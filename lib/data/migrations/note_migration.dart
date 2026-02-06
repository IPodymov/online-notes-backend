import 'package:logging/logging.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'db_migration.dart';

class NoteMigration implements DbMigration {
  final Logger _logger = Logger('NoteMigration');

  @override
  Future<void> up(Db db) async {
    final notes = db.collection('notes');
    await notes.createIndex(key: 'userId');
    _logger.info('Ensured index: notes.userId');
  }
}
