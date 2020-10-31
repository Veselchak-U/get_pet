import 'package:flutter/material.dart';

// Категория питомца
class PetCategory {
  PetCategory({
    this.id,
    this.name,
    this.count,
    this.image,
    this.background,
  });

  final int id;
  final String name;
  final int count;
  final String image;
  final Color background;

  PetCategory.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int,
        name = json['name'] as String,
        count = json['count'] as int,
        image = json['image'] as String,
        background = Color(int.parse(json['background'] as String));

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'count': count,
        'image': image,
        'background': background.value.toString(),
      };
}
