import 'package:subscription_splitter_app/core/constants/api_endpoints.dart';
import 'package:subscription_splitter_app/core/network/dio_client.dart';
import 'package:subscription_splitter_app/features/spliting_features/data/models/service_model.dart';
import 'package:subscription_splitter_app/features/spliting_features/domain/entities/service.dart';
import 'package:subscription_splitter_app/features/spliting_features/domain/repositories/services_repository.dart';

/// Implementation of ServicesRepository using Dio client
class ServicesRepositoryImpl implements ServicesRepository {
  final ApiService _apiService;

  ServicesRepositoryImpl({required ApiService apiService})
    : _apiService = apiService;

  @override
  Future<List<Service>> getServices() async {
    try {
      print(
        'ServicesRepository: Fetching services from ${ApiEndpoints.services}',
      );
      final response = await _apiService.get<List<dynamic>>(
        ApiEndpoints.services,
      );

      print('ServicesRepository: Response received: $response');

      if (response == null) {
        print('ServicesRepository: Response is null, returning empty list');
        return [];
      }

      final services =
          response
              .map(
                (json) => ServiceModel.fromJson(json as Map<String, dynamic>),
              )
              .map((model) => model.toEntity())
              .toList();

      print(
        'ServicesRepository: Successfully parsed ${services.length} services',
      );
      return services;
    } catch (e) {
      print('ServicesRepository: Error fetching services: $e');
      rethrow;
    }
  }

  @override
  Future<Service> createService({
    required String name,
    required String description,
    String? iconUrl,
  }) async {
    final response = await _apiService.post<Map<String, dynamic>>(
      ApiEndpoints.services,
      data: {
        'name': name,
        'description': description,
        if (iconUrl != null) 'icon_url': iconUrl,
      },
    );

    if (response == null) {
      throw Exception('Failed to create service');
    }

    // Handle the wrapped response format: {success, message, data}
    if (response.containsKey('data')) {
      final serviceData = response['data'] as Map<String, dynamic>;
      return ServiceModel.fromJson(serviceData).toEntity();
    } else {
      // Fallback for direct service object response
      return ServiceModel.fromJson(response).toEntity();
    }
  }
}
