import 'package:subscription_splitter_app/features/spliting_features/domain/entities/user.dart';

/// User model for JSON serialization/deserialization
class UserModel extends User {
  /// Creates a UserModel from a User entity
  const UserModel({
    required super.id,
    super.phone,
    required super.fullName,
    super.avatarUrl,
    required super.createdAt,
  });

  /// Creates a UserModel from JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      phone: json['phone'] as String?,
      fullName: json['full_name'] as String,
      avatarUrl: json['avatar_url'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  /// Creates a UserModel from a User entity
  factory UserModel.fromEntity(User user) {
    return UserModel(
      id: user.id,
      phone: user.phone,
      fullName: user.fullName,
      avatarUrl: user.avatarUrl,
      createdAt: user.createdAt,
    );
  }

  /// Converts this UserModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'phone': phone,
      'full_name': fullName,
      'avatar_url': avatarUrl,
      'created_at': createdAt.toIso8601String(),
    };
  }

  /// Converts this UserModel to a User entity
  User toEntity() {
    return User(
      id: id,
      phone: phone,
      fullName: fullName,
      avatarUrl: avatarUrl,
      createdAt: createdAt,
    );
  }

  @override
  UserModel copyWith({
    String? id,
    String? phone,
    String? fullName,
    String? avatarUrl,
    DateTime? createdAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      phone: phone ?? this.phone,
      fullName: fullName ?? this.fullName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
