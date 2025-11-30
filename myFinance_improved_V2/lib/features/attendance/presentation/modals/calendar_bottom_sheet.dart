import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../shared/themes/toss_border_radius.dart';
import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_spacing.dart';
import '../../../../shared/themes/toss_text_styles.dart';
import '../../domain/entities/shift_card.dart';
import '../widgets/calendar_helpers.dart';


/// Calendar bottom sheet for date selection
///
/// ✅ Clean Architecture: Uses ShiftCard Entity instead of Map<String, dynamic>
class CalendarBottomSheet extends StatefulWidget {
  final DateTime initialSelectedDate;
  final DateTime initialFocusedDate;
  /// ✅ Clean Architecture: Use ShiftCard Entity list instead of Map list
  final List<ShiftCard> shiftCards;
  final Future<void> Function(DateTime) onFetchMonthData;
  final void Function(DateTime) onNavigateToDate;
  final VoidCallback parentSetState;

  const CalendarBottomSheet({
    super.key,
    required this.initialSelectedDate,
    required this.initialFocusedDate,
    required this.shiftCards,
    required this.onFetchMonthData,
    required this.onNavigateToDate,
    required this.parentSetState,
  });

  @override
  State<CalendarBottomSheet> createState() => _CalendarBottomSheetState();
}

class _CalendarBottomSheetState extends State<CalendarBottomSheet> {
  late DateTime selectedDate;
  late DateTime focusedDate;
  List<ShiftCard> localShiftData = [];

  @override
  void initState() {
    super.initState();
    selectedDate = widget.initialSelectedDate;
    focusedDate = widget.initialFocusedDate;
    localShiftData = List<ShiftCard>.from(widget.shiftCards);
  }

  @override
  void didUpdateWidget(CalendarBottomSheet oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update local shift data when parent data changes
    if (widget.shiftCards != oldWidget.shiftCards) {
      setState(() {
        localShiftData = List<ShiftCard>.from(widget.shiftCards);
      });
    }
  }

  void _updateFocusedMonth(DateTime newDate) async {
    // Update the focused date for calendar display
    setState(() {
      focusedDate = newDate;
    });

    // Fetch data for the new month if not already loaded
    await widget.onFetchMonthData(newDate);

    // Update parent state to reflect the new data
    widget.parentSetState();
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
          // Handle
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
                  'Select Date',
                  style: TossTextStyles.h2.copyWith(
                    color: TossColors.gray900,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(
                    Icons.close,
                    color: TossColors.gray600,
                  ),
                ),
              ],
            ),
          ),

          // Calendar
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: TossSpacing.space5),
              decoration: BoxDecoration(
                color: TossColors.surface,
                borderRadius: BorderRadius.circular(TossBorderRadius.xl),
                boxShadow: [
                  BoxShadow(
                    color: TossColors.black.withValues(alpha: 0.01),
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Month Year Header
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: TossSpacing.space4,
                      vertical: TossSpacing.space3,
                    ),
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: TossColors.gray100,
                          width: 1,
                        ),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () {
                            final newDate = DateTime(
                              focusedDate.year,
                              focusedDate.month - 1,
                              1,
                            );
                            _updateFocusedMonth(newDate);
                          },
                          icon: const Icon(
                            Icons.chevron_left,
                            color: TossColors.gray700,
                          ),
                        ),
                        Text(
                          '${CalendarHelpers.getMonthName(focusedDate.month)} ${focusedDate.year}',
                          style: TossTextStyles.bodyLarge.copyWith(
                            color: TossColors.gray900,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            final newDate = DateTime(
                              focusedDate.year,
                              focusedDate.month + 1,
                              1,
                            );
                            _updateFocusedMonth(newDate);
                          },
                          icon: const Icon(
                            Icons.chevron_right,
                            color: TossColors.gray700,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Calendar Grid - Use widget's shift data which gets updated via props
                  // ✅ Clean Architecture: Pass ShiftCard Entity list
                  Expanded(
                    child: CalendarHelpers.buildCalendarGrid(
                      focusedDate,
                      selectedDate,
                      (DateTime date) {
                        setState(() {
                          selectedDate = date;
                        });
                        HapticFeedback.selectionClick();

                        // Close the modal
                        Navigator.pop(context);

                        // Navigate to the date (this will check if month changed and fetch if needed)
                        widget.onNavigateToDate(date);
                      },
                      widget.shiftCards,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Selected Date Info
          Container(
            margin: const EdgeInsets.all(TossSpacing.space5),
            padding: const EdgeInsets.all(TossSpacing.space4),
            decoration: BoxDecoration(
              color: TossColors.primary.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(TossBorderRadius.lg),
              border: Border.all(
                color: TossColors.primary.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(TossSpacing.space2),
                    decoration: BoxDecoration(
                      color: TossColors.primary.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(TossBorderRadius.md),
                    ),
                    child: const Icon(
                      Icons.event,
                      size: 20,
                      color: TossColors.primary,
                    ),
                  ),
                  const SizedBox(width: TossSpacing.space3),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Selected Date',
                          style: TossTextStyles.caption.copyWith(
                            color: TossColors.gray600,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${selectedDate.day} ${CalendarHelpers.getMonthName(selectedDate.month)} ${selectedDate.year}',
                          style: TossTextStyles.body.copyWith(
                            color: TossColors.gray900,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
