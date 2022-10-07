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
      'version',
      negatable: false,
      help: 'Print the version information',
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
  Directory(p.basename(options.destination));

  log.info('Converting ${options.source} to ${options.destination}');
  final contents = convertPubspec(fileSource.readAsStringSync(), options);
  File(options.destination).writeAsStringSync(contents);

  return 0;
}
