import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'vet.freezed.dart';
part 'vet.g.dart';

@freezed
abstract class VetModel with _$VetModel {
  const factory VetModel({
    String id, // id
    String name, // наименование
    String phone, // телефон
    String timetable, // режим работы
    @JsonKey(nullable: true)
    bool isOpenNow, // сейчас открыто
    String logoImage, // логотип
  }) = _VetModel;

  factory VetModel.fromJson(Map<String, dynamic> json) =>
      _$VetModelFromJson(json);
}
