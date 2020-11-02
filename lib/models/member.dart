// Пользователь
class Member {
  Member({
    this.id,
    this.name,
    this.photo,
    this.email,
    this.phone,
  });

  final String id;
  final String name;
  final String photo;
  final String email;
  final String phone;

  Member.fromJson(Map<String, dynamic> json)
      : id = json['id'] as String,
        name = json['name'] as String,
        photo = json['photo'] as String,
        email = json['email'] as String,
        phone = json['phone'] as String;

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'photo': photo,
        'email': email,
        'phone': phone,
      };
}
