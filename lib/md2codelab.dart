/// convert .md files to codelab html page
library md2codelab;

import 'dart:async';
import 'dart:convert';

import 'package:path/path.dart';
import 'package:yaml/yaml.dart';
import 'package:quiver/strings.dart' as quiver_strings;

import 'src/io.dart' as io;
import 'src/models.dart';
import 'src/parser.dart' as parser;
import 'src/renderer.dart' as renderer;

// Execute the process md2codelab for the given [inputPath]
Future<void> run(final String inputPath, final String outputPath,
    final bool withJson) async {
  List<Map> metadata;
  List<Map> documentsForSearch;
  List<String> inputFiles;

  metadata = [];
  documentsForSearch = [];
  inputFiles = await io.listMdFiles(inputPath);

  Future
      .wait(
          inputFiles.map((file) => _executeSingle(file.toString(), outputPath)))
      .then((List<SingleParsingInfo> results) {
    if (withJson) {
      results.forEach((singleParsingInfo) {
        metadata.add(singleParsingInfo.metadata);
        documentsForSearch.addAll(singleParsingInfo.documentsForSearch);
      });
      io.writeToDocument(
          outputPath + "/" + "md_search.json", jsonEncode(documentsForSearch));
      io.writeToDocument(
          outputPath + "/" + "md.json", jsonEncode(metadata));
    }
  });
}

Future<SingleParsingInfo> _executeSingle(
    String inputFile, String outputPath) async {
  MdDocument mdDocument;
  Codelab codelab;
  String renderedAsHtml;
  String metadata;
  Map metadataAsmap;
  String outputFile;
  List<Map> documentsForSearch;

  documentsForSearch = <Map>[];
  outputFile =
      outputPath + "/" + basename(inputFile).replaceAll(".md", "") + ".html";

  mdDocument = await io.read(inputFile);
  codelab = parser.parse(mdDocument.htmlContent,basename(inputFile).replaceAll(".md", "") + ".html");

  metadata = codelab.metadata;
  if (quiver_strings.isNotEmpty(metadata)) {
    metadataAsmap = loadYaml(metadata) as Map;
    if (metadataAsmap != null && metadataAsmap['feedback'] != null) {
      codelab.feedbackLink = metadataAsmap['feedback'].toString();
    }
  }

  renderedAsHtml = renderer.render(codelab);

  if (renderedAsHtml != null) {
    io.writeToDocument(outputFile, renderedAsHtml);
    codelab.stepSearch.forEach((entry) {
      documentsForSearch.add(entry.toJson());
    });
  }

  return new SingleParsingInfo(metadataAsmap, documentsForSearch);
}
