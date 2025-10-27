import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../app/providers/app_state_provider.dart';
import '../../../../../app/providers/auth_providers.dart';
import '../../../../../core/utils/datetime_utils.dart';
import '../../../../../shared/themes/toss_animations.dart';
import '../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_shadows.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';
import '../../../../../shared/widgets/common/toss_loading_view.dart';
import '../../../../../shared/widgets/common/toss_success_error_dialog.dart';
import '../../../domain/entities/shift_overview.dart';
import '../../modals/calendar_bottom_sheet.dart';
import '../../providers/attendance_provider.dart';
import '../../pages/qr_scanner_page.dart';

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
  
  // Cache for monthly cards data - key is "yyyy-MM" format
  final Map<String, List<Map<String, dynamic>>> _monthlyCardsCache = {};
  
  // Track which months have been loaded
  final Set<String> _loadedMonths = {};
  
  // ALL shift cards data accumulated across all loaded months
  List<Map<String, dynamic>> allShiftCardsData = [];
  
  // Current displayed month overview
  Map<String, dynamic>? shiftOverviewData;
  
  // Filtered cards for current view
  List<Map<String, dynamic>> get shiftCardsData {
    // Return all accumulated cards (can be filtered if needed)
    return allShiftCardsData;
  }
  
  bool isLoading = true;
  String? errorMessage;
  bool isWorking = false;
  bool hasShiftToday = false;
  String shiftStatus = 'off_duty'; // 'off_duty', 'scheduled', 'working', 'finished'
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
    final newMonthKey = '${newCenterDate.year}-${newCenterDate.month.toString().padLeft(2, '0')}';
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
  
  void _adjustCenterDateForAvailableData(String monthKey) {
    
    // Find the first date with shift data in this month
    final monthShifts = allShiftCardsData.where((card) {
      final date = card['request_date']?.toString() ?? '';
      return date.startsWith(monthKey);
    }).toList();
    
    
    if (monthShifts.isNotEmpty) {
      // Sort by date to find the earliest shift
      monthShifts.sort((a, b) {
        final dateA = a['request_date']?.toString() ?? '';
        final dateB = b['request_date']?.toString() ?? '';
        return dateA.compareTo(dateB);
      });
      
      // Parse the first shift date
      final firstShiftDateStr = monthShifts.first['request_date'];
      final lastShiftDateStr = monthShifts.last['request_date'];
      
      if (firstShiftDateStr != null) {
        final parts = firstShiftDateStr.toString().split('-');
        if (parts.length == 3) {
          final firstShiftDate = DateTime(
            int.parse(parts[0]),
            int.parse(parts[1]),
            int.parse(parts[2]),
          );
          
          // Adjust center date to show the week containing the first shift
          // If first shift is early in month (days 1-3), center on day 4
          // Otherwise center on the first shift date
          setState(() {
            if (firstShiftDate.day <= 3) {
              centerDate = DateTime(firstShiftDate.year, firstShiftDate.month, 4);
            } else {
              centerDate = firstShiftDate;
            }
            selectedDate = centerDate;
          });
        }
      }
    } else {
    }
  }
  
  Future<void> _fetchMonthData(DateTime targetDate, {bool forceRefresh = false}) async {
    // Create month key for tracking (yyyy-MM format)
    final monthKey = '${targetDate.year}-${targetDate.month.toString().padLeft(2, '0')}';
    
    
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
        
        // Sort all cards by date (descending)
        allShiftCardsData.sort((a, b) {
          final dateA = a['request_date']?.toString() ?? '';
          final dateB = b['request_date']?.toString() ?? '';
          return dateB.compareTo(dateA);
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
      final repository = ref.read(attendanceRepositoryProvider);

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
      final requestDate = '${lastDayOfMonth.year}-${lastDayOfMonth.month.toString().padLeft(2, '0')}-${lastDayOfMonth.day.toString().padLeft(2, '0')}';
      
      
      // Call both APIs in parallel
      final results = await Future.wait<dynamic>([
        repository.getUserShiftOverview(
          requestDate: requestDate,
          userId: userId,
          companyId: companyId,
          storeId: storeId,
        ),
        repository.getUserShiftCards(
          requestDate: requestDate,
          userId: userId,
          companyId: companyId,
          storeId: storeId,
        ),
        repository.getCurrentShift(
          userId: userId,
          storeId: storeId,
        ),
      ]);

      // Convert ShiftOverview entity to Map for backward compatibility
      final overviewEntity = results[0] as ShiftOverview;
      final overviewResponse = overviewEntity.toMap();
      final cardsResponse = results[1] as List<Map<String, dynamic>>;
      final currentShift = results[2] as Map<String, dynamic>?;
      
      
      
      // Cache the overview data
      _monthlyOverviewCache[monthKey] = overviewResponse;
      
      // Cache the cards data for this month
      _monthlyCardsCache[monthKey] = List<Map<String, dynamic>>.from(cardsResponse);
      
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
        
        
        
        // Sort all cards by date
        allShiftCardsData.sort((a, b) {
          final dateA = a['request_date'] ?? '';
          final dateB = b['request_date'] ?? '';
          return dateB.compareTo(dateA); // Descending order
        });
        
        shiftOverviewData = overviewResponse;
        currentDisplayedMonth = monthKey;
        isLoading = false;
        
        // Check shift status (only relevant for current month)
        if (monthKey == '${DateTime.now().year}-${DateTime.now().month.toString().padLeft(2, '0')}') {
          // Check if user has shift today
          final today = DateTime.now();
          final todayStr = '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';
          final todayShifts = allShiftCardsData.where((card) => card['request_date'] == todayStr).toList();
          
          hasShiftToday = todayShifts.isNotEmpty;
          
          // Check all shifts for today to determine status
          if (todayShifts.isNotEmpty) {
            // Filter to only APPROVED shifts for status determination
            final approvedShifts = todayShifts.where((shift) => 
              shift['is_approved'] == true || 
              shift['approval_status'] == 'approved'
            ).toList();
            
            if (approvedShifts.isNotEmpty) {
              // Only consider approved shifts for status
              
              // Check if currently working on any approved shift
              bool isCurrentlyWorking = approvedShifts.any((shift) => 
                shift['confirm_start_time'] != null && 
                shift['confirm_end_time'] == null
              );
              
              // Check if all approved shifts are finished
              bool allApprovedShiftsFinished = approvedShifts.every((shift) => 
                shift['confirm_start_time'] != null && 
                shift['confirm_end_time'] != null
              );
              
              // Check if any approved shift has started
              bool anyApprovedShiftStarted = approvedShifts.any((shift) => 
                shift['confirm_start_time'] != null
              );
              
              if (isCurrentlyWorking) {
                // At least one approved shift is being worked on
                shiftStatus = 'working';
              } else if (allApprovedShiftsFinished && anyApprovedShiftStarted) {
                // All approved shifts are completed
                shiftStatus = 'finished';
              } else {
                // Have approved shifts but none started yet
                shiftStatus = 'scheduled';
              }
            } else {
              // Have shifts but none are approved yet
              shiftStatus = 'scheduled';
            }
          } else {
            // No shifts at all today
            shiftStatus = 'off_duty';
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
    
    
    // Find the existing shift card for today's date
    final existingCardIndex = allShiftCardsData.indexWhere((card) {
      return card['request_date'] == requestDate;
    });
    
    if (existingCardIndex != -1) {
      // Update existing card
      final existingCard = allShiftCardsData[existingCardIndex];
      
      if (action == 'check_in') {
        // Update check-in time
        existingCard['actual_start_time'] = timestamp;
        existingCard['confirm_start_time'] = timestamp;
        
        // Clear check-out time if exists (for re-check-in scenarios)
        existingCard['actual_end_time'] = null;
        existingCard['confirm_end_time'] = null;
      } else if (action == 'check_out') {
        // Update check-out time
        existingCard['actual_end_time'] = timestamp;
        existingCard['confirm_end_time'] = timestamp;
      }
      
      // Update the card in the list
      allShiftCardsData[existingCardIndex] = existingCard;
    } else {
      // Create new card if it doesn't exist (shouldn't happen normally)
      final newCard = {
        'request_date': requestDate,
        'shift_request_id': scanResult['shift_request_id'] ?? '',
        'shift_name': scanResult['shift_name'] ?? 'Shift',
        'shift_start_time': scanResult['shift_start_time'] ?? '09:00:00',
        'shift_end_time': scanResult['shift_end_time'] ?? '18:00:00',
        'is_approved': true,
        'actual_start_time': action == 'check_in' ? timestamp : null,
        'confirm_start_time': action == 'check_in' ? timestamp : null,
        'actual_end_time': action == 'check_out' ? timestamp : null,
        'confirm_end_time': action == 'check_out' ? timestamp : null,
      };
      
      allShiftCardsData.add(newCard);
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
      final dateStr = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
      
      // Find ALL shift cards for this date - use allShiftCardsData
      final shiftsForDate = allShiftCardsData.where(
        (card) => card['request_date'] == dateStr,
      ).toList();
      
      
      if (shiftsForDate.isNotEmpty) {
        // Has shift(s) for this date - use the first one for display
        // but mark that there are shifts
        final shiftCard = shiftsForDate.first;
        // The RPC returns shift_time as "22:00 ~ 02:00" format
        final shiftTime = shiftCard['shift_time'] ?? '';
        final actualStart = shiftCard['confirm_start_time'];
        final actualEnd = shiftCard['confirm_end_time'];
        
        // Check approval status for all shifts
        final hasApprovedShift = shiftsForDate.any((card) {
          final isApproved = card['is_approved'];
          final approvalStatus = card['approval_status'];
          return (isApproved == true) || (approvalStatus == 'approved');
        });
        final hasNonApprovedShift = shiftsForDate.any((card) {
          final isApproved = card['is_approved'];
          final approvalStatus = card['approval_status'];
          return (isApproved != true) && (approvalStatus != 'approved');
        });
        
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
          'lateMinutes': shiftCard['late_minutes'] ?? 0,
          'overtimeMinutes': shiftCard['overtime_minutes'] ?? 0,
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
            _buildCompactHeroSection(workDuration),
            
            const SizedBox(height: TossSpacing.space4),
            
            // QR Scan Button
            _buildQRScanButton(),
          
          const SizedBox(height: TossSpacing.space4),
          
          // Week Schedule View
          _buildWeekScheduleView(),
          
          const SizedBox(height: TossSpacing.space4),
          
          // Today Activity - filtered by selected date
          _buildRecentActivity(),
          
            const SizedBox(height: TossSpacing.space8),
          ],
        ),
      ),
    );
  }
  
  // Copy all the build methods from AttendancePage
  Widget _buildCompactHeroSection(Duration workDuration) {
    // Show loading state
    if (isLoading) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space5),
        child: Container(
          height: 400,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                TossColors.primary.withOpacity(0.05),
                TossColors.surface,
              ],
            ),
            borderRadius: BorderRadius.circular(TossBorderRadius.xl),
          ),
          child: const TossLoadingView(),
        ),
      );
    }
    
    // Show error state if there's an error
    if (errorMessage != null) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space5),
        child: Container(
          padding: const EdgeInsets.all(TossSpacing.space5),
          decoration: BoxDecoration(
            color: TossColors.error.withOpacity(0.1),
            borderRadius: BorderRadius.circular(TossBorderRadius.xl),
          ),
          child: Text(
            errorMessage!,
            style: TossTextStyles.body.copyWith(color: TossColors.error),
          ),
        ),
      );
    }
    
    // If no data yet, show empty state
    if (shiftOverviewData == null) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space5),
        child: Container(
          padding: const EdgeInsets.all(TossSpacing.space5),
          decoration: BoxDecoration(
            color: TossColors.gray100,
            borderRadius: BorderRadius.circular(TossBorderRadius.xl),
          ),
          child: Center(
            child: Text(
              'No data available',
              style: TossTextStyles.body.copyWith(color: TossColors.gray600),
            ),
          ),
        ),
      );
    }
    
    // Parse data from the API response
    final requestMonth = shiftOverviewData!['request_month'] ?? '';
    final actualWorkDays = shiftOverviewData!['actual_work_days'] ?? 0;
    final actualWorkHours = (shiftOverviewData!['actual_work_hours'] ?? 0).toDouble();
    final estimatedSalary = shiftOverviewData!['estimated_salary'] ?? '0';
    final currencySymbol = shiftOverviewData!['currency_symbol'] ?? '₩';
    final salaryAmount = (shiftOverviewData!['salary_amount'] ?? 0).toDouble();
    final lateDeductionTotal = shiftOverviewData!['late_deduction_total'] ?? 0;
    final overtimeTotal = shiftOverviewData!['overtime_total'] ?? 0;
    
    // Calculate total unique shifts from the shift cards data for the current month
    
    final currentMonthShifts = allShiftCardsData.where((card) {
      final requestDate = card['request_date']?.toString() ?? '';
      return requestDate.startsWith(currentDisplayedMonth ?? '');
    }).toList();
    
    final totalShifts = currentMonthShifts.length;
    
    // Parse month and year from request_month (format: "2025-08")
    String monthDisplay = 'Current Month';
    if (requestMonth.isNotEmpty) {
      final parts = requestMonth.toString().split('-');
      if (parts.length == 2) {
        final year = parts[0];
        final month = int.tryParse(parts[1]) ?? DateTime.now().month;
        final monthNames = ['January', 'February', 'March', 'April', 'May', 'June',
                           'July', 'August', 'September', 'October', 'November', 'December'];
        monthDisplay = '${monthNames[month - 1]} $year';
      }
    }
    
    // Toss-style overview section
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space4),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              TossColors.primary.withOpacity(0.08),
              TossColors.primary.withOpacity(0.12),
            ],
          ),
          borderRadius: BorderRadius.circular(TossBorderRadius.xxxl),
        ),
        child: Padding(
          padding: const EdgeInsets.all(TossSpacing.space5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with Month and Status
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        monthDisplay,
                        style: TossTextStyles.h2.copyWith(
                          color: TossColors.gray900,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: TossSpacing.space1),
                      Text(
                        'Monthly Overview',
                        style: TossTextStyles.bodySmall.copyWith(
                          color: TossColors.gray600,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  // Status Badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: TossSpacing.space3,
                      vertical: TossSpacing.space2,
                    ),
                    decoration: BoxDecoration(
                      color: TossColors.surface.withOpacity(0.95),
                      borderRadius: BorderRadius.circular(TossBorderRadius.xxl),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: _getStatusColor(shiftStatus),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: TossSpacing.space2),
                        Text(
                          _getStatusText(shiftStatus),
                          style: TossTextStyles.bodySmall.copyWith(
                            color: TossColors.gray700,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: TossSpacing.space6),
              
              // Stats Grid - 2x2 layout
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(TossSpacing.space4),
                      decoration: BoxDecoration(
                        color: TossColors.primary.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(TossBorderRadius.xl),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.calendar_today_outlined,
                                size: 18,
                                color: TossColors.primary,
                              ),
                              const SizedBox(width: TossSpacing.space2),
                              Text(
                                'Total Shifts',
                                style: TossTextStyles.caption.copyWith(
                                  color: TossColors.gray500,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: TossSpacing.space2),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                              Text(
                                totalShifts.toString(),
                                style: TossTextStyles.h2.copyWith(
                                  color: TossColors.gray900,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(width: TossSpacing.space1),
                              Text(
                                'shifts',
                                style: TossTextStyles.bodySmall.copyWith(
                                  color: TossColors.gray600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: TossSpacing.space3),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(TossSpacing.space4),
                      decoration: BoxDecoration(
                        color: TossColors.info.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(TossBorderRadius.xl),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.access_time,
                                size: 18,
                                color: TossColors.info,
                              ),
                              const SizedBox(width: TossSpacing.space2),
                              Text(
                                'Total Hours',
                                style: TossTextStyles.caption.copyWith(
                                  color: TossColors.gray500,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: TossSpacing.space2),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                              Text(
                                actualWorkHours.toStringAsFixed(1),
                                style: TossTextStyles.h2.copyWith(
                                  color: TossColors.gray900,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(width: TossSpacing.space1),
                              Text(
                                'hrs',
                                style: TossTextStyles.bodySmall.copyWith(
                                  color: TossColors.gray600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: TossSpacing.space3),
              
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(TossSpacing.space4),
                      decoration: BoxDecoration(
                        color: TossColors.success.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(TossBorderRadius.xl),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.trending_up,
                                size: 18,
                                color: TossColors.success,
                              ),
                              const SizedBox(width: TossSpacing.space2),
                              Text(
                                'Overtime',
                                style: TossTextStyles.caption.copyWith(
                                  color: TossColors.gray500,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: TossSpacing.space2),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                              Text(
                                overtimeTotal.toString(),
                                style: TossTextStyles.h2.copyWith(
                                  color: TossColors.gray900,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(width: TossSpacing.space1),
                              Text(
                                'min',
                                style: TossTextStyles.bodySmall.copyWith(
                                  color: TossColors.gray600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: TossSpacing.space3),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(TossSpacing.space4),
                      decoration: BoxDecoration(
                        color: TossColors.warning.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(TossBorderRadius.xl),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.trending_down,
                                size: 18,
                                color: TossColors.warning,
                              ),
                              const SizedBox(width: TossSpacing.space2),
                              Text(
                                'Late Deduct',
                                style: TossTextStyles.caption.copyWith(
                                  color: TossColors.gray500,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: TossSpacing.space2),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                              Text(
                                lateDeductionTotal.toString(),
                                style: TossTextStyles.h2.copyWith(
                                  color: TossColors.gray900,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(width: TossSpacing.space1),
                              Text(
                                'min',
                                style: TossTextStyles.bodySmall.copyWith(
                                  color: TossColors.gray600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: TossSpacing.space5),
              
              // Estimated Salary Card
              Container(
                padding: const EdgeInsets.all(TossSpacing.space4),
                decoration: BoxDecoration(
                  color: TossColors.surface.withOpacity(0.95),
                  borderRadius: BorderRadius.circular(TossBorderRadius.xl),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(TossSpacing.space2),
                          decoration: BoxDecoration(
                            color: TossColors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(TossBorderRadius.md),
                          ),
                          child: Icon(
                            Icons.account_balance_wallet,
                            size: 20,
                            color: TossColors.primary,
                          ),
                        ),
                        const SizedBox(width: TossSpacing.space3),
                        Text(
                          'Estimated Salary',
                          style: TossTextStyles.body.copyWith(
                            color: TossColors.gray600,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: TossSpacing.space3),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${currencySymbol}${estimatedSalary}',
                          style: TossTextStyles.display.copyWith(
                            color: TossColors.primary,
                            fontWeight: FontWeight.w800,
                            fontSize: 32,
                          ),
                        ),
                        if ((overtimeTotal ?? 0) > 0) ...[  
                          const SizedBox(height: TossSpacing.space1),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: TossSpacing.space2,
                                  vertical: TossSpacing.space1,
                                ),
                                decoration: BoxDecoration(
                                  color: TossColors.success.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(TossBorderRadius.md),
                                ),
                                child: Text(
                                  '+${currencySymbol}${(overtimeTotal * salaryAmount / 60).toStringAsFixed(0)}',
                                  style: TossTextStyles.caption.copyWith(
                                    color: TossColors.success,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              const SizedBox(width: TossSpacing.space2),
                              Text(
                                'overtime bonus',
                                style: TossTextStyles.caption.copyWith(
                                  color: TossColors.gray500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: TossSpacing.space5),
              
              // QR Scan Button
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildQRScanButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space4),
      child: Material(
        color: TossColors.primary,
        borderRadius: BorderRadius.circular(TossBorderRadius.xl),
        child: InkWell(
          onTap: () async {
                    HapticFeedback.mediumImpact();
                    
                    // Check today's shifts
                    // Allow QR scanning even if no shift today
                    // RPC will handle previous day shift check-out (for overnight workers)

                    // Navigate to QR scanner page
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const QRScannerPage(),
                      ),
                    );
                    
                    // If successfully checked in/out, update local state
                    if (result != null && result is Map<String, dynamic>) {
                      // Update local state instead of calling RPC
                      _updateLocalStateAfterQRScan(result);
                      
                      // Force UI update immediately
                      if (mounted) {
                        setState(() {
                          // Force rebuild of activity section with updated data
                        });
                      }
                    }
                  },
                  borderRadius: BorderRadius.circular(TossBorderRadius.xl),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: TossSpacing.space4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.qr_code_scanner,
                          color: TossColors.white,
                          size: 24,
                        ),
                        const SizedBox(width: TossSpacing.space2),
                        Text(
                          'Scan QR',
                          style: TossTextStyles.labelLarge.copyWith(
                            color: TossColors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
  }
  
  
  Widget _buildStatCard({
    required IconData icon,
    required Color iconColor,
    required Color backgroundColor,
    required String label,
    required String value,
    required String suffix,
  }) {
    return Container(
      padding: const EdgeInsets.all(TossSpacing.space3),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        border: Border.all(
          color: iconColor.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 16,
                color: iconColor,
              ),
              const SizedBox(width: TossSpacing.space1),
              Expanded(
                child: Text(
                  label,
                  style: TossTextStyles.small.copyWith(
                    color: TossColors.gray600,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: TossSpacing.space2),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                value,
                style: TossTextStyles.h3.copyWith(
                  color: TossColors.gray900,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(width: TossSpacing.space1),
              Text(
                suffix,
                style: TossTextStyles.small.copyWith(
                  color: TossColors.gray500,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildWeekScheduleView() {
    // Calculate centered week schedule based on selected date
    // Always show 7 days with selected date in the center (position 3)
    final centeredWeekSchedule = <Map<String, dynamic>>[];
    
    // Start from 3 days before selected date
    for (int i = -3; i <= 3; i++) {
      final date = selectedDate.add(Duration(days: i));
      final dateStr = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
      
      // Check if this date has any shift data
      final hasData = allShiftCardsData.any((card) => card['request_date'] == dateStr);
      final dayCards = allShiftCardsData.where((card) => card['request_date'] == dateStr).toList();
      
      // Check approval status
      bool hasApprovedShift = false;
      bool hasNonApprovedShift = false;
      if (dayCards.isNotEmpty) {
        hasApprovedShift = dayCards.any((card) => card['is_approved'] == true);
        hasNonApprovedShift = dayCards.any((card) => card['is_approved'] != true);
      }
      
      centeredWeekSchedule.add({
        'date': date,
        'hasShift': hasData,
        'hasApprovedShift': hasApprovedShift,
        'hasNonApprovedShift': hasNonApprovedShift,
      });
    }
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'This Week Schedule',
                    style: TossTextStyles.h3.copyWith(
                      color: TossColors.gray900,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: TossSpacing.space1),
                  Text(
                    '${_getMonthName(selectedDate.month)} ${selectedDate.year}',
                    style: TossTextStyles.bodySmall.copyWith(
                      color: TossColors.gray600,
                    ),
                  ),
                ],
              ),
              // View Calendar Button
              Material(
                color: TossColors.transparent,
                child: InkWell(
                  onTap: () {
                    HapticFeedback.selectionClick();
                    _showCalendarBottomSheet();
                  },
                  borderRadius: BorderRadius.circular(TossBorderRadius.md),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: TossSpacing.space3,
                      vertical: TossSpacing.space2,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.calendar_month_outlined,
                          size: 18,
                          color: TossColors.gray600,
                        ),
                        const SizedBox(width: TossSpacing.space2),
                        Text(
                          'View Calendar',
                          style: TossTextStyles.bodySmall.copyWith(
                            color: TossColors.gray600,
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
          
          const SizedBox(height: TossSpacing.space4),
          
          // Week Days
          Container(
            padding: const EdgeInsets.all(TossSpacing.space3),
            decoration: BoxDecoration(
              color: TossColors.gray50,
              borderRadius: BorderRadius.circular(TossBorderRadius.xxl),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(centeredWeekSchedule.length, (index) {
                final schedule = centeredWeekSchedule[index];
                final date = schedule['date'] as DateTime;
                final hasShift = schedule['hasShift'] as bool;
                final hasApprovedShift = schedule['hasApprovedShift'] ?? false;
                final hasNonApprovedShift = schedule['hasNonApprovedShift'] ?? false;
                final isSelected = date.day == selectedDate.day && 
                                 date.month == selectedDate.month && 
                                 date.year == selectedDate.year;
                final isToday = date.day == DateTime.now().day && 
                               date.month == DateTime.now().month && 
                               date.year == DateTime.now().year;
                
                // Weekday names
                final weekdays = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
                final weekdayName = weekdays[date.weekday % 7];
                
                return Expanded(
                  child: GestureDetector(
                    onTap: () async {
                      // Check if the date is in a different month
                      final currentMonth = selectedDate.month;
                      final currentYear = selectedDate.year;
                      final newMonth = date.month;
                      final newYear = date.year;
                      
                      setState(() {
                        selectedDate = date;
                        centerDate = date;
                      });
                      HapticFeedback.selectionClick();
                      
                      // If month changed, fetch data for the new month
                      if (currentMonth != newMonth || currentYear != newYear) {
                        await _fetchMonthData(date);
                      }
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 2),
                      padding: const EdgeInsets.symmetric(
                        vertical: TossSpacing.space3,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected 
                          ? TossColors.primary 
                          : isToday 
                            ? TossColors.surface
                            : TossColors.transparent,
                        borderRadius: BorderRadius.circular(TossBorderRadius.xl),
                        border: isToday && !isSelected
                          ? Border.all(
                              color: TossColors.gray200,
                              width: 1,
                            )
                          : null,
                        // Add subtle shadow for selected date
                        boxShadow: isSelected 
                          ? [
                              BoxShadow(
                                color: TossColors.primary.withOpacity(0.3),
                                blurRadius: 8,
                                offset: Offset(0, 2),
                              ),
                            ]
                          : null,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Weekday
                          Text(
                            weekdayName,
                            style: TossTextStyles.small.copyWith(
                              color: isSelected 
                                ? TossColors.surface 
                                : TossColors.gray500,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: TossSpacing.space2),
                          // Day number
                          Text(
                            date.day.toString(),
                            style: TossTextStyles.h3.copyWith(
                              color: isSelected 
                                ? TossColors.surface 
                                : TossColors.gray900,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: TossSpacing.space2),
                          // Status indicator
                          if (hasShift)
                            Container(
                              width: 6,
                              height: 6,
                              decoration: BoxDecoration(
                                color: (hasApprovedShift == true)
                                  ? (isSelected ? TossColors.surface : TossColors.success)
                                  : (isSelected ? TossColors.surface : TossColors.warning),
                                shape: BoxShape.circle,
                              ),
                            )
                          else
                            Text(
                              'off',
                              style: TossTextStyles.small.copyWith(
                                color: isSelected 
                                  ? TossColors.surface.withOpacity(0.8)
                                  : TossColors.gray400,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildRecentActivity() {
    // Filter activities for the selected date
    final selectedDateStr = '${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}';
    
    
    // Filter cards for the selected date only
    final selectedDateCards = allShiftCardsData.where((card) {
      final cardDate = card['request_date'] ?? '';
      return cardDate == selectedDateStr;
    }).toList();
    
    
    // Sort by shift_request_id or any other relevant field
    selectedDateCards.sort((a, b) {
      final idA = a['shift_request_id'] ?? '';
      final idB = b['shift_request_id'] ?? '';
      return idA.compareTo(idB);
    });
    
    final recentActivities = selectedDateCards
      .map((card) {
        // Parse date
        final dateStr = (card['request_date'] ?? '').toString();
        final dateParts = dateStr.split('-');
        final date = dateParts.length == 3
          ? DateTime(
              int.parse(dateParts[0].toString()),
              int.parse(dateParts[1].toString()),
              int.parse(dateParts[2].toString())
            )
          : DateTime.now();
        
        // Parse times - check both confirm_* and actual_* fields
        final actualStart = card['confirm_start_time'] ?? card['actual_start_time'];
        final actualEnd = card['confirm_end_time'] ?? card['actual_end_time'];
        String checkInTime = '--:--';
        String checkOutTime = '--:--';
        String hoursWorked = '0h 0m';
        
        if (actualStart != null && actualStart.toString().isNotEmpty) {
          try {
            // If it's just a time (HH:mm:ss), extract hours and minutes
            if (actualStart.toString().contains(':') && !actualStart.toString().contains('T')) {
              final timeParts = actualStart.toString().split(':');
              if (timeParts.length >= 2) {
                checkInTime = '${timeParts[0].padLeft(2, '0')}:${timeParts[1].padLeft(2, '0')}';
              }
            } else {
              // It's a full datetime string (UTC from DB - convert to local time)
              final startTime = DateTimeUtils.toLocal(actualStart.toString());
              checkInTime = '${startTime.hour.toString().padLeft(2, '0')}:${startTime.minute.toString().padLeft(2, '0')}';
            }
          } catch (e) {
            checkInTime = actualStart.toString().substring(0, 5); // Try to get first 5 chars (HH:mm)
          }
        }
        
        if (actualEnd != null && actualEnd.toString().isNotEmpty) {
          try {
            // If it's just a time (HH:mm:ss), extract hours and minutes
            if (actualEnd.toString().contains(':') && !actualEnd.toString().contains('T')) {
              final timeParts = actualEnd.toString().split(':');
              if (timeParts.length >= 2) {
                checkOutTime = '${timeParts[0].padLeft(2, '0')}:${timeParts[1].padLeft(2, '0')}';
              }
            } else {
              // It's a full datetime string (UTC from DB - convert to local time)
              final endTime = DateTimeUtils.toLocal(actualEnd.toString());
              checkOutTime = '${endTime.hour.toString().padLeft(2, '0')}:${endTime.minute.toString().padLeft(2, '0')}';
            }
            
            // Calculate hours worked if we have both times
            if (actualStart != null && actualStart.toString().isNotEmpty) {
              try {
                // Parse the request_date and combine with times to get full DateTime
                final baseDate = date;
                
                // Parse start time (UTC from DB - convert to local time)
                DateTime startDateTime;
                if (actualStart.toString().contains('T')) {
                  startDateTime = DateTimeUtils.toLocal(actualStart.toString());
                } else {
                  final startParts = actualStart.toString().split(':');
                  startDateTime = DateTime(
                    baseDate.year, 
                    baseDate.month, 
                    baseDate.day,
                    int.parse(startParts[0]),
                    int.parse(startParts[1]),
                  );
                }
                
                // Parse end time (UTC from DB - convert to local time)
                DateTime endDateTime;
                if (actualEnd.toString().contains('T')) {
                  endDateTime = DateTimeUtils.toLocal(actualEnd.toString());
                } else {
                  final endParts = actualEnd.toString().split(':');
                  endDateTime = DateTime(
                    baseDate.year, 
                    baseDate.month, 
                    baseDate.day,
                    int.parse(endParts[0]),
                    int.parse(endParts[1]),
                  );
                  
                  // If end time is before start time, it's the next day
                  if (endDateTime.isBefore(startDateTime)) {
                    endDateTime = endDateTime.add(const Duration(days: 1));
                  }
                }
                
                final duration = endDateTime.difference(startDateTime);
                final hours = duration.inHours;
                final minutes = duration.inMinutes % 60;
                hoursWorked = '${hours}h ${minutes}m';
              } catch (e) {
              }
            }
          } catch (e) {
            checkOutTime = actualEnd.toString().substring(0, 5); // Try to get first 5 chars (HH:mm)
          }
        }
        
        // Check if shift is approved and reported
        final isApproved = card['is_approved'] ?? card['approval_status'] == 'approved' ?? false;
        final isReported = card['is_reported'] ?? false;
        
        // Determine the actual working status
        String workStatus = 'pending';
        if (isApproved) {
          if (actualStart != null && actualEnd == null) {
            workStatus = 'working'; // Currently working (checked in but not checked out)
          } else if (actualStart != null && actualEnd != null) {
            workStatus = 'completed'; // Finished working (checked in and checked out)
          } else {
            workStatus = 'approved'; // Approved but not started yet
          }
        }
        
        return {
          'date': date,
          'checkIn': checkInTime,
          'checkOut': checkOutTime,
          'hours': hoursWorked,
          'store': card['store_name'] ?? 'Store',
          'shiftInfo': '${card['shift_name'] ?? 'Shift'} • ${card['shift_time'] ?? '--:-- ~ --:--'}',
          'status': actualEnd != null ? 'completed' : 'in_progress',
          'lateMinutes': card['late_minutes'] ?? 0,
          'overtimeMinutes': card['overtime_minutes'] ?? 0,
          'isApproved': isApproved,
          'isReported': isReported,
          'workStatus': workStatus, // Add work status
          'rawCard': card, // Keep the raw card data for debugging
        };
      }).toList();
    
    // Toss-style activity section - Minimalist design
    if (recentActivities.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Text(
              'Activity',
              style: TossTextStyles.body.copyWith(
                color: TossColors.gray900,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: TossSpacing.space3),
            // Empty state - Simple and clean
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: TossSpacing.space4,
                vertical: TossSpacing.space6,
              ),
              decoration: BoxDecoration(
                color: TossColors.gray50,
                borderRadius: BorderRadius.circular(TossBorderRadius.lg),
              ),
              child: Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.event_busy,
                      size: 32,
                      color: TossColors.gray400,
                    ),
                    const SizedBox(height: TossSpacing.space3),
                    Text(
                      'No activity',
                      style: TossTextStyles.bodySmall.copyWith(
                        color: TossColors.gray500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Simple header with View All
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Activity',
                style: TossTextStyles.labelLarge.copyWith(
                  color: TossColors.gray700,
                  fontWeight: FontWeight.w600,
                ),
              ),
              // View All Button - Subtle text button
              GestureDetector(
                onTap: () {
                  _showAllAttendanceHistory();
                  HapticFeedback.selectionClick();
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: TossSpacing.space3,
                    vertical: TossSpacing.space2,
                  ),
                  child: Text(
                    'View All',
                    style: TossTextStyles.bodySmall.copyWith(
                      color: TossColors.gray500,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: TossSpacing.space3),
          // Activity List - Clean card design
          Container(
            decoration: BoxDecoration(
              color: TossColors.background,
              borderRadius: BorderRadius.circular(TossBorderRadius.lg),
              border: Border.all(
                color: TossColors.gray100,
                width: 1,
              ),
            ),
            child: Column(
              children: recentActivities.asMap().entries.map((entry) {
                final index = entry.key;
                final activity = entry.value;
                final date = activity['date'] as DateTime;
                final isLast = index == recentActivities.length - 1;
                
                return Column(
                  children: [
                    Material(
                      color: TossColors.transparent,
                      child: InkWell(
                        onTap: () {
                          _showActivityDetails(activity);
                          HapticFeedback.selectionClick();
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(TossSpacing.space4),
                          child: Row(
                            children: [
                              // Time info - Simplified
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Main time display - Show both confirm times
                                    Row(
                                      children: [
                                        Text(
                                          activity['checkIn'] as String,
                                          style: TossTextStyles.body.copyWith(
                                            color: activity['checkIn'] == '--:--' 
                                              ? TossColors.gray400 
                                              : TossColors.gray900,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Text(
                                          ' → ',
                                          style: TossTextStyles.body.copyWith(
                                            color: TossColors.gray400,
                                          ),
                                        ),
                                        Text(
                                          activity['checkOut'] as String,
                                          style: TossTextStyles.body.copyWith(
                                            color: activity['checkOut'] == '--:--' 
                                              ? TossColors.gray400 
                                              : TossColors.gray900,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: TossSpacing.space1),
                                    // Shift Name and Time
                                    Text(
                                      activity['shiftInfo'] as String,
                                      style: TossTextStyles.caption.copyWith(
                                        color: TossColors.gray500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Duration and status
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  // Duration
                                  Text(
                                    activity['hours'] as String,
                                    style: TossTextStyles.body.copyWith(
                                      color: TossColors.gray900,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: TossSpacing.space1),
                                  // Status indicators
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      // Work status
                                      Row(
                                        children: [
                                          Container(
                                            width: 6,
                                            height: 6,
                                            decoration: BoxDecoration(
                                              color: _getActivityStatusColor((activity['workStatus'] ?? 'pending').toString()),
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                          const SizedBox(width: TossSpacing.space1),
                                          Text(
                                            _getActivityStatusText((activity['workStatus'] ?? 'pending').toString()),
                                            style: TossTextStyles.caption.copyWith(
                                              color: TossColors.gray600,
                                            ),
                                          ),
                                        ],
                                      ),
                                      // Reported status if applicable
                                      if (activity['isReported'] as bool) ...[
                                        const SizedBox(height: 2),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.flag,
                                              size: 10,
                                              color: TossColors.error,
                                            ),
                                            const SizedBox(width: TossSpacing.space1),
                                            Text(
                                              'Reported',
                                              style: TossTextStyles.caption.copyWith(
                                                color: TossColors.error,
                                                fontSize: 10,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ],
                                  ),
                                ],
                              ),
                              // Chevron
                              const SizedBox(width: TossSpacing.space3),
                              Icon(
                                Icons.chevron_right,
                                color: TossColors.gray300,
                                size: 20,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Divider between items
                    if (!isLast)
                      Container(
                        height: 1,
                        color: TossColors.gray100,
                        margin: const EdgeInsets.symmetric(horizontal: TossSpacing.space4),
                      ),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
  
  String _getWeekdayShort(int weekday) {
    const weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return weekdays[weekday - 1];
  }
  
  void _showAllAttendanceHistory() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: TossColors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: BoxDecoration(
          color: TossColors.background,
          borderRadius: const BorderRadius.only(
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
                      decoration: BoxDecoration(
                        color: TossColors.gray50,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
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
                  
                  // Parse date
                  final dateStr = (card['request_date'] ?? '').toString();
                  final dateParts = dateStr.split('-');
                  final date = dateParts.length == 3
                    ? DateTime(
                        int.parse(dateParts[0].toString()),
                        int.parse(dateParts[1].toString()),
                        int.parse(dateParts[2].toString())
                      )
                    : DateTime.now();
                  
                  // Parse times
                  final actualStart = card['confirm_start_time'];
                  final actualEnd = card['confirm_end_time'];
                  String checkInTime = '--:--';
                  String checkOutTime = '--:--';
                  String hoursWorked = '0h 0m';
                  
                  if (actualStart != null && actualStart.toString().isNotEmpty) {
                    try {
                      if (actualStart.toString().contains(':')) {
                        final timeParts = actualStart.toString().split(':');
                        if (timeParts.length >= 2) {
                          checkInTime = '${timeParts[0].padLeft(2, '0')}:${timeParts[1].padLeft(2, '0')}';
                        }
                      }
                    } catch (e) {
                      checkInTime = '--:--';
                    }
                  }
                  
                  if (actualEnd != null && actualEnd.toString().isNotEmpty) {
                    try {
                      if (actualEnd.toString().contains(':')) {
                        final timeParts = actualEnd.toString().split(':');
                        if (timeParts.length >= 2) {
                          checkOutTime = '${timeParts[0].padLeft(2, '0')}:${timeParts[1].padLeft(2, '0')}';
                        }
                      }
                      
                      // Calculate hours worked
                      if (actualStart != null && actualEnd != null) {
                        try {
                          final startParts = actualStart.toString().split(':');
                          final endParts = actualEnd.toString().split(':');
                          if (startParts.length >= 2 && endParts.length >= 2) {
                            final startHour = int.parse(startParts[0]);
                            final startMin = int.parse(startParts[1]);
                            final endHour = int.parse(endParts[0]);
                            final endMin = int.parse(endParts[1]);
                            
                            var totalMinutes = (endHour * 60 + endMin) - (startHour * 60 + startMin);
                            if (totalMinutes < 0) totalMinutes += 24 * 60; // Handle overnight shifts
                            
                            final hours = totalMinutes ~/ 60;
                            final minutes = totalMinutes % 60;
                            hoursWorked = '${hours}h ${minutes}m';
                          }
                        } catch (e) {
                          // Keep default
                        }
                      }
                    } catch (e) {
                      checkOutTime = '--:--';
                    }
                  }
                  
                  final isApproved = card['is_approved'] ?? false;
                  final isReported = card['is_reported'] ?? false;
                  final shiftName = card['shift_name'] ?? 'Shift';
                  final shiftTime = card['shift_time'] ?? '--:-- ~ --:--';
                  
                  // Check if this is first item or if month changed
                  bool showMonthHeader = false;
                  String monthHeader = '';
                  if (index == 0) {
                    showMonthHeader = true;
                    monthHeader = '${_getMonthName(date.month)} ${date.year}';
                  } else {
                    final prevCard = allShiftCardsData[index - 1];
                    final prevDateStr = (prevCard['request_date'] ?? '').toString();
                    final prevDateParts = prevDateStr.split('-');
                    if (prevDateParts.length == 3) {
                      final prevMonth = int.parse(prevDateParts[1].toString());
                      if (prevMonth != date.month) {
                        showMonthHeader = true;
                        monthHeader = '${_getMonthName(date.month)} ${date.year}';
                      }
                    }
                  }
                  
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Month header if needed
                      if (showMonthHeader) ...[
                        if (index > 0) const SizedBox(height: TossSpacing.space4),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: TossSpacing.space1,
                            vertical: TossSpacing.space2,
                          ),
                          child: Text(
                            monthHeader,
                            style: TossTextStyles.caption.copyWith(
                              color: TossColors.gray500,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                        const SizedBox(height: TossSpacing.space2),
                      ],
                      
                      // Activity Card - Clean Toss style
                      Container(
                        margin: const EdgeInsets.only(bottom: TossSpacing.space2),
                        decoration: BoxDecoration(
                          color: TossColors.background,
                          borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                          border: Border.all(
                            color: TossColors.gray100,
                            width: 1,
                          ),
                        ),
                        child: Material(
                          color: TossColors.transparent,
                          child: InkWell(
                            onTap: () {
                              // Create activity object and show details
                              final activity = {
                                'date': date,
                                'checkIn': checkInTime,
                                'checkOut': checkOutTime,
                                'hours': hoursWorked,
                                'store': card['store_name'] ?? 'Store',
                                'status': actualEnd != null ? 'completed' : 'in_progress',
                                'isApproved': isApproved,
                                'rawCard': card,
                              };
                              Navigator.pop(context); // Close bottom sheet
                              _showActivityDetails(activity);
                              HapticFeedback.selectionClick();
                            },
                            borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                            child: Padding(
                              padding: const EdgeInsets.all(TossSpacing.space3),
                              child: Row(
                                children: [
                                  // Date - Compact
                                  Container(
                                    width: 44,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          date.day.toString(),
                                          style: TossTextStyles.body.copyWith(
                                            color: TossColors.gray900,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        Text(
                                          _getWeekdayShort(date.weekday),
                                          style: TossTextStyles.caption.copyWith(
                                            color: TossColors.gray500,
                                            fontSize: 10,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  
                                  // Vertical divider
                                  Container(
                                    height: 32,
                                    width: 1,
                                    color: TossColors.gray100,
                                    margin: const EdgeInsets.symmetric(horizontal: TossSpacing.space3),
                                  ),
                                  
                                  // Time and Store
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        // Time display - Always show both times
                                        Row(
                                          children: [
                                            Text(
                                              checkInTime,
                                              style: TossTextStyles.bodySmall.copyWith(
                                                color: checkInTime == '--:--' 
                                                  ? TossColors.gray400 
                                                  : TossColors.gray900,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            Text(
                                              ' → ',
                                              style: TossTextStyles.bodySmall.copyWith(
                                                color: TossColors.gray400,
                                              ),
                                            ),
                                            Text(
                                              checkOutTime,
                                              style: TossTextStyles.bodySmall.copyWith(
                                                color: checkOutTime == '--:--' 
                                                  ? TossColors.gray400 
                                                  : TossColors.gray900,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 2),
                                        // Shift Name and Time
                                        Text(
                                          '$shiftName • $shiftTime',
                                          style: TossTextStyles.caption.copyWith(
                                            color: TossColors.gray500,
                                            fontSize: 11,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  
                                  // Duration and status
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      // Duration
                                      Text(
                                        hoursWorked,
                                        style: TossTextStyles.bodySmall.copyWith(
                                          color: TossColors.gray700,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      // Status badges
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          // Approval status
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: TossSpacing.space2,
                                              vertical: 2,
                                            ),
                                            decoration: BoxDecoration(
                                              color: isApproved
                                                  ? TossColors.success.withOpacity(0.1)
                                                  : TossColors.warning.withOpacity(0.1),
                                              borderRadius: BorderRadius.circular(TossBorderRadius.xs),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Container(
                                                  width: 4,
                                                  height: 4,
                                                  decoration: BoxDecoration(
                                                    color: isApproved
                                                        ? TossColors.success
                                                        : TossColors.warning,
                                                    shape: BoxShape.circle,
                                                  ),
                                                ),
                                                const SizedBox(width: 4),
                                                Text(
                                                  isApproved ? 'Approved' : 'Pending',
                                                  style: TossTextStyles.caption.copyWith(
                                                    color: isApproved
                                                        ? TossColors.success
                                                        : TossColors.warning,
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          // Reported status if applicable
                                          if (isReported) ...[
                                            const SizedBox(height: 4),
                                            Container(
                                              padding: const EdgeInsets.symmetric(
                                                horizontal: TossSpacing.space2,
                                                vertical: 2,
                                              ),
                                              decoration: BoxDecoration(
                                                color: TossColors.error.withOpacity(0.1),
                                                borderRadius: BorderRadius.circular(TossBorderRadius.xs),
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Icon(
                                                    Icons.flag,
                                                    size: 10,
                                                    color: TossColors.error,
                                                  ),
                                                  const SizedBox(width: 3),
                                                  Text(
                                                    'Reported',
                                                    style: TossTextStyles.caption.copyWith(
                                                      color: TossColors.error,
                                                      fontSize: 10,
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  void _showQRScanner(bool isWorking) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: TossColors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: BoxDecoration(
          color: TossColors.background,
          borderRadius: const BorderRadius.only(
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
              child: Text(
                shiftStatus == 'working' ? 'Check Out' : 'Check In',
                style: TossTextStyles.h2.copyWith(
                  color: TossColors.gray900,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            
            // QR Scanner Area (Mock)
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(TossSpacing.space5),
                decoration: BoxDecoration(
                  color: TossColors.black,
                  borderRadius: BorderRadius.circular(TossBorderRadius.xl),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.qr_code_scanner,
                        color: TossColors.white,
                        size: 80,
                      ),
                      const SizedBox(height: TossSpacing.space4),
                      Text(
                        'Point at store QR code',
                        style: TossTextStyles.body.copyWith(
                          color: TossColors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
            // Info
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space5),
              child: Column(
                children: [
                  Text(
                    'Store A, Gangnam',
                    style: TossTextStyles.body.copyWith(
                      color: TossColors.gray700,
                    ),
                  ),
                  const SizedBox(height: TossSpacing.space1),
                  Text(
                    'Time: ${currentTime.hour.toString().padLeft(2, '0')}:${currentTime.minute.toString().padLeft(2, '0')}',
                    style: TossTextStyles.bodySmall.copyWith(
                      color: TossColors.gray600,
                    ),
                  ),
                ],
              ),
            ),
            
            // Cancel Button
            Padding(
              padding: const EdgeInsets.all(TossSpacing.space5),
              child: SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: TossSpacing.space4),
                  ),
                  child: Text(
                    'Cancel',
                    style: TossTextStyles.body.copyWith(
                      color: TossColors.gray600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
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
  
  Widget _buildCalendarGrid(DateTime focusedDate, DateTime selectedDate, Function(DateTime) onDateSelected, [List<Map<String, dynamic>>? shiftCardsData]) {
    return _buildCalendarGridStatic(focusedDate, selectedDate, onDateSelected, shiftCardsData ?? allShiftCardsData);
  }
  
  static Widget _buildCalendarGridStatic(DateTime focusedDate, DateTime selectedDate, Function(DateTime) onDateSelected, [List<Map<String, dynamic>>? shiftCardsData]) {
    // Use the passed shiftCardsData if available
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
    
    // Empty cells before first day of month
    for (int i = 1; i < firstWeekday; i++) {
      calendarDays.add(const SizedBox());
    }
    
    // Days of the month
    for (int day = 1; day <= daysInMonth; day++) {
      final date = DateTime(focusedDate.year, focusedDate.month, day);
      final isSelected = selectedDate.year == date.year &&
          selectedDate.month == date.month &&
          selectedDate.day == date.day;
      final isToday = DateTime.now().year == date.year &&
          DateTime.now().month == date.month &&
          DateTime.now().day == date.day;
      
      // Get shift data for this date
      final dateStr = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
      
      // Check if there are any shifts for this date in shiftsData
      final shiftsForDate = shiftsData.where(
        (card) => card['request_date'] == dateStr,
      ).toList();
      
      if (day == 1 || day == 31) {  // Debug first and last day of month
      }
      
      final hasShift = shiftsForDate.isNotEmpty;
      
      // Check approval status for shifts
      final hasApprovedShift = hasShift && shiftsForDate.any((card) => 
        card['is_approved'] ?? card['approval_status'] == 'approved' ?? false
      );
      final hasNonApprovedShift = hasShift && shiftsForDate.any((card) => 
        !(card['is_approved'] ?? card['approval_status'] == 'approved' ?? false)
      );
      
      calendarDays.add(
        InkWell(
          onTap: () => onDateSelected(date),
          borderRadius: BorderRadius.circular(TossBorderRadius.md),
          child: Container(
            margin: EdgeInsets.all(TossSpacing.space1 / 2),
            decoration: BoxDecoration(
              color: isSelected
                  ? TossColors.primary
                  : isToday
                      ? TossColors.primary.withOpacity(0.1)
                      : TossColors.transparent,
              borderRadius: BorderRadius.circular(TossBorderRadius.md),
              border: Border.all(
                color: isToday && !isSelected
                    ? TossColors.primary
                    : TossColors.transparent,
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
                      color: isSelected
                          ? TossColors.white
                          : TossColors.gray900,
                      fontWeight: isSelected || isToday
                          ? FontWeight.w600
                          : FontWeight.w400,
                    ),
                  ),
                ),
                if (hasShift)
                  Positioned(
                    bottom: 4,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Show green dot for approved shifts
                        if (hasApprovedShift)
                          Container(
                            width: 4,
                            height: 4,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? TossColors.white
                                  : TossColors.success,
                              shape: BoxShape.circle,
                            ),
                          ),
                        // Add spacing if both types exist
                        if (hasApprovedShift && hasNonApprovedShift)
                          const SizedBox(width: 2),
                        // Show orange dot for non-approved shifts
                        if (hasNonApprovedShift)
                          Container(
                            width: 4,
                            height: 4,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? TossColors.white
                                  : TossColors.warning,
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
        children: calendarDays,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
      ),
    );
  }
  
  static String _getMonthName(int month) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return months[month - 1];
  }
  
  String _getWeekdayFull(int weekday) {
    const days = [
      'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'
    ];
    return days[weekday - 1];
  }
  
  Color _getStatusColor(String status) {
    switch (status) {
      case 'working':
        return TossColors.success; // Green for currently working
      case 'finished':
        return TossColors.primary; // Blue for finished shift
      case 'scheduled':
        return TossColors.warning; // Orange for has shift today
      case 'off_duty':
      default:
        return TossColors.gray400; // Gray for off duty
    }
  }
  
  String _getStatusText(String status) {
    switch (status) {
      case 'working':
        return 'Working';
      case 'finished':
        return 'Finished';
      case 'scheduled':
        return 'Shift Today';
      case 'off_duty':
      default:
        return 'Off Duty';
    }
  }
  
  Color _getActivityStatusColor(String status) {
    switch (status) {
      case 'working':
        return TossColors.primary; // Blue for currently working
      case 'completed':
        return TossColors.success; // Green for completed shift
      case 'approved':
        return TossColors.success.withOpacity(0.7); // Lighter green for approved but not started
      case 'pending':
        return TossColors.warning; // Orange for pending approval
      default:
        return TossColors.gray400;
    }
  }
  
  String _getActivityStatusText(String status) {
    switch (status) {
      case 'working':
        return 'Working';
      case 'completed':
        return 'Completed';
      case 'approved':
        return 'Approved';
      case 'pending':
        return 'Pending';
      default:
        return 'Unknown';
    }
  }
  
  String _getWorkStatusFromCard(Map<String, dynamic> card) {
    final isApproved = card['is_approved'] ?? card['approval_status'] == 'approved' ?? false;
    final actualStart = card['confirm_start_time'] ?? card['actual_start_time'];
    final actualEnd = card['confirm_end_time'] ?? card['actual_end_time'];
    
    if (!isApproved) {
      return 'Pending Approval';
    }
    
    if (actualStart != null && actualEnd == null) {
      return 'Working';
    } else if (actualStart != null && actualEnd != null) {
      return 'Completed';
    } else {
      return 'Approved';
    }
  }
  
  Color _getWorkStatusColorFromCard(Map<String, dynamic> card) {
    final isApproved = card['is_approved'] ?? card['approval_status'] == 'approved' ?? false;
    final actualStart = card['confirm_start_time'] ?? card['actual_start_time'];
    final actualEnd = card['confirm_end_time'] ?? card['actual_end_time'];
    
    if (!isApproved) {
      return TossColors.warning;
    }
    
    if (actualStart != null && actualEnd == null) {
      return TossColors.primary; // Blue for working
    } else if (actualStart != null && actualEnd != null) {
      return TossColors.success; // Green for completed
    } else {
      return TossColors.success.withOpacity(0.7); // Lighter green for approved
    }
  }

  void _showActivityDetails(Map<String, dynamic> activity) {
    // Get the raw card data which contains all the shift information
    final cardData = activity['rawCard'] as Map<String, dynamic>?;
    if (cardData == null) {
      return;
    }
    
    // Capture the root context for ScaffoldMessenger
    final rootContext = context;
    
    // Parse date for better display
    final dateStr = (cardData['request_date'] ?? '').toString();
    final dateParts = dateStr.split('-');
    final date = dateParts.length == 3
      ? DateTime(
          int.parse(dateParts[0].toString()),
          int.parse(dateParts[1].toString()),
          int.parse(dateParts[2].toString())
        )
      : DateTime.now();

    // Get currency symbol from shift overview data
    final currencySymbol = shiftOverviewData?['currency_symbol'] ?? 'VND';

    // Parse shift time
    String shiftTime = (cardData['shift_time'] ?? '09:00 ~ 17:00').toString();
    shiftTime = shiftTime.replaceAll('~', ' ~ ');
    
    showModalBottomSheet(
      context: context,
      backgroundColor: TossColors.transparent,
      isScrollControlled: true,
      builder: (context) {
        // State variables for expandable sections
        bool isInfoExpanded = false;
        bool isActualAttendanceExpanded = false;
        
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.8,
            ),
            decoration: BoxDecoration(
              color: TossColors.background,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Handle bar - Toss style (thinner)
                Center(
                  child: Container(
                    margin: const EdgeInsets.only(top: TossSpacing.space2, bottom: TossSpacing.space4),
                    width: 36,
                    height: 4,
                    decoration: BoxDecoration(
                      color: TossColors.gray200,
                      borderRadius: BorderRadius.circular(TossBorderRadius.full),
                    ),
                  ),
                ),
                
                // Title - Centered with better weight
                Text(
                  'Shift Details',
                  style: TossTextStyles.h3.copyWith(
                    color: TossColors.gray900,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                
                const SizedBox(height: TossSpacing.space5),
                
                // Content with scroll
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Info Section Heading with expandable arrow
                        InkWell(
                          onTap: () {
                            setState(() {
                              isInfoExpanded = !isInfoExpanded;
                            });
                          },
                          borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: TossSpacing.space1),
                            child: Row(
                              children: [
                                Text(
                                  'Info',
                                  style: TossTextStyles.body.copyWith(
                                    color: TossColors.gray900,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(width: TossSpacing.space2),
                                Icon(
                                  isInfoExpanded 
                                    ? Icons.keyboard_arrow_up 
                                    : Icons.keyboard_arrow_down,
                                  size: 20,
                                  color: TossColors.gray600,
                                ),
                              ],
                            ),
                          ),
                        ),
                        
                        // Info section content (collapsible)
                        if (isInfoExpanded) ...[
                          const SizedBox(height: TossSpacing.space3),
                          // Basic Information Section - Clean rows without Store
                          _buildInfoRow('Date', '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}'),
                          const SizedBox(height: TossSpacing.space4),
                          
                          _buildInfoRow('Shift Time', shiftTime),
                          const SizedBox(height: TossSpacing.space4),
                          
                          // Work Status with proper detection
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Status',
                                style: TossTextStyles.body.copyWith(
                                  color: TossColors.gray500,
                                ),
                              ),
                              Text(
                                _getWorkStatusFromCard(cardData),
                                style: TossTextStyles.body.copyWith(
                                  color: _getWorkStatusColorFromCard(cardData),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          
                          // Late info if exists
                          if ((cardData['is_late'] ?? false) || (cardData['late_minutes'] ?? 0) > 0) ...[
                            const SizedBox(height: TossSpacing.space4),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Late',
                                  style: TossTextStyles.body.copyWith(
                                    color: TossColors.error,
                                  ),
                                ),
                                Text(
                                  '${cardData['late_minutes'] ?? 0} minutes',
                                  style: TossTextStyles.body.copyWith(
                                    color: TossColors.error,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                        
                        const SizedBox(height: TossSpacing.space6),
                        
                        // Actual Attendance Section Heading with expandable arrow
                        InkWell(
                          onTap: () {
                            setState(() {
                              isActualAttendanceExpanded = !isActualAttendanceExpanded;
                            });
                          },
                          borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: TossSpacing.space1),
                            child: Row(
                              children: [
                                Text(
                                  'Actual Attendance',
                                  style: TossTextStyles.body.copyWith(
                                    color: TossColors.gray900,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(width: TossSpacing.space2),
                                Icon(
                                  isActualAttendanceExpanded 
                                    ? Icons.keyboard_arrow_up 
                                    : Icons.keyboard_arrow_down,
                                  size: 20,
                                  color: TossColors.gray600,
                                ),
                              ],
                            ),
                          ),
                        ),
                        
                        // Actual Attendance section content (collapsible)
                        if (isActualAttendanceExpanded) ...[
                          const SizedBox(height: TossSpacing.space3),
                          
                          _buildInfoRow('Actual Check-in', _formatTime(cardData['actual_start_time'])),
                          const SizedBox(height: TossSpacing.space3),
                          _buildInfoRow('Actual Check-out', _formatTime(cardData['actual_end_time'])),
                          
                          const SizedBox(height: TossSpacing.space4),
                          
                          // Hours Section
                          _buildInfoRow('Scheduled Hours', '${cardData['scheduled_hours'] ?? 0.0} hours'),
                          const SizedBox(height: TossSpacing.space3),
                          _buildInfoRow('Paid Hours', '${cardData['paid_hours'] ?? 0} hours'),
                          
                          const SizedBox(height: TossSpacing.space4),
                          
                          // Salary information
                          _buildInfoRow('Salary Type', (cardData['salary_type'] ?? 'hourly').toString()),
                          const SizedBox(height: TossSpacing.space3),
                          _buildInfoRow('Salary per Hour', '$currencySymbol${_formatNumber(cardData['salary_amount'] ?? 0)}'),
                        ],
                        
                        const SizedBox(height: TossSpacing.space6),
                        
                        // Confirmed Attendance - Simpler design with light background (Always visible)
                        Container(
                            padding: const EdgeInsets.all(TossSpacing.space4),
                            decoration: BoxDecoration(
                              color: TossColors.info.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Confirmed Attendance',
                                  style: TossTextStyles.body.copyWith(
                                    color: TossColors.info,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: TossSpacing.space3),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Check-in',
                                      style: TossTextStyles.bodySmall.copyWith(
                                        color: TossColors.gray500,
                                      ),
                                    ),
                                    Text(
                                      _formatTime(cardData['confirm_start_time']),
                                      style: TossTextStyles.body.copyWith(
                                        color: TossColors.gray900,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: TossSpacing.space2),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Check-out',
                                      style: TossTextStyles.bodySmall.copyWith(
                                        color: TossColors.gray500,
                                      ),
                                    ),
                                    Text(
                                      _formatTime(cardData['confirm_end_time']),
                                      style: TossTextStyles.body.copyWith(
                                        color: TossColors.gray900,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          
                          const SizedBox(height: TossSpacing.space4),
                          
                          // Base Pay and Bonus Amount in blue box
                          Container(
                            padding: const EdgeInsets.all(TossSpacing.space4),
                            decoration: BoxDecoration(
                              color: TossColors.info.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Base Pay',
                                      style: TossTextStyles.bodySmall.copyWith(
                                        color: TossColors.gray500,
                                      ),
                                    ),
                                    Text(
                                      '$currencySymbol${_formatNumber(cardData['base_pay'] ?? 0)}',
                                      style: TossTextStyles.body.copyWith(
                                        color: TossColors.gray900,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: TossSpacing.space2),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Bonus Amount',
                                      style: TossTextStyles.bodySmall.copyWith(
                                        color: TossColors.gray500,
                                      ),
                                    ),
                                    Text(
                                      '$currencySymbol${_formatNumber(cardData['bonus_amount'] ?? 0)}',
                                      style: TossTextStyles.body.copyWith(
                                        color: TossColors.gray900,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          
                          const SizedBox(height: TossSpacing.space6),
                          
                          // Divider
                          Container(
                            height: 1,
                            color: TossColors.gray100,
                          ),
                          
                          const SizedBox(height: TossSpacing.space4),
                          
                          // Total Pay - More prominent
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Total Pay',
                                style: TossTextStyles.body.copyWith(
                                  color: TossColors.gray900,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                '$currencySymbol${_formatNumber(cardData['total_pay_with_bonus'] ?? '0')}',
                                style: TossTextStyles.h2.copyWith(
                                  color: TossColors.info,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                          
                          const SizedBox(height: TossSpacing.space5),
                  
                        // Show reported status if already reported
                        if (cardData['is_reported'] ?? false) ...[
                          Container(
                            padding: const EdgeInsets.all(TossSpacing.space4),
                            decoration: BoxDecoration(
                              color: TossColors.warning.withOpacity(0.06),
                              borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                              border: Border.all(
                                color: TossColors.warning.withOpacity(0.15),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.info_outline_rounded,
                                  color: TossColors.warning,
                                  size: 20,
                                ),
                                const SizedBox(width: TossSpacing.space3),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Issue Reported',
                                        style: TossTextStyles.body.copyWith(
                                          color: TossColors.warning,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        (cardData['is_problem_solved'] ?? false)
                                            ? 'Your report has been resolved'
                                            : 'Your report is being reviewed',
                                        style: TossTextStyles.bodySmall.copyWith(
                                          color: TossColors.gray600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: TossSpacing.space5),
                        ],
                        
                        // Report Issue Button - Toss style with better visibility
                        Container(
                          width: double.infinity,
                          height: 52,
                          decoration: BoxDecoration(
                            color: (cardData['is_reported'] ?? false) || !(cardData['is_approved'] ?? false)
                                ? TossColors.gray50
                                : TossColors.background,
                            borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                            border: Border.all(
                              color: (cardData['is_reported'] ?? false) || !(cardData['is_approved'] ?? false)
                                  ? TossColors.gray100
                                  : TossColors.gray200,
                              width: 1,
                            ),
                          ),
                          child: Material(
                            color: TossColors.transparent,
                            child: InkWell(
                              onTap: (cardData['is_reported'] ?? false) || !(cardData['is_approved'] ?? false)
                                  ? null  // Disable if already reported OR not approved
                                  : () async {
                                final shiftRequestId = cardData['shift_request_id'];
                                if (shiftRequestId == null) {
                                  // Show error if no shift request ID
                                  if (mounted) {
                                    await showDialog<bool>(
                                      context: rootContext,
                                      barrierDismissible: true,
                                      builder: (context) => TossDialog.error(
                                        title: 'Unable to Report Issue',
                                        message: 'Missing shift ID',
                                        primaryButtonText: 'OK',
                                      ),
                                    );
                                  }
                                  return;
                                }
                                
                                HapticFeedback.selectionClick();
                                
                                // Show the report issue dialog
                                await _showReportIssueDialog(shiftRequestId, cardData);
                              },
                              borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: TossSpacing.space3,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.flag_outlined,
                                      size: 20,
                                      color: (cardData['is_reported'] ?? false) || !(cardData['is_approved'] ?? false)
                                          ? TossColors.gray300
                                          : TossColors.gray600,
                                    ),
                                    const SizedBox(width: TossSpacing.space2),
                                    Text(
                                      'Report Issue',
                                      style: TossTextStyles.body.copyWith(
                                        fontWeight: FontWeight.w500,
                                        color: (cardData['is_reported'] ?? false) || !(cardData['is_approved'] ?? false)
                                            ? TossColors.gray300
                                            : TossColors.gray700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        
                        // Add safe area padding below Report Issue button
                        SizedBox(height: MediaQuery.of(context).padding.bottom + TossSpacing.space5),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
          },
        );
      },
    );
  }
  
  Widget _buildMinimalRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TossTextStyles.body.copyWith(
            color: TossColors.gray600,
          ),
        ),
        Text(
          value,
          style: TossTextStyles.body.copyWith(
            color: TossColors.gray900,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
  
  Widget _buildCleanRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TossTextStyles.body.copyWith(
            color: TossColors.gray600,
          ),
        ),
        Text(
          value,
          style: TossTextStyles.body.copyWith(
            color: TossColors.gray900,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
  
  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TossTextStyles.body.copyWith(
            color: TossColors.gray500,
          ),
        ),
        Text(
          value,
          style: TossTextStyles.body.copyWith(
            color: TossColors.gray900,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
  
  Widget _buildDetailRow(String label, String value, {bool isHighlighted = false, Color? highlightColor, bool isSubtle = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: TossSpacing.space1),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TossTextStyles.body.copyWith(
              color: isHighlighted 
                  ? highlightColor 
                  : isSubtle 
                      ? TossColors.gray600 
                      : TossColors.gray700,
              fontSize: isSubtle ? 14 : null,
              fontWeight: isSubtle ? FontWeight.w500 : FontWeight.w600,
            ),
          ),
          Text(
            value,
            style: TossTextStyles.body.copyWith(
              color: isHighlighted 
                  ? highlightColor 
                  : isSubtle 
                      ? TossColors.gray600 
                      : TossColors.gray900,
              fontWeight: isHighlighted ? FontWeight.w600 : FontWeight.w500,
              fontSize: isSubtle ? 14 : null,
            ),
          ),
        ],
      ),
    );
  }
  
  String _formatNumber(dynamic value) {
    if (value == null) return '0';
    if (value is String) {
      // Remove any existing commas and try to parse
      final cleanValue = value.replaceAll(',', '');
      final parsed = int.tryParse(cleanValue);
      if (parsed != null) {
        return parsed.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]},',
        );
      }
      return value;
    }
    if (value is num) {
      return value.toInt().toString().replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (Match m) => '${m[1]},',
      );
    }
    return value.toString();
  }
  
  String _formatTime(dynamic time) {
    if (time == null || time.toString().isEmpty) {
      return '--:--';
    }

    final timeStr = time.toString();

    try {
      // If it's already in HH:mm format (just time, no date)
      if (timeStr.contains(':') && !timeStr.contains('T') && timeStr.length < 10) {
        final parts = timeStr.split(':');
        if (parts.length >= 2) {
          return '${parts[0].padLeft(2, '0')}:${parts[1].padLeft(2, '0')}';
        }
      }

      // If it's a datetime string (UTC from DB - need to convert to local time)
      if (timeStr.contains('T') || timeStr.length > 10) {
        // Convert UTC to local time using DateTimeUtils
        final dateTime = DateTimeUtils.toLocal(timeStr);
        return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
      }

      // If it's just HH:mm:ss format, take first 5 chars
      if (timeStr.length >= 5) {
        return timeStr.substring(0, 5);
      }

      return timeStr;
    } catch (e) {
      // If all parsing fails, try to extract HH:mm from the string
      if (timeStr.length >= 5) {
        return timeStr.substring(0, 5);
      }
      return '--:--';
    }
  }

  Future<void> _showReportIssueDialog(String shiftRequestId, Map<String, dynamic> cardData) async {
    final TextEditingController reasonController = TextEditingController();
    bool isSubmitting = false;

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setDialogState) {
            return Dialog(
              backgroundColor: TossColors.surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(TossBorderRadius.xl),
              ),
              child: Container(
                padding: const EdgeInsets.all(TossSpacing.space5),
                width: MediaQuery.of(context).size.width * 0.9,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(TossSpacing.space2),
                          decoration: BoxDecoration(
                            color: TossColors.error.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(TossBorderRadius.md),
                          ),
                          child: Icon(
                            Icons.flag_outlined,
                            color: TossColors.error,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: TossSpacing.space3),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Report Issue',
                                style: TossTextStyles.h4.copyWith(
                                  color: TossColors.gray900,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Please describe the problem',
                                style: TossTextStyles.bodySmall.copyWith(
                                  color: TossColors.gray600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: isSubmitting ? null : () => Navigator.of(dialogContext).pop(),
                          icon: Icon(
                            Icons.close_rounded,
                            color: TossColors.gray600,
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: TossSpacing.space5),
                    
                    // Text field for reason
                    Container(
                      decoration: BoxDecoration(
                        color: TossColors.gray50,
                        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                        border: Border.all(
                          color: TossColors.gray200,
                          width: 1,
                        ),
                      ),
                      child: TextField(
                        controller: reasonController,
                        maxLines: 4,
                        maxLength: 500,
                        enabled: !isSubmitting,
                        onChanged: (value) {
                          // Update the dialog state to enable/disable the report button
                          setDialogState(() {});
                        },
                        decoration: InputDecoration(
                          hintText: 'Enter the reason for reporting this issue...',
                          hintStyle: TossTextStyles.body.copyWith(
                            color: TossColors.gray400,
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.all(TossSpacing.space4),
                          counterStyle: TossTextStyles.bodySmall.copyWith(
                            color: TossColors.gray500,
                          ),
                        ),
                        style: TossTextStyles.body.copyWith(
                          color: TossColors.gray900,
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: TossSpacing.space5),
                    
                    // Action buttons
                    Row(
                      children: [
                        Expanded(
                          child: TextButton(
                            onPressed: isSubmitting ? null : () => Navigator.of(dialogContext).pop(),
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: TossSpacing.space3),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                              ),
                            ),
                            child: Text(
                              'Cancel',
                              style: TossTextStyles.body.copyWith(
                                color: TossColors.gray600,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: TossSpacing.space3),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: isSubmitting || reasonController.text.trim().isEmpty
                                ? null
                                : () async {
                                    final reason = reasonController.text.trim();
                                    if (reason.isEmpty) {
                                      await showDialog<bool>(
                                        context: context,
                                        barrierDismissible: true,
                                        builder: (context) => TossDialog.error(
                                          title: 'Validation Error',
                                          message: 'Please enter a reason',
                                          primaryButtonText: 'OK',
                                        ),
                                      );
                                      return;
                                    }

                                    setDialogState(() {
                                      isSubmitting = true;
                                    });

                                    try {
                                      // Report shift issue via datasource (handles UTC conversion)
                                      final datasource = ref.read(attendanceDatasourceProvider);
                                      final success = await datasource.reportShiftIssue(
                                        shiftRequestId: shiftRequestId,
                                        reportReason: reason,
                                      );

                                      if (!success) {
                                        throw Exception('Failed to report shift issue');
                                      }

                                      // Update local card data with current time in UTC (will be converted to local on next fetch)
                                      final nowUtc = DateTime.now().toUtc().toIso8601String();
                                      cardData['is_reported'] = true;
                                      cardData['report_time'] = nowUtc;
                                      cardData['report_reason'] = reason;
                                      cardData['is_problem_solved'] = false;

                                      // Close the report dialog
                                      Navigator.of(dialogContext).pop();
                                      
                                      // Close the shift details bottom sheet
                                      Navigator.of(context).pop();

                                      // Refresh the main page data
                                      _fetchMonthData(selectedDate);
                                      
                                      // Show centered success popup
                                      if (mounted) {
                                        showDialog(
                                          context: context,
                                          barrierDismissible: false,
                                          builder: (BuildContext successContext) {
                                            // Auto-dismiss after 2 seconds
                                            Future.delayed(const Duration(seconds: 2), () {
                                              if (Navigator.of(successContext).canPop()) {
                                                Navigator.of(successContext).pop();
                                              }
                                            });
                                            
                                            return Dialog(
                                              backgroundColor: TossColors.transparent,
                                              elevation: 0,
                                              child: Container(
                                                padding: const EdgeInsets.all(TossSpacing.space5),
                                                decoration: BoxDecoration(
                                                  color: TossColors.surface,
                                                  borderRadius: BorderRadius.circular(TossBorderRadius.xl),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: TossColors.black.withOpacity(0.1),
                                                      blurRadius: 20,
                                                      offset: const Offset(0, 10),
                                                    ),
                                                  ],
                                                ),
                                                child: Column(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    // Success icon
                                                    Container(
                                                      width: 64,
                                                      height: 64,
                                                      decoration: BoxDecoration(
                                                        color: TossColors.success.withOpacity(0.1),
                                                        shape: BoxShape.circle,
                                                      ),
                                                      child: Icon(
                                                        Icons.check_circle_rounded,
                                                        color: TossColors.success,
                                                        size: 36,
                                                      ),
                                                    ),
                                                    const SizedBox(height: TossSpacing.space4),
                                                    // Success title
                                                    Text(
                                                      'Report Submitted',
                                                      style: TossTextStyles.h4.copyWith(
                                                        color: TossColors.gray900,
                                                        fontWeight: FontWeight.w700,
                                                      ),
                                                    ),
                                                    const SizedBox(height: TossSpacing.space2),
                                                    // Success message
                                                    Text(
                                                      'Your issue has been reported\nand will be reviewed soon',
                                                      textAlign: TextAlign.center,
                                                      style: TossTextStyles.body.copyWith(
                                                        color: TossColors.gray600,
                                                        height: 1.5,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      }
                                    } catch (e) {
                                      setDialogState(() {
                                        isSubmitting = false;
                                      });
                                      
                                      // Close the report dialog
                                      Navigator.of(dialogContext).pop();
                                      
                                      if (mounted) {
                                        // Show error popup
                                        showDialog(
                                          context: context,
                                          barrierDismissible: true,
                                          builder: (BuildContext errorContext) {
                                            return Dialog(
                                              backgroundColor: TossColors.transparent,
                                              elevation: 0,
                                              child: Container(
                                                padding: const EdgeInsets.all(TossSpacing.space5),
                                                decoration: BoxDecoration(
                                                  color: TossColors.surface,
                                                  borderRadius: BorderRadius.circular(TossBorderRadius.xl),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: TossColors.black.withOpacity(0.1),
                                                      blurRadius: 20,
                                                      offset: const Offset(0, 10),
                                                    ),
                                                  ],
                                                ),
                                                child: Column(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    // Error icon
                                                    Container(
                                                      width: 64,
                                                      height: 64,
                                                      decoration: BoxDecoration(
                                                        color: TossColors.error.withOpacity(0.1),
                                                        shape: BoxShape.circle,
                                                      ),
                                                      child: Icon(
                                                        Icons.error_outline_rounded,
                                                        color: TossColors.error,
                                                        size: 36,
                                                      ),
                                                    ),
                                                    const SizedBox(height: TossSpacing.space4),
                                                    // Error title
                                                    Text(
                                                      'Report Failed',
                                                      style: TossTextStyles.h4.copyWith(
                                                        color: TossColors.gray900,
                                                        fontWeight: FontWeight.w700,
                                                      ),
                                                    ),
                                                    const SizedBox(height: TossSpacing.space2),
                                                    // Error message
                                                    Text(
                                                      'Failed to report issue.\nPlease try again later.',
                                                      textAlign: TextAlign.center,
                                                      style: TossTextStyles.body.copyWith(
                                                        color: TossColors.gray600,
                                                        height: 1.5,
                                                      ),
                                                    ),
                                                    const SizedBox(height: TossSpacing.space4),
                                                    // OK button
                                                    ElevatedButton(
                                                      onPressed: () {
                                                        Navigator.of(errorContext).pop();
                                                      },
                                                      style: ElevatedButton.styleFrom(
                                                        backgroundColor: TossColors.primary,
                                                        padding: const EdgeInsets.symmetric(
                                                          horizontal: TossSpacing.space6,
                                                          vertical: TossSpacing.space3,
                                                        ),
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                                                        ),
                                                      ),
                                                      child: Text(
                                                        'OK',
                                                        style: TossTextStyles.body.copyWith(
                                                          color: TossColors.surface,
                                                          fontWeight: FontWeight.w600,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      }
                                    }
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isSubmitting || reasonController.text.trim().isEmpty
                                  ? TossColors.gray200
                                  : TossColors.error,
                              padding: const EdgeInsets.symmetric(vertical: TossSpacing.space3),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                              ),
                            ),
                            child: isSubmitting
                                ? SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(TossColors.gray400),
                                    ),
                                  )
                                : Text(
                                    'Report',
                                    style: TossTextStyles.body.copyWith(
                                      color: TossColors.surface,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _navigateToDate(DateTime date) {
    setState(() {
      selectedDate = date;
    });
    _updateCenterDate(date);
  }
}

