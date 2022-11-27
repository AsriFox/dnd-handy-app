import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:dnd_handy_flutter/home_screen/home_screen.dart';
import 'package:dnd_handy_flutter/home_screen/search_delegate.dart';
import 'package:flutter/material.dart';

PreferredSizeWidget buildTitlebarDesktop(BuildContext context) {
  const titlebarItemsWidth = 40.0;
  const defaultElevation = 4.0;
  const defaultShadowColor = Colors.black;
  final appBarTheme = Theme.of(context).appBarTheme;
  final tabBar = TabBar(
    labelPadding: const EdgeInsets.symmetric(vertical: 4.0),
    tabs: [
      for (var icon in homeScreenTabs.keys)
        Icon(icon)
    ]
  );

  return PreferredSize(
    preferredSize: Size.fromHeight(
      appWindow.titleBarHeight
    ),
    child: Material(
      shape: appBarTheme.shape,
      color: appBarTheme.backgroundColor ?? Theme.of(context).colorScheme.surface,
      shadowColor: appBarTheme.shadowColor ?? defaultShadowColor,
      surfaceTintColor: appBarTheme.surfaceTintColor,
      elevation: appBarTheme.elevation ?? defaultElevation,
      child: Row(children: [
        Expanded(child: MoveWindow(
          child: Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                "Handy DnD database",
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          ),
        )),
        IconButtonRect(
          width: titlebarItemsWidth,
          onTap: () => showSearchCustom(context),
          child: const Icon(Icons.search),
        ),
        SizedBox(
          width: titlebarItemsWidth * homeScreenTabs.length,
          child: tabBar,
        ),
        // homeScreenMenu,
        IconButtonRect(
          width: titlebarItemsWidth,
          onTap: () => appWindow.close(),
          child: const Icon(Icons.close),
        ),
      ]),
    ),
  );
}

class IconButtonRect extends StatelessWidget {
  const IconButtonRect({
    super.key,
    this.width,
    this.height,
    this.child,
    this.onTap,
  });

  final double? width;
  final double? height;
  final Widget? child;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) =>
    Material(
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          width: width ?? double.infinity,
          height: height ?? double.infinity,
          child: child,
        ),
      ),
      color: Colors.transparent,
    );
}