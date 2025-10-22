import 'package:subscription_splitter_app/features/spliting_features/domain/entities/service.dart';

/// Service model for JSON serialization/deserialization
class ServiceModel extends Service {
  /// Creates a ServiceModel from a Service entity
  const ServiceModel({
    required super.id,
    required super.name,
    required super.description,
    super.iconUrl,
    required super.createdAt,
  });

  /// Creates a ServiceModel from JSON
  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      iconUrl: json['icon_url'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  /// Creates a ServiceModel from a Service entity
  factory ServiceModel.fromEntity(Service service) {
    return ServiceModel(
      id: service.id,
      name: service.name,
      description: service.description,
      iconUrl: service.iconUrl,
      createdAt: service.createdAt,
    );
  }

  /// Converts this ServiceModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'icon_url': iconUrl,
      'created_at': createdAt.toIso8601String(),
    };
  }

  /// Converts this ServiceModel to a Service entity
  Service toEntity() {
    return Service(
      id: id,
      name: name,
      description: description,
      iconUrl: iconUrl,
      createdAt: createdAt,
    );
  }

  @override
  ServiceModel copyWith({
    String? id,
    String? name,
    String? description,
    String? iconUrl,
    DateTime? createdAt,
  }) {
    return ServiceModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      iconUrl: iconUrl ?? this.iconUrl,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
