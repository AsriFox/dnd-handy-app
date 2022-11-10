import 'package:flutter/material.dart';
import 'package:dnd_handy_flutter/api_service.dart';
import 'package:dnd_handy_flutter/search.dart';
import 'package:dnd_handy_flutter/pages/_page_models.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final ApiService _apiService = ApiService();

  final Widget _queryNullText = const Text("Use search");

  String? _title;
  Widget? _queryResult;

  void queryResult(String? path, BuildContext context) async {
    var prevTitle = _title;
    var prevResult = _queryResult;

    if (path == null) {
      setState(() {
        _title = null;
        _queryResult = null;
      });
      return;
    }

    var request = _apiService.getRequest(path);

    setState(() {
      _title = path;
      _queryResult = const Center(
        child: CircularProgressIndicator(),
      );
    });

    await request.then(
      (model) => setState(() {
        _title = model.name;
        _queryResult = buildModelWidget(model, context);
      })
    ).catchError((e) {
      ScaffoldMessenger.of(context)
        .showSnackBar(
          SnackBar(
            content: Text("Nothing found at '$path'")
          )
        );

      setState(() {
        _title = prevTitle;
        _queryResult = prevResult;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_title ?? 'Handy DnD database'),
        actions: [
          IconButton(
            onPressed: () {
              showSearch(
                context: context,
                delegate: CustomSearchDelegate(),
              ).then((value) =>
                queryResult(value, context)
              );
            },
            icon: const Icon(Icons.search),
          )
        ],
      ),
      body: Center(
        child: _queryResult ?? _queryNullText
      ),
    );
  }
}