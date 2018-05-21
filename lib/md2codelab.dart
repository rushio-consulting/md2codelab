/// convert .md files to codelab html page
library md2codelab;

import 'dart:async';
import 'src/models.dart';
import 'src/parser.dart';
import 'src/reader.dart';
import 'src/renderer.dart';

// Execute the process md 2 codelab for the given [inputMdFile]
Future<String> run(final String inputMdFileContent) async {
  MdDocument mdDocument;
  Codelab codelab;

  mdDocument = read(inputMdFileContent);

  codelab = parse(mdDocument.htmlContent);

  Map metadata = mdDocument.metadata;

  if (metadata != null && metadata['feedback'].toString().isNotEmpty) {
    codelab.feedbackLink = metadata['feedback'].toString();
  }
  return render(codelab);
}




