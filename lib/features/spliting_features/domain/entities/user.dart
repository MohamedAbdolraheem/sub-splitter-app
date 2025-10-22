/// User entity representing a user in the system
class User {
  /// Unique identifier for the user
  final String id;

  /// User's phone number
  final String? phone;

  /// User's full name
  final String fullName;

  /// URL to the user's avatar
  final String? avatarUrl;

  /// When the user was created
  final DateTime createdAt;

  /// Creates a new User instance
  const User({
    required this.id,
    this.phone,
    required this.fullName,
    this.avatarUrl,
    required this.createdAt,
  });

  /// Creates a copy of this User with the given fields replaced with new values
  User copyWith({
    String? id,
    String? phone,
    String? fullName,
    String? avatarUrl,
    DateTime? createdAt,
  }) {
    return User(
      id: id ?? this.id,
      phone: phone ?? this.phone,
      fullName: fullName ?? this.fullName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is User &&
        other.id == id &&
        other.phone == phone &&
        other.fullName == fullName &&
        other.avatarUrl == avatarUrl &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        phone.hashCode ^
        fullName.hashCode ^
        avatarUrl.hashCode ^
        createdAt.hashCode;
  }

  @override
  String toString() {
    return 'User(id: $id, phone: $phone, fullName: $fullName, avatarUrl: $avatarUrl, createdAt: $createdAt)';
  }
}
