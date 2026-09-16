import 'package:flexify/l10n/generated/app_localizations.dart';
import 'package:flutter/widgets.dart';

/// Provides concise access to generated localizations from a widget context.
extension AppLocalizationsContext on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}
