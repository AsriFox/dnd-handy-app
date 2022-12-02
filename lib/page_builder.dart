import 'package:dnd_handy_flutter/api_service.dart';
import 'package:dnd_handy_flutter/dnd_app.dart';
import 'package:dnd_handy_flutter/home_screen/titlebar_desktop.dart';
import 'package:dnd_handy_flutter/home_screen/titlebar_mobile.dart';
import 'package:dnd_handy_flutter/json_objects.dart';
import 'package:flutter/material.dart';

class DndPageBuilder extends StatelessWidget {
  const DndPageBuilder({
    super.key,
    this.title = "/",
    required this.request,
    required this.onResult,
  });

  final String title;
  final Future<dynamic> request;
  final Widget Function(dynamic) onResult;

  factory DndPageBuilder.request({
    required String url,
    required Widget Function(dynamic) onResult,
  }) {
    final title = getTitle(url);
    return DndPageBuilder(
      title: title,
      request: getApiRequest(url),
      onResult: onResult,
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = DndAppSettings.of(context);
    final isHomePage = title == "/";

    return Scaffold(
      appBar: appState.widget.titleBar(context, isHomePage),
      body: FutureBuilder(
        future: request,
        builder: (_, snapshot) {
          if (snapshot.hasData) {
            return onResult(snapshot.data);
          } else if (snapshot.hasError) {
            return Center(
              child: Text("Error: ${snapshot.error}"),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        }
      ),
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
  "subraces",
  "traits",
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