import 'package:drift/drift.dart';
import 'package:flexify/database/database.dart';
import 'package:flexify/main.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timeago/timeago.dart' as timeago;

void toast(String message, {SnackBarAction? action, Duration? duration}) {
  rootScaffoldMessenger.currentState!.showSnackBar(
    SnackBar(
      content: Text(message),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      action: action,
      duration: duration ?? const Duration(seconds: 4),
      persist: false,
    ),
  );
}

Future<GymSet?> getBodyWeight() async {
  final gymSet =
      await (db.gymSets.select()
            ..where((tbl) => tbl.name.equals('Weight'))
            ..orderBy([
              (u) =>
                  OrderingTerm(expression: u.created, mode: OrderingMode.desc),
            ])
            ..limit(1))
          .getSingleOrNull();
  return gymSet;
}

bool isSameDay(DateTime date1, DateTime date2) {
  return date1.year == date2.year &&
      date1.month == date2.month &&
      date1.day == date2.day;
}

String formatDisplayDate(
  BuildContext context,
  DateTime value,
  String pattern,
) => DateFormat(
  pattern,
  Localizations.localeOf(context).toLanguageTag(),
).format(value);

String formatDisplayNumber(
  BuildContext context,
  num value, {
  int minimumFractionDigits = 0,
  int maximumFractionDigits = 2,
}) {
  final formatter =
      NumberFormat.decimalPattern(
          Localizations.localeOf(context).toLanguageTag(),
        )
        ..minimumFractionDigits = minimumFractionDigits
        ..maximumFractionDigits = maximumFractionDigits;
  return formatter.format(value);
}

String formatDisplayPercent(
  BuildContext context,
  num ratio, {
  int maximumFractionDigits = 2,
}) {
  final formatter = NumberFormat.percentPattern(
    Localizations.localeOf(context).toLanguageTag(),
  )..maximumFractionDigits = maximumFractionDigits;
  return formatter.format(ratio);
}

bool _relativeTimeLocalesRegistered = false;

void _registerRelativeTimeLocales() {
  if (_relativeTimeLocalesRegistered) return;
  _relativeTimeLocalesRegistered = true;
  timeago.setLocaleMessages('de', timeago.DeMessages());
  timeago.setLocaleMessages('fr', timeago.FrMessages());
  timeago.setLocaleMessages('it', timeago.ItMessages());
  timeago.setLocaleMessages('ja', timeago.JaMessages());
  timeago.setLocaleMessages('ko', timeago.KoMessages());
  timeago.setLocaleMessages('nl', timeago.NlMessages());
  timeago.setLocaleMessages('pl', timeago.PlMessages());
  timeago.setLocaleMessages('pt_BR', timeago.PtBrMessages());
  timeago.setLocaleMessages('zh_CN', timeago.ZhCnMessages());
}

String formatRelativeTime(BuildContext context, DateTime value) {
  _registerRelativeTimeLocales();
  final locale = Localizations.localeOf(context);
  final localeName = switch ((locale.languageCode, locale.countryCode)) {
    ('pt', 'BR') => 'pt_BR',
    ('zh', 'CN') => 'zh_CN',
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
