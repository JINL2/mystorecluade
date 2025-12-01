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
