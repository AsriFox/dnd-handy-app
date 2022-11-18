import 'package:dnd_handy_flutter/page_screen/pages_build.dart';
import 'package:dnd_handy_flutter/pages/article_page.dart';
import 'package:dnd_handy_flutter/pages/reflist_item.dart';
import 'package:flutter/material.dart';

class SkillArticlePage extends ArticlePage {
  const SkillArticlePage({
    super.key,
    required super.request,
  });

  @override
  List<Widget>? buildChildren(Map<String, dynamic> json) => [
    annotatedLine(
      annotation: "Governing ability: ",
      content: TextButtonRef(
        ref: DndRef.fromJson(json),
        onPressed: gotoPage,
      ),
    ),
  ];
}