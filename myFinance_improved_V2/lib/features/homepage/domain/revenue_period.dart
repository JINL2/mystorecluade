/// Revenue period enumeration for filtering revenue data
///
/// Represents different time periods for revenue analysis:
/// - today: Current day's revenue
/// - yesterday: Previous day's revenue
/// - thisMonth: Current month's total revenue
/// - thisYear: Current year's total revenue
enum RevenuePeriod {
  today('Today', 'vs Yesterday'),
  yesterday('Yesterday', 'vs Day Before'),
  thisMonth('This Month', 'vs Last Month'),
  thisYear('This Year', 'vs Last Year');

  final String displayName;
  final String comparisonText;

  const RevenuePeriod(this.displayName, this.comparisonText);

  /// Parse string to RevenuePeriod enum
  static RevenuePeriod fromString(String value) {
    return RevenuePeriod.values.firstWhere(
      (period) => period.name == value || period.displayName == value,
      orElse: () => RevenuePeriod.today,
    );
  }
}
