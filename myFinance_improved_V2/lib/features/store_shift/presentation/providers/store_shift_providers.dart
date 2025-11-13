import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/providers/app_state_provider.dart';
import '../../data/repositories/repository_providers.dart';
import '../../domain/entities/store_shift.dart';
import '../../domain/usecases/create_shift.dart';
import '../../domain/usecases/delete_shift.dart';
import '../../domain/usecases/get_shifts.dart';
import '../../domain/usecases/update_operational_settings.dart';
import '../../domain/usecases/update_shift.dart';
import '../../domain/usecases/update_store_location.dart';
import '../../domain/value_objects/shift_params.dart';
import 'states/shift_form_state.dart';
import 'states/shift_page_state.dart';
import 'states/store_settings_state.dart';

/// ========================================
/// Presentation Layer Providers
/// ========================================
///
/// This file contains presentation logic providers.
/// It only imports domain layer (entities, repository interfaces).
/// Data layer providers are imported from data/repositories/repository_providers.dart

/// ========================================
/// UseCase Providers
/// ========================================

final getShiftsUseCaseProvider = Provider<GetShifts>((ref) {
  final repository = ref.watch(storeShiftRepositoryProvider);
  return GetShifts(repository);
});

final createShiftUseCaseProvider = Provider<CreateShift>((ref) {
  final repository = ref.watch(storeShiftRepositoryProvider);
  return CreateShift(repository);
});

final updateShiftUseCaseProvider = Provider<UpdateShift>((ref) {
  final repository = ref.watch(storeShiftRepositoryProvider);
  return UpdateShift(repository);
});

final deleteShiftUseCaseProvider = Provider<DeleteShift>((ref) {
  final repository = ref.watch(storeShiftRepositoryProvider);
  return DeleteShift(repository);
});

final updateStoreLocationUseCaseProvider = Provider<UpdateStoreLocation>((ref) {
  final repository = ref.watch(storeShiftRepositoryProvider);
  return UpdateStoreLocation(repository);
});

final updateOperationalSettingsUseCaseProvider = Provider<UpdateOperationalSettings>((ref) {
  final repository = ref.watch(storeShiftRepositoryProvider);
  return UpdateOperationalSettings(repository);
});

/// ========================================
/// Business Logic Providers
/// ========================================

/// Provider to fetch shifts for the selected store
final storeShiftsProvider = FutureProvider.autoDispose<List<StoreShift>>((ref) async {
  final appState = ref.watch(appStateProvider);

  // If no store is selected, return empty list
  if (appState.storeChoosen.isEmpty) {
    return [];
  }

  final repository = ref.watch(storeShiftRepositoryProvider);
  return await repository.getShiftsByStoreId(appState.storeChoosen);
});

/// Provider to fetch detailed store information
final storeDetailsProvider = FutureProvider.autoDispose<Map<String, dynamic>?>((ref) async {
  final appState = ref.watch(appStateProvider);

  // If no store is selected, return null
  if (appState.storeChoosen.isEmpty) {
    return null;
  }

  final repository = ref.watch(storeShiftRepositoryProvider);
  return await repository.getStoreById(appState.storeChoosen);
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
      required int shiftBonus,
    })>((ref) {
  return ({
    required String storeId,
    required String shiftName,
    required String startTime,
    required String endTime,
    required int shiftBonus,
  }) async {
    final useCase = ref.read(createShiftUseCaseProvider);
    return await useCase(CreateShiftParams(
      storeId: storeId,
      shiftName: shiftName,
      startTime: startTime,
      endTime: endTime,
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
      int? shiftBonus,
    })>((ref) {
  return ({
    required String shiftId,
    String? shiftName,
    String? startTime,
    String? endTime,
    int? shiftBonus,
  }) async {
    final useCase = ref.read(updateShiftUseCaseProvider);
    return await useCase(UpdateShiftParams(
      shiftId: shiftId,
      shiftName: shiftName,
      startTime: startTime,
      endTime: endTime,
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
