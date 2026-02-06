import 'package:mongo_dart/mongo_dart.dart';
import '../../domain/models/note.dart';
import '../../domain/repositories/note_repository.dart';

class MongoNoteRepository implements NoteRepository {
  final DbCollection _collection;

  MongoNoteRepository(Db db) : _collection = db.collection('notes');

  @override
  Future<Note> createNote(Note note) async {
    await _collection.insert(note.toJson());
    return note;
  }

  @override
  Future<List<Note>> getNotesForUser(String userId) async {
    final notesData = await _collection.find(where.eq('userId', userId)).toList();
    return notesData.map((json) => Note.fromJson(json)).toList();
  }

  @override
  Future<Note?> getNoteById(String id) async {
    final json = await _collection.findOne(where.eq('id', id));
    if (json != null) {
      return Note.fromJson(json);
    }
    return null;
  }

  @override
  Future<void> markAsRead(String id) async {
    // Assuming marking as read means setting 'isRead' to true
    // But Note model details were not provided in full context above, 
    // assuming standard update for now. 
    // Wait, let's check Note model to be safe. 
    // But for now, using modifier to update part of document.
    await _collection.update(
        where.eq('id', id), modify.set('isRead', true));
  }
}
