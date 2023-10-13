import 'package:flutter/material.dart';
import 'package:dnd_handy_flutter/json_objects.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

final mdTableStyle = MarkdownStyleSheet(
  tableCellsPadding: const EdgeInsets.all(4.0),
  tableColumnWidth: const IntrinsicColumnWidth(),
);

class ArticlePage extends StatelessWidget {
  const ArticlePage({
    super.key,
    this.desc,
  });

  final String? desc;

  List<Widget> buildChildren() => [];

  factory ArticlePage.fromJson(JsonObject json) {
    final desc = json['desc'];
    return ArticlePage(
      desc: desc is String
          ? desc
          : [
              for (String p in desc)
                if (p.contains('|')) p else '\n$p\n'
            ].join('\n'),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (desc == null) {
      return const Center(child: Text('Empty page'));
    }
    return Padding(
        padding: const EdgeInsets.all(10.0),
        child: MarkdownBody(
          data: desc!,
          styleSheet: mdTableStyle,
        ));
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
