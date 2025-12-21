// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransactionDto _$TransactionDtoFromJson(Map<String, dynamic> json) =>
    TransactionDto(
      id: json['id'] as String,
      templateId: json['template_id'] as String,
      debitAccountId: json['debit_account_id'] as String,
      creditAccountId: json['credit_account_id'] as String,
      amount: (json['amount'] as num).toDouble(),
      transactionDate: DateTime.parse(json['transaction_date'] as String),
      description: json['description'] as String?,
      status: json['status'] as String,
      companyId: json['company_id'] as String,
      storeId: json['store_id'] as String?,
      createdBy: json['created_by'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      updatedBy: json['updated_by'] as String,
      counterpartyId: json['counterparty_id'] as String?,
      cashLocationId: json['cash_location_id'] as String?,
      counterpartyCashLocationId:
          json['counterparty_cash_location_id'] as String?,
      tags: json['tags'] as Map<String, dynamic>,
    );

Map<String, dynamic> _$TransactionDtoToJson(TransactionDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'template_id': instance.templateId,
      'debit_account_id': instance.debitAccountId,
      'credit_account_id': instance.creditAccountId,
      'amount': instance.amount,
      'transaction_date': instance.transactionDate.toIso8601String(),
      'description': instance.description,
      'status': instance.status,
      'company_id': instance.companyId,
      'store_id': instance.storeId,
      'created_by': instance.createdBy,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
      'updated_by': instance.updatedBy,
      'counterparty_id': instance.counterpartyId,
      'cash_location_id': instance.cashLocationId,
      'counterparty_cash_location_id': instance.counterpartyCashLocationId,
      'tags': instance.tags,
    };
