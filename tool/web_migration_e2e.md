# Browser persistence migration regression

Flexify's web backend used the legacy `DriftWebStorage.indexedDbIfSupported('flexify_db')` SQL.js database. The current backend opens `WasmDatabase` named `flexify` and imports the old database with `initializeDatabase` **only if** the new database does not exist. The original database is not deleted.

To exercise the migration with a real headless Brave/Chromium browser:

```sh
flutter pub get
flutter build web --release -t tool/web_migration_e2e.dart
uv run --with playwright python tool/web_migration_e2e.py
flutter build web --release
```

The test harness seeds both the original IndexedDB blob and the original Latin-1 localStorage format, in fresh browser contexts. It imports a real SQLite fixture (with settings, exercise, and exercise set), validates database integrity and foreign keys, writes a new WASM-only marker, reloads to prove persistence, and checks that the legacy database bytes retain their original SHA-256 hash. The final build command restores the normal production Flutter entry point.

`web/sqlite3.wasm` and `web/drift_worker.dart.js` are paired, prebuilt assets from Drift release **2.35.2**. When upgrading Drift, update both assets together from the matching official release. Web deployments must serve the WASM file with `Content-Type: application/wasm`.
