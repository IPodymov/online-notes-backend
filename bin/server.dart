import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:dotenv/dotenv.dart'; // Add dotenv
import 'package:mongo_dart/mongo_dart.dart'; // Add mongo_dart
import 'package:shelf_cors_headers/shelf_cors_headers.dart'; // Add shelf_cors_headers
import 'package:logging/logging.dart'; // Add logging

import 'package:electronic_document_management_backend/data/database/database_service.dart';
import 'package:electronic_document_management_backend/data/repositories/in_memory_user_repository.dart';
import 'package:electronic_document_management_backend/data/repositories/mongo_user_repository.dart';
import 'package:electronic_document_management_backend/data/repositories/in_memory_note_repository.dart';
import 'package:electronic_document_management_backend/data/repositories/mongo_note_repository.dart';
import 'package:electronic_document_management_backend/data/repositories/in_memory_invitation_repository.dart';
import 'package:electronic_document_management_backend/data/repositories/mongo_invitation_repository.dart';

import 'package:electronic_document_management_backend/domain/repositories/user_repository.dart';
import 'package:electronic_document_management_backend/domain/repositories/note_repository.dart';
import 'package:electronic_document_management_backend/domain/repositories/invitation_repository.dart';

import 'package:electronic_document_management_backend/services/user_service.dart';
import 'package:electronic_document_management_backend/services/note_service.dart';
import 'package:electronic_document_management_backend/services/auth_service.dart';
import 'package:electronic_document_management_backend/services/invitation_service.dart';
import 'package:electronic_document_management_backend/api/controllers/user_controller.dart';
import 'package:electronic_document_management_backend/api/controllers/note_controller.dart';

void main(List<String> args) async {
  // 0. Setup Logger
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    print('${record.level.name}: ${record.time}: ${record.message}');
    if (record.error != null) {
      print('Error: ${record.error}');
      if (record.stackTrace != null) {
        print('Stacktrace: \n${record.stackTrace}');
      }
    }
  });

  final log = Logger('Server');
  log.info('Starting server...');

  // Load environment variables
  var env = DotEnv(includePlatformEnvironment: true)..load();

  // Connect to MongoDB
  final mongoUrl = env['MONGO_URL'];
  Db? db;
  DatabaseService? dbService;

  if (mongoUrl == null) {
    log.warning('MONGO_URL not found in .env. Using In-Memory repositories.');
  } else {
    try {
      dbService = DatabaseService(mongoUrl);
      await dbService.connect();
      db = dbService.db;
    } catch (e) {
      log.severe('Failed to initialize database', e);
      // Fallback or exit? For now, we'll exit if DB failure to avoid data inconsistency if expected.
      // But if we want fallback, we can just proceed with db = null.
      // Let's decide to fall back to in-memory for dev, but logging error is key.
      log.info('Falling back to In-Memory repositories due to DB error.');
    }
  }

  // 1. Initialize Data Layer
  UserRepository userRepository;
  NoteRepository noteRepository;
  InvitationRepository invitationRepository;

  if (db != null && db.state == State.OPEN) {
    log.info('Using MongoDB repositories');
    userRepository = MongoUserRepository(db);
    noteRepository = MongoNoteRepository(db);
    invitationRepository = MongoInvitationRepository(db);
  } else {
    log.info('Using In-Memory repositories');
    userRepository = InMemoryUserRepository();
    noteRepository = InMemoryNoteRepository();
    invitationRepository = InMemoryInvitationRepository();
  }

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
  log.info('Server listening on port ${server.port}');
}
