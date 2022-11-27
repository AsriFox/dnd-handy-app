import 'package:flutter/material.dart';
import 'package:dnd_handy_flutter/json_objects.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'articles/feat_subpage.dart';
import 'articles/race_subpage.dart';
import 'articles/trait_subpage.dart';
import 'articles/spell_subpage.dart';
import 'articles/rules_subpage.dart';
import 'articles/skills_subpage.dart';
import 'articles/ability_subpage.dart';
import 'articles/feature_subpage.dart';
import 'articles/monster_subpage.dart';
import 'articles/subrace_subpage.dart';
import 'articles/language_subpage.dart';
import 'articles/subclass_subpage.dart';
import 'articles/equipment_subpage.dart';
import 'articles/magic_item_subpage.dart';
import 'articles/proficiency_subpage.dart';

class ArticlePage extends StatelessWidget {
  const ArticlePage({
    super.key,
    this.desc,
  });

  final String? desc;
  List<Widget> buildChildren() => [];

  factory ArticlePage.fromJson(JsonObject json, String? category) {
    switch (category ?? getCategoryName(json['url'])) {
      case "ability scores":
        return AbilityArticlePage.fromJson(json);
      case "equipment":
        return EquipmentArticlePage.fromJson(json);
      case "feats":
        return FeatArticlePage.fromJson(json);
      case "features":
        return FeatureArticlePage.fromJson(json);
      case "languages":
        return LanguageArticlePage.fromJson(json);
      case "magic items":
        return MagicItemArticlePage.fromJson(json);
      case "monsters":
        return MonsterArticlePage.fromJson(json);
      case "proficiencies":
        return ProficiencyArticlePage.fromJson(json);
      case "races":
        return RaceArticlePage.fromJson(json);
      case "rules":
        return RulesArticlePage.fromJson(json);
      case "skills":
        return SkillArticlePage.fromJson(json);
      case "spells":
        return SpellArticlePage.fromJson(json);
      case "subclasses":
        return SubclassArticlePage.fromJson(json);
      case "subraces":
        return SubraceArticlePage.fromJson(json);
      case "traits":
        return TraitArticlePage.fromJson(json);
      default:
        final dynamic desc = json['desc'];
        return ArticlePage(
          desc: desc is String ? desc
            : (desc as JsonArray).join("\n\n")
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final children = buildChildren();
    if (desc?.isNotEmpty ?? false) {
      children.insert(0, 
        MarkdownBody(
          data: desc!,
          styleSheet: MarkdownStyleSheet(
            tableCellsPadding: const EdgeInsets.all(4.0),
            tableColumnWidth: const IntrinsicColumnWidth(),
          ),
        )
      );
    }
    return children.isNotEmpty
      ? ListView(
        padding: const EdgeInsets.all(10.0),
        children: children,
      )
      : const Center(child: Text("Empty page"));
  }
}

const pad = EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 4.0);
const bold = TextStyle(fontWeight: FontWeight.bold);

Widget annotatedLine({
  required String annotation, 
  Widget? content,
  List<Widget>? contents,
  EdgeInsetsGeometry padding = pad,
}) { 
  var children = <Widget>[
    Text(annotation, style: bold),
  ];
  if (content != null) {
    children.add(content);
  }
  if (contents != null) {
    children += contents;
  }

  return Padding(
    padding: pad,
    child: Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: children,
    )
  );
}