import '../entities/group.dart';
import '../entities/group_member.dart';

/// Abstract repository for groups management
abstract class GroupsRepository {
  /// Get all groups for a user
  Future<List<Group>> getUserGroups(String userId);

  /// Create a new group
  Future<Group> createGroup({
    required String serviceId,
    required String ownerId,
    required String name,
    required double totalCost,
    String cycle = 'monthly',
    required String renewDate,
    String? description,
    int? maxMembers,
  });

  /// Get group details
  Future<Group> getGroupDetails(String groupId);

  /// Update group
  Future<Group> updateGroup(
    String groupId, {
    String? name,
    double? totalCost,
    String? cycle,
    String? renewDate,
  });

  /// Delete group
  Future<void> deleteGroup(String groupId);

  /// Get group members
  Future<List<GroupMember>> getGroupMembers(String groupId);

  /// Add member to group
  Future<GroupMember> addGroupMember({
    required String groupId,
    required String userId,
    double? share,
  });

  /// Update member share
  Future<GroupMember> updateMemberShare({
    required String groupId,
    required String memberId,
    required double share,
  });

  /// Rebalance group shares
  Future<Map<String, dynamic>> rebalanceGroup(String groupId);

  /// Remove member from group
  Future<void> removeGroupMember({
    required String groupId,
    required String memberId,
  });
}
