import 'package:freezed_annotation/freezed_annotation.dart';
// with foundation doesn't works method toString() - https://github.com/rrousselGit/freezed/issues/221
// import 'package:flutter/foundation.dart';

part 'breed.freezed.dart';
part 'breed.g.dart';

@freezed
abstract class BreedModel implements _$BreedModel {
  factory BreedModel({
    String id,
    String categoryId,
    String name,
  }) = _BreedModel;

  factory BreedModel.fromJson(Map<String, dynamic> json) =>
      _$BreedModelFromJson(json);

  // required for the overridden method toString()
  BreedModel._();

  @override
  String toString() => name;
}
