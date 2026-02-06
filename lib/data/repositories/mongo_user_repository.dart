import 'package:mongo_dart/mongo_dart.dart';
import '../../domain/models/user.dart';
import '../../domain/repositories/user_repository.dart';

class MongoUserRepository implements UserRepository {
  final DbCollection _collection;

  MongoUserRepository(Db db) : _collection = db.collection('users');

  @override
  Future<User> createUser(User user) async {
    await _collection.insert(user.toJson());
    return user;
  }

  @override
  Future<List<User>> getAllUsers() async {
    final usersData = await _collection.find().toList();
    return usersData.map((json) => User.fromJson(json)).toList();
  }

  @override
  Future<User?> getUserById(String id) async {
    final json = await _collection.findOne(where.eq('id', id));
    if (json != null) {
      return User.fromJson(json);
    }
    return null;
  }

  @override
  Future<User?> getUserByUsername(String username) async {
    final json = await _collection.findOne(where.eq('username', username));
    if (json != null) {
      return User.fromJson(json);
    }
    return null;
  }

  @override
  Future<User> updateUser(User user) async {
    final result = await _collection.replaceOne(
      where.eq('id', user.id),
      user.toJson(),
    );
    if (result.isSuccess && result.nMatched > 0) {
      return user;
    }
    throw Exception('User not found or update failed');
  }
}
