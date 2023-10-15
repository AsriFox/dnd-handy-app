import 'package:dnd_handy_flutter/pages/reflist_item.dart';
import 'package:flutter/material.dart';
import 'package:dnd_handy_flutter/json_objects.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:libadwaita/libadwaita.dart';

final mdArticleStyle = MarkdownStyleSheet(
  tableCellsPadding: const EdgeInsets.all(4.0),
  tableColumnWidth: const IntrinsicColumnWidth(),
);

class ArticlePage extends StatelessWidget {
  const ArticlePage({
    super.key,
    this.desc,
  });

  final String? desc;

  factory ArticlePage.fromJson(JsonObject json) => json['desc'] is String
      ? ArticlePage(desc: json['desc'])
      : ArticlePage.lines([for (String s in json['desc']) s]);

  ArticlePage.lines(List<String> lines, {super.key})
      : desc = lines
            .map((l) =>
                l.startsWith('-') || l.startsWith('|') ? '$l\n' : '\n$l\n')
            .join();

  @override
  Widget build(BuildContext context) {
    if (desc == null) {
      return const Center(child: Text('Empty page'));
    }
    return AdwClamp.scrollable(
      child: MarkdownBody(
        data: desc!,
        styleSheet: mdArticleStyle,
        onTapLink: (text, href, title) => gotoPage(
          context,
          DndRef(
            index: href!.split('/').last,
            name: text,
            url: href,
          ),
        ),
      ),
    );
  }
}

const pad = EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 4.0);
const bold = TextStyle(fontWeight: FontWeight.bold);

Widget annotatedLine({
  required String annotation,
  Widget? content,
  List<Widget>? contents,
  EdgeInsetsGeometry padding = pad,
}) {
  var children = <Widget>[
    Text(annotation, style: bold),
  ];
  if (content != null) {
    children.add(content);
  }
  if (contents != null) {
    children += contents;
  }

  return Padding(
      padding: pad,
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        children: children,
      ));
}
