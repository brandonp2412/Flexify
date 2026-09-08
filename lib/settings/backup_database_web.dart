abstract interface class BackupDatabase {
  void execute(String sql, [List<Object?> parameters = const []]);

  List<Map<String, Object?>> select(
    String sql, [
    List<Object?> parameters = const [],
  ]);

  void close();
}

BackupDatabase openBackupDatabase(String path) =>
    throw UnsupportedError('Database backups are not supported on the web.');
