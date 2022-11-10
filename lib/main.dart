import 'package:flutter/material.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:dnd_handy_flutter/search_screen.dart';

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
        title: 'Handy DnD Database',
        theme: theme,
        darkTheme: darkTheme,
        home: const SearchScreen(),
      ),
    );
  }
}