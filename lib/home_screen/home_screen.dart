import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:dnd_handy_flutter/home_screen/titlebar_desktop.dart';
import 'package:dnd_handy_flutter/main.dart';
import 'package:dnd_handy_flutter/page_builder.dart';
import 'package:flutter/material.dart';
import 'package:yeet/yeet.dart';
import 'home_page.dart';
import 'settings_page.dart';

// final List<Widget> appScreens = [
//   buildHomePage(),
//   const Center(child: CircularProgressIndicator()),
//   const SettingsPage(),
// ];

final appScreens = {
  const NavigationRailDestination(
    icon: Icon(Icons.book), 
    label: Text("Database"),
  ) 
  : buildHomePage(),

  const NavigationRailDestination(
    icon: Icon(Icons.account_circle), 
    label: Text("Characters"),
  ) 
  : const Center(child: CircularProgressIndicator()),

  const NavigationRailDestination(
    icon: Icon(Icons.settings), 
    label: Text("Settings"),
  ) 
  : const SettingsPage(),
};

class HomeScreen extends StatelessWidget {
  const HomeScreen({ 
    super.key,
    required this.titleBar,
  });

  final PreferredSizeWidget titleBar;

  @override
  Widget build(BuildContext context) {
    final appState = DndAppSettings.of(context);
    final appScreenTabs = TabBarView(
      controller: appState.controller,
      physics: const NeverScrollableScrollPhysics(),
      children: appScreens.values.toList(),
    );

    return LayoutBuilder(
      builder: (_, constraints) {
        if (constraints.maxWidth < 600) {
          return Scaffold(
            appBar: titleBar,
            drawerEdgeDragWidth: 100.0,
            drawer: HomeScreenDrawer(
              state: appState,
            ),
            body: appScreenTabs,
          );
        } else {
          return Scaffold(
            appBar: titleBar,
            body: Row(children: [
              HomeScreenDrawer(
                state: appState,
                isExtended: appState.isExtended,
              ),
              Expanded(
                child: appScreenTabs,
              ),
            ]),
          );
        }
      }
    );
  }
}

class HomeScreenDrawer extends StatelessWidget {
  const HomeScreenDrawer({
    super.key,
    required this.state,
    this.isExtended = true,
  });

  final bool isExtended;
  final DndAppSettings state;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: AnimatedContainer(
        width: isExtended ? 304.0 : titleBarDefaultItemsWidth,
        duration: const Duration(milliseconds: 300),
        curve: Curves.decelerate,
        child: Drawer(
          child: NavigationRail(
            selectedIndex: state.tabIndex,
            onDestinationSelected: (index) {
              state.tabIndex = index;
              Scaffold.of(context).closeDrawer();
            },
            extended: isExtended,
            destinations: appScreens.keys.toList()
          ),
        ),
      )
    );
  }
}

// Widget buildDrawerListTile({
//   bool isExtended = true,
//   required String title,
//   required IconData icon,
//   void Function()? onTap,
// }) => isExtended
//   ? ListTile(
//     leading: Icon(icon),
//     title: Text(title),
//     onTap: onTap,
//   )
//   : ListTile(
//     contentPadding: const EdgeInsets.all(0.0),
//     title: Icon(icon),
//     onTap: onTap,
//   );

