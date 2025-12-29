import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../app/providers/app_state_provider.dart';
import '../../di/session_providers.dart';
import 'states/session_list_state.dart';

part 'session_list_provider.g.dart';

/// Notifier for session list state management
/// Migrated to @riverpod from StateNotifier (2025 Best Practice)
@riverpod
class SessionListNotifier extends _$SessionListNotifier {
  @override
  SessionListState build(String sessionType) {
    // Auto-load on creation
    Future.microtask(loadSessions);
    return SessionListState.initial(sessionType);
  }

  /// Load sessions via UseCase
  Future<void> loadSessions() async {
    if (state.isLoading) return;

    state = state.copyWith(isLoading: true, error: null);

    try {
      final appState = ref.read(appStateProvider);
      final companyId = appState.companyChoosen;
      final getSessionList = ref.read(getSessionListUseCaseProvider);

      // For 'join' type, get all active sessions (no type filter)
      // For 'counting' or 'receiving', filter by type
      final String? typeFilter =
          state.sessionType == 'join' ? null : state.sessionType;

      final response = await getSessionList(
        companyId: companyId,
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
