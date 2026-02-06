import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

enum UserRole {
  admin, // Системный администратор
  parent, // Родители
  classTeacher, // Классные руководители
  schoolAdmin, // Администрация школы
  student // Ученик (оставим для совместимости, если нужно)
}

@JsonSerializable()
class User {
  final String id;
  final String username;
  final String password; // В реальном проекте здесь должен быть хэш
  final String name;
  final UserRole role;

  User({
    required this.id,
    required this.username,
    required this.password,
    required this.name,
    required this.role,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}
