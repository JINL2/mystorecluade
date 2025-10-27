import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/providers/app_state_provider.dart';
import '../../data/repositories/repository_providers.dart';
import '../../domain/entities/store_shift.dart';
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
    final repository = ref.read(storeShiftRepositoryProvider);
    return await repository.createShift(
      storeId: storeId,
      shiftName: shiftName,
      startTime: startTime,
      endTime: endTime,
      shiftBonus: shiftBonus,
    );
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
    final repository = ref.read(storeShiftRepositoryProvider);
    return await repository.updateShift(
      shiftId: shiftId,
      shiftName: shiftName,
      startTime: startTime,
      endTime: endTime,
      shiftBonus: shiftBonus,
    );
  };
});

/// Delete a shift
final deleteShiftProvider = Provider.autoDispose<
    Future<void> Function(String shiftId)>((ref) {
  return (String shiftId) async {
    final repository = ref.read(storeShiftRepositoryProvider);
    await repository.deleteShift(shiftId);
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
    final repository = ref.read(storeShiftRepositoryProvider);
    await repository.updateStoreLocation(
      storeId: storeId,
      latitude: latitude,
      longitude: longitude,
      address: address,
    );
  };
});
