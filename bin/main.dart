import 'dart:async';
import 'dart:io';
import 'package:md2codelab/md2codelab.dart' as server;
import 'dart:convert';

void main() async {
  final inputMdFile = 'md/input.md';
  final outputHtmlFile = 'md/output.html';
  String renderedAsHtml;

  String inputContent = await _readFileContent(inputMdFile);
  renderedAsHtml = await server.run(inputContent);
  if (renderedAsHtml != null) {
    _writeToHtml(outputHtmlFile, renderedAsHtml);
  }
}
Future _readFileContent(String filename) {
  return new File(filename).readAsString(encoding: utf8);
}

Future _writeToHtml(String filename, String content) =>
    new File(filename).writeAsString(content,encoding: utf8);
