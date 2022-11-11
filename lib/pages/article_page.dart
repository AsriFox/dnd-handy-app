import 'package:flutter/material.dart';

class ArticlePage extends StatelessWidget {
  const ArticlePage({
    super.key,
    this.description,
  });

  final List<String>? description;

  factory ArticlePage.fromJson(Map<String, dynamic> json) =>
    ArticlePage(
      description: json['desc'] is Iterable<dynamic>
        ? List<String>.from(json['desc'] as Iterable<dynamic>) 
        : List<String>.generate(1, (_) => json['desc'] as String),
    );

  @override
  Widget build(BuildContext context) {
    var paragraphs = description
      ?.map((p) => Text(p,
          textAlign: TextAlign.justify,
          style: const TextStyle(
            fontSize: 18,
          ),
        )).toList()
      ?? List<Widget>.empty();

    return ListView(
      padding: const EdgeInsets.all(10.0),
      children: paragraphs,
    );
  }
}