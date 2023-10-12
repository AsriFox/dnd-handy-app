import 'package:adwaita/adwaita.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dnd_handy_flutter/app.dart';
import 'package:dnd_handy_flutter/home_screen/settings_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  runApp(DndHandyApp(
    settings: SettingsController(prefs),
    lightTheme: AdwaitaThemeData.light(),
    darkTheme: AdwaitaThemeData.dark(),
  ));
}
