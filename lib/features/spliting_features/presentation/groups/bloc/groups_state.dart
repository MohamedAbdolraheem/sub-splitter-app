part of 'groups_bloc.dart';

/// {@template groups_status}
/// Enum representing the current status of the groups
/// {@endtemplate}
enum GroupsStatus {
  /// Initial state
  initial,

  /// Loading groups
  loading,

  /// Groups loaded successfully
  success,

  /// Error loading groups
  error,
}

/// {@template groups_state}
/// State class for groups
/// {@endtemplate}
class GroupsState extends Equatable {
  /// {@macro groups_state}
  const GroupsState({
    this.status = GroupsStatus.initial,
    this.ownedGroups = const [],
    this.memberGroups = const [],
    this.allGroups = const [],
    this.errorMessage,
  });

  /// Current status of the groups
  final GroupsStatus status;

  /// Groups owned by the current user
  final List<Group> ownedGroups;

  /// Groups where the user is a member (not owner)
  final List<Group> memberGroups;

  /// All groups (owned + member)
  final List<Group> allGroups;

  /// Error message if any
  final String? errorMessage;

  /// Whether groups are currently loading
  bool get isLoading => status == GroupsStatus.loading;

  /// Whether groups were loaded successfully
  bool get isSuccess => status == GroupsStatus.success;

  /// Whether there's an error
  bool get hasError => status == GroupsStatus.error;

  /// Total number of groups
  int get totalGroups => allGroups.length;

  /// Number of owned groups
  int get ownedGroupsCount => ownedGroups.length;

  /// Number of member groups
  int get memberGroupsCount => memberGroups.length;

  @override
  List<Object?> get props => [
    status,
    ownedGroups,
    memberGroups,
    allGroups,
    errorMessage,
  ];

  /// Create a copy of this state with updated fields
  GroupsState copyWith({
    GroupsStatus? status,
    List<Group>? ownedGroups,
    List<Group>? memberGroups,
    List<Group>? allGroups,
    String? errorMessage,
  }) {
    return GroupsState(
      status: status ?? this.status,
      ownedGroups: ownedGroups ?? this.ownedGroups,
      memberGroups: memberGroups ?? this.memberGroups,
      allGroups: allGroups ?? this.allGroups,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
