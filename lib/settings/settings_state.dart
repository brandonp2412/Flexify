import 'package:flexify/database/database.dart';
import 'package:flexify/main.dart';

/// Persisted settings are owned by Drift. This alias keeps call sites concise
/// while the provider layer only distributes the latest row from [watchSettings].
typedef SettingsState = Setting;

/// Compatibility accessor for existing `settings.value.foo` call sites.
/// [SettingsState] is the Drift row itself; there is no duplicated mutable state.
extension SettingsStateValue on Setting {
  Setting get value => this;
}

Stream<Setting> watchSettings() =>
    (db.select(db.settings)..limit(1)).watchSingle();
