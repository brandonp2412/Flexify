import 'package:csv/csv.dart';
import 'package:drift/drift.dart';
import 'package:flexify/database.dart';
import 'package:flexify/main.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

Future<String> getGymSetCsv() async {
  final gymSets = await db.gymSets.select().get();
  final List<List<dynamic>> csvData = [
    [
      'id',
      'name',
      'reps',
      'weight',
      'created',
      'unit',
      'bodyWeight',
      'duration',
      'distance',
      'cardio',
      'hidden',
    ]
  ];
  for (var gymSet in gymSets) {
    csvData.add([
      gymSet.id,
      gymSet.name,
      gymSet.reps,
      gymSet.weight,
      gymSet.created.toIso8601String(),
      gymSet.unit,
      gymSet.bodyWeight,
      gymSet.duration,
      gymSet.distance,
      gymSet.cardio,
      gymSet.hidden
    ]);
  }
  return const ListToCsvConverter(eol: "\n").convert(csvData);
}

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

Future<bool> requestNotificationPermission() async {
  if (const String.fromEnvironment("FLEXIFY_DEVICE_TYPE").isNotEmpty)
    return true;
  final permission = await Permission.notification.request();
  return permission.isGranted;
}

bool isSameDay(DateTime date1, DateTime date2) {
  return date1.year == date2.year &&
      date1.month == date2.month &&
      date1.day == date2.day;
}

Future<GymSet?> getBodyWeight() async {
  final weightSet = await (db.gymSets.select()
        ..where((tbl) => tbl.name.equals('Weight'))
        ..orderBy(
          [(u) => OrderingTerm(expression: u.created, mode: OrderingMode.desc)],
        )
        ..limit(1))
      .getSingleOrNull();
  return weightSet;
}
