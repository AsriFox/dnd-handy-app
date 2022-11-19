import 'package:dnd_handy_flutter/pages/article_page.dart';
import 'package:dnd_handy_flutter/pages/reflist_item.dart';
import 'package:flutter/material.dart';

class SpellArticlePage extends ArticlePage {
  const SpellArticlePage({
    super.key,
    required super.request,
  });

  @override
  List<Widget>? buildChildren(Map<String, dynamic> json) {
    var children = <Widget>[];

    final classes = json['classes'] as List<dynamic>;
    if (classes.isNotEmpty) {
      children.add(annotatedLine(
        annotation: "Classes: ",
        contents: classes.map(
          (it) => TextButtonRef.fromJson(it)
        ).toList(),
      ));
    }

    final subclasses = json['subclasses'] as List<dynamic>;
    if (subclasses.isNotEmpty) {
      children.add(annotatedLine(
        annotation: "Classes: ",
        contents: subclasses.map(
          (it) => TextButtonRef.fromJson(it)
        ).toList(),
      ));
    }

    children.add(json['level'] > 0
      ? annotatedLine(
        annotation: "Level: ",
        content: Text(json['level'].toString()),
      )
      : annotatedLine(
        annotation: "Cantrip ",
        content: const Text("(level 0)"),
      )
    );
    if (json.containsKey('higher_level')) {
      final leveledDesc = json['higher_level'] as List<dynamic>;
      children += leveledDesc.map(
          (s) => Padding(padding: pad, child: Text(s))
        ).toList();
    }

    children += <Widget>[
      annotatedLine(
        annotation: "School: ",
        content: TextButtonRef.fromJson(json['school']),
      ),
      annotatedLine(
        annotation: "Components: ",
        contents: (json['components'] as List<dynamic>).map(
          (s) => Text(s.toString())
        ).toList(),
      ),
    ];

    if (json.containsKey('material')) {
      children.add(Padding(
        padding: pad,
        child: Text(json['material']),
      ));
    }

    children += <Widget>[
      annotatedLine(
        annotation: "Casting time: ",
        content: Text(
          json['ritual'] as bool
          ? "${json['casting_time']} - Ritual"
          : json['casting_time'],
        )
      ),
      annotatedLine(
        annotation: "Effect duration: ",
        content: Text(
          json['concentration'] as bool
          ? "Concentration, ${json['duration']}"
          : json['duration'],
        )
      ),
      annotatedLine(
        annotation: "Range: ",
        content: Text(json['range']),
      ),
    ];

    if (json.containsKey('area_of_effect')) {
      children.add(annotatedLine(
        annotation: "Area of effect: ",
        content: Text("${json['area_of_effect']['type']} / ${json['area_of_effect']['size']}"),
      ));
    }
    if (json.containsKey('attack_type')) {
      switch (json['attack_type']) {
        case 'ranged':
          children.add(const Padding(padding: pad,
            child: Text("Ranged spell attack"),
          ));
          break;
      }
    }

    if (json.containsKey('damage')) {
      var leveledDamage = <Widget>[];
      if (json['damage'].containsKey('damage_at_slot_level')) {
        (json['damage']['damage_at_slot_level'] as Map<String, dynamic>)
          .forEach((key, value) => leveledDamage.add(
            Text(" $value in slot level $key;"),
          ));
      } else if (json['damage'].containsKey('damage_at_character_level')) {
        (json['damage']['damage_at_character_level'] as Map<String, dynamic>)
          .forEach((key, value) => leveledDamage.add(
            Text(" $value at character level $key;"),
          ));
      }
        
      children += <Widget>[
        annotatedLine(
          annotation: "Damage: ",
          content: TextButtonRef.fromJson(json['damage']['damage_type']),
        ),
        annotatedLine(annotation: "", contents: leveledDamage),
      ];
    }

    if (json.containsKey('dc')) {
      children.add(annotatedLine(
        annotation: "DC: ",
        content: TextButtonRef.fromJson(json['dc']['dc_type']),
      ));

      switch (json['dc']['dc_success']) {
        case 'half':
          children.add(const Padding(padding: pad,
            child: Text("Take half of the damage on successful DC."),
          ));
          break;
        case 'none':
          children.add(const Padding(padding: pad,
            child: Text("Suffer no effect on successful DC."),
          ));
          break;
      }
    }
    
    return children;
  }
}