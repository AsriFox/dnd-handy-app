import 'package:flutter/material.dart';

class DndPageBuilder extends StatelessWidget {
  const DndPageBuilder({
    super.key,
    required this.request,
    required this.onResult,
  });

  final Future<dynamic> request;
  final Widget Function(dynamic) onResult;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
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