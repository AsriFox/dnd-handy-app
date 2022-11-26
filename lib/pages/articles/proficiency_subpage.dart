import 'package:dnd_handy_flutter/json_objects.dart';
import 'package:dnd_handy_flutter/pages/article_page.dart';
import 'package:dnd_handy_flutter/pages/reflist_item.dart';
import 'package:flutter/material.dart';

class ProficiencyArticlePage extends ArticlePage {
  const ProficiencyArticlePage({
    super.key,
    required this.type,
    required this.reference,
    required this.races,
    required this.classes,
  });

  final String type;
  final DndRef reference;
  final List<DndRef> races;
  final List<DndRef> classes;

  factory ProficiencyArticlePage.fromJson(JsonObject json) =>
    ProficiencyArticlePage(
      type: json['type'],
      reference: DndRef.fromJson(json['reference']),
      races: [
        for (var it in json['races'])
          DndRef.fromJson(it)
      ],
      classes: [
        for (var it in json['classes'])
          DndRef.fromJson(it)
      ],
    );

  @override
  List<Widget> buildChildren() => [
    annotatedLine(
      annotation: "Type: ",
      content: Text(type),
    ),
    annotatedLine(
      annotation: "Subject: ",
      content: TextButtonRef(ref: reference),
    ),
    if (races.isNotEmpty)
      annotatedLine(
        annotation: "Races: ",
        contents: [
          for (var it in races)
            ListTileRef(ref: it)
        ],
      ),
    if (classes.isNotEmpty)
      annotatedLine(
        annotation: "Classes: ",
        contents: [
          for (var it in classes)
            ListTileRef(ref: it)
        ],
      ),
  ];
}