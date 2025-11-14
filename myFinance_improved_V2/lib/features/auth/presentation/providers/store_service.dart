import 'package:flutter_riverpod/flutter_riverpod.dart';

// Domain Layer
import '../../domain/entities/store_entity.dart';
import '../../domain/repositories/store_repository.dart';
import '../../domain/usecases/create_store_usecase.dart';
import '../../domain/value_objects/create_store_command.dart';

// Providers
import '../providers/repository_providers.dart';
import 'usecase_providers.dart';

/// Store Service
///
/// Provides high-level store operations.
/// Facade pattern to simplify UI interactions.
///
/// Responsibilities:
/// - Execute store-related UseCases
/// - Provide simple data queries
class StoreService {
  final CreateStoreUseCase _createStoreUseCase;
  final StoreRepository _storeRepository;

  const StoreService({
    required CreateStoreUseCase createStoreUseCase,
    required StoreRepository storeRepository,
  })  : _createStoreUseCase = createStoreUseCase,
        _storeRepository = storeRepository;

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
    return await _createStoreUseCase.execute(
      CreateStoreCommand(
        name: name.trim(),
        companyId: companyId,
        address: address?.trim(),
        phone: phone?.trim(),
        storeCode: storeCode?.trim(),
        huddleTimeMinutes: huddleTimeMinutes,
        paymentTimeDays: paymentTimeDays,
        allowedDistanceMeters: allowedDistanceMeters,
      ),
    );
  }

  /// Check if store code exists
  ///
  /// Validates that a store code is valid and exists in the system.
  /// Returns true if code exists, false otherwise.
  Future<bool> isStoreCodeExists({
    required String companyId,
    required String storeCode,
  }) {
    return _storeRepository.codeExists(
      companyId: companyId,
      storeCode: storeCode.trim(),
    );
  }
}

/// Store Service Provider
///
/// Provides StoreService instance with all dependencies injected.
final storeServiceProvider = Provider<StoreService>((ref) {
  return StoreService(
    createStoreUseCase: ref.watch(createStoreUseCaseProvider),
    storeRepository: ref.watch(storeRepositoryProvider),
  );
});
