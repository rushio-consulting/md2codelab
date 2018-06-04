import 'package:html/parser.dart' as html5parser;
import 'package:html/dom.dart';
import 'package:intl/intl.dart';
import 'models.dart';

const String METADATA = "metadata";
const String DURATION = "duration";
const String ALTER_SUCCESS = "alert-success";
const String ALTER_INFO = "alert-info";
const String ALTER_WARNING = "alert-warning";
const String ALTER_DANGER = "alert-danger";

/// Check if the given [node] is a metadata
bool _isMetadata(Element node) =>
    (node.innerHtml.startsWith("<$METADATA>") &&
        node.innerHtml.endsWith("</$METADATA>")) ||
    node.localName == "metadata";

/// Check if the given [node] is a duration
bool _isDuration(Element node) =>
    node.innerHtml.startsWith("<$DURATION>") &&
    node.innerHtml.endsWith("</$DURATION>");

/// Check if the given [node] is an info success
bool _isAlertSuccess(Element node) =>
    node.innerHtml.startsWith("<$ALTER_SUCCESS>") &&
    node.innerHtml.endsWith("</$ALTER_SUCCESS>");

/// Check if the given [node] is an info alert
bool _isAlertInfo(Element node) =>
    node.innerHtml.startsWith("<$ALTER_INFO>") &&
    node.innerHtml.endsWith("</$ALTER_INFO>");

/// Check if the given [node] is a warning alert
bool _isAlertWarning(Element node) =>
    node.innerHtml.startsWith("<$ALTER_WARNING>") &&
    node.innerHtml.endsWith("</$ALTER_WARNING>");

/// Check if the given [node] is a danger alert
bool _isAlertDanger(Element node) =>
    node.innerHtml.startsWith("<$ALTER_DANGER>") &&
    node.innerHtml.endsWith("</$ALTER_DANGER>");

/// Get the define metadata form the given [innerHtml]
String _getMetadata(String innerHtml) {
  return innerHtml.trim();
}

/// Get the define duration form the given [innerHtml]
String _getDuration(String innerHtml) {
  DateFormat format;
  String text;
  DateTime datetime;

  format = new DateFormat("H:mm");
  text = innerHtml.replaceFirst("<$DURATION>", "");
  text = text.replaceFirst("</$DURATION>", "");
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
Codelab parse(String htmlContent, String outputFileName) {
  Document document;
  Element body;
  int stepSize;
  int index;
  Step currentStep;
  List<Step> steps;
  List<StepSearch> stepSearch;
  String title;
  String metadata;

  metadata = "";
  document = html5parser.parse(htmlContent);
  body = document.body;
  Element h1Element = body.querySelector("h1");
  if(h1Element == null){
    throw new Exception("no H1 head find in the File. You must provide one !");
  }

  title = h1Element.innerHtml;
  stepSize = body.querySelectorAll("h2").length;
  index = 0;
  steps = [];
  stepSearch = [];

  body.nodes.forEach((node) {
    if (node is Element) {
      if (_isMetadata(node)) {
        metadata = _getMetadata(node.innerHtml);
      } else {
        if (node.localName == "h2") {
          index++;
          if (currentStep != null) {
            stepSearch.add(currentStep.getStepSearch(title,outputFileName));
          }
          currentStep = new Step(node.innerHtml);
          currentStep.order = index.toString();
          if (index == stepSize) {
            currentStep.isLast = true;
          }
          steps.add(currentStep);
        } else if (currentStep != null) {
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
    }
  });

  // Last one for search
  if (currentStep != null && currentStep.isLast) {
    stepSearch.add(currentStep.getStepSearch(title, outputFileName));
  }

  return new Codelab(metadata, title, steps, stepSearch);
}
