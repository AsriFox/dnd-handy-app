import 'package:dnd_handy_flutter/page_screen.dart';
import 'package:dnd_handy_flutter/pages/desc_popup.dart';
import 'package:dnd_handy_flutter/pages/reflist_item.dart';
import 'package:flutter/material.dart';

const bold = TextStyle(fontWeight: FontWeight.bold);
const padButt = EdgeInsets.fromLTRB(16.0, 4.0, 16.0, 0.0);
const padText = EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 4.0);

List<Widget> equipmentArticleSubpage(Map<String, dynamic> json) {
  var children = <Widget>[
    Padding(padding: padButt,
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          const Text("Category: ", style: bold),
          TextButtonRef(
            ref: DndRef.fromJson(json['equipment_category']),
            onPressed: showPageScreen,
          ),
        ]
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
  children.add(Padding(padding: padText,
    child: Row(children: [
      const Text("Cost: ", style: bold),
      Text(json['cost']['quantity'].toString() + json['cost']['unit']),
    ]),
  ));
  if (json.containsKey('weight')) {
    children.add(Padding(padding: padText,
      child: Row(children: [
        const Text("Weight: ", style: bold),
        Text(json['weight'].toString()),
      ]),
    ));
  }
  return children;
}

List<Widget> weaponEquipmentArticleSubpage(Map<String, dynamic> json) { 
  var children = <Widget>[
    Padding(padding: padText,
      child: Text(
        json['category_range'] + " Weapon", 
        style: bold,
      ),
    ),
    Padding(padding: padText,
      child: Row(children: [
        const Text("Range: ", style: bold),
        Text(
          json['range']['long'] != null
            ? "${json['range']['normal']} / ${json['range']['long']}"
            : json['range']['normal'].toString()
        ),
      ]),
    ),
    Padding(padding: padButt,
      child: Row(children: [
        const Text("Damage: ", style: bold),
        Text("${json['damage']['damage_dice']} "),
        TextButtonRef(
          ref: DndRef.fromJson(json['damage']['damage_type']),
          onPressed: showDescPopup,
        ),
      ]),
    ),
  ];
  if (json.containsKey('two_handed_damage')) {
    children.add(Padding(padding: padButt,
      child: Row(children: [
        const Text("2H Damage: ", style: bold),
        Text("${json['damage']['damage_dice']} "),
        TextButtonRef(
          ref: DndRef.fromJson(json['damage']['damage_type']),
          onPressed: showDescPopup,
        ),
      ]),
    ));
  }
  if (json.containsKey('properties')) {
    final properties = json['properties'] as List<dynamic>;
    children.add(Padding(padding: padButt,
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        children: <Widget>[
          const Text("Properties: ", style: bold),
        ] + properties.map(
            (it) => TextButtonRef(
              ref: DndRef.fromJson(it),
              onPressed: showDescPopup,
            )
          ).toList(),
      )
    ));
  }
  return children;
}

List<Widget> armorEquipmentArticleSubpage(Map<String, dynamic> json) { 
  var children = <Widget>[
    Padding(padding: padText,
      child: Text(
        json['armor_category'] + " Armor", 
        style: bold,
      ),
    ),
    Padding(padding: padText,
      child: Row(children: [
        const Text("STR requirement: ", style: bold),
        Text(json['str_minimum'].toString()),
      ]),
    ),
  ];
  if (json['stealth_disadvantage']) {
    children.add(const Padding(padding: padText,
      child: Text("Disadvantage on Stealth"),
    ));
  }
  return children;
}

List<Widget> gearEquipmentArticleSubpage(Map<String, dynamic> json) { 
  var children = <Widget>[
    Padding(
      padding: padText,
      child: TextButtonRef(
        ref: DndRef.fromJson(json['gear_category']), 
        onPressed: showDescPopup,
      ),
    )
  ];
  if (json.containsKey('contents')) {
    final contents = json['contents'] as List<dynamic>;
    children.add( const Padding(padding: padText,
      child: Text("Contents:", style: bold),
    ));
    children += contents.map((it) => 
      ListTileRef(
        ref: DndRef.fromJson(it['item']),
        onTap: showDescPopup,
        visualDensity: ListDensity.veryDense.d,
        trailing: Text(it['quantity'].toString()),
      ),
    ).toList();
  }
  return children;
}