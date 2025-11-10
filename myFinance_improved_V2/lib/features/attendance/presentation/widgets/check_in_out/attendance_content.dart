import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../app/providers/app_state_provider.dart';
import '../../../../../app/providers/auth_providers.dart';
import '../../../../../core/utils/datetime_utils.dart';
import '../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';
import '../../../../../shared/widgets/common/toss_success_error_dialog.dart';
import '../../../domain/entities/shift_card_data.dart';
import '../../../domain/entities/shift_overview.dart';
import '../../../domain/value_objects/shift_status.dart';
import '../../modals/activity_details_modal.dart';
import '../../modals/attendance_history_modal.dart';
import '../../modals/calendar_bottom_sheet.dart';
import '../../modals/report_issue_dialog.dart';
import '../../providers/attendance_providers.dart';
import '../../utils/attendance_formatters.dart';
import '../../utils/date_format_utils.dart';
import 'compact_hero_section.dart';
import 'qr_scan_button.dart';
import 'recent_activity_section.dart';
import 'week_schedule_view.dart';

class AttendanceContent extends ConsumerStatefulWidget {
  const AttendanceContent({super.key});

  @override
  ConsumerState<AttendanceContent> createState() => _AttendanceContentState();
}

class _AttendanceContentState extends ConsumerState<AttendanceContent> {
  final DateTime currentTime = DateTime.now();
  late DateTime selectedDate;
  late DateTime centerDate;
  final ScrollController _weekScrollController = ScrollController();
  
  // Cache for monthly overview data - key is "yyyy-MM" format
  final Map<String, Map<String, dynamic>> _monthlyOverviewCache = {};

  // Cache for monthly cards data - key is "yyyy-MM" format (strongly typed)
  final Map<String, List<ShiftCardData>> _monthlyCardsCache = {};
  
  // Track which months have been loaded
  final Set<String> _loadedMonths = {};

  // ALL shift cards data accumulated across all loaded months (strongly typed)
  List<ShiftCardData> allShiftCardsData = [];

  // Current displayed month overview
  Map<String, dynamic>? shiftOverviewData;
  
  // Filtered cards for current view (strongly typed)
  List<ShiftCardData> get shiftCardsData {
    // Return all accumulated cards (can be filtered if needed)
    return allShiftCardsData;
  }
  
  bool isLoading = true;
  String? errorMessage;
  bool isWorking = false;
  bool hasShiftToday = false;
  ShiftStatus shiftStatus = ShiftStatus.offDuty;
  String? currentDisplayedMonth; // Track which month overview is currently displayed
  
  @override
  void initState() {
    super.initState();
    // Use current date
    final testDate = DateTime.now();
    selectedDate = testDate;
    centerDate = testDate;
    
    // Fetch current month's data when page loads
    _fetchMonthData(testDate);
  }
  
  @override
  void dispose() {
    _weekScrollController.dispose();
    super.dispose();
  }
  
  void _updateCenterDate(DateTime newCenterDate) {
    // Check if the new date is in a different month
    final newMonthKey = newCenterDate.toMonthKey();
    final currentMonthKey = currentDisplayedMonth;
    
    
    setState(() {
      centerDate = newCenterDate;
      selectedDate = newCenterDate;
    });
    
    // If moving to a different month, fetch that month's data
    if (newMonthKey != currentMonthKey) {
      _fetchMonthData(newCenterDate);
      // Don't adjust the center date after user explicitly selected a date
      // The user wants THIS specific date to be centered
    }
    // When user clicks a date, keep it centered as they requested
    // Don't auto-adjust to first available shift
  }
  
  Future<void> _fetchMonthData(DateTime targetDate, {bool forceRefresh = false}) async {
    // Create month key for tracking (yyyy-MM format)
    final monthKey = targetDate.toMonthKey();
    
    
    // Check if we already have cached data for this month
    bool hasOverview = _monthlyOverviewCache.containsKey(monthKey);
    bool hasCards = _monthlyCardsCache.containsKey(monthKey);
    
    
    // If we already have data for this month and not force refreshing, just update the display from cache
    if (hasOverview && hasCards && !forceRefresh) {
      setState(() {
        shiftOverviewData = _monthlyOverviewCache[monthKey];
        currentDisplayedMonth = monthKey;
        
        // Rebuild allShiftCardsData from cached data
        allShiftCardsData.clear();
        for (final cachedMonth in _monthlyCardsCache.keys) {
          allShiftCardsData.addAll(_monthlyCardsCache[cachedMonth]!);
        }
        
        // Sort all cards by date (descending) - strongly typed
        allShiftCardsData.sort((a, b) {
          return b.requestDate.compareTo(a.requestDate);
        });
        
        isLoading = false;
      });
      return;
    }
    
    // Need to fetch data for this month
    setState(() {
      isLoading = true;
      errorMessage = null;
    });
    
    try {
      // Get required data from providers
      final authStateAsync = ref.read(authStateProvider);
      final user = authStateAsync.value;
      final appState = ref.read(appStateProvider);

      // Get Use Cases
      final getShiftOverview = ref.read(getShiftOverviewProvider);
      final getUserShiftCards = ref.read(getUserShiftCardsProvider);
      final getCurrentShift = ref.read(getCurrentShiftProvider);

      final userId = user?.id;
      final companyId = appState.companyChoosen;
      final storeId = appState.storeChoosen;


      if (userId == null || companyId.isEmpty || storeId.isEmpty) {
        setState(() {
          isLoading = false;
          errorMessage = 'Please select a company and store';
        });
        return;
      }

      // IMPORTANT: RPC functions require the LAST day of the month as p_request_date
      // Calculate the last day of the month for the target date
      final lastDayOfMonth = DateTime(targetDate.year, targetDate.month + 1, 0);
      final requestDate = lastDayOfMonth.toDateKey();


      // Call both APIs in parallel using Use Cases
      final results = await Future.wait<dynamic>([
        getShiftOverview(
          requestDate: requestDate,
          userId: userId,
          companyId: companyId,
          storeId: storeId,
        ),
        getUserShiftCards(
          requestDate: requestDate,
          userId: userId,
          companyId: companyId,
          storeId: storeId,
        ),
        getCurrentShift(
          userId: userId,
          storeId: storeId,
        ),
      ]);

      // Convert ShiftOverview entity to Map for backward compatibility
      final overviewEntity = results[0] as ShiftOverview;
      final overviewResponse = overviewEntity.toMap();
      final cardsResponse = results[1] as List<ShiftCardData>;
      final currentShift = results[2] as ShiftCardData?;



      // Cache the overview data
      _monthlyOverviewCache[monthKey] = overviewResponse;

      // Cache the cards data for this month (strongly typed)
      _monthlyCardsCache[monthKey] = List<ShiftCardData>.from(cardsResponse);
      
      // Mark this month as loaded
      _loadedMonths.add(monthKey);
      
      // Rebuild allShiftCardsData from ALL cached months
      setState(() {
        
        // Clear and rebuild allShiftCardsData from all cached months
        allShiftCardsData.clear();
        
        // Add cards from all cached months
        for (final cachedMonth in _monthlyCardsCache.keys) {
          final monthCards = _monthlyCardsCache[cachedMonth]!;
          allShiftCardsData.addAll(monthCards);
        }
        
        
        
        // Sort all cards by date (strongly typed)
        allShiftCardsData.sort((a, b) {
          return b.requestDate.compareTo(a.requestDate); // Descending order
        });
        
        shiftOverviewData = overviewResponse;
        currentDisplayedMonth = monthKey;
        isLoading = false;

        // Check shift status (only relevant for current month) - using strongly typed entities
        if (monthKey == DateTime.now().toMonthKey()) {
          // Check if user has shift today
          final today = DateTime.now();
          final todayStr = today.toDateKey();
          final todayShifts = allShiftCardsData.where((card) => card.requestDate == todayStr).toList();

          hasShiftToday = todayShifts.isNotEmpty;

          // Check all shifts for today to determine status
          if (todayShifts.isNotEmpty) {
            // Filter to only APPROVED shifts for status determination
            final approvedShifts = todayShifts.where((shift) => shift.isApproved).toList();

            if (approvedShifts.isNotEmpty) {
              // Only consider approved shifts for status

              // Check if currently working on any approved shift (using workStatus)
              bool isCurrentlyWorking = approvedShifts.any((shift) =>
                shift.workStatus == WorkStatus.working
              );

              // Check if all approved shifts are finished
              bool allApprovedShiftsFinished = approvedShifts.every((shift) =>
                shift.workStatus == WorkStatus.completed
              );

              // Check if any approved shift has started
              bool anyApprovedShiftStarted = approvedShifts.any((shift) =>
                shift.actualStartTime != null
              );
              
              if (isCurrentlyWorking) {
                // At least one approved shift is being worked on
                shiftStatus = ShiftStatus.working;
              } else if (allApprovedShiftsFinished && anyApprovedShiftStarted) {
                // All approved shifts are completed
                shiftStatus = ShiftStatus.finished;
              } else {
                // Have approved shifts but none started yet
                shiftStatus = ShiftStatus.scheduled;
              }
            } else {
              // Have shifts but none are approved yet
              shiftStatus = ShiftStatus.scheduled;
            }
          } else {
            // No shifts at all today
            shiftStatus = ShiftStatus.offDuty;
          }
        }
      });
      
      
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Error loading data: ${e.toString()}';
      });
    }
  }
  
  // Update local state after QR scan (check-in/out)
  void _updateLocalStateAfterQRScan(Map<String, dynamic> scanResult) {
    final requestDate = scanResult['request_date'] ?? '';
    final action = scanResult['action'] ?? '';
    // Note: timestamp from QR scan is already in UTC from the server
    // If missing, convert current time to UTC
    final timestamp = scanResult['timestamp'] ?? DateTime.now().toUtc().toIso8601String();
    
    
    // Find the existing shift card for today's date (strongly typed)
    final existingCardIndex = allShiftCardsData.indexWhere((card) {
      return card.requestDate == requestDate;
    });

    if (existingCardIndex != -1) {
      // Update existing card using copyWith (immutable)
      final existingCard = allShiftCardsData[existingCardIndex];
      final timestampDateTime = DateTime.tryParse(timestamp.toString());

      if (action == 'check_in') {
        // Update check-in time
        allShiftCardsData[existingCardIndex] = existingCard.copyWith(
          actualStartTime: timestampDateTime,
          actualEndTime: null, // Clear check-out for re-check-in
        );
      } else if (action == 'check_out') {
        // Update check-out time
        allShiftCardsData[existingCardIndex] = existingCard.copyWith(
          actualEndTime: timestampDateTime,
        );
      }
    } else {
      // Note: Creating new card shouldn't happen normally
      // The card should already exist from server data
      // We'll skip this case for now as it requires ShiftCardData constructor
    }
    
    // Update monthly overview stats if needed
    _updateMonthlyOverviewStats(scanResult);
  }
  
  // Update monthly overview statistics after QR scan
  void _updateMonthlyOverviewStats(Map<String, dynamic> scanResult) {
    // This can be expanded to update:
    // - Total hours worked
    // - Overtime calculations
    // - Late deductions
    // - etc.
  }
  
  
  List<Map<String, dynamic>> get weekSchedule {
    // Create a 7-day window with centerDate at position 3 (index 3)
    // This gives us 3 days before and 3 days after the center date
    List<Map<String, dynamic>> schedule = [];
    
    
    for (int i = -3; i <= 3; i++) {  // This creates 7 days: -3, -2, -1, 0, 1, 2, 3
      final date = centerDate.add(Duration(days: i));
      final dateStr = date.toDateKey();
      
      // Find ALL shift cards for this date - use allShiftCardsData (strongly typed)
      final shiftsForDate = allShiftCardsData.where(
        (card) => card.requestDate == dateStr,
      ).toList();


      if (shiftsForDate.isNotEmpty) {
        // Has shift(s) for this date - use the first one for display
        // but mark that there are shifts
        final shiftCard = shiftsForDate.first;
        // The RPC returns shift_time as "22:00 ~ 02:00" format
        final shiftTime = shiftCard.shiftTime;
        final actualStart = shiftCard.actualStartTime;
        final actualEnd = shiftCard.actualEndTime;

        // Check approval status for all shifts (strongly typed)
        final hasApprovedShift = shiftsForDate.any((card) => card.isApproved);
        final hasNonApprovedShift = shiftsForDate.any((card) => !card.isApproved);

        schedule.add({
          'date': date,
          'hasShift': true,
          'shiftCount': shiftsForDate.length, // Track number of shifts
          'worked': actualStart != null, // Worked if they checked in
          'hasApprovedShift': hasApprovedShift,
          'hasNonApprovedShift': hasNonApprovedShift,
          'shift': shiftTime,
          'actualStart': actualStart,
          'actualEnd': actualEnd,
          'lateMinutes': shiftCard.overtimeMinutes ?? 0,
          'overtimeMinutes': shiftCard.overtimeMinutes ?? 0,
          'allShifts': shiftsForDate, // Store all shifts for this date
        });
      } else {
        // No shift for this date
        schedule.add({
          'date': date,
          'hasShift': false,
          'worked': false,
          'hasApprovedShift': false,
          'hasNonApprovedShift': false,
          'shift': '',
        });
      }
    }
    
    return schedule;
  }
  
  @override
  Widget build(BuildContext context) {
    // Calculate work duration if currently working
    Duration workDuration = Duration.zero;
    // This would be calculated from actual shift data when available

    return RefreshIndicator(
      onRefresh: () async {
        // Clear all cached data and refresh from current month
        setState(() {
          allShiftCardsData.clear();
          _monthlyOverviewCache.clear();
          _monthlyCardsCache.clear();
          _loadedMonths.clear();
        });
        await _fetchMonthData(centerDate);
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            // Compact Hero Section with real data
            CompactHeroSection(
              isLoading: isLoading,
              errorMessage: errorMessage,
              shiftOverviewData: shiftOverviewData,
              allShiftCardsData: allShiftCardsData,
              currentDisplayedMonth: currentDisplayedMonth,
              shiftStatus: shiftStatus,
            ),

            const SizedBox(height: TossSpacing.space4),

            // QR Scan Button
            QRScanButton(
              onQRScanResult: (result) {
                // Update local state instead of calling RPC
                _updateLocalStateAfterQRScan(result);

                // Force UI update immediately
                if (mounted) {
                  setState(() {
                    // Force rebuild of activity section with updated data
                  });
                }
              },
            ),

          const SizedBox(height: TossSpacing.space4),

          // Week Schedule View
          WeekScheduleView(
            selectedDate: selectedDate,
            allShiftCardsData: allShiftCardsData,
            onDateSelected: (date) {
              setState(() {
                selectedDate = date;
              });
            },
            onViewCalendar: _showCalendarBottomSheet,
          ),

          const SizedBox(height: TossSpacing.space4),

          // Today Activity - filtered by selected date
          RecentActivitySection(
            selectedDate: selectedDate,
            allShiftCardsData: allShiftCardsData,
            shiftOverviewData: shiftOverviewData,
            onShowActivityDetails: _showActivityDetails,
            onViewAllActivity: _showAllAttendanceHistory,
          ),

            const SizedBox(height: TossSpacing.space8),
          ],
        ),
      ),
    );
  }
  

  void _showAllAttendanceHistory() {
    AttendanceHistoryModal.show(
      context: context,
      allShiftCardsData: allShiftCardsData,
      onShowActivityDetails: _showActivityDetails,
    );
  }

  void _showCalendarBottomSheet() {
    // Initialize with the currently selected date from the main state
    DateTime modalSelectedDate = selectedDate;
    DateTime modalFocusedDate = selectedDate;
    List<Map<String, dynamic>> modalShiftData = List.from(allShiftCardsData);
    
    showModalBottomSheet(
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
                // Call _fetchMonthData which will check if month is already loaded
                await _fetchMonthData(date);
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
    ActivityDetailsModal.show(
      context: context,
      activity: activity,
      currencySymbol: (shiftOverviewData?['currency_symbol'] as String?) ?? 'VND',
      onReportIssue: _showReportIssueDialog,
    );
  }

  Future<void> _showReportIssueDialog(String shiftRequestId, ShiftCardData cardData) async {
    await ReportIssueDialog.show(
      context: context,
      shiftRequestId: shiftRequestId,
      cardData: cardData,
      onSuccess: () => _fetchMonthData(selectedDate),
    );
  }

  void _navigateToDate(DateTime date) {
    setState(() {
      selectedDate = date;
    });
    _updateCenterDate(date);
  }
}

