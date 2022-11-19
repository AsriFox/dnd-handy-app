import 'package:dnd_handy_flutter/pages/article_page.dart';
import 'package:dnd_handy_flutter/pages/reflist_item.dart';
import 'package:flutter/material.dart';

class TraitArticlePage extends ArticlePage {
  const TraitArticlePage({
    super.key,
    required super.request,
  });

  @override
  List<Widget>? buildChildren(Map<String, dynamic> json) {
    var children = <Widget>[];

    final races = json['races'] as List<dynamic>;
    if (races.isNotEmpty) {
      children.add(annotatedLine(
        annotation: "Races: ",
        contents: races.map(
          (it) => TextButtonRef.fromJson(it)
        ).toList(),
      ));
    }

    final subraces = json['subraces'] as List<dynamic>;
    if (subraces.isNotEmpty) {
      children.add(annotatedLine(
        annotation: "Subraces: ",
        contents: subraces.map(
          (it) => TextButtonRef.fromJson(it)
        ).toList(),
      ));
    }
    
    if (json.containsKey('language_options')) {
      final languageOptions = json['language_options']['from']['options'] as List<dynamic>;
      children += <Widget>[
        annotatedLine(
          annotation: "Language choices: ",
          content: Text("choose ${json['language_options']['choose'].toString()} from:"),
        ),
        annotatedLine(
          annotation: "",
          contents: languageOptions.map(
              (it) => TextButtonRef.fromJson(it['item'])
            ).toList(),
        ),
      ];
    }

    final proficiencies = json['proficiencies'] as List<dynamic>;
    if (proficiencies.isNotEmpty) {
      children.add(annotatedLine(
        annotation: "Granted proficiencies: ",
        contents: proficiencies.map(
          (it) => TextButtonRef.fromJson(it)
        ).toList(),
      ));
    }

    if (json.containsKey('proficiency_choices')) {
      children += buildAnnotatedOptionsList(
        annotation: "Proficiency choices: ", 
        json: json['proficiency_choices'],
      );
    }

    if (json.containsKey('trait_specific')) {
      final traitSpec = json['trait_specific'] as Map<String, dynamic>;
      if (traitSpec.containsKey('breath_weapon')) {
        final breathWeapon = traitSpec['breath_weapon'] as Map<String, dynamic>;

        var leveledDamage = <Widget>[];
        (breathWeapon['damage'][0]['damage_at_character_level'] as Map<String, dynamic>)
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
  required Map<String, dynamic> json,
}) => <Widget>[
    annotatedLine(
      annotation: "Variants: ",
      content: Text("choose ${json['choose'].toString()} from:"),
    ),
  ] + (json['from']['options'] as List<dynamic>).map(
      (it) => ListTileRef.fromJson(it['item'], dense: true)
    ).toList();
