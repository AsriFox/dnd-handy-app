import 'package:dnd_handy_flutter/home_screen/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

const titleBarHeight = 47.0;

final rootNavKey = GlobalKey<NavigatorState>(debugLabel: 'root');

class AdwTitleBar extends StatelessWidget implements PreferredSizeWidget {
  const AdwTitleBar({
    super.key,
    this.title = 'DnD Handy App',
    this.backButton = false,
    this.right,
  });

  factory AdwTitleBar.route({Key? key, required GoRouterState routerState}) {
    final path = routerState.matchedLocation;
    return AdwTitleBar(
      key: key,
      title: routerState.name ??
          routerState.extra as String? ??
          path.split('/').last,
      backButton: path.indexOf('/', 1) > 0,
      right: const [SettingsButton()],
    );
  }

  final String title;
  final bool backButton;
  final List<Widget>? right;

  @override
  Size get preferredSize => const Size.fromHeight(47);

  @override
  Widget build(BuildContext context) => AppBar(
        toolbarHeight: preferredSize.height,
        title: Text(title),
        centerTitle: true,
        leading: backButton
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => GoRouter.of(context).pop(),
              )
            : null,
        actions: right,
      );
}

class SettingsButton extends StatelessWidget {
  const SettingsButton({super.key});

  @override
  Widget build(BuildContext context) => IconButton(
        icon: const Icon(Icons.settings),
        onPressed: () {
          Navigator.of(rootNavKey.currentContext!, rootNavigator: true).push(
            MaterialPageRoute(builder: (_) => const SettingsPage()),
          );
        },
      );
}
