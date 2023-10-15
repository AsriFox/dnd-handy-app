import 'package:dnd_handy_flutter/json_objects.dart';
import 'package:dnd_handy_flutter/pages/article_page.dart';
import 'package:dnd_handy_flutter/pages/reflist_item.dart';

ArticlePage proficiencyArticlePage(JsonObject json) {
  final races = [for (var it in json['races']) DndRef.fromJson(it)]
      .map((it) => '[${it.name}](${it.url})');
  final classes = [for (var it in json['classes']) DndRef.fromJson(it)]
      .map((it) => '[${it.name}](${it.url})');
  final ref = DndRef.fromJson(json['reference']);

  return ArticlePage.lines([
    "**Type**: ${json['type']}",
    '**Subject**: [${ref.name}](${ref.url})',
    if (races.isNotEmpty) "**Races**: ${races.join(', ')}",
    if (classes.isNotEmpty) "**Classes**: ${classes.join(', ')}",
  ]);
}
