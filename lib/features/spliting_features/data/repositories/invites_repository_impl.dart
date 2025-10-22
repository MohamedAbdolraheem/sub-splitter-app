import 'package:subscription_splitter_app/core/constants/api_endpoints.dart';
import 'package:subscription_splitter_app/core/network/dio_client.dart';
import 'package:subscription_splitter_app/features/spliting_features/domain/repositories/invites_repository.dart';

/// Implementation of InvitesRepository using Dio client
class InvitesRepositoryImpl implements InvitesRepository {
  final ApiService _apiService;

  InvitesRepositoryImpl({required ApiService apiService})
    : _apiService = apiService;

  @override
  Future<Map<String, dynamic>> createInvite({
    required String groupId,
    required String inviterId,
    required String inviteeEmail,
  }) async {
    final response = await _apiService.post<Map<String, dynamic>>(
      ApiEndpoints.invites,
      data: {
        'group_id': groupId,
        'inviter_id': inviterId,
        'invitee_email': inviteeEmail,
      },
    );
    return response ?? {};
  }

  @override
  Future<List<Map<String, dynamic>>> getUserInvites({
    required String userId,
    String? groupId,
    String? status,
  }) async {
    String url = '${ApiEndpoints.invites}?userId=$userId';
    if (groupId != null) url += '&groupId=$groupId';
    if (status != null) url += '&status=$status';

    final response = await _apiService.get<List<dynamic>>(url);
    return (response ?? []).cast<Map<String, dynamic>>();
  }

  @override
  Future<Map<String, dynamic>> getInviteDetails(String inviteId) async {
    final response = await _apiService.get<Map<String, dynamic>>(
      ApiEndpoints.inviteDetailsById(inviteId),
    );
    return response ?? {};
  }

  @override
  Future<Map<String, dynamic>> updateInviteStatus({
    required String inviteId,
    required String status,
  }) async {
    final response = await _apiService.put<Map<String, dynamic>>(
      ApiEndpoints.updateInviteStatusById(inviteId),
      data: {'status': status},
    );
    return response ?? {};
  }

  /// Accept an invitation
  @override
  Future<Map<String, dynamic>> acceptInvitation({
    required String inviteId,
    required String userId,
  }) async {
    final response = await _apiService.post<Map<String, dynamic>>(
      ApiEndpoints.acceptInvitationById(inviteId),
      data: {'userId': userId},
    );
    return response ?? {};
  }

  /// Decline an invitation
  @override
  Future<Map<String, dynamic>> declineInvitation({
    required String inviteId,
    required String userId,
  }) async {
    final response = await _apiService.post<Map<String, dynamic>>(
      ApiEndpoints.declineInvitationById(inviteId),
      data: {'userId': userId},
    );
    return response ?? {};
  }

  /// Create app-based invitation
  @override
  Future<Map<String, dynamic>> createAppInvitation({
    required String groupId,
    required String inviterId,
    required String inviteeUserId,
  }) async {
    final response = await _apiService.post<Map<String, dynamic>>(
      ApiEndpoints.createAppInvitation,
      data: {
        'group_id': groupId,
        'inviter_id': inviterId,
        'invitee_user_id': inviteeUserId,
      },
    );
    return response ?? {};
  }
}
