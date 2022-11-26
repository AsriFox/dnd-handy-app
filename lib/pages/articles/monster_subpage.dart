import 'package:dnd_handy_flutter/json_objects.dart';
import 'package:dnd_handy_flutter/pages/article_page.dart';
import 'package:dnd_handy_flutter/pages/reflist_item.dart';
import 'package:flutter/material.dart';

// TODO: Finish and Convert to standalone page
class MonsterArticlePage extends ArticlePage {
  const MonsterArticlePage({
    super.key,
    required this.json,
  });

  final JsonObject json;

  factory MonsterArticlePage.fromJson(JsonObject json) =>
    MonsterArticlePage(json: json);

  @override
  List<Widget> buildChildren() {
    var children = <Widget>[
      annotatedLine(
        annotation: "Type: ",
        content: Text(json['type']),
      ),
    ];

    final subtype = json['subtype'];
    if (subtype != null) {
      children.add(annotatedLine(
        annotation: "Subtype: ",
        content: Text(subtype),
      ));
    }

    children += <Widget>[
      annotatedLine(
        annotation: "Alignment: ",
        content: Text(json['alignment']),
      ),
      annotatedLine(
        annotation: "Size: ",
        content: Text(json['size']),
      ),
      annotatedLine(
        annotation: "Challenge rating: ",
        content: Text("${json['challenge_rating']} (${json['xp']} xp)"),
      ),
      annotatedLine(
        annotation: "Speed:",
        contents: (json['speed'] as Map<String, dynamic>).entries.map(
            (s) => Text(" ${s.key} ${s.value};")
          ).toList(),
      ),
      annotatedLine(
        annotation: "Health: ",
        content: Text("${json['hit_points_roll']} (${json['hit_points']})"),
      ),
      annotatedLine(
        annotation: "Armor class: ",
        content: Text(json['armor_class'].toString()),
      ),
      Padding(
        padding: pad,
        child: Table(
          children: [
            const TableRow(children: [
              TextButtonRef(ref: DndRef(index: 'str', name: "STR", url: 'api/ability-scores/str')),
              TextButtonRef(ref: DndRef(index: 'dex', name: "DEX", url: 'api/ability-scores/dex')),
              TextButtonRef(ref: DndRef(index: 'con', name: "CON", url: 'api/ability-scores/con')),
              TextButtonRef(ref: DndRef(index: 'int', name: "INT", url: 'api/ability-scores/int')),
              TextButtonRef(ref: DndRef(index: 'wis', name: "WIS", url: 'api/ability-scores/wis')),
              TextButtonRef(ref: DndRef(index: 'cha', name: "CHA", url: 'api/ability-scores/cha')),
            ]),
            TableRow(children: [
              Text(json['strength'].toString(), 
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 30.0),
              ),
              Text(json['dexterity'].toString(), 
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 30.0),
              ),
              Text(json['constitution'].toString(), 
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 30.0),
              ),
              Text(json['intelligence'].toString(), 
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 30.0),
              ),
              Text(json['wisdom'].toString(),
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 30.0),
              ),
              Text(json['charisma'].toString(), 
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 30.0),
              ),
            ]),
          ],
        )
      ),
      annotatedLine(
        annotation: "Languages: ",
        content: Text(json['languages']),
      ),
    ];

    return children;
  }
}