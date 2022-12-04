import 'package:dnd_handy_flutter/json_objects.dart';
import 'package:dnd_handy_flutter/pages/article_page.dart';
import 'package:dnd_handy_flutter/pages/reflist_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class RulesArticlePage extends StatelessWidget {
  const RulesArticlePage({
    super.key,
    this.desc,
    required this.subsections,
  });

  final String? desc;
  final List<DndRef> subsections;

  static final yeet = yeetCategory(
    category: "rules",
    builder: (json) => RulesArticlePage.fromJson(json),
  );

  factory RulesArticlePage.fromJson(JsonObject json) =>
    RulesArticlePage(
      desc: json['desc'],
      subsections: [
        for (var it in json['subsections'])
          DndRef.fromJson(it)
      ],
    );

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: double.maxFinite,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (desc != null) 
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: MarkdownBody(data: desc!),
            ),
          annotatedLine(annotation: "Subsections:"),
          for (var it in subsections)
            ListTileRef(ref: it)
        ],
      ),
    );
  }
}