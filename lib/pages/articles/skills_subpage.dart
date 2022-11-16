// import 'package:dnd_handy_flutter/page_screen.dart';
import 'package:dnd_handy_flutter/pages/reflist_item.dart';
import 'package:dnd_handy_flutter/pages/desc_popup.dart';
import 'package:flutter/material.dart';

List<Widget> skillsArticleSubpage(Map<String, dynamic> json) => [
  Padding(
    padding: const EdgeInsets.only(top: 8.0), 
    child: Row(
      children: [
        const Text("Governing ability: "),
        TextButtonRef(
          ref: DndRef.fromJson(json),
          onPressed: (ctx, ref) => showDialog(
            context: ctx, 
            builder: (context) => descPopup(context, ref),
          ),
        )
      ]
    ),
  ),
];
