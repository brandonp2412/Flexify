import 'dart:io';

int? _cachedColumns;
int _lastProbeMillis = 0;

int? currentTerminalColumns() {
  try {
    if (stdout.hasTerminal) return stdout.terminalColumns;
  } catch (_) {}
  if (!Platform.isLinux) return _environmentColumns();
  final now = DateTime.now().millisecondsSinceEpoch;
  if (now - _lastProbeMillis < 500) return _cachedColumns;
  _lastProbeMillis = now;
  try {
    final result = Process.runSync('stty', const ['-F', '/dev/tty', 'size']);
    if (result.exitCode == 0) {
      final fields = result.stdout.toString().trim().split(' ');
      final columns = fields.length >= 2 ? int.tryParse(fields.last) : null;
      if (columns != null && columns > 0) return _cachedColumns = columns;
    }
  } catch (_) {}
  return _cachedColumns ?? _environmentColumns();
}

int? _environmentColumns() {
  final columns = int.tryParse(Platform.environment['COLUMNS'] ?? '');
  return columns != null && columns > 0 ? columns : null;
}
