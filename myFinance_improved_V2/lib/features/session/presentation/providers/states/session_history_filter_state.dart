/// Date range type for session history filter
enum DateRangeType {
  thisMonth,
  lastMonth,
  thisYear,
  custom,
}

/// Filter state for session history
class SessionHistoryFilterState {
  /// Selected store ID (single-select, null means all stores)
  final String? selectedStoreId;

  /// Date range type
  final DateRangeType dateRangeType;

  /// Custom start date (only used when dateRangeType is custom)
  final DateTime? customStartDate;

  /// Custom end date (only used when dateRangeType is custom)
  final DateTime? customEndDate;

  /// Filter by active status (null means all)
  final bool? isActive;

  /// Filter by session type (null means all, 'counting' or 'receiving')
  final String? sessionType;

  const SessionHistoryFilterState({
    this.selectedStoreId,
    this.dateRangeType = DateRangeType.thisMonth,
    this.customStartDate,
    this.customEndDate,
    this.isActive,
    this.sessionType,
  });

  factory SessionHistoryFilterState.initial() {
    return const SessionHistoryFilterState();
  }

  SessionHistoryFilterState copyWith({
    String? selectedStoreId,
    DateRangeType? dateRangeType,
    DateTime? customStartDate,
    DateTime? customEndDate,
    bool? isActive,
    String? sessionType,
    bool clearSelectedStoreId = false,
    bool clearIsActive = false,
    bool clearSessionType = false,
    bool clearCustomStartDate = false,
    bool clearCustomEndDate = false,
  }) {
    return SessionHistoryFilterState(
      selectedStoreId:
          clearSelectedStoreId ? null : (selectedStoreId ?? this.selectedStoreId),
      dateRangeType: dateRangeType ?? this.dateRangeType,
      customStartDate:
          clearCustomStartDate ? null : (customStartDate ?? this.customStartDate),
      customEndDate:
          clearCustomEndDate ? null : (customEndDate ?? this.customEndDate),
      isActive: clearIsActive ? null : (isActive ?? this.isActive),
      sessionType:
          clearSessionType ? null : (sessionType ?? this.sessionType),
    );
  }

  /// Get the actual date range based on dateRangeType
  ({DateTime start, DateTime end}) getDateRange() {
    final now = DateTime.now();

    switch (dateRangeType) {
      case DateRangeType.thisMonth:
        final start = DateTime(now.year, now.month, 1);
        final end = DateTime(now.year, now.month + 1, 0, 23, 59, 59);
        return (start: start, end: end);

      case DateRangeType.lastMonth:
        final start = DateTime(now.year, now.month - 1, 1);
        final end = DateTime(now.year, now.month, 0, 23, 59, 59);
        return (start: start, end: end);

      case DateRangeType.thisYear:
        final start = DateTime(now.year, 1, 1);
        final end = DateTime(now.year, 12, 31, 23, 59, 59);
        return (start: start, end: end);

      case DateRangeType.custom:
        final start = customStartDate ?? DateTime(now.year, now.month, 1);
        final end = customEndDate ?? DateTime(now.year, now.month + 1, 0, 23, 59, 59);
        return (start: start, end: end);
    }
  }

  /// Check if any filter is applied
  bool get hasActiveFilters {
    return selectedStoreId != null ||
        dateRangeType != DateRangeType.thisMonth ||
        isActive != null ||
        sessionType != null;
  }

  /// Get active filter count
  int get activeFilterCount {
    int count = 0;
    if (selectedStoreId != null) count++;
    if (dateRangeType != DateRangeType.thisMonth) count++;
    if (isActive != null) count++;
    if (sessionType != null) count++;
    return count;
  }

  /// Get date range display text
  String get dateRangeDisplayText {
    switch (dateRangeType) {
      case DateRangeType.thisMonth:
        return 'This Month';
      case DateRangeType.lastMonth:
        return 'Last Month';
      case DateRangeType.thisYear:
        return 'This Year';
      case DateRangeType.custom:
        if (customStartDate != null && customEndDate != null) {
          return '${_formatDate(customStartDate!)} - ${_formatDate(customEndDate!)}';
        }
        return 'Custom';
    }
  }

  String _formatDate(DateTime date) {
    return '${date.year}/${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}';
  }
}
