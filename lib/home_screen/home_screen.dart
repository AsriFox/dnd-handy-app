import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:dnd_handy_flutter/home_screen/titlebar_desktop.dart';
import 'package:dnd_handy_flutter/page_builder.dart';
import 'package:flutter/material.dart';
import 'home_page.dart';
import 'settings_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({ 
    super.key,
    required this.titleBar,
  });

  final PreferredSizeWidget titleBar;

  static HomeScreenState? of(BuildContext context) =>
    context.findAncestorStateOfType<HomeScreenState>();

  @override
  State<StatefulWidget> createState() => HomeScreenState();    
}

class HomeScreenState extends State<HomeScreen> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  bool _isDrawerExtended = false;

  void toggleDrawer() => setState(() {
    _isDrawerExtended = !_isDrawerExtended;
  });

  late DndPageBuilder homePage;

  @override
  void initState() {
    super.initState();
    homePage = buildHomePage();
  }

  @override
  void setState(VoidCallback fn) {
    super.setState(fn);
    if (scaffoldKey.currentState!.isDrawerOpen) {
      scaffoldKey.currentState?.closeDrawer();
    } else {
      scaffoldKey.currentState?.openDrawer();
    }
  }

  @override
  Widget build(BuildContext context) => 
    LayoutBuilder(
      builder: (_, constraints) {
        if (constraints.maxWidth < 600) {
          return Scaffold(
            key: scaffoldKey,
            appBar: widget.titleBar,
            drawer: buildHomeScreenDrawer(true, Theme.of(context).visualDensity),
            body: homePage,
          );
        } else {
          return Scaffold(
            key: scaffoldKey,
            appBar: widget.titleBar,
            body: Row(children: [
              buildHomeScreenDrawer(
                _isDrawerExtended, 
                Theme.of(context).visualDensity
              ),
              Expanded(
                child: homePage,
              ),
            ]),
          );
        }
      }
    );
}

Widget buildHomeScreenDrawer(bool isExtended, VisualDensity visualDensity) =>
  Drawer(
    width: isExtended ? 304.0 : titleBarDefaultItemsWidth,
    child: ListView(children: [
      buildDrawerListTile(
        isExtended: isExtended,
        title: "Home page", 
        icon: Icons.home,
        onTap: () {},
      ),
      buildDrawerListTile(
        isExtended: isExtended,
        title: "Characters", 
        icon: Icons.account_circle,
        onTap: () {},
      ),
      buildDrawerListTile(
        isExtended: isExtended,
        title: "Settings", 
        icon: Icons.settings,
        onTap: () {},
      ),
    ]),
  );

Widget buildDrawerListTile({
  bool isExtended = true,
  required String title,
  required IconData icon,
  void Function()? onTap,
}) => isExtended
  ? ListTile(
    leading: Icon(icon),
    title: Text(title),
    onTap: onTap,
  )
  : ListTile(
    contentPadding: const EdgeInsets.all(0.0),
    title: Icon(icon),
    onTap: onTap,
  );