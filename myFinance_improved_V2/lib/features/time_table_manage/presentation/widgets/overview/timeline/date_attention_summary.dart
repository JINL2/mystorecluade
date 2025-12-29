import '../attention_card.dart';

/// Summary of attention items for a single date
class DateAttentionSummary {
  final DateTime date;
  final int scheduleCount; // Schedule issues (shift-level: empty or understaffed)
  final int problemCount; // Red dots (staff-level problems)
  final List<AttentionItemData> items;

  const DateAttentionSummary({
    required this.date,
    required this.scheduleCount,
    required this.problemCount,
    required this.items,
  });

  /// Total count of all attention items
  int get totalCount => scheduleCount + problemCount;

  /// Check if this date has any attention items
  bool get hasItems => totalCount > 0;
}
