import 'package:dnd_handy_flutter/json_objects.dart';
import 'package:dnd_handy_flutter/pages/page_screen.dart';
import 'package:dnd_handy_flutter/pages/reflist_item.dart';
import 'package:flutter/material.dart';

Future showSearchCustom(BuildContext context) =>
  showSearch(
    context: context, 
    delegate: CustomSearchDelegate(),
  ).then((query) async {
    if (query == null) { 
      throw "nullQuery";
    }
    return query is String
      ? DndRef(
        index: query.split('/').last,
        name: getTitle(query),
        url: query,
      )
      : query is DndRef
        ? query
        : throw query;
  }).then(
    (ref) => gotoPage(context, ref)
  ).catchError((e) {
    if (e != "nullQuery") {
      ScaffoldMessenger.of(context)
        .showSnackBar(
          SnackBar(
            content: Text("Nothing found at '$e'")
          )
        );
    }
  });

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