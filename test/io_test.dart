//import 'dart:convert';
import 'package:md2codelab/src/io.dart';
import 'package:test/test.dart';

void main() {

  test("readMarkdownToHtml", () async {
    String inputMdContent;
    String expectedHtmlContent;

    inputMdContent = """
# Doc

## Emphasis

### Bold
For emphasizing a snippet of text with a heavier font-weight.

The following snippet of text is **rendered as bold text**.

``` markdown
**rendered as bold text**
```
renders to:

**rendered as bold text**

and this HTML

``` html
<strong>rendered as bold text</strong>
```

### Italics
For emphasizing a snippet of text with italics.

The following snippet of text is _rendered as italicized text_.

``` markdown
_rendered as italicized text_
```

renders to:

_rendered as italicized text_

and this HTML:

``` html
<em>rendered as italicized text</em>
```
    """;

    expectedHtmlContent = '''<h1>Doc</h1>
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

    expect(readMarkdownToHtml(inputMdContent), expectedHtmlContent);

  });
}
