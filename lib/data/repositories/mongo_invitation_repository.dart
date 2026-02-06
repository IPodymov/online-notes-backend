import 'package:mongo_dart/mongo_dart.dart';
import '../../domain/models/invitation.dart';
import '../../domain/repositories/invitation_repository.dart';

class MongoInvitationRepository implements InvitationRepository {
  final DbCollection _collection;

  MongoInvitationRepository(Db db) : _collection = db.collection('invitations');

  @override
  Future<Invitation> createInvitation(Invitation invitation) async {
    await _collection.insert(invitation.toJson());
    return invitation;
  }

  @override
  Future<Invitation?> getInvitation(String token) async {
    final json = await _collection.findOne(where.eq('token', token));
    if (json != null) {
      return Invitation.fromJson(json);
    }
    return null;
  }

  @override
  Future<void> updateInvitation(Invitation invitation) async {
    await _collection.replaceOne(
      where.eq('token', invitation.token),
      invitation.toJson(),
    );
  }
}
