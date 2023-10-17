import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'common.freezed.dart';
part 'common.g.dart';

typedef Json = Map<String, dynamic>;

@freezed
class DndAPIReference with _$DndAPIReference {
  const factory DndAPIReference({
    required String index,
    required String name,
    required String url,
  }) = _DndAPIReference;

  factory DndAPIReference.fromJson(Json json) =>
      _$DndAPIReferenceFromJson(json);
}

@freezed
class DndAPIReferenceList with _$DndAPIReferenceList {
  const factory DndAPIReferenceList({
    required int count,
    required List<DndAPIReference> results,
  }) = _DndApiReferenceList;

  factory DndAPIReferenceList.fromJson(Json json) =>
      _$DndAPIReferenceListFromJson(json);
}

@freezed
class DndAreaOfEffect with _$DndAreaOfEffect {
  const factory DndAreaOfEffect({
    required int size,
    String? type,
  }) = _DndAreaOfEffect;

  factory DndAreaOfEffect.fromJson(Json json) =>
      _$DndAreaOfEffectFromJson(json);
}

@JsonEnum()
enum DndDCSuccessType {
  none,
  half,
  other,
}

@freezed
class DndDifficultyClass with _$DndDifficultyClass {
  const factory DndDifficultyClass({
    required DndAPIReference type,
    required int value,
    required DndDCSuccessType successType,
  }) = _DndDifficultyClass;

  factory DndDifficultyClass.fromJson(Json json) =>
      _$DndDifficultyClassFromJson(json);
}

@freezed
class DndDamage with _$DndDamage {
  const factory DndDamage({
    required DndAPIReference damageType,
    required String damageDice,
  }) = _DndDamage;

  factory DndDamage.fromJson(Json json) => _$DndDamageFromJson(json);
}
