import 'package:flutter/material.dart';
import 'package:get_pet/models/breed.dart';
import 'package:get_pet/models/category.dart';
import 'package:get_pet/models/condition.dart';
import 'package:get_pet/models/member.dart';
import 'package:get_pet/models/pet.dart';
import 'package:get_pet/models/sys_param.dart';
import 'package:get_pet/models/user.dart';
import 'package:get_pet/models/vet.dart';
import 'package:test/test.dart';

void main() {
  Color _colorFromString(String value) => Color(int.parse(value));

  String _colorToString(Color color) => color.value.toString();

  const _breedSample = BreedModel(
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

  const _memberSample = MemberModel(
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

  const _sysParamSample = SysParamModel(
    label: 'min_version',
    value: '42',
    valueTxt: '1.0.42',
    note: 'Minimum app version',
  );

  final Map<String, dynamic> _sysParamSampleJson = {
    'label': 'min_version',
    'value': '42',
    'value_txt': '1.0.42',
    'note': 'Minimum app version',
  };

  const _userModelSample = UserModel(
    id: '86a076ed-a761-402a-ae95-00c2d1ea5732',
    name: 'Jon Doe',
    photo: 'https://lh3.googleusercontent.com',
    email: 'Jon_Doe@gmail.com',
    phone: '911',
    isActive: true,
  );

  final Map<String, dynamic> _userModelSampleJson = {
    'id': '86a076ed-a761-402a-ae95-00c2d1ea5732',
    'name': 'Jon Doe',
    'photo': 'https://lh3.googleusercontent.com',
    'email': 'Jon_Doe@gmail.com',
    'phone': '911',
    'is_active': true,
  };

  const _vetModelSample = VetModel(
    id: '5b08256a-0da0-4bc5-a5f3-bb8bb2207e25',
    name: 'РИмонт ЖЫвотных',
    phone: '(8634) 222-333',
    timetable: 'TOMORROW AT 8:00',
    isOpenNow: true,
    logoImage: 'http://animalservice.ru',
  );

  final Map<String, dynamic> _vetModelSampleJson = {
    'id': '5b08256a-0da0-4bc5-a5f3-bb8bb2207e25',
    'name': 'РИмонт ЖЫвотных',
    'phone': '(8634) 222-333',
    'timetable': 'TOMORROW AT 8:00',
    'is_open_now': true,
    'logo_image': 'http://animalservice.ru',
  };

  group('BreedModel', () {
    // String id,
    // String categoryId,
    // String name,

    const model = _breedSample;
    final modelJson = _breedSampleJson;

    test('copyWith()', () {
      final unitOne = model.copyWith();
      const newFieldValue = 'New value';
      final unitTwo = unitOne.copyWith(id: newFieldValue);
      // comparing any field
      expect(unitOne.id, model.id);
      expect(unitTwo.id, newFieldValue);
      expect(unitTwo.categoryId, model.categoryId);
      expect(unitTwo.name, model.name);
      // null assignment
      final unitThree = unitOne.copyWith(name: null);
      expect(unitThree.name, null);
    });

    test('toString()', () {
      expect(model.toString(), model.name);
    });

    test('operator =', () {
      // comparing objects after new Object()
      var newUnit = const BreedModel(
        id: 'c8305d81-19df-4ddb-8111-0c3d2aea88c5',
        categoryId: 'abe09048-c1dc-4f4b-87e3-421b7f34e07d',
        name: 'Maine Coon',
      );
      expect(newUnit, model);
      // comparing objects after copyWith()
      newUnit = model.copyWith();
      expect(newUnit, model);
      // comparing objects after changing any field
      newUnit = model.copyWith(id: 'New id');
      expect(newUnit == model, isFalse);
      newUnit = model.copyWith(categoryId: 'New categoryId');
      expect(newUnit == model, isFalse);
      newUnit = model.copyWith(name: 'New name');
      expect(newUnit == model, isFalse);
    });

    test('toJson()', () {
      final Map<String, dynamic> newJson = model.toJson();
      expect(newJson.toString(), modelJson.toString());
    });

    test('fromJson()', () {
      final newUnit = BreedModel.fromJson(modelJson);
      expect(newUnit, model);
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

    final model = _categorySample;
    final modelJson = _categorySampleJson;

    test('copyWith()', () {
      final unitOne = model.copyWith();
      const newFieldValue = 'New value';
      final unitTwo = unitOne.copyWith(id: newFieldValue);
      // comparing any field
      expect(unitOne.id, model.id);
      expect(unitTwo.id, newFieldValue);
      expect(unitTwo.name, model.name);
      expect(unitTwo.totalOf, model.totalOf);
      expect(unitTwo.assetImage, model.assetImage);
      expect(unitTwo.backgroundColor, model.backgroundColor);
      // null assignment
      final unitThree = unitOne.copyWith(assetImage: null);
      expect(unitThree.assetImage, null);
    });

    test('toString()', () {
      expect(model.toString(), model.name);
    });

    test('operator =', () {
      // comparing objects after new Object()
      var newUnit = CategoryModel(
        id: '75fe6ef0-80b4-4ef0-9fb9-5f53d25ee166',
        name: 'Hamsters',
        totalOf: 56,
        assetImage: 'hamster.png',
        backgroundColor: _colorFromString('0xFFFCEBD3'),
      );
      expect(newUnit, model);
      // comparing objects after copyWith()
      newUnit = model.copyWith();
      expect(newUnit, model);
      // comparing objects after changing any field
      newUnit = model.copyWith(id: 'New id');
      expect(newUnit == model, isFalse);
      newUnit = model.copyWith(name: 'New name');
      expect(newUnit == model, isFalse);
      newUnit = model.copyWith(totalOf: 44);
      expect(newUnit == model, isFalse);
      newUnit = model.copyWith(assetImage: 'New assetImage');
      expect(newUnit == model, isFalse);
      newUnit = model.copyWith(backgroundColor: Colors.black);
      expect(newUnit == model, isFalse);
    });

    test('toJson()', () {
      final Map<String, dynamic> newJson = model.toJson();
      expect(newJson.toString(), modelJson.toString());
    });

    test('fromJson()', () {
      final newUnit = CategoryModel.fromJson(modelJson);
      expect(newUnit.id, model.id);
      expect(newUnit.name, model.name);
      expect(newUnit.totalOf, model.totalOf);
      expect(newUnit.assetImage, model.assetImage);
      expect(newUnit.backgroundColor, model.backgroundColor);
    });

    test('fromJson() nullable', () {
      final unitOne = CategoryModel(
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
      final unitTwo = CategoryModel.fromJson(json);
      expect(unitOne.totalOf == unitTwo.totalOf, isTrue);
      expect(unitOne, unitTwo);
    });
  });

  group('ConditionModel', () {
    // final String id;
    // final String name;
    // @JsonKey(fromJson: _colorFromString, toJson: _colorToString)
    // final Color textColor;
    // @JsonKey(fromJson: _colorFromString, toJson: _colorToString)
    // final Color backgroundColor;

    final model = _conditionSample;
    final modelJson = _conditionSampleJson;

    test('copyWith()', () {
      final unitOne = model.copyWith();
      const newFieldValue = 'New value';
      final unitTwo = unitOne.copyWith(id: newFieldValue);
      // comparing any field
      expect(unitOne.id, model.id);
      expect(unitTwo.id, newFieldValue);
      expect(unitTwo.name, model.name);
      expect(unitTwo.textColor, model.textColor);
      expect(unitTwo.backgroundColor, model.backgroundColor);
      // null assignment
      final unitThree = unitOne.copyWith(name: null);
      expect(unitThree.name, null);
    });

    test('toString()', () {
      expect(model.toString(), model.name);
    });

    test('operator =', () {
      // comparing objects after new Object()
      var newUnit = ConditionModel(
        id: '58d691e4-0e75-47ad-8a37-95dfa08ee639',
        name: 'Adoption',
        textColor: _colorFromString('0xFFE3B774'),
        backgroundColor: _colorFromString('0xFFFCEBD3'),
      );
      expect(newUnit, model);
      // comparing objects after copyWith()
      newUnit = model.copyWith();
      expect(newUnit, model);
      // comparing objects after changing any field
      newUnit = model.copyWith(id: 'New id');
      expect(newUnit == model, isFalse);
      newUnit = model.copyWith(name: 'New name');
      expect(newUnit == model, isFalse);
      newUnit = model.copyWith(textColor: Colors.green);
      expect(newUnit == model, isFalse);
      newUnit = model.copyWith(backgroundColor: Colors.yellow);
      expect(newUnit == model, isFalse);
    });

    test('toJson()', () {
      final Map<String, dynamic> newJson = model.toJson();
      expect(newJson.toString(), modelJson.toString());
    });

    test('fromJson()', () {
      final newUnit = ConditionModel.fromJson(modelJson);
      expect(newUnit.id, model.id);
      expect(newUnit.name, model.name);
      expect(newUnit.textColor, model.textColor);
      expect(newUnit.backgroundColor, model.backgroundColor);
    });
  });

  group('MemberModel', () {
    // final String id;
    // final String name;
    // final String photo;
    // final bool isActive;

    const model = _memberSample;
    final modelJson = _memberSampleJson;

    test('copyWith()', () {
      final unitOne = model.copyWith();
      const newFieldValue = 'New value';
      final unitTwo = unitOne.copyWith(id: newFieldValue);
      // comparing any field
      expect(unitOne.id, model.id);
      expect(unitTwo.id, newFieldValue);
      expect(unitTwo.name, model.name);
      expect(unitTwo.photo, model.photo);
      expect(unitTwo.isActive, model.isActive);
      // null assignment
      final unitThree = unitOne.copyWith(name: null);
      expect(unitThree.name, null);
    });

    test('operator =', () {
      // comparing objects after new Object()
      var newUnit = const MemberModel(
        id: '86a076ed-a761-402a-ae95-00c2d1ea5732',
        name: 'John Doe',
        photo:
            'https://lh3.googleusercontent.com/a-/AOh14Gh_kVNWSsdfsdfec9EvKgm751Pq5l4qTd_LK-Ydgag=s96-c',
        isActive: true,
      );
      expect(newUnit, model);
      // comparing objects after copyWith()
      newUnit = model.copyWith();
      expect(newUnit, model);
      // comparing objects after changing any field
      newUnit = model.copyWith(id: 'New id');
      expect(newUnit == model, isFalse);
      newUnit = model.copyWith(name: 'New name');
      expect(newUnit == model, isFalse);
      newUnit = model.copyWith(photo: 'New photo');
      expect(newUnit == model, isFalse);
      newUnit = model.copyWith(isActive: !model.isActive);
      expect(newUnit == model, isFalse);
    });

    test('toJson()', () {
      final Map<String, dynamic> newJson = model.toJson();
      expect(newJson.toString(), modelJson.toString());
    });

    test('fromJson()', () {
      final newUnit = MemberModel.fromJson(modelJson);
      expect(newUnit.id == model.id, isTrue);
      expect(newUnit.name == model.name, isTrue);
      expect(newUnit.photo == model.photo, isTrue);
      expect(newUnit.isActive == model.isActive, isTrue);
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
    // final String photos; // фото
    // final String description; // описание
    // final MemberModel member; // контактное лицо
    // final DateTime updatedAt; // дата обновления

    final model = _petSample;
    final modelJson = _petSampleJson;

    test('copyWith()', () {
      final unitOne = model.copyWith();
      const newFieldValue = 'New value';
      final unitTwo = unitOne.copyWith(id: newFieldValue);
      // comparing any field
      expect(unitOne.id, model.id);
      expect(unitTwo.id, newFieldValue);
      expect(unitTwo.category, model.category);
      expect(unitTwo.breed, model.breed);
      expect(unitTwo.age, model.age);
      expect(unitTwo.coloring, model.coloring);
      expect(unitTwo.weight, model.weight);
      expect(unitTwo.address, model.address);
      expect(unitTwo.distance, model.distance);
      expect(unitTwo.condition, model.condition);
      expect(unitTwo.liked, model.liked);
      expect(unitTwo.photos, model.photos);
      expect(unitTwo.description, model.description);
      expect(unitTwo.member, model.member);
      expect(unitTwo.updatedAt, model.updatedAt);
      // null assignment
      final unitThree = unitOne.copyWith(description: null);
      expect(unitThree.description, null);
    });

    test('operator =', () {
      // comparing objects after new Object()
      var newUnit = PetModel(
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
      expect(newUnit, model);
      // comparing objects after copyWith()
      newUnit = model.copyWith();
      expect(newUnit, model);
      // comparing objects after changing any field
      newUnit = model.copyWith(id: 'New id');
      expect(newUnit == model, isFalse);
      newUnit = model.copyWith(
          category: _categorySample.copyWith(name: 'New category name'));
      expect(newUnit == model, isFalse);
      newUnit =
          model.copyWith(breed: _breedSample.copyWith(name: 'New breed name'));
      expect(newUnit == model, isFalse);
      newUnit = model.copyWith(age: 'New age');
      expect(newUnit == model, isFalse);
      newUnit = model.copyWith(coloring: 'New coloring');
      expect(newUnit == model, isFalse);
      newUnit = model.copyWith(weight: 0.33);
      expect(newUnit == model, isFalse);
      newUnit = model.copyWith(address: 'New address');
      expect(newUnit == model, isFalse);
      newUnit = model.copyWith(distance: 4.44);
      expect(newUnit == model, isFalse);
      newUnit = model.copyWith(
          condition: _conditionSample.copyWith(name: 'New condition name'));
      expect(newUnit == model, isFalse);
      newUnit = model.copyWith(liked: !model.liked);
      expect(newUnit == model, isFalse);
      newUnit = model.copyWith(photos: 'New photos');
      expect(newUnit == model, isFalse);
      newUnit = model.copyWith(description: 'New description');
      expect(newUnit == model, isFalse);
      newUnit = model.copyWith(
          member: _memberSample.copyWith(name: 'New member name'));
      expect(newUnit == model, isFalse);
      newUnit = model.copyWith(updatedAt: DateTime.now());
      expect(newUnit == model, isFalse);
    });

    test('toJson()', () {
      final Map<String, dynamic> newJson = model.toJson();
      expect(newJson.toString(), modelJson.toString());
    });

    test('fromJson()', () {
      final newUnit = PetModel.fromJson(modelJson);
      expect(newUnit.id, model.id);
      expect(newUnit.category, model.category);
      expect(newUnit.breed, model.breed);
      expect(newUnit.age, model.age);
      expect(newUnit.coloring, model.coloring);
      expect(newUnit.weight, model.weight);
      expect(newUnit.address, model.address);
      expect(newUnit.distance, model.distance);
      expect(newUnit.condition, model.condition);
      expect(newUnit.liked, model.liked);
      expect(newUnit.photos, model.photos);
      expect(newUnit.description, model.description);
      expect(newUnit.member, model.member);
      expect(newUnit.updatedAt, model.updatedAt);
    });
  });

  group('SysParamModel', () {
    // final String label;
    // final String value;
    // final String valueTxt;
    // final String note;

    const model = _sysParamSample;
    final modelJson = _sysParamSampleJson;

    test('copyWith()', () {
      final unitOne = model.copyWith();
      const newFieldValue = 'New value';
      final unitTwo = unitOne.copyWith(label: newFieldValue);
      // comparing any field
      expect(unitOne.label, model.label);
      expect(unitTwo.label, newFieldValue);
      expect(unitTwo.value, model.value);
      expect(unitTwo.valueTxt, model.valueTxt);
      expect(unitTwo.note, model.note);
      // null assignment
      final unitThree = unitOne.copyWith(label: null);
      expect(unitThree.label, null);
    });

    test('operator =', () {
      // comparing objects after new Object()
      var newUnit = const SysParamModel(
        label: 'min_version',
        value: '42',
        valueTxt: '1.0.42',
        note: 'Minimum app version',
      );
      expect(newUnit, model);
      // comparing objects after copyWith()
      newUnit = model.copyWith();
      expect(newUnit, model);
      // comparing objects after changing any field
      newUnit = model.copyWith(label: 'New label');
      expect(newUnit == model, isFalse);
      newUnit = model.copyWith(value: 'New value');
      expect(newUnit == model, isFalse);
      newUnit = model.copyWith(valueTxt: 'New valueTxt');
      expect(newUnit == model, isFalse);
      newUnit = model.copyWith(note: 'New note');
      expect(newUnit == model, isFalse);
    });

    test('toJson()', () {
      final Map<String, dynamic> newJson = model.toJson();
      expect(newJson.toString(), modelJson.toString());
    });

    test('fromJson()', () {
      final newUnit = SysParamModel.fromJson(modelJson);
      expect(newUnit.label, model.label);
      expect(newUnit.value, model.value);
      expect(newUnit.valueTxt, model.valueTxt);
      expect(newUnit.note, model.note);
    });
  });

  group('UserModel', () {
    // final String id;
    // final String name;
    // final String photo;
    // final String email;
    // final String phone;
    // final bool  isActive;

    const model = _userModelSample;
    final modelJson = _userModelSampleJson;

    test('copyWith()', () {
      final unitOne = model.copyWith();
      const newFieldValue = 'New value';
      final unitTwo = unitOne.copyWith(id: newFieldValue);
      // comparing any field
      expect(unitOne.id, model.id);
      expect(unitTwo.id, newFieldValue);
      expect(unitTwo.name, model.name);
      expect(unitTwo.photo, model.photo);
      expect(unitTwo.email, model.email);
      expect(unitTwo.phone, model.phone);
      expect(unitTwo.isActive, model.isActive);
      // null assignment
      final unitThree = unitOne.copyWith(id: null);
      expect(unitThree.id, null);
    });

    test('operator =', () {
      // comparing objects after new Object()
      var newUnit = const UserModel(
        id: '86a076ed-a761-402a-ae95-00c2d1ea5732',
        name: 'Jon Doe',
        photo: 'https://lh3.googleusercontent.com',
        email: 'Jon_Doe@gmail.com',
        phone: '911',
        isActive: true,
      );
      expect(newUnit, model);
      // comparing objects after copyWith()
      newUnit = model.copyWith();
      expect(newUnit, model);
      // comparing objects after changing any field
      newUnit = model.copyWith(id: 'New id');
      expect(newUnit == model, isFalse);
      newUnit = model.copyWith(name: 'New name');
      expect(newUnit == model, isFalse);
      newUnit = model.copyWith(photo: 'New photo');
      expect(newUnit == model, isFalse);
      newUnit = model.copyWith(email: 'New email');
      expect(newUnit == model, isFalse);
      newUnit = model.copyWith(phone: 'New phone');
      expect(newUnit == model, isFalse);
      newUnit = model.copyWith(isActive: !model.isActive);
      expect(newUnit == model, isFalse);
    });

    test('toJson()', () {
      final Map<String, dynamic> newJson = model.toJson();
      expect(newJson.toString(), modelJson.toString());
    });

    test('fromJson()', () {
      final newUnit = UserModel.fromJson(modelJson);
      expect(newUnit.id, model.id);
      expect(newUnit.name, model.name);
      expect(newUnit.photo, model.photo);
      expect(newUnit.email, model.email);
      expect(newUnit.phone, model.phone);
      expect(newUnit.isActive, model.isActive);
    });
  });

  group('VetModel', () {
    // final String id; // id
    // final String name; // наименование
    // final String phone; // телефон
    // final String timetable; // режим работы
    // @JsonKey(nullable: true)
    // final bool isOpenNow; // сейчас открыто
    // final String logoImage; // логотип

    const model = _vetModelSample;
    final modelJson = _vetModelSampleJson;

    test('copyWith()', () {
      final unitOne = model.copyWith();
      const newFieldValue = 'New value';
      final unitTwo = unitOne.copyWith(id: newFieldValue);
      // comparing any field
      expect(unitOne.id, model.id);
      expect(unitTwo.id, newFieldValue);
      expect(unitTwo.name, model.name);
      expect(unitTwo.phone, model.phone);
      expect(unitTwo.timetable, model.timetable);
      expect(unitTwo.isOpenNow, model.isOpenNow);
      expect(unitTwo.logoImage, model.logoImage);
      final unitThree = unitOne.copyWith(id: null);
      expect(unitThree.id, null);
    });

    test('operator =', () {
      // comparing objects after new Object()
      var newUnit = const VetModel(
        id: '5b08256a-0da0-4bc5-a5f3-bb8bb2207e25',
        name: 'РИмонт ЖЫвотных',
        phone: '(8634) 222-333',
        timetable: 'TOMORROW AT 8:00',
        isOpenNow: true,
        logoImage: 'http://animalservice.ru',
      );
      expect(newUnit, model);
      // comparing objects after copyWith()
      newUnit = model.copyWith();
      expect(newUnit, model);
      // comparing objects after changing any field
      newUnit = model.copyWith(id: 'New id');
      expect(newUnit == model, isFalse);
      newUnit = model.copyWith(name: 'New name');
      expect(newUnit == model, isFalse);
      newUnit = model.copyWith(phone: 'New phone');
      expect(newUnit == model, isFalse);
      newUnit = model.copyWith(timetable: 'New timetable');
      expect(newUnit == model, isFalse);
      newUnit = model.copyWith(isOpenNow: !model.isOpenNow);
      expect(newUnit == model, isFalse);
      newUnit = model.copyWith(logoImage: 'New logoImage');
      expect(newUnit == model, isFalse);
    });

    test('toJson()', () {
      final Map<String, dynamic> newJson = model.toJson();
      expect(newJson.toString(), modelJson.toString());
    });

    test('fromJson()', () {
      final newUnit = VetModel.fromJson(modelJson);
      expect(newUnit.id, model.id);
      expect(newUnit.name, model.name);
      expect(newUnit.phone, model.phone);
      expect(newUnit.timetable, model.timetable);
      expect(newUnit.isOpenNow, model.isOpenNow);
      expect(newUnit.logoImage, model.logoImage);
    });
  });
}
