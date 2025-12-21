import '../../domain/entities/financial_account.dart';
import '../../domain/entities/income_statement.dart';
import '../../domain/value_objects/date_range.dart';

/// Income statement model (DTO + Mapper)
class IncomeStatementModel {
  final List<dynamic> rawData;
  final Map<String, dynamic> parameters;

  IncomeStatementModel({
    required this.rawData,
    required this.parameters,
  });

  /// Convert from JSON
  factory IncomeStatementModel.fromJson({
    required List<dynamic> data,
    required Map<String, dynamic> parameters,
  }) {
    return IncomeStatementModel(
      rawData: data,
      parameters: parameters,
    );
  }

  /// Convert to domain entity
  IncomeStatement toEntity() {
    final sections = rawData.map((sectionData) {
      final sectionMap = sectionData as Map<String, dynamic>;
      final sectionName = sectionMap['section']?.toString() ?? '';
      final sectionTotal = sectionMap['section_total']; // Can be String or double
      final subcategoriesData = sectionMap['subcategories'] as List<dynamic>? ?? [];

      final subcategories = subcategoriesData.map((subcategoryData) {
        final subcategoryMap = subcategoryData as Map<String, dynamic>;
        final subcategoryName = subcategoryMap['subcategory']?.toString() ?? '';
        final subcategoryTotal = _parseDouble(subcategoryMap['subcategory_total']);
        final accountsData = subcategoryMap['accounts'] as List<dynamic>? ?? [];

        final accounts = accountsData.map((accountData) {
          final accountMap = accountData as Map<String, dynamic>;
          return IncomeStatementAccount(
            accountId: accountMap['account_id']?.toString() ?? '',
            accountName: accountMap['account_name']?.toString() ?? '',
            accountType: accountMap['account_type']?.toString() ?? '',
            netAmount: _parseDouble(accountMap['net_amount']),
          );
        }).toList();

        return IncomeStatementSubcategory(
          subcategoryName: subcategoryName,
          subcategoryTotal: subcategoryTotal,
          accounts: accounts,
        );
      }).toList();

      return IncomeStatementSection(
        sectionName: sectionName,
        sectionTotal: sectionTotal,
        subcategories: subcategories,
      );
    }).toList();

    // Parse date range
    final startDateStr = parameters['start_date']?.toString() ?? '';
    final endDateStr = parameters['end_date']?.toString() ?? '';
    final dateRange = DateRange(
      startDate: _parseDate(startDateStr),
      endDate: _parseDate(endDateStr),
    );

    return IncomeStatement(
      sections: sections,
      dateRange: dateRange,
      companyId: parameters['company_id']?.toString() ?? '',
      storeId: parameters['store_id']?.toString(),
    );
  }

  /// Parse double from dynamic
  double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  /// Parse date from string (YYYY-MM-DD)
  /// 날짜만 필요하므로 타임존 변환 없음
  ///
  /// Note: Income Statement는 날짜만 사용합니다.
  /// 만약 timestamp 필드가 추가되면 DateTimeUtils.toLocalSafe()를 사용하세요.
  DateTime _parseDate(String dateStr) {
    try {
      final parts = dateStr.split('-');
      if (parts.length == 3) {
        return DateTime(
          int.parse(parts[0]),
          int.parse(parts[1]),
          int.parse(parts[2]),
        );
      }
    } catch (e) {
      // Return current date on error
    }
    return DateTime.now();
  }

  // Timestamp 파싱이 필요한 경우 아래 메서드를 사용하세요:
  //
  // import '../../../../core/utils/datetime_utils.dart';
  //
  // DateTime? _parseTimestamp(dynamic value) {
  //   if (value == null) return null;
  //   if (value is String) {
  //     return DateTimeUtils.toLocalSafe(value);
  //   }
  //   return null;
  // }
}
