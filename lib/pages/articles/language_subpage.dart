import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:dnd_handy_flutter/json_objects.dart';
import 'package:dnd_handy_flutter/pages/article_page.dart';

class LanguageArticlePage extends StatelessWidget {
  const LanguageArticlePage({
    super.key,
    this.desc,
    required this.type,
    required this.script,
    required this.typicalSpeakers,
  });

  final String? desc;
  final String type;
  final String script;
  final List<String> typicalSpeakers;

  static final yeet = yeetCategory(
    category: 'languages',
    builder: (json) => LanguageArticlePage.fromJson(json),
  );

  factory LanguageArticlePage.fromJson(JsonObject json) => LanguageArticlePage(
        desc: json['desc'],
        type: json['type']!,
        script: json['script'] ?? 'none',
        typicalSpeakers: [for (var s in json['typical_speakers']) s],
      );

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: double.maxFinite,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (desc != null)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: MarkdownBody(data: desc!),
            ),
          _richTextBlock('Type: ', type),
          _richTextBlock('Script: ', script),
          _richTextBlock('Typical speakers: ', typicalSpeakers.join(', ')),
        ],
      ),
    );
  }
}

Widget _richTextBlock(String boldText, String regularText) => annotatedLine(
      annotation: boldText,
      content: Text(regularText),
    );
