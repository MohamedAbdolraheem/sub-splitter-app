import '../entities/dashboard_data.dart';

/// Abstract repository for dashboard data
abstract class DashboardRepository {
  /// Get complete dashboard data for a user (single API call)
  Future<DashboardData> getDashboardData(String userId);
}
