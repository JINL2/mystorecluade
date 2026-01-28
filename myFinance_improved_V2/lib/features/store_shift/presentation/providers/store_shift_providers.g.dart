// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'store_shift_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$getShiftsUseCaseHash() => r'1cf0f320985dc837e12396d1cddec033686637c2';

/// ========================================
/// CLEAN ARCHITECTURE 2025 ✅
/// ========================================
///
/// DI 구조 (Riverpod as DI):
/// - Repository Provider는 presentation/providers/di_providers.dart에서 정의
/// - Domain은 인터페이스(abstract class)만 정의
/// - Riverpod이 DI 컨테이너 역할 수행
///
/// 의존성 흐름:
/// Presentation (di_providers.dart)
///      ↓ provides
/// Repository Impl (data layer)
///      ↓ implements
/// Repository Interface (domain layer)
///
/// Clean Architecture Benefits:
/// ✅ Domain 레이어 순수성 유지 (Riverpod 의존성 없음)
/// ✅ Presentation에서 DI 관리 (표준 패턴)
/// ✅ 테스트 시 Provider override로 Mock 주입 가능
/// ✅ ProviderScope.overrides 불필요
/// ========================================
/// UseCase Providers (@riverpod 2025)
/// ========================================
/// Get Shifts UseCase Provider
///
/// Copied from [getShiftsUseCase].
@ProviderFor(getShiftsUseCase)
final getShiftsUseCaseProvider = AutoDisposeProvider<GetShifts>.internal(
  getShiftsUseCase,
  name: r'getShiftsUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$getShiftsUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GetShiftsUseCaseRef = AutoDisposeProviderRef<GetShifts>;
String _$createShiftUseCaseHash() =>
    r'089e0f5f97dd42c3ca413ba6f1e3cf1e7f8b069d';

/// Create Shift UseCase Provider
///
/// Copied from [createShiftUseCase].
@ProviderFor(createShiftUseCase)
final createShiftUseCaseProvider = AutoDisposeProvider<CreateShift>.internal(
  createShiftUseCase,
  name: r'createShiftUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$createShiftUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CreateShiftUseCaseRef = AutoDisposeProviderRef<CreateShift>;
String _$updateShiftUseCaseHash() =>
    r'77e3e6d9c03d7cd70b700468b5e23f3e5821398a';

/// Update Shift UseCase Provider
///
/// Copied from [updateShiftUseCase].
@ProviderFor(updateShiftUseCase)
final updateShiftUseCaseProvider = AutoDisposeProvider<UpdateShift>.internal(
  updateShiftUseCase,
  name: r'updateShiftUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$updateShiftUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef UpdateShiftUseCaseRef = AutoDisposeProviderRef<UpdateShift>;
String _$deleteShiftUseCaseHash() =>
    r'3a44054431e3e18ef6d74fee4273756a3d1ea7b6';

/// Delete Shift UseCase Provider
///
/// Copied from [deleteShiftUseCase].
@ProviderFor(deleteShiftUseCase)
final deleteShiftUseCaseProvider = AutoDisposeProvider<DeleteShift>.internal(
  deleteShiftUseCase,
  name: r'deleteShiftUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$deleteShiftUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef DeleteShiftUseCaseRef = AutoDisposeProviderRef<DeleteShift>;
String _$updateStoreLocationUseCaseHash() =>
    r'be3f951e6acef6203e91c19ab111afa06b64e715';

/// Update Store Location UseCase Provider
///
/// Copied from [updateStoreLocationUseCase].
@ProviderFor(updateStoreLocationUseCase)
final updateStoreLocationUseCaseProvider =
    AutoDisposeProvider<UpdateStoreLocation>.internal(
  updateStoreLocationUseCase,
  name: r'updateStoreLocationUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$updateStoreLocationUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef UpdateStoreLocationUseCaseRef
    = AutoDisposeProviderRef<UpdateStoreLocation>;
String _$updateOperationalSettingsUseCaseHash() =>
    r'6f351fda3116a5ce6dfa463189e6a07fea9d48e5';

/// Update Operational Settings UseCase Provider
///
/// Copied from [updateOperationalSettingsUseCase].
@ProviderFor(updateOperationalSettingsUseCase)
final updateOperationalSettingsUseCaseProvider =
    AutoDisposeProvider<UpdateOperationalSettings>.internal(
  updateOperationalSettingsUseCase,
  name: r'updateOperationalSettingsUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$updateOperationalSettingsUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef UpdateOperationalSettingsUseCaseRef
    = AutoDisposeProviderRef<UpdateOperationalSettings>;
String _$getBusinessHoursUseCaseHash() =>
    r'9338024a6d3b64b3090e793f4baa28f5bf3c155a';

/// Get Business Hours UseCase Provider
///
/// Copied from [getBusinessHoursUseCase].
@ProviderFor(getBusinessHoursUseCase)
final getBusinessHoursUseCaseProvider =
    AutoDisposeProvider<GetBusinessHours>.internal(
  getBusinessHoursUseCase,
  name: r'getBusinessHoursUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$getBusinessHoursUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GetBusinessHoursUseCaseRef = AutoDisposeProviderRef<GetBusinessHours>;
String _$updateBusinessHoursUseCaseHash() =>
    r'bb6efcbe09092076395d8177ce2407b63662db19';

/// Update Business Hours UseCase Provider
///
/// Copied from [updateBusinessHoursUseCase].
@ProviderFor(updateBusinessHoursUseCase)
final updateBusinessHoursUseCaseProvider =
    AutoDisposeProvider<UpdateBusinessHours>.internal(
  updateBusinessHoursUseCase,
  name: r'updateBusinessHoursUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$updateBusinessHoursUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef UpdateBusinessHoursUseCaseRef
    = AutoDisposeProviderRef<UpdateBusinessHours>;
String _$storeShiftsHash() => r'a870ee02a08d91a8f5d44364f589eaa11a79856f';

/// ========================================
/// Business Logic Providers (@riverpod 2025)
/// ========================================
///
/// These providers use UseCases from the Domain layer.
/// They coordinate between UI state and business logic.
/// Provider to fetch shifts for the selected store
///
/// Uses Domain Repository Provider (implementation injected via DI)
/// Returns empty list if no store is selected.
///
/// Copied from [storeShifts].
@ProviderFor(storeShifts)
final storeShiftsProvider =
    AutoDisposeFutureProvider<List<StoreShift>>.internal(
  storeShifts,
  name: r'storeShiftsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$storeShiftsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef StoreShiftsRef = AutoDisposeFutureProviderRef<List<StoreShift>>;
String _$storeDetailsHash() => r'0898089f352a04561b13b6f08b30fa297d269e79';

/// Provider to fetch detailed store information
///
/// Uses RPC function 'get_store_info_v2' via Domain Repository Provider.
/// Returns null if no store or company is selected.
///
/// Copied from [storeDetails].
@ProviderFor(storeDetails)
final storeDetailsProvider =
    AutoDisposeFutureProvider<Map<String, dynamic>?>.internal(
  storeDetails,
  name: r'storeDetailsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$storeDetailsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef StoreDetailsRef = AutoDisposeFutureProviderRef<Map<String, dynamic>?>;
String _$businessHoursHash() => r'd3a69f1426e8c5446d9d80242c947e1b8e2f434c';

/// Provider to fetch business hours for the selected store
///
/// Uses Domain Repository Provider (implementation injected via DI)
/// Returns default hours if no hours configured or no store selected.
///
/// Copied from [businessHours].
@ProviderFor(businessHours)
final businessHoursProvider =
    AutoDisposeFutureProvider<List<BusinessHours>>.internal(
  businessHours,
  name: r'businessHoursProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$businessHoursHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef BusinessHoursRef = AutoDisposeFutureProviderRef<List<BusinessHours>>;
String _$workScheduleTemplatesHash() =>
    r'fa7108bfb43af18f77477d81f3b83cc346f5f200';

/// ========================================
/// Work Schedule Template Providers (@riverpod 2025)
/// ========================================
/// For monthly (salary-based) employees
/// Provider to fetch work schedule templates for the current company
///
/// Copied from [workScheduleTemplates].
@ProviderFor(workScheduleTemplates)
final workScheduleTemplatesProvider =
    AutoDisposeFutureProvider<List<WorkScheduleTemplate>>.internal(
  workScheduleTemplates,
  name: r'workScheduleTemplatesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$workScheduleTemplatesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef WorkScheduleTemplatesRef
    = AutoDisposeFutureProviderRef<List<WorkScheduleTemplate>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
