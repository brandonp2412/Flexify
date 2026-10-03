import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Drafter is the only chart package used by Flexify', () {
    final pubspec = File('pubspec.yaml').readAsStringSync();
    const legacyPackages = <String>[
      'fl_chart',
      'syncfusion_flutter_charts',
      'charts_flutter',
      'graphic',
    ];

    expect(pubspec, contains('  drafter:'));

    for (final package in legacyPackages) {
      expect(pubspec, isNot(contains('  $package:')));
    }

    final dartFiles = Directory('lib')
        .listSync(recursive: true)
        .whereType<File>()
        .where((file) => file.path.endsWith('.dart'));

    for (final file in dartFiles) {
      final source = file.readAsStringSync();
      for (final package in legacyPackages) {
        expect(
          source,
          isNot(contains('package:$package/')),
          reason: '${file.path} still imports $package',
        );
      }
    }
  });
}
