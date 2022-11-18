import 'package:flutter/material.dart';
import 'package:dnd_handy_flutter/api_service.dart';
import 'package:dnd_handy_flutter/pages/reflist_item.dart';
import 'package:dnd_handy_flutter/pages/reflist_page.dart';
import 'package:dnd_handy_flutter/pages/article_page.dart';
import 'desc_popup.dart';
import 'page_screen.dart';

String getTitle(String path) {
  final it = path.split('/');
  final title = it.last
    .replaceAll('-', ' ');
  return "${title[0].toUpperCase()}${title.substring(1)}";
}

String getCategoryName(String path) {
  final it = path.split('/');
  return it[it.length - 2]
    .replaceAll('-', ' ');
}

Future gotoPage(BuildContext context, DndRef it) {
  if (descListNames.contains(
    getCategoryName(it.url)
  )) {
    return showDialog(
      context: context,
      builder: (ctx) => descPopup(ctx, it),
    );
  } else {
    return Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => pageScreen(ctx, it),
      )
    );
  }
}

const descListNames = [
// Short and simple articles:
  "alignments", 
  "conditions",
  "damage types",
  "magic schools",
  "weapon properties",
// Short articles with small additions:
  "ability scores",
  "feats",
  "languages",
  "proficiencies",
  "skills",
// Complex articles:
  // "Backgrounds",
  "equipment",
  "features",
  "magic items",
  // "Monsters",
  // "Races",
  // "Spells",
  // "Subraces",
  // "Traits",
// Sublists for 'Equipment':
  // "Equipment categories",
// VERY complex articles:
  // "Classes",
  // "Subclasses",
// Long text articles:
  // "Rule sections",
// Sublists for 'Rule sections':
  // "Rules",
];

abstract class DndPageBuilder extends StatelessWidget {
  const DndPageBuilder({
    super.key,
    required this.request,
  });

  final Future<dynamic> request;

  factory DndPageBuilder.request(DndRef ref) {
    if (ref.url == "api") { throw "Main page requested"; }
    final request = getApiRequest(ref.url);
    final category = getCategoryName(ref.url);
    switch (category) {
      case "api":
        return RefListPageBuilder(request: request);
      case "equipment categories":
        return EquipmentListPageBuilder(request: request);
      default:
        return ArticlePage.variant(request: request, category: category);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: request,
      builder: (ctx, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data is Map<String, dynamic>) {
            return buildPage(snapshot.data);
          }
          if (snapshot.data is List<dynamic>) {
            return RefListPage.fromJsonArray(snapshot.data);
          }
          return Center(
            child: Text(
              'Nothing found', 
              style: Theme.of(ctx).textTheme.titleLarge,
            )
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Widget buildPage(Map<String, dynamic> json);
}

class RefListPageBuilder extends DndPageBuilder {
  const RefListPageBuilder({
    super.key,
    required super.request,
  });

  @override
  Widget buildPage(Map<String, dynamic> json) =>
    RefListPage.fromJsonArray(json['results']);
}

class EquipmentListPageBuilder extends DndPageBuilder {
  const EquipmentListPageBuilder({
    super.key,
    required super.request,
  });

  @override
  Widget buildPage(Map<String, dynamic> json) =>
    RefListPage.fromJsonArray(json['equipment']);
}