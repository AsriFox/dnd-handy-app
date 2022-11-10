import 'package:dnd_handy_flutter/models/base_dnd_model.dart';

class DndArticle extends BaseDndModel {
  const DndArticle({
    super.index,
    super.name,
    super.url,
    this.desc
  });

  final List<String>? desc;

  factory DndArticle.fromJson(Map<String, dynamic> json) {
    List<String> desc = json['desc'] is Iterable<dynamic>
        ? List<String>.from(json['desc'] as Iterable<dynamic>)
        : List<String>.generate(1, (_) => json['desc'] as String);

    return DndArticle(
      index: json['index'] as String?,
      name: json['name'] as String?,
      url: json['url'] as String?,
      desc: desc,
    );
  }
}