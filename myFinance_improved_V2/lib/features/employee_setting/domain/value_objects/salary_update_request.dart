/// Domain Value Object: Salary Update Request
///
/// Represents a request to update an employee's salary information.
class SalaryUpdateRequest {
  /// Company ID (required for RPC authorization)
  final String companyId;

  /// Target employee's user ID
  final String userId;

  /// Salary record ID
  final String salaryId;

  /// New salary amount
  final double salaryAmount;

  /// Salary type: 'hourly', 'monthly', 'yearly', etc.
  final String salaryType;

  /// Currency ID or code
  final String currencyId;

  /// Optional reason for the change
  final String? changeReason;

  const SalaryUpdateRequest({
    required this.companyId,
    required this.userId,
    required this.salaryId,
    required this.salaryAmount,
    required this.salaryType,
    required this.currencyId,
    this.changeReason,
  });

  @override
  String toString() {
    return 'SalaryUpdateRequest{companyId: $companyId, userId: $userId, '
        'salaryId: $salaryId, salaryAmount: $salaryAmount, salaryType: $salaryType}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SalaryUpdateRequest &&
          runtimeType == other.runtimeType &&
          companyId == other.companyId &&
          userId == other.userId &&
          salaryId == other.salaryId &&
          salaryAmount == other.salaryAmount &&
          salaryType == other.salaryType &&
          currencyId == other.currencyId;

  @override
  int get hashCode =>
      companyId.hashCode ^
      userId.hashCode ^
      salaryId.hashCode ^
      salaryAmount.hashCode ^
      salaryType.hashCode ^
      currencyId.hashCode;
}
