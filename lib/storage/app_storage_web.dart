import 'dart:io';

Future<File> getDatabaseFile() async {
  throw UnsupportedError('Web databases do not have a filesystem path');
}
