import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:dnd_handy_flutter/home_screen/home_screen.dart';
import 'package:dnd_handy_flutter/home_screen/search_delegate.dart';
import 'package:dnd_handy_flutter/main.dart';
import 'package:flutter/material.dart';

const titleBarDefaultItemsWidth = 56.0;
const titleBarDefaultElevation = 4.0;
const titleBarDefaultShadowColor = Colors.black;

class DesktopTitleBar extends StatelessWidget implements PreferredSizeWidget {
  const DesktopTitleBar({ super.key, });

  @override
  Size get preferredSize => Size.fromHeight(appWindow.titleBarHeight);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // final itemsWidth = titleBarDefaultItemsWidth;
    final elevation = theme.appBarTheme.elevation ?? titleBarDefaultElevation;
    final shadowColor = theme.appBarTheme.shadowColor ?? titleBarDefaultShadowColor;
    final backgroundColor = theme.appBarTheme.backgroundColor ?? theme.colorScheme.surface;
    final surfaceTintColor = theme.appBarTheme.surfaceTintColor;

    return Material(
      elevation: elevation,
      color: backgroundColor,
      shadowColor: shadowColor,
      surfaceTintColor: surfaceTintColor,
      child: Row(children: [
        IconButtonRect(
          width: titleBarDefaultItemsWidth,
          child: const Icon(Icons.menu),
          onTap: () {
            Scaffold.of(context).openDrawer();
            final state = DndAppSettings.of(context);
            state.setState(() {
              state.isExtended = !state.isExtended; 
            });
          },
        ),
        Expanded(
          child: MoveWindow(
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
          )
        ),
        IconButtonRect(
          width: titleBarDefaultItemsWidth,
          child: const Icon(Icons.close),
          onTap: () => appWindow.close(),
        )
      ]),
    );
  }
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
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          width: width ?? double.infinity,
          height: height ?? double.infinity,
          child: child,
        ),
      ),
    );
}