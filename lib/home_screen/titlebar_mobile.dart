import 'package:flutter/material.dart';
import 'package:dnd_handy_flutter/dnd_app.dart';
import 'package:dnd_handy_flutter/home_screen/search_delegate.dart';
import 'package:go_router/go_router.dart';

class MobileTitleBar extends AppBar {
  MobileTitleBar({
    super.key,
    super.actions,
    String? title,
    required this.appState,
    required void Function() onPressBackButton,
  }) : super(
          leading: InkResponse(
            onLongPress: appState.toggleDrawer,
            onTap: onPressBackButton,
            child: const Icon(Icons.arrow_back),
          ),
          title: Text(title ?? '???'),
        );

  final DndAppSettings appState;

  factory MobileTitleBar.build(
    BuildContext context, {
    List<Widget>? actions,
    String? title,
  }) {
    return MobileTitleBar(
      appState: DndAppSettings.of(context),
      onPressBackButton: () => context.pop(),
      actions: actions,
      title: title,
    );
  }
}

PreferredSizeWidget buildMobileCategoryTitleBar({
  required BuildContext context,
  required String title,
}) {
  return MobileTitleBar.build(
    context,
    title: title,
    actions: [
      IconButton(
        icon: const Icon(Icons.search),
        onPressed: () => showSearchCustom(
          context,
          category: title,
        ),
      ),
    ],
  );
}

PreferredSizeWidget buildMobileHomeTitleBar({
  List<Widget>? actions,
  String? title,
  void Function()? onMenuButtonPressed,
}) {
  return AppBar(
    leading: IconButton(
      onPressed: onMenuButtonPressed,
      icon: const Icon(Icons.menu),
    ),
    title: Text(title ?? 'Handy DnD app'),
    actions: actions,
  );
}
