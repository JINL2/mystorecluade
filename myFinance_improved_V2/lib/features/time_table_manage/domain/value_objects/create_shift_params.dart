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

  // Constants for validation
  static const int maxTargetCount = 100;  // Maximum employees per shift
  static const int maxTags = 20;  // Maximum tags per shift
  static const int maxShiftDurationHours = 24;  // Maximum shift duration

  /// Validate parameters with comprehensive bounds checking
  bool get isValid {
    return storeId.isNotEmpty &&
        shiftDate.isNotEmpty &&
        planEndTime.isAfter(planStartTime) &&
        targetCount > 0 &&
        targetCount <= maxTargetCount &&
        tags.length <= maxTags &&
        _isValidShiftDuration() &&
        _isValidShiftDate();
  }

  /// Check if shift duration is reasonable
  bool _isValidShiftDuration() {
    final duration = planEndTime.difference(planStartTime);
    return duration.inHours <= maxShiftDurationHours && duration.inMinutes >= 30;
  }

  /// Check if shift date is not too far in past or future
  bool _isValidShiftDate() {
    try {
      final parts = shiftDate.split('-');
      if (parts.length != 3) return false;

      final date = DateTime(
        int.parse(parts[0]),
        int.parse(parts[1]),
        int.parse(parts[2]),
      );

      final now = DateTime.now();
      final maxPast = now.subtract(const Duration(days: 90));  // 3 months ago
      final maxFuture = now.add(const Duration(days: 365));  // 1 year ahead

      return date.isAfter(maxPast) && date.isBefore(maxFuture);
    } catch (e) {
      return false;
    }
  }

  /// Get validation errors with specific messages
  List<String> get validationErrors {
    final errors = <String>[];

    if (storeId.isEmpty) {
      errors.add('Store ID is required');
    }

    if (shiftDate.isEmpty) {
      errors.add('Shift date is required');
    } else if (!_isValidShiftDate()) {
      errors.add('Shift date must be within 3 months ago to 1 year ahead');
    }

    if (!planEndTime.isAfter(planStartTime)) {
      errors.add('End time must be after start time');
    } else if (!_isValidShiftDuration()) {
      final duration = planEndTime.difference(planStartTime);
      if (duration.inMinutes < 30) {
        errors.add('Shift duration must be at least 30 minutes');
      } else {
        errors.add('Shift duration cannot exceed $maxShiftDurationHours hours');
      }
    }

    if (targetCount <= 0) {
      errors.add('Target count must be greater than 0');
    } else if (targetCount > maxTargetCount) {
      errors.add('Target count cannot exceed $maxTargetCount employees');
    }

    if (tags.length > maxTags) {
      errors.add('Cannot add more than $maxTags tags');
    }

    // Validate individual tags
    for (var i = 0; i < tags.length; i++) {
      if (tags[i].trim().isEmpty) {
        errors.add('Tag ${i + 1} cannot be empty');
      } else if (tags[i].length > 100) {
        errors.add('Tag ${i + 1} is too long (max 100 characters)');
      }
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
