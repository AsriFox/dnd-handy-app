import 'package:dnd_handy_flutter/api_service.dart';
import 'package:dnd_handy_flutter/home_screen/titlebar_mobile.dart';
import 'package:dnd_handy_flutter/json_objects.dart';
import 'package:dnd_handy_flutter/page_builder.dart';
import 'package:dnd_handy_flutter/pages/page_screen.dart';
import 'package:dnd_handy_flutter/pages/reflist_item.dart';
import 'package:flutter/material.dart';

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

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (_, index) => ListTileRef(
        ref: results[index],
        onTap: gotoPage,
      ),
    );
  }
}

class DndCategoryScreen extends StatelessWidget {
  const DndCategoryScreen({
    super.key,
    required this.category,
    required this.body,
  });

  final String category;
  final Widget body;

  factory DndCategoryScreen.request({
    required String path,
  }) {
    return DndCategoryScreen(
      category: path.split('/').last,
      body: DndPageBuilder(
        request: DndApiService().getRequest(path),
        onResult: (json) => RefListPage.fromJsonArray(json['results']),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildMobileCategoryTitleBar(
        context: context,
        title: category,
      ),
      body: body,
    );
  }
}
