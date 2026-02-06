import '../models/note.dart';

abstract class NoteRepository {
  Future<Note> createNote(Note note);
  Future<List<Note>> getNotesForUser(String userId);
  Future<Note?> getNoteById(String id);
  Future<void> markAsRead(String id);
}
