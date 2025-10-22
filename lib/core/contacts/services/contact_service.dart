import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:subscription_splitter_app/core/contacts/models/contact_model.dart';

/// {@template contact_service}
/// Service for accessing device contacts with permission handling
/// {@endtemplate}
class ContactService {
  static ContactService? _instance;
  static ContactService get instance => _instance ??= ContactService._();

  ContactService._();

  /// Check if contact permission is granted using permission_handler
  Future<bool> hasContactPermission() async {
    try {
      debugPrint('ContactService: Checking contact permission...');

      final status = await Permission.contacts.status;
      final isGranted = status == PermissionStatus.granted;
      debugPrint(
        'ContactService: Permission status: $status (granted: $isGranted)',
      );

      return isGranted;
    } catch (e) {
      debugPrint('ContactService: Error checking contact permission: $e');
      return false;
    }
  }

  /// Check if contact permission is permanently denied
  Future<bool> isPermissionPermanentlyDenied() async {
    try {
      final status = await Permission.contacts.status;
      return status == PermissionStatus.permanentlyDenied;
    } catch (e) {
      debugPrint('ContactService: Error checking permission status: $e');
      return false;
    }
  }

  /// Open app settings for user to manually grant permission
  Future<void> openAppSettingsForPermission() async {
    try {
      await openAppSettings();
      debugPrint('ContactService: Opened app settings');
    } catch (e) {
      debugPrint('ContactService: Error opening app settings: $e');
    }
  }

  /// Request contact permission using permission_handler
  Future<bool> requestContactPermission() async {
    try {
      debugPrint('ContactService: Requesting contact permission...');

      final currentStatus = await Permission.contacts.status;
      debugPrint('ContactService: Current permission status: $currentStatus');

      // If already granted, return true
      if (currentStatus == PermissionStatus.granted) {
        debugPrint('ContactService: Permission already granted');
        return true;
      }

      // If permanently denied, we can't request again
      if (currentStatus == PermissionStatus.permanentlyDenied) {
        debugPrint(
          'ContactService: Permission permanently denied. User must enable in settings.',
        );
        return false;
      }

      // Request permission using flutter_contacts directly
      debugPrint(
        'ContactService: Requesting permission via FlutterContacts...',
      );
      try {
        final granted = await FlutterContacts.requestPermission();
        debugPrint(
          'ContactService: FlutterContacts permission result: $granted',
        );
        return granted;
      } catch (e) {
        debugPrint('ContactService: FlutterContacts permission error: $e');

        // Fallback to permission_handler
        debugPrint(
          'ContactService: Fallback to Permission.contacts.request()...',
        );
        final status = await Permission.contacts.request();
        final isGranted = status == PermissionStatus.granted;
        debugPrint(
          'ContactService: Permission request result: $status (granted: $isGranted)',
        );
        return isGranted;
      }
    } catch (e) {
      debugPrint('ContactService: Error requesting contact permission: $e');
      return false;
    }
  }

  /// Get all contacts from device
  Future<List<ContactModel>> getAllContacts() async {
    try {
      debugPrint('ContactService: Getting all contacts...');

      // Ensure we have permission
      final hasPermission = await hasContactPermission();
      if (!hasPermission) {
        debugPrint(
          'ContactService: Permission denied, requesting permission...',
        );
        final permissionGranted = await requestContactPermission();
        if (!permissionGranted) {
          throw ContactPermissionException(
            'Contact permission denied. Please enable in Settings.',
          );
        }
      }

      debugPrint('ContactService: Permission granted, fetching contacts...');
      final List<Contact> contacts = await FlutterContacts.getContacts(
        withProperties: true,
        withPhoto: false,
      );

      debugPrint(
        'ContactService: Successfully fetched ${contacts.length} contacts',
      );
      return contacts
          .map((contact) => _convertFlutterContactToModel(contact))
          .toList();
    } on ContactPermissionException {
      rethrow; // Re-throw permission exceptions as-is
    } catch (e) {
      debugPrint('ContactService: Error getting contacts: $e');
      throw ContactServiceException('Failed to get contacts: $e');
    }
  }

  /// Search contacts by name or phone number
  Future<List<ContactModel>> searchContacts(String query) async {
    try {
      final allContacts = await getAllContacts();

      if (query.isEmpty) return allContacts;

      final lowercaseQuery = query.toLowerCase();

      return allContacts.where((contact) {
        // Search by name
        final nameMatch = contact.displayName.toLowerCase().contains(
          lowercaseQuery,
        );

        // Search by phone numbers
        final phoneMatch = contact.phoneNumbers.any(
          (phone) => phone.number
              .replaceAll(RegExp(r'[^\d]'), '')
              .contains(query.replaceAll(RegExp(r'[^\d]'), '')),
        );

        // Search by email
        final emailMatch = contact.emails.any(
          (email) => email.address.toLowerCase().contains(lowercaseQuery),
        );

        return nameMatch || phoneMatch || emailMatch;
      }).toList();
    } catch (e) {
      debugPrint('Error searching contacts: $e');
      throw ContactServiceException('Failed to search contacts: $e');
    }
  }

  /// Get contacts with phone numbers only
  Future<List<ContactModel>> getContactsWithPhones() async {
    try {
      final allContacts = await getAllContacts();

      return allContacts
          .where((contact) => contact.phoneNumbers.isNotEmpty)
          .toList();
    } catch (e) {
      debugPrint('Error getting contacts with phones: $e');
      throw ContactServiceException('Failed to get contacts with phones: $e');
    }
  }

  /// Format phone number for display
  String formatPhoneNumber(String phoneNumber) {
    // Remove all non-digit characters
    final digits = phoneNumber.replaceAll(RegExp(r'[^\d]'), '');

    // Basic formatting for common patterns
    if (digits.length >= 10) {
      // US format: (XXX) XXX-XXXX
      if (digits.length == 10) {
        return '(${digits.substring(0, 3)}) ${digits.substring(3, 6)}-${digits.substring(6)}';
      }
      // International format: +X XXX XXX XXXX
      else if (digits.length == 11 && digits.startsWith('1')) {
        return '+1 (${digits.substring(1, 4)}) ${digits.substring(4, 7)}-${digits.substring(7)}';
      }
    }

    return phoneNumber; // Return original if can't format
  }

  /// Normalize phone number for comparison
  String normalizePhoneNumber(String phoneNumber) {
    // Remove all non-digit characters and leading zeros
    String normalized = phoneNumber.replaceAll(RegExp(r'[^\d]'), '');

    // Remove leading zeros
    while (normalized.startsWith('0') && normalized.length > 1) {
      normalized = normalized.substring(1);
    }

    return normalized;
  }

  /// Check if two phone numbers are the same
  bool arePhoneNumbersSame(String phone1, String phone2) {
    final normalized1 = normalizePhoneNumber(phone1);
    final normalized2 = normalizePhoneNumber(phone2);

    // Check exact match
    if (normalized1 == normalized2) return true;

    // Check if one is a subset of the other (e.g., +1 555-1234 vs 555-1234)
    if (normalized1.length > normalized2.length) {
      return normalized1.endsWith(normalized2);
    } else if (normalized2.length > normalized1.length) {
      return normalized2.endsWith(normalized1);
    }

    return false;
  }

  /// Convert FlutterContacts Contact to our ContactModel
  ContactModel _convertFlutterContactToModel(Contact contact) {
    // Convert phone numbers
    final phoneNumbers =
        contact.phones
            .map(
              (phone) => ContactPhoneNumber(
                number: phone.number,
                type: _convertPhoneType(phone.label),
                label: phone.label.name,
              ),
            )
            .toList();

    // Convert emails
    final emails =
        contact.emails
            .map(
              (email) => ContactEmail(
                address: email.address,
                type: _convertEmailType(email.label),
                label: email.label.name,
              ),
            )
            .toList();

    return ContactModel(
      id: contact.id,
      displayName:
          contact.displayName.isNotEmpty ? contact.displayName : 'Unknown',
      firstName: contact.name.first,
      lastName: contact.name.last,
      phoneNumbers: phoneNumbers,
      emails: emails,
      avatar: contact.photo?.toString(),
      isAppUser: false, // Will be updated during sync
      appUserId: null,
      lastSyncTime: null,
    );
  }

  /// Convert FlutterContacts phone label to our ContactPhoneType
  ContactPhoneType _convertPhoneType(PhoneLabel label) {
    switch (label) {
      case PhoneLabel.mobile:
        return ContactPhoneType.mobile;
      case PhoneLabel.home:
        return ContactPhoneType.home;
      case PhoneLabel.work:
        return ContactPhoneType.work;
      default:
        return ContactPhoneType.other;
    }
  }

  /// Convert FlutterContacts email label to our ContactEmailType
  ContactEmailType _convertEmailType(EmailLabel label) {
    switch (label) {
      case EmailLabel.work:
        return ContactEmailType.work;
      case EmailLabel.home:
        return ContactEmailType.personal;
      default:
        return ContactEmailType.other;
    }
  }
}

/// Exception thrown when contact permission is denied
class ContactPermissionException implements Exception {
  final String message;
  ContactPermissionException(this.message);

  @override
  String toString() => 'ContactPermissionException: $message';
}

/// Exception thrown when contact service operations fail
class ContactServiceException implements Exception {
  final String message;
  ContactServiceException(this.message);

  @override
  String toString() => 'ContactServiceException: $message';
}
