import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'condition.g.dart';

@CopyWith()
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

  // ignore: sort_constructors_first
  factory ConditionModel.fromJson(Map<String, dynamic> json) =>
      _$ConditionModelFromJson(json);

  Map<String, dynamic> toJson() => _$ConditionModelToJson(this);

  static Color _colorFromString(String value) => Color(int.parse(value));

  static String _colorToString(Color color) => color.value.toString();
}
