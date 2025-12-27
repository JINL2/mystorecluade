import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../data/datasources/pi_remote_datasource.dart';
import '../../data/repositories/pi_repository_impl.dart';
import '../../domain/entities/proforma_invoice.dart';
import '../../domain/repositories/pi_repository.dart';
import '../../../../app/providers/app_state_provider.dart';

// === Datasource & Repository ===
final piDatasourceProvider = Provider<PIRemoteDatasource>((ref) {
  return PIRemoteDatasourceImpl(Supabase.instance.client);
});

final piRepositoryProvider = Provider<PIRepository>((ref) {
  return PIRepositoryImpl(ref.watch(piDatasourceProvider));
});

// === List State ===
class PIListState {
  final List<PIListItem> items;
  final bool isLoading;
  final bool isLoadingMore;
  final String? error;
  final int totalCount;
  final int currentPage;
  final bool hasMore;
  final PIListParams? lastParams;

  const PIListState({
    this.items = const [],
    this.isLoading = false,
    this.isLoadingMore = false,
    this.error,
    this.totalCount = 0,
    this.currentPage = 1,
    this.hasMore = false,
    this.lastParams,
  });

  PIListState copyWith({
    List<PIListItem>? items,
    bool? isLoading,
    bool? isLoadingMore,
    String? error,
    int? totalCount,
    int? currentPage,
    bool? hasMore,
    PIListParams? lastParams,
  }) {
    return PIListState(
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

class PIListNotifier extends StateNotifier<PIListState> {
  final PIRepository _repository;
  final String? _companyId;
  final String? _storeId;

  PIListNotifier(this._repository, this._companyId, this._storeId)
      : super(const PIListState());

  Future<void> loadList({
    List<PIStatus>? statuses,
    String? counterpartyId,
    DateTime? dateFrom,
    DateTime? dateTo,
    String? searchQuery,
    bool refresh = false,
  }) async {
    if (_companyId == null) {
      state = state.copyWith(error: 'Company not selected');
      return;
    }

    if (refresh) {
      state = state.copyWith(isLoading: true, error: null);
    } else {
      state = state.copyWith(isLoading: true, error: null);
    }

    try {
      final params = PIListParams(
        companyId: _companyId!,
        storeId: _storeId,
        statuses: statuses,
        counterpartyId: counterpartyId,
        dateFrom: dateFrom,
        dateTo: dateTo,
        searchQuery: searchQuery,
        page: 1,
        pageSize: 20,
      );

      final result = await _repository.getList(params);

      state = state.copyWith(
        items: result.items,
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
      final params = PIListParams(
        companyId: state.lastParams!.companyId,
        storeId: state.lastParams!.storeId,
        statuses: state.lastParams!.statuses,
        counterpartyId: state.lastParams!.counterpartyId,
        dateFrom: state.lastParams!.dateFrom,
        dateTo: state.lastParams!.dateTo,
        searchQuery: state.lastParams!.searchQuery,
        page: state.currentPage + 1,
        pageSize: state.lastParams!.pageSize,
      );

      final result = await _repository.getList(params);

      state = state.copyWith(
        items: [...state.items, ...result.items],
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

final piListProvider =
    StateNotifierProvider<PIListNotifier, PIListState>((ref) {
  final repository = ref.watch(piRepositoryProvider);
  final appState = ref.watch(appStateProvider);
  final companyId = appState.companyChoosen.isNotEmpty ? appState.companyChoosen : null;
  final storeId = appState.storeChoosen.isNotEmpty ? appState.storeChoosen : null;
  return PIListNotifier(
    repository,
    companyId,
    storeId,
  );
});

// === Detail State ===
class PIDetailState {
  final ProformaInvoice? pi;
  final bool isLoading;
  final String? error;

  const PIDetailState({
    this.pi,
    this.isLoading = false,
    this.error,
  });

  PIDetailState copyWith({
    ProformaInvoice? pi,
    bool? isLoading,
    String? error,
  }) {
    return PIDetailState(
      pi: pi ?? this.pi,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class PIDetailNotifier extends StateNotifier<PIDetailState> {
  final PIRepository _repository;

  PIDetailNotifier(this._repository) : super(const PIDetailState());

  Future<void> load(String piId) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final pi = await _repository.getById(piId);
      state = state.copyWith(pi: pi, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> send() async {
    if (state.pi == null) return;

    try {
      await _repository.send(state.pi!.piId);
      await load(state.pi!.piId);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> accept() async {
    if (state.pi == null) return;

    try {
      await _repository.accept(state.pi!.piId);
      await load(state.pi!.piId);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> reject(String? reason) async {
    if (state.pi == null) return;

    try {
      await _repository.reject(state.pi!.piId, reason);
      await load(state.pi!.piId);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<String?> convertToPO() async {
    if (state.pi == null) return null;

    try {
      final poId = await _repository.convertToPO(state.pi!.piId);
      await load(state.pi!.piId);
      return poId;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return null;
    }
  }

  Future<ProformaInvoice?> duplicate() async {
    if (state.pi == null) return null;

    try {
      return await _repository.duplicate(state.pi!.piId);
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return null;
    }
  }

  void clear() {
    state = const PIDetailState();
  }
}

final piDetailProvider =
    StateNotifierProvider<PIDetailNotifier, PIDetailState>((ref) {
  return PIDetailNotifier(ref.watch(piRepositoryProvider));
});

// === Form State ===
class PIFormState {
  final bool isLoading;
  final bool isSaving;
  final String? error;
  final String? generatedNumber;
  final ProformaInvoice? savedPI;

  const PIFormState({
    this.isLoading = false,
    this.isSaving = false,
    this.error,
    this.generatedNumber,
    this.savedPI,
  });

  PIFormState copyWith({
    bool? isLoading,
    bool? isSaving,
    String? error,
    String? generatedNumber,
    ProformaInvoice? savedPI,
  }) {
    return PIFormState(
      isLoading: isLoading ?? this.isLoading,
      isSaving: isSaving ?? this.isSaving,
      error: error,
      generatedNumber: generatedNumber ?? this.generatedNumber,
      savedPI: savedPI,
    );
  }
}

class PIFormNotifier extends StateNotifier<PIFormState> {
  final PIRepository _repository;
  final String? _companyId;

  PIFormNotifier(this._repository, this._companyId)
      : super(const PIFormState());

  Future<void> generateNumber() async {
    if (_companyId == null) return;

    state = state.copyWith(isLoading: true, error: null);

    try {
      final number = await _repository.generateNumber(_companyId!);
      state = state.copyWith(isLoading: false, generatedNumber: number);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<ProformaInvoice?> create(PICreateParams params) async {
    state = state.copyWith(isSaving: true, error: null);

    try {
      final pi = await _repository.create(params);
      state = state.copyWith(isSaving: false, savedPI: pi);
      return pi;
    } catch (e) {
      state = state.copyWith(isSaving: false, error: e.toString());
      return null;
    }
  }

  Future<ProformaInvoice?> update(String piId, PICreateParams params) async {
    state = state.copyWith(isSaving: true, error: null);

    try {
      final pi = await _repository.update(piId, params);
      state = state.copyWith(isSaving: false, savedPI: pi);
      return pi;
    } catch (e) {
      state = state.copyWith(isSaving: false, error: e.toString());
      return null;
    }
  }

  Future<bool> delete(String piId) async {
    state = state.copyWith(isSaving: true, error: null);

    try {
      await _repository.delete(piId);
      state = state.copyWith(isSaving: false);
      return true;
    } catch (e) {
      state = state.copyWith(isSaving: false, error: e.toString());
      return false;
    }
  }

  void reset() {
    state = const PIFormState();
  }
}

final piFormProvider =
    StateNotifierProvider<PIFormNotifier, PIFormState>((ref) {
  final repository = ref.watch(piRepositoryProvider);
  final appState = ref.watch(appStateProvider);
  final companyId = appState.companyChoosen.isNotEmpty ? appState.companyChoosen : null;
  return PIFormNotifier(repository, companyId);
});
