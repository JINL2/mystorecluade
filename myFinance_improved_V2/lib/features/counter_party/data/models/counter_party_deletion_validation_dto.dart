import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/counter_party_deletion_validation.dart';

part 'counter_party_deletion_validation_dto.freezed.dart';
part 'counter_party_deletion_validation_dto.g.dart';

/// Counter Party Deletion Validation DTO for JSON serialization
@freezed
class CounterPartyDeletionValidationDto with _$CounterPartyDeletionValidationDto {
  const CounterPartyDeletionValidationDto._();

  const factory CounterPartyDeletionValidationDto({
    required bool canDelete,
    required bool hasUnpaidDebts,
    required int unpaidDebtCount,
    required double unpaidDebtAmount,
    required bool hasActiveTransactions,
    required int journalEntryCount,
    required int journalLineCount,
    required String reason,
  }) = _CounterPartyDeletionValidationDto;

  factory CounterPartyDeletionValidationDto.fromJson(Map<String, dynamic> json) =>
      _$CounterPartyDeletionValidationDtoFromJson(json);

  /// Convert to Domain Entity
  CounterPartyDeletionValidation toEntity() => CounterPartyDeletionValidation(
    canDelete: canDelete,
    hasUnpaidDebts: hasUnpaidDebts,
    unpaidDebtCount: unpaidDebtCount,
    unpaidDebtAmount: unpaidDebtAmount,
    hasActiveTransactions: hasActiveTransactions,
    journalEntryCount: journalEntryCount,
    journalLineCount: journalLineCount,
    reason: reason,
  );

  /// Create DTO from Entity
  factory CounterPartyDeletionValidationDto.fromEntity(CounterPartyDeletionValidation entity) =>
      CounterPartyDeletionValidationDto(
        canDelete: entity.canDelete,
        hasUnpaidDebts: entity.hasUnpaidDebts,
        unpaidDebtCount: entity.unpaidDebtCount,
        unpaidDebtAmount: entity.unpaidDebtAmount,
        hasActiveTransactions: entity.hasActiveTransactions,
        journalEntryCount: entity.journalEntryCount,
        journalLineCount: entity.journalLineCount,
        reason: entity.reason,
      );
}
