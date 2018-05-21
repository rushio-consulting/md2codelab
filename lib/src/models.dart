import 'package:html/dom.dart';

/// Model related to
/// [google codelab definition](https://github.com/googlecodelabs/codelab-components/blob/master/google-codelab.html)
class Codelab {
  /**
   * Codelab title
   */
  final String title;

  /**
   * Steps of the codelab
   */
  final List<Step> steps;

  /**
   * Feedback URL for the codelab bug repors.
   */
  String feedbackLink;

  Codelab(this.title, this.steps);

  @override
  String toString() => """
  {
    "title": "$title",
    "steps": $steps,
    "feedbackLink": $feedbackLink
  }
  """;
}

/// Model related to
/// [google codelab step definition](https://github.com/googlecodelabs/codelab-components/blob/master/google-codelab-step.html).
class Step {

  /**
   * Title of this step.
   */
  String label = '';

  /**
   * How long, on average, it takes to complete the step.
   */
  String duration = '0';

  /**
   * Indicate if it is the last of the codelab.
   */
  bool isLast = false;

  /**
   * The content as HTMLElement
   */
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
}
