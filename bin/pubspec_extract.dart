// Copyright (C) 2019, David PHAM-VAN <dev.nfet.net@gmail.com>
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'dart:io';

import 'package:args/args.dart';
import 'package:logging/logging.dart';
import 'package:path/path.dart' as p;
import 'package:pubspec_extract/builder.dart';
import 'package:pubspec_extract/src/generator.dart';
import 'package:pubspec_extract/src/generator_options.dart';
import 'package:pubspec_extract/src/pubspec.dart';

int main(List<String> arguments) {
  // Parse CLI arguments
  final parser = ArgParser()
    ..addOption(
      'source',
      abbr: 's',
      defaultsTo: GeneratorOptions.def.source,
      help: 'Source yaml file',
    )
    ..addOption(
      'destination',
      abbr: 'd',
      defaultsTo: GeneratorOptions.def.destination,
      help: 'Destination dart file',
    )
    ..addOption(
      'class-name',
      abbr: 'c',
      defaultsTo: GeneratorOptions.def.className,
      help: 'Destination class name',
    )
    ..addFlag(
      'verbose',
      abbr: 'v',
      negatable: false,
      help: 'Verbose output',
    )
    ..addFlag(
      'format',
      abbr: 'f',
      defaultsTo: true,
      negatable: true,
      help: 'Format the dart output',
    )
    ..addFlag(
      'map-list',
      abbr: 'm',
      negatable: false,
      help: 'Add a list of the exported variables',
    )
    ..addFlag(
      generateExtractKeyArg(
          GeneratorOptions.kNameGenOptionKey), //'extract-name',
      defaultsTo: true,
      negatable: true,
      help: "Extract top-level 'name' from pubspec",
    )
    ..addFlag(
      generateExtractKeyArg(
          GeneratorOptions.kDescriptionGenOptionKey), //'extract-description',
      defaultsTo: true,
      negatable: true,
      help: "Extract top-level 'description' from pubspec",
    )
    ..addFlag(
      generateExtractKeyArg(
          GeneratorOptions.kVersionGenOptionKey), //'extract-version',
      defaultsTo: true,
      negatable: true,
      help: "Extract top-level 'version' from pubspec",
    )
    ..addFlag(
      generateExtractKeyArg(
          GeneratorOptions.kTopicsGenOptionKey), //'extract-topics',
      defaultsTo: true,
      negatable: true,
      help: "Extract top-level 'topics' from pubspec",
    )
    ..addFlag(
      generateExtractKeyArg(
          GeneratorOptions.kHomepageGenOptionKey), //'extract-homepage',
      defaultsTo: true,
      negatable: true,
      help: "Extract top-level 'homepage' from pubspec",
    )
    ..addFlag(
      generateExtractKeyArg(
          GeneratorOptions.kRepoGenOptionKey), //'extract-repository',
      defaultsTo: true,
      negatable: true,
      help: "Extract top-level 'repository' from pubspec",
    )
    ..addFlag(
      generateExtractKeyArg(GeneratorOptions
          .kIssueTrackerGenOptionKey), //'extract-issue-tracker',
      defaultsTo: true,
      negatable: true,
      help: "Extract top-level 'issue_tracker' from pubspec",
    )
    ..addFlag(
      generateExtractKeyArg(GeneratorOptions
          .kDocumentationGenOptionKey), //'extract-documentation',
      defaultsTo: true,
      negatable: true,
      help: "Extract top-level 'documentation' from pubspec",
    )
    ..addFlag(
      generateExtractKeyArg(
          GeneratorOptions.kPublishToGenOptionKey), //'extract-publish-to',
      defaultsTo: true,
      negatable: true,
      help: "Extract top-level 'publish_to' from pubspec",
    )
    ..addFlag(
      generateExtractKeyArg(
          GeneratorOptions.kFundingGenOptionKey), //'extract-funding',
      defaultsTo: true,
      negatable: true,
      help: "Extract top-level 'funding' from pubspec",
    )
    ..addFlag(
      generateExtractKeyArg(
          GeneratorOptions.kScreenshotsGenOptionKey), //'extract-screenshots',
      defaultsTo: true,
      negatable: true,
      help: "Extract top-level 'screenshots' from pubspec",
    )
    ..addFlag(
      generateExtractKeyArg(GeneratorOptions
          .kFalseSecretsGenOptionKey), //'extract-false-secrets',
      defaultsTo: true,
      negatable: true,
      help: "Extract top-level 'false_secrets' from pubspec",
    )
    ..addFlag(
      generateExtractKeyArg(
          GeneratorOptions.kEnvironmentGenOptionKey), //'extract-environment',
      defaultsTo: true,
      negatable: true,
      help: "Extract top-level 'environment' from pubspec",
    )
    ..addFlag(
      generateExtractKeyArg(
          GeneratorOptions.kDependenciesGenOptionKey), //'extract-dependencies',
      defaultsTo: true,
      negatable: true,
      help: "Extract top-level 'dependencies' from pubspec",
    )
    ..addFlag(
      generateExtractKeyArg(GeneratorOptions
          .kDependencyOverridesGenOptionKey), //'extract-dependency-overrides',
      defaultsTo: true,
      negatable: true,
      help: "Extract top-level 'dependency_overrides' from pubspec",
    )
    ..addFlag(
      generateExtractKeyArg(GeneratorOptions
          .kIgnoredAdvisoriesGenOptionKey), //'extract-ignored-advisories',
      defaultsTo: true,
      negatable: true,
      help: "Extract top-level 'ignored_advisories' from pubspec",
    )
    ..addFlag(
      generateExtractKeyArg(GeneratorOptions
          .kDevDependenciesGenOptionKey), //'extract-dev-dependencies',
      defaultsTo: true,
      negatable: true,
      help: "Extract top-level 'dev_dependencies' from pubspec",
    )
    ..addFlag(
      generateExtractKeyArg(
          GeneratorOptions.kFlutterGenOptionKey), //'extract-flutter',
      defaultsTo: true,
      negatable: true,
      help: "Extract top-level 'flutter' from pubspec",
    )
    ..addFlag(
      generateExtractKeyArg(
          GeneratorOptions.kExecutablesGenOptionKey), //'extract-executables',
      defaultsTo: true,
      negatable: true,
      help: "Extract top-level 'executables' from pubspec",
    )
    ..addFlag(
      generateExtractKeyArg('undocumented-keys'),
      defaultsTo: true,
      negatable: true,
      help: 'Extract undocumented top-level keys from pubspec',
    )
    ..addFlag(
      'version',
      negatable: false,
      help: 'Print the ${Pubspec.name} version information',
    )
    ..addFlag(
      'help',
      abbr: 'h',
      negatable: false,
      help: 'Shows usage information',
    );

  final argResults = parser.parse(arguments);

  if (argResults['help']) {
    print(Pubspec.description);
    print('');
    print('Usage:   ${Pubspec.name} [options...]');
    print('');
    print('Options:');
    print(parser.usage);
    return 0;
  }

  if (argResults['version']) {
    print('${Pubspec.name} version ${Pubspec.versionFull}');
    return 0;
  }

  final bool verbose = argResults['verbose'];
  final options = GeneratorOptions(
    source: argResults['source'],
    destination: argResults['destination'],
    className: argResults['class-name'],
    mapList: argResults['map-list'],
    format: argResults['format'],
    extractName: argResults[generateExtractKeyArg(
        GeneratorOptions.kNameGenOptionKey)], //['extract_name'],
    extractDescription: argResults[generateExtractKeyArg(GeneratorOptions
        .kDescriptionGenOptionKey)], //argResults['extract_description'],
    extractVersion: argResults[generateExtractKeyArg(GeneratorOptions
        .kVersionGenOptionKey)], //argResults['extract_version'],
    extractTopics: argResults[generateExtractKeyArg(
        GeneratorOptions.kTopicsGenOptionKey)], //argResults['extract_topics'],
    extractHomepage: argResults[generateExtractKeyArg(GeneratorOptions
        .kHomepageGenOptionKey)], //argResults['extract_homepage'],
    extractRepo: argResults[generateExtractKeyArg(GeneratorOptions
        .kRepoGenOptionKey)], //argResults['extract_repository'],
    extractIssueTracker: argResults[generateExtractKeyArg(GeneratorOptions
        .kIssueTrackerGenOptionKey)], //argResults['extract_issue_tracker'],
    extractDocumentation: argResults[generateExtractKeyArg(GeneratorOptions
        .kDocumentationGenOptionKey)], //argResults['extract_documentation'],
    extractPublishTo: argResults[generateExtractKeyArg(GeneratorOptions
        .kPublishToGenOptionKey)], //argResults['extract_publish_to'],
    extractFunding: argResults[generateExtractKeyArg(GeneratorOptions
        .kFundingGenOptionKey)], //argResults['extract_funding'],
    extractScreenshots: argResults[generateExtractKeyArg(GeneratorOptions
        .kScreenshotsGenOptionKey)], //argResults['extract_screenshots'],
    extractFalseSecrets: argResults[generateExtractKeyArg(GeneratorOptions
        .kFalseSecretsGenOptionKey)], //argResults['extract_false_secrets'],
    extractEnvironment: argResults[generateExtractKeyArg(GeneratorOptions
        .kEnvironmentGenOptionKey)], //argResults['extract_environment'],
    extractDependencies: argResults[generateExtractKeyArg(GeneratorOptions
        .kDependenciesGenOptionKey)], //argResults['extract_dependencies'],
    extractDependencyOverrides: argResults[generateExtractKeyArg(GeneratorOptions
        .kDependencyOverridesGenOptionKey)], //argResults['extract_dependency_overrides'],
    extractIgnoredAdvisories: argResults[generateExtractKeyArg(GeneratorOptions
        .kIgnoredAdvisoriesGenOptionKey)], //argResults['extract_ignored_advisories'],
    extractDevDependencies: argResults[generateExtractKeyArg(GeneratorOptions
        .kDevDependenciesGenOptionKey)], //argResults['extract_dev_dependencies'],
    extractFlutter: argResults[generateExtractKeyArg(GeneratorOptions
        .kFlutterGenOptionKey)], //argResults['extract_flutter'],
    extractExecutables: argResults[generateExtractKeyArg(GeneratorOptions
        .kExecutablesGenOptionKey)], //argResults['extract_executables'],
    extractUndocumentedKeys: argResults[generateExtractKeyArg(
        'undocumented_keys')], //argResults['extract_other_undocumented_keys']
  );

  // Initialize logger
  Logger.root.level = verbose ? Level.ALL : Level.SEVERE;
  Logger.root.onRecord.listen((LogRecord rec) {
    print('${rec.level.name}: ${rec.time}: ${rec.message}');
  });
  final log = Logger('main');

  log.info('Checking source file exists');
  final fileSource = File(options.source);
  if (!fileSource.existsSync()) {
    log.severe('File ${options.source} not found');
    return 1;
  }

  log.info('Checking output directory');
  final outputDir = Directory(p.dirname(options.destination));
  if (!outputDir.existsSync()) {
    outputDir.createSync(recursive: true);
  }

  log.info('Converting ${options.source} to ${options.destination}');
  final contents = convertPubspec(fileSource.readAsStringSync(), options);
  File(options.destination).writeAsStringSync(contents);

  return 0;
}
