import 'dart:convert';
import 'package:dnd_handy_flutter/pages/article_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dnd_article_model.dart';

class ApiService {
  final String _host = 'dnd5eapi.co';

  String getCategoryName(String? path) {
    if (path == null) return "none";
    var it = path.trim();
    it = it.substring(0, it.lastIndexOf('/'));
    it = it.substring(it.lastIndexOf('/') + 1);
    return it.replaceAll('-', ' ');
  }

  Future<DndArticle> getRequest(String? path) async {
    Response res = await get(
      Uri.https(_host, path ?? ''),
    );
    if (res.statusCode == 200) {
      return DndArticle.fromJson(jsonDecode(res.body));
    } else {
      throw "Failed to complete GET request.";
    }
  }

  FutureBuilder build(String? path) => FutureBuilder<DndArticle>(
    future: getRequest(path),
    builder: (builder, snapshot) {
      if (snapshot.hasData) {
        DndArticle? article = snapshot.data;
        return ArticlePage(
          description: article?.desc,
          category: getCategoryName(path),
        );
      } else {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }
    },
  );
}