import 'dart:io';

import 'package:pubspec_extract/src/generator.dart';
import 'package:pubspec_extract/src/generator_options.dart';
import 'package:test/test.dart';

void main() {
  final pubspecFile = File('test/dummy_pubspec.yaml');
  final pubspecContent = pubspecFile.readAsStringSync();
  final options = GeneratorOptions(
      source: pubspecFile.path,
      extractName: false,
      extractDescription: false,
      extractVersion: false,
      extractTopics: false,
      extractHomepage: false,
      extractRepo: false,
      extractIssueTracker: false,
      extractDocumentation: false,
      extractPublishTo: false,
      extractFunding: false,
      extractScreenshots: false,
      extractFalseSecrets: false,
      extractEnvironment: false,
      extractDependencies: false,
      extractDependencyOverrides: false,
      extractIgnoredAdvisories: false,
      extractDevDependencies: false,
      extractFlutter: false,
      extractExecutables: false,
      extractUndocumentedKeys: false);

  group('Customized extracts tests group', () {
    test('Include one key test', () {
      final testOptions = options.copyWith(extractName: true);
      final result = convertPubspec(pubspecContent, testOptions);
      _testing(testOptions, rawPubspec: pubspecContent, generated: result);
    });

    test('Include many keys test', () {
      final testOptions = options.copyWith(
          extractName: true,
          extractVersion: true,
          extractDescription: true,
          extractUndocumentedKeys: true);
      final result = convertPubspec(pubspecContent, testOptions);
      _testing(testOptions, rawPubspec: pubspecContent, generated: result);
    });

    test("Include all 'extract' keys test", () {
      final testOptions =
          GeneratorOptions.def.copyWith(source: pubspecFile.path);
      final result = convertPubspec(pubspecContent, testOptions);
      _testing(testOptions, rawPubspec: pubspecContent, generated: result);
    });
  });
}

void _testing(GeneratorOptions options,
    {required String rawPubspec, required String generated}) {
  final documentedExtractKeys = options.extractPubspecKeys;
  for (final entry in documentedExtractKeys.entries) {
    if (!rawPubspec.contains(entry.key)) {
      continue;
    }
    expect(generated.contains('${entry.key} = '), entry.value,
        reason: "Generated content key '${entry.key}' contains mismatch");
  }
  expect(generated.contains('undocumented = '), options.extractUndocumentedKeys,
      reason: 'Generated undocumented keys contains mismatch');
}
