import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/stock_flow.dart';

part 'account_detail_state.freezed.dart';

/// State for Account Detail page
///
/// Manages:
/// - Journal flows (transaction list)
/// - Actual flows (real transaction list)
/// - Location summary (balances)
/// - Pagination state
@freezed
class AccountDetailState with _$AccountDetailState {
  const factory AccountDetailState({
    @Default([]) List<JournalFlow> journalFlows,
    @Default([]) List<ActualFlow> actualFlows,
    LocationSummary? locationSummary,

    // Pagination
    @Default(0) int journalOffset,
    @Default(0) int actualOffset,
    @Default(false) bool isLoadingJournal,
    @Default(false) bool isLoadingActual,
    @Default(true) bool hasMoreJournal,
    @Default(true) bool hasMoreActual,

    // Updated balances (from refresh)
    int? updatedTotalJournal,
    int? updatedTotalReal,
    int? updatedCashDifference,
  }) = _AccountDetailState;
}
