import 'package:dnd_handy_flutter/page_screen.dart';
import 'package:dnd_handy_flutter/pages/reflist_item.dart';
import 'package:flutter/material.dart';

class RefListPage extends StatelessWidget {
  const RefListPage({
    super.key,
    required this.results,
  });

  final List<DndRef> results;

  factory RefListPage.fromJsonArray(List<dynamic> array) =>
    RefListPage(
      results: array.map(
          (it) => DndRef.fromJson(it),
        ).toList(growable: false),
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
      itemBuilder: (context, index) => 
        results[index].build(
          onTap: (it) => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => PageScreen.request(it.url),
            )
          )
        ),
    );
  }
}