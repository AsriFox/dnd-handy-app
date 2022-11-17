import 'package:flutter/material.dart';
import 'package:dnd_handy_flutter/api_service.dart';
import 'package:dnd_handy_flutter/page_screen/pages_build.dart';
import 'package:dnd_handy_flutter/pages/reflist_item.dart';
import 'package:dnd_handy_flutter/pages/reflist_page.dart';

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
          var children = List<DndRef>.empty(growable: true);
          (snapshot.data as Map<String, dynamic>)
            .forEach((key, value) => children.add(
              DndRef(
                index: key,
                url: value as String,
                name: getTitle(value),
              )
            ));
          return RefListPage(results: children);
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
