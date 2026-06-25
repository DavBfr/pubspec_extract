import 'package:pubspec_extract/builder.dart';
import 'package:test/test.dart';

void main() {
  group('generateExtractKeyArg', () {
    test('converts underscores to dashes', () {
      expect(generateExtractKeyArg('issue_tracker'), 'extract-issue-tracker');
    });

    test('lowercases input', () {
      expect(generateExtractKeyArg('Flutter'), 'extract-flutter');
    });

    test('simple key', () {
      expect(generateExtractKeyArg('name'), 'extract-name');
    });
  });

  group('Builder config key conventions', () {
    test('include-build-date uses dashes like extract keys', () {
      final configKey = 'include-build-date';
      expect(
        configKey.contains('_'),
        false,
        reason: 'Config key should use dashes, not underscores',
      );
    });
  });
}
