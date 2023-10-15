import 'package:dnd_handy_flutter/json_objects.dart';
import 'package:dnd_handy_flutter/pages/article_page.dart';
import 'package:dnd_handy_flutter/pages/reflist_item.dart';

ArticlePage spellArticlePage(JsonObject json) {
  final classes = [for (var it in json['classes']) DndRef.fromJson(it)]
      .map((it) => '[${it.name}](${it.url})');
  final subclasses = [for (var it in json['subclasses']) DndRef.fromJson(it)]
      .map((it) => '[${it.name}](${it.url})');
  final school = DndRef.fromJson(json['school']);
  final damageType = json.containsKey('damage')
      ? DndRef.fromJson(json['damage']['damage_type'])
      : null;
  final dcType =
      json.containsKey('dc') ? DndRef.fromJson(json['dc']['dc_type']) : null;
  String? dcSuccess;
  if (json.containsKey('dc')) {
    switch (json['dc']['dc_success']) {
      case 'half':
        dcSuccess = 'Take half of the damage on successful DC.';
        break;
      case 'none':
        dcSuccess = 'Suffer no effect on successful DC.';
        break;
    }
  }

  return ArticlePage.lines([
    ...json['desc'],
    if (classes.isNotEmpty) "**Classes**: ${classes.join(', ')}",
    if (subclasses.isNotEmpty) "**Subclasses**: ${subclasses.join(', ')}",
    if (json['level'] > 0)
      "**Level** ${json['level']}"
    else
      '**Cantrip** (level 0)',
    ...json['higher_level'],
    '**School**: [${school.name}](${school.url})',
    "**Components**: ${[for (String s in json['components']) s].join(', ')}",
    if (json.containsKey('material')) json['material'],
    '**Casting time**: '
        "${json['casting_time']}"
        "${json['ritual'] as bool ? ' - Ritual' : ''}",
    '**Effect duration**: '
        "${json['concentration'] as bool ? 'Concentration, ' : ''}"
        "${json['duration']}",
    "**Range**: ${json['range']}",
    if (json.containsKey('area_of_effect'))
      '**Area of effect**:'
          " ${json['area_of_effect']['type']} /"
          " ${json['area_of_effect']['size']}",
    "**Attack type**: ${json['attack_type']}",
    if (damageType != null)
      '**Damage type**: [${damageType.name}](${damageType.url})',
    if (json['damage']?.containsKey('damage_at_slot_level') ?? false)
      for (var it
          in (json['damage']['damage_at_slot_level'] as JsonObject).entries)
        '- ${it.value} at slot level ${it.key}',
    if (json['damage']?.containsKey('damage_at_character_level') ?? false)
      for (var it in (json['damage']['damage_at_character_level'] as JsonObject)
          .entries)
        '- ${it.value} at character level ${it.key}',
    if (dcType != null) '**DC**: [${dcType.name}](${dcType.url})',
    if (dcSuccess != null) dcSuccess,
  ]);
}
