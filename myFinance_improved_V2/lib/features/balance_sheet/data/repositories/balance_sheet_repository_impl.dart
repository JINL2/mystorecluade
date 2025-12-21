import '../../../../core/domain/entities/store.dart';
import '../../domain/entities/balance_sheet.dart';
import '../../domain/entities/income_statement.dart';
import '../../domain/repositories/balance_sheet_repository.dart';
import '../../domain/value_objects/currency.dart';
import '../datasources/balance_sheet_data_source.dart';
import '../models/balance_sheet_model.dart';
import '../models/income_statement_model.dart';

/// Balance sheet repository implementation
class BalanceSheetRepositoryImpl implements BalanceSheetRepository {
  final BalanceSheetDataSource _dataSource;

  BalanceSheetRepositoryImpl(this._dataSource);

  @override
  Future<BalanceSheet> getBalanceSheet({
    required String companyId,
    required String startDate,
    required String endDate,
    String? storeId,
  }) async {
    try {
      final rawData = await _dataSource.getBalanceSheetRaw(
        companyId: companyId,
        startDate: startDate,
        endDate: endDate,
        storeId: storeId,
      );

      final model = BalanceSheetModel.fromJson(rawData);
      return model.toEntity();
    } catch (e) {
      throw Exception('Failed to get balance sheet: ${e.toString()}');
    }
  }

  @override
  Future<IncomeStatement> getIncomeStatement({
    required String companyId,
    required String startDate,
    required String endDate,
    String? storeId,
  }) async {
    try {
      final rawData = await _dataSource.getIncomeStatementRaw(
        companyId: companyId,
        startDate: startDate,
        endDate: endDate,
        storeId: storeId,
      );

      final model = IncomeStatementModel.fromJson(
        data: rawData,
        parameters: {
          'start_date': startDate,
          'end_date': endDate,
          'company_id': companyId,
          'store_id': storeId,
        },
      );
      return model.toEntity();
    } catch (e) {
      throw Exception('Failed to get income statement: ${e.toString()}');
    }
  }

  @override
  Future<List<Store>> getStores(String companyId) async {
    try {
      final rawData = await _dataSource.getStoresRaw(companyId);

      return rawData.map((store) {
        return Store(
          id: store['store_id']?.toString() ?? '',
          storeName: store['store_name']?.toString() ?? '',
          storeCode: store['store_code']?.toString() ?? '',
          companyId: companyId,
        );
      }).toList();
    } catch (e) {
      throw Exception('Failed to get stores: ${e.toString()}');
    }
  }

  @override
  Future<Currency> getCurrency(String companyId) async {
    try {
      final rawData = await _dataSource.getCurrencyRaw(companyId);

      return Currency(
        code: rawData['currency_code']?.toString() ?? 'KRW',
        symbol: rawData['symbol']?.toString() ?? '₩',
      );
    } catch (e) {
      // Return default currency on error
      return Currency.krw();
    }
  }
}
