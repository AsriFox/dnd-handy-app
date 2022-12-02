import 'package:dnd_handy_flutter/home_screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:dnd_handy_flutter/dnd_app.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final appState = DndAppSettings.of(context);
    
    return Scaffold(
      appBar: appState.widget.titleBar(context, true),
      body: AnimatedBuilder(
        animation: appState,
        builder: (_, child) {        
          IconData themeModeIcon = Icons.settings_brightness;
          switch (appState.themeMode) {
            case ThemeMode.light:
              themeModeIcon = Icons.light_mode;
              break;
            case ThemeMode.dark:
              themeModeIcon = Icons.dark_mode;
              break;
            default:
              break;
          }

          final themeModeSetting = ListTile(
            leading: Icon(themeModeIcon),
            title: const Text("Theme mode"),
            trailing: DropdownButton<ThemeMode>(
              value: appState.themeMode,
              onChanged: (value) => appState.setState(() {
                appState.themeMode = value;
              }),
              items: const [
                DropdownMenuItem(
                  value: ThemeMode.system,
                  child: Text("System"),
                ),
                DropdownMenuItem(
                  value: ThemeMode.light,
                  child: Text("Light"),
                ),
                DropdownMenuItem(
                  value: ThemeMode.dark,
                  child: Text("Dark"),
                ),
              ],
            ),
          );

          return ListView(
            children: [
              themeModeSetting,  
            ],
          );
        },
      )
    );
  }
}
