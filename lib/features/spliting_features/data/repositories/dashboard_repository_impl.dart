import 'dart:developer' as console;

import 'package:dio/dio.dart';
import 'package:subscription_splitter_app/core/constants/api_endpoints.dart';
import 'package:subscription_splitter_app/core/errors/failures.dart';
import 'package:subscription_splitter_app/core/network/dio_client.dart';
import 'package:subscription_splitter_app/features/spliting_features/domain/repositories/dashboard_repository.dart';
import 'package:subscription_splitter_app/features/spliting_features/domain/entities/dashboard_data.dart';
import 'package:subscription_splitter_app/features/spliting_features/data/models/dashboard_data_model.dart';

/// Implementation of DashboardRepository
class DashboardRepositoryImpl implements DashboardRepository {
  final ApiService _apiService;

  DashboardRepositoryImpl({required ApiService apiService})
    : _apiService = apiService;

  @override
  Future<DashboardData> getDashboardData(String userId) async {
    try {
      console.log(
        'DashboardRepositoryImpl: Fetching dashboard data for user: $userId',
      );
      console.log(
        'DashboardRepositoryImpl: API endpoint: ${ApiEndpoints.dashboardDataByUserId(userId)}',
      );

      final response = await _apiService.get<Map<String, dynamic>>(
        ApiEndpoints.dashboardDataByUserId(userId),
      );

      console.log(
        'DashboardRepositoryImpl: API response received: ${response != null}',
      );
      if (response != null) {
        console.log(
          'DashboardRepositoryImpl: Response keys: ${response.keys.toList()}',
        );
      }

      if (response == null) {
        throw const ServerFailure(message: 'No dashboard data received');
      }

      // Convert JSON response to DashboardData entity
      console.log(
        'DashboardRepositoryImpl: Converting JSON to DashboardDataModel...',
      );

      final dashboardDataModel = DashboardDataModel.fromJson(response);
      console.log('DashboardRepositoryImpl: Conversion successful');
      return dashboardDataModel.toEntity();
    } on DioException catch (e) {
      console.log('DashboardRepositoryImpl: DioException: $e');
      console.log('DashboardRepositoryImpl: DioException type: ${e.type}');
      console.log(
        'DashboardRepositoryImpl: Response status: ${e.response?.statusCode}',
      );

      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.sendTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw NetworkFailure(
          message: 'Connection timeout. Please check your internet connection.',
          statusCode: e.response?.statusCode,
        );
      } else if (e.type == DioExceptionType.connectionError) {
        throw NetworkFailure(
          message: 'Network error. Please check your internet connection.',
          statusCode: e.response?.statusCode,
        );
      } else if (e.response?.statusCode != null) {
        throw ServerFailure(
          message: e.response?.data?['message'] ?? 'Server error occurred',
          statusCode: e.response?.statusCode,
        );
      } else {
        throw NetworkFailure(
          message: 'Network error: ${e.message}',
          statusCode: e.response?.statusCode,
        );
      }
    } catch (e) {
      console.log('DashboardRepositoryImpl: Unexpected error: $e');
      console.log('DashboardRepositoryImpl: Error type: ${e.runtimeType}');

      if (e is Failure) {
        rethrow; // Re-throw if it's already a Failure
      } else {
        throw UnknownFailure(message: 'Failed to load dashboard data: $e');
      }
    }
  }
}
