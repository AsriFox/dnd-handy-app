import 'package:dnd_handy_flutter/pages/reflist_item.dart';
import 'package:flutter/material.dart';

class CustomSearchDelegate extends SearchDelegate {
  final List<DndRef> searchTerms = [
    const DndRef(
      index: "classes", 
      name: "Classes", 
      url: "api/classes",
    ),
    const DndRef(
      index: "races",
      name: "Races",
      url: "api/races",
    ),
  ];

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            if (query.isEmpty) {
              close(context, null);
            }
            else {
              query = "";
            }
          },
          icon: const Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () => 
          close(context, query.isEmpty ? null : query),
        icon: const Icon(Icons.search),
    );
  }

  List<DndRef> buildMatchQuery() => [
    for (DndRef cat in searchTerms)
      if (cat.url.toLowerCase().contains(query.toLowerCase()))
        cat
  ];
  
  @override
  Widget buildResults(BuildContext context) {
    final matchQuery = buildMatchQuery();
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (_, index) =>
        ListTileRef(
          ref: matchQuery[index],
          onTap: (ctx, ref) => close(ctx, ref),
        ), 
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final matchQuery = buildMatchQuery();
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (_, index) => 
        ListTileRef(
          ref: matchQuery[index],
          onTap: (_, ref) => query = ref.url,
        ),
    );
  }
}