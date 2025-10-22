import 'package:subscription_splitter_app/features/spliting_features/data/models/group_member_model.dart';
import 'package:subscription_splitter_app/features/spliting_features/data/models/service_model.dart';
import 'package:subscription_splitter_app/features/spliting_features/data/models/user_model.dart';
import 'package:subscription_splitter_app/features/spliting_features/domain/entities/group.dart';
import 'package:subscription_splitter_app/features/spliting_features/domain/entities/group_member.dart';
import 'package:subscription_splitter_app/features/spliting_features/domain/entities/service.dart';
import 'package:subscription_splitter_app/features/spliting_features/domain/entities/user.dart';

/// Group model for JSON serialization/deserialization
class GroupModel extends Group {
  /// Creates a GroupModel from a Group entity
  const GroupModel({
    required super.id,
    required super.serviceId,
    required super.ownerId,
    required super.name,
    required super.totalCost,
    required super.cycle,
    required super.renewDate,
    required super.createdAt,
    required super.groupMembers,
    required super.service,
    required super.owner,
  });

  /// Creates a GroupModel from JSON
  factory GroupModel.fromJson(Map<String, dynamic> json) {
    return GroupModel(
      id: json['id'] as String,
      serviceId: json['service_id'] as String,
      ownerId: json['owner_id'] as String,
      name: json['name'] as String,
      totalCost: (json['total_cost'] as num).toDouble(),
      cycle: json['cycle'] as String,
      renewDate: DateTime.parse(json['renew_date'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
      // For creation responses, these fields are null - provide minimal defaults
      // Full data will be available when fetching groups via GET API
      groupMembers:
          json['group_members'] != null
              ? (json['group_members'] as List<dynamic>)
                  .map(
                    (memberJson) =>
                        GroupMemberModel.fromJson(
                          memberJson as Map<String, dynamic>,
                        ).toEntity(),
                  )
                  .toList()
              : [], // Empty list for creation response
      service:
          json['service'] != null
              ? ServiceModel.fromJson(
                json['service'] as Map<String, dynamic>,
              ).toEntity()
              : Service(
                id: json['service_id'] as String,
                name:
                    'Loading...', // Will be updated when fetching full group data
                description: 'Service details loading...',
                createdAt: DateTime.now(),
              ),
      owner:
          json['owner'] != null
              ? UserModel.fromJson(
                json['owner'] as Map<String, dynamic>,
              ).toEntity()
              : User(
                id: json['owner_id'] as String,
                fullName:
                    'Loading...', // Will be updated when fetching full group data
                createdAt: DateTime.now(),
              ),
    );
  }

  /// Creates a GroupModel from a Group entity
  factory GroupModel.fromEntity(Group group) {
    return GroupModel(
      id: group.id,
      serviceId: group.serviceId,
      ownerId: group.ownerId,
      name: group.name,
      totalCost: group.totalCost,
      cycle: group.cycle,
      renewDate: group.renewDate,
      createdAt: group.createdAt,
      groupMembers: group.groupMembers,
      service: group.service,
      owner: group.owner,
    );
  }

  /// Converts this GroupModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'service_id': serviceId,
      'owner_id': ownerId,
      'name': name,
      'total_cost': totalCost,
      'cycle': cycle,
      'renew_date':
          renewDate.toIso8601String().split('T')[0], // Format as YYYY-MM-DD
      'created_at': createdAt.toIso8601String(),
      'group_members':
          groupMembers
              .map((member) => GroupMemberModel.fromEntity(member).toJson())
              .toList(),
      'service': ServiceModel.fromEntity(service).toJson(),
      'owner': UserModel.fromEntity(owner).toJson(),
    };
  }

  /// Converts this GroupModel to a Group entity
  Group toEntity() {
    return Group(
      id: id,
      serviceId: serviceId,
      ownerId: ownerId,
      name: name,
      totalCost: totalCost,
      cycle: cycle,
      renewDate: renewDate,
      createdAt: createdAt,
      groupMembers: groupMembers,
      service: service,
      owner: owner,
    );
  }

  @override
  GroupModel copyWith({
    String? id,
    String? serviceId,
    String? ownerId,
    String? name,
    double? totalCost,
    String? cycle,
    DateTime? renewDate,
    DateTime? createdAt,
    List<GroupMember>? groupMembers,
    Service? service,
    User? owner,
  }) {
    return GroupModel(
      id: id ?? this.id,
      serviceId: serviceId ?? this.serviceId,
      ownerId: ownerId ?? this.ownerId,
      name: name ?? this.name,
      totalCost: totalCost ?? this.totalCost,
      cycle: cycle ?? this.cycle,
      renewDate: renewDate ?? this.renewDate,
      createdAt: createdAt ?? this.createdAt,
      groupMembers: groupMembers ?? this.groupMembers,
      service: service ?? this.service,
      owner: owner ?? this.owner,
    );
  }
}
