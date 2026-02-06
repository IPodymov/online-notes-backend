import 'package:mongo_dart/mongo_dart.dart';

abstract class DbMigration {
  Future<void> up(Db db);
}
