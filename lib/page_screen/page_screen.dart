import 'package:flutter/material.dart';
import 'package:dnd_handy_flutter/pages/reflist_item.dart';
import 'pages_build.dart';

Scaffold pageScreen(BuildContext context, DndRef ref) => 
  Scaffold(
    appBar: AppBar(
      title: Text(ref.name), 
      leading: InkResponse(
        onTap: () => Navigator.pop(context),
        onDoubleTap: () => Navigator.popUntil(context, (route) => route.isFirst),
        onTapCancel: () => ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Tap the button twice to return to the home screen"))
        ),
        child: const Icon(Icons.arrow_back),
      ),
    ),
    body: DndPageBuilder.request(ref),
  );
