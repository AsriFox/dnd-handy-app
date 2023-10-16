import 'package:dnd_handy_flutter/api_service.dart';
import 'package:dnd_handy_flutter/json_objects.dart';
import 'package:dnd_handy_flutter/page_builder.dart';
import 'package:dnd_handy_flutter/pages/reflist_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:libadwaita/libadwaita.dart';

GoRoute routeCategoryPopups({
  required String name,
  required String path,
  required Widget Function(JsonObject) childBuilder,
}) =>
    GoRoute(
      name: name,
      path: path,
      builder: (_, state) => DndPageScreen.request(
        routerState: state,
        onResult: (json) => RefListPage.fromJsonArray(json['results']),
      ),
      routes: [
        GoRoute(
          path: ':name',
          pageBuilder: (context, state) => CustomTransitionPage(
            child: DescPopup(
              title: state.extra as String? ?? state.pathParameters['name']!,
              child: DndPageBuilder(
                request: DndApiService().getRequest(state.matchedLocation),
                onResult: (json) => childBuilder(json),
              ),
            ),
            transitionsBuilder: (_, animation, __, child) => FadeTransition(
              opacity: CurveTween(curve: Curves.easeInCirc).animate(animation),
              child: child,
            ),
            opaque: false,
            barrierDismissible: true,
            barrierColor: Colors.black.withAlpha(127),
          ),
        ),
      ],
    );

const borderRadius = BorderRadius.all(Radius.circular(12));

class DescPopup extends StatelessWidget {
  const DescPopup({
    super.key,
    required this.title,
    this.child,
  });

  final String title;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final titleBar = Align(
      alignment: Alignment.topCenter,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).appBarTheme.backgroundColor,
          border: Border(
            bottom: BorderSide(color: context.borderColor),
          ),
        ),
        height: 47,
        child: NavigationToolbar(
            middle: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(width: 6),
                AdwWindowButton(
                  buttonType: WindowButtonType.close,
                  onPressed: () => Navigator.of(context).pop(),
                  nativeControls: true,
                ),
                const SizedBox(width: 6),
              ],
            )),
      ),
    );
    return Dialog(
      shape: const RoundedRectangleBorder(borderRadius: borderRadius),
      child: ClipRRect(
        borderRadius: borderRadius,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600, maxHeight: 600),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              titleBar,
              if (child != null)
                Flexible(
                  child: child!,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
