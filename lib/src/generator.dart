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

final _match = RegExp(r'^(\d+.\d+).\d+');

/// Converts a yaml content with pubspec.yaml in mind
/// to a dart source file
String convertPubspec(
  String source, {
  String className = 'Pubspec',
  bool format = true,
  bool outputMap = false,
}) {
  final dynamic data = loadYaml(source);
  final output = <String>[];
  final entries = <String>[];

  output.add('// This file is generated automatically, do not modify');
  output.add(
      '// ignore_for_file: public_member_api_docs, constant_identifier_names, avoid_classes_with_only_static_members');

  output.add('class ${_capitalize(className)} {');

  final now = DateTime.now().toUtc();
  output.add(
      'static final buildDate = DateTime.utc(${now.year}, ${now.month}, ${now.day}, ${now.hour}, ${now.minute}, ${now.second});');

  final authors = <String>[];

  if (data is Map) {
    for (var v in data.entries) {
      switch (v.key) {
        case 'version':
          output.add('static const versionFull = ${_outputStr(v.value)};');
          entries.add('versionFull');

          try {
            final ver = Version.parse(v.value);
            final verStr = _match.firstMatch(v.value);

            final version =
                verStr?.group(0) ?? '${ver.major}.${ver.minor}.${ver.patch}';
            output.add('static const version = ${_outputStr(version)};');

            final versionSmall =
                verStr?.group(1) ?? '${ver.major}.${ver.minor}';
            output.add(
                'static const versionSmall = ${_outputStr(versionSmall)};');

            output.add('static const versionMajor = ${ver.major};');
            output.add('static const versionMinor = ${ver.minor};');
            output.add('static const versionPatch = ${ver.patch};');
            final int build = ver.build.isEmpty
                ? 0
                : ver.build.firstWhere((dynamic v) => v is int) ?? 0;
            output.add('static const versionBuild = $build;');

            output.add('static const versionPreRelease = ');
            _outputItem(
                ver.preRelease.isEmpty ? '' : ver.preRelease.first, output);
            output.add(';');

            output.add('static const versionIsPreRelease = ');
            _outputItem(ver.isPreRelease, output);
            output.add(';');

            entries.addAll([
              'version',
              'versionSmall',
              'versionMajor',
              'versionMinor',
              'versionPatch',
              'versionBuild',
              'versionPreRelease',
              'versionIsPreRelease'
            ]);
          } catch (_) {}
          break;
        case 'author':
        case '_author':
        case 'authors':
        case '_authors':
          if (v.value is String) {
            authors.add(v.value);
            break;
          }
          v.value.forEach(authors.add);
          break;
        default:
          final key = _outputVar(v.key);
          if (v.value is String) {
            output.add('static const $key = ${_outputStr(v.value)};');
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
            _outputList(v.value, output);
            output.add('];');
            entries.add(key);
          } else if (v.value is Map) {
            output.add('static const $key = <dynamic,dynamic>{');
            _outputMap(v.value, output);
            output.add('};');
            entries.add(key);
          }
      }
    }

    if (authors.isNotEmpty) {
      output.add('static const authors = <String>[');
      _outputList(authors, output);
      output.add('];');

      output.add('static const authorsName = <String>[');
      _outputList(_authorsName(authors).toList(), output);
      output.add('];');

      output.add('static const authorsEmail = <String>[');
      _outputList(_authorsEmail(authors).toList(), output);
      output.add('];');

      entries.addAll(['authors', 'authorsName', 'authorsEmail']);
    }
  }

  if (outputMap) {
    output.add('static const ${_uncapitalize(className)} = <String, dynamic>{');
    entries.sort();
    for (var entry in entries) {
      output.add('${_outputStr(entry)}:$entry,');
    }
    output.add('};');
  }

  // End class block
  output.add('}');

  if (format) {
    return DartFormatter().format(output.join('\n\n')).toString();
  }

  return output.join('\n');
}

String _capitalize(String s) {
  return '${s[0].toUpperCase()}${s.substring(1)}';
}

String _uncapitalize(String s) {
  return '${s[0].toLowerCase()}${s.substring(1)}';
}

String _outputVar(String s) {
  s = s.replaceAll(RegExp(r'[^A-Za-z0-9_]'), ' ');

  final group = s.split(RegExp(r'\s+'));
  final buffer = StringBuffer();

  var first = true;
  for (var word in group) {
    if (first) {
      first = false;
      buffer.write(word.toLowerCase());
    } else {
      buffer.write(word.substring(0, 1).toUpperCase());
      buffer.write(word.substring(1).toLowerCase());
    }
  }

  return buffer.toString();
}

void _outputItem(dynamic item, List<String> output) {
  if (item is String) {
    output.add(_outputStr(item));
  } else if (item is int || item is double || item is bool) {
    output.add('$item');
  } else if (item == null) {
    output.add('null');
  } else if (item is List) {
    output.add('<dynamic>[');
    _outputList(item, output);
    output.add(']');
  } else if (item is Map) {
    output.add('<dynamic, dynamic>{');
    _outputMap(item, output);
    output.add('}');
  }
}

void _outputList(List<dynamic> list, List<String> output) {
  for (dynamic item in list) {
    _outputItem(item, output);
    output.add(',');
  }
}

void _outputMap(Map<dynamic, dynamic> map, List<String> output) {
  for (var item in map.entries) {
    _outputItem(item.key, output);
    output.add(':');
    _outputItem(item.value, output);
    output.add(',');
  }
}

Iterable<MapEntry<String?, String?>> _authorsSplit(List<String> authors) sync* {
  final re = RegExp(r'([^<]*)\s*(<([^>]*)>)?');
  for (var author in authors) {
    final match = re.firstMatch(author);
    if (match != null) {
      yield MapEntry<String?, String?>(
        match.group(1)?.trim(),
        match.group(3)?.trim(),
      );
    }
  }
}

Iterable<String> _authorsName(List<String> authors) sync* {
  for (var entry in _authorsSplit(authors)) {
    if (entry.key != null) {
      yield entry.key!;
    }
  }
}

Iterable<String> _authorsEmail(List<String> authors) sync* {
  for (var entry in _authorsSplit(authors)) {
    if (entry.value != null) {
      yield entry.value!;
    }
  }
}

String _outputStr(String s) {
  s = s.replaceAll(r'\', r'\\');
  s = s.replaceAll('\n', r'\n');
  s = s.replaceAll('\r', '');
  s = s.replaceAll("'", r"\'");
  return "'$s'";
}
