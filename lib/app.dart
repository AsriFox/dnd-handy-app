import 'dart:ui';

import 'package:dnd_handy_flutter/home_screen/database_home_page.dart';
import 'package:dnd_handy_flutter/home_screen/settings_page.dart';
import 'package:dnd_handy_flutter/home_screen/title_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DndHandyApp extends StatelessWidget {
  DndHandyApp({
    super.key,
    required this.settings,
    required this.lightTheme,
    required this.darkTheme,
  });

  final SettingsController settings;
  final ThemeData lightTheme;
  final ThemeData darkTheme;

  late final _router = GoRouter(
    navigatorKey: rootNavKey,
    initialLocation: '/api',
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (_, __, shell) => HomeScreen(shell: shell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                name: 'Database',
                path: '/api',
                builder: (_, state) => Scaffold(
                  body: const DatabaseHomePage(),
                  appBar: AdwTitleBar.route(routerState: state),
                ),
                routes: databaseRoutes,
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                name: 'Characters',
                path: '/characters',
                builder: (_, state) => Scaffold(
                  body: const Center(child: Text('TODO: No characters yet')),
                  appBar: AdwTitleBar.route(routerState: state),
                  floatingActionButton: FloatingActionButton(
                    child: const Icon(Icons.add),
                    onPressed: () {},
                  ),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                name: 'Adventure',
                path: '/session',
                builder: (_, state) => Scaffold(
                  body: const Center(child: CircularProgressIndicator()),
                  appBar: AdwTitleBar.route(routerState: state),
                ),
              ),
            ],
          ),
        ],
      ),
    ],
  );

  @override
  Widget build(BuildContext context) => SafeArea(
        child: ListenableBuilder(
          listenable: settings,
          builder: (_, __) => SettingsControllerProvider(
            controller: settings,
            child: MaterialApp.router(
              title: 'DnD Handy App',
              theme: lightTheme,
              darkTheme: darkTheme,
              themeMode: settings.themeMode,
              routerConfig: _router,
              scrollBehavior: settings.isMouseDragScroll
                  ? CustomTouchScrollBehavior()
                  : null,
            ),
          ),
        ),
      );
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
    required this.shell,
  });

  final StatefulNavigationShell shell;

  @override
  Widget build(BuildContext context) =>
      LayoutBuilder(builder: (context, constraints) {
        const destinations = {
          'Database': Icons.book,
          'Characters': Icons.person,
          'Adventure': Icons.map,
        };
        if (constraints.maxWidth < 600) {
          final destWidgets = [
            for (var it in destinations.entries)
              BottomNavigationBarItem(
                icon: Icon(it.value),
                label: it.key,
              ),
          ];
          final navBar = BottomNavigationBar(
            items: destWidgets,
            currentIndex: shell.currentIndex,
            onTap: (index) => shell.goBranch(
              index,
              initialLocation: index == shell.currentIndex,
            ),
          );
          return Column(children: [Expanded(child: shell), navBar]);
        } else {
          final destWidgets = [
            for (var it in destinations.entries)
              NavigationRailDestination(
                icon: Icon(it.value),
                label: Text(it.key),
              ),
          ];
          final navBar = NavigationRail(
            leading: const Icon(Icons.ac_unit, size: 32),
            trailing: const Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: SettingsButton(),
                ),
              ),
            ),
            destinations: destWidgets,
            selectedIndex: shell.currentIndex,
            onDestinationSelected: (index) => shell.goBranch(
              index,
              initialLocation: index == shell.currentIndex,
            ),
            minWidth: 55,
            minExtendedWidth: 165,
          );
          return Row(children: [navBar, Expanded(child: shell)]);
        }
      });
}

// Page<dynamic> _fadeTransition({LocalKey? key, required Widget child}) =>
//     CustomTransitionPage(
//       key: key,
//       child: child,
//       transitionsBuilder: (_, animation, __, child) => FadeTransition(
//         opacity: CurveTween(curve: Curves.easeIn).animate(animation),
//         child: child,
//       ),
//       transitionDuration: const Duration(seconds: 2),
//     );

class CustomTouchScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.mouse,
        ...super.dragDevices,
      };
}
