import 'package:dnd_handy_flutter/home_screen/titlebar_desktop.dart';
import 'package:dnd_handy_flutter/home_screen/titlebar_mobile.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:dnd_handy_flutter/dnd_app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  final isDesktop = 
    defaultTargetPlatform == TargetPlatform.linux ||
    defaultTargetPlatform == TargetPlatform.windows;

  final dynamic titleBar = isDesktop
    ? (_, isHomePage) => 
      DesktopTitleBar( 
        isHomePage: isHomePage
      )
    : (context, isHomePage) => 
      MobileTitleBar.build(
        context, 
        isHomePage: isHomePage
      );

  runApp(DndHandyApp(
    titleBar: titleBar,
  ));

  if (isDesktop) {
    doWhenWindowReady(() {
      const initialSize = Size(720, 1080);
      appWindow.size = initialSize;
      appWindow.show();
    });
  }
}
