import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:dnd_handy_flutter/home_screen/titlebar_desktop.dart';
import 'package:dnd_handy_flutter/home_screen/titlebar_mobile.dart';
import 'package:flutter/material.dart';
import 'home_page.dart';
import 'settings_page.dart';

class HomeScreenMobile extends StatelessWidget {
  const HomeScreenMobile({
    super.key,
  });

  @override
  Widget build(BuildContext context) =>
    DefaultTabController(
      length: homeScreenTabs.length, 
      child: Scaffold(
        appBar: buildTitlebarMobile(context),
        bottomNavigationBar: TabBar(tabs: [
          for (var icon in homeScreenTabs.keys)
            Icon(icon)
        ]),
        body: TabBarView(
          children: homeScreenTabs.values.toList()
        ),
      ),
    );
}

class HomeScreenDesktop extends StatelessWidget {
  const HomeScreenDesktop({
    super.key,
  });

  @override
  Widget build(BuildContext context) =>
    WindowBorder(
      color: Theme.of(context).primaryColor,
      child: DefaultTabController(
        length: homeScreenTabs.length,
        child: Scaffold(
          appBar: buildTitlebarDesktop(context),
          body: TabBarView(
            children: homeScreenTabs.values.toList(),
          ),
        ),
      )
    );
}

final homeScreenTabs = <IconData, Widget>{
  Icons.book:
    const HomePage(),
  Icons.account_circle:
    const Center(child: Text("Characters")),
  Icons.settings:
    const SettingsPage(),
};
