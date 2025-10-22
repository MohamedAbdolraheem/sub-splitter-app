part of 'contact_invitation_bloc.dart';

abstract class ContactInvitationState extends Equatable {
  const ContactInvitationState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class ContactInvitationInitial extends ContactInvitationState {
  const ContactInvitationInitial();
}

/// Loading state
class ContactInvitationLoading extends ContactInvitationState {
  const ContactInvitationLoading();
}

/// Permission denied state
class ContactInvitationPermissionDenied extends ContactInvitationState {
  const ContactInvitationPermissionDenied();
}

/// Loaded state with contacts
class ContactInvitationLoaded extends ContactInvitationState {
  const ContactInvitationLoaded({
    required this.contacts,
    required this.selectedContacts,
    this.searchQuery = '',
    this.isAppUsersOnly = false,
    this.isLoading = false,
    this.isSending = false,
    this.error,
    this.syncStatus,
  });

  final List<ContactModel> contacts;
  final List<ContactModel> selectedContacts;
  final String searchQuery;
  final bool isAppUsersOnly;
  final bool isLoading;
  final bool isSending;
  final String? error;
  final ContactSyncStatus? syncStatus;

  @override
  List<Object?> get props => [
    contacts,
    selectedContacts,
    searchQuery,
    isAppUsersOnly,
    isLoading,
    isSending,
    error,
    syncStatus,
  ];

  ContactInvitationLoaded copyWith({
    List<ContactModel>? contacts,
    List<ContactModel>? selectedContacts,
    String? searchQuery,
    bool? isAppUsersOnly,
    bool? isLoading,
    bool? isSending,
    String? error,
    ContactSyncStatus? syncStatus,
    bool clearError = false,
  }) {
    return ContactInvitationLoaded(
      contacts: contacts ?? this.contacts,
      selectedContacts: selectedContacts ?? this.selectedContacts,
      searchQuery: searchQuery ?? this.searchQuery,
      isAppUsersOnly: isAppUsersOnly ?? this.isAppUsersOnly,
      isLoading: isLoading ?? this.isLoading,
      isSending: isSending ?? this.isSending,
      error: clearError ? null : (error ?? this.error),
      syncStatus: syncStatus ?? this.syncStatus,
    );
  }

  /// Get filtered contacts based on search and app users filter
  List<ContactModel> get filteredContacts {
    var filtered = contacts;

    // Filter by search query
    if (searchQuery.isNotEmpty) {
      final lowercaseQuery = searchQuery.toLowerCase();
      filtered =
          filtered.where((contact) {
            final nameMatch = contact.displayName.toLowerCase().contains(
              lowercaseQuery,
            );
            final phoneMatch = contact.phoneNumbers.any(
              (phone) => phone.number.contains(searchQuery),
            );
            final emailMatch = contact.emails.any(
              (email) => email.address.toLowerCase().contains(lowercaseQuery),
            );
            return nameMatch || phoneMatch || emailMatch;
          }).toList();
    }

    // Filter by app users only
    if (isAppUsersOnly) {
      filtered = filtered.where((contact) => contact.isAppUser).toList();
    }

    return filtered;
  }

  /// Get app users count
  int get appUsersCount =>
      contacts.where((contact) => contact.isAppUser).length;

  /// Get non-app users count
  int get nonAppUsersCount =>
      contacts.where((contact) => !contact.isAppUser).length;
}

/// Success state
class ContactInvitationSuccess extends ContactInvitationState {
  const ContactInvitationSuccess({
    required this.sentCount,
    required this.totalCount,
    required this.message,
  });

  final int sentCount;
  final int totalCount;
  final String message;

  @override
  List<Object?> get props => [sentCount, totalCount, message];
}

/// Invitation link generated state
class ContactInvitationLinkGenerated extends ContactInvitationState {
  const ContactInvitationLinkGenerated({
    required this.invitationLink,
    required this.groupId,
    required this.message,
  });

  final String invitationLink;
  final String groupId;
  final String message;

  @override
  List<Object?> get props => [invitationLink, groupId, message];
}

/// Error state
class ContactInvitationError extends ContactInvitationState {
  const ContactInvitationError({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}

/// Contact sync status model
class ContactSyncStatus extends Equatable {
  const ContactSyncStatus({
    required this.lastSyncTime,
    required this.totalContacts,
    required this.matchedContacts,
    required this.appUsersFound,
  });

  final DateTime lastSyncTime;
  final int totalContacts;
  final int matchedContacts;
  final int appUsersFound;

  @override
  List<Object?> get props => [
    lastSyncTime,
    totalContacts,
    matchedContacts,
    appUsersFound,
  ];

  /// Sync percentage
  double get syncPercentage {
    if (totalContacts == 0) return 0.0;
    return (matchedContacts / totalContacts) * 100;
  }

  /// Create ContactSyncStatus from JSON
  factory ContactSyncStatus.fromJson(Map<String, dynamic> json) {
    return ContactSyncStatus(
      lastSyncTime: DateTime.parse(json['lastSyncTime'] as String),
      totalContacts: json['totalContacts'] as int,
      matchedContacts: json['matchedContacts'] as int,
      appUsersFound: json['appUsersFound'] as int,
    );
  }

  /// Convert ContactSyncStatus to JSON
  Map<String, dynamic> toJson() {
    return {
      'lastSyncTime': lastSyncTime.toIso8601String(),
      'totalContacts': totalContacts,
      'matchedContacts': matchedContacts,
      'appUsersFound': appUsersFound,
    };
  }
}
