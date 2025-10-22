import 'package:subscription_splitter_app/features/spliting_features/data/models/user_model.dart';
import 'package:subscription_splitter_app/features/spliting_features/domain/entities/group_member.dart';
import 'package:subscription_splitter_app/features/spliting_features/domain/entities/user.dart';

/// Group member model for JSON serialization/deserialization
class GroupMemberModel extends GroupMember {
  /// Creates a GroupMemberModel from a GroupMember entity
  const GroupMemberModel({
    required super.id,
    required super.user,
    required super.share,
    required super.status,
    required super.userId,
    required super.groupId,
    required super.joinedAt,
  });

  /// Creates a GroupMemberModel from JSON
  factory GroupMemberModel.fromJson(Map<String, dynamic> json) {
    return GroupMemberModel(
      id: json['id'] as String,
      user: UserModel.fromJson(json['user'] as Map<String, dynamic>).toEntity(),
      share: (json['share'] as num).toDouble(),
      status: json['status'] as String,
      userId: json['user_id'] as String,
      groupId: json['group_id'] as String,
      joinedAt: DateTime.parse(json['joined_at'] as String),
    );
  }

  /// Creates a GroupMemberModel from a GroupMember entity
  factory GroupMemberModel.fromEntity(GroupMember groupMember) {
    return GroupMemberModel(
      id: groupMember.id,
      user: groupMember.user,
      share: groupMember.share,
      status: groupMember.status,
      userId: groupMember.userId,
      groupId: groupMember.groupId,
      joinedAt: groupMember.joinedAt,
    );
  }

  /// Converts this GroupMemberModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user': UserModel.fromEntity(user).toJson(),
      'share': share,
      'status': status,
      'user_id': userId,
      'group_id': groupId,
      'joined_at': joinedAt.toIso8601String(),
    };
  }

  /// Converts this GroupMemberModel to a GroupMember entity
  GroupMember toEntity() {
    return GroupMember(
      id: id,
      user: user,
      share: share,
      status: status,
      userId: userId,
      groupId: groupId,
      joinedAt: joinedAt,
    );
  }

  @override
  GroupMemberModel copyWith({
    String? id,
    User? user,
    double? share,
    String? status,
    String? userId,
    String? groupId,
    DateTime? joinedAt,
  }) {
    return GroupMemberModel(
      id: id ?? this.id,
      user: user ?? this.user,
      share: share ?? this.share,
      status: status ?? this.status,
      userId: userId ?? this.userId,
      groupId: groupId ?? this.groupId,
      joinedAt: joinedAt ?? this.joinedAt,
    );
  }
}
