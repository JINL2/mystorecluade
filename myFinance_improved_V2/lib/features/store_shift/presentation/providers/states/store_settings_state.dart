import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/entities/business_hours.dart';

part 'store_settings_state.freezed.dart';

/// Store Settings State - UI state for store settings tab
///
/// Manages store configuration, operating hours, and location settings.
@freezed
class StoreSettingsState with _$StoreSettingsState {
  const factory StoreSettingsState({
    // Store data
    Map<String, dynamic>? storeData,

    // Loading states
    @Default(false) bool isLoading,
    @Default(false) bool isSaving,

    // Error
    String? errorMessage,

    // Editing states
    @Default(false) bool isEditingInfo,
    @Default(false) bool isEditingOperatingHours,
    @Default(false) bool isEditingLocation,
    @Default(false) bool isEditingSettings,
  }) = _StoreSettingsState;

  /// Initial state
  factory StoreSettingsState.initial() => const StoreSettingsState();

  /// Loading state
  factory StoreSettingsState.loading() => const StoreSettingsState(isLoading: true);

  /// Loaded state with store data
  factory StoreSettingsState.loaded(Map<String, dynamic> storeData) =>
      StoreSettingsState(storeData: storeData);
}

/// Operating Hours State - Daily operating hours
///
/// Manages operating hours for each day of the week.
@freezed
class OperatingHoursState with _$OperatingHoursState {
  const factory OperatingHoursState({
    @Default({}) Map<String, DayHours> hours,
    @Default(false) bool isEditing,
    @Default(false) bool isSaving,
    String? errorMessage,
  }) = _OperatingHoursState;

  /// Initial state with default hours
  factory OperatingHoursState.initial() => const OperatingHoursState(
        hours: {
          'Monday': DayHours(open: '09:00', close: '22:00'),
          'Tuesday': DayHours(open: '09:00', close: '22:00'),
          'Wednesday': DayHours(open: '09:00', close: '22:00'),
          'Thursday': DayHours(open: '09:00', close: '22:00'),
          'Friday': DayHours(open: '09:00', close: '23:00'),
          'Saturday': DayHours(open: '10:00', close: '23:00'),
          'Sunday': DayHours(open: '10:00', close: '21:00'),
        },
      );

  /// From store data (deprecated, use fromBusinessHours instead)
  factory OperatingHoursState.fromStoreData(Map<String, dynamic> storeData) {
    return OperatingHoursState.initial();
  }

  /// From BusinessHours list (from database)
  factory OperatingHoursState.fromBusinessHours(List<BusinessHours> businessHours) {
    if (businessHours.isEmpty) {
      return OperatingHoursState.initial();
    }

    final Map<String, DayHours> hoursMap = {};
    for (final bh in businessHours) {
      hoursMap[bh.dayName] = DayHours(
        open: bh.openTime ?? '09:00',
        close: bh.closeTime ?? '22:00',
        isOpen: bh.isOpen,
      );
    }

    return OperatingHoursState(hours: hoursMap);
  }

  /// Convert to BusinessHours list (for database save)
  static List<BusinessHours> toBusinessHours(Map<String, DayHours> hours) {
    return hours.entries.map((entry) {
      final dayOfWeek = BusinessHours.dayNameToNumber[entry.key] ?? 0;
      return BusinessHours(
        dayOfWeek: dayOfWeek,
        dayName: entry.key,
        isOpen: entry.value.isOpen,
        openTime: entry.value.open,
        closeTime: entry.value.close,
      );
    }).toList();
  }
}

/// Day Hours - Operating hours for a single day
@freezed
class DayHours with _$DayHours {
  const factory DayHours({
    required String open,
    required String close,
    @Default(true) bool isOpen,
  }) = _DayHours;
}

/// Store Location State - Location configuration
///
/// Manages store location and check-in distance settings.
@freezed
class StoreLocationState with _$StoreLocationState {
  const factory StoreLocationState({
    double? latitude,
    double? longitude,
    String? address,
    @Default(100) int allowedDistance,
    @Default(false) bool isEditing,
    @Default(false) bool isSaving,
    String? errorMessage,
  }) = _StoreLocationState;

  /// Initial state
  factory StoreLocationState.initial() => const StoreLocationState();

  /// From store data
  factory StoreLocationState.fromStoreData(Map<String, dynamic> storeData) =>
      StoreLocationState(
        latitude: storeData['store_latitude'] as double?,
        longitude: storeData['store_longitude'] as double?,
        address: storeData['store_address'] as String?,
        allowedDistance: (storeData['allowed_distance'] as int?) ?? 100,
      );
}

/// Operational Settings State - Store operational configuration
///
/// Manages huddle time, payment time, and other operational settings.
@freezed
class OperationalSettingsState with _$OperationalSettingsState {
  const factory OperationalSettingsState({
    @Default(15) int huddleTime,
    @Default(30) int paymentTime,
    @Default(100) int allowedDistance,
    @Default(false) bool isEditing,
    @Default(false) bool isSaving,
    String? errorMessage,
  }) = _OperationalSettingsState;

  /// Initial state
  factory OperationalSettingsState.initial() => const OperationalSettingsState();

  /// From store data
  factory OperationalSettingsState.fromStoreData(Map<String, dynamic> storeData) =>
      OperationalSettingsState(
        huddleTime: (storeData['huddle_time'] as int?) ?? 15,
        paymentTime: (storeData['payment_time'] as int?) ?? 30,
        allowedDistance: (storeData['allowed_distance'] as int?) ?? 100,
      );
}
