import 'package:dnd_handy_flutter/json_objects.dart';
import 'package:dnd_handy_flutter/pages/article_page.dart';
import 'package:dnd_handy_flutter/pages/reflist_item.dart';
import 'package:flutter/material.dart';

class RulesArticlePage extends ArticlePage {
  const RulesArticlePage({
    super.key,
    required this.subsections,
  });

  final List<DndRef> subsections;

  factory RulesArticlePage.fromJson(JsonObject json) =>
    RulesArticlePage(
      subsections: [
        for (var it in json['subsections'])
          DndRef.fromJson(it)
      ],
    );

  @override
  List<Widget> buildChildren() => [
    annotatedLine(annotation: "Subsections:"),
    for (var it in subsections)
      ListTileRef(ref: it)
  ];
}