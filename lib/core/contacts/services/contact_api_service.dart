import 'package:flutter/foundation.dart';
import 'package:subscription_splitter_app/core/contacts/models/contact_model.dart';

import '../../constants/api_endpoints.dart';

import '../models/contact_user_match.dart';
import '../../network/dio_client.dart';
import 'contact_service.dart';

/// {@template contact_api_service}
/// Service for contact-related API operations
/// {@endtemplate}
class ContactApiService {
  /// {@macro contact_api_service}
  ContactApiService({required this.apiService});

  final ApiService apiService;
  final ContactService _contactService = ContactService.instance;

  /// Format phone number for API (Saudi Arabia format)
  String _formatPhoneForAPI(String phoneNumber) {
    // Remove all non-digit characters
    String digits = phoneNumber.replaceAll(RegExp(r'[^\d]'), '');

    // Handle Saudi Arabia numbers
    if (digits.startsWith('966')) {
      // Remove country code 966 and add leading 0
      final localNumber = digits.substring(3);
      if (localNumber.length == 9) {
        return '0$localNumber'; // +966599060389 -> 0599060389
      }
    }

    // Handle numbers that already start with 0
    if (digits.startsWith('0') && digits.length == 10) {
      return digits; // Already in correct format
    }

    // Handle US numbers (10 digits)
    if (digits.length == 10 && !digits.startsWith('0')) {
      return digits; // Keep as is for US numbers
    }

    // Default: return normalized version
    return _contactService.normalizePhoneNumber(phoneNumber);
  }

  /// Find app users that match the given phone numbers
  Future<List<ContactUserMatch>> findUsersByPhoneNumbers(
    List<String> phoneNumbers,
  ) async {
    try {
      debugPrint(
        'ContactApiService: Searching for ${phoneNumbers.length} phone numbers',
      );

      // Normalize phone numbers for Saudi Arabia format
      final normalizedPhones =
          phoneNumbers.map((phone) {
            return _formatPhoneForAPI(phone);
          }).toList();

      debugPrint('ContactApiService: Original phone numbers: $phoneNumbers');
      debugPrint(
        'ContactApiService: Normalized phone numbers: $normalizedPhones',
      );

      final response = await apiService.post(
        ApiEndpoints.findUsersByPhones,
        data: {'phones': normalizedPhones},
      );

      if (response == null || response['data'] == null) {
        debugPrint('ContactApiService: No data in response');
        return [];
      }

      // Backend returns data object with results array
      final data = response['data'] as Map<String, dynamic>;
      final results = data['results'] as List<dynamic>?;

      if (results == null) {
        debugPrint('ContactApiService: No results in response data');
        return [];
      }

      // Filter only found users (where user is not null)
      final foundUsers =
          results.where((result) {
            final resultMap = result as Map<String, dynamic>;
            return resultMap['found'] == true && resultMap['user'] != null;
          }).toList();

      debugPrint(
        'ContactApiService: Found ${foundUsers.length} matches out of ${results.length} results',
      );

      // Convert backend response to ContactUserMatch format
      return foundUsers.map((result) {
        final resultMap = result as Map<String, dynamic>;
        final user = resultMap['user'] as Map<String, dynamic>;
        final phone = resultMap['phone'] as String;

        // Create a simple ContactUserMatch from the backend response
        return ContactUserMatch(
          contact: ContactModel(
            id: 'contact_${phone.hashCode}',
            displayName: user['full_name'] ?? 'Unknown',
            phoneNumbers: [ContactPhoneNumber(number: phone, label: 'mobile')],
            emails: [],
            avatar: null,
          ),
          appUser: AppUser(
            id: user['id'] ?? '',
            fullName: user['full_name'] ?? 'Unknown',
            email: user['email'] ?? '',
            phoneNumber: phone,
            avatarUrl: user['avatar_url'],
            isVerified: user['is_verified'] ?? false,
            lastActiveAt: user['last_active_at'],
          ),
          matchType: ContactMatchType.phone,
          matchConfidence: 1.0,
          matchedField: phone,
        );
      }).toList();
    } catch (e) {
      debugPrint('Error finding users by phone numbers: $e');
      return [];
    }
  }

  /// Find app users that match the given email addresses
  Future<List<ContactUserMatch>> findUsersByEmails(List<String> emails) async {
    try {
      final response = await apiService.post(
        ApiEndpoints.findUsersByEmails,
        data: {'emails': emails},
      );

      if (response == null || response['data'] == null) {
        return [];
      }

      final List<dynamic> matchesJson = response['data'] as List<dynamic>;

      return matchesJson
          .map((json) => ContactUserMatch.fromJson(json))
          .toList();
    } catch (e) {
      debugPrint('Error finding users by emails: $e');
      throw ContactApiException('Failed to find users by emails: $e');
    }
  }

  /// Sync contacts with app users (bulk operation)
  Future<List<ContactUserMatch>> syncContactsWithUsers(
    List<ContactModel> contacts,
  ) async {
    try {
      // Extract phone numbers from contacts (email lookup disabled for now)
      final phoneNumbers = <String>[];

      for (final contact in contacts) {
        phoneNumbers.addAll(contact.phoneNumbers.map((phone) => phone.number));
      }

      // Find matches for phone numbers (email endpoint doesn't exist yet)
      List<ContactUserMatch> phoneMatches = [];
      try {
        phoneMatches = await findUsersByPhoneNumbers(phoneNumbers);
        debugPrint(
          'ContactApiService: Found ${phoneMatches.length} phone matches',
        );
      } catch (e) {
        debugPrint('ContactApiService: Phone number lookup failed: $e');
      }

      // Email lookup disabled - endpoint doesn't exist yet
      // final emailMatches = await findUsersByEmails(emails);

      // Combine and deduplicate matches
      final allMatches = <String, ContactUserMatch>{};

      for (final match in phoneMatches) {
        allMatches[match.appUser.id] = match;
      }

      // Email matches processing disabled - endpoint doesn't exist yet
      // for (final match in emailMatches) {
      //   if (allMatches.containsKey(match.appUser.id)) {
      //     // Update existing match with higher confidence or multiple match type
      //     final existing = allMatches[match.appUser.id]!;
      //     if (match.matchConfidence > existing.matchConfidence) {
      //       allMatches[match.appUser.id] = match.copyWith(
      //         matchType: ContactMatchType.multiple,
      //         matchConfidence:
      //             (match.matchConfidence + existing.matchConfidence) / 2,
      //       );
      //     }
      //   } else {
      //     allMatches[match.appUser.id] = match;
      //   }
      // }

      return allMatches.values.toList();
    } catch (e) {
      debugPrint('Error syncing contacts with users: $e');
      throw ContactApiException('Failed to sync contacts with users: $e');
    }
  }

  /// Send invitation to a contact
  Future<Map<String, dynamic>> sendContactInvitation(
    ContactInvitationRequest request,
  ) async {
    try {
      final response = await apiService.post(
        ApiEndpoints.sendEmailInvitation,
        data: request.toJson(),
      );

      return response ?? {};
    } catch (e) {
      debugPrint('Error sending contact invitation: $e');
      throw ContactApiException('Failed to send contact invitation: $e');
    }
  }

  /// Generate shareable invitation link
  Future<Map<String, dynamic>> generateInvitationLink({
    required String groupId,
    String? customMessage,
    String? inviterName,
  }) async {
    try {
      final response = await apiService.post(
        ApiEndpoints.generateInvitationLink,
        data: {
          'groupId': groupId,
          'customMessage': customMessage,
          'inviterName': inviterName,
        },
      );

      return response ?? {};
    } catch (e) {
      debugPrint('Error generating invitation link: $e');
      throw ContactApiException('Failed to generate invitation link: $e');
    }
  }

  /// Send email invitation to an email address
  Future<Map<String, dynamic>> sendEmailInvitation({
    required String email,
    required String groupId,
    String? customMessage,
    String? inviterName,
  }) async {
    try {
      final response = await apiService.post(
        '/contacts/send-email-invitation',
        data: {
          'email': email,
          'groupId': groupId,
          'customMessage': customMessage,
          'inviterName': inviterName,
        },
      );

      return response ?? {};
    } catch (e) {
      debugPrint('Error sending email invitation: $e');
      throw ContactApiException('Failed to send email invitation: $e');
    }
  }

  /// Get contact sync status for current user - disabled (endpoint doesn't exist yet)
  Future<Map<String, dynamic>> getContactSyncStatus() async {
    // TODO: Enable when backend endpoint is available
    debugPrint(
      'ContactApiService: getContactSyncStatus disabled - endpoint not available',
    );
    return {};

    // try {
    //   final response = await apiService.get('/contacts/sync-status');
    //   return response ?? {};
    // } catch (e) {
    //   debugPrint('Error getting contact sync status: $e');
    //   throw ContactApiException('Failed to get contact sync status: $e');
    // }
  }

  /// Update contact sync status - disabled (endpoint doesn't exist yet)
  Future<void> updateContactSyncStatus({
    required DateTime lastSyncTime,
    required int totalContacts,
    required int matchedContacts,
  }) async {
    // TODO: Enable when backend endpoint is available
    debugPrint(
      'ContactApiService: updateContactSyncStatus disabled - endpoint not available',
    );
    return;

    // try {
    //   await apiService.post(
    //     '/contacts/sync-status',
    //     data: {
    //       'lastSyncTime': lastSyncTime.toIso8601String(),
    //       'totalContacts': totalContacts,
    //       'matchedContacts': matchedContacts,
    //     },
    //   );
    // } catch (e) {
    //   debugPrint('Error updating contact sync status: $e');
    //   throw ContactApiException('Failed to update contact sync status: $e');
    // }
  }

  /// Get contacts that have been invited to groups
  Future<List<ContactInvitationRequest>> getInvitedContacts({
    String? groupId,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (groupId != null) {
        queryParams['groupId'] = groupId;
      }

      final response = await apiService.get(
        '/contacts/invited',
        queryParameters: queryParams,
      );

      if (response == null || response['data'] == null) {
        return [];
      }

      final List<dynamic> invitationsJson = response['data'] as List<dynamic>;

      return invitationsJson
          .map((json) => ContactInvitationRequest.fromJson(json))
          .toList();
    } catch (e) {
      debugPrint('Error getting invited contacts: $e');
      throw ContactApiException('Failed to get invited contacts: $e');
    }
  }
}

/// Extension to add copyWith method to ContactUserMatch
extension ContactUserMatchCopyWith on ContactUserMatch {
  ContactUserMatch copyWith({
    ContactModel? contact,
    AppUser? appUser,
    ContactMatchType? matchType,
    double? matchConfidence,
    String? matchedField,
  }) {
    return ContactUserMatch(
      contact: contact ?? this.contact,
      appUser: appUser ?? this.appUser,
      matchType: matchType ?? this.matchType,
      matchConfidence: matchConfidence ?? this.matchConfidence,
      matchedField: matchedField ?? this.matchedField,
    );
  }
}

/// Exception thrown when contact API operations fail
class ContactApiException implements Exception {
  final String message;
  ContactApiException(this.message);

  @override
  String toString() => 'ContactApiException: $message';
}
