import 'package:dnd_handy_flutter/wrapped_list_view.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
          child: const TabBarView(
            children: [
              WrappedListView(children: [
                HomePageListTile(title: 'Races'),
                HomePageListTile(title: 'Classes'),
                HomePageListTile(title: 'Backgrounds'),
                HomePageListTile(title: 'Feats'),
                HomePageListTile(title: 'Magic schools', enabled: false),
                HomePageListTile(title: 'Features', enabled: false),
                HomePageListTile(title: 'Traits', enabled: false),
              ]),
              WrappedListView(children: [
                HomePageListTile(title: 'Monsters'),
                HomePageListTile(title: 'Spells'),
                HomePageListTile(title: 'Weapons'),
                HomePageListTile(title: 'Armor'),
                HomePageListTile(title: 'Items'),
                HomePageListTile(title: 'Magic items', enabled: false),
                HomePageListTile(title: 'Equipment categories', enabled: false),
                HomePageListTile(title: 'Generation lists', enabled: false),
              ]),
              WrappedListView(children: [
                HomePageListTile(title: 'Ability scores'),
                HomePageListTile(title: 'Skills'),
                HomePageListTile(title: 'Alignments'),
                HomePageListTile(title: 'Conditions'),
                HomePageListTile(title: 'Damage types'),
                HomePageListTile(title: 'Languages'),
                HomePageListTile(title: 'Proficiencies', enabled: false),
              ]),
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
      );
}
