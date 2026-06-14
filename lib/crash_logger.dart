import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// Persists uncaught errors to a rolling log file so crashes that produce no
/// console output (e.g. on the Windows store build) leave a retrievable trace.
///
/// The log lives next to the database in the application support directory; its
/// location is printed on startup. Call [CrashLogger.install] from within a
/// [runZonedGuarded] body so Flutter, platform and zone errors all funnel here.
class CrashLogger {
  CrashLogger._(this._file);

  final File _file;
  static CrashLogger? _instance;

  /// Wires up [FlutterError.onError] and [PlatformDispatcher.onError] to append
  /// to the crash log, then returns the logger so callers can record their own
  /// non-fatal failures via [record].
  static Future<CrashLogger> install() async {
    final dir = await getApplicationSupportDirectory();
    final file = File(p.join(dir.path, 'crash.log'));
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

    debugPrint('Crash log: ${file.path}');
    return logger;
  }

  /// The active logger once [install] has completed, otherwise null.
  static CrashLogger? get instance => _instance;

  /// Appends a timestamped entry for [error]. Safe to call from anywhere; any
  /// failure to write is swallowed so logging can never itself crash the app.
  void record(Object error, StackTrace? stack, {String context = 'uncaught'}) {
    final entry = StringBuffer()
      ..writeln('[${DateTime.now().toIso8601String()}] ($context) $error');
    if (stack != null) entry.writeln(stack.toString().trimRight());
    entry.writeln();

    debugPrint(entry.toString());
    try {
      _file.writeAsStringSync(entry.toString(), mode: FileMode.append);
    } catch (_) {
      // Logging must never throw; if the file is unwritable, the debugPrint
      // above is the best we can do.
    }
  }
}
