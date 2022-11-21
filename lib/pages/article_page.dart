import 'package:flutter/material.dart';
import 'package:dnd_handy_flutter/json_objects.dart';
import 'package:dnd_handy_flutter/page_screen/pages_build.dart';
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

class ArticlePage extends DndPageBuilder {
  const ArticlePage({
    super.key,
    required super.request,
  });

  factory ArticlePage.variant({
    required Future<dynamic> request,
    String category = ""
  }) {
    switch (category) {
      case "ability scores":
        return AbilityArticlePage(request: request);
      case "equipment":
        return EquipmentArticlePage(request: request);
      case "feats":
        return FeatArticlePage(request: request);
      case "features":
        return FeatureArticlePage(request: request);
      case "languages":
        return LanguageArticlePage(request: request);
      case "magic items":
        return MagicItemArticlePage(request: request);
      case "monsters":
        return MonsterArticlePage(request: request);
      case "proficiencies":
        return ProficiencyArticlePage(request: request);
      case "races":
        return RaceArticlePage(request: request);
      case "rules":
        return RulesArticlePage(request: request);
      case "skills":
        return SkillArticlePage(request: request);
      case "spells":
        return SpellArticlePage(request: request);
      case "subclasses":
        return SubclassArticlePage(request: request);
      case "subraces":
        return SubraceArticlePage(request: request);
      case "traits":
        return TraitArticlePage(request: request);
      default:
        return ArticlePage(request: request);
    }
  }

  List<Widget>? buildChildren(JsonObject json) => null;

  @override
  Widget buildPage(JsonObject json) {
    var desc = "";
    if (json.containsKey('desc')) {
      if (json['desc'] is String) {
        desc = json['desc'];
      } else if (json['desc'] is JsonArray) {
        for (var s in json['desc']) {
          if ((s as String).contains('|')) {
            // Build tables:
            desc += "\n$s";
          } else {
            // Build paragraphs:
            desc += "$s\n\n";
          }
        }
      }
    }

    final children = buildChildren(json);

    if (desc.isEmpty) {
      if (children != null) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children,
          ),
        );
      }
      return const Center(child: Text("Empty page"));
    }
    
    final body = MarkdownBody(
      data: desc,
      styleSheet: MarkdownStyleSheet(
        tableCellsPadding: const EdgeInsets.all(4.0),
        tableColumnWidth: const IntrinsicColumnWidth(),
      ),
    );

    return SingleChildScrollView(
      padding: const EdgeInsets.all(10.0),
      child: children == null ? body 
        : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 8.0),
              child: body,
            ),
          ] + children
        ),
    );
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