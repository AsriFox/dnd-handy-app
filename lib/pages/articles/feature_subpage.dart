import 'package:dnd_handy_flutter/json_objects.dart';
import 'package:dnd_handy_flutter/pages/article_page.dart';
import 'package:dnd_handy_flutter/pages/reflist_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class FeatureArticlePage extends StatelessWidget {
  const FeatureArticlePage({
    super.key,
    required this.level,
    required this.classRef,
    required this.desc,
    this.subclassRef,
    this.prerequisites,
  });

  final int level;
  final String desc;
  final DndRef classRef;
  final DndRef? subclassRef;
  final Map<DndRef, int>? prerequisites;

  static final yeet = yeetCategory(
    category: 'features',
    builder: (json) => FeatureArticlePage.fromJson(json),
  );

  factory FeatureArticlePage.fromJson(JsonObject json) => FeatureArticlePage(
        level: json['level'],
        desc: json['desc'].join('\n\n'),
        classRef: DndRef.fromJson(json['class']),
        subclassRef:
            json['subclass'] != null ? DndRef.fromJson(json['subclass']) : null,
        prerequisites: {
          for (var it in json['prerequisites'])
            DndRef.fromJson(it['skill']): it['minimum_score']
        },
      );

  @override
  Widget build(BuildContext context) {
    var children = <Widget>[
      annotatedLine(
        annotation: 'Level: ',
        content: Text('$level'),
      ),
      annotatedLine(
        annotation: 'Class: ',
        content: TextButtonRef(ref: classRef),
      ),
      if (subclassRef != null)
        annotatedLine(
          annotation: 'Subclass: ',
          content: TextButtonRef(ref: subclassRef!),
        ),
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: MarkdownBody(data: desc),
      ),
    ];

    if (prerequisites?.isNotEmpty ?? false) {
      children.add(annotatedLine(annotation: 'Prerequisites:'));
      prerequisites!.forEach((key, value) => children.add(ListTileRef(
            ref: key,
            trailing: Text(
              value.toString(),
              style: const TextStyle(fontSize: 16.0),
            ),
          )));
    }

    return SizedBox(
      height: double.maxFinite,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: children,
      ),
    );
  }
}
