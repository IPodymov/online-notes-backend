import '../../domain/models/user.dart';
import '../../domain/repositories/user_repository.dart';

class InMemoryUserRepository implements UserRepository {
  final List<User> _users = [];

  @override
  Future<User> createUser(User user) async {
    _users.add(user);
    return user;
  }

  @override
  Future<List<User>> getAllUsers() async {
    return _users;
  }

  @override
  Future<User?> getUserById(String id) async {
    try {
      return _users.firstWhere((user) => user.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<User?> getUserByUsername(String username) async {
    try {
      return _users.firstWhere((user) => user.username == username);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<User> updateUser(User user) async {
    final index = _users.indexWhere((u) => u.id == user.id);
    if (index != -1) {
      _users[index] = user;
      return user;
    }
    throw Exception('User not found');
  }
}
