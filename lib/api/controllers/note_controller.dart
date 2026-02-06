import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import '../../services/note_service.dart';
import '../../utils/json_utils.dart';

class NoteController {
  final NoteService _noteService;

  NoteController(this._noteService);

  Router get router {
    final router = Router();
    router.post('/', _createNote);
    router.get('/user/<userId>', _getUserNotes);
    router.put('/<id>/read', _markAsRead);
    return router;
  }

  Future<Response> _createNote(Request request) async {
    try {
      final payload = jsonDecode(await request.readAsString());
      final content = payload['content'] as String;
      final senderId = payload['senderId'] as String;
      final receiverId = payload['receiverId'] as String;

      final note = await _noteService.sendNote(content, senderId, receiverId);
      return jsonResponse(note.toJson(), statusCode: 201);
    } catch (e) {
      return errorResponse('Invalid request: $e');
    }
  }

  Future<Response> _getUserNotes(Request request, String userId) async {
    final notes = await _noteService.getUserNotes(userId);
    return jsonResponse(notes.map((n) => n.toJson()).toList());
  }

  Future<Response> _markAsRead(Request request, String id) async {
    await _noteService.readNote(id);
    return jsonResponse({'message': 'Note marked as read'});
  }
}
