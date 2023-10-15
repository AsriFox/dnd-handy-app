import 'package:dnd_handy_flutter/json_objects.dart';
import 'package:dnd_handy_flutter/pages/article_page.dart';
import 'package:dnd_handy_flutter/pages/reflist_item.dart';

// TODO: Finish and convert to standalone page
ArticlePage raceArticlePage(JsonObject json) {
  final abilityBonuses = {
    for (var it in json['ability_bonuses'])
      DndRef.fromJson(it['ability_score']): it['bonus'] as int,
  };
  final traits = [for (var it in json['traits']) DndRef.fromJson(it)]
      .map((it) => '[${it.name}](${it.url})');
  final startProf = [
    for (var it in json['starting_proficiencies']) DndRef.fromJson(it),
  ].map((it) => '[${it.name}](${it.url})');
  // TODO: starting_proficiency_options
  // if (json.containsKey('starting_proficiency_options')) {
  //   final options =
  //       json['starting_proficiency_options'] as Map<String, dynamic>;
  //   children.add(annotatedLine(
  //     annotation: 'Proficiency options: ',
  //     content: Text('choose ${options['choose'].toString()} from:'),
  //   ));
  //   children += (options['from']['options'] as List<dynamic>)
  //       .map((it) => ListTileRef.fromJson(it['item'], dense: true))
  //       .toList();
  //   if (options.containsKey('desc')) {
  //     children.add(Padding(padding: pad, child: Text(options['desc'])));
  //   }
  // } else if (startingProficiencies.isEmpty) {
  //   children.add(annotatedLine(
  //     annotation: 'Starting proficiencies: ',
  //     content: const Text('none'),
  //   ));
  // }
  final subraces = [for (var it in json['subraces']) DndRef.fromJson(it)]
      .map((it) => '- [${it.name}](${it.url})');
  final languages = [for (var it in json['languages']) DndRef.fromJson(it)]
      .map((it) => '[${it.name}](${it.url})');

  return ArticlePage.lines([
    "**Ability bonuses**: ${[
      for (var it in abilityBonuses.entries)
        '[${it.key.name}](${it.key.url}): ${it.value}',
    ].join(', ')}",
    "**Speed**: ${json['speed']}",
    "**Size**: ${json['size']}",
    json['size_description'],
    if (traits.isNotEmpty)
      "**Traits**: ${traits.join(', ')}"
    else
      '**Traits**: none',
    if (startProf.isNotEmpty)
      "**Starting proficiencies**: ${startProf.join(', ')}",
    if (subraces.isNotEmpty) '**Subraces**:',
    ...subraces,
    "**Age**: ${json['age']}",
    "**Alignment**: ${json['alignment']}",
    if (languages.isNotEmpty) "**Languages**: ${languages.join(', ')}",
    json['language_desc'],
  ]);
}
