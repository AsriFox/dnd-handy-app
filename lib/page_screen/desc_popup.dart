import 'package:flutter/material.dart';
import 'package:dnd_handy_flutter/pages/reflist_item.dart';
import 'pages_build.dart';

AlertDialog descPopup(BuildContext context, DndRef it) => 
  AlertDialog(
    title: Text(
      it.name, 
      style: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
    ),
    titlePadding: const EdgeInsets.fromLTRB(14.0, 20.0, 14.0, 4.0),
    contentPadding: const EdgeInsets.all(4.0),
    content: SizedBox(
      width: double.maxFinite,
      child: DndPageBuilder.request(it),
    ),
    actions: [
      IconButton(
        onPressed: () => Navigator.of(context).pop(),
        icon: const Icon(Icons.close),
      ),
    ],
  );