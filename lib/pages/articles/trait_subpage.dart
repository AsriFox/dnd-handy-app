import 'package:dnd_handy_flutter/json_objects.dart';
import 'package:dnd_handy_flutter/pages/article_page.dart';
import 'package:dnd_handy_flutter/pages/reflist_item.dart';
import 'package:flutter/material.dart';

class TraitArticlePage extends ArticlePage {
  const TraitArticlePage({
    super.key,
    required this.races,
    required this.subraces,
    required this.proficiencies,
    this.proficiencyChoiceCount,
    this.proficiencyChoices,
    this.languageOptionsChoiceCount,
    this.languageOptions,
    this.traitSpecifics,
  });

  final List<DndRef> races;
  final List<DndRef> subraces;
  final List<DndRef> proficiencies;
  final int? proficiencyChoiceCount;
  final List<DndRef>? proficiencyChoices;
  final int? languageOptionsChoiceCount;
  final List<DndRef>? languageOptions;
  final List<Widget>? traitSpecifics;

  factory TraitArticlePage.fromJson(JsonObject json) {
    final int? proficiencyChoiceCount = json['proficiency_choices']?['choose'];
    final JsonArray? proficiencyChoices = json['proficiency_choices']?['from']['options'];
    final int? languageOptionsChoiceCount = json['language_options']?['choose'];
    final JsonArray? languageOptions = json['language_options']?['from']['options'];

    final JsonObject? breathWeapon = json['trait_specific']?['breath_weapon'];
    final JsonObject? subtraitOptions = json['trait_specific']?['subtrait_options'];
    final JsonObject? spellOptions = json['trait_specific']?['spell_options'];
    List<Widget>? traitSpecifics;
    if (breathWeapon != null) {
      traitSpecifics = buildBreathWeaponSubpage(breathWeapon);
    } else if (subtraitOptions != null) {
      traitSpecifics = [
        annotatedLine(
          annotation: "Variants: ",
          content: Text("choose ${subtraitOptions['choose'].toString()} from:"),
        ),
        for (var it in subtraitOptions['from']['options'])
          ListTileRef.fromJson(it['item'], dense: true)
      ];
    } else if (spellOptions != null) {
      traitSpecifics = [
        annotatedLine(
          annotation: "Spells: ",
          content: Text("choose ${spellOptions['choose'].toString()} from:"),
        ),
        for (var it in spellOptions['from']['options'])
          ListTileRef.fromJson(it['item'], dense: true)
      ];
    }
    
    return TraitArticlePage(
      races: DndRef.all(json['races'])!,
      subraces: DndRef.all(json['subraces'])!,
      proficiencies: DndRef.all(json['proficiencies'])!,
      proficiencyChoiceCount: proficiencyChoiceCount,
      proficiencyChoices: DndRef.all(proficiencyChoices),
      languageOptionsChoiceCount: languageOptionsChoiceCount,
      languageOptions: DndRef.all(languageOptions),
      traitSpecifics: traitSpecifics,
    );
  }

  @override
  List<Widget> buildChildren() => [
      if (races.isNotEmpty)
        annotatedLine(
          annotation: "Races: ",
          contents: [
            for (var it in races)
              TextButtonRef(ref: it)
          ],
        ),
      if (subraces.isNotEmpty)
        annotatedLine(
          annotation: "Subraces: ",
          contents: [
            for (var it in subraces)
              TextButtonRef(ref: it)
          ],
        ),
      if (languageOptionsChoiceCount != null)
        annotatedLine(
          annotation: "Language choices: ",
          content: Text("choose $languageOptionsChoiceCount from:"),
        ),
      if (languageOptions?.isNotEmpty ?? false)
        annotatedLine(annotation: "",
          contents: [
            for (var it in languageOptions!)
              TextButtonRef(ref: it)
          ],
        ),
      if (proficiencyChoiceCount != null)
        annotatedLine(
          annotation: "Variants: ",
          content: Text("choose $proficiencyChoiceCount from:"),
        ),
      if (proficiencyChoices?.isNotEmpty ?? false)
        for (var it in proficiencyChoices!)
          ListTileRef(ref: it, dense: true),
      if (traitSpecifics != null)
        for (var it in traitSpecifics!)
          it
    ];
}

List<Widget> buildBreathWeaponSubpage(JsonObject breathWeapon) => [
  annotatedLine(annotation: "",
    content: const TextButtonRef(
      ref: DndRef(
        index: "breath-weapon",
        name: "Breath Weapon",
        url: "api/traits/breath-weapon",
      ),
    )
  ),
  annotatedLine(
    annotation: "Area of effect: ",
    content: Text("${breathWeapon['area_of_effect']['type']} / ${breathWeapon['area_of_effect']['size']}"),
  ),
  annotatedLine(
    annotation: "DC: ",
    content: TextButtonRef.fromJson(breathWeapon['dc']['dc_type']),
  ),
  annotatedLine(
    annotation: "Damage: ",
    content: TextButtonRef.fromJson(breathWeapon['damage'][0]['damage_type']),
  ),
  annotatedLine(annotation: "", 
    contents: [
      for (var entry in breathWeapon['damage'][0]['damage_at_character_level'].entries)
        Text(" ${entry.value} at level ${entry.key};")
    ]
  ),
  const Padding(padding: pad, child: Text("Take half of the damage on successful DC.")),
  annotatedLine(
    annotation: "Usage: ",
    content: Text("${breathWeapon['usage']['times']} times ${breathWeapon['usage']['type']}")
  ),
];