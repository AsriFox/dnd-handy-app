import 'package:dnd_handy_flutter/pages/article_page.dart';
import 'package:dnd_handy_flutter/pages/reflist_item.dart';
import 'package:flutter/material.dart';

// TODO: Convert to standalone page
class MulticlassingArticlePage extends ArticlePage {
  const MulticlassingArticlePage({
    super.key,
    required super.request,
  });

  @override
  List<Widget>? buildChildren(Map<String, dynamic> json) {
    var children = <Widget>[];

    if (json.containsKey('prerequisites')) {
      children.add(annotatedLine(annotation: "Prerequisites:"));
      children += (json['prerequisites'] as List<dynamic>).map(
          (it) => ListTileRef.fromJson(
            it['ability_score'],
            trailing: Text(it['minimum_score'].toString(), style: const TextStyle(fontSize: 16.0)),
          )
        ).toList();
    } else if (json.containsKey('prerequisite_options')) {
      // TODO: Check different homebrew classes for needing multiple proficiency choices
      children.add(annotatedLine(annotation: "Prerequisites:", content: const Text("one of:")));
      children += (json['prerequisite_options']['from']['options'] as List<dynamic>).map(
          (it) => ListTileRef.fromJson(
            it['ability_score'],
            trailing: Text(it['minimum_score'].toString(), style: const TextStyle(fontSize: 16.0)),
          )
        ).toList();
    }

    final proficiencies = json['proficiencies'] as List<dynamic>;
    if (proficiencies.isNotEmpty) {
      children.add(annotatedLine(
        annotation: "Granted proficiencies: ",
        contents: proficiencies.map(
          (it) => TextButtonRef.fromJson(it)
        ).toList(),
      ));
    } else {
      children.add(annotatedLine(
        annotation: "Granted proficiencies: ",
        content: const Text("none"),
      ));
    }
        
    if (json.containsKey('proficiency_choices')) {
      children.add(annotatedLine(annotation: "Additional proficiencies:"));
      children += (json['proficiency_choices'] as List<dynamic>).map(
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
