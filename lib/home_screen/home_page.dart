import 'package:flutter/material.dart';
import 'package:dnd_handy_flutter/api_service.dart';
import 'package:dnd_handy_flutter/json_objects.dart';
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
          return RefListPage(
            results: [
              for (var entry in (snapshot.data as JsonObject).entries)
                DndRef(
                  index: entry.key,
                  url: entry.value as String,
                  name: getTitle(entry.value),
                )
            ],
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
