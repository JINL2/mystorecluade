// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bs_summary_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BsSummaryModelImpl _$$BsSummaryModelImplFromJson(Map<String, dynamic> json) =>
    _$BsSummaryModelImpl(
      totalAssets: (json['total_assets'] as num?)?.toDouble() ?? 0,
      currentAssets: (json['current_assets'] as num?)?.toDouble() ?? 0,
      nonCurrentAssets: (json['non_current_assets'] as num?)?.toDouble() ?? 0,
      totalLiabilities: (json['total_liabilities'] as num?)?.toDouble() ?? 0,
      currentLiabilities:
          (json['current_liabilities'] as num?)?.toDouble() ?? 0,
      nonCurrentLiabilities:
          (json['non_current_liabilities'] as num?)?.toDouble() ?? 0,
      totalEquity: (json['total_equity'] as num?)?.toDouble() ?? 0,
      balanceCheck: (json['balance_check'] as num?)?.toDouble() ?? 0,
      prevTotalAssets: (json['prev_total_assets'] as num?)?.toDouble(),
      prevTotalEquity: (json['prev_total_equity'] as num?)?.toDouble(),
      assetsChangePct: (json['assets_change_pct'] as num?)?.toDouble(),
      equityChangePct: (json['equity_change_pct'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$$BsSummaryModelImplToJson(
        _$BsSummaryModelImpl instance) =>
    <String, dynamic>{
      'total_assets': instance.totalAssets,
      'current_assets': instance.currentAssets,
      'non_current_assets': instance.nonCurrentAssets,
      'total_liabilities': instance.totalLiabilities,
      'current_liabilities': instance.currentLiabilities,
      'non_current_liabilities': instance.nonCurrentLiabilities,
      'total_equity': instance.totalEquity,
      'balance_check': instance.balanceCheck,
      'prev_total_assets': instance.prevTotalAssets,
      'prev_total_equity': instance.prevTotalEquity,
      'assets_change_pct': instance.assetsChangePct,
      'equity_change_pct': instance.equityChangePct,
    };

_$BsDetailRowModelImpl _$$BsDetailRowModelImplFromJson(
        Map<String, dynamic> json) =>
    _$BsDetailRowModelImpl(
      section: json['section'] as String? ?? '',
      sectionOrder: (json['section_order'] as num?)?.toInt() ?? 0,
      accountCode: json['account_code'] as String? ?? '',
      accountName: json['account_name'] as String? ?? '',
      balance: (json['balance'] as num?)?.toDouble() ?? 0,
    );

Map<String, dynamic> _$$BsDetailRowModelImplToJson(
        _$BsDetailRowModelImpl instance) =>
    <String, dynamic>{
      'section': instance.section,
      'section_order': instance.sectionOrder,
      'account_code': instance.accountCode,
      'account_name': instance.accountName,
      'balance': instance.balance,
    };
