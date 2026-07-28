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
class FakeFilePickerPlatform extends FilePickerPlatform {
  FakeFilePickerPlatform(this.filePath);

  final String filePath;

  @override
  Future<FilePickerResult?> pickFiles({
    String? dialogTitle,
    String? initialDirectory,
    FileType type = FileType.any,
    List<String>? allowedExtensions,
    Function(FilePickerStatus)? onFileLoading,
    int compressionQuality = 0,
    bool allowMultiple = false,
    bool withData = false,
    bool withReadStream = false,
    bool lockParentWindow = false,
    bool readSequential = false,
    bool cancelUploadOnWindowBlur = true,
    AndroidSAFOptions? androidSafOptions,
  }) async {
    final file = File(filePath);
    return FilePickerResult([
      PlatformFile(
        path: filePath,
        name: p.basename(filePath),
        size: file.lengthSync(),
      ),
    ]);
  }
}

/// Lets tests control the documents directory used by
/// `getApplicationDocumentsDirectory()` without touching the real filesystem
/// paths a device would use.
class FakePathProviderPlatform extends PathProviderPlatform {
  FakePathProviderPlatform(this.documentsPath);

  final String documentsPath;

  @override
  Future<String?> getApplicationDocumentsPath() async => documentsPath;
}

Future<void> mockTests() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  androidChannel = const MethodChannel("com.presley.flexify/timer");
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
}

/// An in-memory [AppDatabase] whose query streams close synchronously, so
/// widget tests don't hang or leak timers waiting on the default one-event-loop
/// close delay.
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
