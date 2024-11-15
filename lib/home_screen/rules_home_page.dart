import 'package:dnd_handy_flutter/api_service.dart';
import 'package:dnd_handy_flutter/page_builder.dart';
import 'package:dnd_handy_flutter/pages/reflist_page.dart';
import 'package:flutter/material.dart';

class RulesHomePage extends StatelessWidget {
  const RulesHomePage({super.key});

  @override
  Widget build(BuildContext context) => DndPageBuilder(
        request: getRequest('/api/rules'),
        onResult: (json) => RefListPage.fromJsonArray(json['results']),
      );
}
