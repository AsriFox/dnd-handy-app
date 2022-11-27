import 'package:flutter/material.dart';
import 'package:dnd_handy_flutter/home_screen/search_delegate.dart';

AppBar buildTitlebarMobile(BuildContext context) =>
  AppBar(
    title: const Text("Handy DnD database"),
    leading: IconButton(
      onPressed: () => Scaffold.of(context).openDrawer(),
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