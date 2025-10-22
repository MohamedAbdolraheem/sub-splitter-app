import '../models/contact_model.dart';
import '../models/contact_user_match.dart';
import '../services/contact_service.dart';
import '../services/contact_api_service.dart';
import 'contact_repository.dart';

/// {@template contact_repository_impl}
/// Implementation of contact repository using ContactService and ContactApiService
/// {@endtemplate}
class ContactRepositoryImpl implements ContactRepository {
  /// {@macro contact_repository_impl}
  const ContactRepositoryImpl({
    required this.contactService,
    required this.apiService,
  });

  final ContactService contactService;
  final ContactApiService apiService;

  @override
  Future<List<ContactModel>> getAllContacts() async {
    return await contactService.getAllContacts();
  }

  @override
  Future<List<ContactModel>> searchContacts(String query) async {
    return await contactService.searchContacts(query);
  }

  @override
  Future<List<ContactModel>> getContactsWithPhones() async {
    return await contactService.getContactsWithPhones();
  }

  @override
  Future<List<ContactUserMatch>> findUsersByPhoneNumbers(
    List<String> phoneNumbers,
  ) async {
    return await apiService.findUsersByPhoneNumbers(phoneNumbers);
  }

  @override
  Future<List<ContactUserMatch>> findUsersByEmails(List<String> emails) async {
    return await apiService.findUsersByEmails(emails);
  }

  @override
  Future<List<ContactUserMatch>> syncContactsWithUsers(
    List<ContactModel> contacts,
  ) async {
    return await apiService.syncContactsWithUsers(contacts);
  }

  @override
  Future<Map<String, dynamic>> sendContactInvitation(
    ContactInvitationRequest request,
  ) async {
    return await apiService.sendContactInvitation(request);
  }

  @override
  Future<Map<String, dynamic>> generateInvitationLink({
    required String groupId,
    String? customMessage,
    String? inviterName,
  }) async {
    return await apiService.generateInvitationLink(
      groupId: groupId,
      customMessage: customMessage,
      inviterName: inviterName,
    );
  }

  @override
  Future<Map<String, dynamic>> sendEmailInvitation({
    required String email,
    required String groupId,
    String? customMessage,
    String? inviterName,
  }) async {
    return await apiService.sendEmailInvitation(
      email: email,
      groupId: groupId,
      customMessage: customMessage,
      inviterName: inviterName,
    );
  }

  @override
  Future<Map<String, dynamic>> getContactSyncStatus() async {
    return await apiService.getContactSyncStatus();
  }

  @override
  Future<void> updateContactSyncStatus({
    required DateTime lastSyncTime,
    required int totalContacts,
    required int matchedContacts,
  }) async {
    await apiService.updateContactSyncStatus(
      lastSyncTime: lastSyncTime,
      totalContacts: totalContacts,
      matchedContacts: matchedContacts,
    );
  }

  @override
  Future<List<ContactInvitationRequest>> getInvitedContacts({
    String? groupId,
  }) async {
    return await apiService.getInvitedContacts(groupId: groupId);
  }

  @override
  Future<bool> hasContactPermission() async {
    return await contactService.hasContactPermission();
  }

  @override
  Future<bool> requestContactPermission() async {
    return await contactService.requestContactPermission();
  }

  @override
  String formatPhoneNumber(String phoneNumber) {
    return contactService.formatPhoneNumber(phoneNumber);
  }

  @override
  String normalizePhoneNumber(String phoneNumber) {
    return contactService.normalizePhoneNumber(phoneNumber);
  }

  @override
  bool arePhoneNumbersSame(String phone1, String phone2) {
    return contactService.arePhoneNumbersSame(phone1, phone2);
  }
}
