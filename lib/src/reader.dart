import 'dart:convert';
import 'package:markdown/markdown.dart';
import 'models.dart';

/// Read the content [mdContent] of the markdown file
/// and retrieve a document model
MdDocument read(String mdContent) {
  String asMarkdown;
  String asHtml;
  dynamic metadata;
  List<String> split;

  /// Check if metadata is present
  if (mdContent.startsWith("---")) {
    mdContent = mdContent.replaceFirst("---", "");
    split = mdContent.split("---");
    metadata = jsonDecode(split.first.trim());
    asMarkdown = split.last;
  } else {
    asMarkdown = mdContent;
  }

  asHtml = markdownToHtml(asMarkdown,
      inlineSyntaxes: [new InlineHtmlSyntax()],
      blockSyntaxes: [const TableSyntax(), const FencedCodeBlockSyntax()]);

  return new MdDocument(metadata, asHtml);
}
