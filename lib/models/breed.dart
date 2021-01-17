import 'package:freezed_annotation/freezed_annotation.dart';
// import 'package:flutter/foundation.dart'; // with it does'n works toString() - https://github.com/rrousselGit/freezed/issues/221

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

  // need to work the overrided method toString()
  BreedModel._();

  @override
  String toString() => name;
}
