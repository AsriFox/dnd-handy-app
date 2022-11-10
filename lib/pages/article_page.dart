import 'package:flutter/material.dart';

class ArticlePage extends StatelessWidget {
  const ArticlePage({
    super.key,
    this.description,
    this.category,
  });

  final List<String>? description;
  final String? category;

  @override
  Widget build(BuildContext context) {
    var paragraphs = description
      ?.map((p) => Text(p))
        .toList()
      ?? List<Widget>.empty();

    paragraphs.add(
      Text(
        "Category: $category",
        style: const TextStyle(
          fontStyle: FontStyle.italic
        )
      )
    );

    return ListView(
      children: paragraphs,
    );
  }
}