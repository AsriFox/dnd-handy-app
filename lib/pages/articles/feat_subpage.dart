import 'package:dnd_handy_flutter/pages/article_page.dart';
import 'package:dnd_handy_flutter/pages/reflist_item.dart';
import 'package:flutter/material.dart';

class FeatArticlePage extends ArticlePage {
  const FeatArticlePage({
    super.key,
    required super.request,
  });

  @override
  List<Widget>? buildChildren(Map<String, dynamic> json) => 
    <Widget>[
      annotatedLine(annotation: "Prerequisites:")
    ] + (json['prerequisites'] as List<dynamic>)
      .map(
        (it) => ListTileRef.fromJson(it['ability_score'],
          trailing: Text(
            it['minimum_score'].toString(),
            style: const TextStyle(fontSize: 16.0),
          ),
        )
      ).toList();
}