// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'counter_party_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CounterPartyImpl _$$CounterPartyImplFromJson(Map<String, dynamic> json) =>
    _$CounterPartyImpl(
      counterpartyId: json['counterparty_id'] as String,
      companyId: json['company_id'] as String,
      name: json['name'] as String,
      type: _typeFromJson(json['type']),
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      address: json['address'] as String?,
      notes: json['notes'] as String?,
      isInternal: json['is_internal'] as bool? ?? false,
      linkedCompanyId: json['linked_company_id'] as String?,
      createdBy: json['created_by'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
      isDeleted: json['is_deleted'] as bool? ?? false,
      lastTransactionDate: json['last_transaction_date'] == null
          ? null
          : DateTime.parse(json['last_transaction_date'] as String),
      totalTransactions: (json['total_transactions'] as num?)?.toInt() ?? 0,
      balance: (json['balance'] as num?)?.toDouble() ?? 0.0,
    );

Map<String, dynamic> _$$CounterPartyImplToJson(_$CounterPartyImpl instance) =>
    <String, dynamic>{
      'counterparty_id': instance.counterpartyId,
      'company_id': instance.companyId,
      'name': instance.name,
      'type': _typeToJson(instance.type),
      'email': instance.email,
      'phone': instance.phone,
      'address': instance.address,
      'notes': instance.notes,
      'is_internal': instance.isInternal,
      'linked_company_id': instance.linkedCompanyId,
      'created_by': instance.createdBy,
      'created_at': instance.createdAt.toIso8601String(),
      if (instance.updatedAt?.toIso8601String() case final value?)
        'updated_at': value,
      'is_deleted': instance.isDeleted,
      'last_transaction_date': instance.lastTransactionDate?.toIso8601String(),
      'total_transactions': instance.totalTransactions,
      'balance': instance.balance,
    };

_$CounterPartyStatsImpl _$$CounterPartyStatsImplFromJson(
        Map<String, dynamic> json) =>
    _$CounterPartyStatsImpl(
      total: (json['total'] as num).toInt(),
      suppliers: (json['suppliers'] as num).toInt(),
      customers: (json['customers'] as num).toInt(),
      employees: (json['employees'] as num).toInt(),
      teamMembers: (json['teamMembers'] as num).toInt(),
      myCompanies: (json['myCompanies'] as num).toInt(),
      others: (json['others'] as num).toInt(),
      activeCount: (json['activeCount'] as num).toInt(),
      inactiveCount: (json['inactiveCount'] as num).toInt(),
      recentAdditions: (json['recent_additions'] as List<dynamic>)
          .map((e) => CounterParty.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$CounterPartyStatsImplToJson(
        _$CounterPartyStatsImpl instance) =>
    <String, dynamic>{
      'total': instance.total,
      'suppliers': instance.suppliers,
      'customers': instance.customers,
      'employees': instance.employees,
      'teamMembers': instance.teamMembers,
      'myCompanies': instance.myCompanies,
      'others': instance.others,
      'activeCount': instance.activeCount,
      'inactiveCount': instance.inactiveCount,
      'recent_additions': instance.recentAdditions,
    };

_$CounterPartyFormDataImpl _$$CounterPartyFormDataImplFromJson(
        Map<String, dynamic> json) =>
    _$CounterPartyFormDataImpl(
      counterpartyId: json['counterpartyId'] as String?,
      companyId: json['companyId'] as String,
      name: json['name'] as String? ?? '',
      type: $enumDecodeNullable(_$CounterPartyTypeEnumMap, json['type']) ??
          CounterPartyType.other,
      email: json['email'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      address: json['address'] as String? ?? '',
      notes: json['notes'] as String? ?? '',
      isInternal: json['isInternal'] as bool? ?? false,
      linkedCompanyId: json['linkedCompanyId'] as String?,
    );

Map<String, dynamic> _$$CounterPartyFormDataImplToJson(
        _$CounterPartyFormDataImpl instance) =>
    <String, dynamic>{
      'counterpartyId': instance.counterpartyId,
      'companyId': instance.companyId,
      'name': instance.name,
      'type': _$CounterPartyTypeEnumMap[instance.type]!,
      'email': instance.email,
      'phone': instance.phone,
      'address': instance.address,
      'notes': instance.notes,
      'isInternal': instance.isInternal,
      'linkedCompanyId': instance.linkedCompanyId,
    };

const _$CounterPartyTypeEnumMap = {
  CounterPartyType.myCompany: 'My Company',
  CounterPartyType.teamMember: 'Team Member',
  CounterPartyType.supplier: 'Suppliers',
  CounterPartyType.employee: 'Employees',
  CounterPartyType.customer: 'Customers',
  CounterPartyType.other: 'Others',
};

_$CounterPartyFilterImpl _$$CounterPartyFilterImplFromJson(
        Map<String, dynamic> json) =>
    _$CounterPartyFilterImpl(
      searchQuery: json['searchQuery'] as String?,
      types: (json['types'] as List<dynamic>?)
          ?.map((e) => $enumDecode(_$CounterPartyTypeEnumMap, e))
          .toList(),
      sortBy: $enumDecodeNullable(
              _$CounterPartySortOptionEnumMap, json['sortBy']) ??
          CounterPartySortOption.name,
      ascending: json['ascending'] as bool? ?? true,
      isInternal: json['isInternal'] as bool?,
      createdAfter: json['createdAfter'] == null
          ? null
          : DateTime.parse(json['createdAfter'] as String),
      createdBefore: json['createdBefore'] == null
          ? null
          : DateTime.parse(json['createdBefore'] as String),
      includeDeleted: json['includeDeleted'] as bool? ?? true,
    );

Map<String, dynamic> _$$CounterPartyFilterImplToJson(
        _$CounterPartyFilterImpl instance) =>
    <String, dynamic>{
      'searchQuery': instance.searchQuery,
      'types':
          instance.types?.map((e) => _$CounterPartyTypeEnumMap[e]!).toList(),
      'sortBy': _$CounterPartySortOptionEnumMap[instance.sortBy]!,
      'ascending': instance.ascending,
      'isInternal': instance.isInternal,
      'createdAfter': instance.createdAfter?.toIso8601String(),
      'createdBefore': instance.createdBefore?.toIso8601String(),
      'includeDeleted': instance.includeDeleted,
    };

const _$CounterPartySortOptionEnumMap = {
  CounterPartySortOption.name: 'name',
  CounterPartySortOption.type: 'type',
  CounterPartySortOption.createdAt: 'createdAt',
  CounterPartySortOption.lastTransaction: 'lastTransaction',
  CounterPartySortOption.balance: 'balance',
};

_$CounterPartyResponseSuccessImpl _$$CounterPartyResponseSuccessImplFromJson(
        Map<String, dynamic> json) =>
    _$CounterPartyResponseSuccessImpl(
      data: CounterParty.fromJson(json['data'] as Map<String, dynamic>),
      message: json['message'] as String?,
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$CounterPartyResponseSuccessImplToJson(
        _$CounterPartyResponseSuccessImpl instance) =>
    <String, dynamic>{
      'data': instance.data,
      'message': instance.message,
      'runtimeType': instance.$type,
    };

_$CounterPartyResponseErrorImpl _$$CounterPartyResponseErrorImplFromJson(
        Map<String, dynamic> json) =>
    _$CounterPartyResponseErrorImpl(
      message: json['message'] as String,
      code: json['code'] as String?,
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$CounterPartyResponseErrorImplToJson(
        _$CounterPartyResponseErrorImpl instance) =>
    <String, dynamic>{
      'message': instance.message,
      'code': instance.code,
      'runtimeType': instance.$type,
    };

_$BatchOperationResultImpl _$$BatchOperationResultImplFromJson(
        Map<String, dynamic> json) =>
    _$BatchOperationResultImpl(
      totalCount: (json['totalCount'] as num).toInt(),
      successCount: (json['successCount'] as num).toInt(),
      failureCount: (json['failureCount'] as num).toInt(),
      failedIds:
          (json['failedIds'] as List<dynamic>).map((e) => e as String).toList(),
      message: json['message'] as String?,
    );

Map<String, dynamic> _$$BatchOperationResultImplToJson(
        _$BatchOperationResultImpl instance) =>
    <String, dynamic>{
      'totalCount': instance.totalCount,
      'successCount': instance.successCount,
      'failureCount': instance.failureCount,
      'failedIds': instance.failedIds,
      'message': instance.message,
    };
