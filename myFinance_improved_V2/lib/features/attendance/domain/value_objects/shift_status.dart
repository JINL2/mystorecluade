import 'package:flutter/material.dart';
import '../../../../shared/themes/toss_colors.dart';

/// Enum representing the various states of a user's shift status for a given day
enum ShiftStatus {
  /// User has no shifts scheduled for today
  offDuty('off_duty', 'Off Duty'),

  /// User has shifts scheduled but hasn't started work yet
  scheduled('scheduled', 'Shift Today'),

  /// User is currently working on an approved shift
  working('working', 'Working'),

  /// User has completed all shifts for today
  finished('finished', 'Finished');

  const ShiftStatus(this.value, this.displayText);

  /// The string value used in the database and API
  final String value;

  /// Human-readable display text for the UI
  final String displayText;

  /// Get the primary color for this status
  Color get color {
    return switch (this) {
      ShiftStatus.offDuty => TossColors.gray400,
      ShiftStatus.scheduled => TossColors.warning, // Orange/yellow for scheduled
      ShiftStatus.working => TossColors.success, // Green for currently working
      ShiftStatus.finished => TossColors.primary, // Blue for finished
    };
  }

  /// Get the icon background color for this status
  Color get iconBackgroundColor {
    return switch (this) {
      ShiftStatus.offDuty => TossColors.gray100,
      ShiftStatus.scheduled => TossColors.warning.withOpacity(0.1),
      ShiftStatus.working => TossColors.success.withOpacity(0.1),
      ShiftStatus.finished => TossColors.primary.withOpacity(0.1),
    };
  }

  /// Get the icon color for this status
  Color get iconColor {
    return switch (this) {
      ShiftStatus.offDuty => TossColors.gray500,
      ShiftStatus.scheduled => TossColors.warning,
      ShiftStatus.working => TossColors.success,
      ShiftStatus.finished => TossColors.primary,
    };
  }

  /// Convert a string value to a ShiftStatus enum
  static ShiftStatus fromString(String value) {
    return ShiftStatus.values.firstWhere(
      (status) => status.value == value,
      orElse: () => ShiftStatus.offDuty,
    );
  }

  /// Check if this status represents an active work state
  bool get isActive => this == ShiftStatus.working;

  /// Check if this status has shifts scheduled or in progress
  bool get hasShifts => this != ShiftStatus.offDuty;
}
