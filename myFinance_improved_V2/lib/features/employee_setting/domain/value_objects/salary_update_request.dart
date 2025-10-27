/// Domain Value Object: Salary Update Request
///
/// Represents a request to update an employee's salary information.
class SalaryUpdateRequest {
  final String salaryId;
  final double salaryAmount;
  final String salaryType;
  final String currencyId;
  final String? changeReason;

  const SalaryUpdateRequest({
    required this.salaryId,
    required this.salaryAmount,
    required this.salaryType,
    required this.currencyId,
    this.changeReason,
  });

  @override
  String toString() {
    return 'SalaryUpdateRequest{salaryId: $salaryId, salaryAmount: $salaryAmount, salaryType: $salaryType}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SalaryUpdateRequest &&
          runtimeType == other.runtimeType &&
          salaryId == other.salaryId &&
          salaryAmount == other.salaryAmount &&
          salaryType == other.salaryType &&
          currencyId == other.currencyId;

  @override
  int get hashCode =>
      salaryId.hashCode ^
      salaryAmount.hashCode ^
      salaryType.hashCode ^
      currencyId.hashCode;
}
