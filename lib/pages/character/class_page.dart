import 'package:dnd_handy_flutter/api_service.dart';
import 'package:dnd_handy_flutter/json_objects.dart';
import 'package:dnd_handy_flutter/page_builder.dart';
import 'package:dnd_handy_flutter/pages/article_page.dart';
import 'package:dnd_handy_flutter/pages/character/multiclassing_subpage.dart';
import 'package:dnd_handy_flutter/pages/reflist_item.dart';
import 'package:dnd_handy_flutter/pages/reflist_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class CharClassPage extends StatelessWidget {
  const CharClassPage({
    super.key,
    required this.classLevels,
    this.classSpells,
    this.spellcasting,
    required this.savingThrows,
    required this.subclasses,
    required this.multiclassing,
    required this.proficiencies,
    this.proficiencyChoices,
    this.equipment,
    this.equipmentOptions,
  });

  final Future<dynamic> classLevels;
  final Future<dynamic>? classSpells;
  final JsonObject? spellcasting;
  final List<DndRef> savingThrows;
  final List<DndRef> subclasses;
  final MulticlassingArticlePage multiclassing;
  final List<DndRef> proficiencies;
  final JsonArray? proficiencyChoices;
  final Map<DndRef, int>? equipment;
  final JsonArray? equipmentOptions;

  factory CharClassPage.fromJson(JsonObject json) =>
    CharClassPage(
      classLevels: getApiRequest(json['class_levels']),
      classSpells: getApiRequest(json['spells']),
      spellcasting: json['spellcasting'],
      savingThrows: [
        for (var it in json['saving_throws'])
          DndRef.fromJson(it)
      ],
      subclasses: [
        for (var it in json['subclasses'])
          DndRef.fromJson(it)
      ],
      multiclassing: MulticlassingArticlePage.fromJson(json['multi_classing']),
      proficiencies: [
        for (JsonObject it in json['proficiencies'])
          if (!it['index'].startsWith('saving-throw'))
            DndRef.fromJson(it)
      ],
      proficiencyChoices: json['proficiency_choices'],
      equipment: { 
        for (var it in json['starting_equipment']) 
          DndRef.fromJson(it['equipment']) : it['quantity'] as int 
      },
      // TODO: Deal with the choice variants
      equipmentOptions: json['starting_equipment_options'],
    );

  @override
  Widget build(BuildContext context) {
    var featuresPageContents = <Widget>[
      annotatedLine(
        annotation: "Saving throws: ",
        contents: [
          for (var it in savingThrows)
            TextButtonRef(ref: it)
        ],
      ),
      annotatedLine(annotation: "Subclasses:"),
      for (var it in subclasses)
        ListTileRef(ref: it)
    ];

    if (proficiencies.isNotEmpty) {
      featuresPageContents.add(annotatedLine(
        annotation: "Granted proficiencies: ",
        contents: [
          for (var it in proficiencies)
            TextButtonRef(ref: it)
        ],
      ));
    } else {
      featuresPageContents.add(annotatedLine(
        annotation: "Granted proficiencies: ",
        content: const Text("none"),
      ));
    }
        
    // if (proficiencyChoices != null) {
    //   featuresPageContents += [
    //     annotatedLine(annotation: "Additional proficiencies:"),

    //     for (var choice in proficiencyChoices!)
    //       annotatedLine(
    //         annotation: "Choose ${choice['choose'].toString()} from: ",
    //         contents: [
    //           for (var it in choice['from']['options'])
    //             TextButtonRef.fromJson(it['item'])
    //         ],
    //       )
    //   ];
    // }

    featuresPageContents.add(annotatedLine(annotation: "Starting equipment:"));
    if (equipment?.isNotEmpty ?? false) {
      equipment!.forEach(
        (key, value) => featuresPageContents.add(
          ListTileRef(
            ref: key,
            trailing: Text(
              value.toString(),
              style: const TextStyle(fontSize: 16.0),
            ),
          )
        )
      );
    }
    if (equipmentOptions != null) {
      for (JsonObject option in equipmentOptions!) {
        featuresPageContents.add(
          Padding(padding: pad, child: Text(
            "Choose ${option['choose'].toString()} equipment item(s) from:"
          ))
        );
        // TODO: Understand option types
        final optionSetType = option['from']['option_set_type'] as String;
        switch (optionSetType) {
          case 'equipment_category':
            featuresPageContents.add(Padding(padding: pad, 
              child: TextButtonRef.fromJson(option['from'][optionSetType]),
            ));
            break;
        }
      }
    }

    var tabs = [
      const Tab(text: "Features"),
      const Tab(text: "Levels"),
    ];

    var tabPages = [
      buildTabPage(contents: featuresPageContents),
      buildTabPage(),
    ];

    if (spellcasting != null) {
      tabs.add(const Tab(text: "Spellcasting"));
      tabs.add(const Tab(text: "Spells"));
      tabPages.add(buildTabPage(
        title: "Spellcasting",
        contents: <Widget>[
          annotatedLine(
            annotation: "Level: ", 
            content: Text(spellcasting!['level'].toString()),
          ),
          annotatedLine(
            annotation: "Spellcasting ability: ",
            content: TextButtonRef.fromJson(spellcasting!['spellcasting_ability']), 
          ),
          for (var p in spellcasting!['info'])
            Padding(padding: pad,
              child: MarkdownBody(
                data: "## ${p['name']}\n\n${p['desc'].join("\n\n")}"
              ),
            )
        ],
      ));
      tabPages.add(
        DndPageBuilder(
          request: classSpells!,
          onResult: (json) => RefListPage.fromJsonArray(json['results']),
        )
      );
    }

    tabs.add(const Tab(text: "Multiclassing"));
    tabPages.add(buildTabPage(
      title: "Multiclassing",
      contents: multiclassing.build(),
    ));

    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        appBar: TabBar(
          isScrollable: true,
          tabs: tabs,
        ),
        body: TabBarView(children: tabPages),
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