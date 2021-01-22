import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
// with foundation doesn't works method toString() - https://github.com/rrousselGit/freezed/issues/221
// import 'package:flutter/foundation.dart';

part 'category.freezed.dart';
part 'category.g.dart';

@freezed
abstract class CategoryModel implements _$CategoryModel {
  const factory CategoryModel({
    String id,
    String name,
    int totalOf,
    @JsonKey(nullable: true) String assetImage,
    @JsonKey(fromJson: CategoryModel._colorFromString,
             toJson: CategoryModel._colorToString)
    Color backgroundColor,
  }) = _CategoryModel;

  factory CategoryModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryModelFromJson(json);

  // required for the overridden method toString()
  const CategoryModel._();

  @override
  String toString() => name;

  static Color _colorFromString(String value) => Color(int.parse(value));

  static String _colorToString(Color color) => color.value.toString();
}
