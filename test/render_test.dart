//import 'dart:convert';
import 'package:test/test.dart';
import 'package:md2codelab/src/parser.dart';
import 'package:md2codelab/src/renderer.dart';

void main() {
  test("render", () async {
    String htmlContent;
    String outputHtml;

    htmlContent = '''<h1>Doc</h1>
<h2>Emphasis</h2>
<h3>Bold</h3>
<p>For emphasizing a snippet of text with a heavier font-weight.</p>
<p>The following snippet of text is <strong>rendered as bold text</strong>.</p>
<pre><code class="language-markdown">**rendered as bold text**
</code></pre>
<p>renders to:</p>
<p><strong>rendered as bold text</strong></p>
<p>and this HTML</p>
<pre><code class="language-html">&lt;strong&gt;rendered as bold text&lt;/strong&gt;
</code></pre>
<h3>Italics</h3>
<p>For emphasizing a snippet of text with italics.</p>
<p>The following snippet of text is <em>rendered as italicized text</em>.</p>
<pre><code class="language-markdown">_rendered as italicized text_
</code></pre>
<p>renders to:</p>
<p><em>rendered as italicized text</em></p>
<p>and this HTML:</p>
<pre><code class="language-html">&lt;em&gt;rendered as italicized text&lt;/em&gt;
</code></pre>
''';

    outputHtml = '''
  <!doctype html>
  <html>
  <head>
      <meta name="viewport" content="width=device-width, minimum-scale=1.0, initial-scale=1.0, user-scalable=yes">
      <meta name="theme-color" content="#4F7DC9">
      <meta charset="UTF-8">
      <title>Doc</title>
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
          blockquote 
          {
              font-style: normal;
              font-size: 12px;
              margin-left: 32px;
              font-family: Consolas, "Times New Roman", Verdana;
              border-left: 4px solid #CCC;
              padding-left: 8px;
          }
      </style>
  </head>
  <body unresolved class="fullbleed">
    <google-codelab title="Doc"><google-codelab-step label="Emphasis" duration="0" ><h3>Bold</h3><p>For emphasizing a snippet of text with a heavier font-weight.</p><p>The following snippet of text is <strong>rendered as bold text</strong>.</p><pre><code class="language-markdown">**rendered as bold text**
</code></pre><p>renders to:</p><p><strong>rendered as bold text</strong></p><p>and this HTML</p><pre><code class="language-html">&lt;strong&gt;rendered as bold text&lt;/strong&gt;
</code></pre><h3>Italics</h3><p>For emphasizing a snippet of text with italics.</p><p>The following snippet of text is <em>rendered as italicized text</em>.</p><pre><code class="language-markdown">_rendered as italicized text_
</code></pre><p>renders to:</p><p><em>rendered as italicized text</em></p><p>and this HTML:</p><pre><code class="language-html">&lt;em&gt;rendered as italicized text&lt;/em&gt;
</code></pre> </google-codelab-step></google-codelab>
  </body>
  </html>
''';
    expect(outputHtml, render(parse(htmlContent, "")));
  });
}
