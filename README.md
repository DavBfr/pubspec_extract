# Pubspec Extract

Extracts Dart pubspec.yaml file and generate pubspec.dart at build time.

[![Buy Me A Coffee](https://bmc-cdn.nyc3.digitaloceanspaces.com/BMC-button-images/custom_images/orange_img.png "Buy Me A Coffee")](https://www.buymeacoffee.com/JORBmbw9h "Buy Me A Coffee")

## Usage as a command line tool

### Install the command-line tool locally

Add the `pubspec_extract` dev dependency

```shell
dart pub add --dev pubspec_extract
```

then run:

```shell
dart run pubspec_extract -s pubspec.yaml  -d lib/pubspec.dart --map-list
```

### Install the command-line tool globally

run:

```shell
dart pub global activate pubspec_extract
```

The executable will be compiled and available at `$HOME/.pub-cache/bin` or `%APPDATA%\Pub\Cache\bin`. You can run it using:

Builder options in command-line args:

```shell
dart pub global run pubspec_extract -s pubspec.yaml  -d lib/pubspec.dart --map-list
```

### Command line arguments

| Arg                               | Abbr | Description                                                            |
|-----------------------------------|:----:|------------------------------------------------------------------------|
| source                            |  s   | YAML source file. Default - pubspec.yaml                               |
| destination                       |  d   | Output dart file export path. Default - lib/pubspec.dart               |
| class-name                        |  c   | Output dart class. Default - Pubspec                                   |
| [no-]format                       |  f   | Format output dart code. Default - true                                |
| map-list                          |  m   | Add a list of the exported variables                                   |
| [no-]extract-name                 |      | Extract top-level 'name' from pubspec. Default - true                  |
| [no-]extract-description          |      | Extract top-level 'description' from pubspec. Default - true           |
| [no-]extract-version              |      | Extract top-level 'version' from pubspec. Default - true               |
| [no-]extract-topics               |      | Extract top-level 'version' from pubspec. Default - true               |
| [no-]extract-homepage             |      | Extract top-level 'homepage' from pubspec. Default - true              |
| [no-]extract-issue-tracker        |      | Extract top-level 'issue_tracker' from pubspec. Default - true         |
| [no-]extract-publish-to           |      | Extract top-level 'publish_to' from pubspec. Default - true            |
| [no-]extract-funding              |      | Extract top-level 'funding' from pubspec. Default - true               |
| [no-]extract-screenshots          |      | Extract top-level 'screenshots' from pubspec. Default - true           |
| [no-]extract-false-secrets        |      | Extract top-level 'false_secrets' from pubspec. Default - true         |
| [no-]extract-environment          |      | Extract top-level 'environment' from pubspec. Default - true           |
| [no-]extract-dependencies         |      | Extract top-level 'dependencies' from pubspec. Default - true          |
| [no-]extract-dependency-overrides |      | Extract top-level 'dependency_overrides' from pubspec. Default - true  |
| [no-]extract-ignored-advisories   |      | Extract top-level 'ignored_advisories' from pubspec. Default - true    |
| [no-]extract-dev-dependencies     |      | Extract top-level 'dev_dependencies' from pubspec. Default - true      |
| [no-]extract-flutter              |      | Extract top-level 'flutter' from pubspec. Default - true               |
| [no-]extract-executables          |      | Extract top-level 'executables' from pubspec. Default - true           |
| [no-]extract-undocumented-keys    |      | Extract other undocumented top-level keys from pubspec. Default - true |
| version                           |      | Extractor version                                                      |
| verbose                           |  v   | Verbose output                                                         |
| help                              |  h   | Show usage info                                                        |

## Usage with build_runner

Add the `build_runner` dev dependency

```shell
dart pub add --dev build_runner
```

Build the `pubspec.dart` file

```shell
dart run build_runner build
```

Builder options are configured in your pubspec.yaml:

```yaml
pubspec_extract:
  class_name: Pubspec
  source: pubspec.yaml
  destination: lib/pubspec.dart
  format: true
  map_list: false
  extract-name: true
  extract-description: true
  extract-version: true
  extract-topics: true
  extract-homepage: true
  extract-issue-tracker: true
  extract-publish-to: true
  extract-funding: true
  extract-screenshots: true
  extract-false-secrets: true
  extract-environment: true
  extract-dependencies: true
  extract-dependency-overrides: true
  extract-ignored-advisories: true
  extract-undocumented-keys: true
```

## Usage

Then in your application, you can import `pubspec.dart`:

```dart
import 'pubspec.dart'; // May not exist but it's okay!

void main() {
  print(Pubspec.name);
  print(Pubspec.description);
  print(Pubspec.version);
}
```
