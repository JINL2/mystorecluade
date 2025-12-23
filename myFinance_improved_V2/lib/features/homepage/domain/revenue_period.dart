/// Revenue period enumeration for filtering revenue data
///
/// Represents different time periods for revenue analysis.
/// Used with get_dashboard_revenue_v3 RPC.
///
/// Supported periods:
/// - today, yesterday
/// - past_7_days (rolling 7 days including today)
/// - this_month, last_month
/// - this_year
enum RevenuePeriod {
  today('Today', 'vs Yesterday', 'today'),
  yesterday('Yesterday', 'vs Day Before', 'yesterday'),
  past7Days('Past 7 Days', 'vs Previous 7 Days', 'past_7_days'),
  thisMonth('This Month', 'vs Last Month', 'this_month'),
  lastMonth('Last Month', 'vs Previous Month', 'last_month'),
  thisYear('This Year', 'vs Last Year', 'this_year');

  final String displayName;
  final String comparisonText;
  final String apiValue; // For get_dashboard_revenue_v3

  const RevenuePeriod(this.displayName, this.comparisonText, this.apiValue);

  /// Parse string to RevenuePeriod enum
  static RevenuePeriod fromString(String value) {
    return RevenuePeriod.values.firstWhere(
      (period) => period.name == value || period.displayName == value || period.apiValue == value,
      orElse: () => RevenuePeriod.today,
    );
  }
}
