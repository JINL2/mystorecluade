import 'package:flutter_riverpod/flutter_riverpod.dart';

// Domain Layer
import '../../domain/entities/store_entity.dart';
import '../../domain/value_objects/create_store_command.dart';

// Providers
import 'usecase_providers.dart';
import 'repository_providers.dart';

/// Store Service
///
/// Provides high-level store operations.
/// This service follows the legacy pattern of Provider<Service> for minimal
/// UI code changes during migration.
///
/// Responsibilities:
/// - Execute store-related UseCases
/// - Provide simple data queries
/// - Coordinate business operations
///
/// Usage:
/// ```dart
/// final storeService = ref.read(storeServiceProvider);
/// final store = await storeService.createStore(
///   name: 'Main Store',
///   companyId: 'company-id',
/// );
/// ```
class StoreService {
  const StoreService(this.ref);

  final Ref ref;

  /// Create a new store
  ///
  /// Performs the following operations:
  /// 1. Validates store data via CreateStoreUseCase
  /// 2. Creates store in database
  /// 3. Generates store code
  /// 4. Creates store settings with default values
  /// 5. Associates current user with store
  ///
  /// Returns the created [Store] entity.
  ///
  /// Throws:
  /// - [ValidationException] if validation fails
  /// - [DuplicateException] if store name already exists in company
  /// - [NetworkException] if network error occurs
  Future<Store> createStore({
    required String name,
    required String companyId,
    String? address,
    String? phone,
    String? storeCode,
    int? huddleTimeMinutes,
    int? paymentTimeDays,
    double? allowedDistanceMeters,
  }) async {
    try {
      final command = CreateStoreCommand(
        name: name.trim(),
        companyId: companyId,
        address: address?.trim(),
        phone: phone?.trim(),
        storeCode: storeCode?.trim(),
        huddleTimeMinutes: huddleTimeMinutes,
        paymentTimeDays: paymentTimeDays,
        allowedDistanceMeters: allowedDistanceMeters,
      );

      return await ref.read(createStoreUseCaseProvider).execute(command);
    } catch (e) {
      rethrow;
    }
  }

  /// Check if store code exists
  ///
  /// Validates that a store code is valid and exists in the system.
  /// Used for joining existing stores or checking duplicates.
  ///
  /// Returns true if code exists, false otherwise.
  Future<bool> isStoreCodeExists({
    required String companyId,
    required String storeCode,
  }) async {
    try {
      final repository = ref.read(storeRepositoryProvider);
      return await repository.codeExists(
        companyId: companyId,
        storeCode: storeCode.trim(),
      );
    } catch (e) {
      rethrow;
    }
  }
}

/// Store Service Provider
///
/// Provides StoreService instance with all dependencies injected.
final storeServiceProvider = Provider<StoreService>((ref) {
  return StoreService(ref);
});
