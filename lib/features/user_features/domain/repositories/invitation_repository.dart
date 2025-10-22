/// Abstract repository for invitation operations
abstract class InvitationRepository {
  /// Send app notification invitation
  Future<void> sendAppNotification({
    required String userId,
    required String groupId,
    String? customMessage,
  });

  /// Send email invitation
  Future<void> sendEmailInvitation({
    required String email,
    required String groupId,
    String? customMessage,
  });

  /// Generate invitation link
  Future<String> generateInvitationLink({
    required String groupId,
    String? customMessage,
  });
}
