// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'counter_party_deletion_validation_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CounterPartyDeletionValidationDtoImpl
    _$$CounterPartyDeletionValidationDtoImplFromJson(
            Map<String, dynamic> json) =>
        _$CounterPartyDeletionValidationDtoImpl(
          canDelete: json['canDelete'] as bool,
          hasUnpaidDebts: json['hasUnpaidDebts'] as bool,
          unpaidDebtCount: (json['unpaidDebtCount'] as num).toInt(),
          unpaidDebtAmount: (json['unpaidDebtAmount'] as num).toDouble(),
          hasActiveTransactions: json['hasActiveTransactions'] as bool,
          journalEntryCount: (json['journalEntryCount'] as num).toInt(),
          journalLineCount: (json['journalLineCount'] as num).toInt(),
          reason: json['reason'] as String,
        );

Map<String, dynamic> _$$CounterPartyDeletionValidationDtoImplToJson(
        _$CounterPartyDeletionValidationDtoImpl instance) =>
    <String, dynamic>{
      'canDelete': instance.canDelete,
      'hasUnpaidDebts': instance.hasUnpaidDebts,
      'unpaidDebtCount': instance.unpaidDebtCount,
      'unpaidDebtAmount': instance.unpaidDebtAmount,
      'hasActiveTransactions': instance.hasActiveTransactions,
      'journalEntryCount': instance.journalEntryCount,
      'journalLineCount': instance.journalLineCount,
      'reason': instance.reason,
    };
