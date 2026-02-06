import 'package:uuid/uuid.dart';
import '../domain/models/invitation.dart';
import '../domain/models/user.dart';
import '../domain/repositories/invitation_repository.dart';

class InvitationService {
  final InvitationRepository _invitationRepository;
  final Uuid _uuid = Uuid();

  InvitationService(this._invitationRepository);

  Future<Invitation> createInvitation(UserRole role) async {
    final token = _uuid.v4();
    final invitation = Invitation(
      token: token,
      role: role,
    );
    return await _invitationRepository.createInvitation(invitation);
  }

  Future<Invitation?> validateInvitation(String token) async {
    final invitation = await _invitationRepository.getInvitation(token);
    if (invitation != null && !invitation.isUsed) {
      return invitation;
    }
    return null;
  }

  Future<void> markAsUsed(String token) async {
    final invitation = await _invitationRepository.getInvitation(token);
    if (invitation != null) {
      await _invitationRepository
          .updateInvitation(invitation.copyWith(isUsed: true));
    }
  }

  bool canCreateInvitation(UserRole userRole) {
    return [UserRole.admin, UserRole.schoolAdmin, UserRole.classTeacher]
        .contains(userRole);
  }
}
