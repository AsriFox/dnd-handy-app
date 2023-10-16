import 'package:dnd_handy_flutter/json_objects.dart';
import 'package:dnd_handy_flutter/pages/article_page.dart';
import 'package:dnd_handy_flutter/pages/reflist_item.dart';

// TODO: Finish and Convert to standalone page
ArticlePage monsterArticlePage(JsonObject json) {
  final abilities = ['str', 'dex', 'con', 'int', 'wis', 'cha']
      .map((index) => DndRef(
            index: index,
            name: index.toUpperCase(),
            url: '/api/ability-scores/$index}',
          ))
      .map((it) => '[${it.name}](${it.url})');

  final List<int> abilityScores = [
    json['strength'],
    json['dexterity'],
    json['constitution'],
    json['intelligence'],
    json['wisdom'],
    json['charisma'],
  ];

  final speed = [
    for (var it in (json['speed'] as JsonObject).entries)
      '${it.key} ${it.value}',
  ];

  armorClass(json) {
    final value = json['value'] as int;
    switch (json['type']) {
      case 'dex':
        return '$value (DEX)';
      case 'natural':
        return '$value (natural)';
      case 'armor':
        final armor = [for (var it in json['armor']) DndRef.fromJson(it)];
        return "$value (${armor.join(', ')})";
      case 'spell':
        final spell = DndRef.fromJson(json['spell']);
        return '$value ([${spell.name}](${spell.url}))';
      case 'condition':
        final condition = DndRef.fromJson(json['condition']);
        return '$value ([${condition.name}](${condition.url}))';
      default:
        return '$value';
    }
  }

  final armor = [for (var it in json['armor_class']) armorClass(it)];

  // final imageLink = json.containsKey('image')
  //     ? Uri.https('dnd5eapi.co', json['image'])
  //     : null;

  return ArticlePage.lines([
    // if (imageLink != null) "![]($imageLink '${json['name']}')",
    if (json['desc'] is String?) json['desc'] ?? '' else ...json['desc'],
    "**Type**: ${json['type']}",
    if (json.containsKey('subtype')) "**Subtype**: ${json['subtype']}",
    "| ${abilities.join(' | ')} |",
    '| --- | --- | --- | --- | --- | --- |',
    "| ${abilityScores.join(' | ')} |",
    "**Alignment**: ${json['alignment']}",
    "**Size**: ${json['size']}",
    "**Challenge rating**: ${json['challenge_rating']} (${json['xp']} xp)",
    "**Speed**: ${speed.join('; ')}",
    "**Health**: ${json['hit_points_roll']} (${json['hit_points']})",
    '**Armor**: ${armor.join('; ')}',
    "**Languages**: ${json['languages']}",
  ]);
}
