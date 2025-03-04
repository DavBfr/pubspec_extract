 # Copyright (C) 2019, David PHAM-VAN <dev.nfet.net@gmail.com>
 #
 # Licensed under the Apache License, Version 2.0 (the "License");
 # you may not use this file except in compliance with the License.
 # You may obtain a copy of the License at
 #
 #     http://www.apache.org/licenses/LICENSE-2.0
 #
 # Unless required by applicable law or agreed to in writing, software
 # distributed under the License is distributed on an "AS IS" BASIS,
 # WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 # See the License for the specific language governing permissions and
 # limitations under the License.

FLUTTER?=$(realpath $(dir $(realpath $(dir $(shell which flutter)))))
FLUTTER_BIN=$(FLUTTER)/bin/flutter
DART_BIN=$(FLUTTER)/bin/dart
DART_SRC=$(shell find . -name '*.dart') lib/src/pubspec.dart

all: format lib/src/pubspec.dart

format: format-dart

format-dart: $(DART_SRC)
	${DART_BIN} format $^

pubspec.lock: pubspec.yaml
	${DART_BIN} pub get

clean:
	git clean -fdx -e .vscode

test:
	${DART_BIN} run test

publish: format analyze clean
	test -z "$(shell git status --porcelain)"
	${DART_BIN} pub publish -f
	git tag $(shell grep version pubspec.yaml | sed 's/version\s*:\s*/v/g')

.pana:
	${DART_BIN} pub global activate pana
	touch $@

fix: $(DART_SRC)
	${DART_BIN} fix --apply

analyze: $(DART_SRC) pubspec.lock
	$(DART_BIN) analyze --fatal-infos

pana: .pana
	$(DART_BIN) pub global run pana --no-warning --source path .

.PHONY: format format-dart clean publish test fix analyze

lib/src/pubspec.dart: pubspec.yaml
	$(DART_BIN) bin/pubspec_extract.dart -s $^ -d $@
