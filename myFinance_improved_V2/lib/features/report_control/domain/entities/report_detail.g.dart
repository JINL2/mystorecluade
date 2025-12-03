// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report_detail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ReportDetailImpl _$$ReportDetailImplFromJson(Map<String, dynamic> json) =>
    _$ReportDetailImpl(
      templateId: json['template_id'] as String,
      templateCode: json['template_code'] as String,
      reportDate: json['report_date'] as String,
      sessionId: json['session_id'] as String?,
      keyMetrics:
          KeyMetrics.fromJson(json['key_metrics'] as Map<String, dynamic>),
      performanceCards: (json['performance_cards'] as List<dynamic>)
          .map((e) => PerformanceCard.fromJson(e as Map<String, dynamic>))
          .toList(),
      balanceSheet: BalanceSheetSummary.fromJson(
          json['balance_sheet'] as Map<String, dynamic>),
      accountChanges: AccountChanges.fromJson(
          json['account_changes'] as Map<String, dynamic>),
      redFlags: RedFlags.fromJson(json['red_flags'] as Map<String, dynamic>),
      aiInsights:
          AiInsights.fromJson(json['ai_insights'] as Map<String, dynamic>),
      markdownBody: json['markdown_body'] as String?,
    );

Map<String, dynamic> _$$ReportDetailImplToJson(_$ReportDetailImpl instance) =>
    <String, dynamic>{
      'template_id': instance.templateId,
      'template_code': instance.templateCode,
      'report_date': instance.reportDate,
      'session_id': instance.sessionId,
      'key_metrics': instance.keyMetrics,
      'performance_cards': instance.performanceCards,
      'balance_sheet': instance.balanceSheet,
      'account_changes': instance.accountChanges,
      'red_flags': instance.redFlags,
      'ai_insights': instance.aiInsights,
      'markdown_body': instance.markdownBody,
    };

_$KeyMetricsImpl _$$KeyMetricsImplFromJson(Map<String, dynamic> json) =>
    _$KeyMetricsImpl(
      totalRevenue: (json['total_revenue'] as num).toDouble(),
      totalRevenueFormatted: json['total_revenue_formatted'] as String,
      revenueChangePercent:
          (json['revenue_change_percent'] as num?)?.toDouble(),
      isPositiveChange: json['is_positive_change'] as bool?,
    );

Map<String, dynamic> _$$KeyMetricsImplToJson(_$KeyMetricsImpl instance) =>
    <String, dynamic>{
      'total_revenue': instance.totalRevenue,
      'total_revenue_formatted': instance.totalRevenueFormatted,
      'revenue_change_percent': instance.revenueChangePercent,
      'is_positive_change': instance.isPositiveChange,
    };

_$PerformanceCardImpl _$$PerformanceCardImplFromJson(
        Map<String, dynamic> json) =>
    _$PerformanceCardImpl(
      label: json['label'] as String,
      value: json['value'] as String,
      icon: json['icon'] as String,
      trend: json['trend'] as String?,
      severity: json['severity'] as String?,
    );

Map<String, dynamic> _$$PerformanceCardImplToJson(
        _$PerformanceCardImpl instance) =>
    <String, dynamic>{
      'label': instance.label,
      'value': instance.value,
      'icon': instance.icon,
      'trend': instance.trend,
      'severity': instance.severity,
    };

_$BalanceSheetSummaryImpl _$$BalanceSheetSummaryImplFromJson(
        Map<String, dynamic> json) =>
    _$BalanceSheetSummaryImpl(
      totalAssets: (json['total_assets'] as num).toDouble(),
      totalLiabilities: (json['total_liabilities'] as num).toDouble(),
      totalEquity: (json['total_equity'] as num).toDouble(),
      assetsChange: (json['assets_change'] as num).toDouble(),
      liabilitiesChange: (json['liabilities_change'] as num).toDouble(),
      equityChange: (json['equity_change'] as num).toDouble(),
      totalAssetsFormatted: json['total_assets_formatted'] as String,
      totalLiabilitiesFormatted: json['total_liabilities_formatted'] as String,
      totalEquityFormatted: json['total_equity_formatted'] as String,
      assetsChangeFormatted: json['assets_change_formatted'] as String,
      liabilitiesChangeFormatted:
          json['liabilities_change_formatted'] as String,
      equityChangeFormatted: json['equity_change_formatted'] as String,
      assetsIncreased: json['assets_increased'] as bool,
      liabilitiesIncreased: json['liabilities_increased'] as bool,
      equityIncreased: json['equity_increased'] as bool,
    );

Map<String, dynamic> _$$BalanceSheetSummaryImplToJson(
        _$BalanceSheetSummaryImpl instance) =>
    <String, dynamic>{
      'total_assets': instance.totalAssets,
      'total_liabilities': instance.totalLiabilities,
      'total_equity': instance.totalEquity,
      'assets_change': instance.assetsChange,
      'liabilities_change': instance.liabilitiesChange,
      'equity_change': instance.equityChange,
      'total_assets_formatted': instance.totalAssetsFormatted,
      'total_liabilities_formatted': instance.totalLiabilitiesFormatted,
      'total_equity_formatted': instance.totalEquityFormatted,
      'assets_change_formatted': instance.assetsChangeFormatted,
      'liabilities_change_formatted': instance.liabilitiesChangeFormatted,
      'equity_change_formatted': instance.equityChangeFormatted,
      'assets_increased': instance.assetsIncreased,
      'liabilities_increased': instance.liabilitiesIncreased,
      'equity_increased': instance.equityIncreased,
    };

_$AccountChangesImpl _$$AccountChangesImplFromJson(Map<String, dynamic> json) =>
    _$AccountChangesImpl(
      companyWide: (json['company_wide'] as List<dynamic>)
          .map((e) => AccountCategory.fromJson(e as Map<String, dynamic>))
          .toList(),
      byStore: (json['by_store'] as List<dynamic>)
          .map((e) => StoreAccountSummary.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$AccountChangesImplToJson(
        _$AccountChangesImpl instance) =>
    <String, dynamic>{
      'company_wide': instance.companyWide,
      'by_store': instance.byStore,
    };

_$AccountCategoryImpl _$$AccountCategoryImplFromJson(
        Map<String, dynamic> json) =>
    _$AccountCategoryImpl(
      category: json['category'] as String,
      accounts: (json['accounts'] as List<dynamic>)
          .map((e) => AccountItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$AccountCategoryImplToJson(
        _$AccountCategoryImpl instance) =>
    <String, dynamic>{
      'category': instance.category,
      'accounts': instance.accounts,
    };

_$AccountItemImpl _$$AccountItemImplFromJson(Map<String, dynamic> json) =>
    _$AccountItemImpl(
      name: json['name'] as String,
      change: (json['change'] as num?)?.toDouble(),
      amount: (json['amount'] as num?)?.toDouble(),
      formatted: json['formatted'] as String,
      isIncrease: json['is_increase'] as bool?,
    );

Map<String, dynamic> _$$AccountItemImplToJson(_$AccountItemImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'change': instance.change,
      'amount': instance.amount,
      'formatted': instance.formatted,
      'is_increase': instance.isIncrease,
    };

_$StoreAccountSummaryImpl _$$StoreAccountSummaryImplFromJson(
        Map<String, dynamic> json) =>
    _$StoreAccountSummaryImpl(
      storeName: json['store_name'] as String,
      storeId: json['store_id'] as String,
      totalTransactions: (json['total_transactions'] as num).toDouble(),
      revenue: (json['revenue'] as num).toDouble(),
      categories: (json['categories'] as List<dynamic>)
          .map((e) => AccountCategory.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$StoreAccountSummaryImplToJson(
        _$StoreAccountSummaryImpl instance) =>
    <String, dynamic>{
      'store_name': instance.storeName,
      'store_id': instance.storeId,
      'total_transactions': instance.totalTransactions,
      'revenue': instance.revenue,
      'categories': instance.categories,
    };

_$RedFlagsImpl _$$RedFlagsImplFromJson(Map<String, dynamic> json) =>
    _$RedFlagsImpl(
      highValueTransactions: (json['high_value_transactions'] as List<dynamic>)
          .map((e) => TransactionFlag.fromJson(e as Map<String, dynamic>))
          .toList(),
      missingDescriptions: (json['missing_descriptions'] as List<dynamic>)
          .map((e) => TransactionFlag.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$RedFlagsImplToJson(_$RedFlagsImpl instance) =>
    <String, dynamic>{
      'high_value_transactions': instance.highValueTransactions,
      'missing_descriptions': instance.missingDescriptions,
    };

_$TransactionFlagImpl _$$TransactionFlagImplFromJson(
        Map<String, dynamic> json) {
  print('🔍 [TransactionFlag fromJson] Input JSON: $json');
  print('🔍 [TransactionFlag] amount=${json['amount']} (${json['amount'].runtimeType})');
  print('🔍 [TransactionFlag] formatted=${json['formatted']} (${json['formatted'].runtimeType})');
  print('🔍 [TransactionFlag] description=${json['description']} (${json['description'].runtimeType})');
  print('🔍 [TransactionFlag] employee=${json['employee']} (${json['employee'].runtimeType})');
  print('🔍 [TransactionFlag] store=${json['store']} (${json['store'].runtimeType})');
  print('🔍 [TransactionFlag] severity=${json['severity']} (${json['severity'].runtimeType})');

  return _$TransactionFlagImpl(
      amount: (json['amount'] as num).toDouble(),
      formatted: json['formatted'] as String,
      description: json['description'] as String?,
      employee: json['employee'] as String?,
      store: json['store'] as String?,
      severity: json['severity'] as String?,
    );
}

Map<String, dynamic> _$$TransactionFlagImplToJson(
        _$TransactionFlagImpl instance) =>
    <String, dynamic>{
      'amount': instance.amount,
      'formatted': instance.formatted,
      'description': instance.description,
      'employee': instance.employee,
      'store': instance.store,
      'severity': instance.severity,
    };

_$AiInsightsImpl _$$AiInsightsImplFromJson(Map<String, dynamic> json) =>
    _$AiInsightsImpl(
      summary: json['summary'] as String,
      trends:
          (json['trends'] as List<dynamic>).map((e) => e as String).toList(),
      recommendations: (json['recommendations'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$$AiInsightsImplToJson(_$AiInsightsImpl instance) =>
    <String, dynamic>{
      'summary': instance.summary,
      'trends': instance.trends,
      'recommendations': instance.recommendations,
    };
