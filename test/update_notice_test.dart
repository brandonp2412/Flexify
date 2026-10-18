import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:flexify/update_notice.dart';

void main() {
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
