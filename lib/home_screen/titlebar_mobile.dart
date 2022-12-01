import 'package:flutter/material.dart';
import 'package:yeet/yeet.dart';
import 'package:dnd_handy_flutter/dnd_app.dart';
import 'package:dnd_handy_flutter/home_screen/search_delegate.dart';

class MobileTitleBar extends StatelessWidget implements PreferredSizeWidget {
  const MobileTitleBar({ 
    super.key,
    this.actions,
    this.isHomePage = false,
  });

  final bool isHomePage;
  final List<Widget>? actions;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    toggleDrawer() {
      Scaffold.of(context).openDrawer();
      final state = DndAppSettings.of(context);
      state.setState(() {
        state.isExtended = !state.isExtended; 
      });
    }
    const menuIcon = Icon(Icons.menu);

    final leadingButton = isHomePage
      ? IconButton(
        onPressed: toggleDrawer,
        icon: menuIcon,
      )
      : InkResponse(
        onTap: () => context.yeet(),
        onLongPress: toggleDrawer,
        child: menuIcon,
      );

    return AppBar(
      title: const Text("Handy DnD database"),
      leading: leadingButton,
      actions: actions,
    );
  }
}
