// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Flexify';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get settingsLanguageDescription =>
      'Choose the language used by Flexify';

  @override
  String get languageSystemDefault => 'System default';

  @override
  String get languageNameEnglish => 'English';

  @override
  String get languageNameSpanish => 'Español';

  @override
  String get languageNameFrench => 'Français';

  @override
  String get languageNameGerman => 'Deutsch';

  @override
  String get languageNameItalian => 'Italiano';

  @override
  String get languageNamePortugueseBrazil => 'Português (Brasil)';

  @override
  String get languageNameDutch => 'Nederlands';

  @override
  String get languageNamePolish => 'Polski';

  @override
  String get languageNameJapanese => '日本語';

  @override
  String get languageNameKorean => '한국어';

  @override
  String get languageNameSimplifiedChinese => '简体中文';

  @override
  String get navHistory => 'History';

  @override
  String get navPlans => 'Plans';

  @override
  String get navGraphs => 'Graphs';

  @override
  String get navTimer => 'Timer';

  @override
  String get navSettings => 'Settings';

  @override
  String get errorLabel => 'Error';

  @override
  String get tabContentError => 'Couldn\'t build tab content.';

  @override
  String get cannotHideAllTabs => 'Can\'t hide everything!';

  @override
  String removeTabQuestion(String tab) {
    return 'Remove $tab tab?';
  }

  @override
  String get restoreTabFromSettings =>
      'You can add it back later from settings.';

  @override
  String removedTab(String tab) {
    return 'Removed $tab';
  }

  @override
  String newVersion(String version) {
    return 'New version $version';
  }

  @override
  String get changes => 'Changes';

  @override
  String get searchHint => 'Search...';

  @override
  String get deleteSelected => 'Delete selected';

  @override
  String get confirmDelete => 'Confirm Delete';

  @override
  String deleteRecordsConfirmation(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Are you sure you want to delete $count records? This action is not reversible.',
      one:
          'Are you sure you want to delete 1 record? This action is not reversible.',
    );
    return '$_temp0';
  }

  @override
  String get actionCancel => 'Cancel';

  @override
  String get actionDelete => 'Delete';

  @override
  String get actionRemove => 'Remove';

  @override
  String get actionEdit => 'Edit';

  @override
  String get actionShare => 'Share';

  @override
  String get clearSelection => 'Clear selection';

  @override
  String get clearSearch => 'Clear search';

  @override
  String get showMenu => 'Show menu';

  @override
  String get selectAll => 'Select all';

  @override
  String get weightLabel => 'Weight';

  @override
  String get filter => 'Filter';

  @override
  String get filters => 'Filters';

  @override
  String get categoryLabel => 'Category';

  @override
  String get repsLabel => 'Reps';

  @override
  String get repsFilter => 'Reps filter';

  @override
  String get weightFilter => 'Weight filter';

  @override
  String get greaterThan => 'Greater than';

  @override
  String get lessThan => 'Less than';

  @override
  String get startDate => 'Start date';

  @override
  String get endDate => 'End date';

  @override
  String get actionClear => 'Clear';

  @override
  String get actionOk => 'OK';

  @override
  String get actionClose => 'Close';

  @override
  String get sortBy => 'Sort by';

  @override
  String get dateNewest => 'Date (newest)';

  @override
  String get dateOldest => 'Date (oldest)';

  @override
  String get nameLabel => 'Name';
}
