import 'package:dnd_handy_flutter/api_service.dart';
import 'package:dnd_handy_flutter/page_screen/pages_build.dart';
import 'package:dnd_handy_flutter/pages/article_page.dart';
import 'package:dnd_handy_flutter/pages/reflist_item.dart';
import 'package:flutter/material.dart';

class AlignmentsPageBuilder extends DndPageBuilder {
  const AlignmentsPageBuilder({
    super.key,
    required super.request,
  });

  @override
  Widget buildPage(Map<String, dynamic> json) {
    var descPages = <String, AlignmentTile>{};
    for (var item in json['results'] as List<dynamic>) {
      final ref = DndRef.fromJson(item);
      final abbr = ref.name.split(" ").map((w) => w[0]).join();
      descPages.putIfAbsent(
        abbr, 
        () => AlignmentTile(
          caption: abbr,
          subtitle: ref.name,
          desc: ArticlePage(request: getApiRequest(ref.url)),
        )
      );
    }
    return GridView.count(
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
  final ArticlePage? desc;

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
            builder: (_) => AlertDialog(
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
                  onPressed: () => Navigator.of(context).pop(),
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
