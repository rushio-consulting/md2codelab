import 'dart:async';
import 'package:build/build.dart';

import 'src/models.dart';
import 'src/io.dart';
import 'src/parser.dart';
import 'src/renderer.dart';

Builder mdBuilder(BuilderOptions options) => new MdBuilder();

class MdBuilder implements Builder {
  @override
  Future build(BuildStep buildStep) async {
    // Each [buildStep] has a single input.
    var inputId = buildStep.inputId;

    // Create a new target [AssetId] based on the old one.
    var mdContent = await buildStep.readAsString(inputId);

    var copy = inputId.addExtension('.html');

    // Write out the new asset.
    await buildStep.writeAsString(copy, _execute(mdContent));
  }

  Future<String> _execute(String mdContent) async {
    Codelab codelab;
    String htmlContent;

    htmlContent = readMarkdownToHtml(mdContent);
    codelab = parse(htmlContent, "");
    return codelab != null ? render(codelab, "../.dependencies/") : "ERROR while parsing";
  }

  @override
  final buildExtensions = const {
    '.md': const ['.md.html']
  };
}