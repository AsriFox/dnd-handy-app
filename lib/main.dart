import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:dnd_handy_flutter/home_screen/titlebar_desktop.dart';
import 'package:dnd_handy_flutter/home_screen/titlebar_mobile.dart';
import 'package:dnd_handy_flutter/dnd_app.dart';
import 'package:path_provider/path_provider.dart';

late final Box cache;

void main() async {
  final localDir = await getApplicationSupportDirectory();
  Hive.init(localDir.path);
  cache = await Hive.openBox("dnd5e-bits");
  
  WidgetsFlutterBinding.ensureInitialized();

  isDesktop = 
    defaultTargetPlatform == TargetPlatform.linux ||
    defaultTargetPlatform == TargetPlatform.windows;

  final dynamic titleBar = isDesktop
    ? (_, title) => 
      DesktopTitleBar(
        title: title,
      )
    : (context, title) => 
      MobileTitleBar.build(
        context, 
        title: title,
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
