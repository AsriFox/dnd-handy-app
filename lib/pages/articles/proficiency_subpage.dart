import 'package:dnd_handy_flutter/page_screen.dart';
import 'package:dnd_handy_flutter/pages/reflist_item.dart';
import 'package:flutter/material.dart';

const bold = TextStyle(fontWeight: FontWeight.bold);
const pad = EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 4.0);

List<Widget> proficiencyArticleSubpage(Map<String, dynamic> json) {
  var children = <Widget>[
    Padding(
      padding: pad,
      child: Row(
        children: [
          const Text("Type: ", style: bold),
          Text(json['type']),
        ],
      ),
    ),
    Padding(
      padding: pad,
      child: Row(
        children: [
          const Text("Subject: ", style: bold),
          TextButtonRef(
            ref: DndRef.fromJson(json['reference']),
            onPressed: showPageScreen,
          ),
        ],
      ),
    ),
  ];
  final races = json['races'] as List<dynamic>;
  if (races.isNotEmpty) {
    children += buildEmbeddedRefList("Races: ", races);
  }
  final classes = json['classes'] as List<dynamic>;
  if (classes.isNotEmpty) {
    children += buildEmbeddedRefList("Classes: ", classes);
  }
  return children;
}

List<Widget> buildEmbeddedRefList(String title, List<dynamic> items) => <Widget>[
  Padding(padding: pad, child: Text(title, style: bold)),
] + items.map((it) { 
    final reference = DndRef.fromJson(it);
    return ListTileRef(
      ref: reference,
      visualDensity: ListDensity.veryDense.d,
      onTap: (ctx, ref) => showPageScreen,
    );
  }).toList();