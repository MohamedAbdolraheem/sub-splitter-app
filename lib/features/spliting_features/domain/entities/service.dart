/// Service entity representing a subscription service
class Service {
  /// Unique identifier for the service
  final String id;

  /// Name of the service (e.g., "Adobe Creative Cloud")
  final String name;

  /// Description of the service
  final String description;

  /// URL to the service icon
  final String? iconUrl;

  /// When the service was created
  final DateTime createdAt;

  /// Creates a new Service instance
  const Service({
    required this.id,
    required this.name,
    required this.description,
    this.iconUrl,
    required this.createdAt,
  });

  /// Creates a copy of this Service with the given fields replaced with new values
  Service copyWith({
    String? id,
    String? name,
    String? description,
    String? iconUrl,
    DateTime? createdAt,
  }) {
    return Service(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      iconUrl: iconUrl ?? this.iconUrl,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Service &&
        other.id == id &&
        other.name == name &&
        other.description == description &&
        other.iconUrl == iconUrl &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        description.hashCode ^
        iconUrl.hashCode ^
        createdAt.hashCode;
  }

  @override
  String toString() {
    return 'Service(id: $id, name: $name, description: $description, iconUrl: $iconUrl, createdAt: $createdAt)';
  }
}
