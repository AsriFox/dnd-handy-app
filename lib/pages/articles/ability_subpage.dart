import 'package:dnd_handy_flutter/json_objects.dart';
import 'package:dnd_handy_flutter/pages/article_page.dart';
import 'package:dnd_handy_flutter/pages/reflist_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class AbilityArticlePage extends StatelessWidget {
  const AbilityArticlePage({
    super.key,
    required this.desc,
    required this.skills,
  });

  final String desc;
  final List<DndRef> skills;

  factory AbilityArticlePage.fromJson(JsonObject json) => AbilityArticlePage(
        desc: json['desc'].join('\n\n'),
        skills: [for (var it in json['skills']) DndRef.fromJson(it)],
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
          annotatedLine(annotation: 'Associated skills:'),
          for (var it in skills)
            ListTileRef(
              ref: it,
              visualDensity: ListDensity.veryDense.d,
            )
        ],
      ),
    );
  }
}
