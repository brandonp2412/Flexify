import 'dart:io';

import 'package:drift/drift.dart';
import 'package:flexify/database/database.dart';
import 'package:flexify/main.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

void toast(BuildContext context, String message, [SnackBarAction? action]) {
  final defaultAction = SnackBarAction(label: 'OK', onPressed: () {});

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      action: action ?? defaultAction,
    ),
  );
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

bool isSameDay(DateTime date1, DateTime date2) {
  return date1.year == date2.year &&
      date1.month == date2.month &&
      date1.day == date2.day;
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

bool platformIsDesktop() =>
    Platform.isLinux || Platform.isWindows || Platform.isMacOS;

bool platformIsMobile() => Platform.isAndroid || Platform.isIOS;

Future<bool> requestNotificationPermission() async {
  if (const String.fromEnvironment("FLEXIFY_DEVICE_TYPE").isNotEmpty)
    return true;
  if (platformIsDesktop()) return true;
  final permission = await Permission.notification.request();
  return permission.isGranted;
}

void selectAll(TextEditingController controller) => controller.selection =
    TextSelection(baseOffset: 0, extentOffset: controller.text.length);

String toString(double value) {
  final string = value.toString();
  if (string.endsWith('.0')) return string.substring(0, string.length - 2);
  return string;
}
