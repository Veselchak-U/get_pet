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

  Pet.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int,
        idCategory = json['idCategory'] as int,
        breed = json['breed'] as String,
        gender = Gender.values
            .firstWhere((e) => e.toString() == (json['gender'] as String)),
        age = json['age'] as String,
        coloring = json['coloring'] as String,
        weight = json['weight'] as double,
        address = json['address'] as String,
        distance = json['distance'] as double,
        action = PetAction.values
            .firstWhere((e) => e.toString() == (json['action'] as String)),
        liked = json['liked'] as bool,
        photos = json['photos'] as List<String>,
        description = json['description'] as String,
        contact = json['contact'] as Contact;

  Map<String, dynamic> toJson() => {
        'id': id,
        'idCategory': idCategory,
        'breed': breed,
        'gender': gender.toString(),
        'age': age,
        'coloring': coloring,
        'weight': weight,
        'address': address,
        'distance': distance,
        'action': action.toString(),
        'liked': liked,
        'photos': photos,
        'description': description,
        'contact': contact,
      };
}

enum Gender { male, female } // мальчик, девочка

enum PetAction { adoption, mating, disappear } // приют, вязка, пропажа
