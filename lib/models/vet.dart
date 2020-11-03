import 'package:json_annotation/json_annotation.dart';

part 'vet.g.dart';

@JsonSerializable()
class VetModel {
  VetModel({
    this.id,
    this.name,
    this.phone,
    this.timetable,
    this.isOpenNow,
    this.logo,
  });

  final String id; // id
  final String name; // наименование
  final String phone; // телефон
  final String timetable; // режим работы
  final bool isOpenNow; // сейчас открыто
  final String logo; // логотип

  factory VetModel.fromJson(Map<String, dynamic> json) =>
      _$VetModelFromJson(json);

  Map<String, dynamic> toJson() => _$VetModelToJson(this);
}
