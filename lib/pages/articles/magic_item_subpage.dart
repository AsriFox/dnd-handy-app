import 'package:dnd_handy_flutter/json_objects.dart';
import 'package:dnd_handy_flutter/pages/article_page.dart';
import 'package:dnd_handy_flutter/pages/reflist_item.dart';
import 'package:flutter/material.dart';

const padButt = EdgeInsets.fromLTRB(16.0, 4.0, 16.0, 0.0);

class MagicItemArticlePage extends ArticlePage {
  const MagicItemArticlePage({
    super.key,
    required this.equipmentCategory,
    required this.rarity,
    this.variant = false,
    required this.variants,
  });

  final DndRef equipmentCategory;
  final String rarity;
  final bool variant;
  final List<DndRef> variants;

  factory MagicItemArticlePage.fromJson(JsonObject json) =>
    MagicItemArticlePage(
      equipmentCategory: json['equipment_category'],
      rarity: json['rarity']['name'].toString(), 
      variant: json['variant'] ?? false,
      variants: [
        for (var it in json['variants'])
          DndRef.fromJson(it)
      ],
    );

  @override
  List<Widget> buildChildren() => [
    annotatedLine(
      annotation: "Category: ",
      padding: padButt,
      content: TextButtonRef(ref: equipmentCategory),
    ),
    annotatedLine(
      annotation: "Rarity: ",
      content: Text(rarity),
    ),
    if (variant)
      const Padding(
        padding: pad, 
        child: Text("Is a variant")
      ),
    if (variants.isNotEmpty)
      annotatedLine(annotation: "Variants:"),
    for (var it in variants)
      ListTileRef(ref: it)
  ];
}