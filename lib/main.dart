import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:dnd_handy_flutter/home_screen/titlebar_mobile.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:dnd_handy_flutter/home_screen/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final isDesktop = 
    defaultTargetPlatform == TargetPlatform.linux ||
    defaultTargetPlatform == TargetPlatform.windows;

  final savedThemeMode = await AdaptiveTheme.getThemeMode();
  
  runApp(DndHandyApp(
    isDesktop: isDesktop,
    themeMode: savedThemeMode,
  ));

  if (isDesktop) {
    doWhenWindowReady(() {
      const initialSize = Size(720, 1080);
      appWindow.size = initialSize;
      appWindow.show();
    });
  }
}

class DndHandyApp extends StatelessWidget {
  const DndHandyApp({
    super.key,
    this.isDesktop = false,
    this.themeMode,
  });

  final bool isDesktop;
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
        home: isDesktop
          ? const HomeScreenDesktop()
          : const HomeScreenMobile(),
      )
    );
  }
}
