import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
// with foundation doesn't works method toString() - https://github.com/rrousselGit/freezed/issues/221
// import 'package:flutter/foundation.dart';

part 'condition.freezed.dart';
part 'condition.g.dart';

@freezed
abstract class ConditionModel implements _$ConditionModel {
  const factory ConditionModel({
    String id,
    String name,
    @JsonKey(fromJson: ConditionModel._colorFromString,
    toJson: ConditionModel._colorToString)
        Color textColor,
    @JsonKey(fromJson: ConditionModel._colorFromString,
    toJson: ConditionModel._colorToString)
        Color backgroundColor,
  }) = _ConditionModel;

  factory ConditionModel.fromJson(Map<String, dynamic> json) =>
      _$ConditionModelFromJson(json);

  // required for the overridden method toString()
  const ConditionModel._();

  @override
  String toString() => name;

  static Color _colorFromString(String value) => Color(int.parse(value));

  static String _colorToString(Color color) => color.value.toString();
}
