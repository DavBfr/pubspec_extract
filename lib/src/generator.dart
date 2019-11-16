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
import 'package:yaml/yaml.dart';

String outputStr(String s) {
  s = s.trim();
  s = s.replaceAll(r'\', r'\\');
  s = s.replaceAll('\n', r'\n');
  s = s.replaceAll('\r', '');
  s = s.replaceAll("'", r"\'");
  return "'$s'";
}

String convertPubspec(String source) {
  final dynamic data = loadYaml(source);
  final List<String> output = <String>[];

  output.add('// This file is generated automatically, do not modify');

  final List<String> authors = <String>[];

  if (data is Map) {
    for (MapEntry<dynamic, dynamic> v in data.entries) {
      switch (v.key) {
        case 'version':
          final List<String> splitted = v.value.split('+');
          output.add('const String version = ${outputStr(splitted.first)};');
          final int build = splitted.length > 1 ? int.parse(splitted[1]) : 0;
          output.add('const int build = $build;');
          break;
        case 'author':
        case 'authors':
          if (v.value is String) {
            authors.add(outputStr(v.value));
            break;
          }
          for (String author in v.value) {
            authors.add(outputStr(author));
          }
          break;
        default:
          if (v.value is String) {
            output.add('const String ${v.key} = ${outputStr(v.value)};');
          } else if (v.value is int) {
            output.add('const int ${v.key} = ${v.value};');
          } else if (v.value is double) {
            output.add('const double ${v.key} = ${v.value};');
          } else if (v.value is bool) {
            output.add('const bool ${v.key} = ${v.value};');
          }
      }
    }

    if (authors.isNotEmpty) {
      output.add(
        'const List<String> authors = <String>[${authors.join(',')},];',
      );
    }
  }

  return DartFormatter().format(output.join('\n\n')).toString();
}
