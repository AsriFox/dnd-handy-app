import 'package:dnd_handy_flutter/json_objects.dart';
import 'package:dnd_handy_flutter/pages/article_page.dart';
import 'package:flutter/material.dart';

class LanguageArticlePage extends ArticlePage {
  const LanguageArticlePage({
    super.key,
    required this.type,
    this.script = "none",
    required this.typicalSpeakers,
  });

  final String type;
  final String script;
  final List<String> typicalSpeakers;

  factory LanguageArticlePage.fromJson(JsonObject json) =>
    LanguageArticlePage(
      type: json['type']!,
      script: json['script'],
      typicalSpeakers: [
        for (var s in json['typical_speakers'])
          s
      ],
    );

  @override
  List<Widget> buildChildren() => 
    <Widget>[
      richTextBlock("Type: ", type),
      richTextBlock("Script: ", script),
      richTextBlock(
        "Typical speakers: ", 
        typicalSpeakers.join(", ")
      ),
    ];
}

Widget richTextBlock(String boldText, String regularText) =>
  annotatedLine(
    annotation: boldText,
    content: Text(regularText),
  );