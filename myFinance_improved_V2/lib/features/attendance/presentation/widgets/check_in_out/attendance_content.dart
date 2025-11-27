import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';
import '../../modals/calendar_bottom_sheet.dart';
import 'controllers/attendance_content_controller.dart';
import 'dialogs/activity_details_sheet.dart';
import 'dialogs/all_attendance_history_sheet.dart';
import 'utils/attendance_status_helper.dart';
import 'widgets/attendance_hero_section.dart';
import 'widgets/attendance_qr_button.dart';
import 'widgets/attendance_recent_activity.dart';
import 'widgets/attendance_week_schedule.dart';

class AttendanceContent extends ConsumerStatefulWidget {
  const AttendanceContent({super.key});

  @override
  ConsumerState<AttendanceContent> createState() => _AttendanceContentState();
}

class _AttendanceContentState extends ConsumerState<AttendanceContent> {
  late AttendanceContentController controller;
  late DateTime selectedDate;
  late DateTime centerDate;
  final ScrollController _weekScrollController = ScrollController();

  bool isLoading = true;
  String? errorMessage;
  String shiftStatus = 'off_duty';

  @override
  void initState() {
    super.initState();
    controller = AttendanceContentController(ref);

    final testDate = DateTime.now();
    selectedDate = testDate;
    centerDate = testDate;

    _fetchMonthData(testDate);
  }

  @override
  void dispose() {
    _weekScrollController.dispose();
    super.dispose();
  }

  Future<void> _fetchMonthData(DateTime targetDate, {bool forceRefresh = false}) async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    final result = await controller.fetchMonthData(targetDate, forceRefresh: forceRefresh);

    setState(() {
      isLoading = false;
      if (result['success'] == true) {
        shiftStatus = (result['shiftStatus'] as String?) ?? 'off_duty';
      } else {
        errorMessage = result['error'] as String?;
      }
    });
  }

  void _updateCenterDate(DateTime newCenterDate) {
    final newMonthKey = '${newCenterDate.year}-${newCenterDate.month.toString().padLeft(2, '0')}';
    final currentMonthKey = controller.currentDisplayedMonth;

    setState(() {
      centerDate = newCenterDate;
      selectedDate = newCenterDate;
    });

    if (newMonthKey != currentMonthKey) {
      _fetchMonthData(newCenterDate);
    }
  }

  void _navigateToDate(DateTime date) {
    setState(() {
      selectedDate = date;
    });
    _updateCenterDate(date);
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        controller.clearCaches();
        await _fetchMonthData(centerDate);
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            // Hero Section
            AttendanceHeroSection(
              isLoading: isLoading,
              errorMessage: errorMessage,
              shiftOverviewData: controller.shiftOverviewData,
              allShiftCardsData: controller.allShiftCardsData,
              currentDisplayedMonth: controller.currentDisplayedMonth,
              shiftStatus: shiftStatus,
              getStatusColor: AttendanceStatusHelper.getStatusColor,
              getStatusText: AttendanceStatusHelper.getStatusText,
            ),

            const SizedBox(height: TossSpacing.space4),

            // QR Scan Button
            AttendanceQRButton(
              onScanResult: (result) {
                controller.updateLocalStateAfterQRScan(result);
                if (mounted) {
                  setState(() {});
                }
              },
            ),

            const SizedBox(height: TossSpacing.space4),

            // Week Schedule
            AttendanceWeekSchedule(
              selectedDate: selectedDate,
              allShiftCardsData: controller.allShiftCardsData,
              onDateSelected: (date) async {
                final currentMonth = selectedDate.month;
                final currentYear = selectedDate.year;
                final newMonth = date.month;
                final newYear = date.year;

                setState(() {
                  selectedDate = date;
                  centerDate = date;
                });

                if (currentMonth != newMonth || currentYear != newYear) {
                  await _fetchMonthData(date);
                }
              },
              onCalendarTap: _showCalendarBottomSheet,
            ),

            const SizedBox(height: TossSpacing.space4),

            // Recent Activity
            AttendanceRecentActivity(
              selectedDate: selectedDate,
              allShiftCardsData: controller.allShiftCardsData,
              onActivityTap: _showActivityDetails,
              onViewAllTap: _showAllAttendanceHistory,
              getActivityStatusColor: AttendanceStatusHelper.getActivityStatusColor,
              getActivityStatusText: AttendanceStatusHelper.getActivityStatusText,
            ),

            const SizedBox(height: TossSpacing.space8),
          ],
        ),
      ),
    );
  }

  void _showAllAttendanceHistory() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: TossColors.transparent,
      builder: (context) => AllAttendanceHistorySheet(
        allShiftCardsData: controller.allShiftCardsData,
        onActivityTap: _showActivityDetails,
      ),
    );
  }

  void _showActivityDetails(Map<String, dynamic> activity) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: TossColors.transparent,
      isScrollControlled: true,
      builder: (context) => ActivityDetailsSheet(
        activity: activity,
        shiftOverviewData: controller.shiftOverviewData,
        onReportSubmitted: () {
          _fetchMonthData(selectedDate);
        },
      ),
    );
  }

  void _showCalendarBottomSheet() {
    DateTime modalSelectedDate = selectedDate;
    DateTime modalFocusedDate = selectedDate;
    List<Map<String, dynamic>> modalShiftData = List.from(controller.allShiftCardsData);

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: TossColors.transparent,
      builder: (modalContext) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return CalendarBottomSheet(
              initialSelectedDate: modalSelectedDate,
              initialFocusedDate: modalFocusedDate,
              allShiftCardsData: modalShiftData,
              onFetchMonthData: (DateTime date) async {
                await _fetchMonthData(date);
                setModalState(() {
                  modalShiftData = List.from(controller.allShiftCardsData);
                });
              },
              onNavigateToDate: (DateTime date) {
                _navigateToDate(date);
                setModalState(() {
                  modalSelectedDate = date;
                  modalFocusedDate = date;
                  modalShiftData = List.from(controller.allShiftCardsData);
                });
              },
              parentSetState: () {
                if (mounted) {
                  setState(() {});
                  setModalState(() {
                    modalShiftData = List.from(controller.allShiftCardsData);
                  });
                }
              },
            );
          },
        );
      },
    );
  }

  // Static calendar grid builder (kept for compatibility)
  // ignore: unused_element
  static Widget buildCalendarGridStatic(
    DateTime focusedDate,
    DateTime selectedDate,
    void Function(DateTime) onDateSelected, [
    List<Map<String, dynamic>>? shiftCardsData,
  ]) {
    final shiftsData = shiftCardsData ?? [];
    final firstDayOfMonth = DateTime(focusedDate.year, focusedDate.month, 1);
    final lastDayOfMonth = DateTime(focusedDate.year, focusedDate.month + 1, 0);
    final daysInMonth = lastDayOfMonth.day;
    final firstWeekday = firstDayOfMonth.weekday;

    List<Widget> calendarDays = [];

    // Week day headers
    const weekDays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    for (final day in weekDays) {
      calendarDays.add(
        Center(
          child: Text(
            day,
            style: TossTextStyles.caption.copyWith(
              color: TossColors.gray600,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      );
    }

    // Empty cells before first day
    for (int i = 1; i < firstWeekday; i++) {
      calendarDays.add(const SizedBox());
    }

    // Days of month
    for (int day = 1; day <= daysInMonth; day++) {
      final date = DateTime(focusedDate.year, focusedDate.month, day);
      final isSelected = selectedDate.year == date.year &&
          selectedDate.month == date.month &&
          selectedDate.day == date.day;
      final isToday = DateTime.now().year == date.year &&
          DateTime.now().month == date.month &&
          DateTime.now().day == date.day;

      final dateStr = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
      final shiftsForDate = shiftsData.where((card) => card['request_date'] == dateStr).toList();
      final hasShift = shiftsForDate.isNotEmpty;

      final hasApprovedShift = hasShift &&
          shiftsForDate.any((card) {
            final isApproved = card['is_approved'] ?? card['approval_status'] == 'approved' ?? false;
            return isApproved == true;
          });

      final hasNonApprovedShift = hasShift &&
          shiftsForDate.any((card) {
            final isApproved = card['is_approved'] ?? card['approval_status'] == 'approved' ?? false;
            return isApproved != true;
          });

      calendarDays.add(
        InkWell(
          onTap: () => onDateSelected(date),
          borderRadius: BorderRadius.circular(TossBorderRadius.md),
          child: Container(
            margin: const EdgeInsets.all(TossSpacing.space1 / 2),
            decoration: BoxDecoration(
              color: isSelected
                  ? TossColors.primary
                  : isToday
                      ? TossColors.primary.withOpacity(0.1)
                      : TossColors.transparent,
              borderRadius: BorderRadius.circular(TossBorderRadius.md),
              border: Border.all(
                color: isToday && !isSelected ? TossColors.primary : TossColors.transparent,
                width: 1,
              ),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Center(
                  child: Text(
                    day.toString(),
                    style: TossTextStyles.body.copyWith(
                      color: isSelected ? TossColors.white : TossColors.gray900,
                      fontWeight: isSelected || isToday ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                ),
                if (hasShift)
                  Positioned(
                    bottom: 4,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (hasApprovedShift)
                          Container(
                            width: 4,
                            height: 4,
                            decoration: BoxDecoration(
                              color: isSelected ? TossColors.white : TossColors.success,
                              shape: BoxShape.circle,
                            ),
                          ),
                        if (hasApprovedShift && hasNonApprovedShift) const SizedBox(width: 2),
                        if (hasNonApprovedShift)
                          Container(
                            width: 4,
                            height: 4,
                            decoration: BoxDecoration(
                              color: isSelected ? TossColors.white : TossColors.warning,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(TossSpacing.space4),
      child: GridView.count(
        crossAxisCount: 7,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: calendarDays,
      ),
    );
  }
}
