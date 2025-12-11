// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'counter_party.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CounterPartyImpl _$$CounterPartyImplFromJson(Map<String, dynamic> json) =>
    _$CounterPartyImpl(
      counterpartyId: json['counterparty_id'] as String,
      companyId: json['company_id'] as String,
      name: json['name'] as String,
      type: counterPartyTypeFromJson(json['type']),
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      address: json['address'] as String?,
      notes: json['notes'] as String?,
      isInternal: json['is_internal'] as bool? ?? false,
      linkedCompanyId: json['linked_company_id'] as String?,
      createdBy: json['created_by'] as String?,
      createdAt: _dateTimeFromJson(json['created_at'] as String),
      updatedAt: _dateTimeFromJsonNullable(json['updated_at'] as String?),
      isDeleted: json['is_deleted'] as bool? ?? false,
      lastTransactionDate:
          _dateTimeFromJsonNullable(json['last_transaction_date'] as String?),
      totalTransactions: (json['total_transactions'] as num?)?.toInt() ?? 0,
      balance: (json['balance'] as num?)?.toDouble() ?? 0.0,
    );

Map<String, dynamic> _$$CounterPartyImplToJson(_$CounterPartyImpl instance) =>
    <String, dynamic>{
      'counterparty_id': instance.counterpartyId,
      'company_id': instance.companyId,
      'name': instance.name,
      'type': counterPartyTypeToJson(instance.type),
      'email': instance.email,
      'phone': instance.phone,
      'address': instance.address,
      'notes': instance.notes,
      'is_internal': instance.isInternal,
      'linked_company_id': instance.linkedCompanyId,
      'created_by': instance.createdBy,
      'created_at': _dateTimeToJson(instance.createdAt),
      if (_dateTimeToJsonNullable(instance.updatedAt) case final value?)
        'updated_at': value,
      'is_deleted': instance.isDeleted,
      'last_transaction_date':
          _dateTimeToJsonNullable(instance.lastTransactionDate),
      'total_transactions': instance.totalTransactions,
      'balance': instance.balance,
    };
