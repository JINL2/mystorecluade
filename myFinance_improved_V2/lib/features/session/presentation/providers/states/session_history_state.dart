import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/entities/session_history_item.dart';
import 'session_history_filter_state.dart';

part 'session_history_state.freezed.dart';

/// State for session history
@freezed
class SessionHistoryState with _$SessionHistoryState {
  const SessionHistoryState._();

  static const int pageSize = 15;

  const factory SessionHistoryState({
    @Default([]) List<SessionHistoryItem> sessions,
    @Default(false) bool isLoading,
    @Default(false) bool isLoadingMore,
    String? error,
    @Default(0) int totalCount,
    @Default(false) bool hasMore,
    @Default(0) int currentOffset,
    required SessionHistoryFilterState filter,
  }) = _SessionHistoryState;

  factory SessionHistoryState.initial() {
    return SessionHistoryState(
      filter: SessionHistoryFilterState.initial(),
    );
  }

  bool get hasError => error != null;
  bool get isEmpty => sessions.isEmpty && !isLoading;
}
