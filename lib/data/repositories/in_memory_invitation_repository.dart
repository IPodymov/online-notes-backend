import '../../domain/models/invitation.dart';
import '../../domain/repositories/invitation_repository.dart';

class InMemoryInvitationRepository implements InvitationRepository {
  final List<Invitation> _invitations = [];

  @override
  Future<Invitation> createInvitation(Invitation invitation) async {
    _invitations.add(invitation);
    return invitation;
  }

  @override
  Future<Invitation?> getInvitation(String token) async {
    try {
      return _invitations.firstWhere((i) => i.token == token);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> updateInvitation(Invitation invitation) async {
    final index = _invitations.indexWhere((i) => i.token == invitation.token);
    if (index != -1) {
      _invitations[index] = invitation;
    }
  }
}
