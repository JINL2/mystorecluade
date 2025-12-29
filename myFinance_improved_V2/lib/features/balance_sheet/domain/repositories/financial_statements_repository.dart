import '../entities/pnl_summary.dart';
import '../entities/bs_summary.dart';
import '../entities/daily_pnl.dart';

/// Financial Statements Repository Interface (Domain Layer)
///
/// Defines the contract for fetching financial statements data.
/// Implementation is in the data layer.
abstract class FinancialStatementsRepository {
  /// Get P&L Summary for a period
  ///
  /// [companyId] - Company identifier
  /// [startDate] - Start of the period
  /// [endDate] - End of the period
  /// [storeId] - Optional store filter
  /// [prevStartDate] - Optional previous period start for comparison
  /// [prevEndDate] - Optional previous period end for comparison
  Future<PnlSummary> getPnlSummary({
    required String companyId,
    required DateTime startDate,
    required DateTime endDate,
    String? storeId,
    DateTime? prevStartDate,
    DateTime? prevEndDate,
  });

  /// Get P&L Detail breakdown by account
  Future<List<PnlDetailRow>> getPnlDetail({
    required String companyId,
    required DateTime startDate,
    required DateTime endDate,
    String? storeId,
  });

  /// Get Balance Sheet Summary as of a date
  ///
  /// [companyId] - Company identifier
  /// [asOfDate] - Date for the balance sheet
  /// [storeId] - Optional store filter
  /// [compareDate] - Optional comparison date
  Future<BsSummary> getBsSummary({
    required String companyId,
    required DateTime asOfDate,
    String? storeId,
    DateTime? compareDate,
  });

  /// Get Balance Sheet Detail breakdown by account
  Future<List<BsDetailRow>> getBsDetail({
    required String companyId,
    required DateTime asOfDate,
    String? storeId,
  });

  /// Get Daily P&L Trend for charting
  Future<List<DailyPnl>> getDailyPnlTrend({
    required String companyId,
    required DateTime startDate,
    required DateTime endDate,
    String? storeId,
  });

  /// Get company currency symbol
  Future<String> getCurrencySymbol(String companyId);
}
