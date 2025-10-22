import 'contact_model.dart';

/// {@template contact_user_match}
/// Model representing a match between a contact and an app user
/// {@endtemplate}
class ContactUserMatch {
  /// {@macro contact_user_match}
  const ContactUserMatch({
    required this.contact,
    required this.appUser,
    required this.matchType,
    required this.matchConfidence,
    this.matchedField,
  });

  /// The contact from device
  final ContactModel contact;

  /// The app user that matches
  final AppUser appUser;

  /// Type of match found
  final ContactMatchType matchType;

  /// Confidence level of the match (0.0 to 1.0)
  final double matchConfidence;

  /// The specific field that matched (phone number, email, etc.)
  final String? matchedField;

  /// Create ContactUserMatch from JSON
  factory ContactUserMatch.fromJson(Map<String, dynamic> json) {
    return ContactUserMatch(
      contact: ContactModel.fromJson(json['contact'] as Map<String, dynamic>),
      appUser: AppUser.fromJson(json['appUser'] as Map<String, dynamic>),
      matchType: ContactMatchType.values.firstWhere(
        (type) => type.value == json['matchType'],
        orElse: () => ContactMatchType.phone,
      ),
      matchConfidence: (json['matchConfidence'] as num).toDouble(),
      matchedField: json['matchedField'] as String?,
    );
  }

  /// Convert ContactUserMatch to JSON
  Map<String, dynamic> toJson() {
    return {
      'contact': contact.toJson(),
      'appUser': appUser.toJson(),
      'matchType': matchType.value,
      'matchConfidence': matchConfidence,
      'matchedField': matchedField,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ContactUserMatch &&
        other.contact == contact &&
        other.appUser == appUser &&
        other.matchType == matchType &&
        other.matchConfidence == matchConfidence &&
        other.matchedField == matchedField;
  }

  @override
  int get hashCode {
    return contact.hashCode ^
        appUser.hashCode ^
        matchType.hashCode ^
        matchConfidence.hashCode ^
        matchedField.hashCode;
  }

  @override
  String toString() {
    return 'ContactUserMatch(contact: ${contact.displayName}, appUser: ${appUser.fullName}, confidence: $matchConfidence)';
  }
}

/// {@template app_user}
/// Model representing an app user for contact matching
/// {@endtemplate}
class AppUser {
  /// {@macro app_user}
  const AppUser({
    required this.id,
    required this.fullName,
    this.email,
    this.phoneNumber,
    this.avatarUrl,
    this.isVerified = false,
    this.lastActiveAt,
  });

  /// User ID
  final String id;

  /// Full name
  final String fullName;

  /// Email address
  final String? email;

  /// Phone number
  final String? phoneNumber;

  /// Avatar URL
  final String? avatarUrl;

  /// Whether the user is verified
  final bool isVerified;

  /// Last active timestamp
  final DateTime? lastActiveAt;

  /// Create AppUser from JSON
  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      id: json['id'] as String,
      fullName: json['fullName'] as String,
      email: json['email'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      avatarUrl: json['avatarUrl'] as String?,
      isVerified: json['isVerified'] as bool? ?? false,
      lastActiveAt:
          json['lastActiveAt'] != null
              ? DateTime.parse(json['lastActiveAt'] as String)
              : null,
    );
  }

  /// Convert AppUser to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      'phoneNumber': phoneNumber,
      'avatarUrl': avatarUrl,
      'isVerified': isVerified,
      'lastActiveAt': lastActiveAt?.toIso8601String(),
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AppUser &&
        other.id == id &&
        other.fullName == fullName &&
        other.email == email &&
        other.phoneNumber == phoneNumber &&
        other.avatarUrl == avatarUrl &&
        other.isVerified == isVerified &&
        other.lastActiveAt == lastActiveAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        fullName.hashCode ^
        email.hashCode ^
        phoneNumber.hashCode ^
        avatarUrl.hashCode ^
        isVerified.hashCode ^
        lastActiveAt.hashCode;
  }

  @override
  String toString() {
    return 'AppUser(id: $id, fullName: $fullName, isVerified: $isVerified)';
  }
}

/// {@template contact_match_type}
/// Enum representing the type of match between contact and user
/// {@endtemplate}
enum ContactMatchType {
  phone('phone'),
  email('email'),
  name('name'),
  multiple('multiple');

  const ContactMatchType(this.value);
  final String value;
}

/// {@template contact_invitation_request}
/// Model representing a request to invite someone via contact
/// {@endtemplate}
class ContactInvitationRequest {
  /// {@macro contact_invitation_request}
  const ContactInvitationRequest({
    required this.contact,
    this.appUserId,
    this.groupId,
    this.invitationMessage,
    this.invitationType = ContactInvitationType.shareLink,
  });

  /// The contact to invite
  final ContactModel contact;

  /// App user ID if contact is an app user
  final String? appUserId;

  /// Group ID to invite to
  final String? groupId;

  /// Custom invitation message
  final String? invitationMessage;

  /// Type of invitation to send
  final ContactInvitationType invitationType;

  /// Create ContactInvitationRequest from JSON
  factory ContactInvitationRequest.fromJson(Map<String, dynamic> json) {
    return ContactInvitationRequest(
      contact: ContactModel.fromJson(json['contact'] as Map<String, dynamic>),
      appUserId: json['appUserId'] as String?,
      groupId: json['groupId'] as String?,
      invitationMessage: json['invitationMessage'] as String?,
      invitationType: ContactInvitationType.values.firstWhere(
        (type) => type.value == json['invitationType'],
        orElse: () => ContactInvitationType.shareLink,
      ),
    );
  }

  /// Convert ContactInvitationRequest to JSON
  Map<String, dynamic> toJson() {
    return {
      'contact': contact.toJson(),
      'appUserId': appUserId,
      'groupId': groupId,
      'invitationMessage': invitationMessage,
      'invitationType': invitationType.value,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ContactInvitationRequest &&
        other.contact == contact &&
        other.appUserId == appUserId &&
        other.groupId == groupId &&
        other.invitationMessage == invitationMessage &&
        other.invitationType == invitationType;
  }

  @override
  int get hashCode {
    return contact.hashCode ^
        appUserId.hashCode ^
        groupId.hashCode ^
        invitationMessage.hashCode ^
        invitationType.hashCode;
  }

  @override
  String toString() {
    return 'ContactInvitationRequest(contact: ${contact.displayName}, type: $invitationType)';
  }
}

/// {@template contact_invitation_type}
/// Enum representing the type of invitation to send
/// {@endtemplate}
enum ContactInvitationType {
  email('email'),
  appNotification('app_notification'),
  shareLink('share_link'),
  copyLink('copy_link');

  const ContactInvitationType(this.value);
  final String value;
}
