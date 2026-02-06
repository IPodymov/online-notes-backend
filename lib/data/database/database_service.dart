import 'package:mongo_dart/mongo_dart.dart';
import 'package:logging/logging.dart';
import '../migrations/db_migration.dart';
import '../migrations/user_migration.dart';
import '../migrations/note_migration.dart';
import '../migrations/invitation_migration.dart';

class DatabaseService {
  final Db _db;
  final Logger _logger = Logger('DatabaseService');

  DatabaseService(String connectionString) : _db = Db(connectionString);

  Db get db => _db;

  Future<void> connect() async {
    try {
      await _db.open();
      _logger.info('Connected to MongoDB');
      await _migrate();
    } catch (e) {
      _logger.severe('Failed to connect to MongoDB', e);
      rethrow;
    }
  }

  Future<void> close() async {
    await _db.close();
    _logger.info('Disconnected from MongoDB');
  }

  Future<void> _migrate() async {
    _logger.info('Starting auto-migration (ensuring indexes)...');

    final migrations = <DbMigration>[
      UserMigration(),
      InvitationMigration(),
      NoteMigration(),
    ];

    for (final migration in migrations) {
      await migration.up(_db);
    }

    _logger.info('Auto-migration completed.');
  }
}
