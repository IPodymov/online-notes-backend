// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Note _$NoteFromJson(Map<String, dynamic> json) => Note(
      id: json['id'] as String,
      content: json['content'] as String,
      senderId: json['senderId'] as String,
      receiverId: json['receiverId'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      isRead: json['isRead'] as bool? ?? false,
    );

Map<String, dynamic> _$NoteToJson(Note instance) => <String, dynamic>{
      'id': instance.id,
      'content': instance.content,
      'senderId': instance.senderId,
      'receiverId': instance.receiverId,
      'createdAt': instance.createdAt.toIso8601String(),
      'isRead': instance.isRead,
    };
