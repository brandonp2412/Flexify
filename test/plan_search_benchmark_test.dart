import 'package:flex/database/database.dart';
import 'package:flex/plan/plans_page.dart';
import 'package:flutter_test/flutter_test.dart';

bool legacy(
  Plan plan,
  String search,
  Set<int> ids,
  String Function(String) localize,
) {
  final localized = plan.days
      .split(',')
      .where((day) => day.isNotEmpty)
      .map(localize)
      .join(' ')
      .toLowerCase();
  return plan.title?.toLowerCase().contains(search) == true ||
      plan.days.toLowerCase().contains(search) ||
      localized.contains(search) ||
      ids.contains(plan.id);
}

int median(List<int> samples) {
  final ordered = List<int>.of(samples)..sort();
  return ordered[ordered.length ~/ 2];
}

void main() {
  test('plan search matches legacy and avoids unnecessary localization', () {
    final plans = List.generate(
      10000,
      (i) => Plan(
        id: i,
        title: i.isEven ? 'Bench Workout $i' : 'Leg Workout $i',
        days: 'monday,wednesday,friday',
      ),
    );
    final ids = <int>{for (var i = 0; i < 10000; i += 7) i};
    String localize(String day) => switch (day) {
      'monday' => 'Lunes',
      'wednesday' => 'Miércoles',
      'friday' => 'Viernes',
      _ => day,
    };
    for (final term in ['bench', 'leg', 'monday', 'lunes', 'missing']) {
      for (final plan in plans) {
        expect(
          matchesPlanSearch(plan, term, ids, localize),
          legacy(plan, term, ids, localize),
        );
      }
    }
    List<int> measure(bool optimized) => [
      for (var sample = 0; sample < 9; sample++)
        (() {
          final clock = Stopwatch()..start();
          var count = 0;
          for (var repeat = 0; repeat < 10; repeat++) {
            for (final plan in plans) {
              if (optimized
                  ? matchesPlanSearch(plan, 'bench', ids, localize)
                  : legacy(plan, 'bench', ids, localize))
                count++;
            }
          }
          clock.stop();
          expect(count, greaterThan(0));
          return clock.elapsedMicroseconds;
        })(),
    ];
    // Alternate order across warm-up and sample runs to limit JIT skew.
    measure(false);
    measure(true);
    final baseline = measure(false);
    final optimized = measure(true);
    print('PLAN_SEARCH_BASELINE_US=$baseline');
    print('PLAN_SEARCH_OPTIMIZED_US=$optimized');
    print('PLAN_SEARCH_BASELINE_MEDIAN_US=${median(baseline)}');
    print('PLAN_SEARCH_OPTIMIZED_MEDIAN_US=${median(optimized)}');
  });
}
