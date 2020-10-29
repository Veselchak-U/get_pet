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
}
