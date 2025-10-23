// ignore_for_file: avoid_dynamic_calls, inference_failure_on_function_invocation, argument_type_not_assignable, invalid_assignment, non_bool_condition, non_bool_negation_expression, non_bool_operand, use_of_void_result
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_text_styles.dart';
import '../../../../shared/themes/toss_spacing.dart';
import '../../../../app/providers/app_state_provider.dart';
import '../../../../shared/widgets/common/toss_scaffold.dart';
import '../../../../shared/widgets/common/toss_app_bar_1.dart';
import '../../../../shared/widgets/common/toss_loading_view.dart';
import '../../../../shared/widgets/toss/toss_selection_bottom_sheet.dart';
import '../../../../shared/themes/toss_border_radius.dart';
import '../../../../shared/widgets/common/toss_calendar_bottom_sheet.dart';
import '../../../../shared/widgets/common/toss_success_error_dialog.dart';

// Bottom sheets
import '../widgets/bottom_sheets/shift_details_bottom_sheet.dart';
import '../widgets/bottom_sheets/add_shift_bottom_sheet.dart';

// Providers
import '../providers/time_table_providers.dart';

class TimeTableManagePage extends ConsumerStatefulWidget {
  const TimeTableManagePage({super.key});

  @override
  ConsumerState<TimeTableManagePage> createState() => _TimeTableManagePageState();
}

class _TimeTableManagePageState extends ConsumerState<TimeTableManagePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  DateTime selectedDate = DateTime.now();
  DateTime focusedMonth = DateTime.now();
  String? selectedStoreId;
  
  // ScrollController for Schedule tab
  final ScrollController _scheduleScrollController = ScrollController();
  
  // Store shift metadata and monthly status
  dynamic shiftMetadata; // Store shift metadata from RPC
  List<dynamic> monthlyShiftData = []; // Store the array response from get_monthly_shift_status_manager
  Set<String> loadedMonths = {}; // Track which months we've already loaded (format: "YYYY-MM")
  bool isLoadingMetadata = false;
  bool isLoadingShiftStatus = false;
  
  // Track selected shift requests (shift_id + user_name combination) - Multi-select
  Set<String> selectedShiftRequests = {};
  Map<String, bool> selectedShiftApprovalStates = {}; // Track approval states for each selected shift
  Map<String, String> selectedShiftRequestIds = {}; // Track actual shift_request_ids for RPC call
  
  // Manager overview data - store by month key "YYYY-MM"
  Map<String, Map<String, dynamic>> managerOverviewDataByMonth = {};
  bool isLoadingOverview = false;
  
  // Preload profile images for faster loading
  void _preloadProfileImages(List<dynamic> shiftData) {
    for (var dayData in shiftData) {
      final shifts = dayData['shifts'] as List<dynamic>? ?? [];
      for (var shift in shifts) {
        final pendingEmployees = shift['pending_employees'] as List<dynamic>? ?? [];
        final approvedEmployees = shift['approved_employees'] as List<dynamic>? ?? [];
        
        for (var employee in [...pendingEmployees, ...approvedEmployees]) {
          final profileImage = employee['profile_image'] as String?;
          if (profileImage != null && profileImage.isNotEmpty) {
            // Preload image using precacheImage
            precacheImage(
              CachedNetworkImageProvider(profileImage),
              context,
            ).catchError((error) {
              // Ignore preload errors
            });
          }
        }
      }
    }
  }
  
  // Manage tab selected date for week view
  DateTime manageSelectedDate = DateTime.now();
  
  // Manager shift cards data - store by month key "YYYY-MM"
  Map<String, Map<String, dynamic>> managerCardsDataByMonth = {};
  bool isLoadingCards = false;
  
  // Filter state for manage tab - default to 'approved'
  String? selectedFilter = 'approved'; // null = 'all', 'problem', 'approved', 'pending'
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this, initialIndex: 0);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        HapticFeedback.selectionClick();
        // Fetch overview data when switching to Manage tab
        if (_tabController.index == 0 && selectedStoreId != null) {
          fetchManagerOverview();
          fetchManagerCards();
        }
      }
    });
    
    // Initialize selectedStoreId from app state
    final appState = ref.read(appStateProvider);
    selectedStoreId = appState.storeChoosen.isNotEmpty ? appState.storeChoosen : null;

    // Fetch initial data if store is selected
    if (selectedStoreId != null) {
      fetchShiftMetadata(selectedStoreId!);
      fetchMonthlyShiftStatus();
      // Also fetch overview data
      fetchManagerOverview();
      fetchManagerCards();
    } else {
    }
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    _scheduleScrollController.dispose();
    super.dispose();
  }
  
  // Helper widget for common spacing
  
  @override
  Widget build(BuildContext context) {
    return TossScaffold(
      appBar: TossAppBar1(
        title: 'Time Table Manage',
        backgroundColor: TossColors.background,
      ),
      backgroundColor: TossColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Tab Bar
            Container(
              color: TossColors.background,
              child: Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: TossSpacing.space5,
                      vertical: TossSpacing.space3,
                    ),
                    height: 44,
                    decoration: BoxDecoration(
                      color: TossColors.gray100,
                      borderRadius: BorderRadius.circular(TossBorderRadius.xxl),
                    ),
                    padding: const EdgeInsets.all(2),
                    child: AnimatedBuilder(
                      animation: _tabController,
                      builder: (context, child) {
                        return Stack(
                          children: [
                            // Animated selection indicator
                            AnimatedAlign(
                              alignment: _tabController.index == 1 
                                ? Alignment.centerRight 
                                : Alignment.centerLeft,
                              duration: Duration(milliseconds: 250),
                              curve: Curves.easeInOut,
                              child: FractionallySizedBox(
                                widthFactor: 0.5,
                                child: Container(
                                  margin: EdgeInsets.symmetric(horizontal: 2),
                                  decoration: BoxDecoration(
                                    color: TossColors.white,
                                    borderRadius: BorderRadius.circular(TossBorderRadius.xxl),
                                    boxShadow: [
                                      BoxShadow(
                                        color: TossColors.black.withValues(alpha: 0.08),
                                        blurRadius: 8,
                                        offset: Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            // Tab buttons
                            Row(
                              children: [
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      if (_tabController.index != 0) {
                                        _tabController.animateTo(0);
                                        HapticFeedback.lightImpact();
                                      }
                                    },
                                    child: Container(
                                      color: TossColors.transparent,
                                      child: Center(
                                        child: AnimatedDefaultTextStyle(
                                          duration: Duration(milliseconds: 200),
                                          style: TossTextStyles.bodySmall.copyWith(
                                            color: _tabController.index == 0 
                                              ? TossColors.gray900 
                                              : TossColors.gray600,
                                            fontWeight: _tabController.index == 0 
                                              ? FontWeight.w700 
                                              : FontWeight.w500,
                                          ),
                                          child: Text('Manage'),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      if (_tabController.index != 1) {
                                        _tabController.animateTo(1);
                                        HapticFeedback.lightImpact();
                                      }
                                    },
                                    child: Container(
                                      color: TossColors.transparent,
                                      child: Center(
                                        child: AnimatedDefaultTextStyle(
                                          duration: Duration(milliseconds: 200),
                                          style: TossTextStyles.bodySmall.copyWith(
                                            color: _tabController.index == 1 
                                              ? TossColors.gray900 
                                              : TossColors.gray600,
                                            fontWeight: _tabController.index == 1 
                                              ? FontWeight.w700 
                                              : FontWeight.w500,
                                          ),
                                          child: Text('Schedule'),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      },
                    ),
              ),
            ),
            // Tab Content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildManageTab(),
                  _buildScheduleTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  // Fetch shift metadata from Repository
  Future<void> fetchShiftMetadata(String storeId) async {
    if (storeId.isEmpty) return;


    setState(() {
      isLoadingMetadata = true;
    });

    try {
      // Get raw shift list directly from datasource (RPC returns List, not Map)
      final rawData = await ref.read(timeTableDatasourceProvider).getShiftMetadata(storeId: storeId);


      setState(() {
        shiftMetadata = rawData;  // Store raw list for UI
        isLoadingMetadata = false;
      });


    } catch (e) {
      setState(() {
        isLoadingMetadata = false;
        shiftMetadata = <dynamic>[];  // Set empty list on error
      });
    }
  }
  
  // Fetch monthly shift status for manager from Supabase RPC
  Future<void> fetchMonthlyShiftStatus({DateTime? forDate, bool forceRefresh = false}) async {
    if (selectedStoreId == null || selectedStoreId!.isEmpty) return;

    // Use provided date or selected date
    final targetDate = forDate ?? selectedDate;
    final monthKey = '${targetDate.year}-${targetDate.month.toString().padLeft(2, '0')}';


    // Check if we already have data for this month (unless force refresh is requested)
    if (!forceRefresh && loadedMonths.contains(monthKey)) {
      return;
    }


    setState(() {
      isLoadingShiftStatus = true;
    });
    
    try {
      // Format date as YYYY-MM-DD for the first day of the month
      final requestDate = '${targetDate.year}-${targetDate.month.toString().padLeft(2, '0')}-01';

      final appState = ref.read(appStateProvider);


      final statusList = await ref.read(timeTableRepositoryProvider).getMonthlyShiftStatus(
        requestDate: requestDate,
        companyId: appState.companyChoosen,
        storeId: selectedStoreId!,
      );

      // Convert entities to the Map format expected by UI
      final List<Map<String, dynamic>> response = statusList.expand((status) {
        return status.dailyShifts.map((daily) {
          return {
            'request_date': daily.date, // yyyy-MM-dd format
            'shifts': daily.shifts.map((shiftWithReqs) {
              // Extract time strings from DateTime
              final startTimeStr = '${shiftWithReqs.shift.planStartTime.hour.toString().padLeft(2, '0')}:${shiftWithReqs.shift.planStartTime.minute.toString().padLeft(2, '0')}';
              final endTimeStr = '${shiftWithReqs.shift.planEndTime.hour.toString().padLeft(2, '0')}:${shiftWithReqs.shift.planEndTime.minute.toString().padLeft(2, '0')}';

              return {
                'shift_id': shiftWithReqs.shift.shiftId,
                'shift_name': shiftWithReqs.shift.shiftName,
                'start_time': startTimeStr,
                'end_time': endTimeStr,
                'pending_employees': shiftWithReqs.pendingRequests.map((req) {
                  // Split userName into first and last name (fallback logic)
                  final nameParts = req.employee.userName.split(' ');
                  return {
                    'shift_request_id': req.shiftRequestId,
                    'user_id': req.employee.userId,
                    'user_name': req.employee.userName,
                    'user_first_name': nameParts.isNotEmpty ? nameParts[0] : req.employee.userName,
                    'user_last_name': nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '',
                    'profile_image': req.employee.profileImage,
                    'is_approved': req.isApproved,
                  };
                }).toList(),
                'approved_employees': shiftWithReqs.approvedRequests.map((req) {
                  // Split userName into first and last name (fallback logic)
                  final nameParts = req.employee.userName.split(' ');
                  return {
                    'shift_request_id': req.shiftRequestId,
                    'user_id': req.employee.userId,
                    'user_name': req.employee.userName,
                    'user_first_name': nameParts.isNotEmpty ? nameParts[0] : req.employee.userName,
                    'user_last_name': nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '',
                    'profile_image': req.employee.profileImage,
                    'is_approved': req.isApproved,
                  };
                }).toList(),
              };
            }).toList(),
          };
        });
      }).toList();

      if (response.isNotEmpty) {
      }

      setState(() {
        // Append new data to existing data (don't replace)
        // Remove any duplicate dates before adding
        final existingDates = monthlyShiftData.map((item) => item['request_date']).toSet();
        final newData = response.where((item) => !existingDates.contains(item['request_date'])).toList();


        monthlyShiftData.addAll(newData);


        // Preload profile images for faster loading
        _preloadProfileImages(newData);

        // Mark the months as loaded (current month and next month)
        loadedMonths.add(monthKey);
        // Also mark the next month as loaded since RPC returns 2 months
        final nextMonth = DateTime(targetDate.year, targetDate.month + 1);
        final nextMonthKey = '${nextMonth.year}-${nextMonth.month.toString().padLeft(2, '0')}';
        loadedMonths.add(nextMonthKey);


        isLoadingShiftStatus = false;
      });
      
    } catch (e) {
      setState(() {
        isLoadingShiftStatus = false;
      });
    }
  }
  
  // Fetch manager overview data from Supabase RPC
  Future<void> fetchManagerOverview({DateTime? forDate, bool forceRefresh = false}) async {
    if (selectedStoreId == null || selectedStoreId!.isEmpty) return;

    // Use provided date or manageSelectedDate for Manage tab
    final targetDate = forDate ?? manageSelectedDate;
    final monthKey = '${targetDate.year}-${targetDate.month.toString().padLeft(2, '0')}';

    // Check if we already have data for this month (unless force refresh is requested)
    if (!forceRefresh && managerOverviewDataByMonth.containsKey(monthKey)) {
      return;
    }

    setState(() {
      isLoadingOverview = true;
    });
    
    try {
      // Calculate first and last day of the month
      final firstDay = DateTime(targetDate.year, targetDate.month, 1);
      final lastDay = DateTime(targetDate.year, targetDate.month + 1, 0);

      // Format dates as yyyy-MM-dd
      final startDate = '${firstDay.year}-${firstDay.month.toString().padLeft(2, '0')}-${firstDay.day.toString().padLeft(2, '0')}';
      final endDate = '${lastDay.year}-${lastDay.month.toString().padLeft(2, '0')}-${lastDay.day.toString().padLeft(2, '0')}';

      // Get company ID from app state
      final appState = ref.read(appStateProvider);
      final companyId = appState.companyChoosen;

      if (companyId.isEmpty) {
        setState(() {
          isLoadingOverview = false;
        });
        return;
      }

      // Use repository instead of direct Supabase call
      final overview = await ref.read(timeTableRepositoryProvider).getManagerOverview(
        startDate: startDate,
        endDate: endDate,
        storeId: selectedStoreId!,
        companyId: companyId,
      );


      // Convert Entity to Map matching the expected format
      // _getMonthlyStatValue expects: { 'stores': [{ 'monthly_stats': [{ ... }] }] }
      // Field names must match what UI looks for: total_requests, total_problems, total_approved, total_pending
      final overviewData = {
        'stores': [
          {
            'monthly_stats': [
              {
                'total_requests': overview.totalShifts,  // UI looks for 'total_requests'
                'total_problems': overview.additionalStats['total_problems'] ?? 0,  // UI looks for 'total_problems'
                'total_approved': overview.totalApprovedRequests,  // UI looks for 'total_approved'
                'total_pending': overview.totalPendingRequests,  // UI looks for 'total_pending'
                'total_employees': overview.totalEmployees,
                'total_cost': overview.totalEstimatedCost,
              }
            ],
          }
        ],
      };

      final stores = overviewData['stores'] as List;
      final monthlyStats = (stores[0] as Map)['monthly_stats'] as List;
      final stats = monthlyStats[0] as Map;

      setState(() {
        managerOverviewDataByMonth[monthKey] = overviewData;
        isLoadingOverview = false;
      });

      
    } catch (e) {
      setState(() {
        isLoadingOverview = false;
      });
    }
  }
  
  // Fetch manager shift cards from Supabase RPC
  Future<void> fetchManagerCards({DateTime? forDate, bool forceRefresh = false}) async {
    if (selectedStoreId == null || selectedStoreId!.isEmpty) return;

    // Use provided date or manageSelectedDate for Manage tab
    final targetDate = forDate ?? manageSelectedDate;
    final monthKey = '${targetDate.year}-${targetDate.month.toString().padLeft(2, '0')}';

    // Check if we already have data for this month (unless force refresh is requested)
    if (!forceRefresh && managerCardsDataByMonth.containsKey(monthKey)) {
      return;
    }

    setState(() {
      isLoadingCards = true;
    });

    try {
      // Calculate first and last day of the month
      final firstDay = DateTime(targetDate.year, targetDate.month, 1);
      final lastDay = DateTime(targetDate.year, targetDate.month + 1, 0);

      // Format dates as yyyy-MM-dd
      final startDate = '${firstDay.year}-${firstDay.month.toString().padLeft(2, '0')}-${firstDay.day.toString().padLeft(2, '0')}';
      final endDate = '${lastDay.year}-${lastDay.month.toString().padLeft(2, '0')}-${lastDay.day.toString().padLeft(2, '0')}';

      // Get company ID from app state
      final appState = ref.read(appStateProvider);
      final companyId = appState.companyChoosen;

      if (companyId.isEmpty) {
        setState(() {
          isLoadingCards = false;
        });
        return;
      }

      // Use repository instead of direct Supabase call
      final cardsData = await ref.read(timeTableRepositoryProvider).getManagerShiftCards(
        startDate: startDate,
        endDate: endDate,
        companyId: companyId,
        storeId: selectedStoreId!,
      );


      setState(() {
        managerCardsDataByMonth[monthKey] = cardsData;
        isLoadingCards = false;
      });

      // Extract cards count for logging
      final stores = cardsData['stores'] as List<dynamic>?;
      final cardsCount = stores?.isNotEmpty == true
        ? (stores!.first as Map<String, dynamic>)['cards']?.length ?? 0
        : 0;


    } catch (e, stackTrace) {
      setState(() {
        isLoadingCards = false;
      });
    }
  }
  
  String _getMonthName(int month) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return months[month - 1];
  }
  
  // Show calendar popup for Manage tab
  Future<void> _showManageCalendarPopup() async {
    // Show calendar with StatefulBuilder to allow indicator updates
    DateTime tempSelectedDate = manageSelectedDate;
    DateTime displayMonth = manageSelectedDate;

    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: TossColors.transparent,
      isScrollControlled: true,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
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
                      'Select Date',
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
                      onPressed: () async {
                        final newMonth = DateTime(displayMonth.year, displayMonth.month - 1);
                        setModalState(() {
                          displayMonth = newMonth;
                        });
                        // Fetch data for the new month
                        await fetchManagerOverview(forDate: newMonth);
                        await fetchManagerCards(forDate: newMonth);
                        // Force refresh of the modal to show the updated indicators
                        setModalState(() {});
                      },
                      icon: const Icon(Icons.chevron_left, color: TossColors.gray700),
                    ),
                    Text(
                      '${_getMonthName(displayMonth.month)} ${displayMonth.year}',
                      style: TossTextStyles.body.copyWith(
                        color: TossColors.gray900,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    IconButton(
                      onPressed: () async {
                        final newMonth = DateTime(displayMonth.year, displayMonth.month + 1);
                        setModalState(() {
                          displayMonth = newMonth;
                        });
                        // Fetch data for the new month
                        await fetchManagerOverview(forDate: newMonth);
                        await fetchManagerCards(forDate: newMonth);
                        // Force refresh of the modal to show the updated indicators
                        setModalState(() {});
                      },
                      icon: const Icon(Icons.chevron_right, color: TossColors.gray700),
                    ),
                  ],
                ),
              ),

              // Calendar
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space5),
                  child: _buildCalendarGrid(
                    displayMonth,
                    tempSelectedDate,
                    (date) async {
                      setModalState(() {
                        tempSelectedDate = date;
                      });
                      setState(() {
                        manageSelectedDate = date;
                      });
                      Navigator.pop(context);
                      HapticFeedback.selectionClick();
                      // Fetch data for the selected date's month if not already loaded
                      await fetchManagerOverview(forDate: date);
                      await fetchManagerCards(forDate: date);
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Build calendar grid for popup
  Widget _buildCalendarGrid(DateTime displayMonth, DateTime selectedDate, void Function(DateTime) onDateSelected) {
    final firstDay = DateTime(displayMonth.year, displayMonth.month, 1);
    final lastDay = DateTime(displayMonth.year, displayMonth.month + 1, 0);
    final daysInMonth = lastDay.day;
    final firstWeekday = firstDay.weekday;

    // Get the month key for the displayed month
    final monthKey = '${displayMonth.year}-${displayMonth.month.toString().padLeft(2, '0')}';

    // Process cards data to find dates with problems, pending, approved shifts
    final indicators = _buildDateIndicatorsForMonth(monthKey);

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
      final date = DateTime(displayMonth.year, displayMonth.month, day);
      final dateStr = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

      final isSelected = date.day == selectedDate.day &&
                        date.month == selectedDate.month &&
                        date.year == selectedDate.year;
      final isToday = date.day == today.day &&
                      date.month == today.month &&
                      date.year == today.year;

      final indicatorType = indicators[dateStr] ?? TossCalendarIndicatorType.none;

      calendarDays.add(
        InkWell(
          onTap: () => onDateSelected(date),
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

  // Get indicator color based on type
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

  // Build date indicators for a specific month
  Map<String, TossCalendarIndicatorType> _buildDateIndicatorsForMonth(String monthKey) {
    final indicators = <String, TossCalendarIndicatorType>{};
    final monthData = managerCardsDataByMonth[monthKey];

    if (monthData != null && monthData['stores'] != null) {
      final stores = monthData['stores'] as List<dynamic>? ?? [];
      if (stores.isNotEmpty) {
        final storeData = stores.first as Map<String, dynamic>;
        final cards = storeData['cards'] as List<dynamic>? ?? [];

        for (var card in cards) {
          final requestDate = card['request_date'] as String?;
          if (requestDate != null) {
            final isProblem = (card['is_problem'] == true) && (card['is_problem_solved'] != true);
            final isApproved = card['is_approved'] ?? false;

            // Priority: Problem > Pending > Approved
            if (isProblem) {
              indicators[requestDate] = TossCalendarIndicatorType.problem;
            } else if (!isApproved && !indicators.containsKey(requestDate)) {
              // Only set pending if not already marked as problem
              indicators[requestDate] = TossCalendarIndicatorType.pending;
            } else if (isApproved && !indicators.containsKey(requestDate)) {
              // Only set approved if not already marked as problem or pending
              indicators[requestDate] = TossCalendarIndicatorType.approved;
            }
          }
        }
      }
    }

    return indicators;
  }

  // Show store selector with Toss-style bottom sheet
  void _showStoreSelector(List<dynamic> stores) async {
    final selectedStore = await TossStoreSelector.show(
      context: context,
      stores: stores,
      selectedStoreId: selectedStoreId,
      title: 'Select Store',
    );

    if (selectedStore != null) {
      setState(() {
        selectedStoreId = selectedStore['store_id'] as String?;
        // Clear cached data when switching stores
        monthlyShiftData = [];
        loadedMonths.clear();
        // Clear selection when switching stores
        selectedShiftRequests.clear();
        selectedShiftApprovalStates.clear();
        selectedShiftRequestIds.clear();
        // Clear overview data when switching stores
        managerOverviewDataByMonth.clear();
        managerCardsDataByMonth.clear();
      });

      // Update app state with the new store selection
      ref.read(appStateProvider.notifier).selectStore(
        selectedStore['store_id'] as String,
        storeName: selectedStore['store_name'] as String?,
      );

      // Fetch data for the new store
      await fetchShiftMetadata(selectedStore['store_id']);
      await fetchMonthlyShiftStatus();
      // Fetch overview data if on Manage tab
      if (_tabController.index == 1) {
        await fetchManagerOverview();
        await fetchManagerCards();
      }
    }
  }
  
  Widget _buildCalendar() {
    final firstDayOfMonth = DateTime(focusedMonth.year, focusedMonth.month, 1);
    final lastDayOfMonth = DateTime(focusedMonth.year, focusedMonth.month + 1, 0);
    final daysInMonth = lastDayOfMonth.day;
    final firstWeekday = firstDayOfMonth.weekday;
    
    List<Widget> calendarDays = [];
    
    // Week day headers - Toss Style
    const weekDays = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    for (int i = 0; i < weekDays.length; i++) {
      final isWeekend = i >= 5;
      calendarDays.add(
        Center(
          child: Text(
            weekDays[i],
            style: TossTextStyles.caption.copyWith(
              color: isWeekend ? TossColors.gray400 : TossColors.gray500,
              fontWeight: FontWeight.w500,
              fontSize: 12,
            ),
          ),
        ),
      );
    }
    
    // Empty cells before first day of month
    for (int i = 1; i < firstWeekday; i++) {
      calendarDays.add(const SizedBox());
    }
    
    // Days of the month - Toss Style
    for (int day = 1; day <= daysInMonth; day++) {
      final date = DateTime(focusedMonth.year, focusedMonth.month, day);
      final isSelected = selectedDate.year == date.year &&
          selectedDate.month == date.month &&
          selectedDate.day == date.day;
      final isToday = DateTime.now().year == date.year &&
          DateTime.now().month == date.month &&
          DateTime.now().day == date.day;
      final isWeekend = date.weekday >= 6;
      
      // Check shift status for this date
      final dateStr = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
      
      // Determine dot color based on shift status
      Color? dotColor;
      
      // Only show dots if we have both shift metadata and monthly data loaded
      if (shiftMetadata != null && shiftMetadata is List && (shiftMetadata as List).isNotEmpty && monthlyShiftData.isNotEmpty) {
        // Find data for this date
        Map<String, dynamic>? dayData;
        for (var data in monthlyShiftData) {
          if (data['request_date'] == dateStr) {
            dayData = data;
            break;
          }
        }
        
        if (dayData != null) {
          // We have data for this date
          final shifts = dayData['shifts'] as List? ?? [];
          final allShifts = shiftMetadata as List;
          
          // Priority 1: Check if ANY shift has 0 approved employees
          // This includes checking if all required shifts have coverage
          bool hasShiftWithNoApproved = false;
          bool hasUnderStaffedShiftWithPending = false;
          bool allShiftsFullyStaffed = true;
          
          // First, check all active shifts from metadata
          Set<String> coveredShiftIds = {};
          Map<String, Map<String, dynamic>> shiftDataMap = {};
          
          // Build a map of shift data for easy lookup
          for (var shift in shifts) {
            final shiftId = shift['shift_id'];
            coveredShiftIds.add(shiftId);
            shiftDataMap[shiftId] = shift;
          }
          
          // Check each active shift from metadata
          for (var metaShift in allShifts) {
            if (metaShift['is_active'] == true) {
              final shiftId = metaShift['shift_id'];
              
              if (!coveredShiftIds.contains(shiftId)) {
                // This shift has no employees at all (not in the shifts array)
                hasShiftWithNoApproved = true;
                break;
              } else {
                // Check the shift data
                final shiftData = shiftDataMap[shiftId];
                final approvedCount = shiftData?['approved_count'] ?? 0;
                final requiredEmployees = shiftData?['required_employees'] ?? 1;
                final pendingCount = shiftData?['pending_count'] ?? 0;
                
                if (approvedCount == 0) {
                  // This shift has 0 approved employees
                  hasShiftWithNoApproved = true;
                  break;
                } else if (approvedCount < requiredEmployees) {
                  // Under-staffed
                  allShiftsFullyStaffed = false;
                  if (pendingCount > 0) {
                    hasUnderStaffedShiftWithPending = true;
                  }
                }
              }
            }
          }
          
          // Determine the dot color based on priorities
          if (hasShiftWithNoApproved) {
            // RED: Priority 1 - At least one shift has no approved employees
            dotColor = TossColors.error;
          } else if (hasUnderStaffedShiftWithPending) {
            // ORANGE: Priority 2 - Under-staffed shifts with pending employees to approve
            dotColor = TossColors.warning;
          } else if (allShiftsFullyStaffed) {
            // GREEN: Priority 3 - All shifts meet or exceed required employees
            dotColor = TossColors.success;
          } else {
            // RED: Under-staffed but no pending employees (nothing to approve)
            dotColor = TossColors.error;
          }
        } else {
          // No data for this date means no shifts registered
          dotColor = TossColors.error;
        }
      }
      
      calendarDays.add(
        InkWell(
          onTap: () {
            setState(() {
              selectedDate = date;
              // Clear selection when changing dates
              selectedShiftRequests.clear();
              selectedShiftApprovalStates.clear();
              selectedShiftRequestIds.clear();
            });
            HapticFeedback.selectionClick();
            // Fetch shift status for the selected date
            fetchMonthlyShiftStatus();
            // Fetch overview data if on Manage tab and month changed
            if (_tabController.index == 1) {
              fetchManagerOverview();
            }
          },
          borderRadius: BorderRadius.circular(TossBorderRadius.lg),
          child: Container(
            margin: EdgeInsets.all(TossSpacing.space1 / 2),
            decoration: BoxDecoration(
              color: isSelected
                  ? TossColors.primary
                  : isToday
                      ? TossColors.primary.withValues(alpha: 0.1)
                      : TossColors.transparent,
              borderRadius: BorderRadius.circular(TossBorderRadius.lg),
              border: isToday && !isSelected
                  ? Border.all(color: TossColors.primary, width: 1.5)
                  : null,
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        day.toString(),
                        style: TossTextStyles.body.copyWith(
                          color: isSelected
                              ? TossColors.white
                              : isWeekend
                                  ? TossColors.gray400
                                  : TossColors.gray900,
                          fontWeight: isSelected || isToday
                              ? FontWeight.w700
                              : FontWeight.w400,
                          fontSize: 15,
                        ),
                      ),
                      if (dotColor != null)
                        Container(
                          margin: const EdgeInsets.only(top: 2),
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: isSelected
                                ? TossColors.white
                                : dotColor,
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
    
    return GridView.count(
      crossAxisCount: 7,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      childAspectRatio: 1,
      children: calendarDays,
    );
  }
  
  // Build shift data section
  Widget _buildShiftDataSection({DateTime? useDate}) {
    // Format the selected date - use provided date or selectedDate (for Schedule tab)
    final targetDate = useDate ?? selectedDate;
    final dateStr = '${targetDate.year}-${targetDate.month.toString().padLeft(2, '0')}-${targetDate.day.toString().padLeft(2, '0')}';


    // Find the data for the selected date from the array
    List<dynamic> employeeShifts = [];

    for (var dayData in monthlyShiftData) {
      if (dayData['request_date'] == dateStr) {
        employeeShifts = dayData['shifts'] as List<dynamic>? ?? [];
        if (employeeShifts.isNotEmpty) {
        }
        break;
      }
    }

    if (employeeShifts.isEmpty) {
      if (monthlyShiftData.isNotEmpty) {
      }
    }

    if (shiftMetadata is List) {

      // Filter active shifts
      final activeShifts = (shiftMetadata as List).where((shift) => shift['is_active'] == true).toList();

      if ((shiftMetadata as List).isNotEmpty) {

        // Log all shifts with is_active status
        for (var i = 0; i < (shiftMetadata as List).length; i++) {
          final shift = (shiftMetadata as List)[i];
        }
      }
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: TossSpacing.space5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Show ALL store shifts (from metadata) regardless of employee assignments
          if (shiftMetadata != null && shiftMetadata is List && (shiftMetadata as List).isNotEmpty) ...[
            Text(
              'Shift Schedule',
              style: TossTextStyles.bodyLarge.copyWith(
                color: TossColors.gray900,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: TossSpacing.space2),
            ...(shiftMetadata as List).where((shift) =>
              shift['is_active'] == true  // Filter only active shifts
            ).map((shift) {
              final shiftId = shift['shift_id'];
              final shiftName = shift['shift_name'] ?? 'Unknown Shift';
              final startTime = shift['start_time'] ?? shift['shift_start_time'] ?? '--:--';
              final endTime = shift['end_time'] ?? shift['shift_end_time'] ?? '--:--';
              
              // Debug: Print shift data
              
              // Find matching employee data from the RPC response
              final List<Map<String, dynamic>> assignedEmployees = [];
              
              // Look for this shift in the employee shifts data
              if (employeeShifts.isNotEmpty) {
                for (var empShift in employeeShifts) {
                  if (empShift['shift_id'] == shiftId || empShift['shift_name'] == shiftName) {
                    // Add pending employees
                    final pendingList = empShift['pending_employees'] as List<dynamic>? ?? [];
                    for (var emp in pendingList) {
                      assignedEmployees.add({
                        'user_name': emp['user_name'] ?? 'Unknown',
                        'is_approved': false,
                        'shift_request_id': emp['shift_request_id'] ?? '',
                        'profile_image': emp['profile_image'],
                      });
                    }
                    
                    // Add approved employees
                    final approvedList = empShift['approved_employees'] as List<dynamic>? ?? [];
                    for (var emp in approvedList) {
                      assignedEmployees.add({
                        'user_name': emp['user_name'] ?? 'Unknown',
                        'is_approved': true,
                        'shift_request_id': emp['shift_request_id'] ?? '',
                        'profile_image': emp['profile_image'],
                      });
                    }
                    break; // Found the matching shift
                  }
                }
              }
              
              
              final hasEmployee = assignedEmployees.isNotEmpty;
              
              return Container(
                margin: const EdgeInsets.only(bottom: TossSpacing.space3),
                decoration: BoxDecoration(
                  color: TossColors.background,
                  borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                  border: Border.all(
                    color: hasEmployee 
                        ? (assignedEmployees.any((e) => e['is_approved'] == true) 
                            ? TossColors.success.withValues(alpha: 0.3) 
                            : TossColors.warning.withValues(alpha: 0.3))
                        : TossColors.error.withValues(alpha: 0.2),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: TossColors.black.withValues(alpha: 0.04),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Shift Header
                    Container(
                      padding: const EdgeInsets.all(TossSpacing.space3),
                      decoration: BoxDecoration(
                        color: hasEmployee 
                            ? TossColors.gray50 
                            : TossColors.error.withValues(alpha: 0.05),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(11),
                          topRight: Radius.circular(11),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: hasEmployee 
                                  ? TossColors.primary.withValues(alpha: 0.1)
                                  : TossColors.error.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(TossBorderRadius.md),
                            ),
                            child: Icon(
                              Icons.access_time,
                              size: 18,
                              color: hasEmployee 
                                  ? TossColors.primary 
                                  : TossColors.error,
                            ),
                          ),
                          const SizedBox(width: TossSpacing.space3),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  shiftName,
                                  style: TossTextStyles.body.copyWith(
                                    color: TossColors.gray900,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Text(
                                  '$startTime - $endTime',
                                  style: TossTextStyles.bodySmall.copyWith(
                                    color: TossColors.gray600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (!hasEmployee)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: TossSpacing.space2,
                                vertical: TossSpacing.space1,
                              ),
                              decoration: BoxDecoration(
                                color: TossColors.error.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                              ),
                              child: Text(
                                'Empty',
                                style: TossTextStyles.caption.copyWith(
                                  color: TossColors.error,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    
                    // Employee Assignments
                    if (hasEmployee) 
                      ...assignedEmployees.map((empShift) {
                        final userName = empShift['user_name'] ?? 'Unknown Employee';
                        final isApproved = empShift['is_approved'] ?? false;
                        final shiftRequestIdFromData = empShift['shift_request_id'] ?? '';
                        final profileImage = empShift['profile_image'] as String?;
                        
                        // Create unique identifier for this shift request
                        final shiftRequestId = '${shiftId}_$userName';
                        final isSelected = selectedShiftRequests.contains(shiftRequestId);
                        
                        return InkWell(
                          onTap: () {
                            // Handle shift click
                            HapticFeedback.selectionClick();
                            setState(() {
                              // Toggle multi-selection - if already selected, deselect; otherwise add to selection
                              if (selectedShiftRequests.contains(shiftRequestId)) {
                                selectedShiftRequests.remove(shiftRequestId);
                                selectedShiftApprovalStates.remove(shiftRequestId);
                                selectedShiftRequestIds.remove(shiftRequestId);
                              } else {
                                selectedShiftRequests.add(shiftRequestId);
                                selectedShiftApprovalStates[shiftRequestId] = isApproved;
                                selectedShiftRequestIds[shiftRequestId] = shiftRequestIdFromData;
                                
                                // Auto-scroll to show the Approve button
                                // Delay to allow setState to complete and UI to update
                                Future.delayed(const Duration(milliseconds: 100), () {
                                  if (_scheduleScrollController.hasClients) {
                                    // Calculate the position to scroll to
                                    // We want to scroll to the bottom to show the button
                                    _scheduleScrollController.animateTo(
                                      _scheduleScrollController.position.maxScrollExtent,
                                      duration: const Duration(milliseconds: 500),
                                      curve: Curves.easeInOut,
                                    );
                                  }
                                });
                              }
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.all(TossSpacing.space3),
                            decoration: BoxDecoration(
                              color: isSelected 
                                  ? TossColors.primary.withValues(alpha: 0.08)
                                  : (isApproved 
                                      ? TossColors.success.withValues(alpha: 0.03)
                                      : TossColors.warning.withValues(alpha: 0.03)),
                              border: Border(
                                top: BorderSide(
                                  color: TossColors.gray100,
                                  width: 1,
                                ),
                                left: BorderSide(
                                  color: isSelected 
                                      ? TossColors.primary 
                                      : TossColors.transparent,
                                  width: 3,
                                ),
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 32,
                                  height: 32,
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? TossColors.primary.withValues(alpha: 0.15)
                                        : (isApproved 
                                            ? TossColors.success.withValues(alpha: 0.1)
                                            : TossColors.warning.withValues(alpha: 0.1)),
                                    shape: BoxShape.circle,
                                  ),
                                  child: isSelected
                                      ? Icon(
                                          Icons.check_circle,
                                          size: 16,
                                          color: TossColors.primary,
                                        )
                                      : profileImage != null && profileImage.isNotEmpty
                                          ? ClipOval(
                                              child: CachedNetworkImage(
                                                imageUrl: profileImage,
                                                width: 32,
                                                height: 32,
                                                fit: BoxFit.cover,
                                                memCacheWidth: 96, // 3x size for better quality on high-DPI displays
                                                memCacheHeight: 96,
                                                maxWidthDiskCache: 96,
                                                maxHeightDiskCache: 96,
                                                placeholder: (context, url) => Icon(
                                                  Icons.person_outline,
                                                  size: 16,
                                                  color: isApproved 
                                                      ? TossColors.success 
                                                      : TossColors.warning,
                                                ),
                                                errorWidget: (context, url, error) => Icon(
                                                  Icons.person_outline,
                                                  size: 16,
                                                  color: isApproved 
                                                      ? TossColors.success 
                                                      : TossColors.warning,
                                                ),
                                                fadeInDuration: const Duration(milliseconds: 200),
                                                fadeOutDuration: const Duration(milliseconds: 100),
                                              ),
                                            )
                                          : Icon(
                                              Icons.person_outline,
                                              size: 16,
                                              color: isApproved 
                                                  ? TossColors.success 
                                                  : TossColors.warning,
                                            ),
                                ),
                                const SizedBox(width: TossSpacing.space2),
                                Expanded(
                                  child: Text(
                                    userName,
                                    style: TossTextStyles.body.copyWith(
                                      color: isSelected 
                                          ? TossColors.primary 
                                          : TossColors.gray900,
                                      fontWeight: isSelected 
                                          ? FontWeight.w600 
                                          : FontWeight.w500,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: TossSpacing.space2,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? TossColors.primary.withValues(alpha: 0.15)
                                        : (isApproved 
                                            ? TossColors.success.withValues(alpha: 0.1)
                                            : TossColors.warning.withValues(alpha: 0.1)),
                                    borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                                    border: isSelected 
                                        ? Border.all(
                                            color: TossColors.primary.withValues(alpha: 0.3),
                                            width: 1,
                                          )
                                        : null,
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      if (isSelected)
                                        Icon(
                                          Icons.check,
                                          size: 12,
                                          color: TossColors.primary,
                                        ),
                                      if (isSelected) const SizedBox(width: 2),
                                      Text(
                                        isSelected ? 'Selected' : (isApproved ? 'Approved' : 'Pending'),
                                        style: TossTextStyles.caption.copyWith(
                                          color: isSelected
                                              ? TossColors.primary
                                              : (isApproved 
                                                  ? TossColors.success 
                                                  : TossColors.warning),
                                          fontWeight: FontWeight.w600,
                                          fontSize: 11,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList()
                    else
                      Container(
                        padding: const EdgeInsets.all(TossSpacing.space3),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.warning_amber_rounded,
                              size: 16,
                              color: TossColors.error.withValues(alpha: 0.7),
                            ),
                            const SizedBox(width: TossSpacing.space2),
                            Text(
                              'No employee assigned',
                              style: TossTextStyles.bodySmall.copyWith(
                                color: TossColors.error.withValues(alpha: 0.7),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              );
            }).toList(),
          ] else if (!isLoadingMetadata) ...[
            Container(
              padding: const EdgeInsets.all(TossSpacing.space4),
              decoration: BoxDecoration(
                color: TossColors.gray50,
                borderRadius: BorderRadius.circular(TossBorderRadius.md),
              ),
              child: Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.info_outline,
                      size: 24,
                      color: TossColors.gray400,
                    ),
                    const SizedBox(height: TossSpacing.space2),
                    Text(
                      'No shift data available',
                      style: TossTextStyles.body.copyWith(
                        color: TossColors.gray500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
  
  // Helper function to get shift status for a specific date
  Map<String, bool> _getDateShiftStatus(DateTime date) {
    final monthKey = '${date.year}-${date.month.toString().padLeft(2, '0')}';
    final monthData = managerCardsDataByMonth[monthKey];
    
    if (monthData == null || monthData['stores'] == null) {
      return {'hasApproved': false, 'hasPending': false, 'hasProblem': false};
    }
    
    final stores = monthData['stores'] as List<dynamic>? ?? [];
    if (stores.isEmpty) {
      return {'hasApproved': false, 'hasPending': false, 'hasProblem': false};
    }
    
    final storeData = stores.first as Map<String, dynamic>;
    final cards = storeData['cards'] as List<dynamic>? ?? [];
    
    final dateStr = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    final dateCards = cards.where((card) => card['request_date'] == dateStr).toList();
    
    bool hasApproved = false;
    bool hasPending = false;
    bool hasProblem = false;
    
    for (var card in dateCards) {
      // Check for problem (is_problem = true AND is_problem_solved = false)
      if (card['is_problem'] == true && card['is_problem_solved'] != true) {
        hasProblem = true;
      }
      
      // Check for approved
      if (card['is_approved'] == true) {
        hasApproved = true;
      } else {
        // If not approved, it's pending
        hasPending = true;
      }
    }
    
    return {
      'hasApproved': hasApproved,
      'hasPending': hasPending,
      'hasProblem': hasProblem,
    };
  }
  
  // Helper function to get monthly stat value from overview data
  String _getMonthlyStatValue(String statKey) {
    // Get data for the currently selected month
    final monthKey = '${manageSelectedDate.year}-${manageSelectedDate.month.toString().padLeft(2, '0')}';
    final monthData = managerOverviewDataByMonth[monthKey];
    
    if (monthData == null || monthData['stores'] == null) {
      return '0';
    }
    
    final stores = monthData['stores'] as List<dynamic>? ?? [];
    if (stores.isEmpty) {
      return '0';
    }
    
    // Get first store's monthly stats
    final storeData = stores.first as Map<String, dynamic>;
    final monthlyStats = storeData['monthly_stats'] as List<dynamic>? ?? [];
    
    if (monthlyStats.isEmpty) {
      return '0';
    }
    
    // Get the first (and usually only) monthly stat
    final monthStat = monthlyStats.first as Map<String, dynamic>;
    final value = monthStat[statKey];
    
    return value?.toString() ?? '0';
  }
  
  // Build Manage Tab Content
  Widget _buildManageTab() {
    final monthName = _getMonthName(manageSelectedDate.month);  // Use selected month, not current month
    final selectedMonthName = _getMonthName(manageSelectedDate.month);

    final today = DateTime.now();
    
    if (isLoadingOverview) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(TossSpacing.space10),
          child: const TossLoadingView(
          ),
        ),
      );
    }
    
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Monthly Overview Section
          Container(
            margin: const EdgeInsets.all(TossSpacing.space5),
            padding: const EdgeInsets.all(TossSpacing.space5),
            decoration: BoxDecoration(
              color: TossColors.primarySurface,
              borderRadius: BorderRadius.circular(TossBorderRadius.xxl),
            ),
            child: SizedBox(
              width: double.infinity,
              child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // Header
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$monthName ${manageSelectedDate.year}',
                      style: TossTextStyles.h2.copyWith(
                        color: TossColors.gray900,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Monthly Overview',
                      style: TossTextStyles.bodySmall.copyWith(
                        color: TossColors.gray500,
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: TossSpacing.space5),
                
                // Stats Grid
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  childAspectRatio: 1.45,
                  mainAxisSpacing: TossSpacing.space3,
                  crossAxisSpacing: TossSpacing.space3,
                  children: [
                    // Total Request
                    _buildStatCard(
                      icon: Icons.calendar_today,
                      iconColor: TossColors.primary,
                      backgroundColor: TossColors.background,  // Changed to white
                      title: 'Total Request',
                      value: _getMonthlyStatValue('total_requests'),
                      subtitle: 'requests',
                      filterType: 'all',
                    ),
                    
                    // Problem
                    _buildStatCard(
                      icon: Icons.warning_amber_rounded,
                      iconColor: TossColors.error,
                      backgroundColor: TossColors.errorLight,
                      title: 'Problem',
                      value: _getMonthlyStatValue('total_problems'),
                      subtitle: 'issues',
                      filterType: 'problem',
                    ),
                    
                    // Total Approve
                    _buildStatCard(
                      icon: Icons.check_circle,
                      iconColor: TossColors.success,
                      backgroundColor: TossColors.successLight,
                      title: 'Total Approve',
                      value: _getMonthlyStatValue('total_approved'),
                      subtitle: 'approved',
                      filterType: 'approved',
                    ),
                    
                    // Pending
                    _buildStatCard(
                      icon: Icons.access_time,
                      iconColor: TossColors.warning,
                      backgroundColor: TossColors.warningLight,
                      title: 'Pending',
                      value: _getMonthlyStatValue('total_pending'),
                      subtitle: 'pending',
                      filterType: 'pending',
                    ),
                  ],
                ),
              ],
            ),
            ),
          ),
          
          // This Week Schedule Section
          Container(
            margin: const EdgeInsets.symmetric(horizontal: TossSpacing.space5),
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
                        const SizedBox(height: 4),
                        Text(
                          '$selectedMonthName ${manageSelectedDate.year}',
                          style: TossTextStyles.bodySmall.copyWith(
                            color: TossColors.gray500,
                          ),
                        ),
                      ],
                    ),
                    // View Calendar Button
                    InkWell(
                      onTap: () {
                        _showManageCalendarPopup();
                        HapticFeedback.selectionClick();
                      },
                      borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: TossSpacing.space3,
                          vertical: TossSpacing.space2,
                        ),
                        decoration: BoxDecoration(
                          color: TossColors.gray50,
                          borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.calendar_month,
                              size: 18,
                              color: TossColors.gray600,
                            ),
                            const SizedBox(width: TossSpacing.space1),
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
                  ],
                ),
                
                const SizedBox(height: TossSpacing.space4),
                
                // Week Days - 7 days with selected date in center
                Container(
                  height: 100,
                  child: Row(
                    children: List.generate(7, (index) {
                      // Calculate dates with selected date in center (index 3)
                      final offset = index - 3;
                      final date = manageSelectedDate.add(Duration(days: offset));
                      final isSelected = index == 3; // Center position
                      final isToday = date.day == today.day && 
                                      date.month == today.month && 
                                      date.year == today.year;
                      
                      // Get day name
                      const dayNames = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
                      final dayName = dayNames[date.weekday % 7];
                      
                      // Get shift status for this date
                      final shiftStatus = _getDateShiftStatus(date);
                      
                      return Expanded(
                        child: InkWell(
                          onTap: () async {
                            setState(() {
                              manageSelectedDate = date;
                            });
                            HapticFeedback.selectionClick();
                            // Fetch data for the selected date's month if not already loaded
                            await fetchManagerOverview(forDate: date);
                            await fetchManagerCards(forDate: date);
                          },
                          borderRadius: BorderRadius.circular(isSelected ? 20 : 12),
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: index == 0 || index == 6 ? 0 : 2),
                            decoration: BoxDecoration(
                              color: isSelected 
                                  ? TossColors.primary 
                                  : TossColors.gray50,
                              borderRadius: BorderRadius.circular(isSelected ? 20 : 12),
                              border: isToday && !isSelected
                                  ? Border.all(color: TossColors.primary.withValues(alpha: 0.3), width: 1)
                                  : null,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  dayName,
                                  style: TossTextStyles.caption.copyWith(
                                    color: isSelected 
                                        ? TossColors.white.withValues(alpha: 0.8)
                                        : TossColors.gray500,
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(height: TossSpacing.space2),
                                Text(
                                  '${date.day}',
                                  style: TossTextStyles.h3.copyWith(
                                    color: isSelected 
                                        ? TossColors.white 
                                        : TossColors.gray900,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: TossSpacing.space1),
                                // Status dots instead of "off" text
                                Container(
                                  height: 8,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      // Problem dot (red) - highest priority
                                      if (shiftStatus['hasProblem'] == true)
                                        Container(
                                          width: 6,
                                          height: 6,
                                          margin: const EdgeInsets.symmetric(horizontal: 1),
                                          decoration: BoxDecoration(
                                            color: isSelected 
                                                ? TossColors.white
                                                : TossColors.error,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                      // Pending dot (orange)
                                      if (shiftStatus['hasPending'] == true && shiftStatus['hasProblem'] != true)
                                        Container(
                                          width: 6,
                                          height: 6,
                                          margin: const EdgeInsets.symmetric(horizontal: 1),
                                          decoration: BoxDecoration(
                                            color: isSelected 
                                                ? TossColors.white
                                                : TossColors.warning,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                      // Approved dot (green)
                                      if (shiftStatus['hasApproved'] == true && shiftStatus['hasProblem'] != true && shiftStatus['hasPending'] != true)
                                        Container(
                                          width: 6,
                                          height: 6,
                                          margin: const EdgeInsets.symmetric(horizontal: 1),
                                          decoration: BoxDecoration(
                                            color: isSelected 
                                                ? TossColors.white
                                                : TossColors.success,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                      // If no shifts, show gray dot for "off"
                                      if (shiftStatus['hasApproved'] != true && shiftStatus['hasPending'] != true && shiftStatus['hasProblem'] != true)
                                        Container(
                                          width: 6,
                                          height: 6,
                                          margin: const EdgeInsets.symmetric(horizontal: 1),
                                          decoration: BoxDecoration(
                                            color: isSelected 
                                                ? TossColors.white.withValues(alpha: 0.5)
                                                : TossColors.gray300,
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
                    }),
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: TossSpacing.space5),
          
          // Shift Cards List
          Container(
            margin: const EdgeInsets.symmetric(horizontal: TossSpacing.space5),
            child: _buildShiftCardsList(),
          ),
          
          const SizedBox(height: TossSpacing.space5),
        ],
      ),
    );
  }
  
  // Build shift cards list for selected date
  Widget _buildShiftCardsList() {
    if (isLoadingCards) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(TossSpacing.space5),
          child: const TossLoadingView(
          ),
        ),
      );
    }
    
    // Get the month key for the selected date
    final monthKey = '${manageSelectedDate.year}-${manageSelectedDate.month.toString().padLeft(2, '0')}';
    final monthData = managerCardsDataByMonth[monthKey];
    
    if (monthData == null || monthData['stores'] == null) {
      return Container(
        padding: const EdgeInsets.all(TossSpacing.space5),
        child: Center(
          child: Text(
            'No shift data available',
            style: TossTextStyles.body.copyWith(
              color: TossColors.gray500,
            ),
          ),
        ),
      );
    }
    
    // Get stores data
    final stores = monthData['stores'] as List<dynamic>? ?? [];
    if (stores.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(TossSpacing.space5),
        child: Center(
          child: Text(
            'No store data available',
            style: TossTextStyles.body.copyWith(
              color: TossColors.gray500,
            ),
          ),
        ),
      );
    }
    
    // Get first store's cards (assuming single store for now)
    final storeData = stores.first as Map<String, dynamic>;
    final cards = storeData['cards'] as List<dynamic>? ?? [];
    
    // Filter cards by selected date
    final selectedDateStr = '${manageSelectedDate.year}-${manageSelectedDate.month.toString().padLeft(2, '0')}-${manageSelectedDate.day.toString().padLeft(2, '0')}';
    var filteredCards = cards.where((card) => card['request_date'] == selectedDateStr).toList();
    
    // Apply additional filter based on selected filter type
    if (selectedFilter != null && selectedFilter != 'all') {
      filteredCards = filteredCards.where((card) {
        switch (selectedFilter) {
          case 'problem':
            // Show cards where is_problem = true AND is_problem_solved = false
            return (card['is_problem'] == true) && (card['is_problem_solved'] != true);
          case 'approved':
            // Show cards where is_approved = true
            return card['is_approved'] == true;
          case 'pending':
            // Show cards where is_approved = false
            return card['is_approved'] == false;
          default:
            return true;
        }
      }).toList();
    }
    
    if (filteredCards.isEmpty) {
      String filterMessage = '';
      if (selectedFilter == 'problem') {
        filterMessage = ' (unsolved problems)';
      } else if (selectedFilter == 'approved') {
        filterMessage = ' (approved)';
      } else if (selectedFilter == 'pending') {
        filterMessage = ' (pending)';
      }
      
      return Container(
        padding: const EdgeInsets.all(TossSpacing.space5),
        child: Center(
          child: Text(
            'No shifts for ${manageSelectedDate.day} ${_getMonthName(manageSelectedDate.month)}$filterMessage',
            style: TossTextStyles.body.copyWith(
              color: TossColors.gray500,
            ),
          ),
        ),
      );
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Date header with filter indicator
        Padding(
          padding: const EdgeInsets.only(bottom: TossSpacing.space3),
          child: Row(
            children: [
              Text(
                '${manageSelectedDate.day} ${_getMonthName(manageSelectedDate.month)} Shifts',
                style: TossTextStyles.body.copyWith(
                  color: TossColors.gray900,
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
              if (selectedFilter != null && selectedFilter != 'all') ...[
                const SizedBox(width: TossSpacing.space2),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: TossSpacing.space2,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: selectedFilter == 'problem'
                        ? TossColors.error.withValues(alpha: 0.1)
                        : selectedFilter == 'approved'
                            ? TossColors.success.withValues(alpha: 0.1)
                            : TossColors.warning.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                  ),
                  child: Text(
                    selectedFilter == 'problem'
                        ? 'Problems'
                        : selectedFilter == 'approved'
                            ? 'Approved'
                            : 'Pending',
                    style: TossTextStyles.caption.copyWith(
                      color: selectedFilter == 'problem'
                          ? TossColors.error
                          : selectedFilter == 'approved'
                              ? TossColors.success
                              : TossColors.warning,
                      fontSize: 11,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
        // Cards list
        ...filteredCards.map((card) => _buildShiftCard(card as Map<String, dynamic>)),
      ],
    );
  }
  
  // Build individual shift card
  Widget _buildShiftCard(Map<String, dynamic> card) {
    final userName = card['user_name'] ?? 'Unknown';
    final profileImage = card['profile_image'] as String?;
    final shiftName = card['shift_name'] ?? 'Unknown Shift';
    final shiftTime = card['shift_time'] ?? '--:--';
    final isApproved = card['is_approved'] ?? false;
    final isProblem = card['is_problem'] ?? false;
    final isProblemSolved = card['is_problem_solved'] ?? false;
    final isLate = card['is_late'] ?? false;
    final lateMinute = card['late_minute'] ?? 0;
    final isOverTime = card['is_over_time'] ?? false;
    final overTimeMinute = card['over_time_minute'] ?? 0;
    final paidHour = card['paid_hour'] ?? 0;
    final confirmStartTime = card['confirm_start_time'];
    final confirmEndTime = card['confirm_end_time'];
    final isReported = card['is_reported'] ?? false;
    
    // Check if problem is unsolved (both conditions must be true)
    final hasUnsolvedProblem = isProblem && !isProblemSolved;
    
    // Check if reported AND problem not solved (both conditions must be true)
    final isReportedUnsolvedProblem = isReported && !isProblemSolved;
    
    // Determine card border color based on status
    Color borderColor = TossColors.gray200;
    if (isReportedUnsolvedProblem) {
      // Purple/Indigo color for reported but unsolved problems
      borderColor = TossColors.primary; // Using primary blue for highlight
    } else if (hasUnsolvedProblem) {
      borderColor = TossColors.error;
    } else if (isApproved) {
      borderColor = TossColors.success;
    } else {
      borderColor = TossColors.warning;
    }
    
    return InkWell(
      onTap: () {
        _showShiftDetailsBottomSheet(card);
        HapticFeedback.selectionClick();
      },
      borderRadius: BorderRadius.circular(TossBorderRadius.xl),
      child: Container(
      margin: const EdgeInsets.only(bottom: TossSpacing.space3),
      decoration: BoxDecoration(
        color: isReportedUnsolvedProblem
            ? TossColors.primary.withValues(alpha: 0.05) // Light primary background for reported unsolved
            : TossColors.background,
        borderRadius: BorderRadius.circular(TossBorderRadius.xl),
        border: Border.all(
          color: borderColor.withValues(alpha: 0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: TossColors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Card header
          Container(
            padding: const EdgeInsets.all(TossSpacing.space4),
            decoration: BoxDecoration(
              color: isReportedUnsolvedProblem
                  ? TossColors.primary.withValues(alpha: 0.08) // Slightly darker primary for header
                  : hasUnsolvedProblem 
                      ? TossColors.error.withValues(alpha: 0.05)
                      : isApproved
                          ? TossColors.success.withValues(alpha: 0.05)
                          : TossColors.warning.withValues(alpha: 0.05),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
            ),
            child: Row(
              children: [
                // User avatar
                ClipOval(
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: TossColors.primary.withValues(alpha: 0.1),
                    ),
                    child: profileImage != null && profileImage.isNotEmpty
                        ? Image.network(
                            profileImage,
                            width: 40,
                            height: 40,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              // Fallback to initial letter if image fails to load
                              return Center(
                                child: Text(
                                  userName.isNotEmpty ? userName[0].toUpperCase() : '?',
                                  style: TossTextStyles.body.copyWith(
                                    color: TossColors.primary,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              );
                            },
                          )
                        : Center(
                            child: Text(
                              userName.isNotEmpty ? userName[0].toUpperCase() : '?',
                              style: TossTextStyles.body.copyWith(
                                color: TossColors.primary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                  ),
                ),
                const SizedBox(width: TossSpacing.space3),
                // User and shift info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userName,
                        style: TossTextStyles.body.copyWith(
                          color: TossColors.gray900,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Text(
                            shiftName,
                            style: TossTextStyles.bodySmall.copyWith(
                              color: TossColors.gray600,
                            ),
                          ),
                          const SizedBox(width: TossSpacing.space2),
                          Text(
                            '•',
                            style: TossTextStyles.bodySmall.copyWith(
                              color: TossColors.gray400,
                            ),
                          ),
                          const SizedBox(width: TossSpacing.space2),
                          Text(
                            shiftTime,
                            style: TossTextStyles.bodySmall.copyWith(
                              color: TossColors.gray600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Status badges
                if (hasUnsolvedProblem)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: TossSpacing.space2,
                      vertical: TossSpacing.space1,
                    ),
                    decoration: BoxDecoration(
                      color: TossColors.error.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(TossBorderRadius.md),
                    ),
                    child: Text(
                      'Problem',
                      style: TossTextStyles.caption.copyWith(
                        color: TossColors.error,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  )
                else if (isProblem && isProblemSolved)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: TossSpacing.space2,
                      vertical: TossSpacing.space1,
                    ),
                    decoration: BoxDecoration(
                      color: TossColors.success.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(TossBorderRadius.md),
                    ),
                    child: Text(
                      'Problem Solved',
                      style: TossTextStyles.caption.copyWith(
                        color: TossColors.success,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  )
                else if (isApproved)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: TossSpacing.space2,
                      vertical: TossSpacing.space1,
                    ),
                    decoration: BoxDecoration(
                      color: TossColors.success.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(TossBorderRadius.md),
                    ),
                    child: Text(
                      'Approved',
                      style: TossTextStyles.caption.copyWith(
                        color: TossColors.success,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  )
                else
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: TossSpacing.space2,
                      vertical: TossSpacing.space1,
                    ),
                    decoration: BoxDecoration(
                      color: TossColors.warning.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(TossBorderRadius.md),
                    ),
                    child: Text(
                      'Pending',
                      style: TossTextStyles.caption.copyWith(
                        color: TossColors.warning,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          // Card details
          if (confirmStartTime != null || confirmEndTime != null || isLate || isOverTime || paidHour > 0)
            Container(
              padding: const EdgeInsets.all(TossSpacing.space4),
              child: Column(
                children: [
                  // Confirmed times display
                  if (confirmStartTime != null || confirmEndTime != null)
                    Row(
                      children: [
                        if (confirmStartTime != null) ...[
                          Icon(
                            Icons.login,
                            size: 16,
                            color: TossColors.gray500,
                          ),
                          const SizedBox(width: TossSpacing.space1),
                          Text(
                            confirmStartTime,
                            style: TossTextStyles.bodySmall.copyWith(
                              color: TossColors.gray700,
                            ),
                          ),
                        ],
                        if (confirmStartTime != null && confirmEndTime != null)
                          const SizedBox(width: TossSpacing.space3),
                        if (confirmEndTime != null) ...[
                          Icon(
                            Icons.logout,
                            size: 16,
                            color: TossColors.gray500,
                          ),
                          const SizedBox(width: TossSpacing.space1),
                          Text(
                            confirmEndTime,
                            style: TossTextStyles.bodySmall.copyWith(
                              color: TossColors.gray700,
                            ),
                          ),
                        ],
                        const Spacer(),
                        if (paidHour > 0) ...[
                          Icon(
                            Icons.access_time,
                            size: 16,
                            color: TossColors.gray500,
                          ),
                          const SizedBox(width: TossSpacing.space1),
                          Text(
                            '${paidHour}h',
                            style: TossTextStyles.bodySmall.copyWith(
                              color: TossColors.gray700,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ],
                    ),
                  // Problem indicators
                  if (isLate || isOverTime || isReported) ...[
                    const SizedBox(height: TossSpacing.space2),
                    Row(
                      children: [
                        if (isLate) ...[
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: TossSpacing.space2,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: TossColors.warning.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                            ),
                            child: Text(
                              'Late ${lateMinute}min',
                              style: TossTextStyles.caption.copyWith(
                                color: TossColors.warning,
                                fontSize: 11,
                              ),
                            ),
                          ),
                          const SizedBox(width: TossSpacing.space2),
                        ],
                        if (isOverTime) ...[
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: TossSpacing.space2,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: TossColors.info.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                            ),
                            child: Text(
                              'OT ${overTimeMinute}min',
                              style: TossTextStyles.caption.copyWith(
                                color: TossColors.info,
                                fontSize: 11,
                              ),
                            ),
                          ),
                          const SizedBox(width: TossSpacing.space2),
                        ],
                        if (isReported) ...[
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: TossSpacing.space2,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: TossColors.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                            ),
                            child: Text(
                              'Reported',
                              style: TossTextStyles.caption.copyWith(
                                color: TossColors.primary,
                                fontSize: 11,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ],
              ),
            ),
        ],
      ),
      ),
    );
  }

  Widget _buildScheduleTab() {
    final appState = ref.watch(appStateProvider);
    final userData = appState.user;
    final companies = (userData['companies'] as List<dynamic>?) ?? [];
    Map<String, dynamic>? selectedCompany;
    if (companies.isNotEmpty) {
      try {
        selectedCompany = companies.firstWhere(
          (c) => (c as Map<String, dynamic>)['company_id'] == appState.companyChoosen,
        ) as Map<String, dynamic>;
      } catch (e) {
        selectedCompany = companies.first as Map<String, dynamic>;
      }
    }
    final stores = (selectedCompany?['stores'] as List<dynamic>?) ?? [];
    
    return Stack(
      children: [
        Column(
          children: [
            // Store Selector - Toss Style
            if (stores.isNotEmpty)
                  Container(
                    margin: const EdgeInsets.all(TossSpacing.space5),
                    child: InkWell(
                      onTap: () => _showStoreSelector(stores),
                      borderRadius: BorderRadius.circular(TossBorderRadius.xl),
                      child: Container(
                        padding: const EdgeInsets.all(TossSpacing.space4),
                        decoration: BoxDecoration(
                          color: TossColors.background,
                          borderRadius: BorderRadius.circular(TossBorderRadius.xl),
                          border: Border.all(
                            color: TossColors.gray200,
                            width: 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: TossColors.black.withValues(alpha: 0.04),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: TossColors.gray50,
                                borderRadius: BorderRadius.circular(TossBorderRadius.md),
                              ),
                              child: const Icon(
                                Icons.store_outlined,
                                size: 20,
                                color: TossColors.gray600,
                              ),
                            ),
                            const SizedBox(width: TossSpacing.space3),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Store',
                                    style: TossTextStyles.caption.copyWith(
                                      color: TossColors.gray500,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    stores.firstWhere(
                                      (store) => store['store_id'] == selectedStoreId,
                                      orElse: () => {'store_name': 'Select Store'},
                                    )['store_name'] ?? 'Select Store',
                                    style: TossTextStyles.body.copyWith(
                                      color: TossColors.gray900,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(
                              Icons.chevron_right,
                              size: 20,
                              color: TossColors.gray400,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
            
            // Calendar Header - Toss Style
            Container(
                  margin: const EdgeInsets.symmetric(horizontal: TossSpacing.space5),
                  padding: const EdgeInsets.symmetric(vertical: TossSpacing.space3),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () async {
                          setState(() {
                            focusedMonth = DateTime(
                              focusedMonth.year,
                              focusedMonth.month - 1,
                            );
                          });
                          HapticFeedback.selectionClick();
                          // Check if we need to load data for this month
                          await fetchMonthlyShiftStatus(forDate: focusedMonth);
                        },
                        borderRadius: BorderRadius.circular(TossBorderRadius.xxl),
                        child: Container(
                          padding: const EdgeInsets.all(TossSpacing.space2),
                          child: const Icon(
                            Icons.chevron_left,
                            size: 24,
                            color: TossColors.gray600,
                          ),
                        ),
                      ),
                      const SizedBox(width: TossSpacing.space4),
                      Text(
                        '${_getMonthName(focusedMonth.month)} ${focusedMonth.year}',
                        style: TossTextStyles.h2.copyWith(
                          color: TossColors.gray900,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(width: TossSpacing.space4),
                      InkWell(
                        onTap: () async {
                          setState(() {
                            focusedMonth = DateTime(
                              focusedMonth.year,
                              focusedMonth.month + 1,
                            );
                          });
                          HapticFeedback.selectionClick();
                          // Check if we need to load data for this month
                          await fetchMonthlyShiftStatus(forDate: focusedMonth);
                        },
                        borderRadius: BorderRadius.circular(TossBorderRadius.xxl),
                        child: Container(
                          padding: const EdgeInsets.all(TossSpacing.space2),
                          child: const Icon(
                            Icons.chevron_right,
                            size: 24,
                            color: TossColors.gray600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            
            // Main content with scroll
            Expanded(
              child: ListView(
                controller: _scheduleScrollController,
                physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                padding: EdgeInsets.zero,
                children: [
                  // Calendar - Toss Style
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: TossSpacing.space5),
                    child: _buildCalendar(),
                  ),
                  
                  const SizedBox(height: TossSpacing.space4),
                  
                  // Display Shift Data
                  if (isLoadingShiftStatus)
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: TossSpacing.space5),
                      padding: const EdgeInsets.all(TossSpacing.space4),
                      child: Center(
                        child: const TossLoadingView(),
                      ),
                    )
                  else
                    _buildShiftDataSection(),
                  
                  const SizedBox(height: TossSpacing.space4),
                  
                  // Approve/Not Approve Button
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space5),
                    child: InkWell(
                      onTap: selectedShiftRequests.isNotEmpty && selectedShiftRequestIds.isNotEmpty 
                          ? () async {
                        HapticFeedback.mediumImpact();
                        
                        // Get user_id from app state
                        final appState = ref.read(appStateProvider);
                        final userId = appState.user['user_id'] ?? '';
                        
                        if (userId.isEmpty || selectedShiftRequestIds.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text('Error: Missing user ID or shift request ID'),
                              backgroundColor: TossColors.error,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(TossBorderRadius.md)),
                            ),
                          );
                          return;
                        }
                        
                        try {
                          // Use direct Supabase RPC call (same as lib_old)
                          await Supabase.instance.client.rpc(
                            'toggle_shift_approval',
                            params: {
                              'p_user_id': userId,
                              'p_shift_request_ids': selectedShiftRequestIds.values.toList(),  // Pass all selected IDs as array
                            },
                          );

                          // Determine action based on selected items - if mixed states, show generic message
                          final hasApproved = selectedShiftApprovalStates.values.contains(true);
                          final hasPending = selectedShiftApprovalStates.values.contains(false);
                          final action = hasApproved && hasPending
                              ? 'toggled'
                              : hasApproved
                                  ? 'changed to pending'
                                  : 'approved';

                          // Show success dialog
                          if (context.mounted) {
                            showDialog(
                              context: context,
                              barrierDismissible: true,
                              builder: (context) => TossDialog.success(
                                title: '${selectedShiftRequests.length} shift request(s) $action successfully',
                                primaryButtonText: 'OK',
                                onPrimaryPressed: () => Navigator.of(context).pop(),
                              ),
                            );
                          }
                          
                          // Clear the cached data for the current month to force a fresh fetch
                          final monthKey = '${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}';
                          final nextMonth = DateTime(selectedDate.year, selectedDate.month + 1);
                          final nextMonthKey = '${nextMonth.year}-${nextMonth.month.toString().padLeft(2, '0')}';
                          
                          // Remove existing data for the affected months
                          monthlyShiftData.removeWhere((item) {
                            final itemDate = item['request_date'] as String;
                            return itemDate.startsWith(monthKey) || itemDate.startsWith(nextMonthKey);
                          });
                          
                          // Clear selection and loaded months cache
                          setState(() {
                            selectedShiftRequests.clear();
                            selectedShiftApprovalStates.clear();
                            selectedShiftRequestIds.clear();
                            loadedMonths.remove(monthKey);
                            loadedMonths.remove(nextMonthKey);
                            // Clear Manager tab cached data to force refresh
                            managerOverviewDataByMonth.remove(monthKey);
                            managerCardsDataByMonth.remove(monthKey);
                          });
                          
                          // Force refresh the shift data to show updated status
                          await fetchMonthlyShiftStatus(forDate: selectedDate, forceRefresh: true);
                          
                          // Also refresh Manager tab data to reflect the changes immediately
                          await fetchManagerOverview(forDate: selectedDate, forceRefresh: true);
                          await fetchManagerCards(forDate: selectedDate, forceRefresh: true);
                          
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Error: ${e.toString()}'),
                              backgroundColor: TossColors.error,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(TossBorderRadius.md)),
                            ),
                          );
                        }
                      } : null,
                      borderRadius: BorderRadius.circular(TossBorderRadius.xl),
                      child: Container(
                        height: 56,
                        decoration: BoxDecoration(
                          color: selectedShiftRequests.isNotEmpty 
                              ? (selectedShiftApprovalStates.values.contains(true) && !selectedShiftApprovalStates.values.contains(false)
                                  ? TossColors.warning 
                                  : TossColors.primary)
                              : TossColors.gray300,
                          borderRadius: BorderRadius.circular(TossBorderRadius.xl),
                        ),
                        child: Center(
                          child: Text(
                            selectedShiftRequests.length > 1 
                                ? 'Toggle ${selectedShiftRequests.length} Shifts' 
                                : selectedShiftApprovalStates.values.contains(true) && !selectedShiftApprovalStates.values.contains(false)
                                    ? 'Not Approve' 
                                    : 'Approve',
                            style: TossTextStyles.bodyLarge.copyWith(
                              color: selectedShiftRequests.isNotEmpty 
                                  ? TossColors.white 
                                  : TossColors.gray500,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  
                  // Add bottom padding for comfortable scrolling
                  const SizedBox(height: 100), // Increased padding to avoid FAB overlap
                ],
              ),
            ),
          ],
        ),
        // Floating Action Button (FAB)
        Positioned(
          bottom: 20,
          right: 20,
          child: InkWell(
            onTap: () {
              HapticFeedback.mediumImpact();
              _showAddShiftBottomSheet();
            },
            borderRadius: BorderRadius.circular(TossBorderRadius.xxl + 4),
            child: Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: TossColors.primary,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: TossColors.primary.withValues(alpha: 0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                  BoxShadow(
                    color: TossColors.black.withValues(alpha: 0.08),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: const Icon(
                Icons.add,
                color: TossColors.white,
                size: 28,
              ),
            ),
          ),
        ),
      ],
    );
  }

  
  // Show shift details bottom sheet
  void _showShiftDetailsBottomSheet(Map<String, dynamic> card) async {
    final result = await showModalBottomSheet<dynamic>(
      context: context,
      backgroundColor: TossColors.transparent,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: ShiftDetailsBottomSheet(
          card: card,
          onUpdate: () {
            // Refresh data when shift details are updated
            if (selectedStoreId != null) {
              fetchManagerOverview();
              fetchManagerCards();
            }
          },
        ),
      ),
    );
    
    // Handle different types of results
    if (result == true) {
      // Regular update (non-bonus) - refresh data
      if (selectedStoreId != null) {
        // Clear cache to force refresh
        final monthKey = '${manageSelectedDate.year}-${manageSelectedDate.month.toString().padLeft(2, '0')}';
        setState(() {
          managerOverviewDataByMonth.remove(monthKey);
          managerCardsDataByMonth.remove(monthKey);
          loadedMonths.remove(monthKey);
        });
        
        // Fetch fresh data
        await fetchMonthlyShiftStatus(forDate: manageSelectedDate, forceRefresh: true);
        await fetchManagerOverview(forDate: manageSelectedDate, forceRefresh: true);
        await fetchManagerCards(forDate: manageSelectedDate, forceRefresh: true);
      }
    } else if (result is Map && result['updated'] == true && result['bonus_amount'] != null) {
      // Bonus update - update local state directly
      final monthKey = '${manageSelectedDate.year}-${manageSelectedDate.month.toString().padLeft(2, '0')}';
      final monthData = managerCardsDataByMonth[monthKey];
      
      if (monthData != null && monthData['stores'] != null) {
        final stores = monthData['stores'] as List<dynamic>;
        if (stores.isNotEmpty) {
          final storeData = stores.first as Map<String, dynamic>;
          final cards = storeData['cards'] as List<dynamic>? ?? [];
          
          // Find and update the specific card
          for (var i = 0; i < cards.length; i++) {
            if (cards[i]['shift_request_id'] == result['shift_request_id']) {
              setState(() {
                cards[i]['bonus_amount'] = result['bonus_amount'];
              });
              break;
            }
          }
        }
      }
      
      // Show success dialog
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(TossBorderRadius.xxl),
            ),
            child: Container(
              padding: const EdgeInsets.all(TossSpacing.space5),
              decoration: BoxDecoration(
                color: TossColors.white,
                borderRadius: BorderRadius.circular(TossBorderRadius.xxl),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: TossColors.success.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check_circle_outline,
                      color: TossColors.success,
                      size: 36,
                    ),
                  ),
                  const SizedBox(height: TossSpacing.space3),
                  Text(
                    'Success',
                    style: TossTextStyles.h3.copyWith(
                      color: TossColors.gray900,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: TossSpacing.space2),
                  Text(
                    'Bonus updated successfully',
                    style: TossTextStyles.body.copyWith(
                      color: TossColors.gray600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: TossSpacing.space4),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: TossColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: TossSpacing.space4,
                          vertical: TossSpacing.space3,
                        ),
                      ),
                      child: Text(
                        'OK',
                        style: TossTextStyles.body.copyWith(
                          color: TossColors.white,
                          fontWeight: FontWeight.w600,
                        ),
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
  
  // Show add shift bottom sheet
  void _showAddShiftBottomSheet() async {
    final result = await showModalBottomSheet<bool>(
      context: context,
      backgroundColor: TossColors.transparent,
      isScrollControlled: true,
      builder: (context) => AddShiftBottomSheet(
        onShiftAdded: () {
          // Refresh data when shift is added
          if (selectedStoreId != null) {
            fetchManagerOverview();
            fetchManagerCards();
          }
        },
      ),
    );

    // If result is true, a shift was added, so refresh
    if (result == true) {
      // Refresh the shift data
      await fetchMonthlyShiftStatus(forDate: focusedMonth, forceRefresh: true);
    }
  }
  
  Widget _buildStatCard({
    required IconData icon,
    required Color iconColor,
    required Color backgroundColor,
    required String title,
    required String value,
    required String subtitle,
    required String filterType,
  }) {
    final isSelected = selectedFilter == filterType;
    
    return InkWell(
      onTap: () {
        setState(() {
          // Toggle filter - if already selected, clear it (show all)
          selectedFilter = isSelected ? null : filterType;
        });
        HapticFeedback.selectionClick();
      },
      borderRadius: BorderRadius.circular(TossBorderRadius.xl),
      child: Container(
        padding: const EdgeInsets.all(TossSpacing.space3),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(TossBorderRadius.xl),
          border: isSelected 
              ? Border.all(
                  color: iconColor.withValues(alpha: 0.5),
                  width: 2,
                )
              : backgroundColor == TossColors.background
                  ? Border.all(
                      color: TossColors.gray200,
                      width: 1,
                    )
                  : null,
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: iconColor.withValues(alpha: 0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : backgroundColor == TossColors.background
                  ? [
                      BoxShadow(
                        color: TossColors.black.withValues(alpha: 0.05),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ]
                  : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  size: 18,
                  color: iconColor,
                ),
                const SizedBox(width: TossSpacing.space2),
                Expanded(
                  child: Text(
                    title,
                    style: TossTextStyles.bodySmall.copyWith(
                      color: TossColors.gray600,
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ],
            ),
            Flexible(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Flexible(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        value,
                        style: TossTextStyles.h1.copyWith(
                          color: TossColors.gray900,
                          fontWeight: FontWeight.w700,
                          fontSize: 28,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 2),
                    child: Text(
                      subtitle,
                      style: TossTextStyles.bodySmall.copyWith(
                        color: TossColors.gray500,
                        fontSize: 11,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
