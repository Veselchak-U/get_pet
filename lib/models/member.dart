import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'member.freezed.dart';
part 'member.g.dart';

@freezed
abstract class MemberModel with _$MemberModel {
  const factory MemberModel({
    String id,
    String name,
    String photo,
    bool isActive,
  }) = _MemberModel;

  factory MemberModel.fromJson(Map<String, dynamic> json) =>
      _$MemberModelFromJson(json);
}
