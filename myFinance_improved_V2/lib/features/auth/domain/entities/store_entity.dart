// lib/features/auth/domain/entities/store_entity.dart

import 'package:freezed_annotation/freezed_annotation.dart';
import '../value_objects/validation_result.dart';

part 'store_entity.freezed.dart';
part 'store_entity.g.dart';

/// Store Entity (Freezed Version)
///
/// 🎯 Improvements:
/// - Auto-generates: copyWith, ==, hashCode, toString, fromJson, toJson
/// - Combines Entity + Model (no separate StoreModel needed)
/// - Type-safe JSON serialization
/// - Immutable by default
///
/// 📊 Code Reduction:
/// - Old: Store entity (164 lines) + StoreModel (130 lines) = 294 lines
/// - New: Store entity (this file) = ~140 lines (52% reduction)
@freezed
class Store with _$Store {
  const Store._();

  const factory Store({
    @JsonKey(name: 'store_id') required String id,
    @JsonKey(name: 'store_name') required String name,
    @JsonKey(name: 'company_id') required String companyId,
    @JsonKey(name: 'store_code') String? storeCode,
    @JsonKey(name: 'store_phone') String? phone,
    @JsonKey(name: 'store_address') String? address,
    String? timezone,
    String? description,
    @JsonKey(name: 'is_active') @Default(true) bool isActive,

    // Operational settings
    @JsonKey(name: 'huddle_time') int? huddleTimeMinutes,
    @JsonKey(name: 'payment_time') int? paymentTimeDays,
    @JsonKey(name: 'allowed_distance') double? allowedDistanceMeters,

    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
    @JsonKey(name: 'is_deleted') @Default(false) bool isDeleted,
  }) = _Store;

  factory Store.fromJson(Map<String, dynamic> json) => _$StoreFromJson(json);

  // ============================================================
  // Business Logic
  // ============================================================

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

  // ============================================================
  // Data Layer Methods
  // ============================================================

  /// Create insert map for Supabase
  Map<String, dynamic> toInsertMap() {
    final map = <String, dynamic>{
      'store_name': name,
      'company_id': companyId,
    };

    if (storeCode != null) map['store_code'] = storeCode;
    if (address != null) map['store_address'] = address;
    if (phone != null) map['store_phone'] = phone;
    if (huddleTimeMinutes != null) map['huddle_time'] = huddleTimeMinutes;
    if (paymentTimeDays != null) map['payment_time'] = paymentTimeDays;
    if (allowedDistanceMeters != null) map['allowed_distance'] = allowedDistanceMeters?.toInt();

    return map;
  }
}
