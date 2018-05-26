import 'dart:async';
import 'dart:convert';
import 'dart:html';

import 'package:yaml/yaml.dart';
import 'package:angular/core.dart';

class AppConfig {
  YamlMap messages;
  YamlMap categories;
  YamlMap categoriesColors;
  YamlMap categoriesIcons;

  AppConfig(
      this.messages, this.categories, this.categoriesColors, this.categoriesIcons);
}

class Codelab {
  String name;
  String description;
  String category;
  String duration;
  String path;

  Codelab.fromJson(Map json) {
    this.name = json['name'].toString();
    this.description = json['description'].toString();
    this.category = json['category'].toString();
    this.duration = json['duration'].toString();
    this.path = json['path'].toString();
  }
}

@Injectable()
class AppService {
  Future _readConfig() async {
    var doc = await HttpRequest.getString("config.yaml");
    return loadYaml(doc.toString());
  }

  Future<Iterable<Codelab>> codelabs() async {
    String asJson;
    List<Codelab> res;
    res = [];
    asJson = await HttpRequest.getString('md.json');

    List<Map> mapList = json.decode(asJson);
    mapList.forEach((json) {
      res.add(new Codelab.fromJson(json));
    });
    return res.take(res.length);
  }

  Future<AppConfig> config() async {

    YamlMap messages;
    YamlMap categories;
    YamlMap categoriesColors;
    YamlMap categoriesIcons;

    YamlMap map = await _readConfig();
    if (map != null) {
      map.nodes.forEach((key, value) {
        switch (key.toString()) {
          case 'messages':
            messages = value as YamlMap;
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
      return new AppConfig(messages, categories, categoriesColors, categoriesIcons);
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
