// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_companies_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserCompaniesModelImpl _$$UserCompaniesModelImplFromJson(
        Map<String, dynamic> json) =>
    _$UserCompaniesModelImpl(
      userId: json['user_id'] as String,
      userFirstName: json['user_first_name'] as String?,
      userLastName: json['user_last_name'] as String?,
      profileImage: json['profile_image'] as String?,
      companyCount: (json['company_count'] as num?)?.toInt(),
      companies: (json['companies'] as List<dynamic>)
          .map((e) => CompanyModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$UserCompaniesModelImplToJson(
        _$UserCompaniesModelImpl instance) =>
    <String, dynamic>{
      'user_id': instance.userId,
      'user_first_name': instance.userFirstName,
      'user_last_name': instance.userLastName,
      'profile_image': instance.profileImage,
      'company_count': instance.companyCount,
      'companies': instance.companies,
    };

_$CompanyModelImpl _$$CompanyModelImplFromJson(Map<String, dynamic> json) =>
    _$CompanyModelImpl(
      companyId: json['company_id'] as String,
      companyName: json['company_name'] as String,
      companyCode: json['company_code'] as String?,
      storeCount: (json['store_count'] as num?)?.toInt(),
      role: json['role'] == null
          ? null
          : RoleModel.fromJson(json['role'] as Map<String, dynamic>),
      stores: (json['stores'] as List<dynamic>?)
              ?.map((e) => StoreModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$CompanyModelImplToJson(_$CompanyModelImpl instance) =>
    <String, dynamic>{
      'company_id': instance.companyId,
      'company_name': instance.companyName,
      'company_code': instance.companyCode,
      'store_count': instance.storeCount,
      'role': instance.role,
      'stores': instance.stores,
    };

_$StoreModelImpl _$$StoreModelImplFromJson(Map<String, dynamic> json) =>
    _$StoreModelImpl(
      storeId: json['store_id'] as String,
      storeName: json['store_name'] as String,
      storeCode: json['store_code'] as String?,
      storePhone: json['store_phone'] as String?,
    );

Map<String, dynamic> _$$StoreModelImplToJson(_$StoreModelImpl instance) =>
    <String, dynamic>{
      'store_id': instance.storeId,
      'store_name': instance.storeName,
      'store_code': instance.storeCode,
      'store_phone': instance.storePhone,
    };

_$RoleModelImpl _$$RoleModelImplFromJson(Map<String, dynamic> json) =>
    _$RoleModelImpl(
      roleId: json['role_id'] as String?,
      roleName: json['role_name'] as String,
      permissions: (json['permissions'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$$RoleModelImplToJson(_$RoleModelImpl instance) =>
    <String, dynamic>{
      'role_id': instance.roleId,
      'role_name': instance.roleName,
      'permissions': instance.permissions,
    };
