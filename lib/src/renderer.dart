import 'models.dart';

String _renderDocument(String title, String webComponent) => '''
  <!doctype html>
  <html>
  <head>
      <meta name="viewport" content="width=device-width, minimum-scale=1.0, initial-scale=1.0, user-scalable=yes">
      <meta name="theme-color" content="#4F7DC9">
      <meta charset="UTF-8">
      <title>$title</title>
      <script src="bower_components/webcomponentsjs/webcomponents-lite.js"></script>
      <link rel="import" href="elements/codelab.html">
      <link rel="stylesheet" href="//fonts.googleapis.com/css?family=Source+Code+Pro:400|Roboto:400,300,400italic,500,700|Roboto+Mono">
      <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css" integrity="sha384-Gn5384xqQ1aoWXA+058RXPxPg6fy4IWvTNh0E263XmFcJlSAwiGgFAW/dAiS6JXm" crossorigin="anonymous">
      <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/open-iconic/1.1.1/font/css/open-iconic-bootstrap.min.css">
      <style is="custom-style">
          body {
              font-family: "Roboto",sans-serif;
              background: var(--google-codelab-background, #F8F9FA);
          }
          .oi-custom {
              font-size: 28px;
              margin-right: 20px;
          }
          .flexbox-it
          {
              display: flex;
          }
           #main-toolbar
        {
            background: #FFFFFF
            box-shadow: 0px 1px 2px 0px rgba(60, 64, 67, 0.3), 0px 2px 6px 2px rgba(60, 64, 67, 0.15);
            color: #3C4043;
            display: flex;
            align-items: center;
            justify-content: space-between;
            height: 64px;
            padding: 0 16px;
        }
      </style>
  </head>
  <body unresolved class="fullbleed">
    $webComponent
  </body>
  </html>
''';

String render(Codelab codelab) {
  var buffer = new StringBuffer();

  if (codelab.feedbackLink != null && codelab.feedbackLink.isNotEmpty) {
    buffer.write("<google-codelab title=\"${codelab
        .title}\" feedback-link=\"${codelab.feedbackLink}\">");
  } else {
    buffer.write("<google-codelab title=\"${codelab.title}\">");
  }

  codelab.steps.forEach((step) {
    buffer.write("<google-codelab-step "
        "label=\"${step.label}\" "
        "duration=\"${step.duration}\" >");
    buffer.write(step.content.innerHtml.toString());
    buffer.write(" </google-codelab-step>");
  });

  buffer.write("</google-codelab>");

  return _renderDocument(codelab.title, buffer.toString());
}
