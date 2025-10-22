import '../entities/service.dart';

/// Abstract repository for services management
abstract class ServicesRepository {
  /// Get all services
  Future<List<Service>> getServices();

  /// Create a new service
  Future<Service> createService({
    required String name,
    required String description,
    String? iconUrl,
  });
}
