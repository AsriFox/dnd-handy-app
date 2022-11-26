import 'package:dnd_handy_flutter/json_objects.dart';
import 'package:dnd_handy_flutter/pages/article_page.dart';
import 'package:dnd_handy_flutter/pages/reflist_item.dart';
import 'package:flutter/material.dart';

class FeatureArticlePage extends ArticlePage {
  const FeatureArticlePage({
    super.key,
    required this.level,
    required this.classRef,
    this.subclassRef,
    this.prerequisites,
  });

  final int level;
  final DndRef classRef;
  final DndRef? subclassRef;
  final Map<DndRef, int>? prerequisites;

  factory FeatureArticlePage.fromJson(JsonObject json) =>
    FeatureArticlePage(
      level: json['level'],
      classRef: DndRef.fromJson(json['class']),
      subclassRef: DndRef.fromJson(json['subclass']),
      prerequisites: {
        for (var it in json['prerequisites'])
          DndRef.fromJson(it['skill']) : it['minimum_score']
      },
    );

  @override
  List<Widget> buildChildren() {
    var children = <Widget>[
      annotatedLine(
        annotation: "Level: ",
        content: Text("$level"),
      ),
      annotatedLine(
        annotation: "Class: ",
        content: TextButtonRef(ref: classRef),
      ),
      if (subclassRef != null) 
        annotatedLine(
          annotation: "Subclass: ",
          content: TextButtonRef(ref: subclassRef!),
        ),
    ]; 

    if (prerequisites?.isNotEmpty ?? false) {
      children.add(annotatedLine(annotation: "Prerequisites:"));
      prerequisites!.forEach(
        (key, value) => children.add(
          ListTileRef(
            ref: key,
            trailing: Text(
              value.toString(),
              style: const TextStyle(fontSize: 16.0),
            ),
          )
        )
      );
    }
    
    return children;
  }
}