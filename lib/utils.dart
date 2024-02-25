import 'dart:convert';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';

DateTime parseDate(String dateString) {
  List<String> formats = [
    'dd.MM.yyyy',
    'yyyy-MM-ddTHH:mm',
    'yyyy-MM-ddTHH:mm:ss.SSS',
    'yyyy-MM-ddTHH:mm:ss',
  ];

  for (String format in formats) {
    try {
      return DateFormat(format).parse(dateString.replaceAll('Z', ''));
    } catch (_) {}
  }

  throw FormatException('Invalid date format: $dateString');
}

Future<List<List<dynamic>>> readCsv() async {
  final result = await FilePicker.platform.pickFiles(
    type: FileType.any,
  );
  if (result == null) return Future.value(<List<dynamic>>[]);

  final file = File(result.files.single.path!);
  final input = file.openRead();

  final firstLine = await input
      .transform(utf8.decoder)
      .transform(const LineSplitter())
      .take(1)
      .single;

  final eol = firstLine.endsWith('\r') ? '\r\n' : '\n';

  final input2 = file.openRead();
  return input2
      .transform(utf8.decoder)
      .transform(CsvToListConverter(eol: eol))
      .skip(1)
      .toList();
}
