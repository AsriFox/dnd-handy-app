import 'package:dnd_handy_flutter/models/common.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'option.freezed.dart';
part 'option.g.dart';

sealed class DndOption {
  static const optionTypeKey = 'option_type';

  factory DndOption.fromJson(Json json) {
    switch (json[optionTypeKey]) {
      case DndOptionString.optionType:
        return DndOptionString.fromJson(json);
      case DndOptionReference.optionType:
        return DndOptionReference.fromJson(json);
      case DndOptionMultiple.optionType:
        return DndOptionMultiple.fromJson(json);
      case DndOptionCountedReference.optionType:
        return DndOptionCountedReference.fromJson(json);
      case DndOptionAbilityBonus.optionType:
        return DndOptionAbilityBonus.fromJson(json);
      case DndOptionScorePrerequisite.optionType:
        return DndOptionScorePrerequisite.fromJson(json);
      case DndOptionAction.optionType:
        return DndOptionAction.fromJson(json);
      case DndOptionIdeal.optionType:
        return DndOptionIdeal.fromJson(json);
      case DndOptionDamage.optionType:
        return DndOptionAction.fromJson(json);
      case DndOptionBreath.optionType:
        return DndOptionIdeal.fromJson(json);
      default:
        throw UnimplementedError();
    }
  }

  Json toJson() {
    switch (this) {
      case DndOptionString():
        return {
          optionTypeKey: DndOptionString.optionType,
          ...(this as DndOptionString).toJson(),
        };
      case DndOptionReference():
        return {
          optionTypeKey: DndOptionReference.optionType,
          ...(this as DndOptionReference).toJson(),
        };
      case DndOptionMultiple():
        return {
          optionTypeKey: DndOptionMultiple.optionType,
          ...(this as DndOptionMultiple).toJson(),
        };
      case DndOptionCountedReference():
        return {
          optionTypeKey: DndOptionCountedReference.optionType,
          ...(this as DndOptionCountedReference).toJson(),
        };
      case DndOptionAbilityBonus():
        return {
          optionTypeKey: DndOptionAbilityBonus.optionType,
          ...(this as DndOptionAbilityBonus).toJson(),
        };
      case DndOptionScorePrerequisite():
        return {
          optionTypeKey: DndOptionScorePrerequisite.optionType,
          ...(this as DndOptionScorePrerequisite).toJson(),
        };
      case DndOptionAction():
        return {
          optionTypeKey: DndOptionAction.optionType,
          ...(this as DndOptionAction).toJson(),
        };
      case DndOptionIdeal():
        return {
          optionTypeKey: DndOptionIdeal.optionType,
          ...(this as DndOptionIdeal).toJson(),
        };
      case DndOptionDamage():
        return {
          optionTypeKey: DndOptionDamage.optionType,
          ...(this as DndOptionDamage).toJson(),
        };
      case DndOptionBreath():
        return {
          optionTypeKey: DndOptionBreath.optionType,
          ...(this as DndOptionBreath).toJson(),
        };
    }
  }
}

@freezed
class DndOptionString extends DndOption with _$DndOptionString {
  const factory DndOptionString({
    required String string,
  }) = _DndOptionString;

  factory DndOptionString.fromJson(Json json) =>
      _$DndOptionStringFromJson(json);

  static const optionType = 'string';
}

@freezed
class DndOptionReference extends DndOption with _$DndOptionReference {
  const factory DndOptionReference({
    required DndAPIReference item,
  }) = _DndOptionReference;

  factory DndOptionReference.fromJson(Json json) =>
      _$DndOptionReferenceFromJson(json);

  static const optionType = 'reference';
}

@freezed
class DndOptionMultiple extends DndOption with _$DndOptionMultiple {
  const factory DndOptionMultiple({
    required List<DndOption> items,
  }) = _DndOptionMultiple;

  factory DndOptionMultiple.fromJson(Json json) =>
      _$DndOptionMultipleFromJson(json);

  static const optionType = 'multiple';
}

@freezed
class DndOptionCountedReference extends DndOption
    with _$DndOptionCountedReference {
  const factory DndOptionCountedReference({
    required int count,
    required DndAPIReference of,
  }) = _DndOptionCountedReference;

  factory DndOptionCountedReference.fromJson(Json json) =>
      _$DndOptionCountedReferenceFromJson(json);

  static const optionType = 'counted_reference';
}

@freezed
class DndOptionAbilityBonus extends DndOption with _$DndOptionAbilityBonus {
  const factory DndOptionAbilityBonus({
    required DndAPIReference abilityScore,
    required int bonus,
  }) = _DndOptionAbilityBonus;

  factory DndOptionAbilityBonus.fromJson(Json json) =>
      _$DndOptionAbilityBonusFromJson(json);

  static const optionType = 'ability_bonus';
}

@freezed
class DndOptionScorePrerequisite extends DndOption
    with _$DndOptionScorePrerequisite {
  const factory DndOptionScorePrerequisite({
    required DndAPIReference abilityScore,
    required int minimumScore,
  }) = _DndOptionScorePrerequisite;

  factory DndOptionScorePrerequisite.fromJson(Json json) =>
      _$DndOptionScorePrerequisiteFromJson(json);

  static const optionType = 'score_prerequisite';
}

@JsonEnum()
enum DndActionType {
  melee,
  ranged,
  ability,
  magic,
}

@freezed
class DndOptionAction extends DndOption with _$DndOptionAction {
  const factory DndOptionAction({
    required String actionName,
    required String count,
    required DndActionType type,
    String? notes,
  }) = _DndOptionAction;

  factory DndOptionAction.fromJson(Json json) =>
      _$DndOptionActionFromJson(json);

  static const optionType = 'action';
}

@freezed
class DndOptionIdeal extends DndOption with _$DndOptionIdeal {
  const factory DndOptionIdeal({
    required String desc,
    required List<DndAPIReference> alignments,
  }) = _DndOptionIdeal;

  factory DndOptionIdeal.fromJson(Json json) => _$DndOptionIdealFromJson(json);

  static const optionType = 'ideal';
}

@freezed
class DndOptionDamage extends DndOption with _$DndOptionDamage {
  const factory DndOptionDamage({
    required DndAPIReference damageType,
    required String damageDice,
    String? notes,
  }) = _DndOptionDamage;

  factory DndOptionDamage.fromJson(Json json) =>
      _$DndOptionDamageFromJson(json);

  static const optionType = 'damage';
}

@freezed
class DndOptionBreath extends DndOption with _$DndOptionBreath {
  const factory DndOptionBreath({
    required String name,
    required DndDifficultyClass dc,
    List<DndDamage>? damage,
  }) = _DndOptionBreath;

  factory DndOptionBreath.fromJson(Json json) =>
      _$DndOptionBreathFromJson(json);

  static const optionType = 'breath';
}

@JsonEnum(alwaysCreate: true)
enum DndOptionSetType {
  equipmentCategory,
  resourceList,
  optionsArray,
}

DndOptionSetType _$DndOptionSetTypeFromJson(String value) =>
    _$DndOptionSetTypeEnumMap.entries.firstWhere((m) => m.value == value).key;

extension on DndOptionSetType {
  String toJson() => _$DndOptionSetTypeEnumMap[this]!;
}

class DndChoice {
  const DndChoice({
    this.desc,
    required this.choose,
    required this.type,
    required this.from,
    required this.optionSet,
  });

  final String? desc;
  final int choose;
  final String type;
  final DndOptionSetType from;
  final DndOption optionSet;

  factory DndChoice.fromJson(Json json) {
    final String? desc = json['desc'];
    final int choose = json['choose'];
    final String type = json['type'];
    final DndOptionSetType from =
        _$DndOptionSetTypeFromJson(json['from']['option_set_type']!);

    DndOption optionSet;
    switch (from) {
      case DndOptionSetType.equipmentCategory:
        optionSet = DndOptionReference(
            item: DndAPIReference.fromJson(json['from']['equipment_category']));
        break;
      case DndOptionSetType.resourceList:
        optionSet = DndOptionString(string: json['from']['resource_list']);
        break;
      case DndOptionSetType.optionsArray:
        optionSet = DndOptionMultiple(items: [
          for (Json item in json['from']['options_array'])
            DndOption.fromJson(item),
        ]);
    }

    return DndChoice(
      desc: desc,
      choose: choose,
      type: type,
      from: from,
      optionSet: optionSet,
    );
  }

  Json toJson() {
    Json fromSet = {
      'option_set_type': from.toJson(),
    };
    switch (from) {
      case DndOptionSetType.equipmentCategory:
        fromSet['equipment_category'] =
            (optionSet as DndOptionReference).item.toJson();
        break;
      case DndOptionSetType.resourceList:
        fromSet['resource_list'] = (optionSet as DndOptionString).string;
        break;
      case DndOptionSetType.optionsArray:
        fromSet['options_array'] = [
          for (var item in (optionSet as DndOptionMultiple).items)
            item.toJson(),
        ];
        break;
    }
    return {
      if (desc != null) 'desc': desc,
      'choose': choose,
      'type': type,
      'from': fromSet,
    };
  }
}
