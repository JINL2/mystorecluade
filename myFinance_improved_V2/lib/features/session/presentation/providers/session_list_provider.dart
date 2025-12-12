import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/providers/app_state_provider.dart';
import '../../di/session_providers.dart';
import '../../domain/entities/session_list_item.dart';
import '../../domain/usecases/get_session_list.dart';

/// State for session list
class SessionListState {
  final List<SessionListItem> sessions;
  final bool isLoading;
  final String? error;
  final String sessionType; // 'counting', 'receiving', 'join'
  final int totalCount;
  final bool hasMore;

  const SessionListState({
    this.sessions = const [],
    this.isLoading = false,
    this.error,
    required this.sessionType,
    this.totalCount = 0,
    this.hasMore = false,
  });

  factory SessionListState.initial(String sessionType) {
    return SessionListState(sessionType: sessionType);
  }

  SessionListState copyWith({
    List<SessionListItem>? sessions,
    bool? isLoading,
    String? error,
    String? sessionType,
    int? totalCount,
    bool? hasMore,
  }) {
    return SessionListState(
      sessions: sessions ?? this.sessions,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      sessionType: sessionType ?? this.sessionType,
      totalCount: totalCount ?? this.totalCount,
      hasMore: hasMore ?? this.hasMore,
    );
  }

  bool get hasError => error != null;
  bool get isEmpty => sessions.isEmpty && !isLoading;
}

/// Notifier for session list state management
class SessionListNotifier extends StateNotifier<SessionListState> {
  final GetSessionList _getSessionList;
  final String _companyId;

  SessionListNotifier({
    required GetSessionList getSessionList,
    required String companyId,
    required String sessionType,
  })  : _getSessionList = getSessionList,
        _companyId = companyId,
        super(SessionListState.initial(sessionType));

  /// Load sessions via UseCase
  Future<void> loadSessions() async {
    if (state.isLoading) return;

    state = state.copyWith(isLoading: true, error: null);

    try {
      // For 'join' type, get all active sessions (no type filter)
      // For 'counting' or 'receiving', filter by type
      final String? typeFilter =
          state.sessionType == 'join' ? null : state.sessionType;

      final response = await _getSessionList(
        companyId: _companyId,
        sessionType: typeFilter,
        isActive: true, // Only show active sessions
      );

      state = state.copyWith(
        sessions: response.sessions,
        isLoading: false,
        totalCount: response.totalCount,
        hasMore: response.hasMore,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Refresh sessions
  Future<void> refresh() async {
    state = state.copyWith(sessions: [], totalCount: 0, hasMore: false);
    await loadSessions();
  }
}

/// Provider for session list
final sessionListProvider = StateNotifierProvider.autoDispose
    .family<SessionListNotifier, SessionListState, String>((ref, sessionType) {
  final appState = ref.watch(appStateProvider);
  final companyId = appState.companyChoosen;
  final getSessionList = ref.watch(getSessionListUseCaseProvider);

  final notifier = SessionListNotifier(
    getSessionList: getSessionList,
    companyId: companyId,
    sessionType: sessionType,
  );

  // Auto-load on creation
  notifier.loadSessions();

  return notifier;
});
