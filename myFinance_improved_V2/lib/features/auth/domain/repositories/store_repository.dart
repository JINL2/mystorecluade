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

  /// Check if store code exists in company
  ///
  /// Returns `true` if the code already exists.
  Future<bool> codeExists({
    required String companyId,
    required String storeCode,
  });
}
