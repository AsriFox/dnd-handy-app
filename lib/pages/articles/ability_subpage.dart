import 'package:dnd_handy_flutter/pages/desc_popup.dart';
import 'package:dnd_handy_flutter/pages/reflist_item.dart';
import 'package:flutter/material.dart';

List<Widget> abilityArticleSubpage(List<dynamic> array) => 
  <Widget>[
    const Padding(
      padding: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 4.0),
      child: Text(
        "Associated skills:",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    )
  ] + array.map(
      (it) => ListTileRef(
        ref: DndRef.fromJson(it),
        visualDensity: ListDensity.veryDense.d,
        onTap: (ctx, ref) => showDescPopup(ctx, ref),
      )
    ).toList();
