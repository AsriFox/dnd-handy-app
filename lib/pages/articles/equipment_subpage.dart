import 'package:dnd_handy_flutter/page_screen/pages_build.dart';
import 'package:dnd_handy_flutter/pages/article_page.dart';
import 'package:dnd_handy_flutter/pages/reflist_item.dart';
import 'package:flutter/material.dart';

const bold = TextStyle(fontWeight: FontWeight.bold);
const padButt = EdgeInsets.fromLTRB(16.0, 4.0, 16.0, 0.0);

class EquipmentArticlePage extends ArticlePage {
  const EquipmentArticlePage({
    super.key,
    required super.request,
  });

  @override
  List<Widget>? buildChildren(Map<String, dynamic> json) {
    var children = <Widget>[
      annotatedLine(
        annotation: "Category: ",
        padding: padButt,
        content: TextButtonRef(
          ref: DndRef.fromJson(json['equipment_category']),
          onPressed: gotoPage,
        ),
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

List<Widget> weaponEquipmentArticleSubpage(Map<String, dynamic> json) { 
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
        TextButtonRef(
          ref: DndRef.fromJson(json['damage']['damage_type']),
          onPressed: gotoPage,
        ),
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
          TextButtonRef(
            ref: DndRef.fromJson(json['damage']['damage_type']),
            onPressed: gotoPage,
          ),
        ],
      )
    );
  }
  if (json.containsKey('properties')) {
    final properties = json['properties'] as List<dynamic>;
    children.add(
      annotatedLine(
        annotation: "Properties: ",
        padding: padButt,
        contents: properties.map(
          (it) => TextButtonRef(
            ref: DndRef.fromJson(it),
            onPressed: gotoPage,
          )
        ).toList(),
      )
    );
  }
  return children;
}

List<Widget> armorEquipmentArticleSubpage(Map<String, dynamic> json) { 
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

List<Widget> gearEquipmentArticleSubpage(Map<String, dynamic> json) { 
  var children = <Widget>[
    Padding(
      padding: pad,
      child: TextButtonRef(
        ref: DndRef.fromJson(json['gear_category']), 
        onPressed: gotoPage,
      ),
    )
  ];
  if (json.containsKey('contents')) {
    final contents = json['contents'] as List<dynamic>;
    children.add(const Padding(padding: pad,
      child: Text("Contents:", style: bold),
    ));
    children += contents.map((it) => 
      ListTileRef(
        ref: DndRef.fromJson(it['item']),
        onTap: gotoPage,
        visualDensity: ListDensity.veryDense.d,
        trailing: Text(it['quantity'].toString()),
      ),
    ).toList();
  }
  return children;
}