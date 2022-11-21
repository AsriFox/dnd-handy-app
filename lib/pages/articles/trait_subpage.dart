import 'package:dnd_handy_flutter/json_objects.dart';
import 'package:dnd_handy_flutter/pages/article_page.dart';
import 'package:dnd_handy_flutter/pages/reflist_item.dart';
import 'package:flutter/material.dart';

class TraitArticlePage extends ArticlePage {
  const TraitArticlePage({
    super.key,
    required super.request,
  });

  @override
  List<Widget>? buildChildren(JsonObject json) {
    var children = <Widget>[];

    if (json['races'].isNotEmpty) {
      children.add(annotatedLine(
        annotation: "Races: ",
        contents: [
          for (var it in json['races'])
            TextButtonRef.fromJson(it)
        ],
      ));
    }

    if (json['subraces'].isNotEmpty) {
      children.add(annotatedLine(
        annotation: "Subraces: ",
        contents: [
          for (var it in json['subraces'])
            TextButtonRef.fromJson(it)
        ],
      ));
    }
    
    if (json.containsKey('language_options')) {
      children += <Widget>[
        annotatedLine(
          annotation: "Language choices: ",
          content: Text("choose ${json['language_options']['choose'].toString()} from:"),
        ),
        annotatedLine(
          annotation: "",
          contents: [
            for (var it in json['language_options']['from']['options'])
              TextButtonRef.fromJson(it)
          ],
        ),
      ];
    }

    if (json['proficiencies'].isNotEmpty) {
      children.add(annotatedLine(
        annotation: "Granted proficiencies: ",
        contents: [
          for (var it in json['proficiencies'])
            TextButtonRef.fromJson(it)
        ],
      ));
    }

    if (json.containsKey('proficiency_choices')) {
      children += buildAnnotatedOptionsList(
        annotation: "Proficiency choices: ", 
        json: json['proficiency_choices'],
      );
    }

    if (json.containsKey('trait_specific')) {
      final traitSpec = json['trait_specific'] as JsonObject;
      if (traitSpec.containsKey('breath_weapon')) {
        final breathWeapon = traitSpec['breath_weapon'] as JsonObject;

        var leveledDamage = <Widget>[];
        (breathWeapon['damage'][0]['damage_at_character_level'] as JsonObject)
          .forEach((key, value) => leveledDamage.add(
            Text(" $value at level $key;"),
          ));

        children += <Widget>[
          annotatedLine(annotation: "",
            content: const TextButtonRef(
              ref: DndRef(
                index: "breath-weapon",
                name: "Breath Weapon",
                url: "api/traits/breath-weapon",
              ),
            )
          ),
          annotatedLine(
            annotation: "Area of effect: ",
            content: Text("${breathWeapon['area_of_effect']['type']} / ${breathWeapon['area_of_effect']['size']}"),
          ),
          annotatedLine(
            annotation: "DC: ",
            content: TextButtonRef.fromJson(breathWeapon['dc']['dc_type']),
          ),
          annotatedLine(
            annotation: "Damage: ",
            content: TextButtonRef.fromJson(breathWeapon['damage'][0]['damage_type']),
          ),
          annotatedLine(annotation: "", contents: leveledDamage),
          const Padding(padding: pad, child: Text("Take half of the damage on successful DC.")),
          annotatedLine(
            annotation: "Usage: ",
            content: Text("${breathWeapon['usage']['times']} times ${breathWeapon['usage']['type']}")
          ),
        ];
      } else if (traitSpec.containsKey('subtrait_options')) {
        children += buildAnnotatedOptionsList(
          annotation: "Variants: ", 
          json: traitSpec['subtrait_options'],
        );
      } else if (traitSpec.containsKey('spell_options')) {
        children += buildAnnotatedOptionsList(
          annotation: "Spell options: ", 
          json: traitSpec['spell_options'],
        );
      }
    }

    return children;
  }
}

List<Widget> buildAnnotatedOptionsList({
  required String annotation, 
  required JsonObject json,
}) => [
  annotatedLine(
    annotation: "Variants: ",
    content: Text("choose ${json['choose'].toString()} from:"),
  ),
  for (var it in json['from']['options'])
    ListTileRef.fromJson(it['item'], dense: true)
];