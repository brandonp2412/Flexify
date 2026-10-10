import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqlite3/sqlite3.dart';

const databaseFileName = 'flexify.sqlite';
final _pendingMigrations = <String, Future<File>>{};

Future<File> getDatabaseFile() async {
  final support = await getApplicationSupportDirectory();
  final path = p.join(support.path, databaseFileName);
  final pending = _pendingMigrations[path];
  if (pending != null) return pending;

  final migration = _resolveDatabaseFile(support);
  _pendingMigrations[path] = migration;
  try {
    return await migration;
  } finally {
    _pendingMigrations.remove(path);
  }
}

Future<File> _resolveDatabaseFile(Directory support) async {
  await support.create(recursive: true);
  final lock = await File(
    p.join(support.path, '.flexify-storage.lock'),
  ).open(mode: FileMode.append);
  try {
    await lock.lock(FileLock.blockingExclusive);
    return await _resolveLockedDatabaseFile(support);
  } finally {
    await lock.close();
  }
}

Future<File> _resolveLockedDatabaseFile(Directory support) async {
  final destination = File(p.join(support.path, databaseFileName));
  final staged = File('${destination.path}.migrating');
  final marker = File(p.join(support.path, '.flexify-storage-migrated'));

  if (await destination.exists()) {
    if (await staged.exists()) await staged.delete();
    if (!await marker.exists()) await marker.writeAsString('', flush: true);
    return destination;
  }

  if (await marker.exists()) {
    if (await staged.exists()) await staged.rename(destination.path);
    return destination;
  }

  final Directory documents;
  try {
    documents = await getApplicationDocumentsDirectory();
  } on MissingPlatformDirectoryException {
    return destination;
  }
  final legacy = File(p.join(documents.path, databaseFileName));
  if (p.equals(legacy.path, destination.path) || !await legacy.exists()) {
    return destination;
  }

  if (await staged.exists()) await staged.delete();
  final source = sqlite3.open(legacy.path, mode: OpenMode.readOnly);
  try {
    final escapedPath = staged.path.replaceAll("'", "''");
    source.execute("VACUUM INTO '$escapedPath'");
  } finally {
    source.close();
  }

  // The marker commits the snapshot before publication, allowing an interrupted
  // rename to resume without ever resurrecting legacy data after deletion.
  await marker.writeAsString('', flush: true);
  return staged.rename(destination.path);
}
