import 'package:flutter/material.dart';
import 'package:dnd_handy_flutter/json_objects.dart';
import 'package:go_router/go_router.dart';

gotoPage(BuildContext context, DndRef ref) =>
    GoRouter.of(context).push(ref.url, extra: ref.name);

enum ListDensity {
  veryDense(VisualDensity.minimumDensity);

  const ListDensity(this.value);

  final double value;

  VisualDensity get d => VisualDensity(vertical: value);
}

class DndRef {
  const DndRef({
    required this.index,
    required this.name,
    required this.url,
  });

  final String index;
  final String name;
  final String url;

  factory DndRef.fromJson(JsonObject json) => DndRef(
        index: json['index'] as String,
        name: json['name'] as String,
        url: json['url'] as String,
      );

  static List<DndRef>? all(JsonArray? array) =>
      array == null ? null : [for (var it in array) DndRef.fromJson(it)];
}

class ListTileRef extends StatelessWidget {
  const ListTileRef({
    super.key,
    required this.ref,
    this.onTap = gotoPage,
    this.visualDensity = VisualDensity.comfortable,
    this.trailing,
    this.dense = false,
  });

  final DndRef ref;
  final void Function(BuildContext, DndRef) onTap;
  final VisualDensity visualDensity;
  final Widget? trailing;
  final bool dense;

  factory ListTileRef.fromJson(
    JsonObject json, {
    Function(BuildContext, DndRef) onTap = gotoPage,
    VisualDensity? visualDensity,
    Widget? trailing,
    bool dense = false,
  }) =>
      ListTileRef(
        ref: DndRef.fromJson(json),
        onTap: onTap,
        trailing: trailing,
        visualDensity: visualDensity ?? ListDensity.veryDense.d,
        dense: dense,
      );

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(ref.name),
      onTap: () => onTap(context, ref),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      visualDensity: visualDensity,
      trailing: trailing,
      dense: dense,
    );
  }
}

class TextButtonRef extends StatelessWidget {
  const TextButtonRef({
    super.key,
    required this.ref,
    this.onPressed = gotoPage,
  });

  final DndRef ref;
  final void Function(BuildContext, DndRef) onPressed;

  factory TextButtonRef.fromJson(
    JsonObject json, {
    Function(BuildContext, DndRef) onPressed = gotoPage,
  }) =>
      TextButtonRef(
        ref: DndRef.fromJson(json),
        onPressed: onPressed,
      );

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        minimumSize: const Size(0.0, 0.0),
        padding: const EdgeInsets.all(4.0),
        visualDensity: ListDensity.veryDense.d,
      ),
      onPressed: () => onPressed(context, ref),
      child: Text(
        ref.name,
        style: TextStyle(
          color: Colors.lightBlueAccent,
          fontSize: Theme.of(context).textTheme.titleMedium?.fontSize,
        ),
      ),
    );
  }
}
