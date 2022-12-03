import 'package:dnd_handy_flutter/pages/page_screen.dart';
import 'package:flutter/material.dart';
import 'package:dnd_handy_flutter/json_objects.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:yeet/yeet.dart';
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

final yeetArticle = Yeet(
  path: "/:category/:name",
  builder: (context) {
    var onResult = (json) {
      final dynamic desc = json['desc'];
      return ArticlePage(
        desc: desc is String ? desc
          : (desc as JsonArray).join("\n\n")
      );
    };
    switch (context.params['category']) {
      case "ability scores":
        onResult = (json) => AbilityArticlePage.fromJson(json);
        break;
      case "equipment":
        onResult = (json) => EquipmentArticlePage.fromJson(json);
        break;
      case "feats":
        onResult = (json) => FeatArticlePage.fromJson(json);
        break;
      case "features":
        onResult = (json) => FeatureArticlePage.fromJson(json);
        break;
      case "languages":
        onResult = (json) => LanguageArticlePage.fromJson(json);
        break;
      case "magic items":
        onResult = (json) => MagicItemArticlePage.fromJson(json);
        break;
      case "monsters":
        onResult = (json) => MonsterArticlePage.fromJson(json);
        break;
      case "proficiencies":
        onResult = (json) => ProficiencyArticlePage.fromJson(json);
        break;
      case "races":
        onResult = (json) => RaceArticlePage.fromJson(json);
        break;
      case "rules":
        onResult = (json) => RulesArticlePage.fromJson(json);
        break;
      case "skills":
        onResult = (json) => SkillArticlePage.fromJson(json);
        break;
      case "spells":
        onResult = (json) => SpellArticlePage.fromJson(json);
        break;
      case "subclasses":
        onResult = (json) => SubclassArticlePage.fromJson(json);
        break;
      case "subraces":
        onResult = (json) => SubraceArticlePage.fromJson(json);
        break;
      case "traits":
        onResult = (json) => TraitArticlePage.fromJson(json);
        break;
    }
    return DndPageScreen.request(
      path: "api${context.currentPath}", 
      onResult: onResult,
    );
  }
);

class ArticlePage extends StatelessWidget {
  const ArticlePage({
    super.key,
    this.desc,
  });

  final String? desc;
  List<Widget> buildChildren() => [];
  
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