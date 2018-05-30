import 'dart:async';
import 'dart:html';
import 'package:angular_components/model/selection/string_selection_options.dart';
import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:md2codelab_ui/utils.dart' as js_interop;
import 'package:quiver/strings.dart' as quiver_strings;
import 'package:quiver/core.dart' as quiver_core;
import 'app_service.dart';

class SearchResult {
  String path;
  String title;
  String codelab;

  SearchResult(this.path, this.title, this.codelab);

  bool operator ==(o) => o is SearchResult && path == o.path;

  int get hashCode => quiver_core.hash2(path.hashCode, path.hashCode);
}

@Component(
  selector: 'my-app',
  styleUrls: const [
    'package:angular_components/app_layout/layout.scss.css',
    'app_component.css'
  ],
  templateUrl: 'app_component.html',
  directives: [materialDirectives, NgFor, NgIf, NgStyle],
  providers: [
    materialProviders,
    const ClassProvider(AppService),
  ],
)
class AppComponent implements OnInit {
  static const String DEFAULT_LOCATION = "http://unknow/";
  static const String DEFAULT_APP_NAME = "APP_NAME";
  static const String DEFAULT_APP_WELCOME = "APP_WELCOME";
  static const String DEFAULT_APP_DESCRIPTION = "APP_DESCRIPTION";
  static const String DEFAULT_APP_AUTHOR = "APP_AUTHOR";
  static const String DEFAULT_APP_START_BUTTON = "START";
  static const String DEFAULT_APP_SELECT_CATEGORY = "Select a category";
  static const String DEFAULT_APP_DESELECT_ALL = "All";

  /// Config
  String appLocation = DEFAULT_LOCATION;
  String appName = DEFAULT_APP_NAME;
  String appWelcome = DEFAULT_APP_WELCOME;
  String appDescription = DEFAULT_APP_DESCRIPTION;
  String appAuthor = DEFAULT_APP_AUTHOR;
  String appStartButtonLabel = DEFAULT_APP_START_BUTTON;
  String appSelectCategoryLabel = DEFAULT_APP_SELECT_CATEGORY;
  String appDeselectAllLabel = DEFAULT_APP_DESELECT_ALL;

  /// DROP DOWN CATEGORY SELECTION
  final bool deselectOnActivate = true;
  static List<String> categories = <String>[];

  StringSelectionOptions<String> selectionCategoriesOptions =
      new StringSelectionOptions(categories);

  final SelectionModel<String> selectionCategoryModel =
      new SelectionModel.single();

  final SelectionModel<int> widthSelection = new SelectionModel<int>.single();

  ///
  final AppService appService;
  AppConfig cfg;

  Iterable<Codelab> filteredDatas = <Codelab>[];
  Iterable<Codelab> datas = <Codelab>[];
  Iterable<CodelabSearch> datasSearch = <CodelabSearch>[];

  var index;

  String filterValue;

  ///
  Set<SearchResult> searchResults = new Set();

  String selectionCategoryModelKey;

  AppComponent(this.appService);

  @override
  Future<Null> ngOnInit() async {
    cfg = await appService.config();
    datas = await appService.codelabs();
    datasSearch = await appService.codelabsSearch();
    _configureMessages();
    _configureCategories();
    _initDatas();
  }

  String _getValue(dynamic value, String ifEmpty) =>
      value == null || quiver_strings.isEmpty(value.toString())
          ? ifEmpty
          : value.toString() ;

  void _configureMessages() {
    if (cfg != null &&
        cfg.global != null &&
        cfg.global.value != null &&
        cfg.global.value.isNotEmpty) {
      Map value;
      value = cfg.global.value;
      appLocation = _getValue(value["location"], DEFAULT_LOCATION);
      appName = _getValue(value["name"], DEFAULT_APP_NAME);
      appWelcome = _getValue(value["welcome"], DEFAULT_APP_WELCOME);
      appDescription = _getValue(value["description"], DEFAULT_APP_DESCRIPTION);
      appAuthor = _getValue(value["author"], DEFAULT_APP_AUTHOR);
      appStartButtonLabel =
          _getValue(value["start_button_label"], DEFAULT_APP_START_BUTTON);
      appSelectCategoryLabel =
          _getValue(value["select_category_label"], DEFAULT_APP_SELECT_CATEGORY);
      appDeselectAllLabel =
          _getValue(value["deselect_category_label"], DEFAULT_APP_DESELECT_ALL);
    }
  }

  void _configureCategories() {
    List values;
    if ((cfg != null &&
        cfg.categories != null &&
        cfg.categories.value != null)) {
      values = cfg.categories.value.values.toList();
    } else {
      values = [];
    }
    // Ensure type checking to String
    values.forEach((data) {
      categories.add(data.toString());
    });
    selectionCategoriesOptions = new StringSelectionOptions(categories);
    selectionCategoryModel.clear();
  }

  void _initDatas() {
    filteredDatas = datas.toList();
    selectionCategoryModel.selectionChanges
        .listen((onData) => _onSelectionCategoryModelChange());
  }

  void _onSelectionCategoryModelChange() {
    if (selectionCategoryModel.isEmpty) {
      filteredDatas = datas.toList();
      return;
    }

    selectionCategoryModelKey = appService.categoryKeyByValue(
        cfg, selectionCategoryModel.selectedValues.first);
    if (quiver_strings.isEmpty(selectionCategoryModelKey)) {
      filteredDatas = datas.toList();
    } else {
      filteredDatas = datas.where((codelab) {
        return codelab.category == selectionCategoryModelKey;
      }).toList();
    }
  }

  String getUrl(String path) => "${window.location}$path";

  String getCategoryBg(String key) =>
      "#" + appService.categoryColorByKey(cfg, key);

  String getCategoryIcon(String key) =>
      "url(" + "\"icons/" + appService.categoryIconsByKey(cfg, key) + "\")";

  String getCategoryValueByKey(String key) {
    String res;
    res = "";
    if (cfg != null && cfg.categories != null) {
      Map value;
      value = cfg.categories.value;

      res = (value != null && value[int.parse(key)] != null)
          ? res = value[int.parse(key)].toString()
          : "";
    }
    return res;
  }

  int get width => widthSelection.selectedValues.isNotEmpty
      ? widthSelection.selectedValues.first
      : null;

  String get singleSelectedCategory =>
      selectionCategoryModel.selectedValues.isNotEmpty
          ? selectionCategoryModel.selectedValues.first
          : null;

  /// Label for the button for single selection.
  String get selectionCategoryLabel =>
      selectionCategoryModel.selectedValues.length > 0
          ? selectionCategoryModel.selectedValues.first
          : appSelectCategoryLabel;

  void onSearch(dynamic event) {
    if (quiver_strings.isEmpty(event.target.value.toString())) {
      searchResults.clear();
      return;
    }

    searchResults.clear();
    var lunrJsResult = js_interop.search(event.target.value.toString());
    lunrJsResult.forEach((entry) {
      String path;
      if (entry != null && entry.ref != null) {
        path = entry.ref.toString();
        searchResults.add(new SearchResult(
            path, _entrySearch(path).title, _entrySearch(path).codelab));
      }
    });
  }

  void onFilter(dynamic event) => filterValue = event.target.value.toString();

  getDatas() {
    if (quiver_strings.isEmpty(filterValue)) {
      return filteredDatas;
    }

    return  filteredDatas.where((codelab) {
      return codelab.name.toLowerCase().contains(filterValue.toLowerCase());
    });
  }

  CodelabSearch _entrySearch(String path) {
    return datasSearch.firstWhere((entry) {
      return entry.path == path;
    });
  }

  startCodelab(path) => window.open("$appLocation/$path", "_blank");

  bool hasDuration(String duration) =>
      quiver_strings.isNotEmpty(duration) && duration != "null";
}
