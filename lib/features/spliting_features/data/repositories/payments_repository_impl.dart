import 'package:subscription_splitter_app/core/constants/api_endpoints.dart';
import 'package:subscription_splitter_app/core/network/dio_client.dart';
import 'package:subscription_splitter_app/features/spliting_features/data/models/payment_model.dart';
import 'package:subscription_splitter_app/features/spliting_features/domain/entities/payment.dart';
import 'package:subscription_splitter_app/features/spliting_features/domain/repositories/payments_repository.dart';

/// Implementation of PaymentsRepository using Dio client
class PaymentsRepositoryImpl implements PaymentsRepository {
  final ApiService _apiService;

  PaymentsRepositoryImpl({required ApiService apiService})
    : _apiService = apiService;

  @override
  Future<Payment> createPayment({
    required String groupId,
    required String userId,
    required double amount,
  }) async {
    final response = await _apiService.post<Map<String, dynamic>>(
      ApiEndpoints.payments,
      data: {'group_id': groupId, 'user_id': userId, 'amount': amount},
    );

    if (response == null) {
      throw Exception('Failed to create payment');
    }

    return PaymentModel.fromJson(response).toEntity();
  }

  @override
  Future<List<Payment>> getUserPayments({
    required String userId,
    String? groupId,
  }) async {
    String url = '${ApiEndpoints.payments}?userId=$userId';
    if (groupId != null) url += '&groupId=$groupId';

    final response = await _apiService.get<List<dynamic>>(url);

    if (response == null) return [];

    return response
        .map((json) => PaymentModel.fromJson(json as Map<String, dynamic>))
        .map((model) => model.toEntity())
        .toList();
  }

  @override
  Future<Payment> getPaymentDetails(String paymentId) async {
    final response = await _apiService.get<Map<String, dynamic>>(
      ApiEndpoints.paymentDetailsById(paymentId),
    );

    if (response == null) {
      throw Exception('Payment not found');
    }

    return PaymentModel.fromJson(response).toEntity();
  }

  @override
  Future<Payment> updatePaymentStatus({
    required String paymentId,
    required String status,
    String? paidAt,
  }) async {
    final data = <String, dynamic>{'status': status};
    if (paidAt != null) data['paid_at'] = paidAt;

    final response = await _apiService.put<Map<String, dynamic>>(
      ApiEndpoints.updatePaymentStatusById(paymentId),
      data: data,
    );

    if (response == null) {
      throw Exception('Failed to update payment status');
    }

    return PaymentModel.fromJson(response).toEntity();
  }
}
