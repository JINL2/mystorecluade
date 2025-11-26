/// Create Shift Parameters
class CreateShiftParams {
  final String storeId;
  final String shiftName;
  final String startTime;
  final String endTime;
  final int shiftBonus;

  const CreateShiftParams({
    required this.storeId,
    required this.shiftName,
    required this.startTime,
    required this.endTime,
    required this.shiftBonus,
  });
}

/// Update Shift Parameters
class UpdateShiftParams {
  final String shiftId;
  final String? shiftName;
  final String? startTime;
  final String? endTime;
  final int? shiftBonus;

  const UpdateShiftParams({
    required this.shiftId,
    this.shiftName,
    this.startTime,
    this.endTime,
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

  const UpdateStoreLocationParams({
    required this.storeId,
    required this.latitude,
    required this.longitude,
  });
}

/// Update Operational Settings Parameters
class UpdateOperationalSettingsParams {
  final String storeId;
  final int? huddleTime;
  final int? paymentTime;
  final int? allowedDistance;
  final String? localTime;
  final String timezone;

  const UpdateOperationalSettingsParams({
    required this.storeId,
    this.huddleTime,
    this.paymentTime,
    this.allowedDistance,
    this.localTime,
    this.timezone = 'Asia/Ho_Chi_Minh',
  });
}
