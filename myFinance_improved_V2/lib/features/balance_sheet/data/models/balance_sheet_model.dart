import '../../domain/entities/balance_sheet.dart';
import '../../domain/entities/balance_verification.dart';
import '../../domain/entities/financial_account.dart';
import '../../domain/value_objects/date_range.dart';

/// Balance sheet model (DTO + Mapper)
class BalanceSheetModel {
  final Map<String, dynamic> rawData;

  BalanceSheetModel(this.rawData);

  /// Convert from JSON
  factory BalanceSheetModel.fromJson(Map<String, dynamic> json) {
    return BalanceSheetModel(json);
  }

  /// Convert to domain entity
  BalanceSheet toEntity() {
    final data = rawData['data'] as Map<String, dynamic>;
    final companyInfo = rawData['company_info'] as Map<String, dynamic>;
    final uiData = rawData['ui_data'] as Map<String, dynamic>;
    final totals = data['totals'] as Map<String, dynamic>;
    final parameters = rawData['parameters'] as Map<String, dynamic>;

    // Parse financial accounts
    final currentAssets = _parseAccounts(data['current_assets'] as List<dynamic>);
    final nonCurrentAssets = _parseAccounts(data['non_current_assets'] as List<dynamic>);
    final currentLiabilities = _parseAccounts(data['current_liabilities'] as List<dynamic>);
    final nonCurrentLiabilities = _parseAccounts(data['non_current_liabilities'] as List<dynamic>);
    final equity = _parseAccounts(data['equity'] as List<dynamic>);
    final comprehensiveIncome = _parseAccounts(data['comprehensive_income'] as List<dynamic>);

    // Parse totals
    final balanceTotals = BalanceSheetTotals(
      totalAssets: _parseDouble(totals['total_assets']),
      totalCurrentAssets: _parseDouble(totals['total_current_assets']),
      totalNonCurrentAssets: _parseDouble(totals['total_non_current_assets']),
      totalLiabilities: _parseDouble(totals['total_liabilities']),
      totalCurrentLiabilities: _parseDouble(totals['total_current_liabilities']),
      totalNonCurrentLiabilities: _parseDouble(totals['total_non_current_liabilities']),
      totalEquity: _parseDouble(totals['total_equity']),
      totalComprehensiveIncome: _parseDouble(totals['total_comprehensive_income']),
    );

    // Parse balance verification
    final verification = uiData['balance_verification'] as Map<String, dynamic>;
    final balanceVerification = BalanceVerification(
      isBalanced: (verification['is_balanced'] as bool?) ?? false,
      totalAssets: _parseDouble(verification['total_assets']),
      totalLiabilitiesAndEquity: _parseDouble(verification['total_liabilities_and_equity']),
      totalAssetsFormatted: verification['total_assets_formatted']?.toString() ?? '0',
      totalLiabilitiesAndEquityFormatted: verification['total_liabilities_and_equity_formatted']?.toString() ?? '0',
    );

    // Parse company info
    final company = CompanyInfo(
      companyId: companyInfo['company_id']?.toString() ?? '',
      companyName: companyInfo['company_name']?.toString() ?? '',
      storeId: companyInfo['store_id']?.toString(),
      storeName: companyInfo['store_name']?.toString(),
    );

    // Parse date range
    final startDateStr = parameters['start_date']?.toString() ?? '';
    final endDateStr = parameters['end_date']?.toString() ?? '';
    final dateRange = DateRange(
      startDate: _parseDate(startDateStr),
      endDate: _parseDate(endDateStr),
    );

    return BalanceSheet(
      currentAssets: currentAssets,
      nonCurrentAssets: nonCurrentAssets,
      currentLiabilities: currentLiabilities,
      nonCurrentLiabilities: nonCurrentLiabilities,
      equity: equity,
      comprehensiveIncome: comprehensiveIncome,
      totals: balanceTotals,
      verification: balanceVerification,
      companyInfo: company,
      dateRange: dateRange,
    );
  }

  /// Parse list of accounts
  List<FinancialAccount> _parseAccounts(List<dynamic> accounts) {
    return accounts.map((account) {
      final accountMap = account as Map<String, dynamic>;
      return FinancialAccount(
        accountId: accountMap['account_id']?.toString() ?? '',
        accountName: accountMap['account_name']?.toString() ?? '',
        accountType: accountMap['account_type']?.toString() ?? '',
        balance: _parseDouble(accountMap['balance']),
        hasTransactions: (accountMap['has_transactions'] as bool?) ?? false,
      );
    }).toList();
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
  /// Note: Balance Sheet는 날짜만 사용합니다.
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
