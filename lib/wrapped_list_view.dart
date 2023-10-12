import 'package:flutter/material.dart';
import 'package:libadwaita/libadwaita.dart';

class WrappedListView extends StatelessWidget {
  const WrappedListView({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) => AdwClamp.scrollable(
        maximumSize: 1600.0,
        child: Card(
          clipBehavior: Clip.antiAlias,
          child: Wrap(
            children: children
                .map((child) => ConstrainedBox(
                      constraints: const BoxConstraints.tightFor(width: 360),
                      child: child,
                    ))
                .toList(),
          ),
        ),
      );
}
