import 'package:flutter/material.dart';

// Категория питомца
class PetCategory {
  PetCategory({
    this.id,
    this.name,
    this.totalOf,
    this.image,
    this.background,
  });

  final String id;
  final String name;
  final int totalOf;
  final String image;
  final Color background;

  PetCategory.fromJson(Map<String, dynamic> json)
      : id = json['id'] as String,
        name = json['name'] as String,
        totalOf = json['totalOf'] as int,
        image = json['image'] as String,
        background = Color(int.parse(json['background'] as String));

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'totalOf': totalOf,
        'image': image,
        'background': background.value.toString(),
      };
}
