// ignore_for_file: avoid_dynamic_calls, inference_failure_on_function_invocation, argument_type_not_assignable, invalid_assignment, non_bool_condition, non_bool_negation_expression, non_bool_operand, use_of_void_result
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../../app/providers/app_state_provider.dart';
import '../../../../core/utils/datetime_utils.dart';
import '../../../../shared/themes/toss_border_radius.dart';
import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_spacing.dart';
import '../../../../shared/themes/toss_text_styles.dart';
import '../../../../shared/widgets/common/toss_app_bar_1.dart';
import '../../../../shared/widgets/common/toss_loading_view.dart';
import '../../../../shared/widgets/common/toss_scaffold.dart';
import '../../../../shared/widgets/common/toss_success_error_dialog.dart';
import '../../../../shared/widgets/toss/toss_selection_bottom_sheet.dart';
import '../../../../shared/widgets/ai_chat/ai_chat_fab.dart';
import '../../../../core/domain/entities/feature.dart';
import '../../../homepage/domain/entities/top_feature.dart';
import '../../domain/entities/manager_shift_cards.dart';
import '../providers/time_table_providers.dart';
import '../widgets/bottom_sheets/add_shift_bottom_sheet.dart';
import '../widgets/bottom_sheets/shift_details_bottom_sheet.dart';
import '../widgets/calendar/calendar_month_header.dart';
import '../widgets/calendar/time_table_calendar.dart';
import '../widgets/common/store_selector_card.dart';
import '../widgets/manage/manage_tab_view.dart';
import '../widgets/schedule/schedule_approve_button.dart';
import '../widgets/schedule/schedule_shift_card.dart';

class TimeTableManagePage extends ConsumerStatefulWidget {
  final dynamic feature;

  const TimeTableManagePage({super.key, this.feature});

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

  // Feature info extracted once
  String? _featureName;
  String? _featureId;
  bool _featureInfoExtracted = false;

  // AI Chat session ID - persists while page is active
  late final String _aiChatSessionId;
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
  Map<String, ManagerShiftCards> managerCardsDataByMonth = {};
  bool isLoadingCards = false;
  
  // Filter state for manage tab - default to show approved shifts
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

    // Generate AI Chat session ID - persists for entire page lifecycle
    _aiChatSessionId = const Uuid().v4();

    // Extract feature info once
    _extractFeatureInfo();

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

  void _extractFeatureInfo() {
    if (_featureInfoExtracted) return;

    final feature = widget.feature;
    if (feature != null) {
      if (feature is Feature) {
        _featureName = feature.featureName;
        _featureId = feature.featureId;
      } else if (feature is TopFeature) {
        _featureName = feature.featureName;
        _featureId = feature.featureId;
      }
    }

    _featureInfoExtracted = true;
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
                  ManageTabView(
                    manageSelectedDate: manageSelectedDate,
                    selectedFilter: selectedFilter,
                    isLoadingOverview: isLoadingOverview,
                    isLoadingCards: isLoadingCards,
                    managerOverviewDataByMonth: managerOverviewDataByMonth,
                    managerCardsDataByMonth: managerCardsDataByMonth,
                    onFilterChanged: (filter) {
                      setState(() {
                        selectedFilter = filter;
                      });
                      fetchManagerCards();
                    },
                    onDateChanged: (date) async {
                      setState(() {
                        manageSelectedDate = date;
                      });
                      await fetchManagerOverview(forDate: date);
                      await fetchManagerCards(forDate: date);
                    },
                    onMonthChanged: (month) async {
                      await fetchManagerOverview(forDate: month);
                      await fetchManagerCards(forDate: month);
                    },
                    onCardTap: _showShiftDetailsBottomSheet,
                    getMonthName: _getMonthName,
                  ),
                  _buildScheduleTab(),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: AnimatedBuilder(
        animation: _tabController,
        builder: (context, child) {
          if (_tabController.index != 0) {
            return const SizedBox.shrink();
          }

          return AiChatFab(
            featureName: _featureName ?? 'Time Table Manage',
            pageContext: _buildPageContext(),
            featureId: _featureId,
            sessionId: _aiChatSessionId,
          );
        },
      ),
    );
  }

  Map<String, dynamic> _buildPageContext() {
    final monthKey = '${manageSelectedDate.year}-${manageSelectedDate.month.toString().padLeft(2, '0')}';
    final managerOverview = managerOverviewDataByMonth[monthKey];
    return {
      'current_tab': _tabController.index == 0 ? 'Manage' : 'Schedule',
      'selected_date': manageSelectedDate.toIso8601String().split('T')[0],
      if (managerOverview != null) ...{
        'total_requests': managerOverview['totalRequests'] ?? 0,
        'approved_count': managerOverview['approvedCount'] ?? 0,
        'pending_count': managerOverview['pendingCount'] ?? 0,
        'problem_count': managerOverview['problemCount'] ?? 0,
      },
    };
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
    if (selectedStoreId == null || selectedStoreId!.isEmpty) {
      return;
    }

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
    } catch (e) {
      setState(() {
        isLoadingCards = false;
      });
    }
  }
  
  String _getMonthName(int month) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December',
    ];
    return months[month - 1];
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
  
  // Build shift data section
  Widget _buildShiftDataSection({DateTime? useDate}) {
    // Format the selected date - use provided date or selectedDate (for Schedule tab)
    final targetDate = useDate ?? selectedDate;

    // Get employee shifts for this date using helper
    final employeeShifts = _getEmployeeShiftsForDate(targetDate);

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
              final shiftId = shift['shift_id'] as String;
              final shiftName = shift['shift_name'] as String? ?? 'Unknown Shift';

              // Get UTC times from database and convert to local time for display
              final startTimeUtc = shift['start_time'] as String? ?? shift['shift_start_time'] as String? ?? '--:--';
              final endTimeUtc = shift['end_time'] as String? ?? shift['shift_end_time'] as String? ?? '--:--';
              final startTime = _formatShiftTime(startTimeUtc);
              final endTime = _formatShiftTime(endTimeUtc);

              // Get assigned employees for this shift using helper
              final assignedEmployees = _getAssignedEmployeesForShift(
                shiftId,
                shiftName,
                employeeShifts,
              );

              // Use ScheduleShiftCard widget
              return ScheduleShiftCard(
                shiftId: shiftId,
                shiftName: shiftName,
                startTime: startTime,
                endTime: endTime,
                assignedEmployees: assignedEmployees,
                selectedShiftRequests: selectedShiftRequests,
                onEmployeeTap: _handleEmployeeTap,
              );
            }),
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

  // Helper: Get employee shifts for a specific date
  List<dynamic> _getEmployeeShiftsForDate(DateTime targetDate) {
    final dateStr = '${targetDate.year}-${targetDate.month.toString().padLeft(2, '0')}-${targetDate.day.toString().padLeft(2, '0')}';

    for (var dayData in monthlyShiftData) {
      if (dayData['request_date'] == dateStr) {
        return dayData['shifts'] as List<dynamic>? ?? [];
      }
    }
    return [];
  }

  // Helper: Format UTC time string to local time (HH:mm format)
  ///
  /// The database stores times in UTC format. This method converts them
  /// to the user's local timezone for display.
  String _formatShiftTime(String? utcTime) {
    if (utcTime == null || utcTime.isEmpty || utcTime == '--:--') {
      return '--:--';
    }

    try {
      // 1. Full ISO 8601 format with timezone (e.g., "2024-01-01T09:00:00Z")
      if (utcTime.contains('T') || utcTime.contains('Z')) {
        final localTime = DateTimeUtils.toLocal(utcTime);
        final formattedTime = DateTimeUtils.formatTimeOnly(localTime);
        return formattedTime;
      }

      // 2. Time-only format (e.g., "09:00:00", "09:00")
      // Remove any timezone info and normalize format
      final cleanTime = utcTime.split('+')[0].split('Z')[0].trim();

      // Create a dummy UTC datetime for today with this time
      final now = DateTime.now().toUtc();
      final dateStr = DateTimeUtils.toDateOnly(now);

      // Build full UTC datetime string
      final fullUtcString = '${dateStr}T${cleanTime}Z';

      // Convert to local and extract time only
      final localTime = DateTimeUtils.toLocal(fullUtcString);
      final formattedTime = DateTimeUtils.formatTimeOnly(localTime);

      return formattedTime;

    } catch (e) {
      // Try one more fallback: parse as HH:mm format
      try {
        final parts = utcTime.split(':');
        if (parts.length >= 2) {
          final hour = int.parse(parts[0]);
          final minute = int.parse(parts[1]);

          // Create UTC datetime and convert to local
          final now = DateTime.now().toUtc();
          final utcDateTime = DateTime.utc(now.year, now.month, now.day, hour, minute);
          final localDateTime = utcDateTime.toLocal();
          final formattedTime = DateTimeUtils.formatTimeOnly(localDateTime);

          return formattedTime;
        }
      } catch (e2) {
        // Silently handle fallback failure
      }

      // Final fallback: return original
      return utcTime;
    }
  }

  // Helper: Get assigned employees for a specific shift
  List<Map<String, dynamic>> _getAssignedEmployeesForShift(
    String shiftId,
    String shiftName,
    List<dynamic> employeeShifts,
  ) {
    final List<Map<String, dynamic>> assignedEmployees = [];

    if (employeeShifts.isEmpty) return assignedEmployees;

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
        break;
      }
    }

    return assignedEmployees;
  }

  // Helper: Handle employee tap for selection
  void _handleEmployeeTap(String shiftRequestId, bool isApproved, String shiftRequestIdFromData) {
    HapticFeedback.selectionClick();
    setState(() {
      if (selectedShiftRequests.contains(shiftRequestId)) {
        selectedShiftRequests.remove(shiftRequestId);
        selectedShiftApprovalStates.remove(shiftRequestId);
        selectedShiftRequestIds.remove(shiftRequestId);
      } else {
        selectedShiftRequests.add(shiftRequestId);
        selectedShiftApprovalStates[shiftRequestId] = isApproved;
        selectedShiftRequestIds[shiftRequestId] = shiftRequestIdFromData;

        // Auto-scroll to show the Approve button
        Future.delayed(const Duration(milliseconds: 100), () {
          if (_scheduleScrollController.hasClients) {
            _scheduleScrollController.animateTo(
              _scheduleScrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
            );
          }
        });
      }
    });
  }

  // Helper: Handle approval success callback
  Future<void> _handleApprovalSuccess() async {
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
            // Store Selector
            StoreSelectorCard(
              selectedStoreId: selectedStoreId,
              stores: stores,
              onTap: () => _showStoreSelector(stores),
            ),

            // Calendar Header
            CalendarMonthHeader(
              focusedMonth: focusedMonth,
              onPreviousMonth: () async {
                setState(() {
                  focusedMonth = DateTime(
                    focusedMonth.year,
                    focusedMonth.month - 1,
                  );
                });
                await fetchMonthlyShiftStatus(forDate: focusedMonth);
              },
              onNextMonth: () async {
                setState(() {
                  focusedMonth = DateTime(
                    focusedMonth.year,
                    focusedMonth.month + 1,
                  );
                });
                await fetchMonthlyShiftStatus(forDate: focusedMonth);
              },
              getMonthName: _getMonthName,
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
                    child: TimeTableCalendar(
                      selectedDate: selectedDate,
                      focusedMonth: focusedMonth,
                      onDateSelected: (date) {
                        setState(() {
                          selectedDate = date;
                          // Clear selection when changing dates
                          selectedShiftRequests.clear();
                          selectedShiftApprovalStates.clear();
                          selectedShiftRequestIds.clear();
                        });
                        // Fetch shift status for the selected date
                        fetchMonthlyShiftStatus();
                        // Fetch overview data if on Manage tab and month changed
                        if (_tabController.index == 1) {
                          fetchManagerOverview();
                        }
                      },
                      shiftMetadata: shiftMetadata,
                      monthlyShiftData: monthlyShiftData,
                    ),
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
                  ScheduleApproveButton(
                    selectedShiftRequests: selectedShiftRequests,
                    selectedShiftApprovalStates: selectedShiftApprovalStates,
                    selectedShiftRequestIds: selectedShiftRequestIds,
                    userId: ref.read(appStateProvider).user['user_id'] ?? '',
                    selectedDate: selectedDate,
                    onSuccess: _handleApprovalSuccess,
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
      // Bonus update - refresh the data
      if (mounted) {
        await fetchManagerCards(forDate: manageSelectedDate, forceRefresh: true);
      }

      // Show success dialog
      if (!mounted) return;
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) => TossDialog.success(
          title: 'Success',
          message: 'Bonus updated successfully',
          primaryButtonText: 'OK',
        ),
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
        onShiftAdded: () async {
          // Refresh data immediately when shift is added (before closing bottom sheet)
          if (selectedStoreId != null && mounted) {
            // Refresh Schedule tab data - this will update the UI immediately
            await fetchMonthlyShiftStatus(forDate: focusedMonth, forceRefresh: true);
            // Refresh Manage tab data
            await fetchManagerOverview(forDate: manageSelectedDate, forceRefresh: true);
            await fetchManagerCards(forDate: manageSelectedDate, forceRefresh: true);
          }
        },
      ),
    );

    // Additional refresh after bottom sheet closes (for safety)
    if (result == true && mounted) {
      // Refresh the shift data one more time to ensure everything is up-to-date
      await fetchMonthlyShiftStatus(forDate: focusedMonth, forceRefresh: true);
    }
  }
}
