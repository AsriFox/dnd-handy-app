import 'package:dnd_handy_flutter/api_service.dart';
import 'package:dnd_handy_flutter/json_objects.dart';
import 'package:dnd_handy_flutter/home_screen/title_bar.dart';
import 'package:dnd_handy_flutter/page_builder.dart';
import 'package:dnd_handy_flutter/pages/reflist_item.dart';
import 'package:dnd_handy_flutter/wrapped_list_view.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RefListPage extends StatelessWidget {
  const RefListPage({
    super.key,
    required this.results,
    this.visualDensity = VisualDensity.comfortable,
  });

  final List<DndRef> results;
  final VisualDensity visualDensity;

  factory RefListPage.fromJsonArray(
    JsonArray array, {
    visualDensity = VisualDensity.comfortable,
  }) =>
      RefListPage(
        results: [for (var it in array) DndRef.fromJson(it)],
        visualDensity: visualDensity,
      );

  @override
  Widget build(BuildContext context) {
    if (results.isEmpty) {
      return const Center(
        child: Text('No items'),
      );
    }

    return WrappedListView.builder(
      builder: (_, index) => ListTileRef(
        ref: results[index],
        onTap: gotoPage,
      ),
      childCount: results.length,
    );
  }
}

class DndPageScreen extends StatelessWidget {
  const DndPageScreen({
    super.key,
    required this.routerState,
    required this.body,
  });

  final GoRouterState routerState;
  final Widget body;

  factory DndPageScreen.request({
    required GoRouterState routerState,
    required Widget Function(dynamic) onResult,
  }) {
    return DndPageScreen(
      routerState: routerState,
      body: DndPageBuilder(
        request: DndApiService().getRequest(routerState.matchedLocation),
        onResult: onResult,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AdwTitleBar.route(routerState: routerState),
      body: body,
    );
  }
}

GoRoute routeCategory({
  required String name,
  required String path,
  required Widget Function(JsonObject) childBuilder,
}) =>
    GoRoute(
      name: name,
      path: path,
      builder: (_, state) => DndPageScreen.request(
        routerState: state,
        onResult: (json) => RefListPage.fromJsonArray(json['results']),
      ),
      routes: [
        GoRoute(
          path: ':name',
          builder: (_, state) => DndPageScreen.request(
            routerState: state,
            onResult: (json) => childBuilder(json),
          ),
        ),
      ],
    );
