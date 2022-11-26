import 'package:dnd_handy_flutter/json_objects.dart';
import 'package:dnd_handy_flutter/pages/article_page.dart';
import 'package:dnd_handy_flutter/pages/reflist_item.dart';
import 'package:flutter/material.dart';

class AbilityArticlePage extends ArticlePage {
  const AbilityArticlePage({
    super.key,
    required this.skills,
  });

  final List<DndRef> skills;

  factory AbilityArticlePage.fromJson(JsonObject json) =>
    AbilityArticlePage(
      skills: [
        for (var it in json['skills'])
          DndRef.fromJson(it)
      ],
    );

  @override
  List<Widget> buildChildren() => 
    <Widget>[
      annotatedLine(annotation: "Associated skills:"),
      for (var it in skills)
        ListTileRef(ref: it)
    ];
}