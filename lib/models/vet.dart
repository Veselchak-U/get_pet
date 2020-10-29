// Ветеринарная клиника
class Vet {
  Vet({
    this.name,
    this.phone,
    this.timetable,
    this.isOpenNow,
    this.logo,
  });

  final String name; // наименование
  final String phone; // телефон
  final String timetable; // режим работы
  final bool isOpenNow; // сейчас открыто
  final String logo; // логотип
}
