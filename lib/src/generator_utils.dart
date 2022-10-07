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

String capitalize(String s) {
  return '${s[0].toUpperCase()}${s.substring(1)}';
}

String unCapitalize(String s) {
  return '${s[0].toLowerCase()}${s.substring(1)}';
}

String outputVar(String s, {bool camelCase = false}) {
  final t = camelCase
      ? s.replaceAll(RegExp(r'[^A-Za-z0-9]'), ' ')
      : s.replaceAll(RegExp(r'[^A-Za-z0-9_]'), ' ');

  final group = t.split(RegExp(r'\s+'));
  final buffer = StringBuffer();

  var first = true;
  for (final word in group) {
    if (first) {
      first = false;
      buffer.write(word.toLowerCase());
    } else {
      buffer.write(word.substring(0, 1).toUpperCase());
      buffer.write(word.substring(1).toLowerCase());
    }
  }

  return buffer.toString();
}

String outputStr(String s) {
  var t = s.replaceAll(r'\', r'\\');
  t = t.replaceAll('\n', r'\n');
  t = t.replaceAll('\r', '');
  t = t.replaceAll("'", r"\'");
  return "'$t'";
}

void outputItem(dynamic item, List<String> output) {
  if (item is String) {
    output.add(outputStr(item));
  } else if (item is int || item is double || item is bool) {
    output.add('$item');
  } else if (item == null) {
    output.add('null');
  } else if (item is List) {
    output.add('<dynamic>[');
    outputList(item, output);
    output.add(']');
  } else if (item is Map) {
    output.add('<dynamic, dynamic>{');
    outputMap(item, output);
    output.add('}');
  }
}

void outputList(List<dynamic> list, List<String> output) {
  for (final dynamic item in list) {
    outputItem(item, output);
    output.add(',');
  }
}

void outputMap(Map<dynamic, dynamic> map, List<String> output) {
  for (final item in map.entries) {
    outputItem(item.key, output);
    output.add(':');
    outputItem(item.value, output);
    output.add(',');
  }
}

Iterable<MapEntry<String?, String?>> authorsSplit(List<String> authors) sync* {
  final re = RegExp(r'([^<]*)\s*(<([^>]*)>)?');
  for (final author in authors) {
    final match = re.firstMatch(author);
    if (match != null) {
      yield MapEntry<String?, String?>(
        match.group(1)?.trim(),
        match.group(3)?.trim(),
      );
    }
  }
}

Iterable<String> authorsName(List<String> authors) sync* {
  for (final entry in authorsSplit(authors)) {
    if (entry.key != null) {
      yield entry.key!;
    }
  }
}

Iterable<String> authorsEmail(List<String> authors) sync* {
  for (final entry in authorsSplit(authors)) {
    if (entry.value != null) {
      yield entry.value!;
    }
  }
}
