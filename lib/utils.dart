import 'dart:convert';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

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
  List<List<dynamic>> csvData = [];

  await file
      .openRead()
      .transform(utf8.decoder)
      .transform(const LineSplitter())
      .skip(1)
      .listen((line) {
    csvData.addAll(const CsvToListConverter().convert(line));
  }).asFuture();

  return csvData;
}

Future<File> writeCsv(List<List<dynamic>> csvData, String fileName) async {
  final result = await FilePicker.platform.getDirectoryPath();
  if (result == null) return Future.value(File(""));

  final permission = await Permission.manageExternalStorage.request();
  if (!permission.isGranted) return Future.value(File(""));
  final file = File("$result/$fileName");
  await file
      .writeAsString(const ListToCsvConverter(eol: "\n").convert(csvData));
  return file;
}
