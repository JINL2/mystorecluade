// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_entry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TransactionEntryImpl _$$TransactionEntryImplFromJson(
        Map<String, dynamic> json) =>
    _$TransactionEntryImpl(
      amount: (json['amount'] as num).toDouble(),
      formattedAmount: json['formattedAmount'] as String,
      debitAccount: json['debitAccount'] as String,
      creditAccount: json['creditAccount'] as String,
      employeeName: json['employeeName'] as String,
      storeName: json['storeName'] as String,
      entryDate: DateTime.parse(json['entryDate'] as String),
      description: json['description'] as String?,
    );

Map<String, dynamic> _$$TransactionEntryImplToJson(
        _$TransactionEntryImpl instance) =>
    <String, dynamic>{
      'amount': instance.amount,
      'formattedAmount': instance.formattedAmount,
      'debitAccount': instance.debitAccount,
      'creditAccount': instance.creditAccount,
      'employeeName': instance.employeeName,
      'storeName': instance.storeName,
      'entryDate': instance.entryDate.toIso8601String(),
      'description': instance.description,
    };
