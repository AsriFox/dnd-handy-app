import 'package:dnd_handy_flutter/json_objects.dart';
import 'package:dnd_handy_flutter/page_screen/pages_build.dart';
import 'package:dnd_handy_flutter/pages/article_page.dart';
import 'package:dnd_handy_flutter/pages/reflist_item.dart';
import 'package:flutter/material.dart';

// TODO: Convert to standalone page
class RaceArticlePage extends ArticlePage {
  const RaceArticlePage({
    super.key,
    required this.json,
  });

  final JsonObject json;

  factory RaceArticlePage.fromJson(JsonObject json) =>
    RaceArticlePage(json: json);

  @override
  List<Widget> buildChildren() {
    var children = <Widget>[
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

    children += <Widget>[
      annotatedLine(
        annotation: "Speed: ", 
        content: Text(json['speed'].toString()),
      ),
      annotatedLine(
        annotation: "Size: ", 
        content: Text(json['size']),
      ),
      Padding(padding: pad, child: Text(json['size_description'])),
    ];
      
    final traits = json['traits'] as List<dynamic>;
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

    final startingProficiencies = json['starting_proficiencies'] as List<dynamic>;
    if (startingProficiencies.isNotEmpty) {
      children.add(annotatedLine(
        annotation: "Starting proficiencies: ",
        contents: startingProficiencies.map(
          (it) => TextButtonRef.fromJson(it)
        ).toList(),
      ));
    } 
    
    if (json.containsKey('starting_proficiency_options')) {
      final options = json['starting_proficiency_options'] as Map<String, dynamic>;
      children.add(annotatedLine(
          annotation: "Proficiency options: ",
          content: Text("choose ${options['choose'].toString()} from:"),
      ));
      children += (options['from']['options'] as List<dynamic>).map(
          (it) => ListTileRef.fromJson(it['item'], dense: true)
        ).toList();
      if (options.containsKey('desc')) {
        children.add(Padding(padding: pad, child: Text(options['desc'])));
      }
    } else if (startingProficiencies.isEmpty) {
      children.add(annotatedLine(
        annotation: "Starting proficiencies: ",
        content: const Text("none"),
      ));
    }

    final subraces = json['subraces'] as List<dynamic>;
    if (subraces.isNotEmpty) {
      children.add(annotatedLine(annotation: "Subraces:"));
      children += (json['subraces'] as List<dynamic>).map(
        (it) => ListTileRef.fromJson(it),
      ).toList();
    }

    children += <Widget>[
      annotatedLine(annotation: "Age:"),
      Padding(padding: pad, child: Text(json['age'])),

      annotatedLine(annotation: "Alignment:"),
      Padding(padding: pad, child: Text(json['alignment'])),

      annotatedLine(
        annotation: "Languages: ",
        contents: (json['languages'] as List<dynamic>).map(
          (it) => TextButtonRef(
            ref: DndRef.fromJson(it),
            onPressed: gotoPage,
          )
        ).toList()
      ),
      Padding(padding: pad, child: Text(json['language_desc'])),
    ];

    return children;
  }
}