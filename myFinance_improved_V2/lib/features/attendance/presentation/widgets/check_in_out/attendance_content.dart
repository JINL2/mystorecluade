// Refactored from 3,754 lines to ~550 lines
// All UI components extracted to separate files for better maintainability

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';
import '../../modals/calendar_bottom_sheet.dart';

// Extracted component imports
import './components/attendance_hero_section.dart';
import './components/attendance_qr_button.dart';
import './components/attendance_recent_activity.dart';
import './components/attendance_week_schedule.dart';
import './dialogs/report_issue_dialog.dart';
import './utils/attendance_data_manager.dart';

class AttendanceContent extends ConsumerStatefulWidget {
  const AttendanceContent({super.key});

  @override
  ConsumerState<AttendanceContent> createState() => _AttendanceContentState();
}

class _AttendanceContentState extends ConsumerState<AttendanceContent>
    with AttendanceDataManager {
  final DateTime currentTime = DateTime.now();
  late DateTime selectedDate;
  late DateTime centerDate;
  final ScrollController _weekScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Use current date
    final testDate = DateTime.now();
    selectedDate = testDate;
    centerDate = testDate;

    // Fetch current month's data when page loads
    fetchMonthData(testDate);
  }

  @override
  void dispose() {
    _weekScrollController.dispose();
    super.dispose();
  }

  void _updateCenterDate(DateTime newCenterDate) {
    // Check if the new date is in a different month
    final newMonthKey = '${newCenterDate.year}-${newCenterDate.month.toString().padLeft(2, '0')}';
    final currentMonthKey = currentDisplayedMonth;

    setState(() {
      centerDate = newCenterDate;
      selectedDate = newCenterDate;
    });

    // If moving to a different month, fetch that month's data
    if (newMonthKey != currentMonthKey) {
      fetchMonthData(newCenterDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        // ✅ Only refresh current month's data (preserve other months' cache)
        await fetchMonthData(centerDate, forceRefresh: true);
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            // Compact Hero Section with real data
            AttendanceHeroSection(
              isLoading: isLoading,
              errorMessage: errorMessage,
              shiftOverviewData: shiftOverviewData,
              allShiftCardsData: allShiftCardsData,
              currentDisplayedMonth: currentDisplayedMonth,
              shiftStatus: shiftStatus,
            ),

            const SizedBox(height: TossSpacing.space4),

            // QR Scan Button
            AttendanceQRButton(
              onScanResult: _handleQRScanResult,
            ),

            const SizedBox(height: TossSpacing.space4),

            // Week Schedule View
            AttendanceWeekSchedule(
              selectedDate: selectedDate,
              allShiftCardsData: allShiftCardsData,
              onDateSelected: _updateCenterDate,
              onCalendarTap: _showCalendarBottomSheet,
            ),

            const SizedBox(height: TossSpacing.space4),

            // Today Activity - filtered by selected date
            AttendanceRecentActivity(
              selectedDate: selectedDate,
              allShiftCardsData: allShiftCardsData,
              shiftOverviewData: shiftOverviewData,
              onActivityTap: _showActivityDetails,
              onViewAllTap: _showAllAttendanceHistory,
            ),

            const SizedBox(height: TossSpacing.space8),
          ],
        ),
      ),
    );
  }

  void _handleQRScanResult(Map<String, dynamic> scanResult) {
    setState(() {
      updateLocalStateAfterQRScan(scanResult);
      updateMonthlyOverviewStats(scanResult);
    });
  }

  void _showAllAttendanceHistory() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: TossColors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: const BoxDecoration(
          color: TossColors.background,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            // Handle bar - Toss style
            Container(
              margin: const EdgeInsets.only(top: TossSpacing.space2),
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: TossColors.gray200,
                borderRadius: BorderRadius.circular(TossBorderRadius.full),
              ),
            ),

            // Header - Minimalist
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: TossSpacing.space5,
                vertical: TossSpacing.space4,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'All Activity',
                    style: TossTextStyles.h3.copyWith(
                      color: TossColors.gray900,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  // Close button
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(TossSpacing.space2),
                      decoration: const BoxDecoration(
                        color: TossColors.gray50,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close,
                        size: 18,
                        color: TossColors.gray600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Divider
            Container(
              height: 1,
              color: TossColors.gray100,
            ),

            // History List - Clean Toss style
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(
                  horizontal: TossSpacing.space4,
                  vertical: TossSpacing.space3,
                ),
                itemCount: allShiftCardsData.length,
                itemBuilder: (context, index) {
                  final card = allShiftCardsData[index];
                  final dateStr = card['request_date']?.toString() ?? '';
                  final dateParts = dateStr.split('-');
                  final date = dateParts.length == 3
                      ? DateTime(
                          int.parse(dateParts[0]),
                          int.parse(dateParts[1]),
                          int.parse(dateParts[2]),
                        )
                      : DateTime.now();

                  final isApproved = card['is_approved'] ?? card['approval_status'] == 'approved' ?? false;
                  final actualStart = card['confirm_start_time'] ?? card['actual_start_time'];
                  final actualEnd = card['confirm_end_time'] ?? card['actual_end_time'];

                  String status;
                  Color statusColor;

                  if (isApproved != true) {
                    status = 'Pending';
                    statusColor = TossColors.warning;
                  } else if (actualStart != null && actualEnd == null) {
                    status = 'Working';
                    statusColor = TossColors.primary;
                  } else if (actualStart != null && actualEnd != null) {
                    status = 'Completed';
                    statusColor = TossColors.success;
                  } else {
                    status = 'Approved';
                    statusColor = TossColors.success.withValues(alpha: 0.7);
                  }

                  final activity = {
                    'date': dateStr,
                    'time': card['shift_time'] ?? '09:00 ~ 17:00',
                    'status': status,
                    'statusColor': statusColor,
                    'rawCard': card,
                  };

                  return GestureDetector(
                    onTap: () => _showActivityDetails(activity),
                    child: Container(
                      margin: const EdgeInsets.only(bottom: TossSpacing.space3),
                      padding: const EdgeInsets.all(TossSpacing.space4),
                      decoration: BoxDecoration(
                        color: TossColors.white,
                        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                        border: Border.all(
                          color: TossColors.gray100,
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          // Date indicator
                          Container(
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(
                              color: statusColor.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(TossBorderRadius.md),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  date.day.toString(),
                                  style: TossTextStyles.h3.copyWith(
                                    color: statusColor,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Text(
                                  _getShortMonthName(date.month),
                                  style: TossTextStyles.caption.copyWith(
                                    color: statusColor,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(width: TossSpacing.space3),

                          // Activity info
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      _getWeekdayShort(date.weekday),
                                      style: TossTextStyles.body.copyWith(
                                        color: TossColors.gray900,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: TossSpacing.space2,
                                        vertical: TossSpacing.space1,
                                      ),
                                      decoration: BoxDecoration(
                                        color: statusColor.withValues(alpha: 0.1),
                                        borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                                      ),
                                      child: Text(
                                        status,
                                        style: TossTextStyles.caption.copyWith(
                                          color: statusColor,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: TossSpacing.space1),
                                Text(
                                  (activity['time'] ?? '').toString(),
                                  style: TossTextStyles.caption.copyWith(
                                    color: TossColors.gray600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCalendarBottomSheet() {
    // Initialize with the currently selected date from the main state
    DateTime modalSelectedDate = selectedDate;
    DateTime modalFocusedDate = selectedDate;
    List<Map<String, dynamic>> modalShiftData = List.from(allShiftCardsData);

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: TossColors.transparent,
      builder: (modalContext) {
        // Use StatefulBuilder to ensure the modal rebuilds when parent state changes
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return CalendarBottomSheet(
              initialSelectedDate: modalSelectedDate,
              initialFocusedDate: modalFocusedDate,
              allShiftCardsData: modalShiftData,
              onFetchMonthData: (DateTime date) async {
                // Call fetchMonthData which will check if month is already loaded
                await fetchMonthData(date);
                // Update the modal's local copy of shift data with the new data
                setModalState(() {
                  modalShiftData = List.from(allShiftCardsData);
                });
              },
              onNavigateToDate: (DateTime date) {
                _navigateToDate(date);
                // Update modal's selected date and refresh data
                setModalState(() {
                  modalSelectedDate = date;
                  modalFocusedDate = date;
                  modalShiftData = List.from(allShiftCardsData);
                });
              },
              parentSetState: () {
                if (mounted) {
                  setState(() {});
                  // Also update modal state with fresh data
                  setModalState(() {
                    modalShiftData = List.from(allShiftCardsData);
                  });
                }
              },
            );
          },
        );
      },
    );
  }

  void _showActivityDetails(Map<String, dynamic> activity) {
    // Get the raw card data which contains all the shift information
    final cardData = activity['rawCard'] as Map<String, dynamic>?;
    if (cardData == null) {
      return;
    }

    showReportIssueDialog(
      context: context,
      ref: ref,
      shiftRequestId: (cardData['shift_request_id'] ?? '').toString(),
      cardData: cardData,
      onSuccess: () {
        // Refresh data after successful report
        fetchMonthData(selectedDate, forceRefresh: true);
      },
    );
  }

  void _navigateToDate(DateTime date) {
    setState(() {
      selectedDate = date;
    });
    _updateCenterDate(date);
  }

  String _getShortMonthName(int month) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return months[month - 1];
  }

  String _getWeekdayShort(int weekday) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[weekday - 1];
  }
}
