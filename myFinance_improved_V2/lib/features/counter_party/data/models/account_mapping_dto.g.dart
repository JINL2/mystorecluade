// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_mapping_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AccountMappingDtoImpl _$$AccountMappingDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$AccountMappingDtoImpl(
      mappingId: json['mapping_id'] as String,
      myCompanyId: json['my_company_id'] as String,
      myAccountId: json['my_account_id'] as String,
      counterpartyId: json['counterparty_id'] as String,
      linkedAccountId: json['linked_account_id'] as String,
      direction: json['direction'] as String,
      createdBy: json['created_by'] as String?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      linkedCompanyId: json['linked_company_id'] as String?,
      myAccountName: json['my_account_name'] as String?,
      linkedAccountName: json['linked_account_name'] as String?,
      linkedCompanyName: json['linked_company_name'] as String?,
      myAccountType: json['my_account_type'] as String?,
      linkedAccountType: json['linked_account_type'] as String?,
    );

Map<String, dynamic> _$$AccountMappingDtoImplToJson(
        _$AccountMappingDtoImpl instance) =>
    <String, dynamic>{
      'mapping_id': instance.mappingId,
      'my_company_id': instance.myCompanyId,
      'my_account_id': instance.myAccountId,
      'counterparty_id': instance.counterpartyId,
      'linked_account_id': instance.linkedAccountId,
      'direction': instance.direction,
      'created_by': instance.createdBy,
      'created_at': instance.createdAt?.toIso8601String(),
      'linked_company_id': instance.linkedCompanyId,
      'my_account_name': instance.myAccountName,
      'linked_account_name': instance.linkedAccountName,
      'linked_company_name': instance.linkedCompanyName,
      'my_account_type': instance.myAccountType,
      'linked_account_type': instance.linkedAccountType,
    };
