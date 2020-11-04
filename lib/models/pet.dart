import 'package:json_annotation/json_annotation.dart';

part 'pet.g.dart';

@JsonSerializable()
class PetModel {
  PetModel({
    this.id,
    this.idCategory,
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
    this.pet,
  });

  final String id; // id
  final String idCategory; // id категории (PetCategory)
  final String breed; // порода
  // final Gender gender; // пол
  final String age; // возраст
  final String coloring; // окрас
  final int weight; // вес
  // final double weight; // вес
  final String address; // адрес
  final int distance; // расстояние до
  // final double distance; // расстояние до
  final String condition; // действие
  // final PetAction condition; // действие
  final bool liked; // понравилось
  final String photos; // список фотографий
  // final List<String> photos; // список фотографий
  final String description; // описание
  final String pet; // контактное лицо
  // final Pet contact; // контактное лицо

  factory PetModel.fromJson(Map<String, dynamic> json) =>
      _$PetModelFromJson(json);

  Map<String, dynamic> toJson() => _$PetModelToJson(this);
}

// enum Gender { male, female } // мальчик, девочка

// enum PetAction { adoption, mating, disappear } // приют, вязка, пропажа
