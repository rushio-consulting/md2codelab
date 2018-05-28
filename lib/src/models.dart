import 'dart:convert';
import 'package:html/dom.dart';

class SingleParsingInfo {
  Map metadata;
  List<Map> documentsForSearch;

  SingleParsingInfo(this.metadata,this.documentsForSearch);
}

/// Model wrapper for the
/// html content related to the markdown content
class MdDocument {
  final String htmlContent;

  MdDocument(this.htmlContent);
}

/// Model related to
/// [google codelab definition](https://github.com/googlecodelabs/codelab-components/blob/master/google-codelab.html)
class Codelab {
  final String metadata;

  /// Codelab title
  final String title;

  /// Steps of the codelab
  final List<Step> steps;

  final List<StepSearch> stepSearch;

  /// Feedback URL for the codelab bug repors.
  String feedbackLink;

  Codelab(this.metadata, this.title, this.steps, this.stepSearch);

  @override
  String toString() => """
  {
    "metadata": "$metadata",
    "title": "$title",
    "steps": $steps,
    "feedbackLink": $feedbackLink
  }
  """;
}

/// Model related to
/// [google codelab step definition](https://github.com/googlecodelabs/codelab-components/blob/master/google-codelab-step.html).
class Step {

  String order;

  /// Title of this step.
  String label = '';

  /// How long, on average, it takes to complete the step.
  String duration = '0';

  /// Indicate if it is the last of the codelab.
  var isLast = false;

  /// The content as HTMLElement
  Element content = new Element.html("<br/>");

  Step(this.label);

  @override
  String toString() => """
  {
    "label": "$label",
    "content": "${content.innerHtml}",
    "isLast": "$isLast",
  }
  """;

  StepSearch getStepSearch(String codelab) {
    return new StepSearch(codelab, order, label, jsonEncode("${content.innerHtml}"));
  }
}

class StepSearch {
  String codelab;
  String order;
  String title;
  String content;
  String path = "";

  StepSearch(this.codelab, this.order, this.title, this.content);

  Map toJson() => {
        'codelab': this.codelab,
        'order': this.order,
        'title': this.title,
        'content': this.content,
        'path': "md/output.html#$order",
      };
}
