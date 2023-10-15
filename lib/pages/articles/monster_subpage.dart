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
    '**Speed**:',
    for (var it in (json['speed'] as JsonObject).entries)
      ' ${it.key} ${it.value};',
  ].join();

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
    speed,
    "**Health**: ${json['hit_points_roll']} (${json['hit_points']})",
    "**Armor class**: ${json['armor_class']}",
    "**Languages**: ${json['languages']}",
  ]);
}
