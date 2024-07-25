import 'package:drift/drift.dart';
import 'package:flexify/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

mockTests() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  androidChannel = const MethodChannel("com.presley.flexify/timer");
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
}

Future<void> scroll(WidgetTester tester, FinderBase<Element> finder) {
  return tester.scrollUntilVisible(
    finder,
    400,
    scrollable: find.byType(Scrollable).first,
  );
}
