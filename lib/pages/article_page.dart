import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'articles/skills_subpage.dart';

class ArticlePage extends StatelessWidget {
  const ArticlePage({
    super.key,
    required this.description,
    this.children,
  });

  final String description;
  final List<Widget>? children;

  factory ArticlePage.fromJson(Map<String, dynamic> json) {
    List<Widget>? children;
    if (json.containsKey('ability_score')) {
      children = skillsArticleSubpage(
        json['ability_score']
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
          children: <Widget>[desc] + children!
        ),
    );
  }
}