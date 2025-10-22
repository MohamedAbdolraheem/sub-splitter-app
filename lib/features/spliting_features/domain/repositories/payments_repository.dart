import '../entities/payment.dart';

/// Abstract repository for payments management
abstract class PaymentsRepository {
  /// Create payment
  Future<Payment> createPayment({
    required String groupId,
    required String userId,
    required double amount,
  });

  /// Get payments for user
  Future<List<Payment>> getUserPayments({
    required String userId,
    String? groupId,
  });

  /// Get payment details
  Future<Payment> getPaymentDetails(String paymentId);

  /// Update payment status
  Future<Payment> updatePaymentStatus({
    required String paymentId,
    required String status, // 'pending', 'completed', 'failed'
    String? paidAt,
  });
}
