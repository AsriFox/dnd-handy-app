import 'package:dnd_handy_flutter/json_objects.dart';
import 'package:dnd_handy_flutter/pages/article_page.dart';
import 'package:dnd_handy_flutter/pages/reflist_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

const padButt = EdgeInsets.fromLTRB(16.0, 4.0, 16.0, 0.0);

class MagicItemArticlePage extends StatelessWidget {
  const MagicItemArticlePage({
    super.key,
    required this.equipmentCategory,
    required this.desc,
    required this.rarity,
    this.variant = false,
    required this.variants,
  });

  final DndRef equipmentCategory;
  final String desc;
  final String rarity;
  final bool variant;
  final List<DndRef> variants;
  
  static final yeet = yeetCategory(
    category: "magic-items",
    builder: (json) => MagicItemArticlePage.fromJson(json),
  );

  factory MagicItemArticlePage.fromJson(JsonObject json) =>
    MagicItemArticlePage(
      equipmentCategory: DndRef.fromJson(json['equipment_category']),
      desc: [
        for (String p in json['desc'])
          if (p.contains('|')) p
          else "\n$p\n"
      ].join("\n"),
      rarity: json['rarity']['name'].toString(), 
      variant: json['variant'] ?? false,
      variants: [
        for (var it in json['variants'])
          DndRef.fromJson(it)
      ],
    );

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: double.maxFinite,
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: MarkdownBody(
                data: desc,
                styleSheet: mdTableStyle,
              ),
            ),
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
          ],
        ),
      ),
    );
  }
}