import 'package:cross_file/cross_file.dart';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flexify/database/database.dart';
import 'package:flexify/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';

/// Lets tests point [FilePicker.pickFiles] at a fixture file on disk
/// without a real OS file-picker dialog.
final class FakePickedFile extends PlatformFile {
  FakePickedFile(this.filePath);

  final String filePath;
  File get _file => File(filePath);

  @override
  String get name => p.basename(filePath);

  @override
  Uri get uri => Uri.file(filePath);

  @override
  XFile get xFile => XFile(filePath);

  @override
  int? lengthSync() => _file.lengthSync();

  @override
  Future<int?> length() => _file.length();

  @override
  Future<Uint8List> readAsBytes() => _file.readAsBytes();

  @override
  Stream<Uint8List> readAsByteStream() =>
      _file.openRead().map(Uint8List.fromList);
}

class FakeFilePickerPlatform extends FilePickerPlatform {
  FakeFilePickerPlatform(this.filePath);

  final String filePath;

  @override
  Future<List<PlatformFile>> pickFiles({
    String? dialogTitle,
    String? initialDirectory,
    FileType type = FileType.any,
    List<String>? allowedExtensions,
    Function(FilePickerStatus)? onFileLoading,
    int compressionQuality = 0,
    AndroidOptions androidOptions = const AndroidOptions(),
    DarwinOptions darwinOptions = const DarwinOptions(),
    WindowsOptions windowsOptions = const WindowsOptions(),
    LinuxOptions linuxOptions = const LinuxOptions(),
    WebOptions webOptions = const WebOptions(),
  }) async => [FakePickedFile(filePath)];
}

/// Supplies isolated documents and application support paths for tests.
class FakePathProviderPlatform extends PathProviderPlatform {
  FakePathProviderPlatform(this.documentsPath, {String? supportPath})
    : supportPath = supportPath ?? documentsPath;

  final String documentsPath;
  final String supportPath;

  @override
  Future<String?> getApplicationDocumentsPath() async => documentsPath;

  @override
  Future<String?> getApplicationSupportPath() async => supportPath;
}

Future<void> mockTests() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  androidChannel = const MethodChannel("com.presley.flexify/timer");
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
}

/// An in-memory [AppDatabase] whose query streams close synchronously when
/// their last listener detaches, so tests don't need to call `db.close()`
/// to avoid Drift's pending-cleanup-timer failing after the test ends.
AppDatabase testDb() {
  return AppDatabase(
    DatabaseConnection(
      NativeDatabase.memory(),
      closeStreamsSynchronously: true,
    ),
  );
}

void mockFilePicker(String filePath) {
  FilePickerPlatform.instance = FakeFilePickerPlatform(filePath);
}

void mockPathProvider(String documentsPath) {
  PathProviderPlatform.instance = FakePathProviderPlatform(documentsPath);
}

Future<void> scroll(WidgetTester tester, FinderBase<Element> finder) {
  return tester.scrollUntilVisible(
    finder,
    400,
    scrollable: find.byType(Scrollable).first,
  );
}
