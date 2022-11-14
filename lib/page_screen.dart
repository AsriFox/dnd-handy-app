import 'package:flutter/material.dart';
import 'package:dnd_handy_flutter/api_service.dart';
import 'package:dnd_handy_flutter/pages/article_page.dart';
import 'package:dnd_handy_flutter/pages/reflist_page.dart';

class PageScreen extends StatelessWidget {
  const PageScreen({
    super.key,
    required this.title,
    required this.request,
  });

  final String title;
  final Future<dynamic> request;

  factory PageScreen.request(String url) => 
    PageScreen(
      title: getTitle(url),
      request: getApiRequest(url)
        .catchError((_) => null),
    );

  static String getCategoryName(String path) {
    var it = path.trim();
    it = it.substring(0, it.lastIndexOf('/'));
    it = it.substring(it.lastIndexOf('/') + 1);
    return it.replaceAll('-', ' ');
  }

  static String getTitle(String path) {
    var it = path.trim();
    it = it.substring(it.lastIndexOf('/') + 1);
    it = it[0].toUpperCase() + it.substring(1);
    return it.replaceAll('-', ' ');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title), 
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(), 
          icon: const Icon(Icons.arrow_back),
        ),
        actions: [
          IconButton(
            onPressed: () => Navigator.of(context)
              .popUntil((route) => route.isFirst), 
            icon: const Icon(Icons.home),
          ),
        ],
      ),
      body: FutureBuilder(
        future: request,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data is List<dynamic>) {
              return RefListPage.fromJsonArray(
                snapshot.data as List<dynamic>
              );
            }
            return selectAndBuildPage(
              snapshot.data as Map<String, dynamic>, 
              title
            ) ?? Center(
              child: Text(
                'Nothing found', 
                style: Theme.of(context).textTheme.titleLarge,
              )
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}

const descListNames = [
// Short and simple articles:
  "Alignments", 
  "Conditions",
  "Damage types",
  "Magic schools",
  "Weapon properties",
// Short articles with small additions:
  "Ability scores",
  "Feats",
  "Features",
  "Languages",
  "Skills",
// Medium-complexity articles (?):
  // "Proficiencies",
  // "Traits",
// Complex articles:
  // "Backgrounds",
  // "Equipment",
  // "Magic items",
  // "Monsters",
  // "Races",
  // "Spells",
  // "Subraces",
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

Widget? selectAndBuildPage(Map<String, dynamic> json, String title) {
  if (json.containsKey('desc')) {
    return ArticlePage.fromJson(json);
  }
  if (json.containsKey('results')) {
    return RefListPage.fromJsonArray(
      json['results'] as List<dynamic>,
      isDescList: descListNames.contains(title),
    );
  }
  if (json.containsKey('equipment')) {
    return RefListPage.fromJsonArray(json['equipment']);
  }
  return null;
}