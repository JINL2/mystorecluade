import 'package:freezed_annotation/freezed_annotation.dart';
import 'aging_analysis.dart';

part 'payment_plan.freezed.dart';

/// Payment plan for structured debt collection
@freezed
class PaymentPlan with _$PaymentPlan {
  const factory PaymentPlan({
    required String id,
    required String debtId,
    required double totalAmount,
    required double installmentAmount,
    required String frequency,
    required DateTime startDate,
    required DateTime endDate,
    required String status,
    @Default([]) List<PaymentPlanInstallment> installments,
    DateTime? createdAt,
    String? notes,
  }) = _PaymentPlan;

  const PaymentPlan._();

  /// Check if payment plan is active
  bool get isActive => status == 'active';

  /// Check if payment plan is completed
  bool get isCompleted => status == 'completed';

  /// Get progress percentage
  double get progressPercentage {
    if (installments.isEmpty) return 0;
    final paidInstallments = installments.where((i) => i.isPaid).length;
    return (paidInstallments / installments.length) * 100;
  }
}

/// Individual installment in a payment plan
@freezed
class PaymentPlanInstallment with _$PaymentPlanInstallment {
  const factory PaymentPlanInstallment({
    required String id,
    required String paymentPlanId,
    required double amount,
    required DateTime dueDate,
    required String status,
    @Default(0.0) double paidAmount,
    DateTime? paidDate,
    String? paymentReference,
  }) = _PaymentPlanInstallment;

  const PaymentPlanInstallment._();

  /// Check if installment is paid
  bool get isPaid => status == 'paid';

  /// Check if installment is overdue
  bool get isOverdue => status == 'overdue' || (status == 'pending' && DateTime.now().isAfter(dueDate));

  /// Get remaining amount
  double get remainingAmount => amount - paidAmount;
}

/// Debt analytics data
@freezed
class DebtAnalytics with _$DebtAnalytics {
  const factory DebtAnalytics({
    required AgingAnalysis currentAging,
    @Default([]) List<AgingTrendPoint> agingTrend,
    required double collectionEfficiency,
    required Map<String, double> riskDistribution,
    DateTime? reportDate,
  }) = _DebtAnalytics;
}

