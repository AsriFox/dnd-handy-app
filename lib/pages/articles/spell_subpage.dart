import 'package:dnd_handy_flutter/json_objects.dart';
import 'package:dnd_handy_flutter/pages/article_page.dart';
import 'package:dnd_handy_flutter/pages/reflist_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class SpellArticlePage extends StatelessWidget {
  const SpellArticlePage({
    super.key,
    required this.json,
  });

  final JsonObject json;

  // TODO: fields
  factory SpellArticlePage.fromJson(JsonObject json) =>
      SpellArticlePage(json: json);

  @override
  Widget build(BuildContext context) {
    var children = <Widget>[
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: MarkdownBody(
          data: [
            for (String p in json['desc'])
              if (p.contains('|')) p else '\n$p\n'
          ].join('\n'),
          styleSheet: mdTableStyle,
        ),
      ),
    ];

    if (json['classes'].isNotEmpty) {
      children.add(annotatedLine(annotation: 'Classes: ', contents: [
        for (var it in json['classes']) TextButtonRef.fromJson(it)
      ]));
    }

    if (json['subclasses'].isNotEmpty) {
      children.add(annotatedLine(
        annotation: 'Classes: ',
        contents: [
          for (var it in json['subclasses']) TextButtonRef.fromJson(it)
        ],
      ));
    }

    children.add(json['level'] > 0
        ? annotatedLine(
            annotation: 'Level: ',
            content: Text(json['level'].toString()),
          )
        : annotatedLine(
            annotation: 'Cantrip ',
            content: const Text('(level 0)'),
          ));
    if (json.containsKey('higher_level')) {
      children += [
        for (var s in json['higher_level'])
          Padding(padding: pad, child: Text(s))
      ];
    }

    children += <Widget>[
      annotatedLine(
        annotation: 'School: ',
        content: TextButtonRef.fromJson(json['school']),
      ),
      annotatedLine(
          annotation: 'Components: ',
          contents: [for (var s in json['components']) Text('$s')]),
    ];

    if (json.containsKey('material')) {
      children.add(Padding(
        padding: pad,
        child: Text(json['material']),
      ));
    }

    children += <Widget>[
      annotatedLine(
          annotation: 'Casting time: ',
          content: Text(
            json['ritual'] as bool
                ? "${json['casting_time']} - Ritual"
                : json['casting_time'],
          )),
      annotatedLine(
          annotation: 'Effect duration: ',
          content: Text(
            json['concentration'] as bool
                ? "Concentration, ${json['duration']}"
                : json['duration'],
          )),
      annotatedLine(
        annotation: 'Range: ',
        content: Text(json['range']),
      ),
    ];

    if (json.containsKey('area_of_effect')) {
      children.add(annotatedLine(
        annotation: 'Area of effect: ',
        content: Text(
            "${json['area_of_effect']['type']} / ${json['area_of_effect']['size']}"),
      ));
    }
    if (json.containsKey('attack_type')) {
      switch (json['attack_type']) {
        case 'ranged':
          children.add(const Padding(
            padding: pad,
            child: Text('Ranged spell attack'),
          ));
          break;
      }
    }

    if (json.containsKey('damage')) {
      var leveledDamage = <Widget>[];
      if (json['damage'].containsKey('damage_at_slot_level')) {
        (json['damage']['damage_at_slot_level'] as JsonObject)
            .forEach((key, value) => leveledDamage.add(
                  Text(' $value in slot level $key;'),
                ));
      } else if (json['damage'].containsKey('damage_at_character_level')) {
        (json['damage']['damage_at_character_level'] as JsonObject)
            .forEach((key, value) => leveledDamage.add(
                  Text(' $value at character level $key;'),
                ));
      }

      children += <Widget>[
        annotatedLine(
          annotation: 'Damage: ',
          content: TextButtonRef.fromJson(json['damage']['damage_type']),
        ),
        annotatedLine(annotation: '', contents: leveledDamage),
      ];
    }

    if (json.containsKey('dc')) {
      children.add(annotatedLine(
        annotation: 'DC: ',
        content: TextButtonRef.fromJson(json['dc']['dc_type']),
      ));

      switch (json['dc']['dc_success']) {
        case 'half':
          children.add(const Padding(
            padding: pad,
            child: Text('Take half of the damage on successful DC.'),
          ));
          break;
        case 'none':
          children.add(const Padding(
            padding: pad,
            child: Text('Suffer no effect on successful DC.'),
          ));
          break;
      }
    }

    return SizedBox(
      height: double.maxFinite,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: children,
      ),
    );
  }
}
