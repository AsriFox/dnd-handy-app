import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _SettingsPageState.init();
}

class _SettingsPageState extends State<SettingsPage> {
  _SettingsPageState({
    required this.prefs,
  });

  final Future<SharedPreferences> prefs;
  late bool preferHttp;

  factory _SettingsPageState.init() =>
    _SettingsPageState(
      prefs: Future(() async => 
        await SharedPreferences.getInstance()
      ),
    );

  @override
  void initState() {
    super.initState();
    prefs.then((pr) {
      preferHttp = pr.getBool('prefer_http') ?? true;
    });
  }

  @override
  void setState(VoidCallback fn) {
    super.setState(fn);
    prefs.then((pr) {
      pr.setBool('prefer_http', preferHttp);
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: prefs,
      builder: (ctx, snapshot) {
        if (snapshot.hasData) {
          final adaptiveTheme = AdaptiveTheme.of(ctx);
          return ListView(
            children: [
              ValueListenableBuilder(
                valueListenable: adaptiveTheme.modeChangeNotifier,
                builder: (_, value, dialog) {
                  var themeMode = "";
                  switch (value) {
                    case AdaptiveThemeMode.light:
                      themeMode = "Light";
                      break;
                    case AdaptiveThemeMode.dark:
                      themeMode = "Dark";
                      break;
                    case AdaptiveThemeMode.system:
                      themeMode = "System";
                      break;
                  }
                  return ListTile(
                    title: const Text("Theme mode"),
                    subtitle: Text(themeMode),
                    trailing: SizedBox(
                      width: 72.0,
                      child: Row(children: [
                        IconButton(
                          icon: const Icon(Icons.swap_horizontal_circle),
                          iconSize: 32.0,
                          splashRadius: 20.0,
                          onPressed: () => adaptiveTheme.toggleThemeMode(),
                        ),
                        const Icon(Icons.chevron_right),
                      ]),
                    ),
                    onTap: () => showDialog(
                      context: context,
                      builder: (_) => dialog!,
                    ),
                  );
                },
                child: SimpleDialog(
                  title: const Text("Choose theme mode"),
                  children: [
                    SimpleDialogOption(
                      onPressed: () {
                        adaptiveTheme.setLight();
                        Navigator.pop(ctx);
                      },
                      child: const Text("Light"),
                    ),
                    SimpleDialogOption(
                      onPressed: () {
                        adaptiveTheme.setDark();
                        Navigator.pop(ctx);
                      },
                      child: const Text("Dark"),
                    ),
                    SimpleDialogOption(
                      onPressed: () {
                        adaptiveTheme.setSystem();
                        Navigator.pop(ctx);
                      },
                      child: const Text("System"),
                    ),
                  ],
                ),
              ),
              
              ListTile(
                title: const Text("Preferred data source"),
                subtitle: Text(preferHttp ? "Network API (dnd5eapi.co)" : "Local storage"),
                trailing: SizedBox(
                  width: 72.0,
                  child: Row(children: [
                    IconButton(
                      icon: const Icon(Icons.swap_horizontal_circle),
                      iconSize: 32.0,
                      splashRadius: 20.0,
                      onPressed: () => setState(() {
                        preferHttp = !preferHttp;
                      }),
                    ),
                    const Icon(Icons.chevron_right),
                  ]),
                ),
                // onTap: () => showDialog(
                //   context: context,
                //   builder: (_) => dialog!,
                // ),
              ),

              ListTile(
                title: const Text("Configure data sources"),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {},
              )
            ],
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      }
    );
  }
}