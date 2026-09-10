import 'package:sqlite3/sqlite3.dart';

abstract interface class BackupDatabase {
  void execute(String sql, [List<Object?> parameters = const []]);

  ResultSet select(String sql, [List<Object?> parameters = const []]);

  void close();
}

BackupDatabase openBackupDatabase(String path) =>
    _NativeBackupDatabase(sqlite3.open(path));

final class _NativeBackupDatabase implements BackupDatabase {
  _NativeBackupDatabase(this._database);

  final Database _database;

  @override
  void execute(String sql, [List<Object?> parameters = const []]) =>
      _database.execute(sql, parameters);

  @override
  ResultSet select(String sql, [List<Object?> parameters = const []]) =>
      _database.select(sql, parameters);

  @override
  void close() => _database.close();
}
