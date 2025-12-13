import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/providers/session_repository_provider.dart';
import '../domain/usecases/add_session_items.dart';
import '../domain/usecases/close_session.dart';
import '../domain/usecases/create_session.dart';
import '../domain/usecases/get_session_history.dart';
import '../domain/usecases/get_session_list.dart';
import '../domain/usecases/get_session_review_items.dart';
import '../domain/usecases/get_shipment_list.dart';
import '../domain/usecases/join_session.dart';
import '../domain/usecases/search_products.dart';
import '../domain/usecases/submit_session.dart';

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
