import 'package:dnd_handy_flutter/api_service.dart';
import 'package:dnd_handy_flutter/dnd_app.dart';
import 'package:dnd_handy_flutter/pages/alignments_page.dart';
import 'package:dnd_handy_flutter/pages/article_page.dart';
import 'package:dnd_handy_flutter/pages/page_screen.dart';
import 'package:flutter/material.dart';
import 'package:dnd_handy_flutter/json_objects.dart';
import 'package:dnd_handy_flutter/page_builder.dart';
import 'package:dnd_handy_flutter/pages/reflist_item.dart';
import 'package:dnd_handy_flutter/pages/reflist_page.dart';
import 'package:yeet/yeet.dart';

class HomePage extends StatelessWidget {
  HomePage({ super.key });


  late final yeet = Yeet(
    path: "/",
    builder: (_) => _HomePage(),
    children: [
      Yeet(
        path: "api/alignments",
        builder: (_) => DndPageScreen.request(
          path: "api/alignments",
          onResult: (json) => AlignmentsPage.fromJson(json),
        ),
      ),
      Yeet(
        path: "api/:category",
        builder: (context) => DndPageScreen.request(
          path: context.currentPath, 
          onResult: (json) => RefListPage.fromJsonArray(json['results']),
        ),
      ),
      Yeet(
        path: "api/equipment-categories/:name",
        builder: (context) => DndPageScreen.request(
          path: context.currentPath,
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

class _HomePage extends StatelessWidget {
  _HomePage();

  final Future<dynamic> request = getApiRequest("api");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DndAppSettings.of(context).widget.titleBar(context, true),
      body: DndPageBuilder(
        request: request,
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
    );
  }
}