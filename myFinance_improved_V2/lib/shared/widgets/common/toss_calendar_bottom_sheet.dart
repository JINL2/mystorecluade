import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myfinance_improved/shared/themes/toss_border_radius.dart';
import 'package:myfinance_improved/shared/themes/toss_colors.dart';
import 'package:myfinance_improved/shared/themes/toss_spacing.dart';
import 'package:myfinance_improved/shared/themes/toss_text_styles.dart';

/// Calendar indicator type for date status visualization
enum TossCalendarIndicatorType {
  problem,   // Red dot - Issues/Problems
  pending,   // Orange dot - Pending approval
  approved,  // Green dot - Approved
  info,      // Blue dot - Information
  none,      // Gray dot - Default/No status
}

/// Calendar bottom sheet matching Toss design system
/// Flexible calendar grid with customizable date indicators and callbacks
class TossCalendarBottomSheet {
  /// Show calendar bottom sheet
  ///
  /// [context] - Build context
  /// [initialDate] - Initially selected date (defaults to today)
  /// [displayMonth] - Month to display initially (defaults to initialDate's month)
  /// [title] - Bottom sheet title (defaults to 'Select Date')
  /// [onDateSelected] - Callback when date is selected (required)
  /// [onMonthChanged] - Optional callback when month changes (for data loading)
  /// [dateIndicators] - Map of date string (yyyy-MM-dd) to indicator type
  /// [onGetIndicators] - Optional callback to dynamically get indicators for a specific month
  /// [enableHaptic] - Enable haptic feedback on selection (defaults to true)
  /// [showTodayIndicator] - Show special indicator for today (defaults to true)
  static Future<DateTime?> show({
    required BuildContext context,
    DateTime? initialDate,
    DateTime? displayMonth,
    String title = 'Select Date',
    required Future<void> Function(DateTime date) onDateSelected,
    Future<void> Function(DateTime month)? onMonthChanged,
    Map<String, TossCalendarIndicatorType>? dateIndicators,
    Map<String, TossCalendarIndicatorType> Function(DateTime month)? onGetIndicators,
    bool enableHaptic = true,
    bool showTodayIndicator = true,
  }) async {
    DateTime? selectedDate;

    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: TossColors.transparent,
      isScrollControlled: true,
      builder: (context) => _TossCalendarBottomSheetContent(
        initialDate: initialDate ?? DateTime.now(),
        displayMonth: displayMonth ?? initialDate ?? DateTime.now(),
        title: title,
        onDateSelected: (date) async {
          selectedDate = date;
          await onDateSelected(date);
        },
        onMonthChanged: onMonthChanged,
        dateIndicators: dateIndicators ?? {},
        onGetIndicators: onGetIndicators,
        enableHaptic: enableHaptic,
        showTodayIndicator: showTodayIndicator,
      ),
    );

    return selectedDate;
  }
}

class _TossCalendarBottomSheetContent extends StatefulWidget {
  final DateTime initialDate;
  final DateTime displayMonth;
  final String title;
  final Future<void> Function(DateTime date) onDateSelected;
  final Future<void> Function(DateTime month)? onMonthChanged;
  final Map<String, TossCalendarIndicatorType> dateIndicators;
  final Map<String, TossCalendarIndicatorType> Function(DateTime month)? onGetIndicators;
  final bool enableHaptic;
  final bool showTodayIndicator;

  const _TossCalendarBottomSheetContent({
    required this.initialDate,
    required this.displayMonth,
    required this.title,
    required this.onDateSelected,
    this.onMonthChanged,
    required this.dateIndicators,
    this.onGetIndicators,
    required this.enableHaptic,
    required this.showTodayIndicator,
  });

  @override
  State<_TossCalendarBottomSheetContent> createState() => _TossCalendarBottomSheetContentState();
}

class _TossCalendarBottomSheetContentState extends State<_TossCalendarBottomSheetContent> {
  late DateTime _displayMonth;
  late DateTime _selectedDate;
  late Map<String, TossCalendarIndicatorType> _currentIndicators;

  @override
  void initState() {
    super.initState();
    _displayMonth = widget.displayMonth;
    _selectedDate = widget.initialDate;
    _currentIndicators = widget.onGetIndicators?.call(_displayMonth) ?? widget.dateIndicators;
  }

  String _getMonthName(int month) {
    const monthNames = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return monthNames[month - 1];
  }

  Future<void> _changeMonth(int delta) async {
    final newMonth = DateTime(_displayMonth.year, _displayMonth.month + delta);
    setState(() {
      _displayMonth = newMonth;
    });

    // Call onMonthChanged callback if provided
    if (widget.onMonthChanged != null) {
      await widget.onMonthChanged!(newMonth);
    }

    // Update indicators for the new month
    setState(() {
      _currentIndicators = widget.onGetIndicators?.call(newMonth) ?? widget.dateIndicators;
    });
  }

  Color _getIndicatorColor(TossCalendarIndicatorType type) {
    switch (type) {
      case TossCalendarIndicatorType.problem:
        return TossColors.error;
      case TossCalendarIndicatorType.pending:
        return TossColors.warning;
      case TossCalendarIndicatorType.approved:
        return TossColors.success;
      case TossCalendarIndicatorType.info:
        return TossColors.info;
      case TossCalendarIndicatorType.none:
        return TossColors.gray300;
    }
  }

  Widget _buildCalendarGrid() {
    final firstDay = DateTime(_displayMonth.year, _displayMonth.month, 1);
    final lastDay = DateTime(_displayMonth.year, _displayMonth.month + 1, 0);
    final daysInMonth = lastDay.day;
    final firstWeekday = firstDay.weekday;

    List<Widget> calendarDays = [];

    // Add day headers
    const dayHeaders = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    for (var header in dayHeaders) {
      calendarDays.add(
        Container(
          alignment: Alignment.center,
          child: Text(
            header,
            style: TossTextStyles.caption.copyWith(
              color: TossColors.gray500,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      );
    }

    // Add empty cells for days before month starts
    for (int i = 0; i < firstWeekday % 7; i++) {
      calendarDays.add(Container());
    }

    // Add days of the month
    final today = DateTime.now();
    for (int day = 1; day <= daysInMonth; day++) {
      final date = DateTime(_displayMonth.year, _displayMonth.month, day);
      final dateStr = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

      final isSelected = date.day == _selectedDate.day &&
                        date.month == _selectedDate.month &&
                        date.year == _selectedDate.year;
      final isToday = widget.showTodayIndicator &&
                      date.day == today.day &&
                      date.month == today.month &&
                      date.year == today.year;

      final indicatorType = _currentIndicators[dateStr] ?? TossCalendarIndicatorType.none;

      calendarDays.add(
        InkWell(
          onTap: () async {
            setState(() {
              _selectedDate = date;
            });
            Navigator.pop(context);
            if (widget.enableHaptic) {
              HapticFeedback.selectionClick();
            }
            await widget.onDateSelected(date);
          },
          borderRadius: BorderRadius.circular(TossBorderRadius.lg),
          child: Container(
            margin: const EdgeInsets.all(TossSpacing.space1 / 2),
            decoration: BoxDecoration(
              color: isSelected
                  ? TossColors.primary
                  : isToday
                      ? TossColors.primary.withValues(alpha: 0.1)
                      : TossColors.transparent,
              borderRadius: BorderRadius.circular(TossBorderRadius.lg),
              border: isToday && !isSelected
                  ? Border.all(color: TossColors.primary, width: 1)
                  : null,
            ),
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '$day',
                  style: TossTextStyles.body.copyWith(
                    color: isSelected
                        ? TossColors.white
                        : isToday
                            ? TossColors.primary
                            : TossColors.gray900,
                    fontWeight: isSelected || isToday ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
                // Show indicator dot below the date
                if (!isSelected) ...[
                  const SizedBox(height: 2),
                  Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: _getIndicatorColor(indicatorType),
                      shape: BoxShape.circle,
                    ),
                  ),
                ] else
                  const SizedBox(height: 8), // Keep spacing consistent
              ],
            ),
          ),
        ),
      );
    }

    return GridView.count(
      crossAxisCount: 7,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: calendarDays,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: const BoxDecoration(
        color: TossColors.background,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: TossSpacing.space3),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: TossColors.gray300,
              borderRadius: BorderRadius.circular(TossBorderRadius.full),
            ),
          ),

          // Title
          Padding(
            padding: const EdgeInsets.all(TossSpacing.space5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.title,
                  style: TossTextStyles.h3.copyWith(
                    color: TossColors.gray900,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close, color: TossColors.gray600),
                ),
              ],
            ),
          ),

          // Month/Year Navigation
          Container(
            padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () => _changeMonth(-1),
                  icon: const Icon(Icons.chevron_left, color: TossColors.gray700),
                ),
                Text(
                  '${_getMonthName(_displayMonth.month)} ${_displayMonth.year}',
                  style: TossTextStyles.body.copyWith(
                    color: TossColors.gray900,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                IconButton(
                  onPressed: () => _changeMonth(1),
                  icon: const Icon(Icons.chevron_right, color: TossColors.gray700),
                ),
              ],
            ),
          ),

          // Calendar Grid
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space5),
              child: _buildCalendarGrid(),
            ),
          ),
        ],
      ),
    );
  }
}
