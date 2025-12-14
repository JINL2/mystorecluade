// Shared Widget: Calendar Time Range Picker
// A calendar-based component for selecting date ranges

import 'package:flutter/material.dart';

import '../../themes/toss_border_radius.dart';
import '../../themes/toss_colors.dart';
import '../../themes/toss_spacing.dart';
import '../../themes/toss_text_styles.dart';

/// Date range model
class DateRange {
  final DateTime start;
  final DateTime end;

  const DateRange({
    required this.start,
    required this.end,
  });

  @override
  String toString() {
    return '${_formatDate(start)} - ${_formatDate(end)}';
  }

  String toShortString() {
    if (_isSameDay(start, end)) {
      return _formatDateShort(start);
    }
    return '${_formatDateShort(start)} - ${_formatDateShort(end)}';
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  String _formatDateShort(DateTime date) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${months[date.month - 1]} ${date.day}';
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}

/// Calendar Time Range Picker Bottom Sheet
class CalendarTimeRange extends StatefulWidget {
  final DateRange? initialRange;
  final void Function(DateRange? range) onRangeSelected;

  const CalendarTimeRange({
    super.key,
    this.initialRange,
    required this.onRangeSelected,
  });

  /// Show the date range picker as a bottom sheet
  static Future<void> show({
    required BuildContext context,
    DateRange? initialRange,
    required void Function(DateRange? range) onRangeSelected,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      backgroundColor: TossColors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(TossBorderRadius.bottomSheet),
        ),
      ),
      builder: (context) => CalendarTimeRange(
        initialRange: initialRange,
        onRangeSelected: onRangeSelected,
      ),
    );
  }

  @override
  State<CalendarTimeRange> createState() => _CalendarTimeRangeState();
}

class _CalendarTimeRangeState extends State<CalendarTimeRange> {
  late DateTime _currentMonth;
  DateTime? _startDate;
  DateTime? _endDate;
  bool _selectingEndDate = false;

  final List<String> _weekDays = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];
  final List<String> _monthNames = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December',
  ];

  @override
  void initState() {
    super.initState();

    if (widget.initialRange != null) {
      _startDate = widget.initialRange!.start;
      _endDate = widget.initialRange!.end;
      // Show the month of the start date when reopening with a selection
      _currentMonth = DateTime(_startDate!.year, _startDate!.month, 1);
    } else {
      // Default to current month when no selection
      final now = DateTime.now();
      _currentMonth = DateTime(now.year, now.month, 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return SafeArea(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: screenHeight * 0.75,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            const SizedBox(height: TossSpacing.space2),
            Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: TossColors.gray300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: TossSpacing.space4),
            // Title row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Select Date Range',
                    style: TossTextStyles.titleLarge.copyWith(
                      color: TossColors.gray900,
                    ),
                  ),
                  if (widget.initialRange != null || _startDate != null)
                    GestureDetector(
                      onTap: () {
                        // Clear the selection and close the picker with null
                        Navigator.pop(context);
                        widget.onRangeSelected(null);
                      },
                      child: Text(
                        'Clear',
                        style: TossTextStyles.body.copyWith(
                          color: TossColors.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: TossSpacing.space3),
            // Selected date range display
            _buildSelectedRangeDisplay(),
            const SizedBox(height: TossSpacing.space3),
            // Month navigation
            _buildMonthNavigation(),
            const SizedBox(height: TossSpacing.space2),
            // Weekday headers
            _buildWeekdayHeaders(),
            // Calendar grid
            _buildCalendarGrid(),
            const SizedBox(height: TossSpacing.space4),
            // Action buttons
            _buildActionButtons(),
            const SizedBox(height: TossSpacing.space4),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectedRangeDisplay() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space4),
      child: Row(
        children: [
          // Start date
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectingEndDate = false;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: TossSpacing.space2,
                  vertical: TossSpacing.space2,
                ),
                decoration: BoxDecoration(
                  color: TossColors.transparent,
                  borderRadius: BorderRadius.circular(6),
                  border: !_selectingEndDate
                      ? Border.all(color: TossColors.primary, width: 1)
                      : null,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'From',
                      style: TossTextStyles.caption.copyWith(
                        color: TossColors.gray500,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _startDate != null ? _formatDateDisplay(_startDate!) : 'Select',
                      style: TossTextStyles.body.copyWith(
                        color: _startDate != null ? TossColors.gray900 : TossColors.gray400,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Arrow
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space2),
            child: Icon(
              Icons.arrow_forward,
              size: 16,
              color: TossColors.gray400,
            ),
          ),
          // End date
          Expanded(
            child: GestureDetector(
              onTap: () {
                if (_startDate != null) {
                  setState(() {
                    _selectingEndDate = true;
                  });
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: TossSpacing.space2,
                  vertical: TossSpacing.space2,
                ),
                decoration: BoxDecoration(
                  color: TossColors.transparent,
                  borderRadius: BorderRadius.circular(6),
                  border: _selectingEndDate
                      ? Border.all(color: TossColors.primary, width: 1)
                      : null,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'To',
                      style: TossTextStyles.caption.copyWith(
                        color: TossColors.gray500,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _endDate != null ? _formatDateDisplay(_endDate!) : 'Select',
                      style: TossTextStyles.body.copyWith(
                        color: _endDate != null ? TossColors.gray900 : TossColors.gray400,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMonthNavigation() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Previous month button
          GestureDetector(
            onTap: () {
              setState(() {
                _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1, 1);
              });
            },
            child: const SizedBox(
              width: 32,
              height: 32,
              child: Icon(
                Icons.chevron_left,
                size: 24,
                color: TossColors.gray700,
              ),
            ),
          ),
          // Month and year
          Text(
            '${_monthNames[_currentMonth.month - 1]} ${_currentMonth.year}',
            style: TossTextStyles.titleMedium.copyWith(
              fontWeight: FontWeight.w600,
              color: TossColors.gray900,
            ),
          ),
          // Next month button
          GestureDetector(
            onTap: () {
              final now = DateTime.now();
              final nextMonth = DateTime(_currentMonth.year, _currentMonth.month + 1, 1);
              if (!nextMonth.isAfter(DateTime(now.year, now.month + 1, 1))) {
                setState(() {
                  _currentMonth = nextMonth;
                });
              }
            },
            child: SizedBox(
              width: 32,
              height: 32,
              child: Icon(
                Icons.chevron_right,
                size: 24,
                color: _canGoNextMonth() ? TossColors.gray700 : TossColors.gray300,
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool _canGoNextMonth() {
    final now = DateTime.now();
    final nextMonth = DateTime(_currentMonth.year, _currentMonth.month + 1, 1);
    return !nextMonth.isAfter(DateTime(now.year, now.month + 1, 1));
  }

  Widget _buildWeekdayHeaders() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space4),
      child: Row(
        children: _weekDays.map((day) {
          return Expanded(
            child: Center(
              child: Text(
                day,
                style: TossTextStyles.caption.copyWith(
                  color: TossColors.gray500,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildCalendarGrid() {
    final daysInMonth = _getDaysInMonth(_currentMonth.year, _currentMonth.month);
    final firstDayOfWeek = DateTime(_currentMonth.year, _currentMonth.month, 1).weekday % 7;
    final today = DateTime.now();

    final totalCells = ((firstDayOfWeek + daysInMonth) / 7).ceil() * 7;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space4),
      child: Column(
        children: List.generate(
          (totalCells / 7).ceil(),
          (weekIndex) {
            return Row(
              children: List.generate(7, (dayIndex) {
                final cellIndex = weekIndex * 7 + dayIndex;
                final dayNumber = cellIndex - firstDayOfWeek + 1;

                if (dayNumber < 1 || dayNumber > daysInMonth) {
                  return Expanded(child: Container(height: 44));
                }

                final date = DateTime(_currentMonth.year, _currentMonth.month, dayNumber);
                final isToday = _isSameDay(date, today);
                final isFuture = date.isAfter(today);
                final isSelected = _isDateSelected(date);
                final isInRange = _isDateInRange(date);
                final isStartDate = _startDate != null && _isSameDay(date, _startDate!);
                final isEndDate = _endDate != null && _isSameDay(date, _endDate!);

                // Check if this date is part of the range (including start/end)
                final hasRange = _startDate != null && _endDate != null;
                final isInRangeOrSelected = isInRange || (isStartDate && hasRange) || (isEndDate && hasRange);

                return Expanded(
                  child: GestureDetector(
                    onTap: isFuture ? null : () => _onDateTap(date),
                    child: SizedBox(
                      height: 44,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Range background - extends to cover half of start/end date cells
                          if (isInRangeOrSelected)
                            Positioned.fill(
                              child: Row(
                                children: [
                                  // Left half - show background if not start date
                                  Expanded(
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(vertical: 2),
                                      color: isStartDate && !isEndDate
                                          ? TossColors.transparent
                                          : TossColors.primarySurface,
                                    ),
                                  ),
                                  // Right half - show background if not end date
                                  Expanded(
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(vertical: 2),
                                      color: isEndDate && !isStartDate
                                          ? TossColors.transparent
                                          : TossColors.primarySurface,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          // Circle for selected dates
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: isSelected ? TossColors.primary : TossColors.transparent,
                              shape: BoxShape.circle,
                              border: isToday && !isSelected
                                  ? Border.all(
                                      color: TossColors.primary,
                                      width: 1,
                                    )
                                  : null,
                            ),
                            child: Center(
                              child: Text(
                                '$dayNumber',
                                style: TossTextStyles.body.copyWith(
                                  color: isFuture
                                      ? TossColors.gray300
                                      : isSelected
                                          ? TossColors.white
                                          : isToday
                                              ? TossColors.primary
                                              : TossColors.gray900,
                                  fontWeight: isSelected || isToday
                                      ? FontWeight.w600
                                      : FontWeight.w400,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            );
          },
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    final canApply = _startDate != null && _endDate != null;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space4),
      child: Row(
        children: [
          // Cancel button
          Expanded(
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  color: TossColors.gray100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    'Cancel',
                    style: TossTextStyles.body.copyWith(
                      fontWeight: FontWeight.w600,
                      color: TossColors.gray700,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: TossSpacing.space3),
          // Apply button
          Expanded(
            child: GestureDetector(
              onTap: canApply ? _onApply : null,
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  color: canApply ? TossColors.primary : TossColors.gray300,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    'Apply',
                    style: TossTextStyles.body.copyWith(
                      fontWeight: FontWeight.w600,
                      color: TossColors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  int _getDaysInMonth(int year, int month) {
    return DateTime(year, month + 1, 0).day;
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  bool _isDateSelected(DateTime date) {
    if (_startDate != null && _isSameDay(date, _startDate!)) return true;
    if (_endDate != null && _isSameDay(date, _endDate!)) return true;
    return false;
  }

  bool _isDateInRange(DateTime date) {
    if (_startDate == null || _endDate == null) return false;
    return date.isAfter(_startDate!) && date.isBefore(_endDate!);
  }

  void _onDateTap(DateTime date) {
    setState(() {
      if (!_selectingEndDate) {
        // Selecting start date
        _startDate = date;
        _endDate = null;
        _selectingEndDate = true;
      } else {
        // Selecting end date
        if (date.isBefore(_startDate!)) {
          // If selected date is before start, swap them
          _endDate = _startDate;
          _startDate = date;
        } else {
          _endDate = date;
        }
        _selectingEndDate = false;
      }
    });
  }

  String _formatDateDisplay(DateTime date) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  void _onApply() {
    if (_startDate == null || _endDate == null) return;

    Navigator.pop(context);
    widget.onRangeSelected(DateRange(start: _startDate!, end: _endDate!));
  }
}
