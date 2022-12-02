import 'package:flutter/material.dart';
import 'package:yeet/yeet.dart';
import 'package:dnd_handy_flutter/dnd_app.dart';
import 'package:dnd_handy_flutter/home_screen/search_delegate.dart';

class MobileTitleBar extends AppBar {
  MobileTitleBar({ 
    super.key,
    super.actions,
    required this.appState,
    void Function()? onPressBackButton,
  }) : super(
    leading: onPressBackButton != null
      ? IconButton(
        onPressed: appState.toggleDrawer,
        icon: menuIcon
      )
      : InkResponse(
        onTap: appState.toggleDrawer,
        onLongPress: onPressBackButton,
        child: menuIcon,
      ),
    title: const Text("Handy DnD app"),
  );

  static const menuIcon = Icon(Icons.menu);
  final DndAppSettings appState;

  factory MobileTitleBar.build(
    BuildContext context, {
    bool isHomePage = false,
    List<Widget>? actions,   
  }) { 
    return MobileTitleBar(
      appState: DndAppSettings.of(context),
      onPressBackButton: isHomePage 
        ? null
        : () => context.yeet(),
      actions: actions,
    );
  }
}
