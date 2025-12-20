import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/datasources/session_datasource.dart';
import '../data/repositories/session_repository_impl.dart';
import '../domain/repositories/session_repository.dart';
import '../domain/usecases/add_session_items.dart';
import '../domain/usecases/close_session.dart';
import '../domain/usecases/create_session.dart';
import '../domain/usecases/get_inventory_page.dart';
import '../domain/usecases/get_session_history.dart';
import '../domain/usecases/get_session_list.dart';
import '../domain/usecases/get_session_review_items.dart';
import '../domain/usecases/get_shipment_list.dart';
import '../domain/usecases/get_user_session_items.dart';
import '../domain/usecases/join_session.dart';
import '../domain/usecases/compare_sessions.dart';
import '../domain/usecases/get_product_stock_by_store.dart';
import '../domain/usecases/merge_sessions.dart';
import '../domain/usecases/update_session_items.dart';
import '../domain/usecases/search_products.dart';
import '../domain/usecases/submit_session.dart';

/// Provider for SessionRepository
/// DI layer provider - connects Data layer implementation to Domain layer interface
final sessionRepositoryProvider = Provider<SessionRepository>((ref) {
  final datasource = ref.watch(sessionDatasourceProvider);
  return SessionRepositoryImpl(datasource);
});

/// Provider for GetSessionList UseCase
final getSessionListUseCaseProvider = Provider<GetSessionList>((ref) {
  final repository = ref.watch(sessionRepositoryProvider);
  return GetSessionList(repository);
});

/// Provider for SearchProducts UseCase
final searchProductsUseCaseProvider = Provider<SearchProducts>((ref) {
  final repository = ref.watch(sessionRepositoryProvider);
  return SearchProducts(repository);
});

/// Provider for GetInventoryPage UseCase
final getInventoryPageUseCaseProvider = Provider<GetInventoryPage>((ref) {
  final repository = ref.watch(sessionRepositoryProvider);
  return GetInventoryPage(repository);
});

/// Provider for AddSessionItems UseCase
final addSessionItemsUseCaseProvider = Provider<AddSessionItems>((ref) {
  final repository = ref.watch(sessionRepositoryProvider);
  return AddSessionItems(repository);
});

/// Provider for GetSessionReviewItems UseCase
final getSessionReviewItemsUseCaseProvider =
    Provider<GetSessionReviewItems>((ref) {
  final repository = ref.watch(sessionRepositoryProvider);
  return GetSessionReviewItems(repository);
});

/// Provider for SubmitSession UseCase
final submitSessionUseCaseProvider = Provider<SubmitSession>((ref) {
  final repository = ref.watch(sessionRepositoryProvider);
  return SubmitSession(repository);
});

/// Provider for CreateSession UseCase
final createSessionUseCaseProvider = Provider<CreateSession>((ref) {
  final repository = ref.watch(sessionRepositoryProvider);
  return CreateSession(repository);
});

/// Provider for GetShipmentList UseCase
final getShipmentListUseCaseProvider = Provider<GetShipmentList>((ref) {
  final repository = ref.watch(sessionRepositoryProvider);
  return GetShipmentList(repository);
});

/// Provider for JoinSession UseCase
final joinSessionUseCaseProvider = Provider<JoinSession>((ref) {
  final repository = ref.watch(sessionRepositoryProvider);
  return JoinSession(repository);
});

/// Provider for CloseSession UseCase
final closeSessionUseCaseProvider = Provider<CloseSession>((ref) {
  final repository = ref.watch(sessionRepositoryProvider);
  return CloseSession(repository);
});

/// Provider for GetSessionHistory UseCase
final getSessionHistoryUseCaseProvider = Provider<GetSessionHistory>((ref) {
  final repository = ref.watch(sessionRepositoryProvider);
  return GetSessionHistory(repository);
});

/// Provider for GetUserSessionItems UseCase
final getUserSessionItemsUseCaseProvider = Provider<GetUserSessionItems>((ref) {
  final repository = ref.watch(sessionRepositoryProvider);
  return GetUserSessionItems(repository);
});

/// Provider for UpdateSessionItems UseCase
final updateSessionItemsUseCaseProvider = Provider<UpdateSessionItems>((ref) {
  final repository = ref.watch(sessionRepositoryProvider);
  return UpdateSessionItems(repository);
});

/// Provider for CompareSessions UseCase
final compareSessionsUseCaseProvider = Provider<CompareSessions>((ref) {
  final repository = ref.watch(sessionRepositoryProvider);
  return CompareSessions(repository);
});

/// Provider for MergeSessions UseCase
final mergeSessionsUseCaseProvider = Provider<MergeSessions>((ref) {
  final repository = ref.watch(sessionRepositoryProvider);
  return MergeSessions(repository);
});

/// Provider for GetProductStockByStore UseCase
final getProductStockByStoreUseCaseProvider = Provider<GetProductStockByStore>((ref) {
  final repository = ref.watch(sessionRepositoryProvider);
  return GetProductStockByStore(repository);
});
