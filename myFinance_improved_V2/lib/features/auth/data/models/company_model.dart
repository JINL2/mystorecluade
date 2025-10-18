// lib/features/auth/data/models/company_model.dart

import '../../domain/entities/company_entity.dart';

/// Company Model
///
/// 📦 택배 상자 - JSON 직렬화 가능한 데이터 모델
///
/// 책임:
/// - JSON ↔ Dart 객체 변환
/// - Database 컬럼명 매핑
/// - Entity 변환
///
/// 이 모델은 Supabase JSON 구조에 대한 지식을 가지고 있습니다.
class CompanyModel {
  final String companyId;
  final String companyName;
  final String? companyCode;
  final String companyTypeId;
  final String ownerId;
  final String? companyBusinessNumber;
  final String? companyEmail;
  final String? companyPhone;
  final String? companyAddress;
  final String baseCurrencyId;
  final String? timezone;
  final String createdAt;
  final String? updatedAt;
  final bool isDeleted;

  const CompanyModel({
    required this.companyId,
    required this.companyName,
    this.companyCode,
    required this.companyTypeId,
    required this.ownerId,
    this.companyBusinessNumber,
    this.companyEmail,
    this.companyPhone,
    this.companyAddress,
    required this.baseCurrencyId,
    this.timezone,
    required this.createdAt,
    this.updatedAt,
    this.isDeleted = false,
  });

  /// Create from Supabase JSON
  factory CompanyModel.fromJson(Map<String, dynamic> json) {
    return CompanyModel(
      companyId: json['company_id'] as String,
      companyName: json['company_name'] as String,
      companyCode: json['company_code'] as String?,
      companyTypeId: json['company_type_id'] as String,
      ownerId: json['owner_id'] as String,
      companyBusinessNumber: json['company_business_number'] as String?,
      companyEmail: json['company_email'] as String?,
      companyPhone: json['company_phone'] as String?,
      companyAddress: json['company_address'] as String?,
      baseCurrencyId: json['base_currency_id'] as String? ?? json['currency_id'] as String,
      timezone: json['timezone'] as String?,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String?,
      isDeleted: json['is_deleted'] as bool? ?? false,
    );
  }

  /// Convert to Supabase JSON
  Map<String, dynamic> toJson() {
    return {
      'company_id': companyId,
      'company_name': companyName,
      'company_code': companyCode,
      'company_type_id': companyTypeId,
      'owner_id': ownerId,
      'company_business_number': companyBusinessNumber,
      'company_email': companyEmail,
      'company_phone': companyPhone,
      'company_address': companyAddress,
      'base_currency_id': baseCurrencyId,
      'timezone': timezone,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'is_deleted': isDeleted,
    };
  }

  /// Convert to Domain Entity
  Company toEntity() {
    return Company(
      id: companyId,
      name: companyName,
      businessNumber: companyBusinessNumber,
      email: companyEmail,
      phone: companyPhone,
      address: companyAddress,
      companyTypeId: companyTypeId,
      currencyId: baseCurrencyId,
      companyCode: companyCode,
      ownerId: ownerId,
      createdAt: DateTime.parse(createdAt),
      updatedAt: updatedAt != null ? DateTime.parse(updatedAt!) : null,
    );
  }

  /// Create from Domain Entity
  factory CompanyModel.fromEntity(Company entity) {
    return CompanyModel(
      companyId: entity.id,
      companyName: entity.name,
      companyCode: entity.companyCode,
      companyTypeId: entity.companyTypeId,
      ownerId: entity.ownerId,
      companyBusinessNumber: entity.businessNumber,
      companyEmail: entity.email,
      companyPhone: entity.phone,
      companyAddress: entity.address,
      baseCurrencyId: entity.currencyId,
      createdAt: entity.createdAt.toIso8601String(),
      updatedAt: entity.updatedAt?.toIso8601String(),
    );
  }

  /// Create insert map for Supabase
  Map<String, dynamic> toInsertMap() {
    final map = <String, dynamic>{
      'company_name': companyName,
      'company_type_id': companyTypeId,
      'owner_id': ownerId,
      'base_currency_id': baseCurrencyId,
    };

    if (companyBusinessNumber != null) {
      map['company_business_number'] = companyBusinessNumber;
    }
    if (companyEmail != null) map['company_email'] = companyEmail;
    if (companyPhone != null) map['company_phone'] = companyPhone;
    if (companyAddress != null) map['company_address'] = companyAddress;
    if (timezone != null) map['timezone'] = timezone;

    return map;
  }
}
