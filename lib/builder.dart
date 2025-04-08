// Copyright (c) 2020, David PHAM-VAN <dev.nfet.net@gmail.com>
// All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: depend_on_referenced_packages

import 'dart:async';
import 'dart:io';

import 'package:build/build.dart';
import 'package:yaml/yaml.dart';

import 'src/generator.dart';
import 'src/generator_options.dart';

Builder pubspecBuilder(BuilderOptions options) {
  final pubspec = loadYaml(File('pubspec.yaml').readAsStringSync()) as Map;

  var options = GeneratorOptions.def;

  if (pubspec.containsKey('pubspec_extract')) {
    final opt = pubspec['pubspec_extract'] as Map;
    options = options.copyWith(
      className: opt['class_name'],
      mapList: opt['map_list'],
      source: opt['source'],
      destination: opt['destination'],
      format: opt['format'],
      extractName: opt[generateExtractKeyArg(
          GeneratorOptions.kNameGenOptionKey)], //['extract_name'],
      extractDescription: opt[generateExtractKeyArg(GeneratorOptions
          .kDescriptionGenOptionKey)], //opt['extract_description'],
      extractVersion: opt[generateExtractKeyArg(
          GeneratorOptions.kVersionGenOptionKey)], //opt['extract_version'],
      extractTopics: opt[generateExtractKeyArg(
          GeneratorOptions.kTopicsGenOptionKey)], //opt['extract_topics'],
      extractHomepage: opt[generateExtractKeyArg(
          GeneratorOptions.kHomepageGenOptionKey)], //opt['extract_homepage'],
      extractRepo: opt[generateExtractKeyArg(
          GeneratorOptions.kRepoGenOptionKey)], //opt['extract_repository'],
      extractIssueTracker: opt[generateExtractKeyArg(GeneratorOptions
          .kIssueTrackerGenOptionKey)], //opt['extract_issue_tracker'],
      extractDocumentation: opt[generateExtractKeyArg(GeneratorOptions
          .kDocumentationGenOptionKey)], //opt['extract_documentation'],
      extractPublishTo: opt[generateExtractKeyArg(GeneratorOptions
          .kPublishToGenOptionKey)], //opt['extract_publish_to'],
      extractFunding: opt[generateExtractKeyArg(
          GeneratorOptions.kFundingGenOptionKey)], //opt['extract_funding'],
      extractScreenshots: opt[generateExtractKeyArg(GeneratorOptions
          .kScreenshotsGenOptionKey)], //opt['extract_screenshots'],
      extractFalseSecrets: opt[generateExtractKeyArg(GeneratorOptions
          .kFalseSecretsGenOptionKey)], //opt['extract_false_secrets'],
      extractEnvironment: opt[generateExtractKeyArg(GeneratorOptions
          .kEnvironmentGenOptionKey)], //opt['extract_environment'],
      extractDependencies: opt[generateExtractKeyArg(GeneratorOptions
          .kDependenciesGenOptionKey)], //opt['extract_dependencies'],
      extractDependencyOverrides: opt[generateExtractKeyArg(GeneratorOptions
          .kDependencyOverridesGenOptionKey)], //opt['extract_dependency_overrides'],
      extractIgnoredAdvisories: opt[generateExtractKeyArg(GeneratorOptions
          .kIgnoredAdvisoriesGenOptionKey)], //opt['extract_ignored_advisories'],
      extractDevDependencies: opt[generateExtractKeyArg(GeneratorOptions
          .kDevDependenciesGenOptionKey)], //opt['extract_dev_dependencies'],
      extractFlutter: opt[generateExtractKeyArg(
          GeneratorOptions.kFlutterGenOptionKey)], //opt['extract_flutter'],
      extractExecutables: opt[generateExtractKeyArg(GeneratorOptions
          .kExecutablesGenOptionKey)], //opt['extract_executables'],
      extractUndocumentedKeys: opt[generateExtractKeyArg(
          'undocumented_keys')], //opt['extract_other_undocumented_keys']
    );
  }

  return MyBuilder(options);
}

String generateExtractKeyArg(String pubspecKey) {
  return 'extract-${pubspecKey.toLowerCase().replaceAll('_', '-')}';
}

class MyBuilder extends Builder {
  MyBuilder(this.options);

  final GeneratorOptions options;

  @override
  Future<void> build(BuildStep buildStep) async {
    log.info('Loading ${buildStep.inputId.path}');
    final yamlData = await buildStep.readAsString(buildStep.inputId);
    final output = convertPubspec(yamlData, options);
    await buildStep.writeAsString(buildStep.allowedOutputs.first, output);
  }

  @override
  Map<String, List<String>> get buildExtensions => {
        options.source: [options.destination],
      };
}
