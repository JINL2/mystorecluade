// lib/features/auth/domain/entities/store_entity.dart

import 'package:freezed_annotation/freezed_annotation.dart';
import '../value_objects/validation_result.dart';

part 'store_entity.freezed.dart';

/// Store entity representing a physical or virtual location of a company.
///
/// A store belongs to a company and can have multiple employees.
/// This entity contains all business rules for store validation.
///
/// Migrated to Freezed for:
/// - Immutability guarantees
/// - Automatic copyWith generation
/// - Type-safe equality
/// - Reduced boilerplate
@freezed
class Store with _$Store {
  const Store._();

  const factory Store({
    required String id,
    required String name,
    required String companyId,
    String? storeCode, // Unique code within company
    String? phone,
    String? address,
    String? timezone, // e.g., "Asia/Seoul", "America/New_York"
    String? description,
    @Default(true) bool isActive,
    // Operational settings
    int? huddleTimeMinutes, // Meeting duration in minutes
    int? paymentTimeDays, // Payment terms in days
    double? allowedDistanceMeters, // Allowed distance for attendance
    required DateTime createdAt,
    DateTime? updatedAt,
  }) = _Store;

  /// Validates the store entity
  ValidationResult validate() {
    final errors = <String>[];

    // Name validation
    if (name.trim().isEmpty) {
      errors.add('Store name is required');
    }
    if (name.trim().length < 2) {
      errors.add('Store name must be at least 2 characters');
    }
    if (name.trim().length > 100) {
      errors.add('Store name must be less than 100 characters');
    }

    // Company ID is required
    if (companyId.isEmpty) {
      errors.add('Company ID is required');
    }

    // Store code validation (optional)
    if (storeCode != null && storeCode!.isNotEmpty) {
      if (storeCode!.length < 2) {
        errors.add('Store code too short');
      }
      if (storeCode!.length > 20) {
        errors.add('Store code too long');
      }
      // Store code should be alphanumeric
      if (!RegExp(r'^[a-zA-Z0-9_-]+$').hasMatch(storeCode!)) {
        errors.add('Store code can only contain letters, numbers, hyphens and underscores');
      }
    }

    // Phone validation (optional)
    if (phone != null && phone!.isNotEmpty) {
      if (phone!.length < 8) {
        errors.add('Phone number too short');
      }
    }

    // Timezone validation (optional)
    if (timezone != null && timezone!.isNotEmpty) {
      if (!_isValidTimezone(timezone!)) {
        errors.add('Invalid timezone format');
      }
    }

    return ValidationResult(
      isValid: errors.isEmpty,
      errors: errors,
    );
  }

  bool _isValidTimezone(String tz) {
    // Basic validation for timezone format (e.g., "Asia/Seoul")
    return tz.contains('/') && tz.length > 3;
  }

  /// Check if store has a code
  bool get hasStoreCode => storeCode != null && storeCode!.isNotEmpty;

  /// Get display name with code if available
  String get displayName {
    if (hasStoreCode) {
      return '$name ($storeCode)';
    }
    return name;
  }
}
