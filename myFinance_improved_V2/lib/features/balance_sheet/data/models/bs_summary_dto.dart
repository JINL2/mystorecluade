import 'package:freezed_annotation/freezed_annotation.dart';

part 'bs_summary_dto.freezed.dart';
part 'bs_summary_dto.g.dart';

/// Balance Sheet Summary from get_bs() RPC
@freezed
class BsSummaryModel with _$BsSummaryModel {
  const factory BsSummaryModel({
    // Current amounts
    @JsonKey(name: 'total_assets') @Default(0) double totalAssets,
    @JsonKey(name: 'current_assets') @Default(0) double currentAssets,
    @JsonKey(name: 'non_current_assets') @Default(0) double nonCurrentAssets,
    @JsonKey(name: 'total_liabilities') @Default(0) double totalLiabilities,
    @JsonKey(name: 'current_liabilities') @Default(0) double currentLiabilities,
    @JsonKey(name: 'non_current_liabilities') @Default(0) double nonCurrentLiabilities,
    @JsonKey(name: 'total_equity') @Default(0) double totalEquity,

    // Balance check (should be 0 if balanced)
    @JsonKey(name: 'balance_check') @Default(0) double balanceCheck,

    // Previous period (nullable)
    @JsonKey(name: 'prev_total_assets') double? prevTotalAssets,
    @JsonKey(name: 'prev_total_equity') double? prevTotalEquity,

    // Change percentages (nullable)
    @JsonKey(name: 'assets_change_pct') double? assetsChangePct,
    @JsonKey(name: 'equity_change_pct') double? equityChangePct,
  }) = _BsSummaryModel;

  const BsSummaryModel._();

  /// Whether the balance sheet is balanced (Assets = Liabilities + Equity)
  bool get isBalanced => balanceCheck.abs() < 0.01;

  factory BsSummaryModel.fromJson(Map<String, dynamic> json) =>
      _$BsSummaryModelFromJson(_parseNumericFields(json));

  static Map<String, dynamic> _parseNumericFields(Map<String, dynamic> json) {
    final result = Map<String, dynamic>.from(json);

    final numericFields = [
      'total_assets', 'current_assets', 'non_current_assets',
      'total_liabilities', 'current_liabilities', 'non_current_liabilities',
      'total_equity', 'balance_check',
      'prev_total_assets', 'prev_total_equity',
      'assets_change_pct', 'equity_change_pct',
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

/// B/S Detail Row from get_bs_detail() RPC
@freezed
class BsDetailRowModel with _$BsDetailRowModel {
  const factory BsDetailRowModel({
    @Default('') String section,
    @JsonKey(name: 'section_order') @Default(0) int sectionOrder,
    @JsonKey(name: 'account_code') @Default('') String accountCode,
    @JsonKey(name: 'account_name') @Default('') String accountName,
    @Default(0) double balance,
  }) = _BsDetailRowModel;

  factory BsDetailRowModel.fromJson(Map<String, dynamic> json) =>
      _$BsDetailRowModelFromJson(_parseNumericFields(json));

  static Map<String, dynamic> _parseNumericFields(Map<String, dynamic> json) {
    final result = Map<String, dynamic>.from(json);

    if (result['balance'] != null) {
      if (result['balance'] is String) {
        result['balance'] = double.tryParse(result['balance'] as String) ?? 0.0;
      } else if (result['balance'] is int) {
        result['balance'] = (result['balance'] as int).toDouble();
      }
    }
    if (result['section_order'] != null && result['section_order'] is String) {
      result['section_order'] = int.tryParse(result['section_order'] as String) ?? 0;
    }

    return result;
  }
}
