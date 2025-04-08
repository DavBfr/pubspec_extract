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

import 'package:dart_style/dart_style.dart';
import 'package:pub_semver/pub_semver.dart';
import 'package:yaml/yaml.dart';

import 'generator_options.dart';
import 'generator_utils.dart';

final _match = RegExp(r'^(\d+.\d+).\d+');

/// Converts a yaml content with pubspec.yaml in mind
/// to a dart source file
String convertPubspec(String source, GeneratorOptions options) {
  final dynamic data = loadYaml(source);
  final output = <String>[];
  final entries = <String>[];

  output.add('// This file is generated automatically, do not modify');
  output.add(
    '// ignore_for_file: public_member_api_docs, constant_identifier_names, avoid_classes_with_only_static_members',
  );

  output.add('mixin ${capitalize(options.className)} {');

  final now = DateTime.now().toUtc();
  output.add(
    'static final buildDate = DateTime.utc(${now.year}, ${now.month}, ${now.day}, ${now.hour}, ${now.minute}, ${now.second});',
  );

  final authors = <String>[];

  if (data is Map) {
    final extractKeyOptions = options.extractPubspecKeys;
    for (var v in data.entries) {
      if (extractKeyOptions[v.key] == false) {
        //Further advanced parsing for documented pubspec keys -> move to 'switch-case' below
        continue;
      }
      switch (v.key) {
        case GeneratorOptions.kVersionGenOptionKey:
          if (v.value is! String) {
            throw const FormatException('Invalid version format');
          }

          output.add('static const versionFull = ${outputStr(v.value)};');
          entries.add('versionFull');

          try {
            final ver = Version.parse(v.value);
            final verStr = _match.firstMatch(v.value);

            final version =
                verStr?.group(0) ?? '${ver.major}.${ver.minor}.${ver.patch}';
            output.add('static const version = ${outputStr(version)};');

            final versionSmall =
                verStr?.group(1) ?? '${ver.major}.${ver.minor}';
            output.add(
              'static const versionSmall = ${outputStr(versionSmall)};',
            );

            output.add('static const versionMajor = ${ver.major};');
            output.add('static const versionMinor = ${ver.minor};');
            output.add('static const versionPatch = ${ver.patch};');
            final build = ver.build.isEmpty
                ? 0
                : ver.build.firstWhere(
                    (dynamic v) => v is int,
                    orElse: () => 0,
                  ) as int;
            output.add('static const versionBuild = $build;');

            output.add('static const versionPreRelease = ');
            outputItem(
              ver.preRelease.isEmpty ? '' : ver.preRelease.first,
              output,
            );
            output.add(';');

            output.add('static const versionIsPreRelease = ');
            outputItem(ver.isPreRelease, output);
            output.add(';');

            entries.addAll([
              'version',
              'versionSmall',
              'versionMajor',
              'versionMinor',
              'versionPatch',
              'versionBuild',
              'versionPreRelease',
              'versionIsPreRelease',
            ]);
          } catch (_) {}
          break;
        case 'author':
        case '_author':
        case 'authors':
        case '_authors':
          if (!options.extractUndocumentedKeys) {
            continue;
          }
          if (v.value is String) {
            authors.add(v.value);
            continue;
          }
          v.value.forEach(authors.add);
          break;
        default:
          if (!extractKeyOptions.containsKey(v.key) &&
              !options.extractUndocumentedKeys) {
            continue;
          }
          final key = outputVar(v.key);
          if (v.value is String) {
            output.add('static const $key = ${outputStr(v.value)};');
            entries.add(key);
          } else if (v.value is int) {
            output.add('static const $key = ${v.value};');
            entries.add(key);
          } else if (v.value is double) {
            output.add('static const $key = ${v.value};');
            entries.add(key);
          } else if (v.value is bool) {
            output.add('static const $key = ${v.value};');
            entries.add(key);
          } else if (v.value is List) {
            output.add('static const $key = <dynamic>[');
            outputList(v.value, output);
            output.add('];');
            entries.add(key);
          } else if (v.value is Map) {
            output.add('static const $key = <dynamic,dynamic>{');
            outputMap(v.value, output);
            output.add('};');
            entries.add(key);
          }
      }
    }

    if (authors.isNotEmpty) {
      output.add('static const authors = <String>[');
      outputList(authors, output);
      output.add('];');

      output.add('static const authorsName = <String>[');
      outputList(authorsName(authors).toList(), output);
      output.add('];');

      output.add('static const authorsEmail = <String>[');
      outputList(authorsEmail(authors).toList(), output);
      output.add('];');

      entries.addAll(['authors', 'authorsName', 'authorsEmail']);
    }
  }

  if (options.mapList) {
    output.add(
      'static const ${unCapitalize(options.className)} = <String, dynamic>{',
    );
    entries.sort();
    for (var entry in entries) {
      output.add('${outputStr(entry)}:$entry,');
    }
    output.add('};');
  }

  // End class block
  output.add('}');

  if (options.format) {
    return DartFormatter(
      languageVersion: Version.none,
    ).format(output.join('\n\n')).toString();
  }

  return output.join('\n');
}
