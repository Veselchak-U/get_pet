import 'package:json_annotation/json_annotation.dart';

part 'member.g.dart';

@JsonSerializable()
class MemberModel {
  MemberModel({
    this.id,
    this.name,
    this.photo,
    // this.email,
    // this.phone,
    this.isActive,
  });

  final String id;
  final String name;
  final String photo;
  // final String email;
  // final String phone;
  final bool isActive;

  factory MemberModel.fromJson(Map<String, dynamic> json) =>
      _$MemberModelFromJson(json);

  Map<String, dynamic> toJson() => _$MemberModelToJson(this);
}
