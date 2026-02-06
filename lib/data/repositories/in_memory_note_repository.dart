import '../../domain/models/note.dart';
import '../../domain/repositories/note_repository.dart';

class InMemoryNoteRepository implements NoteRepository {
  final List<Note> _notes = [];

  @override
  Future<Note> createNote(Note note) async {
    _notes.add(note);
    return note;
  }

  @override
  Future<Note?> getNoteById(String id) async {
    try {
      return _notes.firstWhere((note) => note.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<List<Note>> getNotesForUser(String userId) async {
    return _notes
        .where((note) => note.receiverId == userId || note.senderId == userId)
        .toList();
  }

  @override
  Future<void> markAsRead(String id) async {
    final index = _notes.indexWhere((note) => note.id == id);
    if (index != -1) {
      final oldNote = _notes[index];
      _notes[index] = Note(
        id: oldNote.id,
        content: oldNote.content,
        senderId: oldNote.senderId,
        receiverId: oldNote.receiverId,
        createdAt: oldNote.createdAt,
        isRead: true,
      );
    }
  }
}
