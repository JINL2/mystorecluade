import '../../../../core/utils/datetime_utils.dart';

/// Create Shift Parameters
///
/// Value object for creating a new shift.
class CreateShiftParams {
  final String storeId;
  final String shiftDate; // yyyy-MM-dd
  final DateTime planStartTime;
  final DateTime planEndTime;
  final int targetCount;
  final List<String> tags;
  final String? shiftName;

  const CreateShiftParams({
    required this.storeId,
    required this.shiftDate,
    required this.planStartTime,
    required this.planEndTime,
    required this.targetCount,
    this.tags = const [],
    this.shiftName,
  });

  /// Validate parameters
  bool get isValid {
    return storeId.isNotEmpty &&
        shiftDate.isNotEmpty &&
        planEndTime.isAfter(planStartTime) &&
        targetCount > 0;
  }

  /// Get validation errors
  List<String> get validationErrors {
    final errors = <String>[];

    if (storeId.isEmpty) {
      errors.add('Store ID is required');
    }
    if (shiftDate.isEmpty) {
      errors.add('Shift date is required');
    }
    if (!planEndTime.isAfter(planStartTime)) {
      errors.add('End time must be after start time');
    }
    if (targetCount <= 0) {
      errors.add('Target count must be greater than 0');
    }

    return errors;
  }

  /// Convert to JSON for API call
  Map<String, dynamic> toJson() {
    return {
      'p_store_id': storeId,
      'p_shift_date': shiftDate,
      'p_plan_start_time': DateTimeUtils.toUtc(planStartTime),
      'p_plan_end_time': DateTimeUtils.toUtc(planEndTime),
      'p_target_count': targetCount,
      'p_tags': tags,
      if (shiftName != null) 'p_shift_name': shiftName,
    };
  }

  @override
  String toString() => 'CreateShiftParams(store: $storeId, date: $shiftDate, target: $targetCount)';
}
