// lib/features/report_control/domain/entities/report_detail.dart

import 'package:freezed_annotation/freezed_annotation.dart';

part 'report_detail.freezed.dart';
part 'report_detail.g.dart';

/// Detailed report content for visualization
///
/// This structure is designed to work with fixed templates.
/// AI generates the data, Flutter renders it with predefined layouts.
@freezed
class ReportDetail with _$ReportDetail {
  const factory ReportDetail({
    @JsonKey(name: 'template_id') required String templateId,
    @JsonKey(name: 'template_code') required String templateCode,
    @JsonKey(name: 'report_date') required String reportDate,
    @JsonKey(name: 'session_id') String? sessionId,

    // Core metrics for hero display
    @JsonKey(name: 'key_metrics') required KeyMetrics keyMetrics,

    // Performance cards
    @JsonKey(name: 'performance_cards')
    required List<PerformanceCard> performanceCards,

    // Balance Sheet summary
    @JsonKey(name: 'balance_sheet') required BalanceSheetSummary balanceSheet,

    // Account changes data
    @JsonKey(name: 'account_changes') required AccountChanges accountChanges,

    // Red flags
    @JsonKey(name: 'red_flags') required RedFlags redFlags,

    // AI-generated insights
    @JsonKey(name: 'ai_insights') required AiInsights aiInsights,

    // Fallback markdown
    @JsonKey(name: 'markdown_body') String? markdownBody,
  }) = _ReportDetail;

  factory ReportDetail.fromJson(Map<String, dynamic> json) =>
      _$ReportDetailFromJson(json);
}

/// Key metrics for hero number display
@freezed
class KeyMetrics with _$KeyMetrics {
  const factory KeyMetrics({
    @JsonKey(name: 'total_revenue') required double totalRevenue,
    @JsonKey(name: 'total_revenue_formatted')
    required String totalRevenueFormatted,
    @JsonKey(name: 'revenue_change_percent') double? revenueChangePercent,
    @JsonKey(name: 'is_positive_change') bool? isPositiveChange,
  }) = _KeyMetrics;

  factory KeyMetrics.fromJson(Map<String, dynamic> json) =>
      _$KeyMetricsFromJson(json);
}

/// Performance card data
@freezed
class PerformanceCard with _$PerformanceCard {
  const factory PerformanceCard({
    required String label,
    required String value,
    required String icon,
    String? trend,
    String? severity, // for issues: 'low', 'medium', 'high'
  }) = _PerformanceCard;

  factory PerformanceCard.fromJson(Map<String, dynamic> json) =>
      _$PerformanceCardFromJson(json);
}

/// Balance Sheet Summary
@freezed
class BalanceSheetSummary with _$BalanceSheetSummary {
  const factory BalanceSheetSummary({
    @JsonKey(name: 'total_assets') required double totalAssets,
    @JsonKey(name: 'total_liabilities') required double totalLiabilities,
    @JsonKey(name: 'total_equity') required double totalEquity,
    @JsonKey(name: 'assets_change') required double assetsChange,
    @JsonKey(name: 'liabilities_change') required double liabilitiesChange,
    @JsonKey(name: 'equity_change') required double equityChange,
    @JsonKey(name: 'total_assets_formatted')
    required String totalAssetsFormatted,
    @JsonKey(name: 'total_liabilities_formatted')
    required String totalLiabilitiesFormatted,
    @JsonKey(name: 'total_equity_formatted')
    required String totalEquityFormatted,
    @JsonKey(name: 'assets_change_formatted')
    required String assetsChangeFormatted,
    @JsonKey(name: 'liabilities_change_formatted')
    required String liabilitiesChangeFormatted,
    @JsonKey(name: 'equity_change_formatted')
    required String equityChangeFormatted,
    @JsonKey(name: 'assets_increased') required bool assetsIncreased,
    @JsonKey(name: 'liabilities_increased') required bool liabilitiesIncreased,
    @JsonKey(name: 'equity_increased') required bool equityIncreased,
  }) = _BalanceSheetSummary;

  const BalanceSheetSummary._();

  factory BalanceSheetSummary.fromJson(Map<String, dynamic> json) =>
      _$BalanceSheetSummaryFromJson(json);

  /// Calculate balance sheet health score (0-100)
  double get healthScore {
    // Simple scoring logic
    double score = 50; // Base score

    // Assets growing is good (+20)
    if (assetsIncreased && assetsChange > 0) {
      score += 20;
    }

    // Liabilities decreasing is good (+20)
    if (!liabilitiesIncreased && liabilitiesChange < 0) {
      score += 20;
    }

    // Equity growing is good (+10)
    if (equityIncreased && equityChange > 0) {
      score += 10;
    }

    return score.clamp(0, 100);
  }

  /// Get color based on health
  String get healthLevel {
    if (healthScore >= 80) return 'excellent';
    if (healthScore >= 60) return 'good';
    if (healthScore >= 40) return 'fair';
    return 'poor';
  }
}

/// Account changes data
@freezed
class AccountChanges with _$AccountChanges {
  const factory AccountChanges({
    @JsonKey(name: 'company_wide') required List<AccountCategory> companyWide,
    @JsonKey(name: 'by_store') required List<StoreAccountSummary> byStore,
  }) = _AccountChanges;

  factory AccountChanges.fromJson(Map<String, dynamic> json) =>
      _$AccountChangesFromJson(json);
}

/// Account category (Assets, Liabilities, Income, Expenses)
@freezed
class AccountCategory with _$AccountCategory {
  const factory AccountCategory({
    required String category,
    required List<AccountItem> accounts,
  }) = _AccountCategory;

  factory AccountCategory.fromJson(Map<String, dynamic> json) =>
      _$AccountCategoryFromJson(json);
}

/// Individual account item
@freezed
class AccountItem with _$AccountItem {
  const factory AccountItem({
    required String name,
    double? change, // for balance changes
    double? amount, // for totals
    required String formatted,
    @JsonKey(name: 'is_increase') bool? isIncrease,
  }) = _AccountItem;

  factory AccountItem.fromJson(Map<String, dynamic> json) =>
      _$AccountItemFromJson(json);
}

/// Store account summary
@freezed
class StoreAccountSummary with _$StoreAccountSummary {
  const factory StoreAccountSummary({
    @JsonKey(name: 'store_name') required String storeName,
    @JsonKey(name: 'store_id') required String storeId,
    @JsonKey(name: 'total_transactions') required double totalTransactions,
    required double revenue,
    required List<AccountCategory> categories,
  }) = _StoreAccountSummary;

  factory StoreAccountSummary.fromJson(Map<String, dynamic> json) =>
      _$StoreAccountSummaryFromJson(json);
}

/// Red flags detected
@freezed
class RedFlags with _$RedFlags {
  const factory RedFlags({
    @JsonKey(name: 'high_value_transactions')
    required List<TransactionFlag> highValueTransactions,
    @JsonKey(name: 'missing_descriptions')
    required List<TransactionFlag> missingDescriptions,
  }) = _RedFlags;

  factory RedFlags.fromJson(Map<String, dynamic> json) =>
      _$RedFlagsFromJson(json);
}

/// Transaction flag
@freezed
class TransactionFlag with _$TransactionFlag {
  const factory TransactionFlag({
    required double amount,
    required String formatted,
    String? description,
    String? employee,
    String? store,
    String? severity, // 'low', 'medium', 'high'
  }) = _TransactionFlag;

  factory TransactionFlag.fromJson(Map<String, dynamic> json) =>
      _$TransactionFlagFromJson(json);
}

/// AI-generated insights
@freezed
class AiInsights with _$AiInsights {
  const factory AiInsights({
    required String summary,
    required List<String> trends,
    required List<String> recommendations,
  }) = _AiInsights;

  factory AiInsights.fromJson(Map<String, dynamic> json) =>
      _$AiInsightsFromJson(json);
}
