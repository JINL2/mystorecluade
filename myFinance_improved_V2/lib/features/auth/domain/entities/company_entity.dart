// lib/features/auth/domain/entities/company_entity.dart

import '../value_objects/validation_result.dart';
import '../validators/email_validator.dart';

/// Company entity representing a business organization in the system.
///
/// A company can have multiple stores and is owned by a user.
/// This entity contains all business rules for company validation.
class Company {
  final String id;
  final String name;
  final String? businessNumber;
  final String? email;
  final String? phone;
  final String? address;
  final String companyTypeId;
  final String currencyId;
  final String? companyCode; // Unique code for employees to join
  final String ownerId;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const Company({
    required this.id,
    required this.name,
    this.businessNumber,
    this.email,
    this.phone,
    this.address,
    required this.companyTypeId,
    required this.currencyId,
    this.companyCode,
    required this.ownerId,
    required this.createdAt,
    this.updatedAt,
  });

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

  /// Create a copy with updated fields
  Company copyWith({
    String? id,
    String? name,
    String? businessNumber,
    String? email,
    String? phone,
    String? address,
    String? companyTypeId,
    String? currencyId,
    String? companyCode,
    String? ownerId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Company(
      id: id ?? this.id,
      name: name ?? this.name,
      businessNumber: businessNumber ?? this.businessNumber,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      companyTypeId: companyTypeId ?? this.companyTypeId,
      currencyId: currencyId ?? this.currencyId,
      companyCode: companyCode ?? this.companyCode,
      ownerId: ownerId ?? this.ownerId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Company &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Company(id: $id, name: $name, companyCode: $companyCode, ownerId: $ownerId)';
  }
}
