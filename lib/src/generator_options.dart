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

class GeneratorOptions {
  const GeneratorOptions({
    this.className = 'Pubspec',
    this.format = true,
    this.mapList = false,
    this.source = 'pubspec.yaml',
    this.destination = 'lib/pubspec.dart',
    this.extractName = true,
    this.extractDescription = true,
    this.extractVersion = true,
    this.extractTopics = true,
    this.extractHomepage = true,
    this.extractRepo = true,
    this.extractIssueTracker = true,
    this.extractDocumentation = true,
    this.extractPublishTo = true,
    this.extractFunding = true,
    this.extractScreenshots = true,
    this.extractFalseSecrets = true,
    this.extractEnvironment = true,
    this.extractDependencies = true,
    this.extractDependencyOverrides = true,
    this.extractIgnoredAdvisories = true,
    this.extractDevDependencies = true,
    this.extractFlutter = true,
    this.extractExecutables = true,
    this.extractUndocumentedKeys = true,
  });

  /// Pubspec project 'name' key
  static const kNameGenOptionKey = 'name';

  /// Pubspec project 'description' key
  static const kDescriptionGenOptionKey = 'description';

  /// Pubspec project 'version' key
  static const kVersionGenOptionKey = 'version';

  /// Pubspec project 'topics' key
  static const kTopicsGenOptionKey = 'topics';

  /// Pubspec project 'homepage' key
  static const kHomepageGenOptionKey = 'homepage';

  /// Pubspec project 'repository' key
  static const kRepoGenOptionKey = 'repository';

  /// Pubspec project 'issue_tracker' key
  static const kIssueTrackerGenOptionKey = 'issue_tracker';

  /// Pubspec project 'documentation' key
  static const kDocumentationGenOptionKey = 'documentation';

  /// Pubspec project 'publish_to' key
  static const kPublishToGenOptionKey = 'publish_to';

  /// Pubspec project 'funding' key
  static const kFundingGenOptionKey = 'funding';

  /// Pubspec project 'screenshots' key
  static const kScreenshotsGenOptionKey = 'screenshots';

  /// Pubspec project 'false_secrets' key
  static const kFalseSecretsGenOptionKey = 'false_secrets';

  /// Pubspec project 'environment' key
  static const kEnvironmentGenOptionKey = 'environment';

  /// Pubspec project 'dependencies' key
  static const kDependenciesGenOptionKey = 'dependencies';

  /// Pubspec project 'dependency_overrides' key
  static const kDependencyOverridesGenOptionKey = 'dependency_overrides';

  /// Pubspec project 'ignored_advisories' key
  static const kIgnoredAdvisoriesGenOptionKey = 'ignored_advisories';

  /// Pubspec project 'dev_dependencies' key
  static const kDevDependenciesGenOptionKey = 'dev_dependencies';

  /// Pubspec project 'flutter' key
  static const kFlutterGenOptionKey = 'flutter';

  /// Pubspec project 'executables' key
  static const kExecutablesGenOptionKey = 'executables';

  static const def = GeneratorOptions();

  /// The class name to generate
  final String className;

  /// Format the generated dart file
  final bool format;

  /// Add a list of the exported variables
  final bool mapList;

  /// Source directory
  final String source;

  /// Output filename
  final String destination;

  /// Extract pubspec project 'name' flag
  final bool extractName;

  /// Extract pubspec project 'description' flag
  final bool extractDescription;

  /// Extract pubspec project 'version' flag
  final bool extractVersion;

  /// Extract pubspec project 'topics' flag
  final bool extractTopics;

  /// Extract pubspec project 'homepage' flag
  final bool extractHomepage;

  /// Extract pubspec project 'repository' flag
  final bool extractRepo;

  /// Extract pubspec project 'issue_tracker' flag
  final bool extractIssueTracker;

  /// Extract pubspec project 'documentation' flag
  final bool extractDocumentation;

  /// Extract pubspec project 'publish_to' flag
  final bool extractPublishTo;

  /// Extract pubspec project 'funding' flag
  final bool extractFunding;

  /// Extract pubspec project 'screenshots' flag
  final bool extractScreenshots;

  /// Extract pubspec project 'false_secrets' flag
  final bool extractFalseSecrets;

  /// Extract pubspec project 'environment' flag
  final bool extractEnvironment;

  /// Extract pubspec project 'dependencies' flag
  final bool extractDependencies;

  /// Extract pubspec project 'dependency_overrides' flag
  final bool extractDependencyOverrides;

  /// Extract pubspec project 'ignored_advisories' flag
  final bool extractIgnoredAdvisories;

  /// Extract pubspec project 'dev_dependencies' flag
  final bool extractDevDependencies;

  /// Extract pubspec project 'flutter' flag
  final bool extractFlutter;

  /// Extract pubspec project 'executables' flag
  final bool extractExecutables;

  /// Extract non-pubspec related keys flag
  final bool extractUndocumentedKeys;

  /// Documented pubspec top-level key extract flags map. Details at https://dart.dev/tools/pub/pubspec
  Map<String, bool> get extractPubspecKeys {
    final res = {
      kNameGenOptionKey: extractName,
      kDescriptionGenOptionKey: extractDescription,
      kVersionGenOptionKey: extractVersion,
      kTopicsGenOptionKey: extractTopics,
      kHomepageGenOptionKey: extractHomepage,
      kRepoGenOptionKey: extractRepo,
      kIssueTrackerGenOptionKey: extractIssueTracker,
      kDocumentationGenOptionKey: extractDocumentation,
      kPublishToGenOptionKey: extractPublishTo,
      kFundingGenOptionKey: extractFunding,
      kScreenshotsGenOptionKey: extractScreenshots,
      kFalseSecretsGenOptionKey: extractFalseSecrets,
      kEnvironmentGenOptionKey: extractEnvironment,
      kDependenciesGenOptionKey: extractDependencies,
      kDependencyOverridesGenOptionKey: extractDependencyOverrides,
      kIgnoredAdvisoriesGenOptionKey: extractIgnoredAdvisories,
      kDevDependenciesGenOptionKey: extractDevDependencies,
      kFlutterGenOptionKey: extractFlutter,
      kExecutablesGenOptionKey: extractExecutables,
    };
    return res;
  }

  GeneratorOptions copyWith({
    String? className,
    bool? format,
    bool? mapList,
    String? source,
    String? destination,
    bool? extractName,
    bool? extractDescription,
    bool? extractVersion,
    bool? extractTopics,
    bool? extractHomepage,
    bool? extractRepo,
    bool? extractIssueTracker,
    bool? extractDocumentation,
    bool? extractPublishTo,
    bool? extractFunding,
    bool? extractScreenshots,
    bool? extractFalseSecrets,
    bool? extractEnvironment,
    bool? extractDependencies,
    bool? extractDependencyOverrides,
    bool? extractIgnoredAdvisories,
    bool? extractDevDependencies,
    bool? extractFlutter,
    bool? extractExecutables,
    bool? extractUndocumentedKeys,
  }) =>
      GeneratorOptions(
        className: className ?? this.className,
        format: format ?? this.format,
        mapList: mapList ?? this.mapList,
        source: source ?? this.source,
        destination: destination ?? this.destination,
        extractName: extractName ?? this.extractName,
        extractDescription: extractDescription ?? this.extractDescription,
        extractVersion: extractVersion ?? this.extractVersion,
        extractTopics: extractTopics ?? this.extractTopics,
        extractHomepage: extractHomepage ?? this.extractHomepage,
        extractRepo: extractRepo ?? this.extractRepo,
        extractIssueTracker: extractIssueTracker ?? this.extractIssueTracker,
        extractDocumentation: extractDocumentation ?? this.extractDocumentation,
        extractPublishTo: extractPublishTo ?? this.extractPublishTo,
        extractFunding: extractFunding ?? this.extractFunding,
        extractScreenshots: extractScreenshots ?? this.extractScreenshots,
        extractFalseSecrets: extractFalseSecrets ?? this.extractFalseSecrets,
        extractEnvironment: extractEnvironment ?? this.extractEnvironment,
        extractDependencies: extractDependencies ?? this.extractDependencies,
        extractDependencyOverrides:
            extractDependencyOverrides ?? this.extractDependencyOverrides,
        extractIgnoredAdvisories:
            extractIgnoredAdvisories ?? this.extractIgnoredAdvisories,
        extractDevDependencies:
            extractDevDependencies ?? this.extractDevDependencies,
        extractFlutter: extractFlutter ?? this.extractFlutter,
        extractExecutables: extractExecutables ?? this.extractExecutables,
        extractUndocumentedKeys:
            extractUndocumentedKeys ?? this.extractUndocumentedKeys,
      );
}
