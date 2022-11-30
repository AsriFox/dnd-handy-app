import 'package:dnd_handy_flutter/main.dart';
import 'package:flutter/material.dart';
import 'package:dnd_handy_flutter/home_screen/search_delegate.dart';

class MobileTitleBar extends StatelessWidget implements PreferredSizeWidget {
  const MobileTitleBar({ super.key, });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text("Handy DnD database"),
      leading: IconButton(
        onPressed: () {
          Scaffold.of(context).openDrawer();
          final state = DndAppSettings.of(context);
          state.setState(() {
            state.isExtended = !state.isExtended; 
          });
        },
        icon: const Icon(Icons.menu),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () => showSearchCustom(context),
        ),
        // homeScreenMenu,
      ],
    );
  }
}
