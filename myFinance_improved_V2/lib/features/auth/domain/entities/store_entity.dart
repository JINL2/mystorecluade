// lib/features/auth/domain/entities/store_entity.dart

import '../value_objects/validation_result.dart';

/// Store entity representing a physical or virtual location of a company.
///
/// A store belongs to a company and can have multiple employees.
/// This entity contains all business rules for store validation.
class Store {
  final String id;
  final String name;
  final String companyId;
  final String? storeCode; // Unique code within company
  final String? phone;
  final String? address;
  final String? timezone; // e.g., "Asia/Seoul", "America/New_York"
  final String? description;
  final bool isActive;

  // Operational settings
  final int? huddleTimeMinutes; // Meeting duration in minutes
  final int? paymentTimeDays; // Payment terms in days
  final double? allowedDistanceMeters; // Allowed distance for attendance

  final DateTime createdAt;
  final DateTime? updatedAt;

  const Store({
    required this.id,
    required this.name,
    required this.companyId,
    this.storeCode,
    this.phone,
    this.address,
    this.timezone,
    this.description,
    this.isActive = true,
    this.huddleTimeMinutes,
    this.paymentTimeDays,
    this.allowedDistanceMeters,
    required this.createdAt,
    this.updatedAt,
  });

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

  /// Create a copy with updated fields
  Store copyWith({
    String? id,
    String? name,
    String? companyId,
    String? storeCode,
    String? phone,
    String? address,
    String? timezone,
    String? description,
    bool? isActive,
    int? huddleTimeMinutes,
    int? paymentTimeDays,
    double? allowedDistanceMeters,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Store(
      id: id ?? this.id,
      name: name ?? this.name,
      companyId: companyId ?? this.companyId,
      storeCode: storeCode ?? this.storeCode,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      timezone: timezone ?? this.timezone,
      description: description ?? this.description,
      isActive: isActive ?? this.isActive,
      huddleTimeMinutes: huddleTimeMinutes ?? this.huddleTimeMinutes,
      paymentTimeDays: paymentTimeDays ?? this.paymentTimeDays,
      allowedDistanceMeters: allowedDistanceMeters ?? this.allowedDistanceMeters,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Store &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Store(id: $id, name: $name, companyId: $companyId, storeCode: $storeCode, isActive: $isActive)';
  }
}
