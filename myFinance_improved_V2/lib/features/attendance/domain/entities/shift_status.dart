/// ShiftStatus - Defines the display status of a shift card
///
/// Used by presentation layer for UI rendering.
/// Different from domain's ShiftCard entity status (which uses workStatus getter).
enum ShiftStatus {
  /// Blue - not started yet
  upcoming,

  /// Green - currently working
  inProgress,

  /// Gray - shift finished
  completed,

  /// No shift today
  noShift,

  /// Green badge - "On-time" (checked in on time)
  onTime,

  /// Red badge - "Late" (checked in late)
  late,

  /// Gray badge - "Undone" (shift time passed but no check-in)
  undone,
}
