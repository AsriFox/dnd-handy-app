import 'package:dnd_handy_flutter/home_screen/search_delegate.dart';
import 'package:flutter/material.dart';
import 'package:dnd_handy_flutter/dnd_app.dart';
import 'package:dnd_handy_flutter/home_screen/titlebar_mobile.dart';
import 'home_page.dart';
import 'settings_page.dart';

class HomeScreenPage extends StatelessWidget {
  const HomeScreenPage({
    super.key,
    this.body,
    this.title = '',
  });

  final Widget? body;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildMobileHomeTitleBar(
        title: title,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => showSearchCustom(context),
          )
        ],
        onMenuButtonPressed: DndAppSettings.of(context).toggleDrawer,
      ),
      body: body,
    );
  }
}

final appScreens = {
  const NavigationRailDestination(
    icon: Icon(Icons.book),
    label: Text('Database'),
  ): const HomePage(),
  const NavigationRailDestination(
    icon: Icon(Icons.account_circle),
    label: Text('Characters'),
  ): const HomeScreenPage(
    title: 'Characters',
    body: Center(child: CircularProgressIndicator()),
  ),
  const NavigationRailDestination(
    icon: Icon(Icons.settings),
    label: Text('Settings'),
  ): const HomeScreenPage(
    title: 'Settings',
    body: SettingsPage(),
  ),
};

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
    this.drawerKey,
  });

  final GlobalKey<ScaffoldState>? drawerKey;

  @override
  Widget build(BuildContext context) {
    final appState = DndAppSettings.of(context);
    final appScreenTabs = TabBarView(
      controller: appState.controller,
      physics: const NeverScrollableScrollPhysics(),
      children: appScreens.values.toList(),
    );

    return LayoutBuilder(builder: (_, constraints) {
      if (constraints.maxWidth < 600) {
        final drawer = HomeScreenDrawer(
          state: appState,
          isExtended: true,
          drawerKey: drawerKey,
        );

        return Scaffold(
          key: drawerKey,
          drawerEdgeDragWidth: 100.0,
          drawer: SafeArea(
            child: drawer,
          ),
          body: appScreenTabs,
        );
      } else {
        final drawer = HomeScreenDrawer(
          state: appState,
          isExtended: appState.isExtended,
        );

        return SizedBox.expand(
          child: Row(children: [
            AnimatedContainer(
              width: appState.isExtended ? 240.0 : 56.0,
              duration: const Duration(milliseconds: 300),
              curve: Curves.decelerate,
              child: SafeArea(child: drawer),
            ),
            Expanded(
              child: appScreenTabs,
            ),
          ]),
        );
      }
    });
  }
}

class HomeScreenDrawer extends StatelessWidget {
  const HomeScreenDrawer({
    super.key,
    required this.state,
    this.isExtended = true,
    this.drawerKey,
  });

  final bool isExtended;
  final DndAppSettings state;
  final GlobalKey<ScaffoldState>? drawerKey;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Scaffold(
        body: NavigationRail(
            extended: isExtended,
            selectedIndex: state.tabIndex,
            onDestinationSelected: (index) {
              state.tabIndex = index;
              if (drawerKey?.currentState?.isDrawerOpen ?? false) {
                drawerKey!.currentState!.closeDrawer();
              }
            },
            destinations: appScreens.keys.toList()),
        floatingActionButton: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Align(
              alignment: Alignment.bottomRight,
              child: IconButton(
                icon:
                    Icon(isExtended ? Icons.chevron_left : Icons.chevron_right),
                onPressed: state.toggleDrawer,
              )),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }
}
