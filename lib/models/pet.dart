import 'package:json_annotation/json_annotation.dart';

part 'pet.g.dart';

@JsonSerializable()
class PetModel {
  PetModel({
    this.id,
    this.categoryId,
    this.breed,
    // this.gender,
    this.age,
    this.coloring,
    this.weight,
    this.address,
    this.distance,
    this.conditionId,
    this.liked = true,
    this.photos,
    this.description,
    this.memberId,
  });

  final String id; // id
  final String categoryId; // id категории (PetCategory)
  final String breed; // порода
  // final Gender gender; // пол
  final String age; // возраст
  final String coloring; // окрас
  final int weight; // вес
  // final double weight; // вес
  final String address; // адрес
  final int distance; // расстояние до
  // final double distance; // расстояние до
  final String conditionId; // действие
  @JsonKey(ignore: true)
  final bool liked; // понравилось
  final String photos; // список фотографий
  // final List<String> photos; // список фотографий
  final String description; // описание
  final String memberId; // контактное лицо

  factory PetModel.fromJson(Map<String, dynamic> json) =>
      _$PetModelFromJson(json);

  Map<String, dynamic> toJson() => _$PetModelToJson(this);
}

// enum Gender { male, female } // мальчик, девочка

// enum PetAction { adoption, mating, disappear } // приют, вязка, пропажа
