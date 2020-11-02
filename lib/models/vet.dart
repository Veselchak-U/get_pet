// Ветеринарная клиника
class Vet {
  Vet({
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

  Vet.fromJson(Map<String, dynamic> json)
      : id = json['id'] as String,
        name = json['name'] as String,
        phone = json['phone'] as String,
        timetable = json['timetable'] as String,
        isOpenNow = json['isOpenNow'] as bool,
        logo = json['logo'] as String;

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'phone': phone,
        'timetable': timetable,
        'isOpenNow': isOpenNow,
        'logo': logo,
      };
}
