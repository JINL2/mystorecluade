// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cpa_audit_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CpaAuditDataImpl _$$CpaAuditDataImplFromJson(Map<String, dynamic> json) =>
    _$CpaAuditDataImpl(
      targetDate: DateTime.parse(json['targetDate'] as String),
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      employeesByStore: (json['employeesByStore'] as List<dynamic>)
          .map((e) => StoreEmployeeSummary.fromJson(e as Map<String, dynamic>))
          .toList(),
      highValueTransactions: (json['highValueTransactions'] as List<dynamic>)
          .map((e) => TransactionEntry.fromJson(e as Map<String, dynamic>))
          .toList(),
      missingDescriptions: (json['missingDescriptions'] as List<dynamic>)
          .map((e) => TransactionEntry.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$CpaAuditDataImplToJson(_$CpaAuditDataImpl instance) =>
    <String, dynamic>{
      'targetDate': instance.targetDate.toIso8601String(),
      'startDate': instance.startDate.toIso8601String(),
      'endDate': instance.endDate.toIso8601String(),
      'employeesByStore': instance.employeesByStore,
      'highValueTransactions': instance.highValueTransactions,
      'missingDescriptions': instance.missingDescriptions,
    };
