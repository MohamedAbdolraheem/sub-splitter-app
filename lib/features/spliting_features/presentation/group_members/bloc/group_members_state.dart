part of 'group_members_bloc.dart';

/// {@template group_members_state}
/// GroupMembersState description
/// {@endtemplate}
class GroupMembersState extends Equatable {
  /// {@macro group_members_state}
  const GroupMembersState({
    this.members = const [],
    this.totalCost = 0.0,
    this.isAutoEqualShares = true,
    this.isLoading = false,
    this.isSaving = false,
    this.isInviting = false,
    this.isRemoving = false,
    this.error,
    this.selectedMemberId,
    this.showShareEditor = false,
    this.inviteEmail = '',
  });

  final List<GroupMember> members;
  final double totalCost;
  final bool isAutoEqualShares;
  final bool isLoading;
  final bool isSaving;
  final bool isInviting;
  final bool isRemoving;
  final String? error;
  final String? selectedMemberId;
  final bool showShareEditor;
  final String inviteEmail;

  @override
  List<Object?> get props => [
    members,
    totalCost,
    isAutoEqualShares,
    isLoading,
    isSaving,
    isInviting,
    isRemoving,
    error,
    selectedMemberId,
    showShareEditor,
    inviteEmail,
  ];

  /// Creates a copy of the current GroupMembersState with property changes
  GroupMembersState copyWith({
    List<GroupMember>? members,
    double? totalCost,
    bool? isAutoEqualShares,
    bool? isLoading,
    bool? isSaving,
    bool? isInviting,
    bool? isRemoving,
    String? error,
    String? selectedMemberId,
    bool? showShareEditor,
    String? inviteEmail,
  }) {
    return GroupMembersState(
      members: members ?? this.members,
      totalCost: totalCost ?? this.totalCost,
      isAutoEqualShares: isAutoEqualShares ?? this.isAutoEqualShares,
      isLoading: isLoading ?? this.isLoading,
      isSaving: isSaving ?? this.isSaving,
      isInviting: isInviting ?? this.isInviting,
      isRemoving: isRemoving ?? this.isRemoving,
      error: error ?? this.error,
      selectedMemberId: selectedMemberId ?? this.selectedMemberId,
      showShareEditor: showShareEditor ?? this.showShareEditor,
      inviteEmail: inviteEmail ?? this.inviteEmail,
    );
  }
}

/// {@template group_member}
/// Represents a group member with their share information
/// {@endtemplate}
class GroupMember extends Equatable {
  /// {@macro group_member}
  const GroupMember({
    required this.id,
    required this.name,
    required this.email,
    required this.sharePercentage,
    required this.amount,
    required this.isOwner,
    required this.isAdmin,
    this.avatar,
    this.joinedAt,
  });

  final String id;
  final String name;
  final String email;
  final double sharePercentage;
  final double amount;
  final bool isOwner;
  final bool isAdmin;
  final String? avatar;
  final DateTime? joinedAt;

  @override
  List<Object?> get props => [
    id,
    name,
    email,
    sharePercentage,
    amount,
    isOwner,
    isAdmin,
    avatar,
    joinedAt,
  ];

  GroupMember copyWith({
    String? id,
    String? name,
    String? email,
    double? sharePercentage,
    double? amount,
    bool? isOwner,
    bool? isAdmin,
    String? avatar,
    DateTime? joinedAt,
  }) {
    return GroupMember(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      sharePercentage: sharePercentage ?? this.sharePercentage,
      amount: amount ?? this.amount,
      isOwner: isOwner ?? this.isOwner,
      isAdmin: isAdmin ?? this.isAdmin,
      avatar: avatar ?? this.avatar,
      joinedAt: joinedAt ?? this.joinedAt,
    );
  }
}

/// {@template group_members_initial}
/// The initial state of GroupMembersState
/// {@endtemplate}
class GroupMembersInitial extends GroupMembersState {
  /// {@macro group_members_initial}
  const GroupMembersInitial() : super();
}
