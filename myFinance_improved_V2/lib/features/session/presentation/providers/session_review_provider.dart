import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/providers/app_state_provider.dart';
import '../../data/providers/session_repository_provider.dart';
import 'states/session_review_state.dart';

/// Notifier for session review state management
class SessionReviewNotifier extends StateNotifier<SessionReviewState> {
  final Ref _ref;

  SessionReviewNotifier({
    required Ref ref,
    required String sessionId,
    required String sessionType,
    String? sessionName,
  })  : _ref = ref,
        super(SessionReviewState.initial(
          sessionId: sessionId,
          sessionType: sessionType,
          sessionName: sessionName,
        ),);

  /// Load session items via Repository
  Future<void> loadSessionItems() async {
    if (state.isLoading) return;

    state = state.copyWith(isLoading: true, error: null);

    try {
      final appState = _ref.read(appStateProvider);
      final userId = appState.user['user_id']?.toString() ?? '';

      if (userId.isEmpty) {
        state = state.copyWith(
          isLoading: false,
          error: 'User not found',
        );
        return;
      }

      final repository = _ref.read(sessionRepositoryProvider);
      final response = await repository.getSessionReviewItems(
        sessionId: state.sessionId,
        userId: userId,
      );

      state = state.copyWith(
        items: response.items,
        summary: response.summary,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Refresh session items
  Future<void> refresh() async {
    state = state.copyWith(items: [], summary: null);
    await loadSessionItems();
  }

  /// Submit session with confirmed items
  /// Returns success status and optional error message
  Future<({bool success, String? error, SessionSubmitResponse? data})>
      submitSession({
    bool isFinal = false,
    String? notes,
  }) async {
    if (state.items.isEmpty) {
      return (success: false, error: 'No items to submit', data: null);
    }

    state = state.copyWith(isSubmitting: true, error: null);

    try {
      final appState = _ref.read(appStateProvider);
      final userId = appState.user['user_id']?.toString() ?? '';

      if (userId.isEmpty) {
        state = state.copyWith(isSubmitting: false, error: 'User not found');
        return (success: false, error: 'User not found', data: null);
      }

      // Convert state items to submit items
      final submitItems = state.items
          .map((item) => SessionSubmitItem(
                productId: item.productId,
                quantity: item.totalQuantity,
                quantityRejected: item.totalRejected,
              ))
          .toList();

      final repository = _ref.read(sessionRepositoryProvider);
      final response = await repository.submitSession(
        sessionId: state.sessionId,
        userId: userId,
        items: submitItems,
        isFinal: isFinal,
        notes: notes,
      );

      state = state.copyWith(isSubmitting: false);
      return (success: true, error: null, data: response);
    } catch (e) {
      final errorMsg = e.toString();
      state = state.copyWith(isSubmitting: false, error: errorMsg);
      return (success: false, error: errorMsg, data: null);
    }
  }
}

/// Provider parameters record
typedef SessionReviewParams = ({
  String sessionId,
  String sessionType,
  String? sessionName,
});

/// Provider for session review
final sessionReviewProvider = StateNotifierProvider.autoDispose
    .family<SessionReviewNotifier, SessionReviewState, SessionReviewParams>(
        (ref, params) {
  final notifier = SessionReviewNotifier(
    ref: ref,
    sessionId: params.sessionId,
    sessionType: params.sessionType,
    sessionName: params.sessionName,
  );

  // Auto-load on creation
  notifier.loadSessionItems();

  return notifier;
});
