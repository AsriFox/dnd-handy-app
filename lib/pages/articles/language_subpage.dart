import 'package:dnd_handy_flutter/pages/article_page.dart';
import 'package:flutter/material.dart';

class LanguageArticlePage extends ArticlePage {
  const LanguageArticlePage({
    super.key,
    required super.request,
  });

  @override
  List<Widget>? buildChildren(Map<String, dynamic> json) => 
    <Widget>[
      richTextBlock("Type: ", json['type']),

      json.containsKey('script') 
        ? richTextBlock("Script: ", json['script'])
        : richTextBlock("Script: ", "none"),
        
      richTextBlock(
        "Typical speakers: ", 
        (json['typical_speakers'] as List<dynamic>)
          .map((t) => t as String).join(", "),
      ),
    ];
}

Widget richTextBlock(String boldText, String regularText) =>
  annotatedLine(
    annotation: boldText,
    content: Text(regularText),
  );