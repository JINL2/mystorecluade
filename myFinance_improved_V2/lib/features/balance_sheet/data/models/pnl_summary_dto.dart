import 'package:freezed_annotation/freezed_annotation.dart';

part 'pnl_summary_dto.freezed.dart';
part 'pnl_summary_dto.g.dart';

/// P&L Summary from get_pnl() RPC
@freezed
class PnlSummaryModel with _$PnlSummaryModel {
  const factory PnlSummaryModel({
    // Current period amounts
    @Default(0) double revenue,
    @Default(0) double cogs,
    @JsonKey(name: 'gross_profit') @Default(0) double grossProfit,
    @JsonKey(name: 'operating_expense') @Default(0) double operatingExpense,
    @JsonKey(name: 'operating_income') @Default(0) double operatingIncome,
    @JsonKey(name: 'non_operating_expense') @Default(0) double nonOperatingExpense,
    @JsonKey(name: 'net_income') @Default(0) double netIncome,

    // Margins (%)
    @JsonKey(name: 'gross_margin') @Default(0) double grossMargin,
    @JsonKey(name: 'operating_margin') @Default(0) double operatingMargin,
    @JsonKey(name: 'net_margin') @Default(0) double netMargin,

    // Previous period (nullable)
    @JsonKey(name: 'prev_revenue') double? prevRevenue,
    @JsonKey(name: 'prev_net_income') double? prevNetIncome,

    // Change percentages (nullable)
    @JsonKey(name: 'revenue_change_pct') double? revenueChangePct,
    @JsonKey(name: 'net_income_change_pct') double? netIncomeChangePct,
  }) = _PnlSummaryModel;

  factory PnlSummaryModel.fromJson(Map<String, dynamic> json) =>
      _$PnlSummaryModelFromJson(_parseNumericFields(json));

  /// Parse numeric fields that might come as strings
  static Map<String, dynamic> _parseNumericFields(Map<String, dynamic> json) {
    final result = Map<String, dynamic>.from(json);

    final numericFields = [
      'revenue', 'cogs', 'gross_profit', 'operating_expense',
      'operating_income', 'non_operating_expense', 'net_income',
      'gross_margin', 'operating_margin', 'net_margin',
      'prev_revenue', 'prev_net_income',
      'revenue_change_pct', 'net_income_change_pct',
    ];

    for (final field in numericFields) {
      if (result[field] != null) {
        if (result[field] is String) {
          result[field] = double.tryParse(result[field] as String) ?? 0.0;
        } else if (result[field] is int) {
          result[field] = (result[field] as int).toDouble();
        }
      }
    }

    return result;
  }
}

/// P&L Detail Row from get_pnl_detail() RPC
@freezed
class PnlDetailRowModel with _$PnlDetailRowModel {
  const factory PnlDetailRowModel({
    @Default('') String section,
    @JsonKey(name: 'section_order') @Default(0) int sectionOrder,
    @JsonKey(name: 'account_code') @Default('') String accountCode,
    @JsonKey(name: 'account_name') @Default('') String accountName,
    @Default(0) double amount,
  }) = _PnlDetailRowModel;

  factory PnlDetailRowModel.fromJson(Map<String, dynamic> json) =>
      _$PnlDetailRowModelFromJson(_parseNumericFields(json));

  static Map<String, dynamic> _parseNumericFields(Map<String, dynamic> json) {
    final result = Map<String, dynamic>.from(json);

    if (result['amount'] != null) {
      if (result['amount'] is String) {
        result['amount'] = double.tryParse(result['amount'] as String) ?? 0.0;
      } else if (result['amount'] is int) {
        result['amount'] = (result['amount'] as int).toDouble();
      }
    }
    if (result['section_order'] != null && result['section_order'] is String) {
      result['section_order'] = int.tryParse(result['section_order'] as String) ?? 0;
    }

    return result;
  }
}

/// Daily P&L for trend chart
@freezed
class DailyPnlModel with _$DailyPnlModel {
  const factory DailyPnlModel({
    required DateTime date,
    @Default(0) double revenue,
    @Default(0) double cogs,
    @Default(0) double opex,
    @JsonKey(name: 'net_income') @Default(0) double netIncome,
  }) = _DailyPnlModel;

  factory DailyPnlModel.fromJson(Map<String, dynamic> json) {
    return DailyPnlModel(
      date: DateTime.parse(json['date'] as String),
      revenue: _toDouble(json['revenue']),
      cogs: _toDouble(json['cogs']),
      opex: _toDouble(json['opex']),
      netIncome: _toDouble(json['net_income']),
    );
  }

  static double _toDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }
}
