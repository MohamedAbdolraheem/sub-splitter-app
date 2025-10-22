import 'dart:developer' as console;

import 'package:subscription_splitter_app/core/constants/api_endpoints.dart';
import 'package:subscription_splitter_app/core/network/dio_client.dart';
import 'package:subscription_splitter_app/features/spliting_features/data/models/group_member_model.dart';
import 'package:subscription_splitter_app/features/spliting_features/data/models/group_model.dart';
import 'package:subscription_splitter_app/features/spliting_features/domain/entities/group.dart';
import 'package:subscription_splitter_app/features/spliting_features/domain/entities/group_member.dart';
import 'package:subscription_splitter_app/features/spliting_features/domain/repositories/groups_repository.dart';

/// Implementation of GroupsRepository using Dio client
class GroupsRepositoryImpl implements GroupsRepository {
  final ApiService _apiService;

  GroupsRepositoryImpl({required ApiService apiService})
    : _apiService = apiService;

  @override
  Future<List<Group>> getUserGroups(String userId) async {
    console.log('GroupsRepository: Getting groups for user: $userId');

    final response = await _apiService.get<List<dynamic>>(
      '${ApiEndpoints.groups}?userId=$userId',
    );

    console.log('GroupsRepository: API response: $response');

    if (response == null) {
      console.log('GroupsRepository: Response is null, returning empty list');
      return [];
    }

    final groups =
        response
            .map((json) => GroupModel.fromJson(json as Map<String, dynamic>))
            .map((model) => model.toEntity())
            .toList();

    console.log('GroupsRepository: Converted to ${groups.length} groups');

    return groups;
  }

  @override
  Future<Group> createGroup({
    required String serviceId,
    required String ownerId,
    required String name,
    required double totalCost,
    String cycle = 'monthly',
    required String renewDate,
    String? description,
    int? maxMembers,
  }) async {
    final data = <String, dynamic>{
      'service_id': serviceId,
      'owner_id': ownerId,
      'name': name,
      'total_cost': totalCost,
      'cycle': cycle,
      'renew_date': renewDate,
    };

    final response = await _apiService.post<Map<String, dynamic>>(
      ApiEndpoints.groups,
      data: data,
    );
    console.log('GroupsRepositoryImpl: Response: $response');

    if (response == null) {
      throw Exception('Failed to create group');
    }

    // Handle the wrapped response format: {success, message, data}
    if (response.containsKey('data')) {
      final groupData = response['data'] as Map<String, dynamic>;
      return GroupModel.fromJson(groupData).toEntity();
    } else {
      // Fallback for direct group object response
      return GroupModel.fromJson(response).toEntity();
    }
  }

  @override
  Future<Group> getGroupDetails(String groupId) async {
    final response = await _apiService.get<Map<String, dynamic>>(
      ApiEndpoints.groupDetailsById(groupId),
    );

    if (response == null) {
      throw Exception('Group not found');
    }

    return GroupModel.fromJson(response).toEntity();
  }

  @override
  Future<Group> updateGroup(
    String groupId, {
    String? name,
    double? totalCost,
    String? cycle,
    String? renewDate,
  }) async {
    final data = <String, dynamic>{};
    if (name != null) data['name'] = name;
    if (totalCost != null) data['total_cost'] = totalCost;
    if (cycle != null) data['cycle'] = cycle;
    if (renewDate != null) data['renew_date'] = renewDate;

    final response = await _apiService.put<Map<String, dynamic>>(
      ApiEndpoints.groupDetailsById(groupId),
      data: data,
    );

    if (response == null) {
      throw Exception('Failed to update group');
    }

    return GroupModel.fromJson(response).toEntity();
  }

  @override
  Future<void> deleteGroup(String groupId) async {
    await _apiService.delete<Map<String, dynamic>>(
      ApiEndpoints.groupDetailsById(groupId),
    );
  }

  @override
  Future<List<GroupMember>> getGroupMembers(String groupId) async {
    final response = await _apiService.get<List<dynamic>>(
      ApiEndpoints.groupMembersById(groupId),
    );

    if (response == null) return [];

    return response
        .map((json) => GroupMemberModel.fromJson(json as Map<String, dynamic>))
        .map((model) => model.toEntity())
        .toList();
  }

  @override
  Future<GroupMember> addGroupMember({
    required String groupId,
    required String userId,
    double? share,
  }) async {
    final data = <String, dynamic>{'user_id': userId};
    if (share != null) data['share'] = share;

    final response = await _apiService.post<Map<String, dynamic>>(
      ApiEndpoints.addGroupMemberById(groupId),
      data: data,
    );

    if (response == null) {
      throw Exception('Failed to add group member');
    }

    return GroupMemberModel.fromJson(response).toEntity();
  }

  @override
  Future<GroupMember> updateMemberShare({
    required String groupId,
    required String memberId,
    required double share,
  }) async {
    final response = await _apiService.put<Map<String, dynamic>>(
      ApiEndpoints.updateMemberShareById(groupId, memberId),
      data: {'share': share},
    );

    if (response == null) {
      throw Exception('Failed to update member share');
    }

    return GroupMemberModel.fromJson(response).toEntity();
  }

  @override
  Future<Map<String, dynamic>> rebalanceGroup(String groupId) async {
    final response = await _apiService.post<Map<String, dynamic>>(
      ApiEndpoints.rebalanceGroupById(groupId),
    );

    if (response == null) {
      throw Exception('Failed to rebalance group');
    }

    return response;
  }

  @override
  Future<void> removeGroupMember({
    required String groupId,
    required String memberId,
  }) async {
    await _apiService.delete<Map<String, dynamic>>(
      ApiEndpoints.removeGroupMemberById(groupId, memberId),
    );
  }
}
