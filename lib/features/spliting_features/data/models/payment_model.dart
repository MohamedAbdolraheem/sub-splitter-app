import 'package:subscription_splitter_app/features/spliting_features/domain/entities/payment.dart';

/// Payment model for JSON serialization/deserialization
class PaymentModel extends Payment {
  /// Creates a PaymentModel from a Payment entity
  const PaymentModel({
    required super.id,
    required super.groupId,
    required super.userId,
    required super.amount,
    required super.status,
    super.paidAt,
  });

  /// Creates a PaymentModel from JSON
  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      id: json['id'] as String,
      groupId: json['group_id'] as String,
      userId: json['user_id'] as String,
      amount: (json['amount'] as num).toDouble(),
      status: json['status'] as String,
      paidAt:
          json['paid_at'] != null
              ? DateTime.parse(json['paid_at'] as String)
              : null,
    );
  }

  /// Creates a PaymentModel from a Payment entity
  factory PaymentModel.fromEntity(Payment payment) {
    return PaymentModel(
      id: payment.id,
      groupId: payment.groupId,
      userId: payment.userId,
      amount: payment.amount,
      status: payment.status,
      paidAt: payment.paidAt,
    );
  }

  /// Converts this PaymentModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'group_id': groupId,
      'user_id': userId,
      'amount': amount,
      'status': status,
      'paid_at': paidAt?.toIso8601String(),
    };
  }

  /// Converts this PaymentModel to a Payment entity
  Payment toEntity() {
    return Payment(
      id: id,
      groupId: groupId,
      userId: userId,
      amount: amount,
      status: status,
      paidAt: paidAt,
    );
  }

  @override
  PaymentModel copyWith({
    String? id,
    String? groupId,
    String? userId,
    double? amount,
    String? status,
    DateTime? paidAt,
  }) {
    return PaymentModel(
      id: id ?? this.id,
      groupId: groupId ?? this.groupId,
      userId: userId ?? this.userId,
      amount: amount ?? this.amount,
      status: status ?? this.status,
      paidAt: paidAt ?? this.paidAt,
    );
  }
}
