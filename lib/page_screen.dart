import 'package:flutter/material.dart';
import 'package:dnd_handy_flutter/search_bar.dart';
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
              return RefListPage.fromJsonArray(snapshot.data as List<dynamic>);
            } 
            if (snapshot.data is Map<String, dynamic>) {
              final json = snapshot.data as Map<String, dynamic>;
              if (json.containsKey('desc')) {
                return ArticlePage.fromJson(json);
              }
              if (json.containsKey('results')) {
                return RefListPage.fromJsonArray(json['results'] as List<dynamic>);
              }
            }
            return const Center(
              child: Text('Nothing found')
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
