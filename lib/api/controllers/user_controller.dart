import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import '../../domain/models/user.dart';
import '../../services/user_service.dart';
import '../../services/auth_service.dart';
import '../../services/invitation_service.dart';
import '../../utils/json_utils.dart';

class UserController {
  final UserService _userService;
  final AuthService _authService;
  final InvitationService _invitationService;

  UserController(this._userService, this._authService, this._invitationService);

  Router get router {
    final router = Router();
    router.post('/register', _registerUser);
    router.post('/login', _loginUser);
    router.post('/invite', _createInvite);
    router.get('/', _getAllUsers);
    router.patch('/<id>/role', _updateUserRole);
    router.get('/<id>', _getUser);
    return router;
  }

  Future<Response> _updateUserRole(Request request, String id) async {
    try {
      final payload = jsonDecode(await request.readAsString());
      final newRoleStr = payload['role'] as String;
      final senderRoleStr = payload['senderRole'] as String?;

      final senderRole = UserRole.values.firstWhere(
        (e) => e.name == senderRoleStr,
        orElse: () => UserRole.student,
      );

      // Check permissions: Admin, SchoolAdmin, Teacher can change roles?
      // "role can be changed by admin, school admin and teacher"
      if (!_invitationService.canCreateInvitation(senderRole)) {
        return errorResponse('Permission denied', statusCode: 403);
      }

      final newRole = UserRole.values.firstWhere(
        (e) => e.name == newRoleStr,
        orElse: () => UserRole.student,
      );

      final updatedUser = await _userService.updateUserRole(id, newRole);
      return jsonResponse(updatedUser.toJson()..remove('password'));
    } catch (e) {
      return errorResponse('Failed to update user role: $e');
    }
  }

  Future<Response> _createInvite(Request request) async {
    try {
      final payload = jsonDecode(await request.readAsString());
      final roleStr = payload['role'] as String;
      // For demo purposes, we accept senderRole in the body to simulate auth check
      final senderRoleStr = payload['senderRole'] as String?;
      final senderRole = UserRole.values.firstWhere(
        (e) => e.name == senderRoleStr,
        orElse: () => UserRole.student,
      );

      if (!_invitationService.canCreateInvitation(senderRole)) {
        return errorResponse('Permission denied', statusCode: 403);
      }

      final targetRole = UserRole.values.firstWhere(
        (e) => e.name == roleStr,
        orElse: () => UserRole.student,
      );

      final invitation = await _invitationService.createInvitation(targetRole);
      // Construct a link in a real app, here we return the token/object
      final responseMap = invitation.toJson();
      responseMap['link'] =
          'http://localhost:8080/users/register?inviteToken=${invitation.token}'; // Example link
      return jsonResponse(responseMap, statusCode: 201);
    } catch (e) {
      return errorResponse('Failed to create invitation: $e');
    }
  }

  Future<Response> _registerUser(Request request) async {
    try {
      final payload = jsonDecode(await request.readAsString());
      final username = payload['username'] as String;
      final password = payload['password'] as String;
      final name = payload['name'] as String;

      // Check for invite token
      // Also check query params if they used the link directly (GET -> POST conversion usually handled by frontend, but let's check payload)
      final inviteToken = payload['inviteToken'] as String?;

      UserRole role;

      if (inviteToken != null) {
        final invitation =
            await _invitationService.validateInvitation(inviteToken);
        if (invitation == null) {
          return errorResponse('Invalid or expired invitation token',
              statusCode: 400);
        }
        role = invitation.role;
        // Mark as used after successful registration? Or before?
        // Better to mark after, but consistent.
        await _invitationService.markAsUsed(inviteToken);
      } else {
        final roleStr = payload['role'] as String?;
        role = UserRole.values.firstWhere(
          (e) => e.name == roleStr,
          orElse: () => UserRole.student,
        );
      }

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
