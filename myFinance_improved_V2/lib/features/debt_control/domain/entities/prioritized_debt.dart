import 'package:freezed_annotation/freezed_annotation.dart';

part 'prioritized_debt.freezed.dart';

/// Prioritized debt entity with risk assessment
@freezed
class PrioritizedDebt with _$PrioritizedDebt {
  const factory PrioritizedDebt({
    required String id,
    required String counterpartyId,
    required String counterpartyName,
    required String counterpartyType,
    required double amount,
    required String currency,
    required DateTime dueDate,
    required int daysOverdue,
    required String riskCategory,
    required double priorityScore,
    DateTime? lastContactDate,
    String? lastContactType,
    String? paymentStatus,
    @Default([]) List<String> suggestedActions,
    @Default(false) bool hasPaymentPlan,
    @Default(false) bool isDisputed,
    @Default(0) int transactionCount,
    String? linkedCompanyName,
    Map<String, dynamic>? metadata,
  }) = _PrioritizedDebt;

  const PrioritizedDebt._();

  /// Check if debt is overdue
  bool get isOverdue => daysOverdue > 0;

  /// Check if debt is critical
  bool get isCritical => riskCategory == 'critical' || daysOverdue > 90;

  /// Check if debt needs attention
  bool get needsAttention => riskCategory == 'attention' || daysOverdue > 30;

  /// Check if counterparty is internal
  bool get isInternal => counterpartyType == 'internal';

  /// Get risk level description
  String get riskDescription {
    if (isCritical) return 'Critical - Immediate action required';
    if (needsAttention) return 'Needs attention';
    return 'Current - Monitor';
  }

  /// Calculate urgency score (0-100)
  double get urgencyScore {
    double score = priorityScore;
    if (isDisputed) score += 10;
    if (daysOverdue > 90) score += 20;
    if (daysOverdue > 60) score += 15;
    if (daysOverdue > 30) score += 10;
    return score.clamp(0, 100);
  }
}
