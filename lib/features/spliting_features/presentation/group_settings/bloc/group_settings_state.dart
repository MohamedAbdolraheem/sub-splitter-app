part of 'group_settings_bloc.dart';

/// {@template group_settings_state}
/// GroupSettingsState description
/// {@endtemplate}
class GroupSettingsState extends Equatable {
  /// {@macro group_settings_state}
  const GroupSettingsState({
    this.groupName = '',
    this.description = '',
    this.totalCost = 0.0,
    this.billingCycle = 'monthly',
    this.maxMembers = 10,
    this.isPublic = false,
    this.allowInvites = true,
    this.autoSplit = true,
    this.isLoading = false,
    this.isSaving = false,
    this.error,
  });

  final String groupName;
  final String description;
  final double totalCost;
  final String billingCycle;
  final int maxMembers;
  final bool isPublic;
  final bool allowInvites;
  final bool autoSplit;
  final bool isLoading;
  final bool isSaving;
  final String? error;

  @override
  List<Object?> get props => [
    groupName,
    description,
    totalCost,
    billingCycle,
    maxMembers,
    isPublic,
    allowInvites,
    autoSplit,
    isLoading,
    isSaving,
    error,
  ];

  /// Creates a copy of the current GroupSettingsState with property changes
  GroupSettingsState copyWith({
    String? groupName,
    String? description,
    double? totalCost,
    String? billingCycle,
    int? maxMembers,
    bool? isPublic,
    bool? allowInvites,
    bool? autoSplit,
    bool? isLoading,
    bool? isSaving,
    String? error,
  }) {
    return GroupSettingsState(
      groupName: groupName ?? this.groupName,
      description: description ?? this.description,
      totalCost: totalCost ?? this.totalCost,
      billingCycle: billingCycle ?? this.billingCycle,
      maxMembers: maxMembers ?? this.maxMembers,
      isPublic: isPublic ?? this.isPublic,
      allowInvites: allowInvites ?? this.allowInvites,
      autoSplit: autoSplit ?? this.autoSplit,
      isLoading: isLoading ?? this.isLoading,
      isSaving: isSaving ?? this.isSaving,
      error: error ?? this.error,
    );
  }
}

/// {@template group_settings_initial}
/// The initial state of GroupSettingsState
/// {@endtemplate}
class GroupSettingsInitial extends GroupSettingsState {
  /// {@macro group_settings_initial}
  const GroupSettingsInitial() : super();
}
