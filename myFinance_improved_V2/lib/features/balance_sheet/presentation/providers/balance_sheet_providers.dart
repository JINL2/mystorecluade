import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/domain/entities/store.dart';
import '../../data/datasources/balance_sheet_data_source.dart';
import '../../data/repositories/balance_sheet_repository_impl.dart';
import '../../domain/entities/balance_sheet.dart';
import '../../domain/entities/income_statement.dart';
import '../../domain/repositories/balance_sheet_repository.dart';
import '../../domain/value_objects/currency.dart';
import '../../domain/value_objects/date_range.dart';
import 'states/balance_sheet_page_state.dart';

/// Balance sheet parameters for provider
class BalanceSheetParams {
  final String companyId;
  final String startDate;
  final String endDate;
  final String? storeId;

  const BalanceSheetParams({
    required this.companyId,
    required this.startDate,
    required this.endDate,
    this.storeId,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is BalanceSheetParams &&
        other.companyId == companyId &&
        other.startDate == startDate &&
        other.endDate == endDate &&
        other.storeId == storeId;
  }

  @override
  int get hashCode {
    return companyId.hashCode ^
        startDate.hashCode ^
        endDate.hashCode ^
        (storeId?.hashCode ?? 0);
  }
}

/// Repository provider
final balanceSheetRepositoryProvider = Provider<BalanceSheetRepository>((ref) {
  final dataSource = BalanceSheetDataSource(Supabase.instance.client);
  return BalanceSheetRepositoryImpl(dataSource);
});

/// Balance sheet data provider
final balanceSheetProvider =
    FutureProvider.family<BalanceSheet, BalanceSheetParams>((ref, params) async {
  final repository = ref.read(balanceSheetRepositoryProvider);
  return await repository.getBalanceSheet(
    companyId: params.companyId,
    startDate: params.startDate,
    endDate: params.endDate,
    storeId: params.storeId,
  );
});

/// Income statement data provider
final incomeStatementProvider =
    FutureProvider.family<IncomeStatement, BalanceSheetParams>((ref, params) async {
  final repository = ref.read(balanceSheetRepositoryProvider);
  return await repository.getIncomeStatement(
    companyId: params.companyId,
    startDate: params.startDate,
    endDate: params.endDate,
    storeId: params.storeId,
  );
});

/// Stores provider
final storesProvider = FutureProvider.family<List<Store>, String>((ref, companyId) async {
  final repository = ref.read(balanceSheetRepositoryProvider);
  return await repository.getStores(companyId);
});

/// Currency provider
final currencyProvider = FutureProvider.family<Currency, String>((ref, companyId) async {
  final repository = ref.read(balanceSheetRepositoryProvider);
  return await repository.getCurrency(companyId);
});

/// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
/// 🎯 Balance Sheet Page Notifier - 페이지 상태 관리
/// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
///
/// Balance Sheet 페이지의 UI 상태를 관리합니다.
/// - 탭 선택 (Balance Sheet / Income Statement)
/// - 날짜 범위 선택
/// - 매장 선택
/// - 로딩 상태
/// - 에러 상태
class BalanceSheetPageNotifier extends StateNotifier<BalanceSheetPageState> {
  final BalanceSheetRepository _repository;

  BalanceSheetPageNotifier({
    required BalanceSheetRepository repository,
  })  : _repository = repository,
        super(BalanceSheetPageState.initial());

  /// 탭 변경
  void changeTab(int index) {
    state = state.copyWith(selectedTabIndex: index);
  }

  /// 날짜 범위 변경
  void changeDateRange(DateRange dateRange) {
    state = state.copyWith(
      dateRange: dateRange,
      hasBalanceSheetData: false,
      hasIncomeStatementData: false,
    );
  }

  /// 매장 선택은 App State에서 관리됩니다 (appStateProvider.storeChoosen)
  /// 이 메서드는 삭제되었습니다. App State를 직접 사용하세요.

  /// Balance Sheet 로드
  /// storeId는 App State (appStateProvider.storeChoosen)에서 전달받습니다
  Future<BalanceSheet?> loadBalanceSheet({
    required String companyId,
    required String? storeId,
  }) async {
    state = state.copyWith(
      isLoadingBalanceSheet: true,
      balanceSheetError: null,
    );

    try {
      final balanceSheet = await _repository.getBalanceSheet(
        companyId: companyId,
        startDate: state.dateRange.startDateFormatted,
        endDate: state.dateRange.endDateFormatted,
        storeId: storeId,
      );

      state = state.copyWith(
        isLoadingBalanceSheet: false,
        hasBalanceSheetData: true,
        balanceSheetError: null,
      );

      return balanceSheet;
    } catch (e) {
      state = state.copyWith(
        isLoadingBalanceSheet: false,
        balanceSheetError: e.toString(),
        hasBalanceSheetData: false,
      );
      return null;
    }
  }

  /// Income Statement 로드
  /// storeId는 App State (appStateProvider.storeChoosen)에서 전달받습니다
  Future<IncomeStatement?> loadIncomeStatement({
    required String companyId,
    required String? storeId,
  }) async {
    state = state.copyWith(
      isLoadingIncomeStatement: true,
      incomeStatementError: null,
    );

    try {
      final incomeStatement = await _repository.getIncomeStatement(
        companyId: companyId,
        startDate: state.dateRange.startDateFormatted,
        endDate: state.dateRange.endDateFormatted,
        storeId: storeId,
      );

      state = state.copyWith(
        isLoadingIncomeStatement: false,
        hasIncomeStatementData: true,
        incomeStatementError: null,
      );

      return incomeStatement;
    } catch (e) {
      state = state.copyWith(
        isLoadingIncomeStatement: false,
        incomeStatementError: e.toString(),
        hasIncomeStatementData: false,
      );
      return null;
    }
  }

  /// 매장 목록 로드 (로딩 상태 포함)
  Future<List<Store>> loadStores(String companyId) async {
    state = state.copyWith(isLoadingStores: true);

    try {
      final stores = await _repository.getStores(companyId);
      state = state.copyWith(isLoadingStores: false);
      return stores;
    } catch (e) {
      state = state.copyWith(isLoadingStores: false);
      return [];
    }
  }

  /// 통화 정보 로드 (로딩 상태 포함)
  Future<Currency?> loadCurrency(String companyId) async {
    state = state.copyWith(isLoadingCurrency: true);

    try {
      final currency = await _repository.getCurrency(companyId);
      state = state.copyWith(isLoadingCurrency: false);
      return currency;
    } catch (e) {
      state = state.copyWith(isLoadingCurrency: false);
      return null;
    }
  }

  /// 에러 메시지 지우기

  /// Generate 버튼 클릭 시 데이터 생성 플래그 설정
  void generateBalanceSheet() {
    state = state.copyWith(
      hasBalanceSheetData: true,
      balanceSheetError: null,
    );
  }

  void generateIncomeStatement() {
    state = state.copyWith(
      hasIncomeStatementData: true,
      incomeStatementError: null,
    );
  }
  void clearError() {
    state = state.copyWith(
      balanceSheetError: null,
      incomeStatementError: null,
    );
  }

  /// 상태 초기화
  void reset() {
    state = BalanceSheetPageState.initial();
  }
}

/// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
/// 🎯 Provider 정의
/// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

/// Balance Sheet Page State Provider
final balanceSheetPageProvider = StateNotifierProvider<BalanceSheetPageNotifier, BalanceSheetPageState>((ref) {
  return BalanceSheetPageNotifier(
    repository: ref.read(balanceSheetRepositoryProvider),
  );
});
