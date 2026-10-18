import 'package:drift/drift.dart';
import 'package:flexify/database/database.dart';
import 'package:flexify/main.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timeago/timeago.dart' as timeago;

final _dateFormat = <(String, String), DateFormat>{};
final _numberFormat = <(String, int, int), NumberFormat>{};
final _editableFormat = <String, NumberFormat>{};
final _parseFormat = <String, NumberFormat>{};
final _percentFormat = <(String, int), NumberFormat>{};

String _localeName(BuildContext context) =>
    Localizations.localeOf(context).toLanguageTag();

String formatDisplayDate(BuildContext context, DateTime value, String pattern) {
  final locale = _localeName(context);
  final formatter = _dateFormat.putIfAbsent((
    locale,
    pattern,
  ), () => DateFormat(pattern, locale));
  return formatter.format(value);
}

String formatDisplayNumber(
  BuildContext context,
  num value, {
  int minDigits = 0,
  int maxDigits = 2,
}) {
  final locale = _localeName(context);
  final formatter = _numberFormat.putIfAbsent(
    (locale, minDigits, maxDigits),
    () => NumberFormat.decimalPattern(locale)
      ..minimumFractionDigits = minDigits
      ..maximumFractionDigits = maxDigits,
  );
  return formatter.format(value);
}

String formatEditableNumber(BuildContext context, num value) {
  final locale = _localeName(context);
  return _editableFormat
      .putIfAbsent(locale, () => NumberFormat('0.##', locale))
      .format(value);
}

double? parseDisplayNumber(BuildContext context, String value) {
  final input = value.trim();
  if (input.isEmpty) return null;

  final parsed = double.tryParse(input);
  if (parsed != null) return parsed;

  try {
    final locale = _localeName(context);
    return _parseFormat
        .putIfAbsent(locale, () => NumberFormat.decimalPattern(locale))
        .parse(input)
        .toDouble();
  } on FormatException {
    return null;
  }
}

String formatDisplayPercent(
  BuildContext context,
  num ratio, {
  int maxDigits = 2,
}) {
  final locale = _localeName(context);
  final formatter = _percentFormat.putIfAbsent((
    locale,
    maxDigits,
  ), () => NumberFormat.percentPattern(locale)..maximumFractionDigits = maxDigits);
  return formatter.format(ratio);
}

bool _timeLocalesReady = false;

void _registerRelativeTimeLocales() {
  if (_timeLocalesReady) return;
  _timeLocalesReady = true;
  timeago.setLocaleMessages('de', timeago.DeMessages());
  timeago.setLocaleMessages('fr', timeago.FrMessages());
  timeago.setLocaleMessages('it', timeago.ItMessages());
  timeago.setLocaleMessages('ja', timeago.JaMessages());
  timeago.setLocaleMessages('ko', timeago.KoMessages());
  timeago.setLocaleMessages('nl', timeago.NlMessages());
  timeago.setLocaleMessages('pl', timeago.PlMessages());
  timeago.setLocaleMessages('ru', timeago.RuMessages());
  final portuguese = timeago.PtBrMessages();
  timeago.setLocaleMessages('pt', portuguese);
  timeago.setLocaleMessages('pt_BR', portuguese);
  final zhMessages = timeago.ZhCnMessages();
  timeago.setLocaleMessages('zh', zhMessages);
  timeago.setLocaleMessages('zh_CN', zhMessages);
  timeago.setLocaleMessages('zh_TW', timeago.ZhMessages());
}

String formatRelativeTime(BuildContext context, DateTime value) {
  _registerRelativeTimeLocales();
  final locale = Localizations.localeOf(context);
  final localeName = switch ((locale.languageCode, locale.countryCode)) {
    ('pt', 'BR') => 'pt_BR',
    ('zh', 'CN') => 'zh_CN',
    ('zh', 'TW') => 'zh_TW',
    _ => locale.languageCode,
  };
  return timeago.format(value, locale: localeName);
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
  if (kIsWeb ||
      defaultTargetPlatform == TargetPlatform.linux ||
      defaultTargetPlatform == TargetPlatform.macOS) {
    return true;
  }

  final settings = await (db.settings.select()..limit(1)).getSingle();
  if (!settings.notifications || settings.notificationPermissionRequested)
    return Permission.notification.isGranted;

  // Record the attempt before showing the system dialog so repeated saves,
  // including concurrent ones, cannot repeatedly ask after a denial.
  await db.settings.update().write(
    const SettingsCompanion(notificationPermissionRequested: Value(true)),
  );
  final permission = await Permission.notification.request();
  return permission.isGranted;
}

void selectAll(TextEditingController controller) => controller.selection =
    TextSelection(baseOffset: 0, extentOffset: controller.text.length);

/// Returns the weight increment step based on exercise name and unit.
/// - Dumbbell exercises: 2 kg / 5 lb
/// - Cable/machine exercises (weight stacks): 5 kg / 10 lb
/// - Barbell/default: 2.5 kg / 5 lb
double weightStep(String name, String unit) {
  final lower = name.toLowerCase();
  final isLb = unit == 'lb' || unit == 'stone';

  if (lower.contains('dumbbell') ||
      lower.startsWith('db ') ||
      lower.contains(' db ') ||
      lower.endsWith(' db')) {
    return isLb ? 5.0 : 2.0;
  }

  if (lower.contains('cable') ||
      lower.contains('machine') ||
      lower.contains('pulldown') ||
      lower.contains('pull-down') ||
      lower.contains('pull down') ||
      lower.contains('leg extension') ||
      lower.contains('leg curl') ||
      lower.contains('chest fly') ||
      lower.contains('pec deck') ||
      lower.contains('seated row') ||
      lower.contains('hack squat') ||
      lower.contains('smith')) {
    return isLb ? 10.0 : 5.0;
  }

  if (lower.contains('leg press') || lower.contains('calf raise')) {
    return isLb ? 20.0 : 10.0;
  }

  return isLb ? 5.0 : 2.5;
}

String toString(double value) {
  final str = value.toStringAsFixed(2);
  if (str.endsWith('.00')) return str.substring(0, str.length - 3);
  if (str.endsWith('0')) return str.substring(0, str.length - 1);
  return str;
}
