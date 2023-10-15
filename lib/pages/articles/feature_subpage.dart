import 'package:dnd_handy_flutter/json_objects.dart';
import 'package:dnd_handy_flutter/pages/article_page.dart';
import 'package:dnd_handy_flutter/pages/reflist_item.dart';

ArticlePage featureArticlePage(JsonObject json) {
  final classRef = DndRef.fromJson(json['class']);
  final subclassRef =
      json.containsKey('subclass') ? DndRef.fromJson(json['subclass']) : null;
  final prerequisites = json.containsKey('prerequisites')
      ? {
          for (var it in json['prerequisites'])
            DndRef.fromJson(it['skill']): it['minimum_score'] as int
        }
      : {};

  return ArticlePage.lines([
    "**Level**: ${json['level']}",
    ...json['desc'],
    '**Class**: [${classRef.name}](${classRef.url})',
    if (subclassRef != null)
      '**Subclass**: [${subclassRef.name}](${subclassRef.url})',
    if (prerequisites.isNotEmpty) '**Prerequisites**:',
    for (var it in prerequisites.entries)
      '- [${it.key.name}](${it.key.url}): ${it.value}',
  ]);
}
