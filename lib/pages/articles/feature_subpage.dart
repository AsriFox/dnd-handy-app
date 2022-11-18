import 'package:dnd_handy_flutter/pages/article_page.dart';
import 'package:dnd_handy_flutter/pages/reflist_item.dart';
import 'package:flutter/material.dart';

class FeatureArticlePage extends ArticlePage {
  const FeatureArticlePage({
    super.key,
    required super.request,
  });

  @override
  List<Widget>? buildChildren(Map<String, dynamic> json) {
    var children = <Widget>[
      annotatedLine(
        annotation: "Level: ",
        content: Text(json['level'].toString()),
      ),
      annotatedLine(
        annotation: "Class: ",
        content: TextButtonRef.fromJson(json['class']),
      ),
    ]; 
    if (json.containsKey('subclass')) {
      children.add(annotatedLine(
        annotation: "Subclass: ",
        content: TextButtonRef.fromJson(json['subclass']),
      ));
    }

    final prerequisites = json['prerequisites'] as List<dynamic>;
    if (prerequisites.isNotEmpty) {
      children.add(annotatedLine(annotation: "Prerequisites:"));
      children += prerequisites.map(
          (it) => ListTileRef.fromJson(it['skill'],
            trailing: Text(
              it['minimum_score'].toString(),
              style: const TextStyle(fontSize: 16.0),
            ),
          )
        ).toList();
    }
    
    return children;
  }
}