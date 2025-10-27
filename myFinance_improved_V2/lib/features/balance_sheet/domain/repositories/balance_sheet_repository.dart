import '../../../../core/domain/entities/store.dart';
import '../entities/balance_sheet.dart';
import '../entities/income_statement.dart';
import '../value_objects/currency.dart';

/// Balance sheet repository interface
abstract class BalanceSheetRepository {
  /// Get balance sheet data
  Future<BalanceSheet> getBalanceSheet({
    required String companyId,
    required String startDate,
    required String endDate,
    String? storeId,
  });

  /// Get income statement data
  Future<IncomeStatement> getIncomeStatement({
    required String companyId,
    required String startDate,
    required String endDate,
    String? storeId,
  });

  /// Get stores for a company
  Future<List<Store>> getStores(String companyId);

  /// Get currency for a company
  Future<Currency> getCurrency(String companyId);
}
