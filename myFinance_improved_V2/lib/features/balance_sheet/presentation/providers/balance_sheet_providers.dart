import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/domain/entities/store.dart';
import '../../di/balance_sheet_injection.dart';
import '../../domain/entities/balance_sheet.dart';
import '../../domain/entities/income_statement.dart';
import '../../domain/value_objects/currency.dart';
import '../../domain/value_objects/date_range.dart';
import 'states/balance_sheet_page_state.dart';

// Re-export repository provider from DI for backward compatibility
export '../../di/balance_sheet_injection.dart' show balanceSheetRepositoryProvider;

part 'balance_sheet_providers.g.dart';

/// Balance sheet parameters for provider (v2 - no date filter)
class BalanceSheetParams {
  final String companyId;
  final String? storeId;

  const BalanceSheetParams({
    required this.companyId,
    this.storeId,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is BalanceSheetParams &&
        other.companyId == companyId &&
        other.storeId == storeId;
  }

  @override
  int get hashCode {
    return companyId.hashCode ^ (storeId?.hashCode ?? 0);
  }
}

/// Income statement parameters for provider (v3 - with timezone support)
class IncomeStatementParams {
  final String companyId;
  final String startTime; // Format: 'YYYY-MM-DD HH:MM:SS' (user's local time)
  final String endTime; // Format: 'YYYY-MM-DD HH:MM:SS' (user's local time)
  final String timezone; // IANA timezone (e.g., 'Asia/Ho_Chi_Minh', 'Asia/Seoul')
  final String? storeId;

  const IncomeStatementParams({
    required this.companyId,
    required this.startTime,
    required this.endTime,
    required this.timezone,
    this.storeId,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is IncomeStatementParams &&
        other.companyId == companyId &&
        other.startTime == startTime &&
        other.endTime == endTime &&
        other.timezone == timezone &&
        other.storeId == storeId;
  }

  @override
  int get hashCode {
    return companyId.hashCode ^
        startTime.hashCode ^
        endTime.hashCode ^
        timezone.hashCode ^
        (storeId?.hashCode ?? 0);
  }
}

/// Balance sheet data provider (v2 - no date filter)
@riverpod
Future<BalanceSheet> balanceSheet(Ref ref, BalanceSheetParams params) async {
  final repository = ref.read(balanceSheetRepositoryProvider);
  return await repository.getBalanceSheet(
    companyId: params.companyId,
    storeId: params.storeId,
  );
}

/// Income statement data provider (v3 - with timezone support)
@riverpod
Future<IncomeStatement> incomeStatement(Ref ref, IncomeStatementParams params) async {
  final repository = ref.read(balanceSheetRepositoryProvider);
  return await repository.getIncomeStatement(
    companyId: params.companyId,
    startTime: params.startTime,
    endTime: params.endTime,
    timezone: params.timezone,
    storeId: params.storeId,
  );
}

/// Stores provider
@riverpod
Future<List<Store>> stores(Ref ref, String companyId) async {
  final repository = ref.read(balanceSheetRepositoryProvider);
  return await repository.getStores(companyId);
}

/// Currency provider
@riverpod
Future<Currency> currency(Ref ref, String companyId) async {
  final repository = ref.read(balanceSheetRepositoryProvider);
  return await repository.getCurrency(companyId);
}

/// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
/// 🎯 Balance Sheet Page Notifier - 페이지 상태 관리
/// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
///
/// Balance Sheet 페이지의 UI 상태만 관리합니다.
/// - 탭 선택 (Balance Sheet / Income Statement)
/// - 날짜 범위 선택
/// - 데이터 생성 플래그
///
/// 데이터 로딩은 FutureProvider (balanceSheetProvider, incomeStatementProvider)가 담당합니다.
@riverpod
class BalanceSheetPageNotifier extends _$BalanceSheetPageNotifier {
  @override
  BalanceSheetPageState build() {
    return BalanceSheetPageState.initial();
  }

  /// 탭 변경
  void changeTab(int index) {
    state = state.copyWith(selectedTabIndex: index);
  }

  /// 날짜 범위 변경 (Income Statement에만 영향)
  void changeDateRange(DateRange dateRange) {
    state = state.copyWith(
      dateRange: dateRange,
      hasIncomeStatementData: false,
    );
  }

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

  /// 에러 메시지 지우기
  void clearError() {
    state = state.copyWith(
      balanceSheetError: null,
      incomeStatementError: null,
    );
  }

  /// Clear balance sheet data and return to input
  void clearBalanceSheetData() {
    state = state.copyWith(hasBalanceSheetData: false);
  }

  /// Clear income statement data and return to input
  void clearIncomeStatementData() {
    state = state.copyWith(hasIncomeStatementData: false);
  }

  /// 상태 초기화
  void reset() {
    state = BalanceSheetPageState.initial();
  }
}
