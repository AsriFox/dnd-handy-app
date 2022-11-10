import 'package:flutter/material.dart';
import 'package:dnd_handy_flutter/models/dnd_reflist_model.dart';
import '_page_models.dart';

class RefListPage extends StatelessWidget {
  const RefListPage({
    super.key,
    this.results,
  });

  final List<DndRef>? results;

  @override
  Widget build(BuildContext context) {
    if (results == null) {
      return const Text("No items");
    }

    return ListView.builder(
      itemCount: results!.length,
      itemBuilder: (context, index) => 
        buildModelWidget(results![index], context)
    );
  }
}