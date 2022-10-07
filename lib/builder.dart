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
    );
  }

  return MyBuilder(options);
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
