import 'user.dart';

/// Group member entity representing a user's membership in a group
class GroupMember {
  /// Unique identifier for the group member
  final String id;

  /// The user who is a member
  final User user;

  /// The user's share percentage (0.0 to 1.0)
  final double share;

  /// Status of the membership (active, pending, etc.)
  final String status;

  /// User ID (for quick access)
  final String userId;

  /// Group ID (for quick access)
  final String groupId;

  /// When the user joined the group
  final DateTime joinedAt;

  /// Creates a new GroupMember instance
  const GroupMember({
    required this.id,
    required this.user,
    required this.share,
    required this.status,
    required this.userId,
    required this.groupId,
    required this.joinedAt,
  });

  /// Creates a copy of this GroupMember with the given fields replaced with new values
  GroupMember copyWith({
    String? id,
    User? user,
    double? share,
    String? status,
    String? userId,
    String? groupId,
    DateTime? joinedAt,
  }) {
    return GroupMember(
      id: id ?? this.id,
      user: user ?? this.user,
      share: share ?? this.share,
      status: status ?? this.status,
      userId: userId ?? this.userId,
      groupId: groupId ?? this.groupId,
      joinedAt: joinedAt ?? this.joinedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is GroupMember &&
        other.id == id &&
        other.user == user &&
        other.share == share &&
        other.status == status &&
        other.userId == userId &&
        other.groupId == groupId &&
        other.joinedAt == joinedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        user.hashCode ^
        share.hashCode ^
        status.hashCode ^
        userId.hashCode ^
        groupId.hashCode ^
        joinedAt.hashCode;
  }

  @override
  String toString() {
    return 'GroupMember(id: $id, user: $user, share: $share, status: $status, userId: $userId, groupId: $groupId, joinedAt: $joinedAt)';
  }
}
