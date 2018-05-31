import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:markdown/markdown.dart';
import 'models.dart';

/// Read the content [inputFile] of the markdown file
/// and retrieve a document model
Future<MdDocument> read(String inputFile) async {
  String asHtml;

  String mdContent = await _readFileContent(inputFile);
  asHtml = readMarkdownToHtml(mdContent);

  return new MdDocument(asHtml);
}

String readMarkdownToHtml(String mdContent) => markdownToHtml(mdContent,
    inlineSyntaxes: [new InlineHtmlSyntax()],
    blockSyntaxes: [const TableSyntax(), const FencedCodeBlockSyntax()]);


Future _readFileContent(String filename) =>
    new File(filename).readAsString(encoding: utf8);

Future writeToDocument(String filename, String content) =>
    new File(filename).writeAsString(content, encoding: utf8);

Future<List<String>> listMdFiles(String path) async {
  List<String> mdFiles;
  
  mdFiles = [];
  var directory = new Directory(path);

  var exists = await directory.exists();
  if (exists) {
    //print("List .md files into $path");
    directory
        .listSync(recursive: false, followLinks: false)
        .forEach((FileSystemEntity entity) {
      if (entity.path.endsWith(".md")) {
        mdFiles.add(entity.path);
      } else {}
    });
  }

  return mdFiles;
}
