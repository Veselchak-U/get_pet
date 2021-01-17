import 'package:flutter/material.dart';
import 'package:get_pet/models/breed.dart';
import 'package:get_pet/models/category.dart';
import 'package:test/test.dart';

void main() {
  group('BreedModel', () {
    // String id,
    // String categoryId,
    // String name,

    test('copyWith()', () {
      final breedOne = BreedModel(
        id: '1',
        categoryId: '2',
        name: 'The name of breed',
      );
      final breedTwo = breedOne.copyWith(id: '11');
      expect(breedOne.id, '1');
      expect(breedTwo.id, '11');
      expect(breedTwo.categoryId, '2');
      expect(breedTwo.name, 'The name of breed');
      final breedThree = breedOne.copyWith(name: null);
      expect(breedThree.name, null);
    });

    test('toString()', () {
      final breedOne = BreedModel(
        id: '1',
        categoryId: '2',
        name: 'The name of breed',
      );
      expect(breedOne.toString(), 'The name of breed');
    });

    test('operator =', () {
      final breedOne = BreedModel(
        id: '1',
        categoryId: '2',
        name: 'The name of breed',
      );
      final breedTwo = breedOne.copyWith(id: '11');
      expect(breedOne == breedTwo, isFalse);

      final breedThree = breedOne.copyWith(categoryId: '22');
      expect(breedOne == breedThree, isFalse);

      final breedFour = breedOne.copyWith(name: 'New name');
      expect(breedOne == breedFour, isFalse);

      final breedFive = BreedModel(
        id: '1',
        categoryId: '2',
        name: 'The name of breed',
      );
      expect(breedOne == breedFive, isTrue);
    });

    test('toJson()', () {
      final breedOne = BreedModel(
        id: 'c8305d81-19df-4ddb-8111-0c3d2aea88c5',
        categoryId: 'abe09048-c1dc-4f4b-87e3-421b7f34e07d',
        name: 'Maine Coon',
      );
      final Map<String, dynamic> jsonTxt = breedOne.toJson();
      final Map<String, dynamic> stubTxt = {
        'id': 'c8305d81-19df-4ddb-8111-0c3d2aea88c5',
        'category_id': 'abe09048-c1dc-4f4b-87e3-421b7f34e07d',
        'name': 'Maine Coon'
      };
      expect(jsonTxt.toString() == stubTxt.toString(), isTrue);
    });

    test('fromJson()', () {
      final breedOne = BreedModel(
        id: 'c8305d81-19df-4ddb-8111-0c3d2aea88c5',
        categoryId: 'abe09048-c1dc-4f4b-87e3-421b7f34e07d',
        name: 'Maine Coon',
      );
      final Map<String, dynamic> json = {
        'id': 'c8305d81-19df-4ddb-8111-0c3d2aea88c5',
        'category_id': 'abe09048-c1dc-4f4b-87e3-421b7f34e07d',
        'name': 'Maine Coon'
      };
      final breedTwo = BreedModel.fromJson(json);
      expect(breedOne == breedTwo, isTrue);
    });
  });

  group('CategoryModel', () {
    // final String id;
    // final String name;
    // final int totalOf;
    // @JsonKey(nullable: true)
    // final String assetImage;
    // @JsonKey(fromJson: _colorFromString, toJson: _colorToString)
    // Color backgroundColor;

    Color _colorFromString(String value) => Color(int.parse(value));

    String _colorToString(Color color) => color.value.toString();

    test('copyWith()', () {
      final categoryOne = CategoryModel(
        id: '1',
        name: 'The name of category',
        totalOf: 3,
        assetImage: 'https://image.url',
        backgroundColor: Colors.white,
      );
      final CategoryModel categoryTwo = categoryOne.copyWith(id: '11');
      expect(categoryOne.id, '1');
      expect(categoryTwo.id, '11');
      expect(categoryTwo.name, 'The name of category');
      expect(categoryTwo.totalOf, 3);
      expect(categoryTwo.assetImage, 'https://image.url');
      expect(categoryTwo.backgroundColor, Colors.white);
      final CategoryModel categoryThree =
          categoryOne.copyWith(assetImage: null);
      expect(categoryThree.assetImage, 'https://image.url');
    });

    test('toString()', () {
      final categoryOne = CategoryModel(
        id: '1',
        name: 'The name of category',
        totalOf: 3,
        assetImage: 'https://image.url',
        backgroundColor: Colors.white,
      );
      expect(categoryOne.toString(), 'The name of category');
    });

    test('operator =', () {
      final categoryOne = CategoryModel(
        id: '1',
        name: 'The name of category',
        totalOf: 3,
        assetImage: 'https://image.url',
        backgroundColor: Colors.white,
      );
      final categoryTwo = categoryOne.copyWith(id: '11');
      expect(categoryOne == categoryTwo, isFalse);

      final categoryThree = categoryOne.copyWith(name: 'New name');
      expect(categoryOne == categoryThree, isFalse);

      final categoryFour = categoryOne.copyWith(totalOf: 4);
      expect(categoryOne == categoryFour, isFalse);

      final categoryFive =
          categoryOne.copyWith(assetImage: 'https://new_image.url');
      expect(categoryOne == categoryFive, isFalse);

      final categorySix = categoryOne.copyWith(backgroundColor: Colors.black);
      expect(categoryOne == categorySix, isFalse);

      final categorySeven = CategoryModel(
        id: '1',
        name: 'The name of category',
        totalOf: 3,
        assetImage: 'https://image.url',
        backgroundColor: Colors.white,
      );
      expect(categoryOne == categorySeven, isFalse);
    });

    test('toJson()', () {
      final categoryOne = CategoryModel(
        id: '75fe6ef0-80b4-4ef0-9fb9-5f53d25ee166',
        name: 'Hamsters',
        totalOf: 56,
        assetImage: 'hamster.png',
        backgroundColor: _colorFromString('0xFFFCEBD3'),
      );
      final Map<String, dynamic> json = categoryOne.toJson();
      final Map<String, dynamic> stub = {
        'id': '75fe6ef0-80b4-4ef0-9fb9-5f53d25ee166',
        'name': 'Hamsters',
        'total_of': 56,
        'asset_image': 'hamster.png',
        'background_color': _colorToString(_colorFromString('0xFFFCEBD3')),
      };
      expect(json.toString() == stub.toString(), isTrue);
    });

    test('fromJson()', () {
      final categoryOne = CategoryModel(
        id: '75fe6ef0-80b4-4ef0-9fb9-5f53d25ee166',
        name: 'Hamsters',
        totalOf: 56,
        assetImage: 'hamster.png',
        backgroundColor: _colorFromString('0xFFFCEBD3'),
      );
      final Map<String, dynamic> json = {
        'id': '75fe6ef0-80b4-4ef0-9fb9-5f53d25ee166',
        'name': 'Hamsters',
        'total_of': 56,
        'asset_image': 'hamster.png',
        'background_color': _colorToString(_colorFromString('0xFFFCEBD3')),
      };
      final categoryTwo = CategoryModel.fromJson(json);
      expect(categoryOne.id == categoryTwo.id, isTrue);
      expect(categoryOne.name == categoryTwo.name, isTrue);
      expect(categoryOne.totalOf == categoryTwo.totalOf, isTrue);
      expect(categoryOne.assetImage == categoryTwo.assetImage, isTrue);
      expect(
          categoryOne.backgroundColor == categoryTwo.backgroundColor, isTrue);
      expect(categoryOne == categoryTwo, isFalse);
    });

    test('fromJson() nullable', () {
      final categoryOne = CategoryModel(
        id: '1',
        name: '2',
        assetImage: '4',
        backgroundColor: _colorFromString('5'),
      );
      final Map<String, dynamic> json = {
        'id': '1',
        'name': '2',
        'total_of': null,
        'asset_image': '4',
        'background_color': _colorToString(_colorFromString('5')),
      };
      final categoryTwo = CategoryModel.fromJson(json);
      expect(categoryOne.totalOf == categoryTwo.totalOf, isTrue);
      expect(categoryOne == categoryTwo, isFalse);
    });
  });
}
