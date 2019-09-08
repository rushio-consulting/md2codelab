import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:markdown/markdown.dart';
import 'models.dart';

/// Read the content [inputFile] of the markdown file
/// and retrieve a document model
/// TODO: Check if it is md vs adoc vs whatever else ...
Future<MdDocument> read(String inputFile) async {
  String asHtml;

  var mdContent = await _readFileContent(inputFile);
  asHtml = readMarkdownToHtml(mdContent);

  return new MdDocument(asHtml);
}

String readMarkdownToHtml(String mdContent) => markdownToHtml(mdContent,
    inlineSyntaxes: [new InlineHtmlSyntax()],
    blockSyntaxes: [const TableSyntax(), const FencedCodeBlockSyntax()]);


Future<String> _readFileContent(String filename) =>
    new File(filename).readAsString(encoding: utf8);

Future writeToDocument(String filename, String content) =>
    new File(filename).writeAsString(content, encoding: utf8);

// TODO : Rename listMDFiles => listInputFiles...
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
          // TODO: File to take in consideration .md , .adoc ... whatever else...
      if (entity.path.endsWith(".md")) {
        mdFiles.add(entity.path);
      } else {}
    });
  }

  return mdFiles;
}
