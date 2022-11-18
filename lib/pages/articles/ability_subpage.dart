import 'package:dnd_handy_flutter/pages/article_page.dart';
import 'package:dnd_handy_flutter/pages/reflist_item.dart';
import 'package:flutter/material.dart';

class AbilityArticlePage extends ArticlePage {
  const AbilityArticlePage({
    super.key,
    required super.request,
  });

  @override
  List<Widget>? buildChildren(Map<String, dynamic> json) => 
    <Widget>[
      annotatedLine(annotation: "Associated skills:"),
    ] + (json['skills'] as List<dynamic>)
      .map(
        (it) => ListTileRef.fromJson(it)
      ).toList();
}