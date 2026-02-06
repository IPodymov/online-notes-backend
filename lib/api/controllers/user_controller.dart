import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import '../../domain/models/user.dart';
import '../../services/user_service.dart';
import '../../services/auth_service.dart';
import '../../utils/json_utils.dart';

class UserController {
  final UserService _userService;
  final AuthService _authService;

  UserController(this._userService, this._authService);

  Router get router {
    final router = Router();
    router.post('/register', _registerUser);
    router.post('/login', _loginUser);
    router.get('/', _getAllUsers);
    router.get('/<id>', _getUser);
    return router;
  }

  Future<Response> _registerUser(Request request) async {
    try {
      final payload = jsonDecode(await request.readAsString());
      final username = payload['username'] as String;
      final password = payload['password'] as String;
      final name = payload['name'] as String;
      final roleStr = payload['role'] as String;

      final role = UserRole.values.firstWhere(
        (e) => e.name == roleStr,
        orElse: () => UserRole.student,
      );

      final user =
          await _userService.registerUser(username, password, name, role);
      // Don't return password
      final userJson = user.toJson()..remove('password');
      return jsonResponse(userJson, statusCode: 201);
    } catch (e) {
      return errorResponse('Registration failed: $e');
    }
  }

  Future<Response> _loginUser(Request request) async {
    try {
      final payload = jsonDecode(await request.readAsString());
      final username = payload['username'] as String;
      final password = payload['password'] as String;

      final user = await _userService.loginUser(username, password);
      if (user != null) {
        // In a real app, return a JWT token here
        final userJson = user.toJson()..remove('password');
        return jsonResponse({'message': 'Login successful', 'user': userJson});
      }
      return errorResponse('Invalid credentials', statusCode: 401);
    } catch (e) {
      return errorResponse('Login failed: $e');
    }
  }

  Future<Response> _getAllUsers(Request request) async {
    // Check authorization manually for now (simplest way without middleware context injection yet)
    // In real app, user is in request.context from middleware

    // Simulate getting user from context or header for demonstration
    // For now we just return all users, but let's assume this requires ADMIN role for demo purposes if we had auth middleware
    // We can't easily check auth here without the user object from the request context.

    final users = await _userService.getAllUsers();
    return jsonResponse(
        users.map((u) => u.toJson()..remove('password')).toList());
  }

  Future<Response> _getUser(Request request, String id) async {
    final user = await _userService.getUser(id);
    if (user != null) {
      return jsonResponse(user.toJson()..remove('password'));
    }
    return errorResponse('User not found', statusCode: 404);
  }
}
