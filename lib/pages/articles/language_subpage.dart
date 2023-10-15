import 'package:dnd_handy_flutter/json_objects.dart';
import 'package:dnd_handy_flutter/pages/article_page.dart';

ArticlePage languageArticlePage(JsonObject json) {
  final typicalSpeakers = [
    for (var s in json['typical_speakers']) s as String,
  ];
  return ArticlePage.lines([
    if (json.containsKey('desc')) json['desc'] as String,
    "**Type**: ${json['type']}",
    "**Script**: ${json['script'] ?? 'none'}",
    "**Typical speakers**: ${typicalSpeakers.join(', ')}",
  ]);
}
