// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pnl_summary_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PnlSummaryModelImpl _$$PnlSummaryModelImplFromJson(
        Map<String, dynamic> json) =>
    _$PnlSummaryModelImpl(
      revenue: (json['revenue'] as num?)?.toDouble() ?? 0,
      cogs: (json['cogs'] as num?)?.toDouble() ?? 0,
      grossProfit: (json['gross_profit'] as num?)?.toDouble() ?? 0,
      operatingExpense: (json['operating_expense'] as num?)?.toDouble() ?? 0,
      operatingIncome: (json['operating_income'] as num?)?.toDouble() ?? 0,
      nonOperatingExpense:
          (json['non_operating_expense'] as num?)?.toDouble() ?? 0,
      netIncome: (json['net_income'] as num?)?.toDouble() ?? 0,
      grossMargin: (json['gross_margin'] as num?)?.toDouble() ?? 0,
      operatingMargin: (json['operating_margin'] as num?)?.toDouble() ?? 0,
      netMargin: (json['net_margin'] as num?)?.toDouble() ?? 0,
      prevRevenue: (json['prev_revenue'] as num?)?.toDouble(),
      prevNetIncome: (json['prev_net_income'] as num?)?.toDouble(),
      revenueChangePct: (json['revenue_change_pct'] as num?)?.toDouble(),
      netIncomeChangePct: (json['net_income_change_pct'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$$PnlSummaryModelImplToJson(
        _$PnlSummaryModelImpl instance) =>
    <String, dynamic>{
      'revenue': instance.revenue,
      'cogs': instance.cogs,
      'gross_profit': instance.grossProfit,
      'operating_expense': instance.operatingExpense,
      'operating_income': instance.operatingIncome,
      'non_operating_expense': instance.nonOperatingExpense,
      'net_income': instance.netIncome,
      'gross_margin': instance.grossMargin,
      'operating_margin': instance.operatingMargin,
      'net_margin': instance.netMargin,
      'prev_revenue': instance.prevRevenue,
      'prev_net_income': instance.prevNetIncome,
      'revenue_change_pct': instance.revenueChangePct,
      'net_income_change_pct': instance.netIncomeChangePct,
    };

_$PnlDetailRowModelImpl _$$PnlDetailRowModelImplFromJson(
        Map<String, dynamic> json) =>
    _$PnlDetailRowModelImpl(
      section: json['section'] as String? ?? '',
      sectionOrder: (json['section_order'] as num?)?.toInt() ?? 0,
      accountCode: json['account_code'] as String? ?? '',
      accountName: json['account_name'] as String? ?? '',
      amount: (json['amount'] as num?)?.toDouble() ?? 0,
    );

Map<String, dynamic> _$$PnlDetailRowModelImplToJson(
        _$PnlDetailRowModelImpl instance) =>
    <String, dynamic>{
      'section': instance.section,
      'section_order': instance.sectionOrder,
      'account_code': instance.accountCode,
      'account_name': instance.accountName,
      'amount': instance.amount,
    };
