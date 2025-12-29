import '../../domain/entities/pnl_summary.dart';
import '../../domain/entities/bs_summary.dart';
import '../../domain/entities/daily_pnl.dart';
import '../../domain/repositories/financial_statements_repository.dart';
import '../datasources/balance_sheet_data_source.dart';

/// Financial Statements Repository Implementation (Data Layer)
///
/// Implements [FinancialStatementsRepository] interface.
/// Converts DTOs from DataSource to Domain Entities.
class FinancialStatementsRepositoryImpl implements FinancialStatementsRepository {
  final BalanceSheetDataSource _dataSource;

  FinancialStatementsRepositoryImpl(this._dataSource);

  @override
  Future<PnlSummary> getPnlSummary({
    required String companyId,
    required DateTime startDate,
    required DateTime endDate,
    String? storeId,
    DateTime? prevStartDate,
    DateTime? prevEndDate,
  }) async {
    final dto = await _dataSource.getPnlSummary(
      companyId: companyId,
      startDate: startDate,
      endDate: endDate,
      storeId: storeId,
      prevStartDate: prevStartDate,
      prevEndDate: prevEndDate,
    );
    return dto.toEntity();
  }

  @override
  Future<List<PnlDetailRow>> getPnlDetail({
    required String companyId,
    required DateTime startDate,
    required DateTime endDate,
    String? storeId,
  }) async {
    final dtos = await _dataSource.getPnlDetail(
      companyId: companyId,
      startDate: startDate,
      endDate: endDate,
      storeId: storeId,
    );
    return dtos.map((dto) => dto.toEntity()).toList();
  }

  @override
  Future<BsSummary> getBsSummary({
    required String companyId,
    required DateTime asOfDate,
    String? storeId,
    DateTime? compareDate,
  }) async {
    final dto = await _dataSource.getBsSummary(
      companyId: companyId,
      asOfDate: asOfDate,
      storeId: storeId,
      compareDate: compareDate,
    );
    return dto.toEntity();
  }

  @override
  Future<List<BsDetailRow>> getBsDetail({
    required String companyId,
    required DateTime asOfDate,
    String? storeId,
  }) async {
    final dtos = await _dataSource.getBsDetail(
      companyId: companyId,
      asOfDate: asOfDate,
      storeId: storeId,
    );
    return dtos.map((dto) => dto.toEntity()).toList();
  }

  @override
  Future<List<DailyPnl>> getDailyPnlTrend({
    required String companyId,
    required DateTime startDate,
    required DateTime endDate,
    String? storeId,
  }) async {
    final dtos = await _dataSource.getDailyPnlTrend(
      companyId: companyId,
      startDate: startDate,
      endDate: endDate,
      storeId: storeId,
    );
    return dtos.map((dto) => dto.toEntity()).toList();
  }

  @override
  Future<String> getCurrencySymbol(String companyId) async {
    final currency = await _dataSource.getCurrencyRaw(companyId);
    return currency['symbol'] as String? ?? '₫';
  }
}
