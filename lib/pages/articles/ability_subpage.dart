import 'package:dnd_handy_flutter/page_screen/pages_build.dart';
import 'package:dnd_handy_flutter/pages/article_page.dart';
import 'package:dnd_handy_flutter/pages/reflist_item.dart';
import 'package:flutter/material.dart';

class AbilityArticlePage extends ArticlePage {
  const AbilityArticlePage({
    super.key,
    required super.request,
  });

  @override
  List<Widget>? buildChildren(Map<String, dynamic> json) => 
    <Widget>[
      const Padding(
        padding: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 4.0),
        child: Text(
          "Associated skills:",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      )
    ] + (json['skills'] as List<dynamic>)
      .map(
        (it) => ListTileRef(
          ref: DndRef.fromJson(it),
          visualDensity: ListDensity.veryDense.d,
          onTap: gotoPage,
        )
      ).toList();

}