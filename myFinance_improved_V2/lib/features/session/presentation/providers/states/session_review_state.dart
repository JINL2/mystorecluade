import '../../../domain/entities/session_review_item.dart';

// Re-export domain entities for convenience
export '../../../domain/entities/session_review_item.dart';

/// State for session review page
class SessionReviewState {
  final String sessionId;
  final String sessionType;
  final String? sessionName;
  final List<SessionReviewItem> items;
  final SessionReviewSummary? summary;
  final bool isLoading;
  final bool isSubmitting;
  final String? error;

  const SessionReviewState({
    required this.sessionId,
    required this.sessionType,
    this.sessionName,
    this.items = const [],
    this.summary,
    this.isLoading = false,
    this.isSubmitting = false,
    this.error,
  });

  factory SessionReviewState.initial({
    required String sessionId,
    required String sessionType,
    String? sessionName,
  }) {
    return SessionReviewState(
      sessionId: sessionId,
      sessionType: sessionType,
      sessionName: sessionName,
    );
  }

  SessionReviewState copyWith({
    String? sessionId,
    String? sessionType,
    String? sessionName,
    List<SessionReviewItem>? items,
    SessionReviewSummary? summary,
    bool? isLoading,
    bool? isSubmitting,
    String? error,
  }) {
    return SessionReviewState(
      sessionId: sessionId ?? this.sessionId,
      sessionType: sessionType ?? this.sessionType,
      sessionName: sessionName ?? this.sessionName,
      items: items ?? this.items,
      summary: summary ?? this.summary,
      isLoading: isLoading ?? this.isLoading,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      error: error,
    );
  }

  bool get hasItems => items.isNotEmpty;
  bool get hasError => error != null;
}
