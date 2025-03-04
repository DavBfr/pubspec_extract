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

import 'package:pubspec_extract/src/generator.dart';
import 'package:pubspec_extract/src/generator_options.dart';
import 'package:test/test.dart';

void main() {
  test('Empty file', () {
    final result = convertPubspec('', GeneratorOptions.def);
    expect(result.contains('buildDate ='), true);
  });

  test('Name works', () {
    final result = convertPubspec('name: package', GeneratorOptions.def);
    expect(result.contains(r"const name = 'package';"), true);
    expect(result.contains('authors'), false);
  });

  test('Authors works', () {
    final result = convertPubspec('author: David', GeneratorOptions.def);
    expect(result.contains('const authors ='), true);
    expect(result.contains(r"'David'"), true);
  });

  group('Version string', () {
    test('Simple', () {
      final result = convertPubspec('version: 1.2.3', GeneratorOptions.def);
      expect(result.contains('version = \'1.2.3\';'), true);
      expect(result.contains('versionSmall = \'1.2\';'), true);
      expect(result.contains('versionMajor = 1;'), true);
      expect(result.contains('versionMinor = 2;'), true);
      expect(result.contains('versionPatch = 3;'), true);
      expect(result.contains('versionBuild = 0;'), true);
      expect(result.contains('versionPreRelease = \'\';'), true);
      expect(result.contains('versionIsPreRelease = false;'), true);
    });

    test('Too small', () {
      expect(
        () => convertPubspec('version: 1.2', GeneratorOptions.def),
        throwsFormatException,
      );
    });

    test('Complete', () {
      final result = convertPubspec(
        'version: 1.02.3-dev+3',
        GeneratorOptions.def,
      );
      expect(result.contains('version = \'1.02.3\';'), true);
      expect(result.contains('versionSmall = \'1.02\';'), true);
      expect(result.contains('versionMajor = 1;'), true);
      expect(result.contains('versionMinor = 2;'), true);
      expect(result.contains('versionPatch = 3;'), true);
      expect(result.contains('versionBuild = 3;'), true);
      expect(result.contains('versionPreRelease = \'dev\';'), true);
      expect(result.contains('versionIsPreRelease = true;'), true);
    });
  });

  test('With a \$', () {
    final result = convertPubspec('name: \$value', GeneratorOptions.def);
    expect(result.contains('name = \'\\\$value\';'), true);
  });
}
