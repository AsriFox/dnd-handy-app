import 'package:dnd_handy_flutter/api_service.dart';
import 'package:dnd_handy_flutter/dnd_app.dart';
import 'package:dnd_handy_flutter/pages/alignments_page.dart';
import 'package:flutter/material.dart';
import 'package:dnd_handy_flutter/json_objects.dart';
import 'package:dnd_handy_flutter/page_builder.dart';
import 'package:dnd_handy_flutter/pages/reflist_item.dart';
import 'package:dnd_handy_flutter/pages/reflist_page.dart';
import 'package:yeet/yeet.dart';

class HomePage extends StatelessWidget {
  HomePage({ super.key });

  final Future<dynamic> request = getApiRequest("api");

  late final yeet = Yeet(
    path: "/",
    builder: (_) => DndPageBuilder(
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
      ),
    ),
    children: [
      Yeet(
        path: "api/alignments",
        builder: (_) => DndPageBuilder(
          request: getApiRequest("api/alignments"),
          onResult: (json) => AlignmentsPage.fromJson(json),
        ),
      ),
      Yeet(
        path: "api/:category",
        builder: (context) => DndPageBuilder(
          request: getApiRequest("api/${context.params['category']!}"), 
          onResult: (json) => RefListPage.fromJsonArray(json['results']),
        ),
      ),
      Yeet(
        path: "api/equipment-categories/:name",
        builder: (context) => DndPageBuilder(
          request: getApiRequest("api/equipment-categories/${context.params['name']}"),
          onResult: (json) => RefListPage.fromJsonArray(json['equipment'])
        ),
      ),
    ]
  );

  @override
  Widget build(BuildContext context) => Router(
    key: yeetKey,
    routeInformationParser: YeetInformationParser(),
    routerDelegate: YeeterDelegate(yeet: yeet),
  );
}
