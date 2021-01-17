import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'member.g.dart';

@CopyWith()
@JsonSerializable()
class MemberModel {
  MemberModel({
    this.id,
    this.name,
    this.photo,
    this.isActive,
  });

  final String id;
  final String name;
  final String photo;
  final bool isActive;

  // ignore: sort_constructors_first
  factory MemberModel.fromJson(Map<String, dynamic> json) =>
      _$MemberModelFromJson(json);

  Map<String, dynamic> toJson() => _$MemberModelToJson(this);
}
