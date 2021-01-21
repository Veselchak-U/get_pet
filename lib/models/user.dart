import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

@freezed
abstract class UserModel with _$UserModel {
  const factory UserModel({
    String id,
    String name,
    String photo,
    String email,
    String phone,
    bool isActive,
  }) = _UserModel;

  // ignore: sort_constructors_first
  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  // Empty user which represents an unauthenticated user.
  static const empty = UserModel(
    id: '',
  );
}
