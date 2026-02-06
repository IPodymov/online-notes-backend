import 'package:uuid/uuid.dart';
import '../domain/models/user.dart';
import '../domain/repositories/user_repository.dart';

class UserService {
  final UserRepository _userRepository;
  final Uuid _uuid = Uuid();

  UserService(this._userRepository);

  Future<User> registerUser(String username, String password, String name, UserRole role) async {
    final existingUser = await _userRepository.getUserByUsername(username);
    if (existingUser != null) {
      throw Exception('User with username $username already exists');
    }
    final user = User(
      id: _uuid.v4(),
      username: username,
      password: password, // In a real app, hash this!
      name: name,
      role: role,
    );
    return await _userRepository.createUser(user);
  }

  Future<User?> loginUser(String username, String password) async {
    final user = await _userRepository.getUserByUsername(username);
    if (user != null && user.password == password) {
      return user;
    }
    return null;
  }

  Future<List<User>> getAllUsers() {
    return _userRepository.getAllUsers();
  }

  Future<User?> getUser(String id) {
    return _userRepository.getUserById(id);
  }
}
