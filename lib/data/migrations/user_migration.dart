import 'package:logging/logging.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'db_migration.dart';

class UserMigration implements DbMigration {
  final Logger _logger = Logger('UserMigration');

  @override
  Future<void> up(Db db) async {
    final users = db.collection('users');
    await users.createIndex(key: 'username', unique: true);
    _logger.info('Ensured index: users.username (unique)');
  }
}
