import 'package:dnd_handy_flutter/json_objects.dart';
import 'package:dnd_handy_flutter/pages/article_page.dart';
import 'package:dnd_handy_flutter/pages/reflist_item.dart';

// TODO: Convert to standalone page
ArticlePage subraceArticlePage(JsonObject json) {
  final raceRef = DndRef.fromJson(json['race']);

  final abilityBonuses = {
    for (JsonObject it in json['ability_bonuses'])
      DndRef.fromJson(it['ability_score']): it['bonus'] as int,
  }.entries.map((it) => '[${it.key.name}](${it.key.url}): ${it.value}');

  final startProf = [
    for (var it in json['starting_proficiencies']) DndRef.fromJson(it),
  ].map((it) => '[${it.name}](${it.url})');

  final traits = [for (var it in json['racial_traits']) DndRef.fromJson(it)]
      .map((it) => '[${it.name}](${it.url})');

  final languages = [for (var it in json['languages']) DndRef.fromJson(it)]
      .map((it) => '[${it.name}](${it.url})');

  return ArticlePage.lines([
    '**Base**: [${raceRef.name}](${raceRef.url})',
    json['desc'],
    '**Ability bonuses**: ${abilityBonuses.join(', ')}',
    if (startProf.isNotEmpty)
      "**Starting proficiencies**: ${startProf.join(', ')}"
    else
      '**Starting proficiencies**: none',
    if (traits.isNotEmpty)
      "**Traits**: ${traits.join(', ')}"
    else
      '**Traits**: none',
    if (languages.isNotEmpty)
      "**Additional languages**: ${languages.join(', ')}",
    // TODO: Language options
    // if (json.containsKey('language_options')) {
    // final languageOptions =
    // json['language_options']['from']['options'] as List<dynamic>;
    // children += <Widget>[
    // Padding(
    // padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 0.0),
    // child: Text(
    // "Choose ${json['language_options']['choose'].toString()} language(s) from:"),
    // ),
    // annotatedLine(
    // annotation: '',
    // contents: languageOptions
    //     .map((it) => TextButtonRef.fromJson(it['item']))
    //     .toList(),
    // ),
    // ];
    // } else if (languages.isEmpty) {
    // children.add(annotatedLine(
    // annotation: 'Additional languages: ',
    // content: const Text('none'),
    // ));
    // }
  ]);
}
