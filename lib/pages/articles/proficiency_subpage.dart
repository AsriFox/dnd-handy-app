import 'package:dnd_handy_flutter/json_objects.dart';
import 'package:dnd_handy_flutter/pages/article_page.dart';
import 'package:dnd_handy_flutter/pages/reflist_item.dart';
import 'package:flutter/material.dart';

class ProficiencyArticlePage extends ArticlePage {
  const ProficiencyArticlePage({
    super.key,
    required super.request,
  });

  @override
  List<Widget>? buildChildren(JsonObject json) {
    var children = <Widget>[
      annotatedLine(
        annotation: "Type: ",
        content: Text(json['type']),
      ),
      annotatedLine(
        annotation: "Subject: ",
        content: TextButtonRef.fromJson(json['reference']),
      ),
    ];
    if (json['races'].isNotEmpty) {
      children += buildEmbeddedRefList(
        "Races: ", 
        json['races']
      );
    }
    if (json['classes'].isNotEmpty) {
      children += buildEmbeddedRefList(
        "Classes: ", 
        json['classes']
      );
    }
    return children;
  }
}

List<Widget> buildEmbeddedRefList(String title, JsonArray items) => 
  <Widget>[
    annotatedLine(annotation: title),
    for (var it in items)
      ListTileRef.fromJson(it)
  ];