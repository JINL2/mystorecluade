import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../app/providers/app_state_provider.dart';
import '../../domain/entities/business_hours.dart';
import '../../domain/entities/store_shift.dart';
import '../../domain/entities/work_schedule_template.dart';
import '../../domain/usecases/create_shift.dart';
import '../../domain/usecases/delete_shift.dart';
import '../../domain/usecases/get_business_hours.dart';
import '../../domain/usecases/get_shifts.dart';
import '../../domain/usecases/update_business_hours.dart';
import '../../domain/usecases/update_operational_settings.dart';
import '../../domain/usecases/update_shift.dart';
import '../../domain/usecases/update_store_location.dart';
import '../../domain/value_objects/shift_params.dart';
import 'di_providers.dart';

part 'store_shift_providers.g.dart';

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
@riverpod
GetShifts getShiftsUseCase(Ref ref) {
  final repository = ref.watch(storeShiftRepositoryProvider);
  return GetShifts(repository);
}

/// Create Shift UseCase Provider
@riverpod
CreateShift createShiftUseCase(Ref ref) {
  final repository = ref.watch(storeShiftRepositoryProvider);
  return CreateShift(repository);
}

/// Update Shift UseCase Provider
@riverpod
UpdateShift updateShiftUseCase(Ref ref) {
  final repository = ref.watch(storeShiftRepositoryProvider);
  return UpdateShift(repository);
}

/// Delete Shift UseCase Provider
@riverpod
DeleteShift deleteShiftUseCase(Ref ref) {
  final repository = ref.watch(storeShiftRepositoryProvider);
  return DeleteShift(repository);
}

/// Update Store Location UseCase Provider
@riverpod
UpdateStoreLocation updateStoreLocationUseCase(Ref ref) {
  final repository = ref.watch(storeShiftRepositoryProvider);
  return UpdateStoreLocation(repository);
}

/// Update Operational Settings UseCase Provider
@riverpod
UpdateOperationalSettings updateOperationalSettingsUseCase(Ref ref) {
  final repository = ref.watch(storeShiftRepositoryProvider);
  return UpdateOperationalSettings(repository);
}

/// Get Business Hours UseCase Provider
@riverpod
GetBusinessHours getBusinessHoursUseCase(Ref ref) {
  final repository = ref.watch(storeShiftRepositoryProvider);
  return GetBusinessHours(repository);
}

/// Update Business Hours UseCase Provider
@riverpod
UpdateBusinessHours updateBusinessHoursUseCase(Ref ref) {
  final repository = ref.watch(storeShiftRepositoryProvider);
  return UpdateBusinessHours(repository);
}

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
@riverpod
Future<List<StoreShift>> storeShifts(Ref ref) async {
  final appState = ref.watch(appStateProvider);

  // If no store is selected, return empty list
  if (appState.storeChoosen.isEmpty) {
    return [];
  }

  // Use Domain Repository Provider (Clean Architecture compliant)
  final repository = ref.watch(storeShiftRepositoryProvider);
  return await repository.getShiftsByStoreId(appState.storeChoosen);
}

/// Provider to fetch detailed store information
///
/// Uses RPC function 'get_store_info_v2' via Domain Repository Provider.
/// Returns null if no store or company is selected.
@riverpod
Future<Map<String, dynamic>?> storeDetails(Ref ref) async {
  final appState = ref.watch(appStateProvider);

  // If no store or company is selected, return null
  if (appState.storeChoosen.isEmpty || appState.companyChoosen.isEmpty) {
    return null;
  }

  // Use Domain Repository Provider (Clean Architecture compliant)
  final repository = ref.watch(storeShiftRepositoryProvider);
  return await repository.getStoreById(
    storeId: appState.storeChoosen,
    companyId: appState.companyChoosen,
  );
}

/// Provider to fetch business hours for the selected store
///
/// Uses Domain Repository Provider (implementation injected via DI)
/// Returns default hours if no hours configured or no store selected.
@riverpod
Future<List<BusinessHours>> businessHours(Ref ref) async {
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
}

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
/// Work Schedule Template Providers (@riverpod 2025)
/// ========================================
/// For monthly (salary-based) employees

/// Provider to fetch work schedule templates for the current company
@riverpod
Future<List<WorkScheduleTemplate>> workScheduleTemplates(Ref ref) async {
  final appState = ref.watch(appStateProvider);

  // If no company is selected, return empty list
  if (appState.companyChoosen.isEmpty) {
    return [];
  }

  final repository = ref.watch(storeShiftRepositoryProvider);
  return await repository.getWorkScheduleTemplates(appState.companyChoosen);
}

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
