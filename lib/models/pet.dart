import 'package:cats/import.dart';

// Питомец
class Pet {
  Pet({
    this.id,
    this.idCategory,
    this.breed,
    this.gender,
    this.age,
    this.coloring,
    this.weight,
    this.address,
    this.distance,
    this.action,
    this.liked,
    this.photos,
    this.description,
    this.contact,
  });

  final int id; // id
  final int idCategory; // id категории (PetCategory)
  final String breed; // порода
  final Gender gender; // пол
  final String age; // возраст
  final String coloring; // окрас
  final double weight; // вес
  final String address; // адрес
  final double distance; // расстояние до
  final PetAction action; // действие
  final bool liked; // понравилось
  final List<String> photos; // список фотографий
  final String description; // описание
  final Contact contact; // контактное лицо
}

enum Gender { male, female } // мальчик, девочка

enum PetAction { adoption, mating, disappear } // приют, вязка, пропажа
