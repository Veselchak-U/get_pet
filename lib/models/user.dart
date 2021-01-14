import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
@CopyWith()
class UserModel extends Equatable {
  const UserModel({
    this.id,
    this.name,
    this.photo,
    this.email,
    this.phone,
    this.isActive,
  });

  final String id;
  final String name;
  final String photo;
  final String email;
  final String phone;
  final bool isActive;

  // Empty user which represents an unauthenticated user.
  static const empty = UserModel(
    id: '',
  );

  // ignore: sort_constructors_first
  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  @override
  List<Object> get props => [
        id,
        name,
        photo,
        email,
        phone,
        isActive,
      ];
}
