/// Render performance tests using simulated frame counts.
///
/// In Flutter's test environment, each [pump()] call advances a simulated
/// clock by 16ms and processes exactly one frame -- no real GPU involved.
/// Frame counts are therefore hardware-independent: they measure how many
/// rebuild passes the framework needs to settle, not how fast the CPU runs.
///
/// What frame counts tell you:
///   - More frames = more setState/rebuild cycles = less efficient UI
///   - A regression here means a change introduced unnecessary rebuilds
///   - Virtualization can be verified: a 100-item list should need the same
///     frames as a 10-item list because ListView.builder only builds visible items
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flexify/database/database.dart';
import 'package:flexify/main.dart';
import 'package:flexify/plan/plan_state.dart';
import 'package:flexify/sets/history_page.dart';
import 'package:flexify/settings/settings_state.dart';
import 'package:flexify/timer/timer_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'mock_tab_controller.dart';
import 'mock_tests.dart';

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

/// Pumps frames one at a time until nothing is scheduled, returning the count.
/// Each pump() is one simulated 16ms tick -- completely hardware-independent.
Future<int> countFramesToSettle(WidgetTester tester) async {
  int frames = 0;
  while (tester.binding.hasScheduledFrame) {
    await tester.pump(const Duration(milliseconds: 16));
    frames++;
    if (frames > 500) {
      throw Exception('Widget did not settle after 500 frames (~8s simulated)');
    }
  }
  return frames;
}

Widget historyApp(Setting settings) {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => SettingsState(settings)),
      ChangeNotifierProvider(create: (_) => TimerState()),
      ChangeNotifierProvider(create: (_) => PlanState()),
    ],
    child: MaterialApp(
      home: HistoryPage(tabController: MockTabController()),
    ),
  );
}

GymSetsCompanion makeSet(String name, {int minutesAgo = 0}) =>
    GymSetsCompanion.insert(
      name: name,
      reps: 5,
      weight: 100,
      unit: 'kg',
      created: DateTime.now().subtract(Duration(minutes: minutesAgo)),
    );

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  setUp(() async {
    await mockTests();
    db = AppDatabase(NativeDatabase.memory());
  });

  // db is closed inside each test so Drift's stream cleanup timer fires while
  // the widget tree is still alive and can be pumped. tearDown is a safety net.
  tearDown(() async {
    try {
      await db.close();
    } catch (_) {}
  });

  Future<Setting> settings() => (db.settings.select()..limit(1)).getSingle();

  // Call at the end of each test: closes DB then pumps one frame so Drift's
  // zero-duration cleanup timer fires before the framework checks for pending timers.
  Future<void> closeDb(WidgetTester tester) async {
    await db.close();
    await tester.pump();
  }

  // --- Virtualization -------------------------------------------------
  // Both tests share the same frame threshold. If the 100-item test ever needs
  // significantly more frames than the 10-item test, ListView.builder is
  // building off-screen items instead of virtualizing.

  testWidgets(
    'HistoryPage with 10 items settles within 20 frames',
    (tester) async {
      await db.gymSets.insertAll(
        List.generate(10, (i) => makeSet('Bench press', minutesAgo: i)),
      );
      await tester.pumpWidget(historyApp(await settings()));
      final frames = await countFramesToSettle(tester);

      print('[perf] 10-item list initial render: $frames frames');
      expect(frames, lessThan(20), reason: '10-item list took $frames frames');
      await closeDb(tester);
    },
  );

  testWidgets(
    'HistoryPage with 100 items settles within 20 frames (same as 10 -- virtualized)',
    (tester) async {
      await db.gymSets.insertAll(
        List.generate(100, (i) => makeSet('Bench press', minutesAgo: i)),
      );
      await tester.pumpWidget(historyApp(await settings()));
      final frames = await countFramesToSettle(tester);

      print('[perf] 100-item list initial render: $frames frames');
      expect(frames, lessThan(20),
          reason: '100-item list took $frames frames -- '
              'if much higher than the 10-item test, '
              'ListView.builder is building off-screen items');
      await closeDb(tester);
    },
  );

  // --- Stream update --------------------------------------------------

  testWidgets(
    'inserting a new set settles in few frames (StreamBuilder + HistoryList rebuild)',
    (tester) async {
      await tester.pumpWidget(historyApp(await settings()));
      await tester.pumpAndSettle();

      // Triggers: DB stream emit -> StreamBuilder rebuild -> HistoryList.didUpdateWidget -> setState
      await db.gymSets.insertOne(makeSet('Squat'));
      final frames = await countFramesToSettle(tester);

      // Expect ~2: one for StreamBuilder, one for HistoryList's setState in didUpdateWidget
      print('[perf] Insert record → UI settle: $frames frames');
      expect(
        frames,
        lessThan(6),
        reason: 'Stream update took $frames frames -- '
            'expected ~2 (StreamBuilder + HistoryList setState)',
      );
      await closeDb(tester);
    },
  );

  testWidgets(
    'deleting a set settles in few frames',
    (tester) async {
      final id = await db.gymSets.insertOne(makeSet('Romanian DL'));
      await tester.pumpWidget(historyApp(await settings()));
      await tester.pumpAndSettle();

      await (db.gymSets.deleteWhere((t) => t.id.equals(id)));
      final frames = await countFramesToSettle(tester);

      print('[perf] Delete record → UI settle: $frames frames');
      expect(frames, lessThan(6), reason: 'Delete settled in $frames frames');
      await closeDb(tester);
    },
  );

  // --- Selection animation --------------------------------------------

  testWidgets(
    'entering selection mode settles within 50 frames',
    (tester) async {
      await db.gymSets.insertOne(makeSet('Deadlift'));
      await tester.pumpWidget(historyApp(await settings()));
      await tester.pumpAndSettle();

      // longPress recognition takes kLongPressTimeout (500ms = ~31 frames at 16ms),
      // then AnimatedSwitcher animates the leading icon (150ms = ~10 frames).
      // Total expected: ~41 frames. Threshold is 50 to allow a small buffer.
      await tester.longPress(find.text('5 x 100 kg'));
      final frames = await countFramesToSettle(tester);

      print('[perf] Enter selection mode: $frames frames (~31 longpress + ~10 AnimatedSwitcher)');
      expect(
        frames,
        lessThan(50),
        reason: 'Entering selection mode took $frames frames',
      );
      await closeDb(tester);
    },
  );

  testWidgets(
    'exiting selection mode settles within 50 frames',
    (tester) async {
      await db.gymSets.insertOne(makeSet('OHP'));
      await tester.pumpWidget(historyApp(await settings()));
      await tester.pumpAndSettle();

      await tester.longPress(find.text('5 x 100 kg'));
      await tester.pumpAndSettle();

      // Tap to deselect -- AnimatedSwitcher plays in reverse (150ms = ~10 frames)
      await tester.tap(find.text('5 x 100 kg'));
      final frames = await countFramesToSettle(tester);

      print('[perf] Exit selection mode: $frames frames (~10 AnimatedSwitcher in reverse)');
      expect(frames, lessThan(50),
          reason: 'Exiting selection mode took $frames frames');
      await closeDb(tester);
    },
  );
}
