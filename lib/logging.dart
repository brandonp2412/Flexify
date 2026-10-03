import 'dart:developer' show log;

import 'package:flutter/foundation.dart';
import 'package:talker_flutter/talker_flutter.dart';

import 'terminal_columns_stub.dart'
    if (dart.library.io) 'terminal_columns_io.dart';

typedef TerminalColumnsProvider = int? Function();

class TerminalResponsiveLoggerFormatter implements LoggerFormatter {
  const TerminalResponsiveLoggerFormatter({this.terminalColumnsProvider});

  final TerminalColumnsProvider? terminalColumnsProvider;

  @override
  String fmt(LogDetails details, TalkerLoggerSettings settings) {
    final terminalColumns =
        (terminalColumnsProvider ?? currentTerminalColumns)();
    final maxLineWidth = terminalColumns != null && terminalColumns > 2
        ? (terminalColumns - 2).clamp(1, settings.maxLineWidth).toInt()
        : settings.maxLineWidth;

    return const ExtendedLoggerFormatter().fmt(
      details,
      settings.copyWith(maxLineWidth: maxLineWidth),
    );
  }
}

final talker = TalkerFlutter.init(
  logger: TalkerLogger(
    formatter: const TerminalResponsiveLoggerFormatter(),
    output: _talkerOutput,
  ),
);

void _talkerOutput(String message) {
  if (kIsWeb) {
    // ignore: avoid_print
    print(message);
    return;
  }

  switch (defaultTargetPlatform) {
    case TargetPlatform.iOS:
    case TargetPlatform.macOS:
      log(message, name: 'Talker');
      break;
    default:
      debugPrint(message);
  }
}
