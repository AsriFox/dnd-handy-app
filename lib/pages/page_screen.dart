import 'package:dnd_handy_flutter/pages/article_page.dart';
import 'package:flutter/material.dart';
import 'package:dnd_handy_flutter/api_service.dart';
import 'package:dnd_handy_flutter/json_objects.dart';
import 'package:dnd_handy_flutter/page_builder.dart';
import 'package:dnd_handy_flutter/pages/reflist_item.dart';

Future gotoPage(BuildContext context, DndRef ref) =>
  Navigator.push(context,
    MaterialPageRoute(
      builder: (_) => DndPageBuilder(
        request: getApiRequest(ref.url), 
        onResult: (json) => DndPageScreen.fronJson(json),
      )
    )
  );

class DndPageScreen extends StatelessWidget {
  const DndPageScreen({ 
    super.key,
    required this.title, 
    required this.builder,
  });

  final String title;
  final Widget Function() builder;

  factory DndPageScreen.fronJson(JsonObject json) {
    String title = "N/A";
    Widget Function() builder = () => const Center(
      child: Text("Nothing found")
    );

    if (json.containsKey('index')) {
      title = json['name'];
      switch (getCategoryName(json['url'])) {
        default:
          builder = () => ArticlePage.fromJson(json, 
            getCategoryName(json['url'])
          );
          break;
      }
    }
    return DndPageScreen(
      title: title, 
      builder: builder,
    );
  }

  @override
  Widget build(BuildContext context) =>
    Scaffold(
      appBar: AppBar(
        title: Text(title),
        leading: InkResponse(
          onTap: () => Navigator.pop(context),
          onDoubleTap: () => Navigator.popUntil(context, (route) => route.isFirst),
          onTapCancel: () => ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Tap the button twice to return to the home screen"))
          ),
          child: const Icon(Icons.arrow_back),
        ),
      ),
      body: builder()
    );
}
