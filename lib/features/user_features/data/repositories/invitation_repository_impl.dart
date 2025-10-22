import 'package:subscription_splitter_app/core/notifications/models/notification_model.dart';
import 'package:subscription_splitter_app/features/user_features/domain/repositories/invitation_repository.dart';
import 'package:subscription_splitter_app/core/notifications/services/notification_api_service.dart';
import 'package:subscription_splitter_app/core/contacts/services/contact_api_service.dart';

/// Implementation of InvitationRepository
class InvitationRepositoryImpl implements InvitationRepository {
  const InvitationRepositoryImpl({
    required this.notificationApiService,
    required this.contactApiService,
  });

  final NotificationApiService notificationApiService;
  final ContactApiService contactApiService;

  @override
  Future<void> sendAppNotification({
    required String userId,
    required String groupId,
    String? customMessage,
  }) async {
    await notificationApiService.sendNotificationToUser(
      userId: userId,
      title: 'Group Invitation',
      body: customMessage ?? 'You have been invited to join a group',
      type: NotificationType.groupInvite,
      data: {'groupId': groupId},
    );
  }

  @override
  Future<void> sendEmailInvitation({
    required String email,
    required String groupId,
    String? customMessage,
  }) async {
    await contactApiService.sendEmailInvitation(
      email: email,
      groupId: groupId,
      customMessage: customMessage,
    );
  }

  @override
  Future<String> generateInvitationLink({
    required String groupId,
    String? customMessage,
  }) async {
    final result = await contactApiService.generateInvitationLink(
      groupId: groupId,
      customMessage: customMessage,
      inviterName: null,
    );

    final link = result['invitationLink'] as String?;
    if (link == null) {
      throw Exception('Failed to generate invitation link');
    }

    return link;
  }
}
