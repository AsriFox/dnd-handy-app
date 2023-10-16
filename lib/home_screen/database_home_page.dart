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
import 'package:dnd_handy_flutter/pages/popup_page.dart';
import 'package:dnd_handy_flutter/pages/reflist_page.dart';
import 'package:dnd_handy_flutter/wrapped_list_view.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final _databaseStatsRoutes = [
  routeCategory(
    name: 'Races',
    path: 'races',
    childBuilder: raceArticlePage,
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
    childBuilder: featArticlePage,
  ),
  routeCategory(
    name: 'Magic schools',
    path: 'magic-schools',
    childBuilder: (json) => ArticlePage.fromJson(json),
  ),
  routeCategory(
    name: 'Features',
    path: 'features',
    childBuilder: featureArticlePage,
  ),
  routeCategory(
    name: 'Traits',
    path: 'traits',
    childBuilder: (json) => TraitArticlePage.fromJson(json),
  ),
  routeCategory(
    name: 'Subraces',
    path: 'subraces',
    childBuilder: subraceArticlePage,
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
    childBuilder: monsterArticlePage,
  ),
  routeCategory(
    name: 'Spells',
    path: 'spells',
    childBuilder: spellArticlePage,
  ),
  routeCategory(
    name: 'Equipment',
    path: 'equipment',
    childBuilder: equipmentArticlePage,
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
          onResult: (json) => equipmentArticlePage(json),
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
          onResult: (json) => equipmentArticlePage(json),
        ),
      ),
    ],
  ),
  // routeCategory(name: 'Items', path: 'items', childBuilder: ),
  routeCategory(
    name: 'Magic items',
    path: 'magic-items',
    childBuilder: magicItemArticlePage,
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
    childBuilder: rulesArticlePage,
  ),
  routeCategory(
    name: 'Rule sections',
    path: 'rule-sections',
    childBuilder: (json) => ArticlePage.fromJson(json),
  ),
  routeCategory(
    name: 'Ability scores',
    path: 'ability-scores',
    childBuilder: abilityArticlePage,
  ),
  routeCategory(
    name: 'Skills',
    path: 'skills',
    childBuilder: skillArticlePage,
  ),
  GoRoute(
    name: 'Alignments',
    path: 'alignments',
    builder: (_, state) => DndPageScreen.request(
      routerState: state,
      onResult: (json) => AlignmentsPage.fromJson(json),
    ),
  ),
  routeCategoryPopups(
    name: 'Conditions',
    path: 'conditions',
    childBuilder: (json) => ArticlePage.fromJson(json),
  ),
  routeCategoryPopups(
    name: 'Damage types',
    path: 'damage-types',
    childBuilder: (json) => ArticlePage.fromJson(json),
  ),
  routeCategoryPopups(
    name: 'Languages',
    path: 'languages',
    childBuilder: languageArticlePage,
  ),
  routeCategoryPopups(
    name: 'Proficiencies',
    path: 'proficiencies',
    childBuilder: proficiencyArticlePage,
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
