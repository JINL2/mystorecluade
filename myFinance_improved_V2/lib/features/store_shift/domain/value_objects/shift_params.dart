/// Create Shift Parameters
class CreateShiftParams {
  final String storeId;
  final String shiftName;
  final String startTime;
  final String endTime;
  final int? numberShift;
  final bool? isCanOvertime;
  final int? shiftBonus;

  const CreateShiftParams({
    required this.storeId,
    required this.shiftName,
    required this.startTime,
    required this.endTime,
    this.numberShift,
    this.isCanOvertime,
    this.shiftBonus,
  });
}

/// Update Shift Parameters
class UpdateShiftParams {
  final String shiftId;
  final String? shiftName;
  final String? startTime;
  final String? endTime;
  final int? numberShift;
  final bool? isCanOvertime;
  final int? shiftBonus;

  const UpdateShiftParams({
    required this.shiftId,
    this.shiftName,
    this.startTime,
    this.endTime,
    this.numberShift,
    this.isCanOvertime,
    this.shiftBonus,
  });
}

/// Delete Shift Parameters
class DeleteShiftParams {
  final String shiftId;

  const DeleteShiftParams(this.shiftId);
}

/// Get Shifts Parameters
class GetShiftsParams {
  final String storeId;

  const GetShiftsParams(this.storeId);
}

/// Update Store Location Parameters
class UpdateStoreLocationParams {
  final String storeId;
  final double latitude;
  final double longitude;
  final String address;

  const UpdateStoreLocationParams({
    required this.storeId,
    required this.latitude,
    required this.longitude,
    required this.address,
  });
}

/// Update Operational Settings Parameters
class UpdateOperationalSettingsParams {
  final String storeId;
  final int? huddleTime;
  final int? paymentTime;
  final int? allowedDistance;

  const UpdateOperationalSettingsParams({
    required this.storeId,
    this.huddleTime,
    this.paymentTime,
    this.allowedDistance,
  });
}

/// ========================================
/// Business Hours Parameters
/// ========================================

/// Get Business Hours Parameters
class GetBusinessHoursParams {
  final String storeId;

  const GetBusinessHoursParams(this.storeId);
}

/// Update Business Hours Parameters
class UpdateBusinessHoursParams {
  final String storeId;
  final List<BusinessHoursParam> hours;

  const UpdateBusinessHoursParams({
    required this.storeId,
    required this.hours,
  });
}

/// Individual Business Hours Parameter (for use in params)
class BusinessHoursParam {
  final int dayOfWeek; // 0=Sunday, 1=Monday, ..., 6=Saturday
  final String dayName;
  final bool isOpen;
  final String? openTime; // HH:mm format
  final String? closeTime; // HH:mm format
  final bool closesNextDay; // True if close_time is on the next day (overnight)

  const BusinessHoursParam({
    required this.dayOfWeek,
    required this.dayName,
    required this.isOpen,
    this.openTime,
    this.closeTime,
    this.closesNextDay = false,
  });
}
