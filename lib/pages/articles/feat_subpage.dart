import 'package:dnd_handy_flutter/json_objects.dart';
import 'package:dnd_handy_flutter/pages/article_page.dart';
import 'package:dnd_handy_flutter/pages/reflist_item.dart';
import 'package:flutter/material.dart';

class FeatArticlePage extends ArticlePage {
  const FeatArticlePage({
    super.key,
    required this.prerequisites,
  });

  final Map<DndRef, int> prerequisites;

  factory FeatArticlePage.fromJson(JsonObject json) =>
    FeatArticlePage(
      prerequisites: {
        for (var it in json['prerequisites'])
          DndRef.fromJson(it['ability_score']) : it['minimum_score']
      },
    );

  @override
  List<Widget> buildChildren() => 
    <Widget>[
      annotatedLine(annotation: "Prerequisites:"),
      for (var it in prerequisites.entries)
        ListTileRef(
          ref: it.key,
          trailing: Text(
            "${it.value}",
            style: const TextStyle(fontSize: 16.0),
          ),
        )
    ];
}