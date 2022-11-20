import 'package:dnd_handy_flutter/home_screen/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:dnd_handy_flutter/home_screen/search_bar.dart';
import 'package:dnd_handy_flutter/home_screen/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final savedThemeMode = await AdaptiveTheme.getThemeMode();
  runApp(DndHandyApp(themeMode: savedThemeMode));
}

class DndHandyApp extends StatelessWidget {
  const DndHandyApp({super.key, this.themeMode});

  final AdaptiveThemeMode? themeMode;

  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
      light: ThemeData.light(),
      dark: ThemeData.dark(),
      initial: themeMode ?? AdaptiveThemeMode.system,
      builder: (theme, darkTheme) => MaterialApp(
        title: 'Handy DnD app',
        theme: theme,
        darkTheme: darkTheme,
        home: const HomeScreen(),
      )
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: SearchAppBar(
          title: 'Handy DnD database', 
          leading: IconButton(
            onPressed: () {},
            icon: const Icon(Icons.menu),
          ),
        ),
        bottomNavigationBar: const TabBar(tabs: [
          Tab(icon: Icon(Icons.book)),
          Tab(icon: Icon(Icons.account_circle)),
          Tab(icon: Icon(Icons.settings)),
        ]),
        body: const TabBarView(children: [
          HomePage(),
          Center(child: Text("Characters")),
          SettingsPage(),
        ]),
      )
    );
  }
}
