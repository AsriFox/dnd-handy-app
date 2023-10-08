import 'package:dnd_handy_flutter/json_objects.dart';
import 'package:dnd_handy_flutter/pages/article_page.dart';
import 'package:dnd_handy_flutter/pages/reflist_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

const padButt = EdgeInsets.fromLTRB(16.0, 4.0, 16.0, 0.0);

class EquipmentArticlePage extends StatelessWidget {
  const EquipmentArticlePage({
    super.key,
    required this.equipmentCategory,
    required this.desc,
    required this.cost,
    this.weight,
    this.equipmentSubpage,
  });

  final DndRef equipmentCategory;
  final String desc;
  final String cost;
  final String? weight;
  final List<Widget>? equipmentSubpage;

  static final yeet = yeetCategory(
    category: 'equipment',
    builder: (json) => EquipmentArticlePage.fromJson(json),
  );

  factory EquipmentArticlePage.fromJson(JsonObject json) {
    List<Widget>? equipmentSubpage;
    if (json.containsKey('weapon_category')) {
      equipmentSubpage = weaponEquipmentArticlePage(json);
    } else if (json.containsKey('armor_category')) {
      equipmentSubpage = armorEquipmentArticlePage(json);
    } else if (json.containsKey('gear_category')) {
      equipmentSubpage = gearEquipmentArticleSubpage(json);
    }

    return EquipmentArticlePage(
      equipmentCategory: DndRef.fromJson(json['equipment_category']!),
      desc: json['desc'].join('\n\n'),
      cost: "${json['cost']['quantity']}${json['cost']['unit']}",
      weight: json['weight']?.toString(),
      equipmentSubpage: equipmentSubpage,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: double.maxFinite,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          annotatedLine(
            annotation: 'Category: ',
            padding: padButt,
            content: TextButtonRef(ref: equipmentCategory),
          ),
          if (desc.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: MarkdownBody(data: desc),
            ),
          if (equipmentSubpage?.isNotEmpty ?? false)
            for (var widget in equipmentSubpage!) widget,
          annotatedLine(
            annotation: 'Cost: ',
            content: Text(cost),
          ),
          if (weight != null)
            annotatedLine(
              annotation: 'Weight: ',
              content: Text(weight!),
            ),
        ],
      ),
    );
  }
}

List<Widget> weaponEquipmentArticlePage(JsonObject json) {
  final String rangeCategory = json['category_range'];
  final String range = json['range']['long'] != null
      ? "${json['range']['normal']} / ${json['range']['long']}"
      : json['range']['normal'].toString();
  final String damageDice = json['damage']['damage_dice'];
  final DndRef damageType = DndRef.fromJson(json['damage']['damage_type']);

  final String? twoHandedDamageDice = json['two_handed_damage']?['damage_dice'];
  DndRef? twoHandedDamageType;
  if (twoHandedDamageDice != null) {
    twoHandedDamageType =
        DndRef.fromJson(json['two_handed_damage']['damage_type']);
  }

  final JsonArray? properties = json['properties'];

  return [
    annotatedLine(annotation: '$rangeCategory Weapon'),
    annotatedLine(
      annotation: 'Range: ',
      content: Text(range),
    ),
    annotatedLine(
      annotation: 'Damage: ',
      padding: padButt,
      contents: [
        Text(damageDice),
        TextButtonRef(ref: damageType),
      ],
    ),
    if (twoHandedDamageDice != null && twoHandedDamageType != null)
      annotatedLine(
        annotation: '2H Damage: ',
        contents: [
          Text(twoHandedDamageDice),
          TextButtonRef(ref: twoHandedDamageType),
        ],
      ),
    if (properties != null)
      annotatedLine(
        annotation: 'Properties:',
        contents: [
          for (var it in properties) TextButtonRef.fromJson(it),
        ],
      ),
  ];
}

List<Widget> armorEquipmentArticlePage(JsonObject json) {
  final String armorCategory = json['armor_category'];
  final int strengthRequirement = json['str_minimum'] ?? 0;
  final bool stealthDisadvantage = json['stealth_disadvantage'] ?? false;

  return [
    annotatedLine(
      annotation: '$armorCategory Armor',
    ),
    annotatedLine(
      annotation: 'STR requirement: ',
      content: Text('$strengthRequirement'),
    ),
    if (stealthDisadvantage)
      const Padding(
        padding: pad,
        child: Text('Disadvantage on Stealth'),
      ),
  ];
}

List<Widget> gearEquipmentArticleSubpage(JsonObject json) {
  final DndRef gearCategory = DndRef.fromJson(json['gear_category']);
  final JsonArray? contents = json['contents'];

  return [
    annotatedLine(
      annotation: 'Gear category: ',
      content: TextButtonRef(ref: gearCategory),
    ),
    if (contents?.isNotEmpty ?? false) ...[
      annotatedLine(annotation: 'Contents:'),
      for (var it in contents!)
        ListTileRef.fromJson(
          it['item'],
          trailing: Text(
            it['quantity'].toString(),
            style: const TextStyle(fontSize: 16.0),
          ),
        ),
    ]
  ];
}
