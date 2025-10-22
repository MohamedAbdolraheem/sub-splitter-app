/// API Endpoints for Subscription Splitter App
/// Based on the NestJS backend API documentation
class ApiEndpoints {
  // Health Check
  static const String health = '/health';

  // Dashboard
  static const String dashboard = '/dashboard';
  static const String dashboardData = '/dashboard/{userId}';

  // Services
  static const String services = '/services';

  // Groups Management
  static const String groups = '/groups';
  static const String groupDetails = '/groups/{id}';
  static const String groupMembers = '/groups/{id}/members';
  static const String addGroupMember = '/groups/{id}/members';
  static const String updateMemberShare =
      '/groups/{id}/members/{memberId}/share';
  static const String rebalanceGroup = '/groups/{id}/rebalance';
  static const String removeGroupMember = '/groups/{id}/members/{memberId}';

  // Invites
  static const String invites = '/invites';
  static const String inviteDetails = '/invites/{id}';
  static const String updateInviteStatus = '/invites/{id}/status';
  static const String acceptInvitation = '/invites/{id}/accept';
  static const String declineInvitation = '/invites/{id}/decline';
  static const String createAppInvitation = '/invites/app';

  // Payments
  static const String payments = '/payments';
  static const String paymentDetails = '/payments/{id}';
  static const String updatePaymentStatus = '/payments/{id}/status';

  // Contacts
  static const String findUsersByEmails = '/contacts/find-by-email';
  static const String findUsersByPhones = '/users/find-by-phones';
  static const String sendEmailInvitation = '/contacts/send-email-invitation';
  static const String generateInvitationLink =
      '/contacts/generate-invitation-link';

  // Utility Methods
  static String dashboardDataByUserId(String userId) =>
      dashboardData.replaceAll('{userId}', userId);

  static String groupDetailsById(String groupId) =>
      groupDetails.replaceAll('{id}', groupId);
  static String groupMembersById(String groupId) =>
      groupMembers.replaceAll('{id}', groupId);
  static String addGroupMemberById(String groupId) =>
      addGroupMember.replaceAll('{id}', groupId);
  static String updateMemberShareById(String groupId, String memberId) =>
      updateMemberShare
          .replaceAll('{id}', groupId)
          .replaceAll('{memberId}', memberId);
  static String rebalanceGroupById(String groupId) =>
      rebalanceGroup.replaceAll('{id}', groupId);
  static String removeGroupMemberById(String groupId, String memberId) =>
      removeGroupMember
          .replaceAll('{id}', groupId)
          .replaceAll('{memberId}', memberId);

  static String inviteDetailsById(String inviteId) =>
      inviteDetails.replaceAll('{id}', inviteId);
  static String updateInviteStatusById(String inviteId) =>
      updateInviteStatus.replaceAll('{id}', inviteId);
  static String acceptInvitationById(String inviteId) =>
      acceptInvitation.replaceAll('{id}', inviteId);
  static String declineInvitationById(String inviteId) =>
      declineInvitation.replaceAll('{id}', inviteId);

  static String paymentDetailsById(String paymentId) =>
      paymentDetails.replaceAll('{id}', paymentId);
  static String updatePaymentStatusById(String paymentId) =>
      updatePaymentStatus.replaceAll('{id}', paymentId);
}
