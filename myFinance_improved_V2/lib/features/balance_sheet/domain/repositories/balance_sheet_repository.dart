import '../entities/balance_sheet.dart';
import '../entities/income_statement.dart';
import '../value_objects/currency.dart';

/// Balance sheet repository interface
abstract class BalanceSheetRepository {
  /// Get balance sheet data (v2 - no date filter, uses balance_sheet_logs)
  Future<BalanceSheet> getBalanceSheet({
    required String companyId,
    String? storeId,
  });

  /// Get income statement data (v3 - with timezone support)
  ///
  /// Parameters:
  /// - companyId: Company UUID
  /// - startTime: Start timestamp in user's local time (YYYY-MM-DD HH:MM:SS)
  /// - endTime: End timestamp in user's local time (YYYY-MM-DD HH:MM:SS)
  /// - timezone: IANA timezone string (e.g., 'Asia/Ho_Chi_Minh', 'Asia/Seoul')
  /// - storeId: Optional store UUID (null = all stores)
  Future<IncomeStatement> getIncomeStatement({
    required String companyId,
    required String startTime,
    required String endTime,
    required String timezone,
    String? storeId,
  });

  /// Get currency for a company
  Future<Currency> getCurrency(String companyId);
}
