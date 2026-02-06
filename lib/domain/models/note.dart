import 'package:json_annotation/json_annotation.dart';

part 'note.g.dart';

@JsonSerializable()
class Note {
  final String id;
  final String content;
  final String senderId;
  final String receiverId;
  final DateTime createdAt;
  final bool isRead;

  Note({
    required this.id,
    required this.content,
    required this.senderId,
    required this.receiverId,
    required this.createdAt,
    this.isRead = false,
  });

  factory Note.fromJson(Map<String, dynamic> json) => _$NoteFromJson(json);
  Map<String, dynamic> toJson() => _$NoteToJson(this);
}
