import 'package:dnd_handy_flutter/page_screen/pages_build.dart';
import 'package:dnd_handy_flutter/pages/article_page.dart';
import 'package:dnd_handy_flutter/pages/reflist_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class CharBackgroundPageBuilder extends DndPageBuilder {
  const CharBackgroundPageBuilder({
    super.key,
    required super.request,
  });

  @override
  Widget buildPage(Map<String, dynamic> json) =>
    CharBackgroundPage.fromJson(json);
}

class CharBackgroundPage extends StatelessWidget {
  const CharBackgroundPage({
    super.key,
    required this.featureName,
    required this.featureDesc,
    required this.proficiencies,
    required this.equipment,
    this.equipmentOptions,
    this.languages,
    this.languageOptions,
    required this.personalityTraits,
    required this.ideals,
    required this.bonds,
    required this.flaws,
  });

  final String featureName;
  final String featureDesc;
  final List<DndRef> proficiencies;
  final Map<DndRef, int> equipment;
  final List<dynamic>? equipmentOptions;
  final List<DndRef>? languages;
  final Map<String, dynamic>? languageOptions;
  final Map<String, dynamic> personalityTraits;
  final Map<String, dynamic> ideals;
  final Map<String, dynamic> bonds;
  final Map<String, dynamic> flaws;

  factory CharBackgroundPage.fromJson(Map<String, dynamic> json) {
    // TODO: Deal with the choice variants
    List<dynamic>? equipmentOptions;
    if (json.containsKey('starting_equipment_options')) {
      equipmentOptions = json['starting_equipment_options'];
    }
    List<DndRef>? languages;
    if (json.containsKey('languages')) {
      languages = (json['languages'] as List<dynamic>).map(
        (it) => DndRef.fromJson(it)
      ).toList();
    }
    Map<String, dynamic>? languageOptions;
    if (json.containsKey('language_options')) {
      languageOptions = json['language_options'];
    }

    return CharBackgroundPage(
      featureName: json['feature']['name'],
      featureDesc: (json['feature']['desc'] as List<dynamic>)
        .map((p) => p as String).join("\n\n"),
      proficiencies: (json['starting_proficiencies'] as List<dynamic>)
        .map((it) => DndRef.fromJson(it)).toList(),
      equipment: { 
        for (var it in (json['starting_equipment'] as List<dynamic>)) 
          DndRef.fromJson(it['equipment']) : it['quantity'] as int 
      },
      equipmentOptions: equipmentOptions,
      languages: languages,
      languageOptions: languageOptions,
      personalityTraits: json['personality_traits'],
      ideals: json['ideals'],
      bonds: json['bonds'],
      flaws: json['flaws'],
    );
  }

  @override
  Widget build(BuildContext context) {
    var bonusPageContents = [
      annotatedLine(annotation: "Starting equipment:"),
    ];
    if (equipment.isNotEmpty) {
      bonusPageContents += equipment.entries.map(
          (it) => ListTileRef(
            ref: it.key,
            trailing: Text(
              it.value.toString(),
              style: const TextStyle(fontSize: 16.0),
            ),
          )
        ).toList();
    }
    if (equipmentOptions != null) {
      for (Map<String, dynamic> option in equipmentOptions!) {
        bonusPageContents.add(
          Padding(padding: pad, child: Text(
            "Choose ${option['choose'].toString()} equipment item(s) from:"
          ))
        );
        final optionSetType = option['from']['option_set_type'] as String;
        switch (optionSetType) {
          case 'equipment_category':
            bonusPageContents.add(Padding(padding: pad, 
              child: TextButtonRef.fromJson(option['from'][optionSetType]),
            ));
            break;
        }
      }
    }

    if (languages != null) {
      bonusPageContents.add(annotatedLine(
        annotation: "Additional languages: ",
        contents: languages!.map(
          (it) => TextButtonRef(ref: it)
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

    return DefaultTabController(
      length: 6,
      child: Scaffold(
        appBar: const TabBar(
          isScrollable: true,
          tabs: [
            Tab(text: "Feature"),
            Tab(text: "Bonuses"),
            Tab(text: "Personality"),
            Tab(text: "Ideals"),
            Tab(text: "Bonds"),
            Tab(text: "Flaws"),
          ]
        ),
        body: TabBarView(children: [
          buildTabPage(
            title: "Feature: $featureName",
            content: Padding(padding: pad,
              child: MarkdownBody(
                data: featureDesc,
              ),
            )
          ),
          buildTabPage(contents: bonusPageContents),
          buildTabPage(
            title: "Personality traits",
            contents: buildOptionsList(personalityTraits, title: "",
              builder: (s) => buildOptionListTile(s['string'] as String)
            ),
          ),
          buildTabPage(
            title: "Ideals",
            contents: buildOptionsList(ideals, title: "",
              builder: (it) => IdealListTile(
                  desc: it['desc'],
                  options: (it['alignments'] as List<dynamic>).map(
                      (a) => DndRef.fromJson(a)
                    ).toList(), 
                ),
            ),
          ),
          buildTabPage(
            title: "Bonds",
            contents: buildOptionsList(bonds, title: "",
              builder: (s) => buildOptionListTile(s['string'] as String)
            ),
          ),
          buildTabPage(
            title: "Flaws",
            contents: buildOptionsList(flaws, title: "",
              builder: (s) => buildOptionListTile(s['string'] as String)
            ),
          ),
        ]),
      )
    );
  }
}

Widget buildTabPage({
  String? title,
  Widget? content,
  List<Widget>? contents,
}) {
  var children = <Widget>[];
  if (title != null) {
    children.add(Padding(padding: pad, 
      child: Text(
        title,
        style: const TextStyle(fontSize: 20.0),
      )
    ));
  } 
  if (content != null) {
    children.add(content);
  }
  if (contents != null) {
    children += contents;
  } 
  return SingleChildScrollView(child: Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: children,
  ));
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