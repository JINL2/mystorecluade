import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../data/datasources/lc_remote_datasource.dart';
import '../../data/repositories/lc_repository_impl.dart';
import '../../domain/entities/letter_of_credit.dart';
import '../../domain/repositories/lc_repository.dart';

/// Supabase client provider (shared)
final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

/// LC Remote Datasource provider
final lcRemoteDatasourceProvider = Provider<LCRemoteDatasource>((ref) {
  final supabase = ref.watch(supabaseClientProvider);
  return LCRemoteDatasourceImpl(supabase);
});

/// LC Repository provider
final lcRepositoryProvider = Provider<LCRepository>((ref) {
  final datasource = ref.watch(lcRemoteDatasourceProvider);
  return LCRepositoryImpl(datasource);
});

/// LC List params state
class LCListState {
  final String? searchQuery;
  final List<LCStatus>? statusFilter;
  final int page;
  final bool isLoading;
  final String? error;

  const LCListState({
    this.searchQuery,
    this.statusFilter,
    this.page = 1,
    this.isLoading = false,
    this.error,
  });

  LCListState copyWith({
    String? searchQuery,
    List<LCStatus>? statusFilter,
    int? page,
    bool? isLoading,
    String? error,
  }) {
    return LCListState(
      searchQuery: searchQuery ?? this.searchQuery,
      statusFilter: statusFilter ?? this.statusFilter,
      page: page ?? this.page,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// LC List provider with auto-refresh
final lcListProvider = FutureProvider.autoDispose
    .family<PaginatedLCResponse, LCListParams>((ref, params) async {
  final repository = ref.watch(lcRepositoryProvider);
  return repository.getList(params);
});

/// Single LC detail provider
final lcDetailProvider =
    FutureProvider.autoDispose.family<LetterOfCredit, String>((ref, lcId) async {
  final repository = ref.watch(lcRepositoryProvider);
  return repository.getById(lcId);
});

/// LC create/update notifier
class LCFormNotifier extends StateNotifier<AsyncValue<LetterOfCredit?>> {
  final LCRepository _repository;

  LCFormNotifier(this._repository) : super(const AsyncValue.data(null));

  Future<LetterOfCredit?> create(LCCreateParams params) async {
    state = const AsyncValue.loading();
    try {
      final lc = await _repository.create(params);
      state = AsyncValue.data(lc);
      return lc;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return null;
    }
  }

  Future<LetterOfCredit?> update(
      String lcId, int version, Map<String, dynamic> updates) async {
    state = const AsyncValue.loading();
    try {
      final lc = await _repository.update(lcId, version, updates);
      state = AsyncValue.data(lc);
      return lc;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return null;
    }
  }

  Future<bool> delete(String lcId) async {
    state = const AsyncValue.loading();
    try {
      await _repository.delete(lcId);
      state = const AsyncValue.data(null);
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }

  Future<bool> updateStatus(String lcId, LCStatus newStatus,
      {String? notes}) async {
    try {
      await _repository.updateStatus(lcId, newStatus, notes: notes);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<LCAmendment?> addAmendment(
      String lcId, LCAmendmentCreateParams params) async {
    try {
      return await _repository.addAmendment(lcId, params);
    } catch (e) {
      return null;
    }
  }

  Future<String?> createFromPO(String poId,
      {Map<String, dynamic>? options}) async {
    state = const AsyncValue.loading();
    try {
      final lcId = await _repository.createFromPO(poId, options: options);
      state = const AsyncValue.data(null);
      return lcId;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return null;
    }
  }

  void reset() {
    state = const AsyncValue.data(null);
  }
}

final lcFormNotifierProvider =
    StateNotifierProvider<LCFormNotifier, AsyncValue<LetterOfCredit?>>((ref) {
  final repository = ref.watch(lcRepositoryProvider);
  return LCFormNotifier(repository);
});
