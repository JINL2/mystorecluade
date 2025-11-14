import '../../domain/entities/stock_flow.dart';

/// State for Account Detail page
///
/// Manages:
/// - Journal flows (transaction list)
/// - Actual flows (real transaction list)
/// - Location summary (balances)
/// - Pagination state
class AccountDetailState {
  final List<JournalFlow> journalFlows;
  final List<ActualFlow> actualFlows;
  final LocationSummary? locationSummary;

  // Pagination
  final int journalOffset;
  final int actualOffset;
  final bool isLoadingJournal;
  final bool isLoadingActual;
  final bool hasMoreJournal;
  final bool hasMoreActual;

  // Updated balances (from refresh)
  final int? updatedTotalJournal;
  final int? updatedTotalReal;
  final int? updatedCashDifference;

  const AccountDetailState({
    this.journalFlows = const [],
    this.actualFlows = const [],
    this.locationSummary,
    this.journalOffset = 0,
    this.actualOffset = 0,
    this.isLoadingJournal = false,
    this.isLoadingActual = false,
    this.hasMoreJournal = true,
    this.hasMoreActual = true,
    this.updatedTotalJournal,
    this.updatedTotalReal,
    this.updatedCashDifference,
  });

  AccountDetailState copyWith({
    List<JournalFlow>? journalFlows,
    List<ActualFlow>? actualFlows,
    LocationSummary? locationSummary,
    int? journalOffset,
    int? actualOffset,
    bool? isLoadingJournal,
    bool? isLoadingActual,
    bool? hasMoreJournal,
    bool? hasMoreActual,
    int? updatedTotalJournal,
    int? updatedTotalReal,
    int? updatedCashDifference,
  }) {
    return AccountDetailState(
      journalFlows: journalFlows ?? this.journalFlows,
      actualFlows: actualFlows ?? this.actualFlows,
      locationSummary: locationSummary ?? this.locationSummary,
      journalOffset: journalOffset ?? this.journalOffset,
      actualOffset: actualOffset ?? this.actualOffset,
      isLoadingJournal: isLoadingJournal ?? this.isLoadingJournal,
      isLoadingActual: isLoadingActual ?? this.isLoadingActual,
      hasMoreJournal: hasMoreJournal ?? this.hasMoreJournal,
      hasMoreActual: hasMoreActual ?? this.hasMoreActual,
      updatedTotalJournal: updatedTotalJournal ?? this.updatedTotalJournal,
      updatedTotalReal: updatedTotalReal ?? this.updatedTotalReal,
      updatedCashDifference: updatedCashDifference ?? this.updatedCashDifference,
    );
  }
}
