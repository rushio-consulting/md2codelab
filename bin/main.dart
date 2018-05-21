import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:args/args.dart';
import 'package:md2codelab/md2codelab.dart' as server;

void main(List<String> args) async {
  var parser = _configureArgParser();
  var results = parser.parse(args);
  String renderedAsHtml;
  if (results['help'] == true || args.isEmpty) {
    print(parser.usage);
    return;
  }
  if (results['input'] != null) {
    String inputMdFile = results['input'];
    String inputContent = await _readFileContent(inputMdFile);
    renderedAsHtml = await server.run(inputContent);
    if (renderedAsHtml != null) {
      _writeToHtml(results['output'].toString(), renderedAsHtml);
    }
  }
}

ArgParser _configureArgParser() {
  var parser = new ArgParser();
  parser
    ..addOption('input',
        help: '[required] The input markdown file path', valueHelp: 'path')
    ..addOption('output',
        help: 'The output html file path',
        valueHelp: 'path',
        defaultsTo: 'index.html')
    ..addFlag('help', abbr: 'h', help: 'Show the usage');
  return parser;
}

Future _readFileContent(String filename) {
  return new File(filename).readAsString(encoding: utf8);
}

Future _writeToHtml(String filename, String content) =>
    new File(filename).writeAsString(content, encoding: utf8);
