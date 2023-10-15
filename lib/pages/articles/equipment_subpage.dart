import 'package:dnd_handy_flutter/json_objects.dart';
import 'package:dnd_handy_flutter/pages/article_page.dart';
import 'package:dnd_handy_flutter/pages/reflist_item.dart';

ArticlePage equipmentArticlePage(JsonObject json) {
  List<String> equipmentSubpage = [];
  if (json.containsKey('weapon_category')) {
    equipmentSubpage = _weaponEquipmentArticlePage(json);
  } else if (json.containsKey('armor_category')) {
    equipmentSubpage = _armorEquipmentArticlePage(json);
  } else if (json.containsKey('gear_category')) {
    equipmentSubpage = _gearEquipmentArticleSubpage(json);
  }
  final equipmentCategory = DndRef.fromJson(json['equipment_category']);

  return ArticlePage.lines([
    '**Category**: [${equipmentCategory.name}](${equipmentCategory.url})',
    ...json['desc'],
    ...equipmentSubpage,
    "**Cost**: ${json['cost']['quantity']}${json['cost']['unit']}",
    if (json.containsKey('weight')) "**Weight**: ${json['weight']}",
  ]);
}

List<String> _weaponEquipmentArticlePage(JsonObject json) {
  final String rangeCategory = json['category_range'];
  final range = json['range']['long'] != null
      ? "${json['range']['normal']} / ${json['range']['long']}"
      : "${json['range']['normal']}";
  final String damageDice = json['damage']['damage_dice'];
  final damageType = DndRef.fromJson(json['damage']['damage_type']);

  final String? twoHandedDamageDice = json['two_handed_damage']?['damage_dice'];
  final twoHandedDamageType = twoHandedDamageDice != null
      ? DndRef.fromJson(json['two_handed_damage']['damage_type'])
      : null;

  final properties = json.containsKey('properties')
      ? [for (var it in json['properties']) DndRef.fromJson(it)]
          .map((it) => '[${it.name}](${it.url})')
      : null;

  return [
    '**$rangeCategory Weapon**',
    '**Range**: $range',
    '**Damage**: $damageDice [${damageType.name}](${damageType.url})',
    if (twoHandedDamageDice != null)
      '**2H Damage**: $twoHandedDamageDice '
          '[${twoHandedDamageType!.name}](${twoHandedDamageType.url})',
    if (properties != null) "**Properties**: ${properties.join(', ')}"
  ];
}

List<String> _armorEquipmentArticlePage(JsonObject json) {
  final String armorCategory = json['armor_category'];
  final strengthRequirement = json['str_minimum'] ?? 0;
  final stealthDisadvantage = json['stealth_disadvantage'] ?? false;

  return [
    '**$armorCategory Armor**',
    '**STR requirement**: $strengthRequirement',
    if (stealthDisadvantage) 'Disadvantage on Stealth',
  ];
}

List<String> _gearEquipmentArticleSubpage(JsonObject json) {
  final gearCategory = DndRef.fromJson(json['gear_category']);
  final contents = json.containsKey('contents')
      ? {
          for (var it in json['contents'])
            DndRef.fromJson(it['item']): it['quantity'] as int,
        }
      : {};

  return [
    '**Gear category**: [${gearCategory.name}](${gearCategory.url})',
    if (contents.isNotEmpty) '**Contents**:',
    for (var it in contents.entries)
      '- [${it.key.name}](${it.key.url}) (${it.value})',
  ];
}
