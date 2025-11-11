// lib/features/auth/domain/entities/company_entity.dart

import 'package:freezed_annotation/freezed_annotation.dart';
import '../value_objects/validation_result.dart';

part 'company_entity.freezed.dart';

/// Company entity representing a business organization in the system.
///
/// A company can have multiple stores and is owned by a user.
/// This entity contains all business rules for company validation.
///
/// Migrated to Freezed for:
/// - Immutability guarantees
/// - Automatic copyWith generation
/// - Type-safe equality
/// - Reduced boilerplate
@freezed
class Company with _$Company {
  const Company._();

  const factory Company({
    required String id,
    required String name,
    required String companyTypeId,
    required String currencyId,
    String? companyCode, // Unique code for employees to join
    required String ownerId,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) = _Company;

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
}
