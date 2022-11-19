import 'package:dnd_handy_flutter/pages/article_page.dart';
import 'package:dnd_handy_flutter/pages/reflist_item.dart';
import 'package:flutter/material.dart';

// TODO: Convert to standalone page
class SubraceArticlePage extends ArticlePage {
  const SubraceArticlePage({
    super.key,
    required super.request,
  });

  @override
  List<Widget>? buildChildren(Map<String, dynamic> json) {
    var children = <Widget>[
      annotatedLine(
        annotation: "Base: ",
        content: TextButtonRef.fromJson(json['race']),
      ),
      annotatedLine(annotation: "Ability bonuses:"),
    ] + (json['ability_bonuses'] as List<dynamic>).map(
        (it) => ListTileRef(
          ref: DndRef.fromJson(it['ability_score']),
          visualDensity: ListDensity.veryDense.d,
          trailing: Text(
            it['bonus'].toString(),
            style: const TextStyle(fontSize: 16.0),
          ),
        )
      ).toList(); 

    final startingProficiencies = json['starting_proficiencies'] as List<dynamic>;
    if (startingProficiencies.isNotEmpty) {
      children.add(annotatedLine(
        annotation: "Starting proficiencies: ",
        contents: startingProficiencies.map(
          (it) => TextButtonRef.fromJson(it)
        ).toList(),
      ));
    } else {
      children.add(annotatedLine(
        annotation: "Starting proficiencies: ",
        content: const Text("none"),
      ));
    }
      
    final traits = json['racial_traits'] as List<dynamic>;
    if (traits.isNotEmpty) {
      children.add(annotatedLine(
        annotation: "Traits: ",
        contents: traits.map(
          (it) => TextButtonRef.fromJson(it)
        ).toList(),
      ));
    } else {
      children.add(annotatedLine(
        annotation: "Traits: ",
        content: const Text("none"),
      ));
    }

    final languages = json['languages'] as List<dynamic>;
    if (languages.isNotEmpty) {
      children.add(annotatedLine(
        annotation: "Additional languages: ",
        contents: languages.map(
          (it) => TextButtonRef.fromJson(it)
        ).toList()
      ));
    } 
    
    if (json.containsKey('language_options')) {
      final languageOptions = json['language_options']['from']['options'] as List<dynamic>;
      children += <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 0.0),
          child: Text("Choose ${json['language_options']['choose'].toString()} language(s) from:"),
        ),
        annotatedLine(
          annotation: "",
          contents: languageOptions.map(
              (it) => TextButtonRef.fromJson(it['item'])
            ).toList(),
        ),
      ];
    } else if (languages.isEmpty) {
      children.add(annotatedLine(
        annotation: "Additional languages: ",
        content: const Text("none"),
      ));
    }

    return children;
  }
}