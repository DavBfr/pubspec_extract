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

class GeneratorOptions {
  const GeneratorOptions({
    this.className = 'Pubspec',
    this.format = true,
    this.mapList = false,
    this.source = 'pubspec.yaml',
    this.destination = 'lib/pubspec.dart',
  });

  static const def = GeneratorOptions();

  /// The class name to generate
  final String className;

  /// Format the generated dart file
  final bool format;

  /// Add a list of the exported variables
  final bool mapList;

  /// Source directory
  final String source;

  /// Output filename
  final String destination;

  GeneratorOptions copyWith({
    String? className,
    bool? format,
    bool? mapList,
    String? source,
    String? destination,
  }) =>
      GeneratorOptions(
        className: className ?? this.className,
        format: format ?? this.format,
        mapList: mapList ?? this.mapList,
        source: source ?? this.source,
        destination: destination ?? this.destination,
      );
}
