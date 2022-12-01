import 'package:dnd_handy_flutter/home_screen/search_delegate.dart';
import 'package:flutter/material.dart';
import 'package:yeet/yeet.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_screen/home_screen.dart';
import 'home_screen/titlebar_mobile.dart';
import 'home_screen/titlebar_desktop.dart';

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

  bool isExtended = false;

  static DndAppSettings of(BuildContext context) =>
    context.findAncestorStateOfType<DndAppSettings>()!;

  @override
  Widget build(BuildContext context) {
    final titleBar = widget.isDesktop
      ? const DesktopTitleBar(
        isHomePage: true,
      )
      : MobileTitleBar(
        isHomePage: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => showSearchCustom(context),
          ),
          // homeScreenMenu,
        ],
      );

    return MaterialApp(
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: themeMode,
      home: WillPopScope(
        onWillPop: () async {
          final yeeter = yeetKey.currentState!.widget.routerDelegate as YeeterDelegate;
          if (yeeter.currentConfiguration == "/") {
            return true;
          }
          yeeter.yeet();
          return false;
        },
        child: HomeScreen(
          titleBar: titleBar as PreferredSizeWidget,
        ),
      ),
    );
  }
}

final yeetKey = GlobalKey<State<Router<String>>>();
