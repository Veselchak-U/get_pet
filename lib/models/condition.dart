import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'condition.g.dart';

@JsonSerializable(createToJson: false)
class ConditionModel {
  ConditionModel({
    this.id,
    this.name,
    this.textColor,
    this.backgroundColor,
  });

  final String id;
  final String name;
  @JsonKey(fromJson: _colorFromString)
  final Color textColor;
  @JsonKey(fromJson: _colorFromString)
  final Color backgroundColor;

  factory ConditionModel.fromJson(Map<String, dynamic> json) =>
      _$ConditionModelFromJson(json);

  static Color _colorFromString(String value) => Color(int.parse(value));
}
