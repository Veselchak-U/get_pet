import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'condition.g.dart';

@JsonSerializable()
class ConditionModel {
  ConditionModel({
    this.id,
    this.name,
    this.textColor,
    this.backgroundColor,
  });

  final String id;
  final String name;
  @JsonKey(fromJson: _colorFromString, toJson: _colorToString)
  final Color textColor;
  @JsonKey(fromJson: _colorFromString, toJson: _colorToString)
  final Color backgroundColor;

  @override
  String toString() => name;

  factory ConditionModel.fromJson(Map<String, dynamic> json) =>
      _$ConditionModelFromJson(json);

  Map<String, dynamic> toJson() => _$ConditionModelToJson(this);

  static Color _colorFromString(String value) => Color(int.parse(value));

  static String _colorToString(Color color) => color.value.toString();
}
