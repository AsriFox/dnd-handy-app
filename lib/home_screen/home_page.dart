import 'package:dnd_handy_flutter/api_service.dart';
import 'package:dnd_handy_flutter/dnd_app.dart';
import 'package:dnd_handy_flutter/home_screen/home_screen.dart';
import 'package:dnd_handy_flutter/pages/alignments_page.dart';
import 'package:dnd_handy_flutter/pages/article_page.dart';
import 'package:dnd_handy_flutter/pages/character/background_page.dart';
import 'package:dnd_handy_flutter/pages/page_screen.dart';
import 'package:flutter/material.dart';
import 'package:dnd_handy_flutter/json_objects.dart';
import 'package:dnd_handy_flutter/page_builder.dart';
import 'package:dnd_handy_flutter/pages/reflist_item.dart';
import 'package:dnd_handy_flutter/pages/reflist_page.dart';
import 'package:yeet/yeet.dart';

class HomePage extends StatelessWidget {
  HomePage({ super.key });

  final yeet = Yeet(
    path: "/",
    builder: (_) => HomeScreenPage(
      title: "Database",
      body: DndPageBuilder(
        request: getApiRequest('api'),
        onResult: (json) => RefListPage(
          results: [
            for (var entry in (json as JsonObject).entries)
              DndRef(
                index: entry.key,
                url: entry.value as String,
                name: getTitle(entry.value),
              )
          ] 
        )
      ),
    ),
    children: [
      Yeet(
        path: "/alignments",
        builder: (context) => DndPageScreen.request(
          path: "api${context.currentPath}",
          onResult: (json) => AlignmentsPage.fromJson(json),
        ),
      ),
      Yeet(
        path: "/:category",
        builder: (context) => DndPageScreen.request(
          path: "api${context.currentPath}", 
          onResult: (json) => RefListPage.fromJsonArray(json['results']),
        ),
      ),
      Yeet(
        path: "/backgrounds/:name",
        builder: (context) => DndPageScreen.request(
          path: "api${context.currentPath}", 
          onResult: (json) => CharBackgroundPage.fromJson(json), 
        ),
      ),
      Yeet(
        path: "/equipment-categories/:name",
        builder: (context) => DndPageScreen.request(
          path: "api${context.currentPath}",
          onResult: (json) => RefListPage.fromJsonArray(json['equipment'])
        ),
      ),
      yeetArticle,
    ]
  );

  @override
  Widget build(BuildContext context) => Router(
    key: yeetKey,
    routeInformationParser: YeetInformationParser(),
    routerDelegate: YeeterDelegate(yeet: yeet),
  );
}
