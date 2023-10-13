import 'package:dnd_handy_flutter/pages/alignments_page.dart';
import 'package:dnd_handy_flutter/pages/article_page.dart';
import 'package:dnd_handy_flutter/pages/articles/ability_subpage.dart';
import 'package:dnd_handy_flutter/pages/articles/equipment_subpage.dart';
import 'package:dnd_handy_flutter/pages/articles/feat_subpage.dart';
import 'package:dnd_handy_flutter/pages/articles/feature_subpage.dart';
import 'package:dnd_handy_flutter/pages/articles/language_subpage.dart';
import 'package:dnd_handy_flutter/pages/articles/magic_item_subpage.dart';
import 'package:dnd_handy_flutter/pages/articles/monster_subpage.dart';
import 'package:dnd_handy_flutter/pages/articles/proficiency_subpage.dart';
import 'package:dnd_handy_flutter/pages/articles/race_subpage.dart';
import 'package:dnd_handy_flutter/pages/articles/rules_subpage.dart';
import 'package:dnd_handy_flutter/pages/articles/skills_subpage.dart';
import 'package:dnd_handy_flutter/pages/articles/spell_subpage.dart';
import 'package:dnd_handy_flutter/pages/articles/subclass_subpage.dart';
import 'package:dnd_handy_flutter/pages/articles/subrace_subpage.dart';
import 'package:dnd_handy_flutter/pages/articles/trait_subpage.dart';
import 'package:dnd_handy_flutter/pages/character/background_page.dart';
import 'package:dnd_handy_flutter/pages/character/class_page.dart';
import 'package:dnd_handy_flutter/pages/reflist_page.dart';
import 'package:dnd_handy_flutter/wrapped_list_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:go_router/go_router.dart';

final _databaseStatsRoutes = [
  routeCategory(
    name: 'Races',
    path: 'races',
    childBuilder: (json) => RaceArticlePage.fromJson(json),
  ),
  routeCategory(
    name: 'Classes',
    path: 'classes',
    childBuilder: (json) => CharClassPage.fromJson(json),
  ),
  routeCategory(
    name: 'Backgrounds',
    path: 'backgrounds',
    childBuilder: (json) => CharBackgroundPage.fromJson(json),
  ),
  routeCategory(
    name: 'Feats',
    path: 'feats',
    childBuilder: (json) => FeatArticlePage.fromJson(json),
  ),
  routeCategory(
    name: 'Magic schools',
    path: 'magic-schools',
    childBuilder: (json) => ArticlePage.fromJson(json),
  ),
  routeCategory(
    name: 'Features',
    path: 'features',
    childBuilder: (json) => FeatureArticlePage.fromJson(json),
  ),
  routeCategory(
    name: 'Traits',
    path: 'traits',
    childBuilder: (json) => TraitArticlePage.fromJson(json),
  ),
  routeCategory(
    name: 'Subraces',
    path: 'subraces',
    childBuilder: (json) => SubraceArticlePage.fromJson(json),
  ),
  routeCategory(
    name: 'Subclasses',
    path: 'subclasses',
    childBuilder: (json) => SubclassArticlePage.fromJson(json),
  ),
];

final _databaseObjectsRoutes = [
  routeCategory(
    name: 'Monsters',
    path: 'monsters',
    childBuilder: (json) => MonsterArticlePage.fromJson(json),
  ),
  routeCategory(
    name: 'Spells',
    path: 'spells',
    childBuilder: (json) => SpellArticlePage.fromJson(json),
  ),
  routeCategory(
    name: 'Equipment',
    path: 'equipment',
    childBuilder: (json) => EquipmentArticlePage.fromJson(json),
  ),
  GoRoute(
    name: 'Weapons',
    path: 'equipment-categories/weapon',
    builder: (_, state) => DndPageScreen.request(
      routerState: state,
      onResult: (json) => RefListPage.fromJsonArray(json['equipment']),
    ),
    routes: [
      GoRoute(
        path: ':name',
        builder: (_, state) => DndPageScreen.request(
          routerState: state,
          onResult: (json) => EquipmentArticlePage.fromJson(json),
        ),
      ),
    ],
  ),
  GoRoute(
    name: 'Armor',
    path: 'equipment-categories/armor',
    builder: (_, state) => DndPageScreen.request(
      routerState: state,
      onResult: (json) => RefListPage.fromJsonArray(json['equipment']),
    ),
    routes: [
      GoRoute(
        path: ':name',
        builder: (_, state) => DndPageScreen.request(
          routerState: state,
          onResult: (json) => EquipmentArticlePage.fromJson(json),
        ),
      ),
    ],
  ),
  // routeCategory(name: 'Items', path: 'items', childBuilder: ),
  routeCategory(
    name: 'Magic items',
    path: 'magic-items',
    childBuilder: (json) => MagicItemArticlePage.fromJson(json),
  ),
  routeCategory(
    name: 'Equipment categories',
    path: 'equipment-categories',
    childBuilder: (json) => RefListPage.fromJsonArray(json['equipment']),
  ),
  // routeCategory(name: 'Generation lists', path: 'generation-lists', childBuilder: ),
];

final _databaseRulesRoutes = [
  routeCategory(
    name: 'Rules',
    path: 'rules',
    childBuilder: (json) => RulesArticlePage.fromJson(json),
  ),
  routeCategory(
    name: 'Rule sections',
    path: 'rule-sections',
    childBuilder: (json) => Markdown(
      data: json['desc'],
      styleSheet: mdTableStyle,
    ),
  ),
  routeCategory(
    name: 'Ability scores',
    path: 'ability-scores',
    childBuilder: (json) => AbilityArticlePage.fromJson(json),
  ),
  routeCategory(
    name: 'Skills',
    path: 'skills',
    childBuilder: (json) => SkillArticlePage.fromJson(json),
  ),
  GoRoute(
    name: 'Alignments',
    path: 'alignments',
    builder: (_, state) => DndPageScreen.request(
      routerState: state,
      onResult: (json) => AlignmentsPage.fromJson(json),
    ),
  ),
  routeCategory(
    name: 'Conditions',
    path: 'conditions',
    childBuilder: (json) => ArticlePage.fromJson(json),
  ),
  routeCategory(
    name: 'Damage types',
    path: 'damage-types',
    childBuilder: (json) => ArticlePage.fromJson(json),
  ),
  routeCategory(
    name: 'Languages',
    path: 'languages',
    childBuilder: (json) => LanguageArticlePage.fromJson(json),
  ),
  routeCategory(
    name: 'Proficiencies',
    path: 'proficiencies',
    childBuilder: (json) => ProficiencyArticlePage.fromJson(json),
  ),
];

final databaseRoutes = [
  ..._databaseStatsRoutes,
  ..._databaseObjectsRoutes,
  ..._databaseRulesRoutes,
];

class DatabaseHomePage extends StatelessWidget {
  const DatabaseHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: const TabBar(
          tabs: [
            Tab(text: 'Stats'),
            Tab(text: 'Objects'),
            Tab(text: 'Rules'),
          ],
        ),
        body: Theme(
          data: Theme.of(context).copyWith(
            listTileTheme: ListTileThemeData(
              titleTextStyle: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
          child: TabBarView(
            children: [
              WrappedListView(
                children: _databaseStatsRoutes
                    .map((route) => HomePageListTile(
                          title: route.name ?? route.path,
                          destination: route.path,
                        ))
                    .toList(),
              ),
              WrappedListView(
                children: _databaseObjectsRoutes
                    .map((route) => HomePageListTile(
                          title: route.name ?? route.path,
                          destination: route.path,
                        ))
                    .toList(),
              ),
              WrappedListView(
                children: _databaseRulesRoutes
                    .map((route) => HomePageListTile(
                          title: route.name ?? route.path,
                          destination: route.path,
                        ))
                    .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HomePageListTile extends StatelessWidget {
  const HomePageListTile({
    super.key,
    required this.title,
    this.destination,
    this.enabled = true,
  });

  final String title;
  final String? destination;
  final bool enabled;

  @override
  Widget build(BuildContext context) => ListTile(
        title: Text(title),
        onTap: destination != null
            ? () => GoRouter.of(context).go('/api/$destination')
            : () {},
        enabled: enabled,
        visualDensity: VisualDensity.comfortable,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      );
}
