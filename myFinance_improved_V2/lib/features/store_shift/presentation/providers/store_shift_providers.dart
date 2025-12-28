import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/providers/app_state_provider.dart';
import '../../domain/entities/business_hours.dart';
import '../../domain/entities/store_shift.dart';
import '../../domain/entities/work_schedule_template.dart';
import '../../domain/providers/repository_provider.dart';
import '../../domain/usecases/create_shift.dart';
import '../../domain/usecases/delete_shift.dart';
import '../../domain/usecases/get_business_hours.dart';
import '../../domain/usecases/get_shifts.dart';
import '../../domain/usecases/update_business_hours.dart';
import '../../domain/usecases/update_operational_settings.dart';
import '../../domain/usecases/update_shift.dart';
import '../../domain/usecases/update_store_location.dart';
import '../../domain/value_objects/shift_params.dart';
import 'states/shift_form_state.dart';
import 'states/shift_page_state.dart';
import 'states/store_settings_state.dart';

/// ========================================
/// CLEAN ARCHITECTURE COMPLIANCE ✅
/// ========================================
///
/// Presentation layer structure (IMPROVED):
/// - Imports repository provider from DOMAIN layer (repository_provider.dart)
/// - Data layer provides concrete implementation through override in main.dart
/// - Presentation layer depends ONLY on Domain (UseCases, Entities, Repository interfaces)
///
/// Dependency Flow:
/// Presentation → Domain Providers → Domain Interfaces
///                     ↑
///              Data Implementation (injected via ProviderScope.overrides)
///
/// Clean Architecture Benefits:
/// ✅ Presentation does NOT import Data layer at all
/// ✅ Presentation only knows about Domain interfaces
/// ✅ Data layer can be swapped without affecting Presentation
/// ✅ Easy to mock repositories for testing
///
/// Implementation:
/// 1. Domain defines: storeShiftRepositoryProvider (throws UnimplementedError)
/// 2. Data provides: storeShiftRepositoryImplProvider (concrete implementation)
/// 3. main.dart overrides: storeShiftRepositoryProvider with storeShiftRepositoryImplProvider
/// 4. Presentation uses: storeShiftRepositoryProvider (gets Data's implementation)

/// ========================================
/// UseCase Providers
/// ========================================

/// Get Shifts UseCase Provider
final getShiftsUseCaseProvider = Provider<GetShifts>((ref) {
  final repository = ref.watch(storeShiftRepositoryProvider);
  return GetShifts(repository);
});

/// Create Shift UseCase Provider
final createShiftUseCaseProvider = Provider<CreateShift>((ref) {
  final repository = ref.watch(storeShiftRepositoryProvider);
  return CreateShift(repository);
});

/// Update Shift UseCase Provider
final updateShiftUseCaseProvider = Provider<UpdateShift>((ref) {
  final repository = ref.watch(storeShiftRepositoryProvider);
  return UpdateShift(repository);
});

/// Delete Shift UseCase Provider
final deleteShiftUseCaseProvider = Provider<DeleteShift>((ref) {
  final repository = ref.watch(storeShiftRepositoryProvider);
  return DeleteShift(repository);
});

/// Update Store Location UseCase Provider
final updateStoreLocationUseCaseProvider = Provider<UpdateStoreLocation>((ref) {
  final repository = ref.watch(storeShiftRepositoryProvider);
  return UpdateStoreLocation(repository);
});

/// Update Operational Settings UseCase Provider
final updateOperationalSettingsUseCaseProvider = Provider<UpdateOperationalSettings>((ref) {
  final repository = ref.watch(storeShiftRepositoryProvider);
  return UpdateOperationalSettings(repository);
});

/// Get Business Hours UseCase Provider
final getBusinessHoursUseCaseProvider = Provider<GetBusinessHours>((ref) {
  final repository = ref.watch(storeShiftRepositoryProvider);
  return GetBusinessHours(repository);
});

/// Update Business Hours UseCase Provider
final updateBusinessHoursUseCaseProvider = Provider<UpdateBusinessHours>((ref) {
  final repository = ref.watch(storeShiftRepositoryProvider);
  return UpdateBusinessHours(repository);
});

/// ========================================
/// Business Logic Providers
/// ========================================
///
/// These providers use UseCases from the Domain layer.
/// They coordinate between UI state and business logic.

/// Provider to fetch shifts for the selected store
///
/// Uses Domain Repository Provider (implementation injected via DI)
/// Returns empty list if no store is selected.
final storeShiftsProvider = FutureProvider.autoDispose<List<StoreShift>>((ref) async {
  final appState = ref.watch(appStateProvider);

  // If no store is selected, return empty list
  if (appState.storeChoosen.isEmpty) {
    return [];
  }

  // Use Domain Repository Provider (Clean Architecture compliant)
  final repository = ref.watch(storeShiftRepositoryProvider);
  return await repository.getShiftsByStoreId(appState.storeChoosen);
});

/// Provider to fetch detailed store information
///
/// Uses Domain Repository Provider (implementation injected via DI)
/// Returns null if no store is selected.
final storeDetailsProvider = FutureProvider.autoDispose<Map<String, dynamic>?>((ref) async {
  final appState = ref.watch(appStateProvider);

  // If no store is selected, return null
  if (appState.storeChoosen.isEmpty) {
    return null;
  }

  // Use Domain Repository Provider (Clean Architecture compliant)
  final repository = ref.watch(storeShiftRepositoryProvider);
  return await repository.getStoreById(appState.storeChoosen);
});

/// Provider to fetch business hours for the selected store
///
/// Uses Domain Repository Provider (implementation injected via DI)
/// Returns default hours if no hours configured or no store selected.
final businessHoursProvider = FutureProvider.autoDispose<List<BusinessHours>>((ref) async {
  final appState = ref.watch(appStateProvider);

  // If no store is selected, return default hours
  if (appState.storeChoosen.isEmpty) {
    return BusinessHours.defaultHours();
  }

  // Use Domain Repository Provider (Clean Architecture compliant)
  final repository = ref.watch(storeShiftRepositoryProvider);
  final hours = await repository.getBusinessHours(appState.storeChoosen);

  // If no hours configured, return default hours
  if (hours.isEmpty) {
    return BusinessHours.defaultHours();
  }

  return hours;
});

/// ========================================
/// UI State Providers (Freezed States)
/// ========================================

/// Shift Page State Provider
final shiftPageStateProvider = StateProvider.autoDispose<ShiftPageState>((ref) {
  return ShiftPageState.initial();
});

/// Shift Filter State Provider
final shiftFilterStateProvider = StateProvider.autoDispose<ShiftFilterState>((ref) {
  return const ShiftFilterState();
});

/// Shift Form State Provider
final shiftFormStateProvider = StateProvider.autoDispose<ShiftFormState>((ref) {
  return ShiftFormState.initial();
});

/// Shift Deletion State Provider
final shiftDeletionStateProvider = StateProvider.autoDispose<ShiftDeletionState>((ref) {
  return ShiftDeletionState.initial();
});

/// Store Settings State Provider
final storeSettingsStateProvider = StateProvider.autoDispose<StoreSettingsState>((ref) {
  return StoreSettingsState.initial();
});

/// Operating Hours State Provider
final operatingHoursStateProvider = StateProvider.autoDispose<OperatingHoursState>((ref) {
  return OperatingHoursState.initial();
});

/// Store Location State Provider
final storeLocationStateProvider = StateProvider.autoDispose<StoreLocationState>((ref) {
  return StoreLocationState.initial();
});

/// Operational Settings State Provider
final operationalSettingsStateProvider = StateProvider.autoDispose<OperationalSettingsState>((ref) {
  return OperationalSettingsState.initial();
});

/// ========================================
/// Helper Methods (as extensions or separate providers)
/// ========================================

/// Create a new shift
final createShiftProvider = Provider.autoDispose<
    Future<StoreShift> Function({
      required String storeId,
      required String shiftName,
      required String startTime,
      required String endTime,
      int? numberShift,
      bool? isCanOvertime,
      int? shiftBonus,
    })>((ref) {
  return ({
    required String storeId,
    required String shiftName,
    required String startTime,
    required String endTime,
    int? numberShift,
    bool? isCanOvertime,
    int? shiftBonus,
  }) async {
    final useCase = ref.read(createShiftUseCaseProvider);
    return await useCase(CreateShiftParams(
      storeId: storeId,
      shiftName: shiftName,
      startTime: startTime,
      endTime: endTime,
      numberShift: numberShift,
      isCanOvertime: isCanOvertime,
      shiftBonus: shiftBonus,
    ),);
  };
});

/// Update an existing shift
final updateShiftProvider = Provider.autoDispose<
    Future<StoreShift> Function({
      required String shiftId,
      String? shiftName,
      String? startTime,
      String? endTime,
      int? numberShift,
      bool? isCanOvertime,
      int? shiftBonus,
    })>((ref) {
  return ({
    required String shiftId,
    String? shiftName,
    String? startTime,
    String? endTime,
    int? numberShift,
    bool? isCanOvertime,
    int? shiftBonus,
  }) async {
    final useCase = ref.read(updateShiftUseCaseProvider);
    return await useCase(UpdateShiftParams(
      shiftId: shiftId,
      shiftName: shiftName,
      startTime: startTime,
      endTime: endTime,
      numberShift: numberShift,
      isCanOvertime: isCanOvertime,
      shiftBonus: shiftBonus,
    ),);
  };
});

/// Delete a shift
final deleteShiftProvider = Provider.autoDispose<
    Future<void> Function(String shiftId)>((ref) {
  return (String shiftId) async {
    final useCase = ref.read(deleteShiftUseCaseProvider);
    await useCase(DeleteShiftParams(shiftId));
  };
});

/// Update store location
final updateStoreLocationProvider = Provider.autoDispose<
    Future<void> Function({
      required String storeId,
      required double latitude,
      required double longitude,
      required String address,
    })>((ref) {
  return ({
    required String storeId,
    required double latitude,
    required double longitude,
    required String address,
  }) async {
    final useCase = ref.read(updateStoreLocationUseCaseProvider);
    await useCase(UpdateStoreLocationParams(
      storeId: storeId,
      latitude: latitude,
      longitude: longitude,
      address: address,
    ),);
  };
});

/// Update business hours for a store
final updateBusinessHoursProvider = Provider.autoDispose<
    Future<bool> Function({
      required String storeId,
      required List<BusinessHours> hours,
    })>((ref) {
  return ({
    required String storeId,
    required List<BusinessHours> hours,
  }) async {
    final repository = ref.read(storeShiftRepositoryProvider);
    final success = await repository.updateBusinessHours(
      storeId: storeId,
      hours: hours,
    );

    // Invalidate the provider to refetch fresh data
    if (success) {
      ref.invalidate(businessHoursProvider);
    }

    return success;
  };
});

/// ========================================
/// Work Schedule Template Providers
/// ========================================
/// For monthly (salary-based) employees

/// Provider to fetch work schedule templates for the current company
final workScheduleTemplatesProvider =
    FutureProvider.autoDispose<List<WorkScheduleTemplate>>((ref) async {
  final appState = ref.watch(appStateProvider);

  // If no company is selected, return empty list
  if (appState.companyChoosen.isEmpty) {
    return [];
  }

  final repository = ref.watch(storeShiftRepositoryProvider);
  return await repository.getWorkScheduleTemplates(appState.companyChoosen);
});

/// Create a new work schedule template
final createWorkScheduleTemplateProvider = Provider.autoDispose<
    Future<Map<String, dynamic>> Function({
      required String templateName,
      String workStartTime,
      String workEndTime,
      bool monday,
      bool tuesday,
      bool wednesday,
      bool thursday,
      bool friday,
      bool saturday,
      bool sunday,
      bool isDefault,
    })>((ref) {
  return ({
    required String templateName,
    String workStartTime = '09:00',
    String workEndTime = '18:00',
    bool monday = true,
    bool tuesday = true,
    bool wednesday = true,
    bool thursday = true,
    bool friday = true,
    bool saturday = false,
    bool sunday = false,
    bool isDefault = false,
  }) async {
    final appState = ref.read(appStateProvider);
    final repository = ref.read(storeShiftRepositoryProvider);

    final result = await repository.createWorkScheduleTemplate(
      companyId: appState.companyChoosen,
      templateName: templateName,
      workStartTime: workStartTime,
      workEndTime: workEndTime,
      monday: monday,
      tuesday: tuesday,
      wednesday: wednesday,
      thursday: thursday,
      friday: friday,
      saturday: saturday,
      sunday: sunday,
      isDefault: isDefault,
    );

    // Invalidate to refresh list
    if (result['success'] == true) {
      ref.invalidate(workScheduleTemplatesProvider);
    }

    return result;
  };
});

/// Update an existing work schedule template
final updateWorkScheduleTemplateProvider = Provider.autoDispose<
    Future<Map<String, dynamic>> Function({
      required String templateId,
      String? templateName,
      String? workStartTime,
      String? workEndTime,
      bool? monday,
      bool? tuesday,
      bool? wednesday,
      bool? thursday,
      bool? friday,
      bool? saturday,
      bool? sunday,
      bool? isDefault,
    })>((ref) {
  return ({
    required String templateId,
    String? templateName,
    String? workStartTime,
    String? workEndTime,
    bool? monday,
    bool? tuesday,
    bool? wednesday,
    bool? thursday,
    bool? friday,
    bool? saturday,
    bool? sunday,
    bool? isDefault,
  }) async {
    final repository = ref.read(storeShiftRepositoryProvider);

    final result = await repository.updateWorkScheduleTemplate(
      templateId: templateId,
      templateName: templateName,
      workStartTime: workStartTime,
      workEndTime: workEndTime,
      monday: monday,
      tuesday: tuesday,
      wednesday: wednesday,
      thursday: thursday,
      friday: friday,
      saturday: saturday,
      sunday: sunday,
      isDefault: isDefault,
    );

    // Invalidate to refresh list
    if (result['success'] == true) {
      ref.invalidate(workScheduleTemplatesProvider);
    }

    return result;
  };
});

/// Delete a work schedule template
final deleteWorkScheduleTemplateProvider = Provider.autoDispose<
    Future<Map<String, dynamic>> Function(String templateId)>((ref) {
  return (String templateId) async {
    final repository = ref.read(storeShiftRepositoryProvider);

    final result = await repository.deleteWorkScheduleTemplate(templateId);

    // Invalidate to refresh list
    if (result['success'] == true) {
      ref.invalidate(workScheduleTemplatesProvider);
    }

    return result;
  };
});
