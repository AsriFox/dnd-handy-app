import 'package:dnd_handy_flutter/json_objects.dart';
import 'package:dnd_handy_flutter/pages/article_page.dart';
import 'package:dnd_handy_flutter/pages/reflist_item.dart';

ArticlePage abilityArticlePage(JsonObject json) {
  final skills = [for (var it in json['skills']) DndRef.fromJson(it)];
  return ArticlePage.lines([
    ...json['desc'],
    '**Associated skills**:',
    ...skills.map((ref) => '- [${ref.name}](${ref.url})'),
  ]);
}
