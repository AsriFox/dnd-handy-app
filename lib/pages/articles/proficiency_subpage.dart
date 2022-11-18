import 'package:dnd_handy_flutter/pages/article_page.dart';
import 'package:dnd_handy_flutter/pages/reflist_item.dart';
import 'package:flutter/material.dart';

class ProficiencyArticlePage extends ArticlePage {
  const ProficiencyArticlePage({
    super.key,
    required super.request,
  });

  @override
  List<Widget>? buildChildren(Map<String, dynamic> json) {
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
    final races = json['races'] as List<dynamic>;
    if (races.isNotEmpty) {
      children += buildEmbeddedRefList("Races: ", races);
    }
    final classes = json['classes'] as List<dynamic>;
    if (classes.isNotEmpty) {
      children += buildEmbeddedRefList("Classes: ", classes);
    }
    return children;
  }
}

List<Widget> buildEmbeddedRefList(String title, List<dynamic> items) => 
  <Widget>[
    annotatedLine(annotation: title),
  ] + items.map(
      (it) => ListTileRef.fromJson(it)
    ).toList();