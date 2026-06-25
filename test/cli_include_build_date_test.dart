import 'dart:io';

import 'package:test/test.dart';

void main() {
  group('CLI --include-build-date flag', () {
    late Directory tempDir;

    setUp(() {
      tempDir = Directory.systemTemp.createTempSync('pubspec_extract_cli_');
      File(
        '${tempDir.path}/pubspec.yaml',
      ).writeAsStringSync('name: cli_test\nversion: 1.0.0\n');
      Directory('${tempDir.path}/lib').createSync();
    });

    tearDown(() {
      tempDir.deleteSync(recursive: true);
    });

    test('default generates buildDate', () async {
      final result = await Process.run('dart', [
        'run',
        '${Directory.current.path}/bin/pubspec_extract.dart',
        '-s',
        '${tempDir.path}/pubspec.yaml',
        '-d',
        '${tempDir.path}/lib/pubspec.dart',
      ]);
      expect(result.exitCode, 0, reason: 'stderr: ${result.stderr}');
      final output = File(
        '${tempDir.path}/lib/pubspec.dart',
      ).readAsStringSync();
      expect(output.contains('buildDate'), true);
    });

    test('--include-build-date generates buildDate', () async {
      final result = await Process.run('dart', [
        'run',
        '${Directory.current.path}/bin/pubspec_extract.dart',
        '-s',
        '${tempDir.path}/pubspec.yaml',
        '-d',
        '${tempDir.path}/lib/pubspec.dart',
        '--include-build-date',
      ]);
      expect(result.exitCode, 0, reason: 'stderr: ${result.stderr}');
      final output = File(
        '${tempDir.path}/lib/pubspec.dart',
      ).readAsStringSync();
      expect(output.contains('buildDate'), true);
    });

    test('--no-include-build-date omits buildDate', () async {
      final result = await Process.run('dart', [
        'run',
        '${Directory.current.path}/bin/pubspec_extract.dart',
        '-s',
        '${tempDir.path}/pubspec.yaml',
        '-d',
        '${tempDir.path}/lib/pubspec.dart',
        '--no-include-build-date',
      ]);
      expect(result.exitCode, 0, reason: 'stderr: ${result.stderr}');
      final output = File(
        '${tempDir.path}/lib/pubspec.dart',
      ).readAsStringSync();
      expect(output.contains('buildDate'), false);
    });
  });
}
