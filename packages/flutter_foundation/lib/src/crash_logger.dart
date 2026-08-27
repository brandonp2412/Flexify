import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// Persists uncaught Flutter, platform and zone errors to a local log file.
class CrashLogger {
  CrashLogger._(this._file);

  final File? _file;
  static CrashLogger? _instance;

  /// Installs global Flutter and platform error handlers.
  ///
  /// Native apps append to [fileName] in the application-support directory.
  /// Web builds continue to emit errors through [debugPrint] only.
  static Future<CrashLogger> install({String fileName = 'crash.log'}) async {
    File? file;
    if (!kIsWeb) {
      final dir = await getApplicationSupportDirectory();
      file = File(p.join(dir.path, fileName));
    }

    final logger = CrashLogger._(file);
    _instance = logger;

    final previousFlutterOnError = FlutterError.onError;
    FlutterError.onError = (details) {
      logger.record(details.exception, details.stack, context: 'FlutterError');
      previousFlutterOnError?.call(details);
    };

    PlatformDispatcher.instance.onError = (error, stack) {
      logger.record(error, stack, context: 'PlatformDispatcher');
      return true;
    };

    if (file != null) debugPrint('Crash log: ${file.path}');
    return logger;
  }

  /// The active logger after [install] has completed.
  static CrashLogger? get instance => _instance;

  /// Records an error without allowing logging failures to crash the app.
  void record(Object error, StackTrace? stack, {String context = 'uncaught'}) {
    final entry = StringBuffer()
      ..writeln('[${DateTime.now().toIso8601String()}] ($context) $error');
    if (stack != null) entry.writeln(stack.toString().trimRight());
    entry.writeln();

    debugPrint(entry.toString());
    final file = _file;
    if (file == null) return;

    try {
      file.writeAsStringSync(entry.toString(), mode: FileMode.append);
    } catch (_) {
      // Logging is deliberately best-effort.
    }
  }
}
