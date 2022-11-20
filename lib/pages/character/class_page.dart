import 'package:dnd_handy_flutter/api_service.dart';
import 'package:dnd_handy_flutter/page_screen/pages_build.dart';
import 'package:dnd_handy_flutter/pages/article_page.dart';
import 'package:dnd_handy_flutter/pages/character/multiclassing_subpage.dart';
import 'package:dnd_handy_flutter/pages/reflist_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class CharClassPageBuilder extends DndPageBuilder {
  const CharClassPageBuilder({
    super.key,
    required super.request,
  });

  @override
  Widget buildPage(Map<String, dynamic> json) =>
    CharClassPage.fromJson(json);
}

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
  final Map<String, dynamic>? spellcasting;
  final List<DndRef> savingThrows;
  final List<DndRef> subclasses;
  final MulticlassingArticlePage multiclassing;
  final List<DndRef> proficiencies;
  final List<dynamic>? proficiencyChoices;
  final Map<DndRef, int>? equipment;
  final List<dynamic>? equipmentOptions;

  factory CharClassPage.fromJson(Map<String, dynamic> json) {
    // TODO: Deal with the choice variants
    List<dynamic>? equipmentOptions;
    if (json.containsKey('starting_equipment_options')) {
      equipmentOptions = json['starting_equipment_options'];
    }

    Future<dynamic>? classSpells;
    if (json.containsKey('spells')) {
      classSpells = getApiRequest(json['spells']);
    }

    Map<String, dynamic>? spellcasting;
    if (json.containsKey('spellcasting')) {
      spellcasting = json['spellcasting'];
    }

    return CharClassPage(
      classLevels: getApiRequest(json['class_levels']),
      classSpells: classSpells,
      spellcasting: spellcasting,
      savingThrows: (json['saving_throws'] as List<dynamic>)
        .map((it) => DndRef.fromJson(it)).toList(),
      subclasses: (json['subclasses'] as List<dynamic>)
        .map((it) => DndRef.fromJson(it)).toList(),
      multiclassing: MulticlassingArticlePage.fromJson(json['multi_classing']),
      proficiencies: (json['proficiencies'] as List<dynamic>)
        .map((it) => DndRef.fromJson(it)).toList(),
      proficiencyChoices: json['proficiency_choices'],
      equipment: { 
        for (var it in (json['starting_equipment'] as List<dynamic>)) 
          DndRef.fromJson(it['equipment']) : it['quantity'] as int 
      },
      equipmentOptions: equipmentOptions,
    );
  }

  @override
  Widget build(BuildContext context) {
    var bonusPageContents = [
      annotatedLine(annotation: "Starting equipment:"),
    ];
    if (equipment?.isNotEmpty ?? false) {
      bonusPageContents += equipment!.entries.map(
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

    var featuresPageContents = <Widget>[
      annotatedLine(
        annotation: "Saving throws: ",
        contents: savingThrows.map(
          (it) => TextButtonRef(ref: it)
        ).toList(),
      ),
      annotatedLine(annotation: "Subclasses:"),
    ] + subclasses.map(
      (it) => ListTileRef(ref: it)
    ).toList();

    if (proficiencies.isNotEmpty) {
      featuresPageContents.add(annotatedLine(
        annotation: "Granted proficiencies: ",
        contents: proficiencies.map(
          (it) => TextButtonRef(ref: it)
        ).toList(),
      ));
    } else {
      featuresPageContents.add(annotatedLine(
        annotation: "Granted proficiencies: ",
        content: const Text("none"),
      ));
    }
        
    if (proficiencyChoices != null) {
      featuresPageContents.add(annotatedLine(annotation: "Additional proficiencies:"));
      featuresPageContents+= proficiencyChoices!.map(
          (choice) => annotatedLine(
            annotation: "Choose ${choice['choose'].toString()} ${choice['desc']}: ",
            contents: (choice['from']['options'] as List<dynamic>).map(
                (it) => TextButtonRef.fromJson(it['item'])
              ).toList(),
          )
        ).toList();
    }

    featuresPageContents.add(annotatedLine(annotation: "Starting equipment:"));
    if (equipment?.isNotEmpty ?? false) {
      bonusPageContents += equipment!.entries.map(
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
        ] + (spellcasting!['info'] as List<dynamic>).map(
          (p) => Padding(padding: pad,
            child: MarkdownBody(
              data: "## ${p['name']}\n\n${(p['desc'] as List<dynamic>).map((s) => s as String).join("\n\n")}"
            ),
          )
        ).toList(),
      ));

      tabPages.add(RefListPageBuilder(request: classSpells!));
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