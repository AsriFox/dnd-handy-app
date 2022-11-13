// import 'package:dnd_handy_flutter/page_screen.dart';
import 'package:dnd_handy_flutter/pages/reflist_item.dart';
import 'package:dnd_handy_flutter/pages/desc_popup.dart';
import 'package:flutter/material.dart';

List<Widget> skillsArticleSubpage(Map<String, dynamic> json) => [
  GoverningAbilityRef(ref: DndRef.fromJson(json)),
];

class GoverningAbilityRef extends StatelessWidget {
  const GoverningAbilityRef({
    super.key,
    required this.ref,
  });

  final DndRef ref;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text("Governing ability: "),
        TextButton(
          child: Text(
            ref.name,
            style: const TextStyle(
              color: Colors.lightBlueAccent,
              fontSize: 18.0,
            ),
          ),
          onPressed: () {
            // Navigator.of(context).pop();
            showDialog(
              context: context,
              builder: (ctx) => descPopup(ctx, ref),
            );
          } 
        ),
      ],
    );
  }
}