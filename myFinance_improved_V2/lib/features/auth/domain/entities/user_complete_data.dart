// lib/features/auth/domain/entities/user_complete_data.dart

import 'package:freezed_annotation/freezed_annotation.dart';
import 'user_entity.dart';
import 'company_entity.dart';
import 'store_entity.dart';

part 'user_complete_data.freezed.dart';
part 'user_complete_data.g.dart';

/// User Complete Data
///
/// Combined user data with their companies and stores.
/// Returned from getUserCompleteData() RPC call.
///
/// ✅ Clean Architecture:
/// - Domain Entity (not tied to any framework)
/// - Immutable (Freezed)
/// - Type-safe
@Freezed(fromJson: true, toJson: true)
class UserCompleteData with _$UserCompleteData {
  const UserCompleteData._(); // For custom methods

  const factory UserCompleteData({
    /// User profile data
    required User user,

    /// Companies where user is owner or member
    @Default([]) List<Company> companies,

    /// Stores where user has access
    @Default([]) List<Store> stores,
  }) = _UserCompleteData;

  /// Create from RPC response JSON
  ///
  /// Handles the nested structure returned by get_user_companies_and_stores RPC
  factory UserCompleteData.fromJson(Map<String, dynamic> json) =>
      _$UserCompleteDataFromJson(json);

  // ============================================================
  // Business Logic (Domain Methods)
  // ============================================================

  /// Get active companies (not deleted)
  ///
  /// Used by GetUserDataUseCase to filter out deleted companies
  List<Company> get activeCompanies =>
      companies.where((c) => !c.isDeleted).toList();

  /// Get active stores (not deleted)
  ///
  /// Used by GetUserDataUseCase to filter out deleted stores
  List<Store> get activeStores => stores.where((s) => !s.isDeleted).toList();
}
