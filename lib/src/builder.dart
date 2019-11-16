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

import 'dart:async';

import 'package:build/build.dart';

import 'generator.dart';

class PubspecBuilder implements Builder {
  const PubspecBuilder();

  @override
  Map<String, List<String>> get buildExtensions => const <String, List<String>>{
        r'$lib$': <String>['pubspec.dart'],
      };

  @override
  Future<void> build(BuildStep buildStep) async {
    if (buildStep.inputId.path == r'lib/$lib$') {
      final AssetId inputId = AssetId(
        buildStep.inputId.package,
        'pubspec.yaml',
      );

      final AssetId outputId = AssetId(
        buildStep.inputId.package,
        'lib/pubspec.dart',
      );

      final String contents = await buildStep.readAsString(inputId);
      final String source = convertPubspec(contents);
      buildStep.writeAsString(outputId, source);
    }
  }
}
