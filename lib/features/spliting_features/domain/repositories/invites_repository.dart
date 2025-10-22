/// Abstract repository for invites management
abstract class InvitesRepository {
  /// Create invite
  Future<Map<String, dynamic>> createInvite({
    required String groupId,
    required String inviterId,
    required String inviteeEmail,
  });

  /// Get invites for user
  Future<List<Map<String, dynamic>>> getUserInvites({
    required String userId,
    String? groupId,
    String? status,
  });

  /// Get invite details
  Future<Map<String, dynamic>> getInviteDetails(String inviteId);

  /// Update invite status
  Future<Map<String, dynamic>> updateInviteStatus({
    required String inviteId,
    required String status, // 'pending', 'accepted', 'declined'
  });

  /// Accept an invitation
  Future<Map<String, dynamic>> acceptInvitation({
    required String inviteId,
    required String userId,
  });

  /// Decline an invitation
  Future<Map<String, dynamic>> declineInvitation({
    required String inviteId,
    required String userId,
  });

  /// Create app-based invitation
  Future<Map<String, dynamic>> createAppInvitation({
    required String groupId,
    required String inviterId,
    required String inviteeUserId,
  });
}
