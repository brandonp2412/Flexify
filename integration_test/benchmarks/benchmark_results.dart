import 'dart:convert';
import 'dart:io';

void recordBenchmark(String name, Map<String, Object> measurements) {
  final file = File('build/benchmarks/$name.json');
  file.parent.createSync(recursive: true);
  file.writeAsStringSync(
    '${const JsonEncoder.withIndent('  ').convert(measurements)}\n',
  );
}
