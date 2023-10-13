import 'package:flutter/material.dart';
import 'package:libadwaita/libadwaita.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsController extends ChangeNotifier {
  SettingsController(this._prefs)
      : _themeMode =
            ThemeMode.values.byName(_prefs.getString(_themeKey) ?? 'system'),
        _isMouseDragScroll = _prefs.getBool(_mouseDragKey) ?? false;

  final SharedPreferences _prefs;

  static const _themeKey = 'themeMode';
  ThemeMode _themeMode;
  ThemeMode get themeMode => _themeMode;
  set themeMode(ThemeMode newThemeMode) {
    if (_themeMode == newThemeMode) {
      return;
    }
    _themeMode = newThemeMode;
    _prefs.setString(_themeKey, _themeMode.name);
    notifyListeners();
  }

  static const _mouseDragKey = 'isMouseDragScroll';
  bool _isMouseDragScroll;
  bool get isMouseDragScroll => _isMouseDragScroll;
  set isMouseDragScroll(bool newValue) {
    if (_isMouseDragScroll == newValue) {
      return;
    }
    _isMouseDragScroll = newValue;
    _prefs.setBool(_mouseDragKey, _isMouseDragScroll);
    notifyListeners();
  }

  static SettingsController of(BuildContext context) => context
      .getInheritedWidgetOfExactType<SettingsControllerProvider>()!
      .controller;
}

class SettingsControllerProvider extends InheritedWidget {
  const SettingsControllerProvider({
    super.key,
    required this.controller,
    required super.child,
  });

  final SettingsController controller;

  @override
  bool updateShouldNotify(SettingsControllerProvider oldWidget) =>
      controller != oldWidget.controller;
}

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  static const _aboutRow = ExpansionTile(
    title: Text('About'),
    children: [
      AdwActionRow(
        title: 'DnD Handy App',
        subtitle: 'Author: AsriFox',
      ),
      AdwActionRow(
          title: 'GitHub',
          subtitle: 'https://github.com/AsriFox/dnd-handy-app',
          start: Icon(Icons.link)),
    ],
  );

  @override
  Widget build(BuildContext context) {
    final settings = SettingsController.of(context);

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 47,
        title: const Text('Settings'),
        centerTitle: true,
      ),
      body: AdwClamp.scrollable(
        child: ListenableBuilder(
          listenable: settings,
          builder: (_, __) => AdwPreferencesGroup(
            children: [
              AdwComboRow(
                title: 'Theme mode',
                selectedIndex: ThemeMode.values.indexOf(settings.themeMode),
                onSelected: (val) => settings.themeMode = ThemeMode.values[val],
                choices: ThemeMode.values.map((e) => e.name).toList(),
              ),
              AdwSwitchRow(
                title: 'Use mouse drag to scroll',
                value: settings.isMouseDragScroll,
                onChanged: (val) => settings.isMouseDragScroll = val,
              ),
              _aboutRow,
            ],
          ),
        ),
      ),
    );
  }
}
