import 'package:dnd_handy_flutter/dnd_app.dart';
import 'package:dnd_handy_flutter/home_screen/titlebar_mobile.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:dnd_handy_flutter/api_service.dart';
import 'package:dnd_handy_flutter/json_objects.dart';
import 'package:dnd_handy_flutter/page_builder.dart';
import 'package:dnd_handy_flutter/pages/reflist_item.dart';

gotoPage(BuildContext context, DndRef ref) =>
  context.push(ref.url.substring(4));

class DndPageScreen extends StatelessWidget {
  const DndPageScreen({
    super.key,
    required this.title,
    required this.body,
  });

  final String title;
  final Widget body;

  factory DndPageScreen.request({
    String? title,
    required String path,
    required Widget Function(dynamic) onResult,
  }) {
    return DndPageScreen(
      title: title ?? getTitle(path), 
      body: DndPageBuilder(
        request: DndApiService().getRequest(path),
        onResult: onResult,
      ), 
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MobileTitleBar(
        title: title,
        appState: DndAppSettings.of(context),
        onPressBackButton: () => context.pop(),
      ),
      body: body,
    );
  }
}
