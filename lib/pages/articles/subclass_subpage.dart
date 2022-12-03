import 'package:dnd_handy_flutter/api_service.dart';
import 'package:dnd_handy_flutter/json_objects.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:dnd_handy_flutter/pages/article_page.dart';
import 'package:dnd_handy_flutter/pages/reflist_item.dart';

// TODO: Convert to standalone page
class SubclassArticlePage extends StatelessWidget {
  const SubclassArticlePage({
    super.key,
    required this.json,
  });

  final JsonObject json;

  static final yeet = yeetCategory(
    category: "subclasses",
    builder: (json) => SubclassArticlePage.fromJson(json),
  );

  factory SubclassArticlePage.fromJson(JsonObject json) =>
    SubclassArticlePage(json: json);

  @override
  Widget build(BuildContext context) {
    var children = <Widget>[
      annotatedLine(
        annotation: "Base: ",
        content: TextButtonRef.fromJson(json['class']),
      ),
      annotatedLine(
        annotation: "Flavor: ",
        content: Text(json['subclass_flavor']),
      ),
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: MarkdownBody(
          data: json['desc'].join("\n\n"),
        ),
      ),
      annotatedLine(annotation: "Features:"),
      // TODO: Branching features (e.g. druid circles)
      // buildListFuture(
      //   request: getApiRequest("${json['url']}/features"), 
      //   itemBuilder: (ref) => ListTileRef.fromJson(ref),
      // ),
      LevelFeaturesList.request(json['subclass_levels']),
    ];

    final spells = json['spells'] as List<dynamic>;
    if (spells.isNotEmpty) {
      children.add(annotatedLine(annotation: "Spells:"));
      children += spells.map(
          (it) => ExpansionTile(
            title: ListTileRef.fromJson(it['spell']),
            trailing: const Icon(Icons.expand_more),
            expandedCrossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              annotatedLine(
                annotation: "Prerequisites: ",
                contents: (it['prerequisites'] as List<dynamic>).map(
                    (ref) => ref['type'] == "level"
                      ? Text("${ref['name']}, ") 
                      : TextButtonRef.fromJson(ref)
                  ).toList(),
              ),
            ],
          )
        ).toList();
    }

    return SizedBox(
      height: double.maxFinite,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: children,
      ),
    );
  }
}

FutureBuilder buildListFuture({
  required Future<dynamic> request,
  required Widget Function(dynamic) itemBuilder,
}) =>
  FutureBuilder(
    future: request,
    builder: (_, snapshot) {
      if (snapshot.hasData) {
        return SingleChildScrollView(
          child: Column(
            children: snapshot.data is List<dynamic> 
              ? (snapshot.data as List<dynamic>)
                .map(itemBuilder).toList()
              : (snapshot.data['results'] as List<dynamic>)
                .map(itemBuilder).toList(),
          ),
        );
      } else {
        return const SizedBox(
          // width: double.maxFinite,
          height: 60.0,
          child: Center(child: CircularProgressIndicator()),
        );
      }
    }
  );

class LevelFeaturesList extends StatelessWidget {
  const LevelFeaturesList({
    super.key,
    required this.request,
  });

  final Future<dynamic> request;

  factory LevelFeaturesList.request(String url) =>
    LevelFeaturesList(request: getApiRequest(url));

  @override
  Widget build(BuildContext context) {
    return buildListFuture(
      request: request, 
      itemBuilder: (it) => ExpansionTile(
          title: Text("Level ${it['level']}"),
          children: (it['features'] as List<dynamic>).map(
              (ref) => ListTileRef.fromJson(ref)
            ).toList(),
        )
    );
  }
}