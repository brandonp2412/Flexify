import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flexify/database/database.dart';
import 'package:flexify/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';

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

Future<void> scroll(WidgetTester tester, FinderBase<Element> finder) {
  return tester.scrollUntilVisible(
    finder,
    400,
    scrollable: find.byType(Scrollable).first,
  );
}
