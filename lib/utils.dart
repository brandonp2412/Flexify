import 'package:intl/intl.dart';

DateTime parseDate(String dateString) {
  List<String> formats = [
    'yyyy-MM-ddTHH:mm',
    'yyyy-MM-ddTHH:mm:ss.SSS',
    'yyyy-MM-ddTHH:mm:ss'
  ];

  for (String format in formats) {
    try {
      return DateFormat(format).parseStrict(dateString.replaceAll('Z', ''));
    } catch (_) {}
  }

  throw FormatException('Invalid date format: $dateString');
}
