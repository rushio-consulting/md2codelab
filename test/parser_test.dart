//import 'dart:convert';
import 'package:test/test.dart';
import 'package:md2codelab/src/models.dart';
import 'package:md2codelab/src/parser.dart';

void main() {
  test("parse", () async {
    String htmlContent;
    String codelabToString;

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

    Codelab codelab = parse(htmlContent, "");

    codelabToString = '''
  {
    "metadata": "",
    "title": "Doc",
    "steps": [  {
    "order": "1",
    "label": "Emphasis",
    "duration": "0",
    "content": "<h3>Bold</h3><p>For emphasizing a snippet of text with a heavier font-weight.</p><p>The following snippet of text is <strong>rendered as bold text</strong>.</p><pre><code class="language-markdown">**rendered as bold text**
</code></pre><p>renders to:</p><p><strong>rendered as bold text</strong></p><p>and this HTML</p><pre><code class="language-html">&lt;strong&gt;rendered as bold text&lt;/strong&gt;
</code></pre><h3>Italics</h3><p>For emphasizing a snippet of text with italics.</p><p>The following snippet of text is <em>rendered as italicized text</em>.</p><pre><code class="language-markdown">_rendered as italicized text_
</code></pre><p>renders to:</p><p><em>rendered as italicized text</em></p><p>and this HTML:</p><pre><code class="language-html">&lt;em&gt;rendered as italicized text&lt;/em&gt;
</code></pre>",
    "isLast": "true",
  }
  ],
    "stepSearch": [  {
    "codelab": "Doc",
    "order": "1",
    "title": "Emphasis",
    "content": ""<h3>Bold</h3><p>For emphasizing a snippet of text with a heavier font-weight.</p><p>The following snippet of text is <strong>rendered as bold text</strong>.</p><pre><code class=\\"language-markdown\\">**rendered as bold text**\\n</code></pre><p>renders to:</p><p><strong>rendered as bold text</strong></p><p>and this HTML</p><pre><code class=\\"language-html\\">&lt;strong&gt;rendered as bold text&lt;/strong&gt;\\n</code></pre><h3>Italics</h3><p>For emphasizing a snippet of text with italics.</p><p>The following snippet of text is <em>rendered as italicized text</em>.</p><pre><code class=\\"language-markdown\\">_rendered as italicized text_\\n</code></pre><p>renders to:</p><p><em>rendered as italicized text</em></p><p>and this HTML:</p><pre><code class=\\"language-html\\">&lt;em&gt;rendered as italicized text&lt;/em&gt;\\n</code></pre>"",
    "outputFileName": "",
    "path": "",
  }
  ],
    "feedbackLink": null
  }
  ''';

    expect(codelabToString, codelab.toString());
  });
}
