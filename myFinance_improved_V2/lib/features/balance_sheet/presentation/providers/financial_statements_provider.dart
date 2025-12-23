import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../data/datasources/balance_sheet_data_source.dart';
import '../../data/models/pnl_summary_model.dart';
import '../../data/models/bs_summary_model.dart';

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// DATA SOURCE PROVIDER
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

final balanceSheetDataSourceProvider = Provider<BalanceSheetDataSource>((ref) {
  return BalanceSheetDataSource(Supabase.instance.client);
});

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PAGE STATE
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

enum QuickPeriod { today, thisWeek, thisMonth, thisYear, custom }

class FinancialStatementsPageState {
  final int selectedTabIndex;
  final QuickPeriod selectedPeriod;
  final DateTime startDate;
  final DateTime endDate;
  final bool showDetail;

  const FinancialStatementsPageState({
    this.selectedTabIndex = 0,
    this.selectedPeriod = QuickPeriod.thisMonth,
    required this.startDate,
    required this.endDate,
    this.showDetail = false,
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
  }) {
    return FinancialStatementsPageState(
      selectedTabIndex: selectedTabIndex ?? this.selectedTabIndex,
      selectedPeriod: selectedPeriod ?? this.selectedPeriod,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      showDetail: showDetail ?? this.showDetail,
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

class FinancialStatementsPageNotifier
    extends StateNotifier<FinancialStatementsPageState> {
  FinancialStatementsPageNotifier()
      : super(FinancialStatementsPageState.initial());

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
      case QuickPeriod.thisWeek:
        // Monday start
        startDate = today.subtract(Duration(days: today.weekday - 1));
        break;
      case QuickPeriod.thisMonth:
        startDate = DateTime(now.year, now.month, 1);
        break;
      case QuickPeriod.thisYear:
        startDate = DateTime(now.year, 1, 1);
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
}

final financialStatementsPageProvider = StateNotifierProvider<
    FinancialStatementsPageNotifier, FinancialStatementsPageState>((ref) {
  return FinancialStatementsPageNotifier();
});

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// DATA PROVIDERS
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

/// P&L Summary Provider
final pnlSummaryProvider =
    FutureProvider.family<PnlSummaryModel, PnlParams>((ref, params) async {
  final dataSource = ref.read(balanceSheetDataSourceProvider);
  return dataSource.getPnlSummary(
    companyId: params.companyId,
    startDate: params.startDate,
    endDate: params.endDate,
    storeId: params.storeId,
    prevStartDate: params.prevStartDate,
    prevEndDate: params.prevEndDate,
  );
});

/// P&L Detail Provider
final pnlDetailProvider =
    FutureProvider.family<List<PnlDetailRowModel>, PnlParams>((ref, params) async {
  final dataSource = ref.read(balanceSheetDataSourceProvider);
  return dataSource.getPnlDetail(
    companyId: params.companyId,
    startDate: params.startDate,
    endDate: params.endDate,
    storeId: params.storeId,
  );
});

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

/// B/S Summary Provider
final bsSummaryProvider =
    FutureProvider.family<BsSummaryModel, BsParams>((ref, params) async {
  final dataSource = ref.read(balanceSheetDataSourceProvider);
  return dataSource.getBsSummary(
    companyId: params.companyId,
    asOfDate: params.asOfDate,
    storeId: params.storeId,
    compareDate: params.compareDate,
  );
});

/// B/S Detail Provider
final bsDetailProvider =
    FutureProvider.family<List<BsDetailRowModel>, BsParams>((ref, params) async {
  final dataSource = ref.read(balanceSheetDataSourceProvider);
  return dataSource.getBsDetail(
    companyId: params.companyId,
    asOfDate: params.asOfDate,
    storeId: params.storeId,
  );
});

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

/// Daily P&L Trend Provider
final dailyPnlTrendProvider =
    FutureProvider.family<List<DailyPnlModel>, TrendParams>((ref, params) async {
  final dataSource = ref.read(balanceSheetDataSourceProvider);
  return dataSource.getDailyPnlTrend(
    companyId: params.companyId,
    startDate: params.startDate,
    endDate: params.endDate,
    storeId: params.storeId,
  );
});

/// Currency Provider
final companyCurrencyProvider =
    FutureProvider.family<String, String>((ref, companyId) async {
  final dataSource = ref.read(balanceSheetDataSourceProvider);
  final currency = await dataSource.getCurrencyRaw(companyId);
  return currency['symbol'] as String? ?? '₫';
});
