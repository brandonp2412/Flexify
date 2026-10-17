/// Creates an actionable report URL without exceeding GitHub URL limits.
Uri buildImportIssueUrl({
  required String kind,
  required Object error,
  required StackTrace stackTrace,
  required String version,
}) {
  String trim(String text, int length) => text.length <= length
      ? text
      : String.fromCharCodes(text.runes.take(length));

  final title = 'Import failed: $kind';
  Uri issue(String body) => Uri.https(
    'github.com',
    '/brandonp2412/Flexify/issues/new',
    {'title': title, 'body': body},
  );

  final description = 'Failed to import $kind.\n\nFlexify version: $version';
  final exception = trim(error.toString(), 200);
  final trace = trim(stackTrace.toString(), 500);
  final detailed = issue('''
$description

Error:
$exception

Stack trace (truncated):
$trace
''');
  if (detailed.toString().length <= 1800) return detailed;

  final short = issue('$description\n\nError: ${trim(exception, 120)}');
  if (short.toString().length <= 1800) return short;
  return issue('Failed to import $kind. Flexify version: ${trim(version, 20)}');
}
