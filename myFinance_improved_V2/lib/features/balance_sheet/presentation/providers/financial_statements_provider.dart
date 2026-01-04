import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../auth/di/auth_providers.dart';
import '../../data/datasources/balance_sheet_data_source.dart';
import '../../data/repositories/financial_statements_repository_impl.dart';
import '../../domain/entities/pnl_summary.dart';
import '../../domain/entities/bs_summary.dart';
import '../../domain/entities/daily_pnl.dart';
import '../../domain/repositories/financial_statements_repository.dart';

part 'financial_statements_provider.g.dart';

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// DATA SOURCE PROVIDER
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

@riverpod
BalanceSheetDataSource balanceSheetDataSource(Ref ref) {
  return BalanceSheetDataSource(ref.watch(supabaseClientProvider));
}

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// REPOSITORY PROVIDER
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

@riverpod
FinancialStatementsRepository financialStatementsRepository(Ref ref) {
  return FinancialStatementsRepositoryImpl(
    ref.watch(balanceSheetDataSourceProvider),
  );
}

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PAGE STATE
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

enum QuickPeriod {
  today,
  yesterday,
  past7Days,
  thisWeek,
  thisMonth,
  lastMonth,
  thisYear,
  lastYear,
  custom,
}

enum DataLevel { company, store }

class FinancialStatementsPageState {
  final int selectedTabIndex;
  final QuickPeriod selectedPeriod;
  final DateTime startDate;
  final DateTime endDate;
  final bool showDetail;
  final DataLevel dataLevel;

  const FinancialStatementsPageState({
    this.selectedTabIndex = 0,
    this.selectedPeriod = QuickPeriod.thisMonth,
    required this.startDate,
    required this.endDate,
    this.showDetail = false,
    this.dataLevel = DataLevel.company,
  });

  factory FinancialStatementsPageState.initial() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final monthStart = DateTime(now.year, now.month, 1);

    return FinancialStatementsPageState(
      startDate: monthStart,
      endDate: today,
    );
  }

  FinancialStatementsPageState copyWith({
    int? selectedTabIndex,
    QuickPeriod? selectedPeriod,
    DateTime? startDate,
    DateTime? endDate,
    bool? showDetail,
    DataLevel? dataLevel,
  }) {
    return FinancialStatementsPageState(
      selectedTabIndex: selectedTabIndex ?? this.selectedTabIndex,
      selectedPeriod: selectedPeriod ?? this.selectedPeriod,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      showDetail: showDetail ?? this.showDetail,
      dataLevel: dataLevel ?? this.dataLevel,
    );
  }

  /// Get previous period dates for comparison
  ({DateTime start, DateTime end}) get prevPeriodDates {
    final duration = endDate.difference(startDate);
    return (
      start: startDate.subtract(duration + const Duration(days: 1)),
      end: startDate.subtract(const Duration(days: 1)),
    );
  }
}

@riverpod
class FinancialStatementsPageNotifier extends _$FinancialStatementsPageNotifier {
  @override
  FinancialStatementsPageState build() {
    return FinancialStatementsPageState.initial();
  }

  void changeTab(int index) {
    state = state.copyWith(selectedTabIndex: index);
  }

  void changePeriod(QuickPeriod period) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    DateTime startDate;
    DateTime endDate = today;

    switch (period) {
      case QuickPeriod.today:
        startDate = today;
        break;
      case QuickPeriod.yesterday:
        final yesterday = today.subtract(const Duration(days: 1));
        startDate = yesterday;
        endDate = yesterday;
        break;
      case QuickPeriod.past7Days:
        startDate = today.subtract(const Duration(days: 6));
        break;
      case QuickPeriod.thisWeek:
        // Monday start
        startDate = today.subtract(Duration(days: today.weekday - 1));
        break;
      case QuickPeriod.thisMonth:
        startDate = DateTime(now.year, now.month, 1);
        break;
      case QuickPeriod.lastMonth:
        final lastMonth = DateTime(now.year, now.month - 1, 1);
        startDate = lastMonth;
        // Last day of last month
        endDate = DateTime(now.year, now.month, 0);
        break;
      case QuickPeriod.thisYear:
        startDate = DateTime(now.year, 1, 1);
        break;
      case QuickPeriod.lastYear:
        startDate = DateTime(now.year - 1, 1, 1);
        endDate = DateTime(now.year - 1, 12, 31);
        break;
      case QuickPeriod.custom:
        // Keep current dates
        return;
    }

    state = state.copyWith(
      selectedPeriod: period,
      startDate: startDate,
      endDate: endDate,
    );
  }

  void setCustomDateRange(DateTime start, DateTime end) {
    state = state.copyWith(
      selectedPeriod: QuickPeriod.custom,
      startDate: start,
      endDate: end,
    );
  }

  void toggleDetail() {
    state = state.copyWith(showDetail: !state.showDetail);
  }

  void setDataLevel(DataLevel level) {
    state = state.copyWith(dataLevel: level);
  }
}

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PARAMS CLASSES
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

class PnlParams {
  final String companyId;
  final DateTime startDate;
  final DateTime endDate;
  final String? storeId;
  final DateTime? prevStartDate;
  final DateTime? prevEndDate;

  const PnlParams({
    required this.companyId,
    required this.startDate,
    required this.endDate,
    this.storeId,
    this.prevStartDate,
    this.prevEndDate,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PnlParams &&
          companyId == other.companyId &&
          startDate == other.startDate &&
          endDate == other.endDate &&
          storeId == other.storeId &&
          prevStartDate == other.prevStartDate &&
          prevEndDate == other.prevEndDate;

  @override
  int get hashCode => Object.hash(
      companyId, startDate, endDate, storeId, prevStartDate, prevEndDate);
}

class BsParams {
  final String companyId;
  final DateTime asOfDate;
  final String? storeId;
  final DateTime? compareDate;

  const BsParams({
    required this.companyId,
    required this.asOfDate,
    this.storeId,
    this.compareDate,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BsParams &&
          companyId == other.companyId &&
          asOfDate == other.asOfDate &&
          storeId == other.storeId &&
          compareDate == other.compareDate;

  @override
  int get hashCode =>
      Object.hash(companyId, asOfDate, storeId, compareDate);
}

class TrendParams {
  final String companyId;
  final DateTime startDate;
  final DateTime endDate;
  final String? storeId;

  const TrendParams({
    required this.companyId,
    required this.startDate,
    required this.endDate,
    this.storeId,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TrendParams &&
          companyId == other.companyId &&
          startDate == other.startDate &&
          endDate == other.endDate &&
          storeId == other.storeId;

  @override
  int get hashCode => Object.hash(companyId, startDate, endDate, storeId);
}

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// DATA PROVIDERS (using Repository, returning Domain Entities)
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

/// P&L Summary Provider - returns Domain Entity
@riverpod
Future<PnlSummary> pnlSummary(Ref ref, PnlParams params) async {
  final repository = ref.read(financialStatementsRepositoryProvider);
  return repository.getPnlSummary(
    companyId: params.companyId,
    startDate: params.startDate,
    endDate: params.endDate,
    storeId: params.storeId,
    prevStartDate: params.prevStartDate,
    prevEndDate: params.prevEndDate,
  );
}

/// P&L Detail Provider - returns Domain Entities
@riverpod
Future<List<PnlDetailRow>> pnlDetail(Ref ref, PnlParams params) async {
  final repository = ref.read(financialStatementsRepositoryProvider);
  return repository.getPnlDetail(
    companyId: params.companyId,
    startDate: params.startDate,
    endDate: params.endDate,
    storeId: params.storeId,
  );
}

/// B/S Summary Provider - returns Domain Entity
@riverpod
Future<BsSummary> bsSummary(Ref ref, BsParams params) async {
  final repository = ref.read(financialStatementsRepositoryProvider);
  return repository.getBsSummary(
    companyId: params.companyId,
    asOfDate: params.asOfDate,
    storeId: params.storeId,
    compareDate: params.compareDate,
  );
}

/// B/S Detail Provider - returns Domain Entities
@riverpod
Future<List<BsDetailRow>> bsDetail(Ref ref, BsParams params) async {
  final repository = ref.read(financialStatementsRepositoryProvider);
  return repository.getBsDetail(
    companyId: params.companyId,
    asOfDate: params.asOfDate,
    storeId: params.storeId,
  );
}

/// Daily P&L Trend Provider - returns Domain Entities
@riverpod
Future<List<DailyPnl>> dailyPnlTrend(Ref ref, TrendParams params) async {
  final repository = ref.read(financialStatementsRepositoryProvider);
  return repository.getDailyPnlTrend(
    companyId: params.companyId,
    startDate: params.startDate,
    endDate: params.endDate,
    storeId: params.storeId,
  );
}

/// Currency Provider
@riverpod
Future<String> companyCurrency(Ref ref, String companyId) async {
  final repository = ref.read(financialStatementsRepositoryProvider);
  return repository.getCurrencySymbol(companyId);
}
