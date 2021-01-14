import 'package:json_annotation/json_annotation.dart';

part 'sys_param.g.dart';

@JsonSerializable()
class SysParamModel {
  SysParamModel({
    this.label,
    this.value,
    this.valueTxt,
    this.note,
  });

  final String label;
  final String value;
  final String valueTxt;
  final String note;


  // ignore: sort_constructors_first
  factory SysParamModel.fromJson(Map<String, dynamic> json) =>
      _$SysParamModelFromJson(json);

  Map<String, dynamic> toJson() => _$SysParamModelToJson(this);
}
