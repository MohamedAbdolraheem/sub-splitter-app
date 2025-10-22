import 'group_member.dart';
import 'service.dart';
import 'user.dart';

/// Group entity representing a subscription sharing group
class Group {
  /// Unique identifier for the group
  final String id;

  /// ID of the service this group is for
  final String serviceId;

  /// ID of the user who owns this group
  final String ownerId;

  /// Name of the group
  final String name;

  /// Total cost of the subscription
  final double totalCost;

  /// Billing cycle (monthly, yearly)
  final String cycle;

  /// Next renewal date
  final DateTime renewDate;

  /// When the group was created
  final DateTime createdAt;

  /// Members of this group
  final List<GroupMember> groupMembers;

  /// The service this group is for
  final Service service;

  /// The owner of this group
  final User owner;

  /// Creates a new Group instance
  const Group({
    required this.id,
    required this.serviceId,
    required this.ownerId,
    required this.name,
    required this.totalCost,
    required this.cycle,
    required this.renewDate,
    required this.createdAt,
    required this.groupMembers,
    required this.service,
    required this.owner,
  });

  /// Creates a copy of this Group with the given fields replaced with new values
  Group copyWith({
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
    return Group(
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

  /// Gets the number of active members
  int get activeMemberCount {
    return groupMembers.where((member) => member.status == 'active').length;
  }

  /// Gets the total number of members
  int get totalMemberCount {
    return groupMembers.length;
  }

  /// Checks if a user is the owner of this group
  bool isOwner(String userId) {
    return ownerId == userId;
  }

  /// Gets a member by user ID
  GroupMember? getMemberByUserId(String userId) {
    try {
      return groupMembers.firstWhere((member) => member.userId == userId);
    } catch (e) {
      return null;
    }
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Group &&
        other.id == id &&
        other.serviceId == serviceId &&
        other.ownerId == ownerId &&
        other.name == name &&
        other.totalCost == totalCost &&
        other.cycle == cycle &&
        other.renewDate == renewDate &&
        other.createdAt == createdAt &&
        other.groupMembers == groupMembers &&
        other.service == service &&
        other.owner == owner;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        serviceId.hashCode ^
        ownerId.hashCode ^
        name.hashCode ^
        totalCost.hashCode ^
        cycle.hashCode ^
        renewDate.hashCode ^
        createdAt.hashCode ^
        groupMembers.hashCode ^
        service.hashCode ^
        owner.hashCode;
  }

  @override
  String toString() {
    return 'Group(id: $id, serviceId: $serviceId, ownerId: $ownerId, name: $name, totalCost: $totalCost, cycle: $cycle, renewDate: $renewDate, createdAt: $createdAt, groupMembers: $groupMembers, service: $service, owner: $owner)';
  }
}
