import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:dnd_handy_flutter/json_objects.dart';
import 'package:dnd_handy_flutter/pages/article_page.dart';
import 'package:dnd_handy_flutter/pages/reflist_item.dart';

class SkillArticlePage extends StatelessWidget {
  const SkillArticlePage({
    super.key,
    this.desc,
    required this.governingAbility,
  });

  final String? desc;
  final DndRef governingAbility;

  factory SkillArticlePage.fromJson(JsonObject json) => SkillArticlePage(
        desc: json['desc'].join('\n\n'),
        governingAbility: DndRef.fromJson(json['ability_score']),
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
          annotatedLine(
            annotation: 'Governing ability: ',
            content: TextButtonRef(ref: governingAbility),
          ),
        ],
      ),
    );
  }
}
