import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/entities/session_list_item.dart';

part 'session_list_state.freezed.dart';

/// State for session list
@freezed
class SessionListState with _$SessionListState {
  const SessionListState._();

  const factory SessionListState({
    @Default([]) List<SessionListItem> sessions,
    @Default(false) bool isLoading,
    String? error,
    required String sessionType,
    @Default(0) int totalCount,
    @Default(false) bool hasMore,
  }) = _SessionListState;

  factory SessionListState.initial(String sessionType) {
    return SessionListState(sessionType: sessionType);
  }

  bool get hasError => error != null;
  bool get isEmpty => sessions.isEmpty && !isLoading;
}
