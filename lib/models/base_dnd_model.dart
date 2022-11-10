import 'dnd_article_model.dart';
import 'dnd_reflist_model.dart';

class BaseDndModel {
  const BaseDndModel({
    this.index,
    this.name,
    this.url,
  });

  final String? index;
  final String? name;
  final String? url;

  BaseDndModel.fromJson(Map<String, dynamic> json) 
    : this(
      index: json['index'] as String?,
      name: json['name'] as String?,
      url: json['url'] as String?,
    );

  factory BaseDndModel.generate(Map<String, dynamic> json) {
    if (json.containsKey('desc')) {
      return DndArticle.fromJson(json);
    }
    if (json.containsKey('results')) {
      return DndRefList.fromJsonArray(json['results']);
    }
    return BaseDndModel.fromJson(json);
  }
}