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

  Widget buildListTile({
    void Function(DndRef)? onTap,
    VisualDensity visualDensity = VisualDensity.comfortable,
  }) {
    return ListTile(
      title: Text(name),
      onTap: onTap != null  
        ? () => onTap(this)
        : () {},
        visualDensity: visualDensity,
    );
  }

  Widget buildTextButton({void Function(DndRef)? onPressed}) {
    return TextButton(
      onPressed: onPressed != null 
        ? () => onPressed(this)
        : () {},
      child: Text(
        name,
        style: const TextStyle(
          color: Colors.lightBlueAccent,
          fontSize: 18.0,
        ),
      ),
    );
  }
}