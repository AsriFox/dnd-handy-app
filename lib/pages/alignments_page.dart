import 'package:dnd_handy_flutter/api_service.dart';
import 'package:dnd_handy_flutter/json_objects.dart';
import 'package:dnd_handy_flutter/page_builder.dart';
import 'package:dnd_handy_flutter/pages/article_page.dart';
import 'package:dnd_handy_flutter/pages/reflist_item.dart';
import 'package:flutter/material.dart';

class AlignmentsPage extends StatelessWidget {
  const AlignmentsPage({ 
    super.key,
    required this.descPages,
  });

  final Map<String, AlignmentTile> descPages;

  factory AlignmentsPage.fromJson(JsonObject json) {
    var descPages = <String, AlignmentTile>{};
    for (var item in json['results']) {
      final ref = DndRef.fromJson(item);
      final abbr = ref.name.split(" ").map((w) => w[0]).join();
      descPages.putIfAbsent(
        abbr, 
        () => AlignmentTile(
          caption: abbr,
          subtitle: ref.name,
          desc: DndPageBuilder(
            request: getApiRequest(ref.url),
            onResult: (json) => ArticlePage.fromJson(json,
              'alignments'
            ),
          ),
        )
      );
    }
    return AlignmentsPage(descPages: descPages);
  }

  @override
  Widget build(BuildContext context) =>
    GridView.count(
      crossAxisCount: 3,
      childAspectRatio: 0.925,
      children: [
        descPages["LG"] ?? AlignmentTile.dummy("LG"),
        descPages["NG"] ?? AlignmentTile.dummy("NG"),
        descPages["CG"] ?? AlignmentTile.dummy("CG"),
        descPages["LN"] ?? AlignmentTile.dummy("LN"),
        descPages["N"]  ?? AlignmentTile.dummy("N"),
        descPages["CN"] ?? AlignmentTile.dummy("CN"),
        descPages["LE"] ?? AlignmentTile.dummy("LE"),
        descPages["NE"] ?? AlignmentTile.dummy("NE"),
        descPages["CE"] ?? AlignmentTile.dummy("CE"),
      ],
    );
}

class AlignmentTile extends StatelessWidget {
  const AlignmentTile({
    super.key,
    required this.caption,
    this.subtitle,
    this.desc,
  });

  final String caption;
  final String? subtitle;
  final DndPageBuilder? desc;

  factory AlignmentTile.dummy(String caption) =>
    AlignmentTile(caption: caption);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    return GridTile(
      footer: subtitle == null ? null
        : Padding(padding: pad, child: Text(
          subtitle!,
          textAlign: TextAlign.center,
          style: theme.subtitle1,
        )),
      child: InkWell(
        onTap: desc != null
          ? () => showDialog(
            context: context, 
            builder: (ctx) => AlertDialog(
              title: Text(
                subtitle ?? caption,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              titlePadding: const EdgeInsets.fromLTRB(14.0, 20.0, 14.0, 4.0),
              contentPadding: const EdgeInsets.all(4.0),
              content: SizedBox(
                width: double.maxFinite,
                child: desc,
              ),
              actions: [
                IconButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
          )
          : () => ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("No description is avaliable for '$caption'"))
          ),
        borderRadius: const BorderRadius.all(Radius.circular(20.0)),
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(color: Theme.of(context).hintColor),
            borderRadius: const BorderRadius.all(Radius.circular(20.0)),
          ),
          padding: const EdgeInsets.only(bottom: 24.0),
          child: Text(caption, style: theme.headline2),
        ),
      ),
    );
  }
}
