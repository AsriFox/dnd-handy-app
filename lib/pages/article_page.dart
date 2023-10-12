import 'package:dnd_handy_flutter/pages/reflist_page.dart';
import 'package:flutter/material.dart';
import 'package:dnd_handy_flutter/json_objects.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:go_router/go_router.dart';
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

GoRoute yeetCategory({
  required String category,
  required Widget Function(dynamic) builder,
}) =>
    GoRoute(
      path: category,
      builder: (_, state) => DndPageScreen.request(
        routerState: state,
        onResult: (json) => RefListPage.fromJsonArray(json['results']),
      ),
      routes: [
        GoRoute(
            path: ':name',
            builder: (_, state) => DndPageScreen.request(
                  routerState: state,
                  onResult: builder,
                )),
      ],
    );

final yeetArticles = [
  AbilityArticlePage.yeet,
  EquipmentArticlePage.yeet,
  FeatArticlePage.yeet,
  FeatureArticlePage.yeet,
  LanguageArticlePage.yeet,
  MagicItemArticlePage.yeet,
  MonsterArticlePage.yeet,
  ProficiencyArticlePage.yeet,
  RaceArticlePage.yeet,
  RulesArticlePage.yeet,
  SkillArticlePage.yeet,
  SpellArticlePage.yeet,
  SubclassArticlePage.yeet,
  SubraceArticlePage.yeet,
  TraitArticlePage.yeet,
  yeetCategory(
      category: 'rule-sections',
      builder: (json) => Markdown(
            data: json['desc'],
            styleSheet: mdTableStyle,
          )),
  for (String cat in const [
    'conditions',
    'damage-types',
    'magic-schools',
    'weapon-properties',
  ])
    yeetCategory(
      category: cat,
      builder: (json) => ArticlePage.fromJson(json),
    ),
];

class ArticlePage extends StatelessWidget {
  const ArticlePage({
    super.key,
    this.desc,
  });

  final String? desc;

  List<Widget> buildChildren() => [];

  factory ArticlePage.fromJson(JsonObject json) {
    final desc = json['desc'];
    return ArticlePage(
      desc: desc is String
          ? desc
          : [
              for (String p in desc)
                if (p.contains('|')) p else '\n$p\n'
            ].join('\n'),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (desc == null) {
      return const Center(child: Text('Empty page'));
    }
    return Padding(
        padding: const EdgeInsets.all(10.0),
        child: MarkdownBody(
          data: desc!,
          styleSheet: mdTableStyle,
        ));
  }
}

const pad = EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 4.0);
const bold = TextStyle(fontWeight: FontWeight.bold);

final mdTableStyle = MarkdownStyleSheet(
  tableCellsPadding: const EdgeInsets.all(4.0),
  tableColumnWidth: const IntrinsicColumnWidth(),
);

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
      ));
}
