import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_screen/home_screen.dart';

class DndHandyApp extends StatefulWidget {
  const DndHandyApp({
    super.key,
  });

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
    final themeModeOld = themeMode;
    super.setState(fn);
    notifyListeners();
    if (themeMode != themeModeOld) {
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
  }

  int get tabIndex => controller.index;

  set tabIndex(int index) => setState(() {
    controller.index = index;
  });

  bool isExtended = false;
  final _drawerKey = GlobalKey<ScaffoldState>(); 
  void toggleDrawer() {
    final state = _drawerKey.currentState;
    if (state != null && state.hasDrawer) {
      // Narrow screen - use drawer:
      if (state.isDrawerOpen) {
        state.closeDrawer();
      } else {
        state.openDrawer();
      }
    } else {
      // Wide screen - use sidebar:
      setState(() {
        isExtended = !isExtended;
      });
    }
  }

  static DndAppSettings of(BuildContext context) =>
    context.findAncestorStateOfType<DndAppSettings>()!;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: themeMode,
      home: Material(
        child: SafeArea(
          child: HomeScreen(
            drawerKey: _drawerKey,
          ),
        ),
      ),
    );
  }
}

final yeetKey = GlobalKey<State<Router<String>>>();
