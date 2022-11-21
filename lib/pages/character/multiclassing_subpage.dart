import 'package:dnd_handy_flutter/json_objects.dart';
import 'package:dnd_handy_flutter/pages/article_page.dart';
import 'package:dnd_handy_flutter/pages/reflist_item.dart';
import 'package:flutter/material.dart';

class MulticlassingArticlePage {
  const MulticlassingArticlePage({
    this.prerequisites,
    this.prerequisiteOptions,
    required this.proficiencies,
    this.proficiencyChoices,
  });

  final Map<DndRef, int>? prerequisites;
  final Map<DndRef, int>? prerequisiteOptions;
  final List<DndRef> proficiencies;
  final JsonArray? proficiencyChoices;

  @override
  factory MulticlassingArticlePage.fromJson(JsonObject json) {
    Map<DndRef, int>? prerequisites, prerequisiteOptions;
    if (json.containsKey('prerequisites')) {
      prerequisites = {
        for (JsonObject it in json['prerequisites'])
          DndRef.fromJson(it['ability_score']) : it['minimum_score'] as int          
      };
    } else if (json.containsKey('prerequisite_options')) {
      // TODO: Check different homebrew classes for needing multiple proficiency choices
      prerequisiteOptions = {
        for (JsonObject it in (json['prerequisite_options']['from']['options']))
          DndRef.fromJson(it['ability_score']) : it['minimum_score'] as int 
      };
    }

    JsonArray? proficiencyChoices;
    if (json.containsKey('proficiency_choices')) {
      proficiencyChoices = json['proficiency_choices'];
    }
    
    return MulticlassingArticlePage(
      prerequisites: prerequisites,
      prerequisiteOptions: prerequisiteOptions,
      proficiencies: [
        for (var it in json['proficiencies'])
          DndRef.fromJson(it)
      ],
      proficiencyChoices: proficiencyChoices,
    );
  }

  List<Widget> build() {
    var children = <Widget>[];

    if (prerequisites != null) {
      children.add(annotatedLine(annotation: "Prerequisites:"));
      prerequisites!.forEach(
        (key, value) => children.add(
          ListTileRef(
            ref: key,
            trailing: Text(
              value.toString(),
              style: const TextStyle(fontSize: 16.0),
            ),
          )
        )
      );
    } else if (prerequisiteOptions != null) {
      children.add(annotatedLine(
        annotation: "Prerequisites: ", 
        content: const Text("one of:"),
      ));
      prerequisiteOptions!.forEach(
        (key, value) => children.add(
          ListTileRef(
            ref: key,
            trailing: Text(
              value.toString(),
              style: const TextStyle(fontSize: 16.0),
            ),
          )
        )
      );
    }

    if (proficiencies.isNotEmpty) {
      children.add(annotatedLine(
        annotation: "Granted proficiencies: ",
        contents: [
          for (var it in proficiencies)
            TextButtonRef(ref: it)
        ],
      ));
    } else {
      children.add(annotatedLine(
        annotation: "Granted proficiencies: ",
        content: const Text("none"),
      ));
    }
        
    if (proficiencyChoices != null) {
      children += [
        annotatedLine(annotation: "Additional proficiencies:"),
        for (var choice in proficiencyChoices!)
          annotatedLine(
            annotation: "Choose ${choice['choose'].toString()} ${choice['desc']}: ",
            contents: [
              for (var it in choice['from']['options'])
                TextButtonRef.fromJson(it['item'])
            ],
          )
      ];
    }

    return children;
  }
}
