import 'package:dnd_handy_flutter/json_objects.dart';
import 'package:dnd_handy_flutter/pages/article_page.dart';
import 'package:dnd_handy_flutter/pages/reflist_item.dart';

ArticlePage magicItemArticlePage(JsonObject json) {
  final equipmentCategory = DndRef.fromJson(json['equipment_category']);
  final variants = [for (var it in json['variants']) DndRef.fromJson(it)];
  return ArticlePage.lines([
    ...json['desc'],
    '**Category**: [${equipmentCategory.name}](${equipmentCategory.url})',
    "**Rarity**: ${json['rarity']['name']}",
    if (json['variant'] as bool? ?? false) 'Is a variant',
    if (variants.isNotEmpty) '**Variants**:',
    for (var it in variants) '- [${it.name}](${it.url})',
  ]);
}
