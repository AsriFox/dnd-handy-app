import 'package:flutter/material.dart';
import 'package:dnd_handy_flutter/api_service.dart';
import 'package:dnd_handy_flutter/page_screen.dart';
import 'package:dnd_handy_flutter/pages/reflist_item.dart';

class HomePage extends StatelessWidget {
  const HomePage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getApiRequest('api').catchError((_) => null),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return HomeRefList.fromJson(
            snapshot.data as Map<String, dynamic>
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}

class HomeRefList extends StatelessWidget {
  const HomeRefList({
    super.key,
    required this.items,
  });

  final List<DndRef> items;

  factory HomeRefList.fromJson(Map<String, dynamic> json) {
    var children = List<DndRef>.empty(growable: true);
    json.forEach((key, value) => children.add(
      DndRef(
        index: key,
        url: value as String,
        name: PageScreen.getTitle(value),
      )
    ));
    return HomeRefList(items: children);
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: items.map((it) => ListTileRef(
        ref: it,
        onTap: showPageScreen,
      )).toList(),
    );
  }
}