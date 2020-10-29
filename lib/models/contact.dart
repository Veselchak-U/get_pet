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
}
