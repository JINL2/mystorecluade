import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../app/providers/app_state_provider.dart';
import '../../data/datasources/po_remote_datasource.dart';
import '../../data/repositories/po_repository_impl.dart';
import '../../domain/entities/purchase_order.dart';
import '../../domain/repositories/po_repository.dart';

part 'po_providers.g.dart';

// === Datasource & Repository ===
@Riverpod(keepAlive: true)
PORemoteDatasource poDatasource(PoDatasourceRef ref) {
  return PORemoteDatasourceImpl(Supabase.instance.client);
}

@Riverpod(keepAlive: true)
PORepository poRepository(PoRepositoryRef ref) {
  return PORepositoryImpl(ref.watch(poDatasourceProvider));
}

// === List State ===
class POListState {
  final List<POListItem> items;
  final bool isLoading;
  final bool isLoadingMore;
  final String? error;
  final int totalCount;
  final int currentPage;
  final bool hasMore;
  final POListParams? lastParams;

  const POListState({
    this.items = const [],
    this.isLoading = false,
    this.isLoadingMore = false,
    this.error,
    this.totalCount = 0,
    this.currentPage = 1,
    this.hasMore = false,
    this.lastParams,
  });

  POListState copyWith({
    List<POListItem>? items,
    bool? isLoading,
    bool? isLoadingMore,
    String? error,
    int? totalCount,
    int? currentPage,
    bool? hasMore,
    POListParams? lastParams,
  }) {
    return POListState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      error: error,
      totalCount: totalCount ?? this.totalCount,
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
      lastParams: lastParams ?? this.lastParams,
    );
  }
}

@riverpod
class PoList extends _$PoList {
  @override
  POListState build() {
    return const POListState();
  }

  String? get _companyId {
    final appState = ref.read(appStateProvider);
    return appState.companyChoosen.isNotEmpty ? appState.companyChoosen : null;
  }

  String? get _storeId {
    final appState = ref.read(appStateProvider);
    return appState.storeChoosen.isNotEmpty ? appState.storeChoosen : null;
  }

  PORepository get _repository => ref.read(poRepositoryProvider);

  Future<void> loadList({
    List<POStatus>? statuses,
    String? counterpartyId,
    bool? hasLc,
    DateTime? dateFrom,
    DateTime? dateTo,
    String? searchQuery,
    bool refresh = false,
  }) async {
    if (_companyId == null) {
      state = state.copyWith(error: 'Company not selected');
      return;
    }

    state = state.copyWith(isLoading: true, error: null);

    try {
      final params = POListParams(
        companyId: _companyId!,
        storeId: _storeId,
        statuses: statuses,
        counterpartyId: counterpartyId,
        hasLc: hasLc,
        dateFrom: dateFrom,
        dateTo: dateTo,
        searchQuery: searchQuery,
        page: 1,
        pageSize: 20,
      );

      final result = await _repository.getList(params);

      state = state.copyWith(
        items: result.data,
        isLoading: false,
        totalCount: result.totalCount,
        currentPage: result.page,
        hasMore: result.hasMore,
        lastParams: params,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> loadMore() async {
    if (state.isLoadingMore || !state.hasMore || state.lastParams == null) {
      return;
    }

    state = state.copyWith(isLoadingMore: true);

    try {
      final params = POListParams(
        companyId: state.lastParams!.companyId,
        storeId: state.lastParams!.storeId,
        statuses: state.lastParams!.statuses,
        counterpartyId: state.lastParams!.counterpartyId,
        hasLc: state.lastParams!.hasLc,
        dateFrom: state.lastParams!.dateFrom,
        dateTo: state.lastParams!.dateTo,
        searchQuery: state.lastParams!.searchQuery,
        page: state.currentPage + 1,
        pageSize: state.lastParams!.pageSize,
      );

      final result = await _repository.getList(params);

      state = state.copyWith(
        items: [...state.items, ...result.data],
        isLoadingMore: false,
        currentPage: result.page,
        hasMore: result.hasMore,
        lastParams: params,
      );
    } catch (e) {
      state = state.copyWith(
        isLoadingMore: false,
        error: e.toString(),
      );
    }
  }

  void refresh() {
    if (state.lastParams != null) {
      loadList(
        statuses: state.lastParams!.statuses,
        counterpartyId: state.lastParams!.counterpartyId,
        hasLc: state.lastParams!.hasLc,
        dateFrom: state.lastParams!.dateFrom,
        dateTo: state.lastParams!.dateTo,
        searchQuery: state.lastParams!.searchQuery,
        refresh: true,
      );
    } else {
      loadList(refresh: true);
    }
  }
}

// === Detail State ===
class PODetailState {
  final PurchaseOrder? po;
  final bool isLoading;
  final String? error;

  const PODetailState({
    this.po,
    this.isLoading = false,
    this.error,
  });

  PODetailState copyWith({
    PurchaseOrder? po,
    bool? isLoading,
    String? error,
  }) {
    return PODetailState(
      po: po ?? this.po,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

@riverpod
class PoDetail extends _$PoDetail {
  @override
  PODetailState build() {
    return const PODetailState();
  }

  PORepository get _repository => ref.read(poRepositoryProvider);

  Future<void> load(String poId) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final po = await _repository.getById(poId);
      state = state.copyWith(po: po, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> confirm() async {
    if (state.po == null) return;

    try {
      await _repository.confirm(state.po!.poId);
      await load(state.po!.poId);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> updateStatus(POStatus newStatus, {String? notes}) async {
    if (state.po == null) return;

    try {
      await _repository.updateStatus(state.po!.poId, newStatus, notes: notes);
      await load(state.po!.poId);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> startProduction() async {
    await updateStatus(POStatus.inProduction);
  }

  Future<void> markReadyToShip() async {
    await updateStatus(POStatus.readyToShip);
  }

  Future<void> markShipped() async {
    await updateStatus(POStatus.shipped);
  }

  Future<void> markPartiallyShipped() async {
    await updateStatus(POStatus.partiallyShipped);
  }

  Future<void> complete() async {
    await updateStatus(POStatus.completed);
  }

  Future<void> cancel({String? reason}) async {
    await updateStatus(POStatus.cancelled, notes: reason);
  }

  void clear() {
    state = const PODetailState();
  }
}

// === Form State ===
class POFormState {
  final bool isLoading;
  final bool isSaving;
  final String? error;
  final String? generatedNumber;
  final PurchaseOrder? savedPO;

  const POFormState({
    this.isLoading = false,
    this.isSaving = false,
    this.error,
    this.generatedNumber,
    this.savedPO,
  });

  POFormState copyWith({
    bool? isLoading,
    bool? isSaving,
    String? error,
    String? generatedNumber,
    PurchaseOrder? savedPO,
  }) {
    return POFormState(
      isLoading: isLoading ?? this.isLoading,
      isSaving: isSaving ?? this.isSaving,
      error: error,
      generatedNumber: generatedNumber ?? this.generatedNumber,
      savedPO: savedPO,
    );
  }
}

@riverpod
class PoForm extends _$PoForm {
  @override
  POFormState build() {
    return const POFormState();
  }

  String? get _companyId {
    final appState = ref.read(appStateProvider);
    return appState.companyChoosen.isNotEmpty ? appState.companyChoosen : null;
  }

  PORepository get _repository => ref.read(poRepositoryProvider);
  PORemoteDatasource get _datasource => ref.read(poDatasourceProvider);

  Future<void> generateNumber() async {
    if (_companyId == null) return;

    state = state.copyWith(isLoading: true, error: null);

    try {
      final number = await _datasource.generateNumber(_companyId!);
      state = state.copyWith(isLoading: false, generatedNumber: number);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<PurchaseOrder?> create(POCreateParams params) async {
    state = state.copyWith(isSaving: true, error: null);

    try {
      final po = await _repository.create(params);
      state = state.copyWith(isSaving: false, savedPO: po);
      return po;
    } catch (e) {
      state = state.copyWith(isSaving: false, error: e.toString());
      return null;
    }
  }

  Future<PurchaseOrder?> update(
    String poId,
    int version,
    Map<String, dynamic> updates,
  ) async {
    state = state.copyWith(isSaving: true, error: null);

    try {
      final po = await _repository.update(poId, version, updates);
      state = state.copyWith(isSaving: false, savedPO: po);
      return po;
    } catch (e) {
      state = state.copyWith(isSaving: false, error: e.toString());
      return null;
    }
  }

  Future<bool> delete(String poId) async {
    state = state.copyWith(isSaving: true, error: null);

    try {
      await _repository.delete(poId);
      state = state.copyWith(isSaving: false);
      return true;
    } catch (e) {
      state = state.copyWith(isSaving: false, error: e.toString());
      return false;
    }
  }

  Future<String?> convertFromPI(
    String piId, {
    Map<String, dynamic>? options,
  }) async {
    state = state.copyWith(isSaving: true, error: null);

    try {
      final poId = await _repository.convertFromPI(piId, options: options);
      state = state.copyWith(isSaving: false);
      return poId;
    } catch (e) {
      state = state.copyWith(isSaving: false, error: e.toString());
      return null;
    }
  }

  void reset() {
    state = const POFormState();
  }
}

// === Accepted PIs for Conversion ===
@riverpod
Future<List<AcceptedPIForConversion>> acceptedPIsForConversion(
  AcceptedPIsForConversionRef ref,
) async {
  final datasource = ref.watch(poDatasourceProvider);
  return datasource.getAcceptedPIsForConversion();
}
