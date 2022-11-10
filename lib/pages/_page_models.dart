import 'package:flutter/material.dart';
import 'package:dnd_handy_flutter/models/dnd_article_model.dart';
import 'package:dnd_handy_flutter/models/dnd_reflist_model.dart';
import 'article_page.dart';
import 'reflist_page.dart';

String getCategoryName(String? path) {
  if (path == null) return "none";
  var it = path.trim();
  it = it.substring(0, it.lastIndexOf('/'));
  it = it.substring(it.lastIndexOf('/') + 1);
  return it.replaceAll('-', ' ');
}

Widget buildModelWidget(dynamic model, BuildContext context) {
  if (model is DndArticle) {
    return ArticlePage(
      description: model.desc,
      category: getCategoryName(model.url),
    );
  }
  if (model is DndRefList) {
    return RefListPage(results: model.results);
  }
  if (model is DndRef) {
    return ListTile(
      title: Text(model.name!),
      onTap: () {

      },
    );
  }
  throw "Invalid model type";
}