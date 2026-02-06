import '../models/invitation.dart';

abstract class InvitationRepository {
  Future<Invitation> createInvitation(Invitation invitation);
  Future<Invitation?> getInvitation(String token);
  Future<void> updateInvitation(Invitation invitation);
}
