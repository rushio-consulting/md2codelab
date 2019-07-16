import 'dart:async';
import 'dart:convert';
import 'dart:html';

import 'package:yaml/yaml.dart';
import 'package:angular/core.dart';

class AppConfig {
  YamlMap global;
  YamlMap categories;
  YamlMap categoriesColors;
  YamlMap categoriesIcons;

  AppConfig(this.global, this.categories, this.categoriesColors,
      this.categoriesIcons);
}

class CodelabSearch {
  String codelab;
  String order;
  String title;
  String path;

  CodelabSearch.fromJson(dynamic json) {
    this.codelab = json['codelab'].toString();
    this.order = json['order'].toString();
    this.title = json['title'].toString();
    this.path = json['path'].toString();
  }
}

class Codelab {
  String name;
  String description;
  String category;
  String duration;
  String path;

  Codelab.fromJson(dynamic json) {
    this.name = json['name'].toString();
    this.description = json['description'].toString();
    this.category = json['category'].toString();
    this.duration = json['duration'].toString();
    this.path = json['path'].toString();
  }
}

@Injectable()
class AppService {
  _readConfig() async {
    var doc = await HttpRequest.getString("config.yaml");
    return loadYaml(doc.toString());
  }

  Future<Iterable<Codelab>> codelabs() async {
    String asJson;
    List<Codelab> res;
    res = [];
    asJson = await HttpRequest.getString('md.json');

    var mapList = json.decode(asJson);
    mapList.forEach((json) {
      res.add(new Codelab.fromJson(json));
    });
    return res.take(res.length);
  }

  Future<Iterable<CodelabSearch>> codelabsSearch() async {
    String asJson;
    List<CodelabSearch> res;
    res = [];
    asJson = await HttpRequest.getString('md_search.json');

    var mapList = json.decode(asJson);
    mapList.forEach((json) {
      res.add(new CodelabSearch.fromJson(json));
    });
    return res.take(res.length);
  }

  Future<AppConfig> config() async {
    YamlMap global;
    YamlMap categories;
    YamlMap categoriesColors;
    YamlMap categoriesIcons;

    var map = await _readConfig();
    if (map != null) {
      map.nodes.forEach((key, value) {
        switch (key.toString()) {
          case 'global':
            global = value as YamlMap;
            break;
          case 'categories':
            categories = value as YamlMap;
            break;
          case 'categories_colors':
            categoriesColors = value as YamlMap;
            break;
          case 'categories_icons':
            categoriesIcons = value as YamlMap;
            break;
          default:
            break;
        }
      });
      return new AppConfig(
          global, categories, categoriesColors, categoriesIcons);
    }
    return null;
  }

  String categoryKeyByValue(AppConfig cfg, String value) {
    String res;
    res = "";
    if (cfg != null && cfg.categories != null && cfg.categories.value != null) {
      cfg.categories.nodes.forEach((key, node) {
        if (value == node.value.toString()) {
          res = key.toString();
        }
      });
    }
    return res;
  }

  String categoryColorByKey(AppConfig cfg, String value) {
    String res;
    res = "";
    if (cfg != null &&
        cfg.categoriesColors != null &&
        cfg.categoriesColors.value != null) {
      cfg.categoriesColors.nodes.forEach((key, node) {
        if (value == key.toString()) {
          res = node.value.toString();
        }
      });
    }
    return res;
  }

  String categoryIconsByKey(AppConfig cfg, String value) {
    String res;
    res = "";
    if (cfg != null &&
        cfg.categoriesIcons != null &&
        cfg.categoriesIcons.value != null) {
      cfg.categoriesIcons.nodes.forEach((key, node) {
        if (value == key.toString()) {
          res = node.value.toString();
        }
      });
    }
    return res;
  }
}
