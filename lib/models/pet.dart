import 'package:flutter/material.dart';
import 'package:cats/import.dart';

// Питомец
class Pet {
  Pet({
    @required this.breed,
    @required this.gender,
    this.age,
    @required this.coloring,
    this.weight,
    @required this.address,
    this.distance,
    @required this.action,
    this.liked,
    @required this.photos,
    @required this.description,
    @required this.contact,
  });

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
