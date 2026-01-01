/// ShiftCardStatus - Status enum for week shift card display
///
/// Used by presentation layer for UI rendering of weekly shift cards.
enum ShiftCardStatus {
  /// No left border - future shift
  upcoming,

  /// Green left border - currently working
  inProgress,

  /// No left border - completed
  completed,

  /// Red left border - late check-in
  late,

  /// Green badge text - on-time
  onTime,

  /// Gray badge text - past but no check-in
  undone,

  /// Red badge - marked as absent
  absent,

  /// Orange badge - no checkout recorded
  noCheckout,

  /// Orange badge - left early
  earlyLeave,

  /// Orange badge - issue reported
  reported,

  /// Green badge - issue resolved
  resolved,
}
