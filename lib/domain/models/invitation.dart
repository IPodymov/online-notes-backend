import 'user.dart';

class Invitation {
  final String token;
  final UserRole role;
  final bool isUsed;
  final DateTime? expiresAt;

  Invitation({
    required this.token,
    required this.role,
    this.isUsed = false,
    this.expiresAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'role': role.name,
      'isUsed': isUsed,
      'expiresAt': expiresAt?.toIso8601String(),
    };
  }

  factory Invitation.fromJson(Map<String, dynamic> json) {
    return Invitation(
      token: json['token'],
      role: UserRole.values.firstWhere((e) => e.name == json['role']),
      isUsed: json['isUsed'] ?? false,
      expiresAt: json['expiresAt'] != null ? DateTime.parse(json['expiresAt']) : null,
    );
  }

  Invitation copyWith({
    String? token,
    UserRole? role,
    bool? isUsed,
    DateTime? expiresAt,
  }) {
    return Invitation(
      token: token ?? this.token,
      role: role ?? this.role,
      isUsed: isUsed ?? this.isUsed,
      expiresAt: expiresAt ?? this.expiresAt,
    );
  }
}
