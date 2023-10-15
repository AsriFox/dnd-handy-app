import 'package:dnd_handy_flutter/json_objects.dart';
import 'package:dnd_handy_flutter/pages/article_page.dart';
import 'package:dnd_handy_flutter/pages/reflist_item.dart';

ArticlePage rulesArticlePage(JsonObject json) {
  final subsections = [for (var it in json['subsections']) DndRef.fromJson(it)];
  return ArticlePage.lines([
    json['desc'],
    '**Subsections**:',
    for (var it in subsections) '- [${it.name}](${it.url})',
  ]);
}
