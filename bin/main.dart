import 'dart:async';
import 'dart:io';
import 'package:md2codelab/md2codelab.dart' as server;

void main() async {
  final inputMdFile = 'md/cheatsheet.md';
  final outputHtmlFile = 'md/cheatsheet.html';

  server.MdDocument mdDocument;
  server.Codelab codelab;
  String renderedAsHtml;

  String mdContent = await _readFileContent(inputMdFile);

  mdDocument = server.read(mdContent);

  codelab = server.parse(mdDocument.htmlContent);

  Map metadata = mdDocument.metadata;

  if (metadata != null && metadata['feedback'].toString().isNotEmpty) {
    codelab.feedbackLink = metadata['feedback'].toString();
  }
  renderedAsHtml = server.render(codelab);

  _writeToHtml(outputHtmlFile, renderedAsHtml);
}

Future _readFileContent(String filename) {
  return new File(filename).readAsString();
}

Future _writeToHtml(String filename, String content) {
  return new File(filename).writeAsString(content);
}
