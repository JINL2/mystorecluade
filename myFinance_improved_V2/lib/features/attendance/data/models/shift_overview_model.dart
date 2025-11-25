import '../../domain/entities/shift_overview.dart';

/// Shift Overview Model (DTO + Mapper)
///
/// Handles JSON serialization/deserialization for ShiftOverview entity.
class ShiftOverviewModel {
  final ShiftOverview _entity;

  ShiftOverviewModel(this._entity);

  /// Create from Entity
  factory ShiftOverviewModel.fromEntity(ShiftOverview entity) {
    return ShiftOverviewModel(entity);
  }

  /// Convert to Entity
  ShiftOverview toEntity() => _entity;

  /// Create from JSON
  factory ShiftOverviewModel.fromJson(Map<String, dynamic> json) {
    // Parse salary_stores array
    final salaryStoresJson = json['salary_stores'] as List<dynamic>? ?? [];
    final salaryStores = salaryStoresJson.map((storeJson) {
      final store = storeJson as Map<String, dynamic>;
      return StoreSalary(
        storeId: store['store_id'] as String? ?? '',
        storeName: store['store_name'] as String? ?? '',
        estimatedSalary: store['estimated_salary']?.toString() ?? '0',
      );
    }).toList();

    return ShiftOverviewModel(
      ShiftOverview(
        requestMonth: json['request_month'] as String? ?? '',
        actualWorkDays: json['actual_work_days'] as int? ?? 0,
        actualWorkHours: (json['actual_work_hours'] as num?)?.toDouble() ?? 0.0,
        estimatedSalary: json['estimated_salary']?.toString() ?? '0',
        currencySymbol: json['currency_symbol'] as String? ?? '₩',
        salaryAmount: (json['salary_amount'] as num?)?.toDouble() ?? 0.0,
        salaryType: json['salary_type'] as String? ?? 'hourly',
        lateDeductionTotal: json['late_deduction_total'] as int? ?? 0,
        overtimeTotal: json['overtime_total'] as int? ?? 0,
        salaryStores: salaryStores,
      ),
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'request_month': _entity.requestMonth,
      'actual_work_days': _entity.actualWorkDays,
      'actual_work_hours': _entity.actualWorkHours,
      'estimated_salary': _entity.estimatedSalary,
      'currency_symbol': _entity.currencySymbol,
      'salary_amount': _entity.salaryAmount,
      'salary_type': _entity.salaryType,
      'late_deduction_total': _entity.lateDeductionTotal,
      'overtime_total': _entity.overtimeTotal,
      'salary_stores': _entity.salaryStores
          .map((store) => _storeSalaryToJson(store))
          .toList(),
    };
  }

  /// Convert StoreSalary to JSON
  static Map<String, dynamic> _storeSalaryToJson(StoreSalary store) {
    return {
      'store_id': store.storeId,
      'store_name': store.storeName,
      'estimated_salary': store.estimatedSalary,
    };
  }

  /// Create empty model
  static ShiftOverviewModel empty(String month) {
    return ShiftOverviewModel(ShiftOverview.empty(month));
  }
}
