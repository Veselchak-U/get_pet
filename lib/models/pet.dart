import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:get_pet/models/breed.dart';
import 'package:get_pet/models/category.dart';
import 'package:get_pet/models/condition.dart';
import 'package:get_pet/models/member.dart';

part 'pet.freezed.dart';
part 'pet.g.dart';

@freezed
abstract class PetModel with _$PetModel {
  const factory PetModel({
    String id, // id
    CategoryModel category, // категория
    BreedModel breed, // порода
    String age, // возраст
    String coloring, // окрас
    double weight, // вес double
    String address, // адрес
    double distance, // расстояние до  double
    ConditionModel condition, // действие
    bool liked, // понравилось
    String photos, // TODO список фотографий
    String description, // описание
    MemberModel member, // контактное лицо
    DateTime updatedAt, // дата обновления
  }) = _PetModel;

  factory PetModel.fromJson(Map<String, dynamic> json) =>
      _$PetModelFromJson(json);
}
