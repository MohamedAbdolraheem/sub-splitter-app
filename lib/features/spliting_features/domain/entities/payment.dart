/// Payment entity representing a payment record
class Payment {
  /// Unique identifier for the payment
  final String id;

  /// ID of the group this payment belongs to
  final String groupId;

  /// ID of the user who made the payment
  final String userId;

  /// Amount of the payment
  final double amount;

  /// Status of the payment (pending, completed, failed)
  final String status;

  /// When the payment was made (null if not paid yet)
  final DateTime? paidAt;

  /// Creates a new Payment instance
  const Payment({
    required this.id,
    required this.groupId,
    required this.userId,
    required this.amount,
    required this.status,
    this.paidAt,
  });

  /// Creates a copy of this Payment with the given fields replaced with new values
  Payment copyWith({
    String? id,
    String? groupId,
    String? userId,
    double? amount,
    String? status,
    DateTime? paidAt,
  }) {
    return Payment(
      id: id ?? this.id,
      groupId: groupId ?? this.groupId,
      userId: userId ?? this.userId,
      amount: amount ?? this.amount,
      status: status ?? this.status,
      paidAt: paidAt ?? this.paidAt,
    );
  }

  /// Checks if the payment is completed
  bool get isCompleted => status == 'completed';

  /// Checks if the payment is pending
  bool get isPending => status == 'pending';

  /// Checks if the payment failed
  bool get isFailed => status == 'failed';

  /// Checks if the payment has been paid
  bool get isPaid => paidAt != null;

  /// Gets the formatted amount as currency
  String get formattedAmount => '\$${amount.toStringAsFixed(2)}';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Payment &&
        other.id == id &&
        other.groupId == groupId &&
        other.userId == userId &&
        other.amount == amount &&
        other.status == status &&
        other.paidAt == paidAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        groupId.hashCode ^
        userId.hashCode ^
        amount.hashCode ^
        status.hashCode ^
        paidAt.hashCode;
  }

  @override
  String toString() {
    return 'Payment(id: $id, groupId: $groupId, userId: $userId, amount: $amount, status: $status, paidAt: $paidAt)';
  }
}
