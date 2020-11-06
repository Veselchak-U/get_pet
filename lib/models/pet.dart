import 'package:cats/import.dart';
import 'package:json_annotation/json_annotation.dart';

part 'pet.g.dart';

@JsonSerializable()
class PetModel {
  PetModel({
    this.id,
    this.category,
    this.breed,
    // this.gender,
    this.age,
    this.coloring,
    this.weight,
    this.address,
    this.distance,
    this.condition,
    this.liked = true,
    this.photos,
    this.description,
    this.member,
  });

  final String id; // id
  final CategoryModel category; // категория
  final String breed; // порода
  // final Gender gender; // пол
  final String age; // возраст
  final String coloring; // окрас
  final int weight; // вес double
  final String address; // адрес
  final int distance; // расстояние до  double
  final ConditionModel condition; // действие
  @JsonKey(ignore: true)
  final bool liked; // понравилось
  final String photos; // список фотографий
  // final List<String> photos; // список фотографий
  final String description; // описание
  final MemberModel member; // контактное лицо

  factory PetModel.fromJson(Map<String, dynamic> json) =>
      _$PetModelFromJson(json);

  Map<String, dynamic> toJson() => _$PetModelToJson(this);
}

// enum Gender { male, female } // мальчик, девочка

// enum PetAction { adoption, mating, disappear } // приют, вязка, пропажа
