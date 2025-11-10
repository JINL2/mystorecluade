// lib/features/auth/domain/entities/company_entity.dart

import 'package:freezed_annotation/freezed_annotation.dart';
import '../value_objects/validation_result.dart';
import '../validators/email_validator.dart';

part 'company_entity.freezed.dart';
part 'company_entity.g.dart';

/// Company Entity (Freezed Version)
///
/// 🎯 Improvements:
/// - Auto-generates: copyWith, ==, hashCode, toString, fromJson, toJson
/// - Combines Entity + Model (no separate CompanyModel needed)
/// - Type-safe JSON serialization
/// - Immutable by default
///
/// 📊 Code Reduction:
/// - Old: Company entity (137 lines) + CompanyModel (143 lines) = 280 lines
/// - New: Company entity (this file) = ~110 lines (61% reduction)
@freezed
class Company with _$Company {
  const Company._();

  const factory Company({
    @JsonKey(name: 'company_id') required String id,
    @JsonKey(name: 'company_name') required String name,
    @JsonKey(name: 'company_business_number') String? businessNumber,
    @JsonKey(name: 'company_email') String? email,
    @JsonKey(name: 'company_phone') String? phone,
    @JsonKey(name: 'company_address') String? address,
    @JsonKey(name: 'company_type_id') required String companyTypeId,
    @JsonKey(name: 'base_currency_id') required String currencyId,
    @JsonKey(name: 'company_code') String? companyCode,
    @JsonKey(name: 'owner_id') required String ownerId,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
    @JsonKey(name: 'timezone') String? timezone,
    @JsonKey(name: 'is_deleted') @Default(false) bool isDeleted,
  }) = _Company;

  factory Company.fromJson(Map<String, dynamic> json) => _$CompanyFromJson(json);

  // ============================================================
  // Business Logic
  // ============================================================

  /// Validates the company entity
  ValidationResult validate() {
    final errors = <String>[];

    // Name validation
    if (name.trim().isEmpty) {
      errors.add('Company name is required');
    }
    if (name.trim().length < 2) {
      errors.add('Company name must be at least 2 characters');
    }
    if (name.trim().length > 100) {
      errors.add('Company name must be less than 100 characters');
    }

    // Email validation (optional, but if provided must be valid)
    if (email != null && email!.isNotEmpty) {
      if (!EmailValidator.isValid(email!)) {
        errors.add('Invalid email format');
      }
    }

    // Business number validation (optional)
    if (businessNumber != null && businessNumber!.isNotEmpty) {
      if (businessNumber!.length < 5) {
        errors.add('Business number too short');
      }
    }

    // Phone validation (optional)
    if (phone != null && phone!.isNotEmpty) {
      if (phone!.length < 8) {
        errors.add('Phone number too short');
      }
    }

    // Company type and currency are required
    if (companyTypeId.isEmpty) {
      errors.add('Company type is required');
    }
    if (currencyId.isEmpty) {
      errors.add('Currency is required');
    }

    return ValidationResult(
      isValid: errors.isEmpty,
      errors: errors,
    );
  }

  /// Check if company has a join code
  bool get hasJoinCode => companyCode != null && companyCode!.isNotEmpty;

  // ============================================================
  // Data Layer Methods
  // ============================================================

  /// Create insert map for Supabase
  Map<String, dynamic> toInsertMap() {
    final map = <String, dynamic>{
      'company_name': name,
      'company_type_id': companyTypeId,
      'owner_id': ownerId,
      'base_currency_id': currencyId,
    };

    if (businessNumber != null) map['company_business_number'] = businessNumber;
    if (email != null) map['company_email'] = email;
    if (phone != null) map['company_phone'] = phone;
    if (address != null) map['company_address'] = address;
    if (timezone != null) map['timezone'] = timezone;

    return map;
  }
}
