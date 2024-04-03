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
