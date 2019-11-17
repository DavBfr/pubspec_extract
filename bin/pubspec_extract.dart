import 'dart:io';

import 'package:args/args.dart';
import 'package:logging/logging.dart';
import 'package:path/path.dart' as p;

import 'package:pubspec_extract/pubspec_extract.dart';
import 'package:pubspec_extract/src/pubspec.dart';

int main(List<String> arguments) {
  // Parse CLI arguments
  final parser = ArgParser()
    ..addOption(
      'source',
      abbr: 's',
      defaultsTo: 'pubspec.yaml',
      help: 'Source yaml file',
    )
    ..addOption(
      'destination',
      abbr: 'd',
      defaultsTo: 'lib/pubspec.dart',
      help: 'Destination dart file',
    )
    ..addFlag(
      'verbose',
      abbr: 'v',
      negatable: false,
      help: 'Verbose output',
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

  final String source = argResults['source'];
  final String destination = argResults['destination'];
  final bool verbose = argResults['verbose'];

  // Initialize logger
  Logger.root.level = verbose ? Level.ALL : Level.SEVERE;
  Logger.root.onRecord.listen((LogRecord rec) {
    print('${rec.level.name}: ${rec.time}: ${rec.message}');
  });
  final Logger log = Logger('main');

  log.info('Checking source file exists');
  final fileSource = File(source);
  if (!fileSource.existsSync()) {
    log.severe('File ${source} not found');
    return 1;
  }

  log.info('Checking output directory');
  Directory(p.basename(destination));

  log.info('Converting $source to $destination');
  final contents = convertPubspec(fileSource.readAsStringSync());
  File(destination).writeAsStringSync(contents);

  return 0;
}
