class SalaryUpdateRequest {
  final String salaryId;
  final double salaryAmount;
  final String salaryType;
  final String currencyId;
  final String? changeReason;

  SalaryUpdateRequest({
    required this.salaryId,
    required this.salaryAmount,
    required this.salaryType,
    required this.currencyId,
    this.changeReason,
  });

  Map<String, dynamic> toJson() {
    return {
      'p_salary_id': salaryId,
      'p_salary_amount': salaryAmount,
      'p_salary_type': salaryType,
      'p_currency_id': currencyId,
      'p_change_reason': changeReason,
    };
  }
}