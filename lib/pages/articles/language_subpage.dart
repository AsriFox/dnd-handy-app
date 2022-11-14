import 'package:flutter/material.dart';

List<Widget> languageArticleSubpage(Map<String, dynamic> json) => 
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

Widget richTextBlock(String boldText, String regularText) =>
  Padding(
    padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 4.0),
    child: RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: boldText,
            style: const TextStyle(fontWeight: FontWeight.bold)
          ),
          TextSpan(text: regularText),
        ],
      ),
    ),
  );
  