import 'package:flutter/material.dart';

class DndRef {
  const DndRef({
    required this.index,
    required this.name,
    required this.url,
  });

  final String index;
  final String name;
  final String url;

  factory DndRef.fromJson(Map<String, dynamic> json) =>
    DndRef(
      index: json['index'] as String,
      name: json['name'] as String,
      url: json['url'] as String,
    );
}

class ListTileRef extends StatelessWidget {
  const ListTileRef({
    super.key,
    required this.ref,
    this.onTap,
    this.visualDensity = VisualDensity.comfortable,
  }); 

  final DndRef ref;
  final void Function(BuildContext, DndRef)? onTap;
  final VisualDensity visualDensity;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(ref.name),
      onTap: onTap != null
        ? () => onTap!(context, ref)
        : () {},
      visualDensity: visualDensity,
    );
  }
}

class TextButtonRef extends StatelessWidget {
  const TextButtonRef({
    super.key,
    required this.ref,
    this.onPressed,
  });

  final DndRef ref;
  final void Function(BuildContext, DndRef)? onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed != null
        ? () => onPressed!(context, ref)
        : () {},
      child: Text(
        ref.name,
        style: const TextStyle(
          color: Colors.lightBlueAccent,
          fontSize: 18.0,
        ),
      ),
    );
  }
}