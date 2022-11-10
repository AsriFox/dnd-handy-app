import 'package:dnd_handy_flutter/models/base_dnd_model.dart';

class DndRefList extends BaseDndModel {
  const DndRefList({
    this.results,
  });

  final List<DndRef>? results;

  factory DndRefList.fromJsonArray(List<dynamic> array) {
    return DndRefList(
      results: array.map(
        (it) => DndRef.fromJson(it as Map<String, dynamic>)
      ).toList(growable: false),
    );
  }
}

class DndRef extends BaseDndModel {
  const DndRef({
    super.index,
    super.name,
    super.url,
  });

  DndRef.fromJson(Map<String, dynamic> json) : super.fromJson(json);
}