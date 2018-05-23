import 'package:html/parser.dart' as html5parser;
import 'package:html/dom.dart';
import 'package:intl/intl.dart';
import 'models.dart';

/// Check if the given [node] is a duration
bool _isDuration(Element node) =>
    node.innerHtml.startsWith("<duration>") &&
    node.innerHtml.endsWith("</duration>");

/// Check if the given [node] is an info success
bool _isAlertSuccess(Element node) =>
    node.innerHtml.startsWith("<alert-success>") &&
        node.innerHtml.endsWith("</alert-success>");

/// Check if the given [node] is an info alert
bool _isAlertInfo(Element node) =>
    node.innerHtml.startsWith("<alert-info>") &&
    node.innerHtml.endsWith("</alert-info>");

/// Check if the given [node] is a warning alert
bool _isAlertWarning(Element node) =>
    node.innerHtml.startsWith("<alert-warning>") &&
    node.innerHtml.endsWith("</alert-warning>");

/// Check if the given [node] is a danger alert
bool _isAlertDanger(Element node) =>
    node.innerHtml.startsWith("<alert-danger>") &&
    node.innerHtml.endsWith("</alert-danger>");

/// Get the define duration form the given [innerHtml]
String _getDuration(String innerHtml) {
  DateFormat format;
  String text;
  DateTime datetime;

  format = new DateFormat("H:mm");
  text = innerHtml.replaceFirst("<duration>", "");
  text = text.replaceFirst("</duration>", "");
  datetime = format.parse(text.trim());

  return datetime.minute.toString();
}

/// Get the define success alert form the given [innerHtml]
String _getAlertSuccess(String innerHtml) => """
  <div class="alert alert-success flexbox-it" role="alert">
    <div> <span title="Success" class="oi oi-check oi-custom"></span></div>
    <div>$innerHtml</div>
  </div>
""";

/// Get the define info alert form the given [innerHtml]
String _getAlertInfo(String innerHtml) => """
  <div class="alert alert-primary flexbox-it" role="alert">
    <div> <span title="Note" class="oi oi-info oi-custom"></span></div>
    <div>$innerHtml</div>
  </div>
""";

/// Get the define warning alert form the given [innerHtml]
String _getAlertWarning(String innerHtml) => """
  <div class="alert alert-warning flexbox-it" role="alert">
    <div> <span title="Warning" class=" oi oi-warning oi-custom"></span></div>
    <div>$innerHtml</div>
  </div>
""";

/// Get the define danger alert form the given [innerHtml]
String _getAlertDanger(String innerHtml) => """
  <div class="alert alert-danger flexbox-it" role="alert">
    <div> <span title="Important" class=" oi oi-fire oi-custom"></span></div>
    <div>$innerHtml</div>
  </div>
""";

/// Parse the given [htmlContent] to a codelab
Codelab parse(String htmlContent) {
  Document document;
  Element body;
  int stepSize;
  int index;
  Step currentStep;
  List<Step> steps;
  String title;

  document = html5parser.parse(htmlContent);
  body = document.body;
  title = body.querySelector("h1").innerHtml;
  stepSize = body.querySelectorAll("h2").length;
  index = 0;
  steps = [];

  body.nodes.forEach((node) {
    if (node is Element) {
      if (node.localName == "h2") {
        index++;
        currentStep = new Step(node.innerHtml);
        if (index == stepSize) {
          currentStep.isLast = true;
        }
        steps.add(currentStep);
      } else if (currentStep != null) {
        // Duration
        if (_isDuration(node)) {
          currentStep.duration = _getDuration(node.innerHtml);
        } else {
          // alert success
          if (_isAlertSuccess(node)) {
            node.innerHtml = _getAlertSuccess(node.innerHtml);
          }
          // alert info
          if (_isAlertInfo(node)) {
            node.innerHtml = _getAlertInfo(node.innerHtml);
          }
          // alert warning
          if (_isAlertWarning(node)) {
            node.innerHtml = _getAlertWarning(node.innerHtml);
          }
          // alert danger
          if (_isAlertDanger(node)) {
            node.innerHtml = _getAlertDanger(node.innerHtml);
          }

          currentStep.content.append(node.clone(true));
        }
      }
    }
  });

  return new Codelab(title, steps);
}
