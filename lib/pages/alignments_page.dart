import 'package:dnd_handy_flutter/api_service.dart';
import 'package:dnd_handy_flutter/models/common.dart';
import 'package:dnd_handy_flutter/page_builder.dart';
import 'package:dnd_handy_flutter/pages/popup_page.dart';
import 'package:flutter/material.dart';
import 'package:libadwaita/libadwaita.dart';

class AlignmentsPage extends StatelessWidget {
  const AlignmentsPage({
    super.key,
    required this.descPages,
  });

  final Map<String, DndPageBuilder> descPages;

  factory AlignmentsPage.fromJson(Json json) {
    final refs = DndAPIReferenceList.fromJson(json).results;
    return AlignmentsPage(descPages: {
      for (var it in refs)
        it.index: DndPageBuilder(
          request: DndApiService().getRequest(it.url),
          onResult: (json) => AlignmentTile(
            caption: json['abbreviation'],
            subtitle: json['name'],
            desc: json['desc'],
          ),
        ),
    });
  }

  @override
  Widget build(BuildContext context) => AdwClamp.scrollable(
        child: GridView.count(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          crossAxisCount: 3,
          childAspectRatio: 0.925,
          children: [
            descPages['lawful-good'] ?? const AlignmentTile(caption: 'LG'),
            descPages['neutral-good'] ?? const AlignmentTile(caption: 'NG'),
            descPages['chaotic-good'] ?? const AlignmentTile(caption: 'CG'),
            descPages['lawful-neutral'] ?? const AlignmentTile(caption: 'LN'),
            descPages['neutral'] ?? const AlignmentTile(caption: 'N'),
            descPages['chaotic-neutral'] ?? const AlignmentTile(caption: 'CN'),
            descPages['lawful-evil'] ?? const AlignmentTile(caption: 'LE'),
            descPages['neutral-evil'] ?? const AlignmentTile(caption: 'NE'),
            descPages['chaotic-evil'] ?? const AlignmentTile(caption: 'CE'),
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
  final String? desc;

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
                    child: Text(desc!),
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
