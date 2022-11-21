import 'package:dnd_handy_flutter/json_objects.dart';
import 'package:dnd_handy_flutter/pages/article_page.dart';
import 'package:dnd_handy_flutter/pages/reflist_item.dart';
import 'package:flutter/material.dart';

const padButt = EdgeInsets.fromLTRB(16.0, 4.0, 16.0, 0.0);

class EquipmentArticlePage extends ArticlePage {
  const EquipmentArticlePage({
    super.key,
    required super.request,
  });

  @override
  List<Widget>? buildChildren(JsonObject json) {
    var children = <Widget>[
      annotatedLine(
        annotation: "Category: ",
        padding: padButt,
        content: TextButtonRef.fromJson(json['equipment_category']),
      ),
    ];
    if (json.containsKey('weapon_category')) {
      children += weaponEquipmentArticleSubpage(json);
    } else if (json.containsKey('armor_category')) {
      children += armorEquipmentArticleSubpage(json);
    } else if (json.containsKey('gear_category')) {
      children += gearEquipmentArticleSubpage(json);
    }
    children.add(
      annotatedLine(
        annotation: "Cost: ",
        content: Text(json['cost']['quantity'].toString() + json['cost']['unit']),
      ),
    );
    if (json.containsKey('weight')) {
      children.add(
        annotatedLine(
          annotation: "Weight: ",
          content: Text(json['weight'].toString()),
        ),
      );
    }
    return children;
  }
}

List<Widget> weaponEquipmentArticleSubpage(JsonObject json) { 
  var children = <Widget>[
    annotatedLine(
      annotation: json['category_range'] + " Weapon"
    ),
    annotatedLine(
      annotation: "Range: ", 
      content: Text(
        json['range']['long'] != null
          ? "${json['range']['normal']} / ${json['range']['long']}"
          : json['range']['normal'].toString()
      ),
    ),
    annotatedLine(
      annotation: "Damage: ",
      padding: padButt,
      contents: [
        Text("${json['damage']['damage_dice']} "),
        TextButtonRef.fromJson(json['damage']['damage_type']),
      ],
    ),
  ];
  if (json.containsKey('two_handed_damage')) {
    children.add(
      annotatedLine(
        annotation: "2H Damage:",
        padding: padButt,
        contents: [
          const Text("2H Damage: ", style: bold),
          Text("${json['damage']['damage_dice']} "),
          TextButtonRef.fromJson(json['damage']['damage_type']),
        ],
      )
    );
  }
  if (json.containsKey('properties')) {
    children.add(
      annotatedLine(
        annotation: "Properties: ",
        padding: padButt,
        contents: [
          for (var it in json['properties'])
            TextButtonRef.fromJson(it)
        ],
      )
    );
  }
  return children;
}

List<Widget> armorEquipmentArticleSubpage(JsonObject json) { 
  var children = <Widget>[
    annotatedLine(
      annotation: json['armor_category'] + " Armor",
    ),
    annotatedLine(
      annotation: "STR requirement: ",
      content: Text(json['str_minimum'].toString()),
    ),
  ];
  if (json['stealth_disadvantage']) {
    children.add(const Padding(padding: pad,
      child: Text("Disadvantage on Stealth"),
    ));
  }
  return children;
}

List<Widget> gearEquipmentArticleSubpage(JsonObject json) { 
  var children = <Widget>[
    Padding(
      padding: pad,
      child: TextButtonRef.fromJson(json['gear_category']),
    )
  ];
  if (json.containsKey('contents')) {
    children += [
      const Padding(padding: pad,
        child: Text("Contents:", style: bold),
      ),
      for (var it in json['contents'])
        ListTileRef.fromJson(
          it['item'],
          trailing: Text(
            it['quantity'].toString(),
            style: const TextStyle(fontSize: 16.0),
          ),
        )
    ];
  }
  return children;
}