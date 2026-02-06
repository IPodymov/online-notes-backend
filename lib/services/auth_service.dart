import '../domain/models/user.dart';

class AuthService {
  // Использование Record для возврата результата проверки авторизации
  ({bool isAllowed, String reason}) checkAccess(
      User? user, List<UserRole> allowedRoles) {
    if (user == null) {
      return (isAllowed: false, reason: 'User not authenticated');
    }

    if (allowedRoles.contains(user.role)) {
      return (isAllowed: true, reason: 'Access granted');
    }

    return (
      isAllowed: false,
      reason:
          'Access denied: User role ${user.role} is not authorized. Required: $allowedRoles'
    );
  }

  // Пример использования Record для маппинга прав доступа
  // (UserRole role, String resource) -> (canRead, canWrite, canDelete)
  (bool, bool, bool) getPermissionsForRole(UserRole role) {
    return switch (role) {
      UserRole.admin => (true, true, true),
      UserRole.schoolAdmin => (true, true, true),
      UserRole.classTeacher => (true, true, false),
      UserRole.parent => (true, false, false),
      UserRole.student => (true, false, false),
    };
  }
}
