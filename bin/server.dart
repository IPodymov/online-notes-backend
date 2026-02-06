import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:dotenv/dotenv.dart'; // Add dotenv
import 'package:mongo_dart/mongo_dart.dart'; // Add mongo_dart
import 'package:shelf_cors_headers/shelf_cors_headers.dart'; // Add shelf_cors_headers
import 'package:electronic_document_management_backend/data/repositories/in_memory_user_repository.dart';
import 'package:electronic_document_management_backend/data/repositories/in_memory_note_repository.dart';
import 'package:electronic_document_management_backend/data/repositories/in_memory_invitation_repository.dart';
import 'package:electronic_document_management_backend/services/user_service.dart';
import 'package:electronic_document_management_backend/services/note_service.dart';
import 'package:electronic_document_management_backend/services/auth_service.dart';
import 'package:electronic_document_management_backend/services/invitation_service.dart';
import 'package:electronic_document_management_backend/api/controllers/user_controller.dart';
import 'package:electronic_document_management_backend/api/controllers/note_controller.dart';

void main(List<String> args) async {
  // Load environment variables
  var env = DotEnv(includePlatformEnvironment: true)..load();

  // Connect to MongoDB
  final mongoUrl = env['MONGO_URL'];
  if (mongoUrl == null) {
    print('Warning: MONGO_URL not found in .env');
  } else {
    try {
      final db = await Db.create(mongoUrl);
      await db.open();
      print('Connected to MongoDB');
    } catch (e) {
      print('Failed to connect to MongoDB: $e');
    }
  }

  // 1. Initialize Data Layer
  final userRepository = InMemoryUserRepository();
  final noteRepository = InMemoryNoteRepository();
  final invitationRepository = InMemoryInvitationRepository();

  // 2. Initialize Service Layer
  final userService = UserService(userRepository);
  final noteService = NoteService(noteRepository);
  final authService = AuthService();
  final invitationService = InvitationService(invitationRepository);

  // 3. Initialize API Layer (Controllers)
  final userController =
      UserController(userService, authService, invitationService);
  final noteController = NoteController(noteService);

  // Define routes
  final router = Router();
  // Mount user routes
  router.mount('/users/', userController.router);
  router.mount(
      '/auth/',
      userController
          .router); // Alias for auth endpoints like login/register if needed
  router.mount('/notes/', noteController.router);

  // Configure Pipeline
  final handler = Pipeline()
      .addMiddleware(corsHeaders()) // Add CORS middleware
      .addMiddleware(logRequests())
      .addHandler(router);

  // Start Server
  final ip = InternetAddress.anyIPv4;
  final port = int.parse(env['PORT'] ?? '8080'); // Use port from env
  final server = await serve(handler, ip, port);
  print('Server listening on port ${server.port}');
}
