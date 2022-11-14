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

  List<DndRef> buildMatchQuery() =>
    searchTerms.where(
      (cat) => cat.url.toLowerCase()
          .contains(query.toLowerCase())
    ).toList();

  @override
  Widget buildResults(BuildContext context) {
    final matchQuery = buildMatchQuery();
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) => 
        matchQuery[index].buildListTile(
          onTap: (it) => close(context, it),
        ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final matchQuery = buildMatchQuery();
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) => 
        matchQuery[index].buildListTile(
          onTap: (it) => query = it.url,
        ),
    );
  }
}