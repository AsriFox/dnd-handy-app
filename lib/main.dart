import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:dnd_handy_flutter/home_screen/home_page.dart';
import 'package:dnd_handy_flutter/home_screen/home_screen.dart';
import 'package:dnd_handy_flutter/home_screen/titlebar_mobile.dart';
import 'package:dnd_handy_flutter/home_screen/titlebar_desktop.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  final isDesktop = 
    defaultTargetPlatform == TargetPlatform.linux ||
    defaultTargetPlatform == TargetPlatform.windows;

  runApp(DndHandyApp(
    isDesktop: isDesktop,
  ));

  if (isDesktop) {
    doWhenWindowReady(() {
      const initialSize = Size(720, 1080);
      appWindow.size = initialSize;
      appWindow.show();
    });
  }
}

class DndHandyApp extends StatefulWidget {
  const DndHandyApp({
    super.key,
    this.isDesktop = false,
  });

  final bool isDesktop;

  @override
  State<StatefulWidget> createState() => DndAppSettings();
}

class DndAppSettings extends State<DndHandyApp> 
  with SingleTickerProviderStateMixin,
       ChangeNotifier {
  ThemeMode? themeMode;
  late TabController controller;
  late SharedPreferences persistent;

  @override
  void initState() {
    super.initState();
    controller = TabController(
      length: appScreens.length,
      vsync: this,
    );
    loadState();
  }

  void loadState() async {
    persistent = await SharedPreferences.getInstance();
    switch (persistent.getString('themeMode')) {
      case 'light':
        themeMode = ThemeMode.light;
        break;
      case 'dark':
        themeMode = ThemeMode.dark;
        break;
      default:
        themeMode = ThemeMode.system;
        break;
    }
    notifyListeners();
  }

  @override
  void setState(VoidCallback fn) {
    super.setState(fn);
    notifyListeners();
    switch (themeMode) {
      case ThemeMode.light:
        persistent.setString('themeMode', 'light');
        break;
      case ThemeMode.dark:
        persistent.setString('themeMode', 'dark');
        break;
      default:
        persistent.setString('themeMode', 'system');
        break;
    }
  }

  int get tabIndex => controller.index;

  set tabIndex(int index) => setState(() {
    controller.index = index;
  });
 
  static DndAppSettings of(BuildContext context) =>
    context.findAncestorStateOfType<DndAppSettings>()!;

  @override
  Widget build(BuildContext context) {
    final titleBar = widget.isDesktop
      ? buildTitlebarDesktop(context)
      : buildTitlebarMobile(context);

    return MaterialApp(
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: themeMode,
      home: HomeScreen(
        titleBar: titleBar,
      ),
    );
  }
}
