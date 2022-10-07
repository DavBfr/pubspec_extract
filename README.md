# Pubspec Extract

Extracts Dart pubspec.yaml file and generate pubspec.dart at build time.

[![Buy Me A Coffee](https://bmc-cdn.nyc3.digitaloceanspaces.com/BMC-button-images/custom_images/orange_img.png "Buy Me A Coffee")](https://www.buymeacoffee.com/JORBmbw9h "Buy Me A Coffee")

## Usage as a command line tool

Add the `pubspec_extract` dev dependency

```shell
dart pub add --dev pubspec_extract
```

then run:

```shell
dart run pubspec_extract
```

## Install the command-line tool globally

run:

```shell
dart pub global activate pubspec_extract
```

the executable will be compiled and available at `$HOME/.pub-cache/bin` or `%APPDATA%\Pub\Cache\bin`. You can run it using:

```shell
dart pub global run pubspec_extract
```

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
