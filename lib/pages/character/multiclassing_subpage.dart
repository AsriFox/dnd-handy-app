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
  final List<dynamic>? proficiencyChoices;

  @override
  factory MulticlassingArticlePage.fromJson(Map<String, dynamic> json) {
    Map<DndRef, int>? prerequisites, prerequisiteOptions;
    if (json.containsKey('prerequisites')) {
      prerequisites = {
        for (Map<String, dynamic> it in (json['prerequisites'] as List<dynamic>))
          DndRef.fromJson(it['ability_score']) : it['minimum_score'] as int          
      };
    } else if (json.containsKey('prerequisite_options')) {
      // TODO: Check different homebrew classes for needing multiple proficiency choices
      prerequisiteOptions = {
        for (Map<String, dynamic> it in (json['prerequisite_options']['from']['options'] as List<dynamic>))
          DndRef.fromJson(it['ability_score']) : it['minimum_score'] as int 
      };
    }

    List<dynamic>? proficiencyChoices;
    if (json.containsKey('proficiency_choices')) {
      proficiencyChoices = json['proficiency_choices'];
    }
    
    return MulticlassingArticlePage(
      prerequisites: prerequisites,
      prerequisiteOptions: prerequisiteOptions,
      proficiencies: (json['proficiencies'] as List<dynamic>).map(
          (it) => DndRef.fromJson(it)
        ).toList(),
      proficiencyChoices: proficiencyChoices,
    );
  }

  List<Widget> build() {
    var children = <Widget>[];

    if (prerequisites != null) {
      children.add(annotatedLine(annotation: "Prerequisites:"));
      children += prerequisites!.entries.map(
        (it) => ListTileRef(
          ref: it.key,
          trailing: Text(
            it.value.toString(),
            style: const TextStyle(fontSize: 16.0),
          ),
        )
      ).toList();
    } else if (prerequisiteOptions != null) {
      children.add(annotatedLine(
        annotation: "Prerequisites: ", 
        content: const Text("one of:"),
      ));
      children += prerequisiteOptions!.entries.map(
        (it) => ListTileRef(
          ref: it.key,
          trailing: Text(
            it.value.toString(),
            style: const TextStyle(fontSize: 16.0),
          ),
        )
      ).toList();
    }

    if (proficiencies.isNotEmpty) {
      children.add(annotatedLine(
        annotation: "Granted proficiencies: ",
        contents: proficiencies.map(
          (it) => TextButtonRef(ref: it)
        ).toList(),
      ));
    } else {
      children.add(annotatedLine(
        annotation: "Granted proficiencies: ",
        content: const Text("none"),
      ));
    }
        
    if (proficiencyChoices != null) {
      children.add(annotatedLine(annotation: "Additional proficiencies:"));
      children += proficiencyChoices!.map(
          (choice) => annotatedLine(
            annotation: "Choose ${choice['choose'].toString()} ${choice['desc']}: ",
            contents: (choice['from']['options'] as List<dynamic>).map(
                (it) => TextButtonRef.fromJson(it['item'])
              ).toList(),
          )
        ).toList();
    }

    return children;
  }
}
