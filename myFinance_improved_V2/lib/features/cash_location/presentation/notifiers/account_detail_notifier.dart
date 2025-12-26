import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../di/cash_location_providers.dart';
import '../../domain/entities/journal_result.dart';
import '../../domain/usecases/create_error_adjustment_use_case.dart';
import '../../domain/usecases/create_foreign_currency_translation_use_case.dart';
import '../../domain/usecases/get_stock_flow_use_case.dart';
import '../../domain/value_objects/stock_flow_params.dart';
import 'account_detail_state.dart';

part 'account_detail_notifier.g.dart';

/// Notifier for Account Detail page
///
/// Handles:
/// - Loading journal/actual flows with pagination
/// - Creating error adjustments
/// - Creating foreign currency translations
/// - Refreshing data
@riverpod
class AccountDetailNotifier extends _$AccountDetailNotifier {
  late final GetStockFlowUseCase _getStockFlowUseCase;
  late final CreateErrorAdjustmentUseCase _createErrorUseCase;
  late final CreateForeignCurrencyTranslationUseCase _createForeignCurrencyUseCase;

  static const int _pageLimit = 20;
  static const int _maxItemsInMemory = 100;

  @override
  AccountDetailState build(String locationId) {
    _getStockFlowUseCase = ref.read(getStockFlowUseCaseProvider);
    _createErrorUseCase = ref.read(createErrorAdjustmentUseCaseProvider);
    _createForeignCurrencyUseCase = ref.read(createForeignCurrencyTranslationUseCaseProvider);
    return const AccountDetailState();
  }

  /// Load initial data
  Future<void> loadInitialData({
    required String companyId,
    required String storeId,
    required String locationId,
  }) async {
    state = state.copyWith(isLoadingJournal: true, isLoadingActual: true);

    try {
      final response = await _getStockFlowUseCase(StockFlowParams(
        companyId: companyId,
        storeId: storeId,
        cashLocationId: locationId,
        offset: 0,
        limit: _pageLimit,
      ));

      if (!response.success || response.data == null) {
        state = state.copyWith(
          isLoadingJournal: false,
          isLoadingActual: false,
        );
        return;
      }

      final data = response.data!;
      final journalFlows = data.journalFlows;
      final actualFlows = data.actualFlows;
      final locationSummary = data.locationSummary;

      state = state.copyWith(
        journalFlows: journalFlows,
        actualFlows: actualFlows,
        locationSummary: locationSummary,
        journalOffset: _pageLimit,
        actualOffset: _pageLimit,
        isLoadingJournal: false,
        isLoadingActual: false,
        hasMoreJournal: response.pagination?.hasMore ?? false,
        hasMoreActual: response.pagination?.hasMore ?? false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoadingJournal: false,
        isLoadingActual: false,
      );
      rethrow;
    }
  }

  /// Load more journal/actual flows
  Future<void> loadMore({
    required String companyId,
    required String storeId,
    required String locationId,
  }) async {
    if (state.isLoadingJournal || !state.hasMoreJournal) return;

    state = state.copyWith(isLoadingJournal: true);

    try {
      final response = await _getStockFlowUseCase(StockFlowParams(
        companyId: companyId,
        storeId: storeId,
        cashLocationId: locationId,
        offset: state.journalOffset,
        limit: _pageLimit,
      ));

      if (!response.success || response.data == null) {
        state = state.copyWith(isLoadingJournal: false);
        return;
      }

      final data = response.data!;
      final newJournalFlows = data.journalFlows;
      final newActualFlows = data.actualFlows;

      // Combine with existing data
      var updatedJournalFlows = [...state.journalFlows, ...newJournalFlows];
      var updatedActualFlows = [...state.actualFlows, ...newActualFlows];

      // Keep only recent items to prevent memory leak
      if (updatedJournalFlows.length > _maxItemsInMemory) {
        final removeCount = updatedJournalFlows.length - _maxItemsInMemory;
        updatedJournalFlows = updatedJournalFlows.sublist(removeCount);
      }
      if (updatedActualFlows.length > _maxItemsInMemory) {
        final removeCount = updatedActualFlows.length - _maxItemsInMemory;
        updatedActualFlows = updatedActualFlows.sublist(removeCount);
      }

      state = state.copyWith(
        journalFlows: updatedJournalFlows,
        actualFlows: updatedActualFlows,
        journalOffset: state.journalOffset + _pageLimit,
        actualOffset: state.actualOffset + _pageLimit,
        isLoadingJournal: false,
        hasMoreJournal: response.pagination?.hasMore ?? false,
        hasMoreActual: response.pagination?.hasMore ?? false,
      );
    } catch (e) {
      state = state.copyWith(isLoadingJournal: false);
      rethrow;
    }
  }

  /// Refresh data (pull to refresh)
  Future<void> refresh({
    required String companyId,
    required String storeId,
    required String locationId,
  }) async {
    // Reset state
    state = const AccountDetailState();

    // Load fresh data
    await loadInitialData(
      companyId: companyId,
      storeId: storeId,
      locationId: locationId,
    );
  }

  /// Create error adjustment journal
  Future<JournalResult> createErrorAdjustment({
    required double errorAmount,
    required String companyId,
    required String storeId,
    required String userId,
    required String cashLocationId,
    required String locationName,
  }) async {
    final result = await _createErrorUseCase(CreateErrorAdjustmentParams(
      differenceAmount: errorAmount,
      companyId: companyId,
      storeId: storeId,
      userId: userId,
      cashLocationId: cashLocationId,
      locationName: locationName,
    ));

    // Refresh data after creating entry
    await refresh(
      companyId: companyId,
      storeId: storeId,
      locationId: cashLocationId,
    );

    return result;
  }

  /// Create foreign currency translation journal
  Future<JournalResult> createForeignCurrencyTranslation({
    required double errorAmount,
    required String companyId,
    required String storeId,
    required String userId,
    required String cashLocationId,
    required String locationName,
  }) async {
    final result = await _createForeignCurrencyUseCase(
      CreateForeignCurrencyTranslationParams(
        differenceAmount: errorAmount,
        companyId: companyId,
        storeId: storeId,
        userId: userId,
        cashLocationId: cashLocationId,
        locationName: locationName,
      ),
    );

    // Refresh data after creating entry
    await refresh(
      companyId: companyId,
      storeId: storeId,
      locationId: cashLocationId,
    );

    return result;
  }
}
