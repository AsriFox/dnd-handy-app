import 'package:dnd_handy_flutter/json_objects.dart';
import 'package:dnd_handy_flutter/pages/article_page.dart';
import 'package:dnd_handy_flutter/pages/reflist_item.dart';
import 'package:flutter/material.dart';

class SkillArticlePage extends ArticlePage {
  const SkillArticlePage({
    super.key,
    required this.governingAbility,
  });

  final DndRef governingAbility;

  factory SkillArticlePage.fromJson(JsonObject json) =>
    SkillArticlePage(
      governingAbility: DndRef.fromJson(json['ability_score']),
    );

  @override
  List<Widget> buildChildren() => [
    annotatedLine(
      annotation: "Governing ability: ",
      content: TextButtonRef(ref: governingAbility),
    ),
  ];
}