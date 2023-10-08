import 'package:dnd_handy_flutter/json_objects.dart';
import 'package:dnd_handy_flutter/pages/article_page.dart';
import 'package:dnd_handy_flutter/pages/reflist_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class FeatArticlePage extends StatelessWidget {
  const FeatArticlePage({
    super.key,
    required this.desc,
    required this.prerequisites,
  });

  final String desc;
  final Map<DndRef, int> prerequisites;

  static final yeet = yeetCategory(
    category: 'feats',
    builder: (json) => FeatArticlePage.fromJson(json),
  );

  factory FeatArticlePage.fromJson(JsonObject json) => FeatArticlePage(
        desc: json['desc'].join('\n\n'),
        prerequisites: {
          for (var it in json['prerequisites'])
            DndRef.fromJson(it['ability_score']): it['minimum_score']
        },
      );

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: double.maxFinite,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: MarkdownBody(data: desc),
          ),
          annotatedLine(annotation: 'Prerequisites:'),
          for (var it in prerequisites.entries)
            ListTileRef(
              ref: it.key,
              trailing: Text(
                "${it.value}",
                style: const TextStyle(fontSize: 16.0),
              ),
            )
        ],
      ),
    );
  }
}
