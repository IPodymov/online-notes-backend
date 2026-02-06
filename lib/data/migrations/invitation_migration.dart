import 'package:logging/logging.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'db_migration.dart';

class InvitationMigration implements DbMigration {
  final Logger _logger = Logger('InvitationMigration');

  @override
  Future<void> up(Db db) async {
    final invites = db.collection('invitations');
    await invites.createIndex(key: 'token', unique: true);
    _logger.info('Ensured index: invitations.token (unique)');
  }
}
