import 'dart:async';

import 'package:drift/drift.dart';
import 'package:flex/logging.dart';
import 'package:talker_flutter/talker_flutter.dart';

Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  talker.configure(
    filter: TalkerFilter(disabledKeys: [TalkerKey.debug, TalkerKey.info]),
  );
  await testMain();
}
