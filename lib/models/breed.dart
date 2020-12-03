import 'package:json_annotation/json_annotation.dart';

part 'breed.g.dart';

@JsonSerializable()
class BreedModel {
  BreedModel({
    this.id,
    this.categoryId,
    this.name,
  });

  final String id;
  final String categoryId;
  final String name;

  @override
  String toString() => name;

  factory BreedModel.fromJson(Map<String, dynamic> json) =>
      _$BreedModelFromJson(json);

  Map<String, dynamic> toJson() => _$BreedModelToJson(this);
}
