import 'package:flutter_test/flutter_test.dart';
import 'package:flexify/logging.dart';
import 'package:talker_flutter/talker_flutter.dart';

void main() {
  test('Talker border follows the current terminal width', () {
    var terminalColumns = 50;
    final formatter = TerminalResponsiveLoggerFormatter(
      terminalColumnsProvider: () => terminalColumns,
    );
    final settings = TalkerLoggerSettings(
      maxLineWidth: 110,
      enableColors: false,
    );
    final details = LogDetails(
      message: 'hello',
      level: LogLevel.info,
      pen: AnsiPen(),
    );

    final narrow = formatter
        .fmt(details, settings)
        .split(String.fromCharCode(10))
        .first;
    terminalColumns = 90;
    final wide = formatter
        .fmt(details, settings)
        .split(String.fromCharCode(10))
        .first;

    expect(narrow.length, lessThan(50));
    expect(wide.length, lessThan(90));
    expect(wide.length, greaterThan(narrow.length));
  });

  test('Talker keeps its configured width without a terminal', () {
    final formatter = TerminalResponsiveLoggerFormatter(
      terminalColumnsProvider: () => null,
    );
    final settings = TalkerLoggerSettings(
      maxLineWidth: 110,
      enableColors: false,
    );
    final details = LogDetails(
      message: 'hello',
      level: LogLevel.info,
      pen: AnsiPen(),
    );

    final border = formatter
        .fmt(details, settings)
        .split(String.fromCharCode(10))
        .first;
    expect(border.length, 111);
  });
}
