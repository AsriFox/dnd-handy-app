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
  Widget build(BuildContext context) => Scaffold(
        body: shell,
        bottomNavigationBar: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Database'),
            BottomNavigationBarItem(
                icon: Icon(Icons.person), label: 'Characters'),
            BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Adventure'),
          ],
          currentIndex: shell.currentIndex,
          onTap: (index) => shell.goBranch(
            index,
            initialLocation: index == shell.currentIndex,
          ),
        ),
      );
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
