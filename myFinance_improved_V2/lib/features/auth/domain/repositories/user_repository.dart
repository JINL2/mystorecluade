// lib/features/auth/domain/repositories/user_repository.dart

import '../entities/company_entity.dart';
import '../entities/store_entity.dart';
import '../entities/user_entity.dart';

/// User repository interface.
///
/// Defines operations for managing user profiles and data.
/// Implementation will be in the data layer.
abstract class UserRepository {
  /// Find user by ID
  ///
  /// Returns the [User] or `null` if not found.
  Future<User?> findById(String userId);

  /// Find user by email
  ///
  /// Returns the [User] or `null` if not found.
  Future<User?> findByEmail(String email);

  /// Check if email exists
  ///
  /// Returns `true` if email is already registered.
  Future<bool> emailExists(String email);

  /// Update user profile
  ///
  /// Updates user's first name, last name, and other profile data.
  /// Returns the updated [User].
  Future<User> updateProfile({
    required String userId,
    String? firstName,
    String? lastName,
  });

  /// Update last login timestamp
  ///
  /// Records when the user last logged in.
  Future<void> updateLastLogin({required String userId});

  /// Get user's companies
  ///
  /// Returns companies where the user is owner or member.
  Future<List<Company>> getCompanies(String userId);

  /// Get user's stores
  ///
  /// Returns stores where the user has access.
  Future<List<Store>> getStores(String userId);

  /// Check if user has access to company
  ///
  /// Returns `true` if user is owner or member of the company.
  Future<bool> hasCompanyAccess({
    required String userId,
    required String companyId,
  });

  /// Check if user has access to store
  ///
  /// Returns `true` if user is assigned to the store.
  Future<bool> hasStoreAccess({
    required String userId,
    required String storeId,
  });

  /// Get user's complete data including companies and stores
  ///
  /// Returns raw data map with user info, companies, and stores.
  /// Used for app initialization and data refresh.
  Future<Map<String, dynamic>> getUserCompleteData(String userId);
}
