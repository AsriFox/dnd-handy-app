import 'package:dnd_handy_flutter/api_service.dart';
import 'package:dnd_handy_flutter/dnd_app.dart';
import 'package:dnd_handy_flutter/home_screen/home_screen.dart';
import 'package:dnd_handy_flutter/pages/alignments_page.dart';
import 'package:dnd_handy_flutter/pages/article_page.dart';
import 'package:dnd_handy_flutter/pages/character/background_page.dart';
import 'package:dnd_handy_flutter/pages/character/class_page.dart';
import 'package:dnd_handy_flutter/pages/page_screen.dart';
import 'package:flutter/material.dart';
import 'package:dnd_handy_flutter/json_objects.dart';
import 'package:dnd_handy_flutter/page_builder.dart';
import 'package:dnd_handy_flutter/pages/reflist_item.dart';
import 'package:dnd_handy_flutter/pages/reflist_page.dart';
import 'package:go_router/go_router.dart';

final _router = GoRouter(routes: [
  GoRoute(
      path: '/',
      builder: (_, __) => HomeScreenPage(
          title: 'Database',
          body: DndPageBuilder(
            request: DndApiService().getRequest('api'),
            onResult: (json) => RefListPage(results: [
              for (var entry in (json as JsonObject).entries)
                if (entry.key != 'last_refresh')
                  DndRef(
                    index: entry.key,
                    url: entry.value,
                    name: getTitle(entry.value),
                  )
            ]),
          )),
      routes: [
        GoRoute(
            path: 'alignments',
            builder: (_, state) => DndPageScreen.request(
                  path: 'api${state.uri}',
                  onResult: (json) => AlignmentsPage.fromJson(json),
                )),
        yeetCategory(
            category: 'backgrounds',
            builder: (json) => CharBackgroundPage.fromJson(json)),
        yeetCategory(
            category: 'classes',
            builder: (json) => CharClassPage.fromJson(json)),
        yeetCategory(
            category: 'equipment-categories',
            builder: (json) => RefListPage.fromJsonArray(json['equipment'])),
        ...yeetArticles,
      ]),
]);

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) => Router(
        routeInformationProvider: _router.routeInformationProvider,
        routeInformationParser: _router.routeInformationParser,
        routerDelegate: _router.routerDelegate,
        backButtonDispatcher: _router.backButtonDispatcher,
      );
}
