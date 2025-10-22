import '../models/contact_model.dart';
import '../models/contact_user_match.dart';

/// {@template contact_repository}
/// Abstract repository for contact-related operations
/// {@endtemplate}
abstract class ContactRepository {
  /// Get all contacts from device
  Future<List<ContactModel>> getAllContacts();

  /// Search contacts by query
  Future<List<ContactModel>> searchContacts(String query);

  /// Get contacts with phone numbers only
  Future<List<ContactModel>> getContactsWithPhones();

  /// Find app users that match the given phone numbers
  Future<List<ContactUserMatch>> findUsersByPhoneNumbers(
    List<String> phoneNumbers,
  );

  /// Find app users that match the given email addresses
  Future<List<ContactUserMatch>> findUsersByEmails(List<String> emails);

  /// Sync contacts with app users (bulk operation)
  Future<List<ContactUserMatch>> syncContactsWithUsers(
    List<ContactModel> contacts,
  );

  /// Send invitation to a contact
  Future<Map<String, dynamic>> sendContactInvitation(
    ContactInvitationRequest request,
  );

  /// Generate shareable invitation link
  Future<Map<String, dynamic>> generateInvitationLink({
    required String groupId,
    String? customMessage,
    String? inviterName,
  });

  /// Send email invitation to an email address
  Future<Map<String, dynamic>> sendEmailInvitation({
    required String email,
    required String groupId,
    String? customMessage,
    String? inviterName,
  });

  /// Get contact sync status for current user
  Future<Map<String, dynamic>> getContactSyncStatus();

  /// Update contact sync status
  Future<void> updateContactSyncStatus({
    required DateTime lastSyncTime,
    required int totalContacts,
    required int matchedContacts,
  });

  /// Get contacts that have been invited to groups
  Future<List<ContactInvitationRequest>> getInvitedContacts({String? groupId});

  /// Check if contact permission is granted
  Future<bool> hasContactPermission();

  /// Request contact permission
  Future<bool> requestContactPermission();

  /// Format phone number for display
  String formatPhoneNumber(String phoneNumber);

  /// Normalize phone number for comparison
  String normalizePhoneNumber(String phoneNumber);

  /// Check if two phone numbers are the same
  bool arePhoneNumbersSame(String phone1, String phone2);
}
