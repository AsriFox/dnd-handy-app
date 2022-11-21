import 'package:dnd_handy_flutter/json_objects.dart';
import 'package:dnd_handy_flutter/pages/article_page.dart';
import 'package:dnd_handy_flutter/pages/reflist_item.dart';
import 'package:flutter/material.dart';

const padButt = EdgeInsets.fromLTRB(16.0, 4.0, 16.0, 0.0);

class MagicItemArticlePage extends ArticlePage {
  const MagicItemArticlePage({
    super.key,
    required super.request,
  });

  @override
  List<Widget>? buildChildren(JsonObject json) {
    var children = <Widget>[
      annotatedLine(
        annotation: "Category: ",
        padding: padButt,
        content: TextButtonRef.fromJson(json['equipment_category']),
      ),
      annotatedLine(
        annotation: "Rarity: ",
        content: Text(json['rarity']['name'].toString()),
      ),
    ];

    if (json['variant'] as bool) {
      children.add(const Padding(
        padding: pad, 
        child: Text("Is a variant")
      ));
    }

    if (json['variants'].isNotEmpty) {
      children += [
        annotatedLine(annotation: "Variants:"),
        for (var it in json['variants'])
          ListTileRef.fromJson(it),
      ];
    }

    return children;
  }
}