import 'package:flutter/material.dart';
import 'package:dnd_handy_flutter/page_screen/pages_build.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'articles/skills_subpage.dart';
import 'articles/ability_subpage.dart';
import 'articles/language_subpage.dart';
import 'articles/equipment_subpage.dart';
import 'articles/proficiency_subpage.dart';

class ArticlePage extends DndPageBuilder {
  const ArticlePage({
    super.key,
    required super.request,
  });

  factory ArticlePage.variant({
    required Future<dynamic> request,
    String category = ""
  }) {
    switch (category) {
      case "skills":
        return SkillArticlePage(request: request);
      case "ability_scores":
        return AbilityArticlePage(request: request);
      case "languages":
        return LanguageArticlePage(request: request);
      case "equipment":
        return EquipmentArticlePage(request: request);
      case "proficiencies":
        return ProficiencyArticlePage(request: request);
      default:
        return ArticlePage(request: request);
    }
  }

  List<Widget>? buildChildren(Map<String, dynamic> json) => null;

  @override
  Widget buildPage(Map<String, dynamic> json) {
    var desc = "";
    if (json.containsKey('desc')) {
      if (json['desc'] is String) {
        desc = json['desc'];
      } else if (json['desc'] is Iterable<dynamic>) {
        for (var s in json['desc']) {
          desc += "${s as String}\n\n";
        }
      }
    }
    final body = MarkdownBody(data: desc);

    final children = buildChildren(json);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(10.0),
      child: children == null ? body 
        : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 8.0),
              child: body,
            ),
          ] + children
        ),
    );
  }
}

const pad = EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 4.0);

Widget annotatedLine({
  required String annotation, 
  Widget? content,
  List<Widget>? contents,
  EdgeInsetsGeometry padding = pad,
}) { 
  var children = <Widget>[
    Text(
      annotation,
      style: const TextStyle(fontWeight: FontWeight.bold)
    ),
  ];
  if (content != null) {
    children.add(content);
  }
  if (contents != null) {
    children += contents;
  }

  return Padding(
    padding: pad,
    child: Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: children,
    )
  );
}