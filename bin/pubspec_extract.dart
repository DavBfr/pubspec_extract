import 'dart:io';

import 'package:args/args.dart';
import 'package:logging/logging.dart';
import 'package:path/path.dart' as p;
import 'package:pubspec_extract/pubspec_extract.dart';

int main(List<String> arguments) {
  // Parse CLI arguments
  final parser = ArgParser()
    ..addOption('source', abbr: 's', defaultsTo: 'pubspec.yaml')
    ..addOption('destination', abbr: 'd', defaultsTo: 'lib/pubspec.dart')
    ..addFlag('verbose', abbr: 'v');
  final argResults = parser.parse(arguments);

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
