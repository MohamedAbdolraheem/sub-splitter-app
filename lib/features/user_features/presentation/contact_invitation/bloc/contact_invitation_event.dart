part of 'contact_invitation_bloc.dart';

abstract class ContactInvitationEvent extends Equatable {
  const ContactInvitationEvent();

  @override
  List<Object?> get props => [];
}

/// Event to request contact permission
class RequestContactPermission extends ContactInvitationEvent {
  const RequestContactPermission();
}

/// Event to load contacts from device
class LoadContacts extends ContactInvitationEvent {
  const LoadContacts();
}

/// Event to search contacts
class SearchContacts extends ContactInvitationEvent {
  const SearchContacts({required this.query});

  final String query;

  @override
  List<Object?> get props => [query];
}

/// Event to sync contacts with app users
class SyncContactsWithUsers extends ContactInvitationEvent {
  const SyncContactsWithUsers();
}

/// Event to select a contact for invitation
class SelectContact extends ContactInvitationEvent {
  const SelectContact({required this.contact});

  final ContactModel contact;

  @override
  List<Object?> get props => [contact];
}

/// Event to deselect a contact
class DeselectContact extends ContactInvitationEvent {
  const DeselectContact({required this.contact});

  final ContactModel contact;

  @override
  List<Object?> get props => [contact];
}

/// Event to select all contacts
class SelectAllContacts extends ContactInvitationEvent {
  const SelectAllContacts();
}

/// Event to deselect all contacts
class DeselectAllContacts extends ContactInvitationEvent {
  const DeselectAllContacts();
}

/// Event to send invitations to selected contacts
class SendInvitations extends ContactInvitationEvent {
  const SendInvitations({
    required this.groupId,
    this.customMessage,
    this.invitationType = ContactInvitationType.shareLink,
  });

  final String groupId;
  final String? customMessage;
  final ContactInvitationType invitationType;

  @override
  List<Object?> get props => [groupId, customMessage, invitationType];
}

/// Event to send invitation to a specific contact
class SendContactInvitation extends ContactInvitationEvent {
  const SendContactInvitation({
    required this.contact,
    required this.groupId,
    this.customMessage,
    this.invitationType = ContactInvitationType.shareLink,
  });

  final ContactModel contact;
  final String groupId;
  final String? customMessage;
  final ContactInvitationType invitationType;

  @override
  List<Object?> get props => [contact, groupId, customMessage, invitationType];
}

/// Event to generate invitation link
class GenerateInvitationLink extends ContactInvitationEvent {
  const GenerateInvitationLink({
    required this.groupId,
    this.customMessage,
    this.inviterName,
  });

  final String groupId;
  final String? customMessage;
  final String? inviterName;

  @override
  List<Object?> get props => [groupId, customMessage, inviterName];
}

/// Event to clear search
class ClearSearch extends ContactInvitationEvent {
  const ClearSearch();
}

/// Event to filter contacts by app users only
class FilterAppUsersOnly extends ContactInvitationEvent {
  const FilterAppUsersOnly({required this.appUsersOnly});

  final bool appUsersOnly;

  @override
  List<Object?> get props => [appUsersOnly];
}
