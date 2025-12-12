import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/providers/app_state_provider.dart';
import '../../di/session_providers.dart';
import '../../domain/usecases/get_session_review_items.dart';
import '../../domain/usecases/submit_session.dart';
import 'states/session_review_state.dart';

/// Notifier for session review state management
class SessionReviewNotifier extends StateNotifier<SessionReviewState> {
  final Ref _ref;
  final GetSessionReviewItems _getSessionReviewItems;
  final SubmitSession _submitSession;

  SessionReviewNotifier({
    required Ref ref,
    required GetSessionReviewItems getSessionReviewItems,
    required SubmitSession submitSession,
    required String sessionId,
    required String sessionType,
    String? sessionName,
  })  : _ref = ref,
        _getSessionReviewItems = getSessionReviewItems,
        _submitSession = submitSession,
        super(SessionReviewState.initial(
          sessionId: sessionId,
          sessionType: sessionType,
          sessionName: sessionName,
        ),);

  /// Load session items via UseCase
  Future<void> loadSessionItems() async {
    if (state.isLoading) return;

    state = state.copyWith(isLoading: true, error: null);

    try {
      final appState = _ref.read(appStateProvider);
      final userId = appState.userId;

      if (userId.isEmpty) {
        state = state.copyWith(
          isLoading: false,
          error: 'User not found',
        );
        return;
      }

      final response = await _getSessionReviewItems(
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
      final userId = appState.userId;

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
              ),)
          .toList();

      final response = await _submitSession(
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
  final getSessionReviewItems = ref.watch(getSessionReviewItemsUseCaseProvider);
  final submitSession = ref.watch(submitSessionUseCaseProvider);

  final notifier = SessionReviewNotifier(
    ref: ref,
    getSessionReviewItems: getSessionReviewItems,
    submitSession: submitSession,
    sessionId: params.sessionId,
    sessionType: params.sessionType,
    sessionName: params.sessionName,
  );

  // Auto-load on creation
  notifier.loadSessionItems();

  return notifier;
});
