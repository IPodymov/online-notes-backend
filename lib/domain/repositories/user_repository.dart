import '../models/user.dart';

abstract class UserRepository {
  Future<List<User>> getAllUsers();
  Future<User?> getUserById(String id);
  Future<User?> getUserByUsername(String username);
  Future<User> createUser(User user);
  Future<User> updateUser(User user);
}
