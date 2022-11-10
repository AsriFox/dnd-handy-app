import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:dnd_handy_flutter/api_service.dart';
import 'package:dnd_handy_flutter/search.dart';

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

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final ApiService apiService = ApiService();

  final String queryNullText = "Use search";
  Widget? _queryResult;
  void queryResult(String? path) {
    setState(() {
      _queryResult = path == null
        ? Text(queryNullText)
        : apiService.build(path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Handy DnD database'),
        actions: [
          IconButton(
            onPressed: () {
              showSearch(
                context: context,
                delegate: CustomSearchDelegate(),
              ).then((value) =>
                queryResult(value)
              );
            },
            icon: const Icon(Icons.search),
          )
        ],
      ),
      body: Center(
        child: _queryResult
      ),
    );
  }
}