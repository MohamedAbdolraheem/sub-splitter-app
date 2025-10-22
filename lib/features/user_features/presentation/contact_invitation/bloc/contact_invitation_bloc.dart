import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import 'package:subscription_splitter_app/core/contacts/models/contact_model.dart';
import 'package:subscription_splitter_app/core/contacts/models/contact_user_match.dart';
import 'package:subscription_splitter_app/core/contacts/repositories/contact_repository.dart';
import 'package:subscription_splitter_app/core/di/service_locator.dart';
import 'package:subscription_splitter_app/features/user_features/domain/repositories/invitation_repository.dart';

part 'contact_invitation_event.dart';
part 'contact_invitation_state.dart';

/// {@template contact_invitation_bloc}
/// BLoC for managing contact invitation functionality
/// {@endtemplate}
class ContactInvitationBloc
    extends Bloc<ContactInvitationEvent, ContactInvitationState> {
  /// {@macro contact_invitation_bloc}
  ContactInvitationBloc() : super(const ContactInvitationInitial()) {
    on<RequestContactPermission>(_onRequestContactPermission);
    on<LoadContacts>(_onLoadContacts);
    on<SearchContacts>(_onSearchContacts);
    on<SyncContactsWithUsers>(_onSyncContactsWithUsers);
    on<SelectContact>(_onSelectContact);
    on<DeselectContact>(_onDeselectContact);
    on<SelectAllContacts>(_onSelectAllContacts);
    on<DeselectAllContacts>(_onDeselectAllContacts);
    on<SendInvitations>(_onSendInvitations);
    on<SendContactInvitation>(_onSendContactInvitation);
    on<GenerateInvitationLink>(_onGenerateInvitationLink);
    on<ClearSearch>(_onClearSearch);
    on<FilterAppUsersOnly>(_onFilterAppUsersOnly);
  }

  final ContactRepository _contactRepository =
      ServiceLocator().contactRepository;
  final InvitationRepository _invitationRepository =
      ServiceLocator().invitationRepository;

  /// Request contact permission
  FutureOr<void> _onRequestContactPermission(
    RequestContactPermission event,
    Emitter<ContactInvitationState> emit,
  ) async {
    try {
      debugPrint('ContactInvitationBloc: Starting contact permission flow...');

      // First emit loading state
      emit(const ContactInvitationLoading());

      debugPrint('ContactInvitationBloc: Requesting contact permission...');
      final granted = await _contactRepository.requestContactPermission();
      debugPrint('ContactInvitationBloc: Permission granted: $granted');

      if (granted) {
        debugPrint(
          'ContactInvitationBloc: Permission granted, loading contacts...',
        );
        add(const LoadContacts());
      } else {
        debugPrint('ContactInvitationBloc: Permission denied');
        emit(const ContactInvitationPermissionDenied());
      }
    } catch (e, stackTrace) {
      debugPrint(
        'ContactInvitationBloc: Error requesting contact permission: $e',
      );
      debugPrint('ContactInvitationBloc: Stack trace: $stackTrace');
      emit(ContactInvitationError(message: 'Failed to request permission: $e'));
    }
  }

  /// Load contacts from device
  FutureOr<void> _onLoadContacts(
    LoadContacts event,
    Emitter<ContactInvitationState> emit,
  ) async {
    try {
      debugPrint('ContactInvitationBloc: Loading contacts...');
      emit(const ContactInvitationLoading());

      final contacts = await _contactRepository.getAllContacts();
      debugPrint('ContactInvitationBloc: Loaded ${contacts.length} contacts');

      emit(ContactInvitationLoaded(contacts: contacts, selectedContacts: []));

      // Auto-sync with app users
      debugPrint('ContactInvitationBloc: Starting auto-sync with app users...');
      add(const SyncContactsWithUsers());
    } catch (e, stackTrace) {
      debugPrint('ContactInvitationBloc: Error loading contacts: $e');
      debugPrint('ContactInvitationBloc: Stack trace: $stackTrace');
      emit(ContactInvitationError(message: 'Failed to load contacts: $e'));
    }
  }

  /// Search contacts
  void _onSearchContacts(
    SearchContacts event,
    Emitter<ContactInvitationState> emit,
  ) {
    if (state is! ContactInvitationLoaded) return;

    final currentState = state as ContactInvitationLoaded;
    emit(currentState.copyWith(searchQuery: event.query));
  }

  /// Sync contacts with app users
  FutureOr<void> _onSyncContactsWithUsers(
    SyncContactsWithUsers event,
    Emitter<ContactInvitationState> emit,
  ) async {
    if (state is! ContactInvitationLoaded) return;

    final currentState = state as ContactInvitationLoaded;
    emit(currentState.copyWith(isLoading: true));

    try {
      // Get contacts with phone numbers only for matching
      final contactsWithPhones =
          currentState.contacts
              .where((contact) => contact.phoneNumbers.isNotEmpty)
              .toList();

      if (contactsWithPhones.isNotEmpty) {
        // Sync with app users
        final matches = await _contactRepository.syncContactsWithUsers(
          contactsWithPhones,
        );

        // Update contacts with app user information
        final updatedContacts =
            currentState.contacts.map((contact) {
              try {
                final match = matches.firstWhere(
                  (match) => _contactRepository.arePhoneNumbersSame(
                    contact.primaryPhoneNumber ?? '',
                    match.contact.primaryPhoneNumber ?? '',
                  ),
                );

                return contact.copyWith(
                  isAppUser: true,
                  appUserId: match.appUser.id,
                  lastSyncTime: DateTime.now(),
                );
              } catch (e) {
                // No match found, return original contact
                return contact;
              }
            }).toList();

        // Update sync status
        final syncStatus = ContactSyncStatus(
          lastSyncTime: DateTime.now(),
          totalContacts: contactsWithPhones.length,
          matchedContacts: matches.length,
          appUsersFound: matches.length,
        );

        emit(
          currentState.copyWith(
            contacts: updatedContacts,
            isLoading: false,
            syncStatus: syncStatus,
          ),
        );

        // Update sync status on server - disabled (endpoint doesn't exist yet)
        // await _contactRepository.updateContactSyncStatus(
        //   lastSyncTime: syncStatus.lastSyncTime,
        //   totalContacts: syncStatus.totalContacts,
        //   matchedContacts: syncStatus.matchedContacts,
        // );
      } else {
        emit(currentState.copyWith(isLoading: false));
      }
    } catch (e) {
      debugPrint('Error syncing contacts with users: $e');
      emit(
        currentState.copyWith(
          isLoading: false,
          error: 'Failed to sync contacts: $e',
        ),
      );
    }
  }

  /// Select a contact
  void _onSelectContact(
    SelectContact event,
    Emitter<ContactInvitationState> emit,
  ) {
    if (state is! ContactInvitationLoaded) return;

    final currentState = state as ContactInvitationLoaded;
    final selectedContacts = List<ContactModel>.from(
      currentState.selectedContacts,
    );

    if (!selectedContacts.contains(event.contact)) {
      selectedContacts.add(event.contact);
    }

    emit(currentState.copyWith(selectedContacts: selectedContacts));
  }

  /// Deselect a contact
  void _onDeselectContact(
    DeselectContact event,
    Emitter<ContactInvitationState> emit,
  ) {
    if (state is! ContactInvitationLoaded) return;

    final currentState = state as ContactInvitationLoaded;
    final selectedContacts = List<ContactModel>.from(
      currentState.selectedContacts,
    );
    selectedContacts.remove(event.contact);

    emit(currentState.copyWith(selectedContacts: selectedContacts));
  }

  /// Select all contacts
  void _onSelectAllContacts(
    SelectAllContacts event,
    Emitter<ContactInvitationState> emit,
  ) {
    if (state is! ContactInvitationLoaded) return;

    final currentState = state as ContactInvitationLoaded;
    final filteredContacts = currentState.filteredContacts;

    emit(currentState.copyWith(selectedContacts: filteredContacts));
  }

  /// Deselect all contacts
  void _onDeselectAllContacts(
    DeselectAllContacts event,
    Emitter<ContactInvitationState> emit,
  ) {
    if (state is! ContactInvitationLoaded) return;

    final currentState = state as ContactInvitationLoaded;
    emit(currentState.copyWith(selectedContacts: []));
  }

  /// Send invitations to selected contacts
  FutureOr<void> _onSendInvitations(
    SendInvitations event,
    Emitter<ContactInvitationState> emit,
  ) async {
    if (state is! ContactInvitationLoaded) return;

    final currentState = state as ContactInvitationLoaded;
    emit(currentState.copyWith(isSending: true, error: null));

    try {
      // For share link and copy link, generate the link first
      if (event.invitationType == ContactInvitationType.shareLink ||
          event.invitationType == ContactInvitationType.copyLink) {
        try {
          final invitationLink = await _invitationRepository
              .generateInvitationLink(
                groupId: event.groupId,
                customMessage: event.customMessage,
              );

          emit(
            ContactInvitationLinkGenerated(
              invitationLink: invitationLink,
              groupId: event.groupId,
              message: 'Invitation link generated successfully',
            ),
          );
          return;
        } catch (e) {
          debugPrint('Failed to generate invitation link: $e');
          emit(
            currentState.copyWith(
              isSending: false,
              error: 'Failed to generate invitation link: $e',
            ),
          );
          return;
        }
      }

      // For other invitation types (email, app notification)
      int sentCount = 0;
      int totalCount = currentState.selectedContacts.length;

      for (final contact in currentState.selectedContacts) {
        try {
          if (event.invitationType == ContactInvitationType.appNotification &&
              contact.isAppUser &&
              contact.appUserId != null) {
            // Send app notification
            await _invitationRepository.sendAppNotification(
              userId: contact.appUserId!,
              groupId: event.groupId,
              customMessage: event.customMessage,
            );
            sentCount++;
          } else if (event.invitationType == ContactInvitationType.email) {
            // Send email invitation
            final email = contact.emails.firstOrNull;
            if (email != null) {
              await _invitationRepository.sendEmailInvitation(
                email: email.address,
                groupId: event.groupId,
                customMessage: event.customMessage,
              );
              sentCount++;
            }
          }
        } catch (e) {
          debugPrint('Failed to send invitation to ${contact.displayName}: $e');
        }
      }

      emit(
        ContactInvitationSuccess(
          sentCount: sentCount,
          totalCount: totalCount,
          message: 'Invitations sent successfully',
        ),
      );
    } catch (e) {
      debugPrint('Error sending invitations: $e');
      emit(
        currentState.copyWith(
          isSending: false,
          error: 'Failed to send invitations: $e',
        ),
      );
    }
  }

  /// Send invitation to a specific contact
  FutureOr<void> _onSendContactInvitation(
    SendContactInvitation event,
    Emitter<ContactInvitationState> emit,
  ) async {
    if (state is! ContactInvitationLoaded) return;

    final currentState = state as ContactInvitationLoaded;
    emit(currentState.copyWith(isSending: true, error: null));

    try {
      if (event.invitationType == ContactInvitationType.appNotification) {
        // Send app notification
        await _invitationRepository.sendAppNotification(
          userId: event.contact.appUserId!,
          groupId: event.groupId,
          customMessage: event.customMessage,
        );
      } else if (event.invitationType == ContactInvitationType.email) {
        // Send email invitation
        final email = event.contact.emails.firstOrNull;
        if (email != null) {
          await _invitationRepository.sendEmailInvitation(
            email: email.address,
            groupId: event.groupId,
            customMessage: event.customMessage,
          );
        }
      }

      emit(
        const ContactInvitationSuccess(
          sentCount: 1,
          totalCount: 1,
          message: 'Invitation sent successfully',
        ),
      );
    } catch (e) {
      debugPrint('Error sending contact invitation: $e');
      emit(
        currentState.copyWith(
          isSending: false,
          error: 'Failed to send invitation: $e',
        ),
      );
    }
  }

  /// Generate invitation link
  FutureOr<void> _onGenerateInvitationLink(
    GenerateInvitationLink event,
    Emitter<ContactInvitationState> emit,
  ) async {
    try {
      final invitationLink = await _invitationRepository.generateInvitationLink(
        groupId: event.groupId,
        customMessage: event.customMessage,
      );

      emit(
        ContactInvitationLinkGenerated(
          invitationLink: invitationLink,
          groupId: event.groupId,
          message: 'Invitation link generated successfully',
        ),
      );
    } catch (e) {
      debugPrint('Error generating invitation link: $e');
      emit(
        ContactInvitationError(
          message: 'Failed to generate invitation link: $e',
        ),
      );
    }
  }

  /// Clear search
  void _onClearSearch(ClearSearch event, Emitter<ContactInvitationState> emit) {
    if (state is! ContactInvitationLoaded) return;

    final currentState = state as ContactInvitationLoaded;
    emit(currentState.copyWith(searchQuery: ''));
  }

  /// Filter app users only
  void _onFilterAppUsersOnly(
    FilterAppUsersOnly event,
    Emitter<ContactInvitationState> emit,
  ) {
    if (state is! ContactInvitationLoaded) return;

    final currentState = state as ContactInvitationLoaded;
    emit(currentState.copyWith(isAppUsersOnly: event.appUsersOnly));
  }
}
