import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:flexify/update_notice.dart';

void main() {
  test(
    'update notice preference defaults on and persists both states',
    () async {
      final directory = await Directory.systemTemp.createTemp();
      addTearDown(() => directory.delete(recursive: true));
      final storage = File('${directory.path}${Platform.pathSeparator}enabled');

      expect(await updateNoticesEnabled(storage: storage), isTrue);
      await setUpdateNoticesEnabled(false, storage: storage);
      expect(await updateNoticesEnabled(storage: storage), isFalse);
      await setUpdateNoticesEnabled(true, storage: storage);
      expect(await updateNoticesEnabled(storage: storage), isTrue);
    },
  );

  test('notice timestamp persists across launches', () async {
    final directory = await Directory.systemTemp.createTemp();
    addTearDown(() => directory.delete(recursive: true));
    final storage = File('${directory.path}${Platform.pathSeparator}notice');
    final start = DateTime.utc(2026, 10, 1);

    expect(await claimUpdateNotice(storage: storage, at: start), isTrue);
    expect(
      await claimUpdateNotice(
        storage: storage,
        at: start.add(const Duration(days: 13)),
      ),
      isFalse,
    );
    expect(
      await claimUpdateNotice(
        storage: storage,
        at: start.add(const Duration(days: 14)),
      ),
      isTrue,
    );
  });

  test('update notice is shown at most once in fourteen days', () {
    final start = DateTime.utc(2026, 10, 1);

    expect(isUpdateNoticeDue(start, null), isTrue);
    expect(isUpdateNoticeDue(start, start), isFalse);
    expect(
      isUpdateNoticeDue(start.add(const Duration(days: 13, hours: 23)), start),
      isFalse,
    );
    expect(
      isUpdateNoticeDue(start.add(const Duration(days: 14)), start),
      isTrue,
    );
    expect(
      isUpdateNoticeDue(start.subtract(const Duration(days: 1)), start),
      isFalse,
    );
  });
}
