import 'dart:async';
import 'dart:html';
import 'package:angular_components/model/selection/string_selection_options.dart';
import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:md2codelab_ui/utils.dart' as js_interop;
import 'package:quiver/strings.dart' as quiver_strings;
import 'app_service.dart';

@Component(
  selector: 'my-app',
  styleUrls: const [
    'package:angular_components/app_layout/layout.scss.css',
    'app_component.scss.css'
  ],
  templateUrl: 'app_component.html',
  directives: [materialDirectives, NgFor, NgIf, NgStyle],
  providers: [
    materialProviders,
    const ClassProvider(AppService),
  ],
)
class AppComponent implements OnInit {

  static const String DEFAULT_APP_NAME = "APP_NAME";
  static const String DEFAULT_APP_WELCOME = "APP_WELCOME";
  static const String DEFAULT_APP_DESCRIPTION = "APP_DESCRIPTION";
  static const String DEFAULT_APP_AUTHOR = "APP_AUTHOR";
  static const String DEFAULT_APP_START_BUTTON = "START";

  /// Config
  String appName = DEFAULT_APP_NAME;
  String appWelcome = DEFAULT_APP_WELCOME;
  String appDescription = DEFAULT_APP_DESCRIPTION;
  String appAuthor = DEFAULT_APP_AUTHOR;
  String appStartButton = DEFAULT_APP_START_BUTTON;

  /// DROP DOWN CATEGORY SELECTION
  final String deselectLabel = 'All';
  final String selectionCategoryButton = "Select a category";
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

  List<Codelab> filteredDatas = <Codelab>[];
  Iterable<Codelab> datas = <Codelab>[];

  AppComponent(this.appService);

  @override
  Future<Null> ngOnInit() async {
    cfg = await appService.config();
    datas = await appService.codelabs();
    _configureMessages();
    _configureCategories();
    _initDatas();
  }

  String _getValue(dynamic value, String ifEmpty) =>
      value != null && quiver_strings.isEmpty(value.toString())
          ? ifEmpty
          : value.toString();

  void _configureMessages() {
    if (cfg != null &&
        cfg.messages != null &&
        cfg.messages.value != null &&
        cfg.messages.value.isNotEmpty) {
      Map value;
      value = cfg.messages.value;
      appName = _getValue(value["name"], DEFAULT_APP_NAME);
      appWelcome = _getValue(value["welcome"], DEFAULT_APP_WELCOME);
      appDescription = _getValue(value["description"], DEFAULT_APP_DESCRIPTION);
      appAuthor = _getValue(value["author"], DEFAULT_APP_AUTHOR);
      appStartButton =
          _getValue(value["start_button"], DEFAULT_APP_START_BUTTON);
    }
  }

  void _configureCategories() {
    List values;
    if ((cfg != null && cfg.categories != null && cfg.categories.value != null)) {
      values = cfg.categories.value.values.toList();
    } else {
      values = [];
    }
    // Ensure type checking to String
    values.forEach((data){
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

    String key;
    key = appService.categoryKeyByValue(
        cfg, selectionCategoryModel.selectedValues.first);
    if (quiver_strings.isEmpty(key)) {
      filteredDatas = datas.toList();
    } else {
      filteredDatas = datas.where((codelab) {
        return codelab.category == key;
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

      res = (value != null && value[int.parse(key)] != null) ?
      res = value[int.parse(key)].toString() : "";
    }
    return res;
  }

  showLunr() {
    List<dynamic> list = js_interop.blablaTT("JavaScript");
    list.forEach((value) {
      print(value.ref.toString());
    });
  }

  int get width =>
      widthSelection.selectedValues.isNotEmpty
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
          : selectionCategoryButton;
}
