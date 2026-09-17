import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

final _directTextPattern = RegExp(
  r'''(?:const\s+)?(?:Text|SelectableText)\(\s*(["'])([A-Za-z][^"'\n]*)\1''',
);
final _literalUiPropertyPattern = RegExp(
  r'''(?:labelText|hintText|helperText|errorText|tooltip|semanticLabel)\s*:\s*(["'])([A-Za-z][^"'\n]*)\1''',
);
final _placeholderPattern = RegExp(r'\{([A-Za-z][A-Za-z0-9_]*)\s*(?:,|\})');

const _allowedLiteralUiText = <String>{
  'lib/about_page.dart:Brandon Presley',
  'lib/about_page.dart:MIT',
};

Map<String, dynamic> _readArb(File file) =>
    jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;

Set<String> _messageKeys(Map<String, dynamic> arb) =>
    arb.keys.where((key) => !key.startsWith('@')).toSet();

Set<String> _messagePlaceholders(String message) => _placeholderPattern
    .allMatches(message)
    .map((match) => match.group(1)!)
    .toSet();

Set<String> _metadataPlaceholders(Map<String, dynamic> source, String key) {
  final metadata = source['@$key'];
  if (metadata is! Map<String, dynamic>) return const {};
  final placeholders = metadata['placeholders'];
  if (placeholders is! Map<String, dynamic>) return const {};
  return placeholders.keys.toSet();
}

void main() {
  final sourceFile = File('lib/l10n/app_en.arb');
  final source = _readArb(sourceFile);
  final sourceKeys = _messageKeys(source);

  test('English ARB metadata declares every message placeholder', () {
    for (final key in sourceKeys) {
      final message = source[key] as String;
      expect(
        _metadataPlaceholders(source, key),
        _messagePlaceholders(message),
        reason: 'Placeholder metadata mismatch for English key "$key".',
      );
    }
  });

  test('translated ARBs match English keys and placeholders', () {
    final localeFiles =
        Directory('lib/l10n')
            .listSync()
            .whereType<File>()
            .where(
              (file) =>
                  file.path.endsWith('.arb') &&
                  !file.path.endsWith('app_en.arb'),
            )
            .toList()
          ..sort((a, b) => a.path.compareTo(b.path));

    for (final file in localeFiles) {
      final translated = _readArb(file);
      expect(
        _messageKeys(translated),
        sourceKeys,
        reason: '${file.path} must contain every active English message key.',
      );

      for (final key in sourceKeys) {
        expect(
          _messagePlaceholders(translated[key] as String),
          _metadataPlaceholders(source, key),
          reason: '${file.path} has different placeholders for "$key".',
        );
      }
    }
  });

  test('Flutter UI avoids obvious hard-coded English literals', () {
    final violations = <String>[];
    final dartFiles = Directory('lib')
        .listSync(recursive: true)
        .whereType<File>()
        .where(
          (file) =>
              file.path.endsWith('.dart') &&
              !file.path.contains('/l10n/generated/'),
        );

    for (final file in dartFiles) {
      final relativePath = file.path.replaceFirst(
        '${Directory.current.path}/',
        '',
      );
      final sourceText = file.readAsStringSync();
      for (final pattern in [_directTextPattern, _literalUiPropertyPattern]) {
        for (final match in pattern.allMatches(sourceText)) {
          final literal = match.group(2)!;
          if (_allowedLiteralUiText.contains('$relativePath:$literal'))
            continue;
          final line =
              '\n'.allMatches(sourceText.substring(0, match.start)).length + 1;
          violations.add('$relativePath:$line: $literal');
        }
      }
    }

    expect(
      violations,
      isEmpty,
      reason:
          'Move user-facing literals into app_en.arb, or document a true non-translatable exception.',
    );
  });
}
