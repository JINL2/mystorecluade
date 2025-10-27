import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinance_improved/features/homepage/presentation/providers/company_providers.dart';
import 'package:myfinance_improved/features/homepage/data/datasources/store_remote_datasource.dart';
import 'package:myfinance_improved/features/homepage/data/repositories/store_repository_impl.dart';
import 'package:myfinance_improved/features/homepage/domain/repositories/store_repository.dart';
import 'package:myfinance_improved/features/homepage/domain/usecases/create_store.dart';
import 'package:myfinance_improved/features/homepage/presentation/providers/states/store_state.dart';
import 'package:myfinance_improved/features/homepage/presentation/providers/store_notifier.dart';

/// Store Remote Data Source provider
final storeRemoteDataSourceProvider = Provider<StoreRemoteDataSource>((ref) {
  final supabaseClient = ref.watch(supabaseClientProvider);
  return StoreRemoteDataSourceImpl(supabaseClient);
});

/// Store Repository provider
final storeRepositoryProvider = Provider<StoreRepository>((ref) {
  final remoteDataSource = ref.watch(storeRemoteDataSourceProvider);
  return StoreRepositoryImpl(remoteDataSource);
});

/// Create Store Use Case provider
final createStoreUseCaseProvider = Provider<CreateStore>((ref) {
  final repository = ref.watch(storeRepositoryProvider);
  return CreateStore(repository);
});

/// Store StateNotifier Provider
final storeNotifierProvider =
    StateNotifierProvider<StoreNotifier, StoreState>((ref) {
  final createStore = ref.watch(createStoreUseCaseProvider);
  return StoreNotifier(createStore);
});
