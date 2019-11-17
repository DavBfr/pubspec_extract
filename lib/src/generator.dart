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

part of pubspec_extract;

/// Converts a yaml content with pubspec.yaml in mind
/// to a dart source file
String convertPubspec(
  String source, {
  String className = 'Pubspec',
  bool format = true,
  bool outputMap = false,
}) {
  final dynamic data = loadYaml(source);
  final List<String> output = <String>[];
  final List<String> entries = <String>[];

  output.add('// This file is generated automatically, do not modify');

  output.add('class $className {');

  final List<String> authors = <String>[];

  if (data is Map) {
    for (MapEntry<dynamic, dynamic> v in data.entries) {
      switch (v.key) {
        case 'version':
          output
              .add('static const String versionFull = ${_outputStr(v.value)};');
          entries.add('versionFull');

          try {
            final Version ver = Version.parse(v.value);

            final String v1 = '${ver.major}.${ver.minor}.${ver.patch}';
            output.add('static const String version = ${_outputStr(v1)};');

            final String v2 = '${ver.major}.${ver.minor}';
            output.add('static const String versionSmall = ${_outputStr(v2)};');

            output.add('static const int versionMajor = ${ver.major};');
            output.add('static const int versionMinor = ${ver.minor};');
            output.add('static const int versionPatch = ${ver.patch};');
            final int build = ver.build.isEmpty
                ? 0
                : ver.build.firstWhere((v) => v is int) ?? 0;
            output.add('static const int versionBuild = $build;');

            output.add('static const String versionPreRelease = ');
            _outputItem(
                ver.preRelease.isEmpty ? null : ver.preRelease.first, output);
            output.add(';');

            output.add('static const bool versionIsPreRelease = ');
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
        case 'authors':
          if (v.value is String) {
            authors.add(v.value);
            break;
          }
          for (String author in v.value) {
            authors.add(author);
          }
          break;
        default:
          if (v.value is String) {
            output
                .add('static const String ${v.key} = ${_outputStr(v.value)};');
            entries.add(v.key);
          } else if (v.value is int) {
            output.add('static const int ${v.key} = ${v.value};');
            entries.add(v.key);
          } else if (v.value is double) {
            output.add('static const double ${v.key} = ${v.value};');
            entries.add(v.key);
          } else if (v.value is bool) {
            output.add('static const bool ${v.key} = ${v.value};');
            entries.add(v.key);
          } else if (v.value is List) {
            output.add('static const List<dynamic> ${v.key} = <dynamic>[');
            _outputList(v.value, output);
            output.add('];');
            entries.add(v.key);
          } else if (v.value is Map) {
            output.add(
                'static const Map<dynamic, dynamic> ${v.key} = <dynamic,dynamic>{');
            _outputMap(v.value, output);
            output.add('};');
            entries.add(v.key);
          }
      }
    }

    if (authors.isNotEmpty) {
      output.add('static const List<String> authors = <String>[');
      _outputList(authors, output);
      output.add('];');

      output.add('static const List<String> authorsName = <String>[');
      _outputList(_authorsName(authors).toList(), output);
      output.add('];');

      output.add('static const List<String> authorsEmail = <String>[');
      _outputList(_authorsEmail(authors).toList(), output);
      output.add('];');

      entries.addAll(['authors', 'authorsName', 'authorsEmail']);
    }
  }

  if (outputMap) {
    output
        .add('static const Map<String, dynamic> pubspec = <String, dynamic>{');
    entries.sort();
    for (var entry in entries) {
      output.add('${_outputStr(entry)}:${entry},');
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

void _outputItem(dynamic item, List<String> output) {
  if (item is String) {
    output.add('${_outputStr(item)}');
  } else if (item is int || item is double || item is bool) {
    output.add('${item}');
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
  for (MapEntry<dynamic, dynamic> item in map.entries) {
    _outputItem(item.key, output);
    output.add(':');
    _outputItem(item.value, output);
    output.add(',');
  }
}

Iterable<MapEntry<String, String>> _authorsSplit(List<String> authors) sync* {
  final RegExp re = RegExp(r'([^<]*)\s*(<([^>]*)>)?');
  for (String author in authors) {
    RegExpMatch match = re.firstMatch(author);

    yield MapEntry<String, String>(
      match.group(1)?.trim(),
      match.group(2)?.trim(),
    );
  }
}

Iterable<String> _authorsName(List<String> authors) sync* {
  for (MapEntry<String, String> entry in _authorsSplit(authors)) {
    if (entry.key != null) {
      yield entry.key;
    }
  }
}

Iterable<String> _authorsEmail(List<String> authors) sync* {
  for (MapEntry<String, String> entry in _authorsSplit(authors)) {
    if (entry.value != null) {
      yield entry.value;
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
