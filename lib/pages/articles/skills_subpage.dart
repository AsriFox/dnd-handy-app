import 'package:dnd_handy_flutter/json_objects.dart';
import 'package:dnd_handy_flutter/pages/article_page.dart';
import 'package:dnd_handy_flutter/pages/reflist_item.dart';

ArticlePage skillArticlePage(JsonObject json) {
  final ability = DndRef.fromJson(json['ability_score']);
  return ArticlePage.lines([
    ...json['desc'],
    '**Governing ability**: [${ability.name}](${ability.url})',
  ]);
}
