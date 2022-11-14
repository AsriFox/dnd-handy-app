import 'package:dnd_handy_flutter/pages/desc_popup.dart';
import 'package:dnd_handy_flutter/pages/reflist_item.dart';
import 'package:dnd_handy_flutter/pages/reflist_page.dart';
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
      (it) => AssociatedSkillRef(ref: DndRef.fromJson(it))
    ).toList();

class AssociatedSkillRef extends StatelessWidget {
  const AssociatedSkillRef({
    super.key,
    required this.ref,
  });

  final DndRef ref;

  @override
  Widget build(BuildContext context) {
    return ref.buildListTile(
      visualDensity: ListDensity.veryDense.d,
      onTap: (it) => showDialog(
        context: context,
        builder: (ctx) => descPopup(ctx, it),
      ),
    );
  }
}