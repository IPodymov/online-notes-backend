// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      id: json['id'] as String,
      username: json['username'] as String,
      password: json['password'] as String,
      name: json['name'] as String,
      role: $enumDecode(_$UserRoleEnumMap, json['role']),
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'password': instance.password,
      'name': instance.name,
      'role': _$UserRoleEnumMap[instance.role]!,
    };

const _$UserRoleEnumMap = {
  UserRole.admin: 'admin',
  UserRole.parent: 'parent',
  UserRole.classTeacher: 'classTeacher',
  UserRole.schoolAdmin: 'schoolAdmin',
  UserRole.student: 'student',
};
