// lib/features/cash_ending/data/models/freezed/balance_summary_dto.dart

import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../domain/entities/balance_summary.dart';

part 'balance_summary_dto.freezed.dart';
part 'balance_summary_dto.g.dart';

/// DTO for Balance Summary (Journal vs Real comparison)
///
/// This represents the data returned from get_cash_location_balance_summary RPC.
/// It shows the comparison between Journal (book balance) and Real (actual cash count).
@freezed
class BalanceSummaryDto with _$BalanceSummaryDto {
  const BalanceSummaryDto._();

  const factory BalanceSummaryDto({
    required bool success,
    @JsonKey(name: 'location_id') required String locationId,
    @JsonKey(name: 'location_name') required String locationName,
    @JsonKey(name: 'location_type') required String locationType,

    // Balance amounts
    @JsonKey(name: 'total_journal') required double totalJournal,
    @JsonKey(name: 'total_real') required double totalReal,
    required double difference,

    // Status flags
    @JsonKey(name: 'is_balanced') required bool isBalanced,
    @JsonKey(name: 'has_shortage') required bool hasShortage,
    @JsonKey(name: 'has_surplus') required bool hasSurplus,

    // Currency info
    @JsonKey(name: 'currency_symbol') required String currencySymbol,
    @JsonKey(name: 'currency_code') required String currencyCode,

    // Metadata
    @JsonKey(name: 'last_updated') DateTime? lastUpdated,
    String? error,
  }) = _BalanceSummaryDto;

  /// From JSON (Supabase RPC response)
  factory BalanceSummaryDto.fromJson(Map<String, dynamic> json) =>
      _$BalanceSummaryDtoFromJson(json);

  /// To Domain Entity
  BalanceSummary toEntity() {
    return BalanceSummary(
      locationId: locationId,
      locationName: locationName,
      locationType: locationType,
      totalJournal: totalJournal,
      totalReal: totalReal,
      difference: difference,
      isBalanced: isBalanced,
      hasShortage: hasShortage,
      hasSurplus: hasSurplus,
      currencySymbol: currencySymbol,
      currencyCode: currencyCode,
      lastUpdated: lastUpdated,
    );
  }

  /// Helper: Get formatted total journal
  String get formattedTotalJournal =>
      '$currencySymbol${totalJournal.toStringAsFixed(2)}';

  /// Helper: Get formatted total real
  String get formattedTotalReal =>
      '$currencySymbol${totalReal.toStringAsFixed(2)}';

  /// Helper: Get formatted difference
  String get formattedDifference =>
      '$currencySymbol${difference.toStringAsFixed(2)}';

  /// Helper: Get status message
  String get statusMessage {
    if (isBalanced) return 'Balanced ✓';
    if (hasShortage) return 'Shortage (${formattedDifference})';
    if (hasSurplus) return 'Surplus (+${formattedDifference})';
    return 'Unknown';
  }
}
