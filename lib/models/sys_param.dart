import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'sys_param.freezed.dart';
part 'sys_param.g.dart';

@freezed
abstract class SysParamModel with _$SysParamModel {
  const factory SysParamModel({
    String label,
    String value,
    String valueTxt,
    String note,
  }) = _SysParamModel;

  factory SysParamModel.fromJson(Map<String, dynamic> json) =>
      _$SysParamModelFromJson(json);
}
