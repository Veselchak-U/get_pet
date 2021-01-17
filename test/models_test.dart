import 'package:flutter/material.dart';
import 'package:get_pet/models/breed.dart';
import 'package:get_pet/models/category.dart';
import 'package:get_pet/models/condition.dart';
import 'package:get_pet/models/member.dart';
import 'package:get_pet/models/pet.dart';
import 'package:test/test.dart';

void main() {
  Color _colorFromString(String value) => Color(int.parse(value));

  String _colorToString(Color color) => color.value.toString();

  final _breedSample = BreedModel(
    id: 'c8305d81-19df-4ddb-8111-0c3d2aea88c5',
    categoryId: 'abe09048-c1dc-4f4b-87e3-421b7f34e07d',
    name: 'Maine Coon',
  );

  final Map<String, dynamic> _breedSampleJson = {
    'id': 'c8305d81-19df-4ddb-8111-0c3d2aea88c5',
    'category_id': 'abe09048-c1dc-4f4b-87e3-421b7f34e07d',
    'name': 'Maine Coon'
  };

  final _categorySample = CategoryModel(
    id: '75fe6ef0-80b4-4ef0-9fb9-5f53d25ee166',
    name: 'Hamsters',
    totalOf: 56,
    assetImage: 'hamster.png',
    backgroundColor: _colorFromString('0xFFFCEBD3'),
  );

  final Map<String, dynamic> _categorySampleJson = {
    'id': '75fe6ef0-80b4-4ef0-9fb9-5f53d25ee166',
    'name': 'Hamsters',
    'total_of': 56,
    'asset_image': 'hamster.png',
    'background_color': _colorToString(_colorFromString('0xFFFCEBD3')),
  };

  final _conditionSample = ConditionModel(
    id: '58d691e4-0e75-47ad-8a37-95dfa08ee639',
    name: 'Adoption',
    textColor: _colorFromString('0xFFE3B774'),
    backgroundColor: _colorFromString('0xFFFCEBD3'),
  );

  final Map<String, dynamic> _conditionSampleJson = {
    'id': '58d691e4-0e75-47ad-8a37-95dfa08ee639',
    'name': 'Adoption',
    'text_color': _colorToString(_colorFromString('0xFFE3B774')),
    'background_color': _colorToString(_colorFromString('0xFFFCEBD3')),
  };

  final _memberSample = MemberModel(
    id: '86a076ed-a761-402a-ae95-00c2d1ea5732',
    name: 'John Doe',
    photo:
        'https://lh3.googleusercontent.com/a-/AOh14Gh_kVNWSsdfsdfec9EvKgm751Pq5l4qTd_LK-Ydgag=s96-c',
    isActive: true,
  );

  final Map<String, dynamic> _memberSampleJson = {
    'id': '86a076ed-a761-402a-ae95-00c2d1ea5732',
    'name': 'John Doe',
    'photo':
        'https://lh3.googleusercontent.com/a-/AOh14Gh_kVNWSsdfsdfec9EvKgm751Pq5l4qTd_LK-Ydgag=s96-c',
    'is_active': true,
  };

  final _petSample = PetModel(
    id: 'a78aa439-b1c6-49a1-a405-59b023536485',
    category: _categorySample.copyWith(),
    breed: _breedSample.copyWith(),
    age: '4 года',
    coloring: 'Gray',
    weight: 5.1,
    address: 'Таганрог',
    distance: 1.1,
    condition: _conditionSample.copyWith(),
    liked: true,
    photos:
        'https://cdn.pixabay.com/photo/2016/02/10/16/37/cat-1192026_960_720.jpg',
    description:
        'There are many variations of passages of Lorem Ipsum available',
    member: _memberSample.copyWith(),
    updatedAt: DateTime(2021, 01, 17, 21, 59),
  );

  final Map<String, dynamic> _petSampleJson = {
    'id': 'a78aa439-b1c6-49a1-a405-59b023536485',
    'category': _categorySample.toJson(),
    'breed': _breedSample.toJson(),
    'age': '4 года',
    'coloring': 'Gray',
    'weight': 5.1,
    'address': 'Таганрог',
    'distance': 1.1,
    'condition': _conditionSample.toJson(),
    'liked': true,
    'photos':
        'https://cdn.pixabay.com/photo/2016/02/10/16/37/cat-1192026_960_720.jpg',
    'description':
        'There are many variations of passages of Lorem Ipsum available',
    'member': _memberSample.toJson(),
    'updated_at': DateTime(2021, 01, 17, 21, 59).toIso8601String(),
  };

  group('BreedModel', () {
    // String id,
    // String categoryId,
    // String name,

    test('copyWith()', () {
      final breedOne = _breedSample.copyWith();
      final breedTwo = breedOne.copyWith(id: '11');
      expect(breedOne.id, _breedSample.id);
      expect(breedTwo.id, '11');
      expect(breedTwo.categoryId, _breedSample.categoryId);
      expect(breedTwo.name, _breedSample.name);
      final breedThree = breedOne.copyWith(name: null);
      expect(breedThree.name, null);
    });

    test('toString()', () {
      expect(_breedSample.toString(), _breedSample.name);
    });

    test('operator =', () {
      final breedOne = _breedSample.copyWith();
      final breedTwo = breedOne.copyWith(id: '11');
      expect(breedOne == breedTwo, isFalse);
      final breedThree = breedOne.copyWith(categoryId: '22');
      expect(breedOne == breedThree, isFalse);
      final breedFour = breedOne.copyWith(name: 'New name');
      expect(breedOne == breedFour, isFalse);
      // copy of _breedSample()
      final breedFive = BreedModel(
        id: 'c8305d81-19df-4ddb-8111-0c3d2aea88c5',
        categoryId: 'abe09048-c1dc-4f4b-87e3-421b7f34e07d',
        name: 'Maine Coon',
      );
      expect(breedOne.id == breedFive.id, isTrue);
      expect(breedOne.categoryId == breedFive.categoryId, isTrue);
      expect(breedOne.name == breedFive.name, isTrue);
      expect(breedOne == breedFive, isTrue);
    });

    test('toJson()', () {
      final Map<String, dynamic> json = _breedSample.toJson();
      final Map<String, dynamic> stub = _breedSampleJson;
      expect(json.toString() == stub.toString(), isTrue);
    });

    test('fromJson()', () {
      final breedOne = _breedSample;
      final breedTwo = BreedModel.fromJson(_breedSampleJson);
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

    test('copyWith()', () {
      final categoryOne = _categorySample.copyWith();
      final categoryTwo = categoryOne.copyWith(id: '11');
      expect(categoryOne.id, _categorySample.id);
      expect(categoryTwo.id, '11');
      expect(categoryTwo.name, _categorySample.name);
      expect(categoryTwo.totalOf, _categorySample.totalOf);
      expect(categoryTwo.assetImage, _categorySample.assetImage);
      expect(categoryTwo.backgroundColor, _categorySample.backgroundColor);
      final categoryThree = categoryOne.copyWith(assetImage: null);
      // must be null after freezed
      expect(categoryThree.assetImage, _categorySample.assetImage);
    });

    test('toString()', () {
      expect(_categorySample.toString(), _categorySample.name);
    });

    test('operator =', () {
      final categoryOne = _categorySample.copyWith();
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
      // copy of _categorySample()
      final categorySeven = CategoryModel(
        id: '75fe6ef0-80b4-4ef0-9fb9-5f53d25ee166',
        name: 'Hamsters',
        totalOf: 56,
        assetImage: 'hamster.png',
        backgroundColor: _colorFromString('0xFFFCEBD3'),
      );
      expect(categoryOne.id == categorySeven.id, isTrue);
      expect(categoryOne.name == categorySeven.name, isTrue);
      expect(categoryOne.totalOf == categorySeven.totalOf, isTrue);
      expect(categoryOne.assetImage == categorySeven.assetImage, isTrue);
      expect(
          categoryOne.backgroundColor == categorySeven.backgroundColor, isTrue);
      // TODO must be isTrue after freezed
      expect(categoryOne == categorySeven, isFalse);
    });

    test('toJson()', () {
      final Map<String, dynamic> json = _categorySample.toJson();
      final Map<String, dynamic> stub = _categorySampleJson;
      expect(json.toString() == stub.toString(), isTrue);
    });

    test('fromJson()', () {
      final categoryOne = _categorySample.copyWith();
      final categoryTwo = CategoryModel.fromJson(_categorySampleJson);
      expect(categoryOne.id == categoryTwo.id, isTrue);
      expect(categoryOne.name == categoryTwo.name, isTrue);
      expect(categoryOne.totalOf == categoryTwo.totalOf, isTrue);
      expect(categoryOne.assetImage == categoryTwo.assetImage, isTrue);
      expect(
          categoryOne.backgroundColor == categoryTwo.backgroundColor, isTrue);
      // TODO must be isTrue after freezed
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

  group('ConditionModel', () {
    // final String id;
    // final String name;
    // @JsonKey(fromJson: _colorFromString, toJson: _colorToString)
    // final Color textColor;
    // @JsonKey(fromJson: _colorFromString, toJson: _colorToString)
    // final Color backgroundColor;

    test('copyWith()', () {
      final conditionOne = _conditionSample.copyWith();
      final conditionTwo = conditionOne.copyWith(id: '11');
      expect(conditionOne.id, _conditionSample.id);
      expect(conditionTwo.id, '11');
      expect(conditionTwo.name, _conditionSample.name);
      expect(conditionTwo.textColor, _conditionSample.textColor);
      expect(conditionTwo.backgroundColor, _conditionSample.backgroundColor);
      final conditionThree = conditionOne.copyWith(name: null);
      // must be null after freezed
      expect(conditionThree.name, _conditionSample.name);
    });

    test('toString()', () {
      expect(_conditionSample.toString(), _conditionSample.name);
    });

    test('operator =', () {
      final conditionOne = _conditionSample.copyWith();
      final conditionTwo = conditionOne.copyWith(id: '11');
      expect(conditionOne == conditionTwo, isFalse);
      final conditionThree = conditionOne.copyWith(name: 'New name');
      expect(conditionOne == conditionThree, isFalse);
      final conditionFour = conditionOne.copyWith(textColor: Colors.green);
      expect(conditionOne == conditionFour, isFalse);
      final conditionFive =
          conditionOne.copyWith(backgroundColor: Colors.yellow);
      expect(conditionOne == conditionFive, isFalse);
      // copy of _conditionSample()
      final conditionSix = ConditionModel(
        id: '58d691e4-0e75-47ad-8a37-95dfa08ee639',
        name: 'Adoption',
        textColor: _colorFromString('0xFFE3B774'),
        backgroundColor: _colorFromString('0xFFFCEBD3'),
      );
      expect(conditionOne.id == conditionSix.id, isTrue);
      expect(conditionOne.name == conditionSix.name, isTrue);
      expect(conditionOne.textColor == conditionSix.textColor, isTrue);
      expect(
          conditionOne.backgroundColor == conditionSix.backgroundColor, isTrue);
      // TODO must be isTrue after freezed
      expect(conditionOne == conditionSix, isFalse);
    });

    test('toJson()', () {
      final Map<String, dynamic> json = _conditionSample.toJson();
      final Map<String, dynamic> stub = _conditionSampleJson;
      expect(json.toString() == stub.toString(), isTrue);
    });

    test('fromJson()', () {
      final conditionOne = _conditionSample.copyWith();
      final conditionTwo = ConditionModel.fromJson(_conditionSampleJson);
      expect(conditionOne.id == conditionTwo.id, isTrue);
      expect(conditionOne.name == conditionTwo.name, isTrue);
      expect(conditionOne.textColor == conditionTwo.textColor, isTrue);
      expect(
          conditionOne.backgroundColor == conditionTwo.backgroundColor, isTrue);
      // TODO must be isTrue after freezed
      expect(conditionOne == conditionTwo, isFalse);
    });
  });

  group('MemberModel', () {
    // final String id;
    // final String name;
    // final String photo;
    // final bool isActive;

    test('copyWith()', () {
      final memberOne = _memberSample.copyWith();
      final memberTwo = memberOne.copyWith(id: '11');
      expect(memberOne.id, _memberSample.id);
      expect(memberTwo.id, '11');
      expect(memberTwo.name, _memberSample.name);
      expect(memberTwo.photo, _memberSample.photo);
      expect(memberTwo.isActive, _memberSample.isActive);
      final memberThree = memberOne.copyWith(name: null);
      // TODO must be null after freezed
      expect(memberThree.name, _memberSample.name);
    });

    test('operator =', () {
      final memberOne = _memberSample.copyWith();
      final memberTwo = memberOne.copyWith(id: '11');
      expect(memberOne == memberTwo, isFalse);
      final memberThree = memberOne.copyWith(name: 'New name');
      expect(memberOne == memberThree, isFalse);
      final memberFour = memberOne.copyWith(photo: 'https://new_photo.url');
      expect(memberOne == memberFour, isFalse);
      final memberFive = memberOne.copyWith(isActive: false);
      expect(memberOne == memberFive, isFalse);
      // copy of _memberSample()
      final memberSix = MemberModel(
        id: '86a076ed-a761-402a-ae95-00c2d1ea5732',
        name: 'John Doe',
        photo:
            'https://lh3.googleusercontent.com/a-/AOh14Gh_kVNWSsdfsdfec9EvKgm751Pq5l4qTd_LK-Ydgag=s96-c',
        isActive: true,
      );
      expect(memberOne.id == memberSix.id, isTrue);
      expect(memberOne.name == memberSix.name, isTrue);
      expect(memberOne.photo == memberSix.photo, isTrue);
      expect(memberOne.isActive == memberSix.isActive, isTrue);
      // TODO must be isTrue after freezed
      expect(memberOne == memberSix, isFalse);
    });

    test('toJson()', () {
      final Map<String, dynamic> json = _memberSample.toJson();
      final Map<String, dynamic> stub = _memberSampleJson;
      expect(json.toString() == stub.toString(), isTrue);
    });

    test('fromJson()', () {
      final memberTwo = MemberModel.fromJson(_memberSampleJson);
      expect(memberTwo.id == _memberSample.id, isTrue);
      expect(memberTwo.name == _memberSample.name, isTrue);
      expect(memberTwo.photo == _memberSample.photo, isTrue);
      expect(memberTwo.isActive == _memberSample.isActive, isTrue);
      // TODO must be isTrue after freezed
      expect(memberTwo == _memberSample, isFalse);
    });
  });

  group('PetModel', () {
    // final String id; // id
    // final CategoryModel category; // категория
    // final BreedModel breed; // порода
    // final String age; // возраст
    // final String coloring; // окрас
    // final double weight; // вес double
    // final String address; // адрес
    // final double distance; // расстояние до  double
    // final ConditionModel condition; // действие
    // final bool liked; // понравилось
    // final String photos; // TODO список фотографий
    // final String description; // описание
    // final MemberModel member; // контактное лицо
    // final DateTime updatedAt; // дата обновления

    test('copyWith()', () {
      final petOne = _petSample.copyWith();
      const newId = '11';
      final petTwo = petOne.copyWith(id: newId);
      expect(petOne.id, _petSample.id);
      expect(petTwo.id, newId);
      expect(petTwo.category, _petSample.category);
      expect(petTwo.breed, _petSample.breed);
      expect(petTwo.age, _petSample.age);
      expect(petTwo.coloring, _petSample.coloring);
      expect(petTwo.weight, _petSample.weight);
      expect(petTwo.address, _petSample.address);
      expect(petTwo.distance, _petSample.distance);
      expect(petTwo.condition, _petSample.condition);
      expect(petTwo.liked, _petSample.liked);
      expect(petTwo.photos, _petSample.photos);
      expect(petTwo.description, _petSample.description);
      expect(petTwo.member, _petSample.member);
      expect(petTwo.updatedAt, _petSample.updatedAt);
      final petThree = petOne.copyWith(description: null);
      // TODO null assignment - must be null after freezed
      expect(petThree.description, _petSample.description);
    });

    test('operator =', () {
      final petOne = _petSample.copyWith();
      var petTwo = petOne.copyWith(id: '11');
      expect(petOne == petTwo, isFalse);
      petTwo =
          petOne.copyWith(category: _categorySample.copyWith(name: 'New name'));
      expect(petOne == petTwo, isFalse);
      petTwo = petOne.copyWith(breed: _breedSample.copyWith(name: 'New name'));
      expect(petOne == petTwo, isFalse);
      petTwo = petOne.copyWith(age: 'New age');
      expect(petOne == petTwo, isFalse);
      petTwo = petOne.copyWith(coloring: 'New coloring');
      expect(petOne == petTwo, isFalse);
      petTwo = petOne.copyWith(weight: 0.33);
      expect(petOne == petTwo, isFalse);
      petTwo = petOne.copyWith(address: 'New address');
      expect(petOne == petTwo, isFalse);
      petTwo = petOne.copyWith(distance: 4.44);
      expect(petOne == petTwo, isFalse);
      petTwo = petOne.copyWith(
          condition: _conditionSample.copyWith(name: 'New name'));
      expect(petOne == petTwo, isFalse);
      petTwo = petOne.copyWith(liked: !_petSample.liked);
      expect(petOne == petTwo, isFalse);
      petTwo = petOne.copyWith(photos: 'New photos');
      expect(petOne == petTwo, isFalse);
      petTwo = petOne.copyWith(description: 'New description');
      expect(petOne == petTwo, isFalse);
      petTwo =
          petOne.copyWith(member: _memberSample.copyWith(name: 'New name'));
      expect(petOne == petTwo, isFalse);
      petTwo = petOne.copyWith(updatedAt: DateTime.now());
      expect(petOne == petTwo, isFalse);
      // copy of _petSample()
      petTwo = PetModel(
        id: 'a78aa439-b1c6-49a1-a405-59b023536485',
        category: _categorySample.copyWith(),
        breed: _breedSample.copyWith(),
        age: '4 года',
        coloring: 'Gray',
        weight: 5.1,
        address: 'Таганрог',
        distance: 1.1,
        condition: _conditionSample.copyWith(),
        liked: true,
        photos:
            'https://cdn.pixabay.com/photo/2016/02/10/16/37/cat-1192026_960_720.jpg',
        description:
            'There are many variations of passages of Lorem Ipsum available',
        member: _memberSample.copyWith(),
        updatedAt: DateTime(2021, 01, 17, 21, 59),
      );
      // TODO must be isTrue after freezed
      expect(petTwo == _petSample, isFalse);
    });

    test('toJson()', () {
      final Map<String, dynamic> json = _petSample.toJson();
      final Map<String, dynamic> stub = _petSampleJson;
      expect(json.toString() == stub.toString(), isTrue);
    });

    test('fromJson()', () {
      final petTwo = PetModel.fromJson(_petSampleJson);
      expect(petTwo.id, _petSample.id);
      // TODO must be isTrue after freezed
      expect(petTwo.category == _petSample.category, isFalse);
      expect(petTwo.breed, _petSample.breed);
      expect(petTwo.age, _petSample.age);
      expect(petTwo.coloring, _petSample.coloring);
      expect(petTwo.weight, _petSample.weight);
      expect(petTwo.address, _petSample.address);
      expect(petTwo.distance, _petSample.distance);
      // TODO must be isTrue after freezed
      expect(petTwo.condition == _petSample.condition, isFalse);
      expect(petTwo.liked, _petSample.liked);
      expect(petTwo.photos, _petSample.photos);
      expect(petTwo.description, _petSample.description);
      // TODO must be isTrue after freezed
      expect(petTwo.member == _petSample.member, isFalse);
      expect(petTwo.updatedAt, _petSample.updatedAt);
      // TODO must be isTrue after freezed
      expect(petTwo == _petSample, isFalse);
    });
  });
}
