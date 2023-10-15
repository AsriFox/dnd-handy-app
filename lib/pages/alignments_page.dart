import 'package:dnd_handy_flutter/api_service.dart';
import 'package:dnd_handy_flutter/json_objects.dart';
import 'package:dnd_handy_flutter/page_builder.dart';
import 'package:dnd_handy_flutter/pages/popup_page.dart';
import 'package:dnd_handy_flutter/pages/reflist_item.dart';
import 'package:flutter/material.dart';
import 'package:libadwaita/libadwaita.dart';

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
      final abbr = ref.name.split(' ').map((w) => w[0]).join();
      descPages.putIfAbsent(
          abbr,
          () => AlignmentTile(
                caption: abbr,
                subtitle: ref.name,
                desc: DndPageBuilder(
                  request: DndApiService().getRequest(ref.url),
                  onResult: (json) => Text(json['desc']),
                ),
              ));
    }
    return AlignmentsPage(descPages: descPages);
  }

  @override
  Widget build(BuildContext context) => AdwClamp.scrollable(
        child: GridView.count(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          crossAxisCount: 3,
          childAspectRatio: 0.925,
          children: [
            descPages['LG'] ?? const AlignmentTile(caption: 'LG'),
            descPages['NG'] ?? const AlignmentTile(caption: 'NG'),
            descPages['CG'] ?? const AlignmentTile(caption: 'CG'),
            descPages['LN'] ?? const AlignmentTile(caption: 'LN'),
            descPages['N'] ?? const AlignmentTile(caption: 'N'),
            descPages['CN'] ?? const AlignmentTile(caption: 'CN'),
            descPages['LE'] ?? const AlignmentTile(caption: 'LE'),
            descPages['NE'] ?? const AlignmentTile(caption: 'NE'),
            descPages['CE'] ?? const AlignmentTile(caption: 'CE'),
          ],
        ),
      );
}

const borderRadius = BorderRadius.all(Radius.circular(12));

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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;

    final tile = InkWell(
      onTap: desc != null
          ? () => showDialog(
                context: context,
                builder: (_) => DescPopup(
                  title: subtitle ?? caption,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: desc,
                  ),
                ),
              )
          : () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('No description is available for "$caption"'))),
      borderRadius: borderRadius,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).hintColor),
          borderRadius: borderRadius,
        ),
        padding: const EdgeInsets.only(bottom: 16.0),
        child: Text(caption, style: theme.displayLarge),
      ),
    );

    return Stack(
      children: [
        Positioned.fill(
          child: tile,
        ),
        if (subtitle != null)
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 4,
              ),
              child: Text(
                subtitle!,
                style: theme.titleSmall,
                textAlign: TextAlign.center,
              ),
            ),
          )
      ],
    );
  }
}
