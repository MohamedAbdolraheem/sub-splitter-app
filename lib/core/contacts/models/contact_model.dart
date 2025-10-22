/// {@template contact_model}
/// Model representing a contact from the device
/// {@endtemplate}
class ContactModel {
  /// {@macro contact_model}
  const ContactModel({
    required this.id,
    required this.displayName,
    this.firstName,
    this.lastName,
    this.phoneNumbers = const [],
    this.emails = const [],
    this.avatar,
    this.isAppUser = false,
    this.appUserId,
    this.lastSyncTime,
  });

  /// Unique identifier for the contact
  final String id;

  /// Display name for the contact
  final String displayName;

  /// First name
  final String? firstName;

  /// Last name
  final String? lastName;

  /// List of phone numbers
  final List<ContactPhoneNumber> phoneNumbers;

  /// List of email addresses
  final List<ContactEmail> emails;

  /// Avatar/photo URI
  final String? avatar;

  /// Whether this contact is a user of the app
  final bool isAppUser;

  /// App user ID if this contact is a user
  final String? appUserId;

  /// Last time this contact was synced with app users
  final DateTime? lastSyncTime;

  /// Primary phone number (first one or best formatted)
  String? get primaryPhoneNumber {
    if (phoneNumbers.isEmpty) return null;

    // Try to find a mobile number first
    final mobileNumber = phoneNumbers.firstWhere(
      (phone) => phone.type == ContactPhoneType.mobile,
      orElse: () => phoneNumbers.first,
    );

    return mobileNumber.number;
  }

  /// Primary email address
  String? get primaryEmail {
    if (emails.isEmpty) return null;

    // Try to find a personal email first
    final personalEmail = emails.firstWhere(
      (email) => email.type == ContactEmailType.personal,
      orElse: () => emails.first,
    );

    return personalEmail.address;
  }

  /// Create ContactModel from JSON
  factory ContactModel.fromJson(Map<String, dynamic> json) {
    return ContactModel(
      id: json['id'] as String,
      displayName: json['displayName'] as String,
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      phoneNumbers:
          (json['phoneNumbers'] as List<dynamic>?)
              ?.map((phone) => ContactPhoneNumber.fromJson(phone))
              .toList() ??
          [],
      emails:
          (json['emails'] as List<dynamic>?)
              ?.map((email) => ContactEmail.fromJson(email))
              .toList() ??
          [],
      avatar: json['avatar'] as String?,
      isAppUser: json['isAppUser'] as bool? ?? false,
      appUserId: json['appUserId'] as String?,
      lastSyncTime:
          json['lastSyncTime'] != null
              ? DateTime.parse(json['lastSyncTime'] as String)
              : null,
    );
  }

  /// Convert ContactModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'displayName': displayName,
      'firstName': firstName,
      'lastName': lastName,
      'phoneNumbers': phoneNumbers.map((phone) => phone.toJson()).toList(),
      'emails': emails.map((email) => email.toJson()).toList(),
      'avatar': avatar,
      'isAppUser': isAppUser,
      'appUserId': appUserId,
      'lastSyncTime': lastSyncTime?.toIso8601String(),
    };
  }

  /// Create a copy with updated fields
  ContactModel copyWith({
    String? id,
    String? displayName,
    String? firstName,
    String? lastName,
    List<ContactPhoneNumber>? phoneNumbers,
    List<ContactEmail>? emails,
    String? avatar,
    bool? isAppUser,
    String? appUserId,
    DateTime? lastSyncTime,
  }) {
    return ContactModel(
      id: id ?? this.id,
      displayName: displayName ?? this.displayName,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phoneNumbers: phoneNumbers ?? this.phoneNumbers,
      emails: emails ?? this.emails,
      avatar: avatar ?? this.avatar,
      isAppUser: isAppUser ?? this.isAppUser,
      appUserId: appUserId ?? this.appUserId,
      lastSyncTime: lastSyncTime ?? this.lastSyncTime,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ContactModel &&
        other.id == id &&
        other.displayName == displayName &&
        other.firstName == firstName &&
        other.lastName == lastName &&
        other.phoneNumbers == phoneNumbers &&
        other.emails == emails &&
        other.avatar == avatar &&
        other.isAppUser == isAppUser &&
        other.appUserId == appUserId &&
        other.lastSyncTime == lastSyncTime;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        displayName.hashCode ^
        firstName.hashCode ^
        lastName.hashCode ^
        phoneNumbers.hashCode ^
        emails.hashCode ^
        avatar.hashCode ^
        isAppUser.hashCode ^
        appUserId.hashCode ^
        lastSyncTime.hashCode;
  }

  @override
  String toString() {
    return 'ContactModel(id: $id, displayName: $displayName, isAppUser: $isAppUser)';
  }
}

/// {@template contact_phone_number}
/// Model representing a phone number in a contact
/// {@endtemplate}
class ContactPhoneNumber {
  /// {@macro contact_phone_number}
  const ContactPhoneNumber({
    required this.number,
    this.type = ContactPhoneType.other,
    this.label,
  });

  /// The phone number
  final String number;

  /// Type of phone number
  final ContactPhoneType type;

  /// Custom label for the phone number
  final String? label;

  /// Create ContactPhoneNumber from JSON
  factory ContactPhoneNumber.fromJson(Map<String, dynamic> json) {
    return ContactPhoneNumber(
      number: json['number'] as String,
      type: ContactPhoneType.values.firstWhere(
        (type) => type.value == json['type'],
        orElse: () => ContactPhoneType.other,
      ),
      label: json['label'] as String?,
    );
  }

  /// Convert ContactPhoneNumber to JSON
  Map<String, dynamic> toJson() {
    return {'number': number, 'type': type.value, 'label': label};
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ContactPhoneNumber &&
        other.number == number &&
        other.type == type &&
        other.label == label;
  }

  @override
  int get hashCode => number.hashCode ^ type.hashCode ^ label.hashCode;

  @override
  String toString() {
    return 'ContactPhoneNumber(number: $number, type: $type)';
  }
}

/// {@template contact_email}
/// Model representing an email address in a contact
/// {@endtemplate}
class ContactEmail {
  /// {@macro contact_email}
  const ContactEmail({
    required this.address,
    this.type = ContactEmailType.other,
    this.label,
  });

  /// The email address
  final String address;

  /// Type of email address
  final ContactEmailType type;

  /// Custom label for the email
  final String? label;

  /// Create ContactEmail from JSON
  factory ContactEmail.fromJson(Map<String, dynamic> json) {
    return ContactEmail(
      address: json['address'] as String,
      type: ContactEmailType.values.firstWhere(
        (type) => type.value == json['type'],
        orElse: () => ContactEmailType.other,
      ),
      label: json['label'] as String?,
    );
  }

  /// Convert ContactEmail to JSON
  Map<String, dynamic> toJson() {
    return {'address': address, 'type': type.value, 'label': label};
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ContactEmail &&
        other.address == address &&
        other.type == type &&
        other.label == label;
  }

  @override
  int get hashCode => address.hashCode ^ type.hashCode ^ label.hashCode;

  @override
  String toString() {
    return 'ContactEmail(address: $address, type: $type)';
  }
}

/// {@template contact_phone_type}
/// Enum representing the type of phone number
/// {@endtemplate}
enum ContactPhoneType {
  mobile('mobile'),
  home('home'),
  work('work'),
  fax('fax'),
  other('other');

  const ContactPhoneType(this.value);
  final String value;
}

/// {@template contact_email_type}
/// Enum representing the type of email address
/// {@endtemplate}
enum ContactEmailType {
  personal('personal'),
  work('work'),
  other('other');

  const ContactEmailType(this.value);
  final String value;
}
