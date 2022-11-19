import 'package:dnd_handy_flutter/pages/article_page.dart';
import 'package:dnd_handy_flutter/pages/reflist_item.dart';
import 'package:flutter/material.dart';

class BackgroundArticlePage extends ArticlePage {
  const BackgroundArticlePage({
    super.key,
    required super.request,
  });

  @override
  List<Widget>? buildChildren(Map<String, dynamic> json) {
    var children = <Widget>[
      annotatedLine(
        annotation: "Feature: ",
        content: Text(json['feature']['name']),
      ),
    ] + (json['feature']['desc'] as List<dynamic>).map(
        (p) => Padding(padding: pad, child: Text(p))
      ).toList(); 

    final startingProficiencies = json['starting_proficiencies'] as List<dynamic>;
    if (startingProficiencies.isNotEmpty) {
      children.add(annotatedLine(
        annotation: "Starting proficiencies: ",
        contents: startingProficiencies.map(
          (it) => TextButtonRef.fromJson(it)
        ).toList(),
      ));
    } else {
      children.add(annotatedLine(
        annotation: "Starting proficiencies: ",
        content: const Text("none"),
      ));
    }
      
    children.add(annotatedLine(annotation: "Starting equipment:"));
    final equipment = json['starting_equipment'] as List<dynamic>;
    if (equipment.isNotEmpty) {
      children += equipment.map(
          (it) => ListTileRef.fromJson(
            it['equipment'],
            trailing: Text(it['quantity'].toString(), style: const TextStyle(fontSize: 16.0)),
          )
        ).toList();
    }     
    if (json.containsKey('starting_equipment_options')) {
      children.add(Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 0.0),
        child: Text("Choose ${json['starting_equipment_options'][0]['choose'].toString()} equipment item(s) from:"),
      ));
      final optionSetType = json['starting_equipment_options'][0]['from']['option_set_type'] as String;
      switch (optionSetType) {
        case 'equipment_category':
          children.add(Padding(padding: pad, 
            child: TextButtonRef.fromJson(json['starting_equipment_options'][0]['from'][optionSetType]),
          ));
          break;
      }
    }
      
    if (json.containsKey('languages')) {
      children.add(annotatedLine(
        annotation: "Additional languages: ",
        contents: (json['languages'] as List<dynamic>).map(
          (it) => TextButtonRef.fromJson(it)
        ).toList()
      ));
    }
    // TODO: Understand option types
    // if (json.containsKey('language_options')) {
    //   final languageOptions = json['language_options']['from']['options'] as List<dynamic>;
    //   children += <Widget>[
    //     Padding(
    //       padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 0.0),
    //       child: Text("Choose ${json['language_options']['choose'].toString()} language(s) from:"),
    //     ),
    //     annotatedLine(
    //       annotation: "",
    //       contents: languageOptions.map(
    //           (it) => TextButtonRef.fromJson(it['item'])
    //         ).toList(),
    //     ),
    //   ];
    // }

    if (json.containsKey('personality_traits')) {
      children += buildOptionsList(
        json['personality_traits'],
        title: "Personality traits: ",
        builder: (s) => buildOptionListTile(s['string'] as String),
      );
    }

    if (json.containsKey('ideals')) {
      children += buildOptionsList(
        json['ideals'],
        title: "Ideals: ",
        builder: (it) => IdealListTile(
            desc: it['desc'],
            options: (it['alignments'] as List<dynamic>).map(
                (a) => DndRef.fromJson(a)
              ).toList(), 
          ),
      );
    }

    if (json.containsKey('bonds')) {
      children += buildOptionsList(
        json['bonds'],
        title: "Bonds: ",
        builder: (s) => buildOptionListTile(s['string'] as String),
      );
    }

    if (json.containsKey('flaws')) {
      children += buildOptionsList(
        json['flaws'],
        title: "Flaws: ",
        builder: (s) => buildOptionListTile(s['string'] as String),
      );
    }

    return children;
  }
}

List<Widget> buildOptionsList(
  Map<String, dynamic> json, {
  required String title,
  required Widget Function(dynamic) builder,
}) =>
  <Widget>[
    annotatedLine(
      annotation: title,
      content: Text("Choose ${json['choose'].toString()} from:"),
    )
  ] + (json['from']['options'] as List<dynamic>).map(builder).toList();

ListTile buildOptionListTile(String title, {Widget? trailing, Function()? onTap}) =>
  ListTile(
    dense: true, 
    visualDensity: ListDensity.veryDense.d, 
    leading: const Icon(Icons.add, size: 16.0),
    minLeadingWidth: 0.0,
    title: Text(title),
    trailing: trailing,
    onTap: onTap,
  );

class IdealListTile extends StatelessWidget {
  const IdealListTile({
    super.key,
    required this.desc,
    this.options,
  });

  final String desc;
  final List<DndRef>? options;

  @override
  Widget build(BuildContext context) {
    return buildOptionListTile(desc,
      trailing: const Icon(Icons.more_horiz),
      onTap: () => showDialog(
        context: context, 
        builder: (ctx) => SimpleDialog(
          title: const Text("Alignments"),
          children: options!.map(
            (it) => ListTileRef(
              ref: it,
              dense: true,
              visualDensity: ListDensity.veryDense.d,
            )
          ).toList(),
        )
      ),
    );
  }
}