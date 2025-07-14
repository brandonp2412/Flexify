import 'package:drift/drift.dart';
import 'package:flexify/database/database.dart';
import 'package:flexify/main.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

void toast(BuildContext context, String message, [SnackBarAction? action]) {
  final def = SnackBarAction(label: 'OK', onPressed: () {});

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      action: action ?? def,
    ),
  );
}

Future<GymSet?> getBodyWeight() async {
  final set = await (db.gymSets.select()
        ..where((tbl) => tbl.name.equals('Weight'))
        ..orderBy(
          [(u) => OrderingTerm(expression: u.created, mode: OrderingMode.desc)],
        )
        ..limit(1))
      .getSingleOrNull();
  return set;
}

bool isSameDay(DateTime date1, DateTime date2) {
  return date1.year == date2.year &&
      date1.month == date2.month &&
      date1.day == date2.day;
}

DateTime parseDate(String dateString) {
  List<String> fmts = [
    'dd.MM.yyyy',
    'yyyy-MM-ddTHH:mm',
    'yyyy-MM-ddTHH:mm:ss.SSS',
    'yyyy-MM-ddTHH:mm:ss',
  ];

  for (String fmt in fmts) {
    try {
      return DateFormat(fmt).parse(dateString.replaceAll('Z', ''));
    } catch (_) {}
  }

  throw FormatException('Invalid date format: $dateString');
}

Future<bool> requestNotificationPermission() async {
  if (const String.fromEnvironment("FLEXIFY_DEVICE_TYPE").isNotEmpty)
    return true;
  if (!kIsWeb) {
    final permission = await Permission.notification.request();
    return permission.isGranted;
  }
  return true;
}

void selectAll(TextEditingController controller) => controller.selection =
    TextSelection(baseOffset: 0, extentOffset: controller.text.length);

String toString(double value) {
  final str = value.toStringAsFixed(2);
  if (str.endsWith('.0')) return str.substring(0, str.length - 2);
  if (str.endsWith('.00')) return str.substring(0, str.length - 3);
  return str;
}
