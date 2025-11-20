import 'package:freezed_annotation/freezed_annotation.dart';

import '../value_objects/date_range.dart';
import 'balance_verification.dart';
import 'financial_account.dart';

part 'balance_sheet.freezed.dart';

/// Balance sheet totals
@freezed
class BalanceSheetTotals with _$BalanceSheetTotals {
  const factory BalanceSheetTotals({
    required double totalAssets,
    required double totalCurrentAssets,
    required double totalNonCurrentAssets,
    required double totalLiabilities,
    required double totalCurrentLiabilities,
    required double totalNonCurrentLiabilities,
    required double totalEquity,
    required double totalComprehensiveIncome,
  }) = _BalanceSheetTotals;
}

/// Company info for balance sheet
@freezed
class CompanyInfo with _$CompanyInfo {
  const factory CompanyInfo({
    required String companyId,
    required String companyName,
    String? storeId,
    String? storeName,
  }) = _CompanyInfo;
}

/// Balance sheet entity
@freezed
class BalanceSheet with _$BalanceSheet {
  const factory BalanceSheet({
    required List<FinancialAccount> currentAssets,
    required List<FinancialAccount> nonCurrentAssets,
    required List<FinancialAccount> currentLiabilities,
    required List<FinancialAccount> nonCurrentLiabilities,
    required List<FinancialAccount> equity,
    required List<FinancialAccount> comprehensiveIncome,
    required BalanceSheetTotals totals,
    required BalanceVerification verification,
    required CompanyInfo companyInfo,
    required DateRange dateRange,
  }) = _BalanceSheet;
}
