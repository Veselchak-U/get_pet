import 'package:flutter/material.dart';

// Контактное лицо питомца
class Contact {
  Contact({
    @required this.name,
    this.photo,
    this.email,
    this.phone,
  });

  final String name;
  final String photo;
  final String email;
  final String phone;

  Contact.fromJson(Map<String, dynamic> json)
      : name = json['name'] as String,
        photo = json['photo'] as String,
        email = json['email'] as String,
        phone = json['phone'] as String;

  Map<String, dynamic> toJson() => {
        'name': name,
        'photo': photo,
        'email': email,
        'phone': phone,
      };
}
