import 'package:dnd_handy_flutter/api_service.dart';
import 'package:dnd_handy_flutter/json_objects.dart';
import 'package:dnd_handy_flutter/page_builder.dart';
import 'package:dnd_handy_flutter/pages/reflist_item.dart';
import 'package:dnd_handy_flutter/pages/reflist_page.dart';

DndPageBuilder buildHomePage() =>
  DndPageBuilder(
    request: getApiRequest('api'),
    onResult: (json) => RefListPage(
      results: [
        for (var entry in (json as JsonObject).entries)
          DndRef(
            index: entry.key,
            url: entry.value as String,
            name: getTitle(entry.value),
          )
      ] 
    ),
  );
