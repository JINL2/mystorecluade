// lib/features/auth/domain/repositories/store_repository.dart

import '../entities/store_entity.dart';

/// Store repository interface.
///
/// Defines operations for managing stores.
/// Implementation will be in the data layer.
///
/// YAGNI Principle Applied: Only contains methods actually used.
abstract class StoreRepository {
  /// Create a new store
  ///
  /// Returns the created [Store].
  /// Throws [StoreCodeExistsException] if store code already exists in company.
  /// Throws [ValidationException] if data is invalid.
  Future<Store> create(Store store);

  /// Find store by ID
  ///
  /// Returns the [Store] if found, null otherwise.
  Future<Store?> findById(String storeId);

  /// Find stores by company ID
  ///
  /// Returns list of stores in the company.
  Future<List<Store>> findByCompany(String companyId);

  /// Check if store code exists in company
  ///
  /// Returns `true` if the code already exists.
  Future<bool> codeExists({
    required String companyId,
    required String storeCode,
  });

  /// Update store
  ///
  /// Returns the updated [Store].
  Future<Store> update(Store store);

  /// Delete store (soft delete)
  ///
  /// Marks the store as deleted.
  Future<void> delete(String storeId);
}
