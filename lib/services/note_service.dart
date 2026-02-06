import 'package:uuid/uuid.dart';
import '../domain/models/note.dart';
import '../domain/repositories/note_repository.dart';

class NoteService {
  final NoteRepository _noteRepository;
  final Uuid _uuid = Uuid();

  NoteService(this._noteRepository);

  Future<Note> sendNote(String content, String senderId, String receiverId) async {
    final note = Note(
      id: _uuid.v4(),
      content: content,
      senderId: senderId,
      receiverId: receiverId,
      createdAt: DateTime.now(),
    );
    return await _noteRepository.createNote(note);
  }

  Future<List<Note>> getUserNotes(String userId) {
    return _noteRepository.getNotesForUser(userId);
  }

  Future<void> readNote(String id) {
    return _noteRepository.markAsRead(id);
  }
}
