import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:permission_handler/permission_handler.dart';

/// Simple contact helper - no over-engineering
class ContactHelper {
  /// Check if contact permission is granted
  static Future<bool> hasPermission() async {
    final status = await Permission.contacts.status;
    return status == PermissionStatus.granted;
  }

  /// Request contact permission
  static Future<bool> requestPermission() async {
    final status = await Permission.contacts.request();
    return status == PermissionStatus.granted;
  }

  /// Get all contacts (requests permission if needed)
  static Future<List<Contact>> getContacts() async {
    if (!await hasPermission()) {
      final granted = await requestPermission();
      if (!granted) {
        throw Exception('Contact permission denied');
      }
    }

    return await FlutterContacts.getContacts(
      withProperties: true,
      withPhoto: false,
    );
  }

  /// Search contacts by name or phone
  static Future<List<Contact>> searchContacts(String query) async {
    if (query.isEmpty) return getContacts();

    final contacts = await getContacts();
    final lowercaseQuery = query.toLowerCase();

    return contacts.where((contact) {
      // Search by name
      if (contact.displayName.toLowerCase().contains(lowercaseQuery)) {
        return true;
      }

      // Search by phone
      for (final phone in contact.phones) {
        if (phone.number.contains(query)) return true;
      }

      return false;
    }).toList();
  }
}
