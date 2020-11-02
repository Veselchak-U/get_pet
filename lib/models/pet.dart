import 'package:cats/import.dart';

// Питомец
class Pet {
  Pet({
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
    // this.liked,
    this.photos,
    this.description,
    this.member,
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
  // final bool liked; // понравилось
  final String photos; // список фотографий
  // final List<String> photos; // список фотографий
  final String description; // описание
  final String member; // контактное лицо
  // final Member contact; // контактное лицо

  Pet.fromJson(Map<String, dynamic> json)
      : id = json['id'] as String,
        idCategory = json['idCategory'] as String,
        breed = json['breed'] as String,
        // gender = Gender.values
        //     .firstWhere((e) => e.toString() == (json['gender'] as String)),
        age = json['age'] as String,
        coloring = json['coloring'] as String,
        weight = json['weight'] as int, //double,
        address = json['address'] as String,
        distance = json['distance'] as int, //double,
        condition = json['condition'] as String,
        // condition = PetAction.values
        //     .firstWhere((e) => e.toString() == (json['action'] as String)),
        // liked = json['liked'] as bool,
        photos = json['photos'] as String,
        // photos = json['photos'] as List<String>,
        description = json['description'] as String,
        member = json['member'] as String;
        // contact = json['contact'] as Member;

  Map<String, dynamic> toJson() => {
        'id': id,
        'idCategory': idCategory,
        'breed': breed,
        // 'gender': gender.toString(),
        'age': age,
        'coloring': coloring,
        'weight': weight,
        'address': address,
        'distance': distance,
        'condition': condition,
        // 'action': condition.toString(),
        // 'liked': liked,
        'photos': photos,
        'description': description,
        'member': member,
      };
}

// enum Gender { male, female } // мальчик, девочка

enum PetAction { adoption, mating, disappear } // приют, вязка, пропажа
