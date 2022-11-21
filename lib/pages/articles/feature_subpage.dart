import 'package:dnd_handy_flutter/json_objects.dart';
import 'package:dnd_handy_flutter/pages/article_page.dart';
import 'package:dnd_handy_flutter/pages/reflist_item.dart';
import 'package:flutter/material.dart';

class FeatureArticlePage extends ArticlePage {
  const FeatureArticlePage({
    super.key,
    required super.request,
  });

  @override
  List<Widget>? buildChildren(JsonObject json) {
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

    if (json['prerequisites'].isNotEmpty) {
      children += [
        annotatedLine(annotation: "Prerequisites:"),
        for (var it in json['prerequisites'])
          ListTileRef.fromJson(it['skill'],
            trailing: Text(
              it['minimum_score'].toString(),
              style: const TextStyle(fontSize: 16.0),
            ),
          )
      ];
    }
    
    return children;
  }
}