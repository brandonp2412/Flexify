import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('integration tests never open the persistent database', () {
    final integrationTests = Directory(
      'integration_test',
    ).listSync().whereType<File>().where((file) => file.path.endsWith('.dart'));

    for (final file in integrationTests) {
      expect(
        file.readAsStringSync(),
        isNot(contains('AppDatabase.persistent()')),
        reason: '${file.path} must use an isolated database executor',
      );
    }
  });
}
