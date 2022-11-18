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
    List<dynamic> array, {
    visualDensity = VisualDensity.comfortable,
  }) =>
    RefListPage(
      results: array.map(
          (it) => DndRef.fromJson(it),
        ).toList(growable: false),
      visualDensity: visualDensity,
    );

  @override
  Widget build(BuildContext context) {
    if (results.isEmpty) {
      return const Center(
        child: Text("No items"),
      );
    }
    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (_, index) => 
        ListTileRef(ref: results[index]),
    );
  }
}