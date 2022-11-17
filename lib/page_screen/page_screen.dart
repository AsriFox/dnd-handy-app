import 'package:flutter/material.dart';
import 'package:dnd_handy_flutter/pages/reflist_item.dart';
import 'pages_build.dart';

Scaffold pageScreen(BuildContext context, DndRef ref) => 
  Scaffold(
    appBar: AppBar(
      title: Text(ref.name), 
      leading: IconButton(
        onPressed: () => Navigator.of(context).pop(), 
        icon: const Icon(Icons.arrow_back),
      ),
      actions: [
        IconButton(
          onPressed: () => Navigator.of(context)
            .popUntil((route) => route.isFirst), 
          icon: const Icon(Icons.home),
        ),
      ],
    ),
    body: DndPageBuilder.request(ref),
  );
