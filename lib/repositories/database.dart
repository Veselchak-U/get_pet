import 'package:cats/import.dart';
import 'package:flutter/material.dart';

class DatabaseRepository {
  Future<int> loadNotificationCount() async {
    var result = 2;
    await Future.delayed(const Duration(milliseconds: 300));
    return result;
  }

  Future<String> loadUserAvatarImage() async {
    var result =
        'https://images.unsplash.com/photo-1602773890240-87ce74fc752e?ixlib=rb-1.2.1&auto=format&fit=crop&w=700&q=80';
    await Future.delayed(const Duration(milliseconds: 300));
    return result;
  }

  Future<List<PetCategory>> loadPetCategories() async {
    var result = [
      PetCategory(
        name: 'Hamster',
        count: 56,
        image: 'assets/image/hamster.png',
        background: Color(0xffF9EDD3),
      ),
      PetCategory(
        name: 'Cats',
        count: 210,
        image: 'assets/image/cat.png',
        background: Color(0xffD8F1FD),
      ),
      PetCategory(
        name: 'Bunnies',
        count: 90,
        image: 'assets/image/rabbit.png',
        background: Color(0xffE6F3E7),
      ),
      PetCategory(
        name: 'Dogs',
        count: 340,
        image: 'assets/image/dog.png',
        background: Color(0xffFAE0D8),
      ),
    ];
    await Future.delayed(const Duration(milliseconds: 300));
    return result;
  }

  Future<List<Pet>> loadNewestPets() async {
    List<Pet> result = [];
    await Future.delayed(const Duration(milliseconds: 300));
    return result;
  }
}
