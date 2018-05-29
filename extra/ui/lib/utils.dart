@JS()
library jsinterop;

import "package:js/js.dart";

@JS()
@anonymous
class SearchResult {
  external String get ref;
  external factory SearchResult({String ref});
}

@JS("search")
external List<SearchResult> search(value);
