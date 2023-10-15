import 'package:dnd_handy_flutter/json_objects.dart';
import 'package:dnd_handy_flutter/pages/article_page.dart';
import 'package:dnd_handy_flutter/pages/reflist_item.dart';

ArticlePage featArticlePage(JsonObject json) {
  final prerequisites = {
    for (var it in json['prerequisites'])
      DndRef.fromJson(it['ability_score']): it['minimum_score'] as int
  };
  return ArticlePage.lines([
    ...json['desc'],
    '**Prerequisites**:',
    for (var it in prerequisites.entries)
      '- [${it.key.name}](${it.key.url}): ${it.value}',
  ]);
}
