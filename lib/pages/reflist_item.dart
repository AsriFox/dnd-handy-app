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

  Widget build({void Function(DndRef)? onTap}) {
    return ListTile(
      title: Text(name),
      onTap: onTap != null  
        ? () => onTap(this)
        : () {},
    );
  }
}