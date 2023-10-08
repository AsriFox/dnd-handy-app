import 'package:dnd_handy_flutter/api_service.dart';
import 'package:dnd_handy_flutter/json_objects.dart';
import 'package:dnd_handy_flutter/page_builder.dart';
import 'package:dnd_handy_flutter/pages/page_screen.dart';
import 'package:dnd_handy_flutter/pages/reflist_item.dart';
import 'package:flutter/material.dart';

Future showSearchCustom(BuildContext context, {String? category}) => showSearch(
      context: context,
      delegate: category != null
          ? CategorySearchDelegate(
              category: category,
              request: DndApiService().getRequest('api/$category'),
            )
          : CustomSearchDelegate(
              request: DndApiService().getRequest('api'),
            ),
    )
        .then((query) async {
          if (query == null) {
            throw 'nullQuery';
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
        })
        .then((ref) => gotoPage(context, ref))
        .catchError((e) {
          if (e != 'nullQuery') {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text('Nothing found at "$e"')));
          }
        });

class CustomSearchDelegate extends SearchDelegate {
  CustomSearchDelegate({required this.request});

  final Future<JsonObject?> request;

  @override
  String? get searchFieldLabel => 'Search database';

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          if (query.isEmpty) {
            close(context, null);
          } else {
            query = '';
          }
        },
        icon: const Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () => close(context, query.isEmpty ? null : query),
      icon: const Icon(Icons.search),
    );
  }

  // TODO: search everywhere
  Future<List<DndRef>> buildMatchList() async {
    final json = (await request)!;
    return [
      for (var it in json.entries)
        DndRef(
          index: it.key,
          name: getTitle(it.value),
          url: it.value,
        )
    ];
  }

  Widget buildMatches(dynamic Function(BuildContext, DndRef) onTap) {
    return DndPageBuilder(
        request: buildMatchList(),
        onResult: (matches) => ListView.builder(
              itemCount: matches.length,
              itemBuilder: (_, index) => ListTileRef(
                ref: matches[index],
                onTap: onTap,
              ),
            ));
  }

  @override
  Widget buildResults(BuildContext context) => buildMatches(close);

  @override
  Widget buildSuggestions(BuildContext context) =>
      buildMatches((_, ref) => query = ref.name);
}

class CategorySearchDelegate extends CustomSearchDelegate {
  CategorySearchDelegate({
    required this.category,
    required super.request,
  });

  final String category;

  @override
  Future<List<DndRef>> buildMatchList() async {
    final json = (await request)!;
    return [
      for (JsonObject it in json['results'])
        if (it['name'].toLowerCase().contains(query.toLowerCase()))
          DndRef.fromJson(it)
    ];
  }
}
