import 'package:dnd_handy_flutter/page_screen.dart';
import 'package:dnd_handy_flutter/pages/reflist_item.dart';
import 'package:flutter/material.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:dnd_handy_flutter/search_bar.dart';
import 'package:dnd_handy_flutter/api_service.dart';

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
        home: const MainScreen(),
      )
    );
  }
}

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildSearchBar(
        context: context, 
        title: 'Handy DnD database', 
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.menu),
        ),
      ),
      body: FutureBuilder(
        future: getApiRequest('api').catchError((_) => null),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final map = snapshot.data as Map<String, dynamic>;
            var children = List<Widget>.empty(growable: true);
            map.forEach((key, value) => children.add(
              DndRef(
                index: key,
                name: key,
                url: value as String,
              ).build(
                onTap: (it) => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => PageScreen.request(it.url)
                  )
                )
              )
            ));

            return ListView(
              children: children,
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}