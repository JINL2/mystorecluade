import 'package:freezed_annotation/freezed_annotation.dart';

part 'counter_party_deletion_validation.freezed.dart';

/// Validation result for counter party deletion (Pure Domain - No JSON)
@freezed
class CounterPartyDeletionValidation with _$CounterPartyDeletionValidation {
  const factory CounterPartyDeletionValidation({
    required bool canDelete,
    required bool hasUnpaidDebts,
    required int unpaidDebtCount,
    required double unpaidDebtAmount,
    required bool hasActiveTransactions,
    required int journalEntryCount,
    required int journalLineCount,
    required String reason,
  }) = _CounterPartyDeletionValidation;
}
