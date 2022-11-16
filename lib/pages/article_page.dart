import 'package:dnd_handy_flutter/pages/articles/proficiency_subpage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'articles/skills_subpage.dart';
import 'articles/ability_subpage.dart';
import 'articles/language_subpage.dart';

class ArticlePage extends StatelessWidget {
  const ArticlePage({
    super.key,
    required this.description,
    this.children,
  });

  final String description;
  final List<Widget>? children;

  factory ArticlePage.fromJson(Map<String, dynamic> json) {
    // TODO: optimize selection of article types
    List<Widget>? children;
    if (json.containsKey('ability_score')) {
      children = skillsArticleSubpage(
        json['ability_score']
      );
    } 
    if (json.containsKey('skills')) {
      if (json.containsKey('full_name')) {
        children = abilityArticleSubpage(
          json['skills']
        );
      }
    }
    if (json.containsKey('typical_speakers')) {
      children = languageArticleSubpage(json);
    }
    if (json.containsKey('classes') && json.containsKey('races') && json.containsKey('reference')) {
      children = proficiencyArticleSubpage(json);
    }

    if (!json.containsKey('desc')) {
      return ArticlePage(
        description: "",
        children: children,
      );
    }
    if (json['desc'] is String) {
      return ArticlePage(
        description: json['desc'] as String,
        children: children,
      );
    }
    var description = "";
    for (var s in (json['desc'] as Iterable<dynamic>)) {
      description += "${s as String}\n\n";
    }
    return ArticlePage(
      description: description,
      children: children,
    );
  }

  @override
  Widget build(BuildContext context) {
    // styleSheet: MarkdownStyleSheet.largeFromTheme(Theme.of(context)),
    final desc = MarkdownBody(data: description);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(10.0),
      child: children == null ? desc 
        : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[desc] + children!
        ),
    );
  }
}