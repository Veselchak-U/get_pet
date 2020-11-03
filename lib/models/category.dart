import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'category.g.dart';

@JsonSerializable()
class CategoryModel {
  CategoryModel({
    this.id,
    this.name,
    this.totalOf,
    this.image,
    this.background,
  });

  final String id;
  final String name;
  final int totalOf;
  final String image;
  @JsonKey(fromJson: _colorFromString, toJson: _colorToString)
  Color background;

  factory CategoryModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryModelFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryModelToJson(this);

  static Color _colorFromString(String value) => Color(int.parse(value));

  static String _colorToString(Color color) => color.value.toString();
}
