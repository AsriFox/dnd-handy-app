import 'package:dnd_handy_flutter/json_objects.dart';
import 'package:dnd_handy_flutter/pages/article_page.dart';
import 'package:dnd_handy_flutter/pages/reflist_item.dart';
import 'package:flutter/material.dart';

class RulesArticlePage extends ArticlePage {
  const RulesArticlePage({
    super.key,
    required super.request,
  });

  @override
  List<Widget>? buildChildren(JsonObject json) => 
    <Widget>[
      annotatedLine(annotation: "Subsections:"),
      for (var it in json['subsections'])
        ListTileRef.fromJson(it)
    ];
}