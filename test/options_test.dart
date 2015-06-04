// Copyright (c) 2015, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library analyzer_cli.test.options;

import 'package:analyzer_cli/src/options.dart';
import 'package:args/args.dart';
import 'package:unittest/unittest.dart';

main() {
  groupSep = ' | ';

  group('AnalyzerOptions', () {
    group('parse', () {
      test('defaults', () {
        CommandLineOptions options =
            CommandLineOptions.parse(['--dart-sdk', '.', 'foo.dart']);
        expect(options, isNotNull);
        expect(options.dartSdkPath, isNotNull);
        expect(options.disableHints, isFalse);
        expect(options.lints, isFalse);
        expect(options.displayVersion, isFalse);
        expect(options.enableStrictCallChecks, isFalse);
        expect(options.enableTypeChecks, isFalse);
        expect(options.ignoreUnrecognizedFlags, isFalse);
        expect(options.log, isFalse);
        expect(options.machineFormat, isFalse);
        expect(options.packageRootPath, isNull);
        expect(options.shouldBatch, isFalse);
        expect(options.showPackageWarnings, isFalse);
        expect(options.showSdkWarnings, isFalse);
        expect(options.sourceFiles, equals(['foo.dart']));
        expect(options.warningsAreFatal, isFalse);
        expect(options.customUrlMappings, isNotNull);
        expect(options.customUrlMappings.isEmpty, isTrue);
      });

      test('batch', () {
        CommandLineOptions options =
            CommandLineOptions.parse(['--dart-sdk', '.', '--batch']);
        expect(options.shouldBatch, isTrue);
      });

      test('defined variables', () {
        CommandLineOptions options = CommandLineOptions
            .parse(['--dart-sdk', '.', '-Dfoo=bar', 'foo.dart']);
        expect(options.definedVariables['foo'], equals('bar'));
        expect(options.definedVariables['bar'], isNull);
      });

      test('enable strict call checks', () {
        CommandLineOptions options = CommandLineOptions.parse(
            ['--dart-sdk', '.', '--enable-strict-call-checks', 'foo.dart']);
        expect(options.enableStrictCallChecks, isTrue);
      });

      test('enable type checks', () {
        CommandLineOptions options = CommandLineOptions
            .parse(['--dart-sdk', '.', '--enable_type_checks', 'foo.dart']);
        expect(options.enableTypeChecks, isTrue);
      });

      test('log', () {
        CommandLineOptions options =
            CommandLineOptions.parse(['--dart-sdk', '.', '--log', 'foo.dart']);
        expect(options.log, isTrue);
      });

      test('machine format', () {
        CommandLineOptions options = CommandLineOptions
            .parse(['--dart-sdk', '.', '--format=machine', 'foo.dart']);
        expect(options.machineFormat, isTrue);
      });

      test('no-hints', () {
        CommandLineOptions options = CommandLineOptions
            .parse(['--dart-sdk', '.', '--no-hints', 'foo.dart']);
        expect(options.disableHints, isTrue);
      });

      test('lints', () {
        CommandLineOptions options = CommandLineOptions
            .parse(['--dart-sdk', '.', '--lints', 'foo.dart']);
        expect(options.lints, isTrue);
      });

      test('package root', () {
        CommandLineOptions options = CommandLineOptions
            .parse(['--dart-sdk', '.', '-p', 'bar', 'foo.dart']);
        expect(options.packageRootPath, equals('bar'));
      });

      test('package warnings', () {
        CommandLineOptions options = CommandLineOptions
            .parse(['--dart-sdk', '.', '--package-warnings', 'foo.dart']);
        expect(options.showPackageWarnings, isTrue);
      });

      test('sdk warnings', () {
        CommandLineOptions options = CommandLineOptions
            .parse(['--dart-sdk', '.', '--warnings', 'foo.dart']);
        expect(options.showSdkWarnings, isTrue);
      });

      test('sourceFiles', () {
        CommandLineOptions options = CommandLineOptions.parse(
            ['--dart-sdk', '.', '--log', 'foo.dart', 'foo2.dart', 'foo3.dart']);
        expect(options.sourceFiles,
            equals(['foo.dart', 'foo2.dart', 'foo3.dart']));
      });

      test('warningsAreFatal', () {
        CommandLineOptions options = CommandLineOptions
            .parse(['--dart-sdk', '.', '--fatal-warnings', 'foo.dart']);
        expect(options.warningsAreFatal, isTrue);
      });

      test('customUrlMappings', () {
        CommandLineOptions options = CommandLineOptions.parse([
          '--dart-sdk',
          '.',
          '--url-mapping',
          'dart:dummy,/path/to/dummy.dart',
          'foo.dart'
        ]);
        expect(options.customUrlMappings, isNotNull);
        expect(options.customUrlMappings.isEmpty, isFalse);
        expect(options.customUrlMappings['dart:dummy'],
            equals('/path/to/dummy.dart'));
      });

      test('notice unrecognized flags', () {
        expect(() => new CommandLineParser().parse(
                ['--bar', '--baz', 'foo.dart'], {}),
            throwsA(new isInstanceOf<FormatException>()));
      });

      test('ignore unrecognized flags', () {
        CommandLineOptions options = CommandLineOptions.parse([
          '--ignore-unrecognized-flags',
          '--bar',
          '--baz',
          '--dart-sdk',
          '.',
          'foo.dart'
        ]);
        expect(options, isNotNull);
        expect(options.sourceFiles, equals(['foo.dart']));
      });

      test('ignore unrecognized options', () {
        CommandLineParser parser =
            new CommandLineParser(alwaysIgnoreUnrecognized: true);
        parser.addOption('optionA');
        parser.addFlag('flagA');
        ArgResults argResults =
            parser.parse(['--optionA=1', '--optionB=2', '--flagA'], {});
        expect(argResults['optionA'], '1');
        expect(argResults['flagA'], isTrue);
      });
    });
  });
}
