import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:myfinance_improved/core/themes/toss_colors.dart';
import 'package:myfinance_improved/core/themes/toss_text_styles.dart';
import 'package:myfinance_improved/core/themes/toss_spacing.dart';
import 'package:myfinance_improved/presentation/providers/app_state_provider.dart';
import '../../widgets/common/toss_scaffold.dart';
import '../../widgets/common/toss_app_bar.dart';
import '../../widgets/common/toss_loading_view.dart';
import '../../widgets/toss/toss_time_picker.dart';
import 'package:myfinance_improved/core/themes/index.dart';
import 'package:myfinance_improved/core/themes/toss_border_radius.dart';

// Custom formatter for number with comma separators
class ThousandSeparatorInputFormatter extends TextInputFormatter {
  final NumberFormat _formatter = NumberFormat('#,###');

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    // Remove all non-digit characters
    String digitsOnly = newValue.text.replaceAll(RegExp(r'[^\d]'), '');
    
    if (digitsOnly.isEmpty) {
      return const TextEditingValue(
        text: '',
        selection: TextSelection.collapsed(offset: 0),
      );
    }

    // Parse the number
    int number = int.tryParse(digitsOnly) ?? 0;
    
    // Format with commas
    String formatted = _formatter.format(number);
    
    // Calculate new cursor position
    int cursorPosition = formatted.length;
    
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: cursorPosition),
    );
  }
}
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
  
  // Track selected shift request (shift_id + user_name combination)
  String? selectedShiftRequest;
  bool? selectedShiftIsApproved; // Track if selected shift is approved or pending
  String? selectedShiftRequestId; // Track the actual shift_request_id for RPC call
  
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
      appBar: TossAppBar(
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
  
  // Fetch shift metadata from Supabase RPC
  Future<void> fetchShiftMetadata(String storeId) async {
    if (storeId.isEmpty) return;
    
    setState(() {
      isLoadingMetadata = true;
    });
    
    try {
      final response = await Supabase.instance.client.rpc(
        'get_shift_metadata',
        params: {
          'p_store_id': storeId,
        },
      );
      
      
      setState(() {
        shiftMetadata = response;
        isLoadingMetadata = false;
      });
      
    } catch (e) {
      setState(() {
        isLoadingMetadata = false;
        shiftMetadata = [];
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
      
      final response = await Supabase.instance.client.rpc(
        'get_monthly_shift_status_manager',
        params: {
          'p_store_id': selectedStoreId,
          'p_request_date': requestDate,
        },
      );
      
      
      setState(() {
        // Append new data to existing data (don't replace)
        if (response != null && response is List) {
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
        }
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
      
      final response = await Supabase.instance.client.rpc(
        'manager_shift_get_overview',
        params: {
          'p_start_date': startDate,
          'p_end_date': endDate,
          'p_store_id': selectedStoreId,
          'p_company_id': companyId,
        },
      );
      
      
      setState(() {
        if (response != null) {
          managerOverviewDataByMonth[monthKey] = Map<String, dynamic>.from(response);
        }
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
      
      final response = await Supabase.instance.client.rpc(
        'manager_shift_get_cards',
        params: {
          'p_start_date': startDate,
          'p_end_date': endDate,
          'p_store_id': selectedStoreId,
          'p_company_id': companyId,
        },
      );
      
      
      setState(() {
        if (response != null) {
          managerCardsDataByMonth[monthKey] = Map<String, dynamic>.from(response);
        }
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
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return months[month - 1];
  }
  
  // Show calendar popup for Manage tab
  void _showManageCalendarPopup() {
    DateTime tempSelectedDate = manageSelectedDate;
    DateTime displayMonth = manageSelectedDate;
    
    showModalBottomSheet(
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
  Widget _buildCalendarGrid(DateTime displayMonth, DateTime selectedDate, Function(DateTime) onDateSelected) {
    final firstDay = DateTime(displayMonth.year, displayMonth.month, 1);
    final lastDay = DateTime(displayMonth.year, displayMonth.month + 1, 0);
    final daysInMonth = lastDay.day;
    final firstWeekday = firstDay.weekday;
    
    // Get the month key for the displayed month
    final monthKey = '${displayMonth.year}-${displayMonth.month.toString().padLeft(2, '0')}';
    final monthData = managerCardsDataByMonth[monthKey];
    
    // Process cards data to find dates with problems, pending, approved shifts, or no shifts
    Map<String, bool> datesWithProblems = {};
    Map<String, bool> datesWithPending = {};
    Map<String, bool> datesWithApproved = {};
    Map<String, bool> datesWithShifts = {}; // Track dates that have any shifts
    
    if (monthData != null && monthData['stores'] != null) {
      final stores = monthData['stores'] as List<dynamic>? ?? [];
      if (stores.isNotEmpty) {
        final storeData = stores.first as Map<String, dynamic>;
        final cards = storeData['cards'] as List<dynamic>? ?? [];
        
        for (var card in cards) {
          final requestDate = card['request_date'] as String?;
          if (requestDate != null) {
            // Mark this date as having shifts
            datesWithShifts[requestDate] = true;
            
            final isProblem = (card['is_problem'] == true) && (card['is_problem_solved'] != true);
            final isApproved = card['is_approved'] ?? false;
            
            if (isProblem) {
              datesWithProblems[requestDate] = true;
            }
            if (!isApproved) {
              datesWithPending[requestDate] = true;
            }
            if (isApproved && !isProblem) {
              datesWithApproved[requestDate] = true;
            }
          }
        }
      }
    }
    
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
      
      final hasProblem = datesWithProblems[dateStr] ?? false;
      final hasPending = datesWithPending[dateStr] ?? false;
      final hasApproved = datesWithApproved[dateStr] ?? false;
      final hasShift = datesWithShifts[dateStr] ?? false;
      
      calendarDays.add(
        InkWell(
          onTap: () => onDateSelected(date),
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
                // Show indicator dots below the date matching the weekly schedule logic
                if (!isSelected) ...[
                  const SizedBox(height: 2),
                  Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      // Priority: Problem (red) > Pending (orange) > Approved (green) > No shift (gray)
                      color: hasProblem 
                          ? TossColors.error               // Red for problems
                          : hasPending 
                              ? TossColors.warning         // Orange for pending
                              : hasApproved
                                  ? TossColors.success     // Green for approved
                                  : hasShift
                                      ? TossColors.gray400  // Should not happen, but fallback
                                      : TossColors.gray300, // Gray for no shifts (off day)
                      shape: BoxShape.circle,
                    ),
                  ),
                ] else
                  const SizedBox(height: 6), // Keep spacing consistent
              ],
            ),
          ),
        ),
      );
    }
    
    return GridView.count(
      crossAxisCount: 7,
      children: calendarDays,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
    );
  }
  
  // Show store selector with Toss-style bottom sheet
  void _showStoreSelector(List<dynamic> stores) {
    showModalBottomSheet(
      context: context,
      backgroundColor: TossColors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: TossColors.background,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
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
                children: [
                  Text(
                    'Select Store',
                    style: TossTextStyles.h3.copyWith(
                      color: TossColors.gray900,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            // Store list
            Container(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.5,
              ),
              child: ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                itemCount: stores.length,
                itemBuilder: (context, index) {
                  final store = stores[index];
                  final isSelected = store['store_id'] == selectedStoreId;
                  
                  return InkWell(
                    onTap: () async {
                      HapticFeedback.selectionClick();
                      Navigator.pop(context);
                      
                      setState(() {
                        selectedStoreId = store['store_id'];
                        // Clear cached data when switching stores
                        monthlyShiftData = [];
                        loadedMonths.clear();
                        // Clear selection when switching stores
                        selectedShiftRequest = null;
                        selectedShiftIsApproved = null;
                        selectedShiftRequestId = null;
                        // Clear overview data when switching stores
                        managerOverviewDataByMonth.clear();
                        managerCardsDataByMonth.clear();
                      });
                      
                      // Update app state with the new store selection
                      await ref.read(appStateProvider.notifier).setStoreChoosen(store['store_id']);
                      
                      // Fetch data for the new store
                      await fetchShiftMetadata(store['store_id']);
                      await fetchMonthlyShiftStatus();
                      // Fetch overview data if on Manage tab
                      if (_tabController.index == 1) {
                        await fetchManagerOverview();
                        await fetchManagerCards();
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: TossSpacing.space5,
                        vertical: TossSpacing.space4,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected ? TossColors.gray50 : TossColors.transparent,
                        border: Border(
                          bottom: BorderSide(
                            color: TossColors.gray100,
                            width: index == stores.length - 1 ? 0 : 1,
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: isSelected ? TossColors.primary.withValues(alpha: 0.1) : TossColors.gray100,
                              borderRadius: BorderRadius.circular(TossBorderRadius.md),
                            ),
                            child: Icon(
                              Icons.store_outlined,
                              size: 20,
                              color: isSelected ? TossColors.primary : TossColors.gray600,
                            ),
                          ),
                          const SizedBox(width: TossSpacing.space3),
                          Expanded(
                            child: Text(
                              store['store_name'] ?? 'Unknown Store',
                              style: TossTextStyles.body.copyWith(
                                color: isSelected ? TossColors.primary : TossColors.gray900,
                                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                              ),
                            ),
                          ),
                          if (isSelected)
                            const Icon(
                              Icons.check_circle,
                              size: 20,
                              color: TossColors.primary,
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            // Bottom safe area
            SizedBox(height: MediaQuery.of(context).padding.bottom + TossSpacing.space4),
          ],
        ),
      ),
    );
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
              selectedShiftRequest = null;
              selectedShiftIsApproved = null;
              selectedShiftRequestId = null;
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
  Widget _buildShiftDataSection() {
    // Format the selected date
    final dateStr = '${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}';
    
    // Find the data for the selected date from the array
    List<dynamic> employeeShifts = [];
    
    for (var dayData in monthlyShiftData) {
      if (dayData['request_date'] == dateStr) {
        employeeShifts = dayData['shifts'] as List<dynamic>? ?? [];
        break;
      }
    }
    
    // Debug: Print the data structure
    
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
                        final isSelected = selectedShiftRequest == shiftRequestId;
                        
                        return InkWell(
                          onTap: () {
                            // Handle shift click
                            HapticFeedback.selectionClick();
                            setState(() {
                              // Toggle selection - if already selected, deselect; otherwise select
                              if (selectedShiftRequest == shiftRequestId) {
                                selectedShiftRequest = null;
                                selectedShiftIsApproved = null;
                                selectedShiftRequestId = null;
                              } else {
                                selectedShiftRequest = shiftRequestId;
                                selectedShiftIsApproved = isApproved;
                                selectedShiftRequestId = shiftRequestIdFromData;
                                
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
    final now = DateTime.now();
    final monthName = _getMonthName(now.month);
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
                      '$monthName ${now.year}',
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
    final selectedCompany = ref.watch(selectedCompanyProvider);
    final stores = selectedCompany?['stores'] ?? [];
    
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
                      onTap: selectedShiftRequest != null && selectedShiftRequestId != null && selectedShiftRequestId!.isNotEmpty 
                          ? () async {
                        HapticFeedback.mediumImpact();
                        
                        // Get user_id from app state
                        final appState = ref.read(appStateProvider);
                        final userId = appState.user['user_id'] ?? '';
                        
                        if (userId.isEmpty || selectedShiftRequestId!.isEmpty) {
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
                          // Call RPC function to toggle shift approval
                          await Supabase.instance.client.rpc(
                            'toggle_shift_approval',
                            params: {
                              'p_user_id': userId,
                              'p_shift_request_ids': [selectedShiftRequestId],  // Pass as array
                            },
                          );
                          
                          
                          // When clicking approved shift, it changes to pending. When clicking pending shift, it changes to approved.
                          final action = selectedShiftIsApproved == true 
                              ? 'changed to pending' 
                              : 'approved';
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Shift request $action successfully'),
                              backgroundColor: TossColors.success,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(TossBorderRadius.md)),
                            ),
                          );
                          
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
                            selectedShiftRequest = null;
                            selectedShiftIsApproved = null;
                            selectedShiftRequestId = null;
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
                          color: selectedShiftRequest != null 
                              ? (selectedShiftIsApproved == true 
                                  ? TossColors.warning 
                                  : TossColors.primary)
                              : TossColors.gray300,
                          borderRadius: BorderRadius.circular(TossBorderRadius.xl),
                        ),
                        child: Center(
                          child: Text(
                            selectedShiftIsApproved == true ? 'Not Approve' : 'Approve',
                            style: TossTextStyles.bodyLarge.copyWith(
                              color: selectedShiftRequest != null 
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
        child: _ShiftDetailsBottomSheet(card: card),
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
      builder: (context) => _AddShiftBottomSheet(),
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
class _ShiftDetailsBottomSheet extends ConsumerStatefulWidget {
  final Map<String, dynamic> card;
  
  const _ShiftDetailsBottomSheet({required this.card});
  
  @override
  ConsumerState<_ShiftDetailsBottomSheet> createState() => _ShiftDetailsBottomSheetState();
}

class _ShiftDetailsBottomSheetState extends ConsumerState<_ShiftDetailsBottomSheet> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String? editedStartTime;
  String? editedEndTime;
  String? selectedTagType;
  String? tagContent;
  late bool isProblemSolved;
  String bonusInputText = '';
  late TextEditingController bonusController;
  
  // Original values to track changes
  String? originalStartTime;
  String? originalEndTime;
  late bool originalProblemSolved;
  
  final List<String> tagTypes = [
    'Schedule Change',
    'Exceptional Case', 
    'Manager Note',
    'Policy Violation',
    'Others',
    'Reset'
  ];
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    // Initialize with confirmed times
    editedStartTime = widget.card['confirm_start_time'];
    editedEndTime = widget.card['confirm_end_time'];
    // Store original values
    originalStartTime = editedStartTime;
    originalEndTime = editedEndTime;
    
    // Tag values start as null
    selectedTagType = null;
    tagContent = null;
    
    // Initialize bonus controller - always start with empty text
    bonusController = TextEditingController(text: '');
    bonusInputText = bonusController.text;
    bonusController.addListener(() {
      setState(() {
        bonusInputText = bonusController.text;
      });
    });
    
    // Initialize problem solved state
    final isProblem = widget.card['is_problem'] == true;
    final wasSolved = widget.card['is_problem_solved'] == true;
    
    if (!isProblem) {
      // If not a problem, default to solved (clicked)
      isProblemSolved = true;
    } else if (isProblem && wasSolved) {
      // If problem and already solved, default to solved (clicked)
      isProblemSolved = true;
    } else {
      // If problem and not solved, default to unsolved (unclicked)
      isProblemSolved = false;
    }
    originalProblemSolved = isProblemSolved;
  }
  
  // Check if any changes have been made
  bool hasChanges() {
    // Check if times have changed
    final timeChanged = editedStartTime != originalStartTime || 
                       editedEndTime != originalEndTime;
    
    // Check if problem status changed
    final problemChanged = isProblemSolved != originalProblemSolved;
    
    // Check if tag is being added
    final tagAdded = (selectedTagType != null && tagContent != null && tagContent!.isNotEmpty);
    
    return timeChanged || problemChanged || tagAdded;
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    bonusController.dispose();
    super.dispose();
  }
  
  Future<void> _showBonusConfirmationDialog() async {
    // Get current bonus from card
    final dynamic rawBonusAmount = widget.card['bonus_amount'];
    final num currentBonus = rawBonusAmount is String 
        ? num.tryParse(rawBonusAmount) ?? 0 
        : rawBonusAmount ?? 0;
    
    // Get base pay
    final dynamic rawBasePay = widget.card['base_pay'] ?? '0';
    final num basePay = rawBasePay is String 
        ? num.tryParse(rawBasePay.replaceAll(',', '')) ?? 0 
        : rawBasePay ?? 0;
    
    // Get typed bonus (remove commas for parsing)
    String cleanInput = bonusInputText.replaceAll(',', '');
    final num typedBonus = num.tryParse(cleanInput) ?? 0;
    
    // Calculate total pays
    final num currentTotal = basePay + currentBonus;
    final num newTotal = basePay + typedBonus;
    
    // Format numbers for display
    final formatter = NumberFormat('#,###');
    
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(TossBorderRadius.xxl),
          ),
          title: Text(
            'Confirm Bonus',
            style: TossTextStyles.h3.copyWith(
              color: TossColors.gray900,
              fontWeight: FontWeight.w700,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(TossSpacing.space4),
                decoration: BoxDecoration(
                  color: TossColors.info.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(TossBorderRadius.xl),
                  border: Border.all(
                    color: TossColors.info.withValues(alpha: 0.2),
                    width: 1,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Text(
                      'Payment Summary',
                      style: TossTextStyles.body.copyWith(
                        color: TossColors.gray900,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: TossSpacing.space3),
                    
                    // Base Pay
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Base Pay',
                          style: TossTextStyles.caption.copyWith(
                            color: TossColors.gray600,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          basePay != 0 ? formatter.format(basePay) : '0',
                          style: TossTextStyles.body.copyWith(
                            color: basePay < 0 ? TossColors.error : TossColors.gray700,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: TossSpacing.space2),
                    
                    // Current Bonus with arrow to New Bonus
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Bonus',
                          style: TossTextStyles.caption.copyWith(
                            color: TossColors.gray600,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              currentBonus > 0 ? '+ ${formatter.format(currentBonus)}' : '+ 0',
                              style: TossTextStyles.body.copyWith(
                                color: TossColors.gray500,
                                fontWeight: FontWeight.w600,
                                decoration: currentTotal != newTotal ? TextDecoration.lineThrough : null,
                              ),
                            ),
                            if (currentTotal != newTotal) ...[
                              const SizedBox(width: TossSpacing.space2),
                              const Icon(
                                Icons.arrow_forward,
                                size: 14,
                                color: TossColors.info,
                              ),
                              const SizedBox(width: TossSpacing.space2),
                              Text(
                                typedBonus > 0 ? '+ ${formatter.format(typedBonus)}' : '+ 0',
                                style: TossTextStyles.body.copyWith(
                                  color: TossColors.info,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                    
                    // Divider
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: TossSpacing.space2),
                      height: 1,
                      color: TossColors.info.withValues(alpha: 0.2),
                    ),
                    
                    // Total Pay
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total Pay',
                          style: TossTextStyles.body.copyWith(
                            color: TossColors.gray700,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          formatter.format(newTotal),
                          style: TossTextStyles.h3.copyWith(
                            color: newTotal < 0 ? TossColors.error : TossColors.info,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: TossSpacing.space4),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: TossColors.gray200,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: TossSpacing.space4,
                          vertical: TossSpacing.space3,
                        ),
                      ),
                      child: Text(
                        'Cancel',
                        style: TossTextStyles.body.copyWith(
                          color: TossColors.gray700,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: TossSpacing.space3),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(true),
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
            ],
          ),
          actions: [],
        );
      },
    );
    
    if (result == true) {
      await _updateBonusAmount(typedBonus);
    }
  }
  
  Future<void> _updateBonusAmount(num newBonus) async {
    try {
      // Show loading
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(
            color: TossColors.primary,
          ),
        ),
      );
      
      // Get shift request ID from the card
      final shiftRequestId = widget.card['shift_request_id'];
      
      if (shiftRequestId == null) {
        throw Exception('Shift request ID not found');
      }
      
      // Update the database
      final supabase = Supabase.instance.client;
      await supabase
          .from('shift_requests')
          .update({'bonus_amount': newBonus})
          .eq('shift_request_id', shiftRequestId);
      
      // Close loading dialog
      Navigator.of(context).pop();
      
      // Update the card in parent's state by returning the new bonus amount
      Navigator.of(context).pop({'updated': true, 'bonus_amount': newBonus, 'shift_request_id': shiftRequestId});
      
    } catch (e) {
      // Close loading dialog if open
      if (Navigator.canPop(context)) {
        Navigator.of(context).pop();
      }
      
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Failed to update bonus: $e',
            style: TossTextStyles.body.copyWith(color: TossColors.white),
          ),
          backgroundColor: TossColors.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(TossBorderRadius.lg),
          ),
        ),
      );
    }
  }
  
  Future<void> _showDeleteTagDialog(BuildContext context, String tagId, String content) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(TossBorderRadius.xxl),
          ),
          title: Text(
            'Delete Tag',
            style: TossTextStyles.body.copyWith(
              color: TossColors.gray900,
              fontWeight: FontWeight.w700,
              fontSize: 20,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Do you want to delete this tag?',
                style: TossTextStyles.body.copyWith(
                  color: TossColors.gray700,
                ),
              ),
              const SizedBox(height: TossSpacing.space3),
              Container(
                padding: const EdgeInsets.all(TossSpacing.space3),
                decoration: BoxDecoration(
                  color: TossColors.gray50,
                  borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                ),
                child: Text(
                  content,
                  style: TossTextStyles.bodySmall.copyWith(
                    color: TossColors.gray600,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(
                'Cancel',
                style: TossTextStyles.body.copyWith(
                  color: TossColors.gray500,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: TextButton.styleFrom(
                foregroundColor: TossColors.error,
              ),
              child: Text(
                'Delete',
                style: TossTextStyles.body.copyWith(
                  color: TossColors.error,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        );
      },
    );
    
    if (result == true && mounted) {
      await _deleteTag(tagId);
    }
  }
  
  Future<void> _showNotApproveDialog(BuildContext context, Map<String, dynamic> card) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(TossBorderRadius.xxl),
          ),
          title: Text(
            'Confirm',
            style: TossTextStyles.body.copyWith(
              color: TossColors.gray900,
              fontWeight: FontWeight.w700,
              fontSize: 20,
            ),
          ),
          content: Text(
            'Are you sure you want to not approve this shift?',
            style: TossTextStyles.body.copyWith(
              color: TossColors.gray700,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(
                'Cancel',
                style: TossTextStyles.body.copyWith(
                  color: TossColors.gray500,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: TextButton.styleFrom(
                foregroundColor: TossColors.warning,
              ),
              child: Text(
                'Yes',
                style: TossTextStyles.body.copyWith(
                  color: TossColors.warning,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        );
      },
    );
    
    if (result == true && mounted) {
      await _toggleApprovalStatus(card['shift_request_id']);
    }
  }
  
  Future<void> _toggleApprovalStatus(String shiftRequestId) async {
    try {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: true, // Allow dismissing loading dialogs
        builder: (BuildContext context) {
          return const Center(
            child: const TossLoadingView(
            ),
          );
        },
      );
      
      // Get user ID from app state
      final appState = ref.read(appStateProvider);
      final userId = appState.user['user_id'] ?? '';
      
      if (userId.isEmpty || shiftRequestId.isEmpty) {
        throw Exception('Missing user ID or shift request ID');
      }
      
      // Call RPC function to toggle shift approval (same as Schedule tab)
      await Supabase.instance.client.rpc(
        'toggle_shift_approval',
        params: {
          'p_user_id': userId,
          'p_shift_request_ids': [shiftRequestId],  // Pass as array
        },
      );
      
      // Close loading dialog
      if (mounted) {
        Navigator.of(context).pop();
      }
      
      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Shift request changed to pending successfully',
              style: TossTextStyles.body.copyWith(
                color: TossColors.white,
              ),
            ),
            backgroundColor: TossColors.success,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(TossBorderRadius.lg),
            ),
            margin: const EdgeInsets.all(TossSpacing.space4),
            duration: const Duration(seconds: 2),
          ),
        );
        
        // Close the bottom sheet and return true to trigger refresh in parent
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      // Close loading dialog if still open
      if (mounted) {
        Navigator.of(context).pop();
      }
      
      // Show error message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Error: ${e.toString()}',
              style: TossTextStyles.body.copyWith(
                color: TossColors.white,
              ),
            ),
            backgroundColor: TossColors.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(TossBorderRadius.lg),
            ),
            margin: const EdgeInsets.all(TossSpacing.space4),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }
  
  Future<void> _deleteTag(String tagId) async {
    // Validate tag ID
    if (tagId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Invalid tag ID',
            style: TossTextStyles.body.copyWith(color: TossColors.white),
          ),
          backgroundColor: TossColors.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(TossBorderRadius.lg),
          ),
        ),
      );
      return;
    }
    
    try {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const Center(
            child: TossLoadingView(),
          );
        },
      );
      
      // Get user ID from app state
      final appState = ref.read(appStateProvider);
      final userId = appState.user['user_id'] ?? '';
      
      if (userId.isEmpty) {
        throw Exception('User ID not found');
      }
      
      // Debug log
      print('RPC manager_shift_delete_tag Parameters:');
      print('  p_tag_id: $tagId');
      print('  p_user_id: $userId');
      
      // Call RPC to delete tag
      final response = await Supabase.instance.client.rpc(
        'manager_shift_delete_tag',
        params: {
          'p_tag_id': tagId,
          'p_user_id': userId,
        },
      );
      
      // Debug log response
      print('RPC Response: $response');
      
      // Close loading dialog
      if (mounted) {
        Navigator.of(context).pop();
      }
      
      // Check response
      if (response != null && response is Map) {
        final success = response['success'] ?? false;
        
        if (!success) {
          // Handle error response
          final errorMessage = response['message'] ?? 'Failed to delete tag';
          final errorCode = response['error'] ?? 'UNKNOWN_ERROR';
          
          print('RPC Error: $errorCode - $errorMessage');
          
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  errorMessage,
                  style: TossTextStyles.body.copyWith(color: TossColors.white),
                ),
                backgroundColor: TossColors.error,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                ),
                margin: const EdgeInsets.all(TossSpacing.space4),
                duration: const Duration(seconds: 3),
              ),
            );
          }
          return;
        }
      }
      
      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Tag deleted successfully',
              style: TossTextStyles.body.copyWith(color: TossColors.white),
            ),
            backgroundColor: TossColors.success,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(TossBorderRadius.lg),
            ),
            margin: const EdgeInsets.all(TossSpacing.space4),
            duration: const Duration(seconds: 2),
          ),
        );
        
        // Don't modify widget.card directly, just close with success flag
        // The parent will refresh the data
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      // Close loading dialog if still open
      if (mounted) {
        Navigator.of(context).pop();
      }
      
      // Show error message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Failed to delete tag: ${e.toString()}',
              style: TossTextStyles.body.copyWith(color: TossColors.white),
            ),
            backgroundColor: TossColors.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(TossBorderRadius.lg),
            ),
            margin: const EdgeInsets.all(TossSpacing.space4),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final card = widget.card;
    final hasUnsolvedProblem = card['is_problem'] == true && card['is_problem_solved'] != true;
    
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.8 - MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: BoxDecoration(
        color: TossColors.background,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
        boxShadow: [
          BoxShadow(
            color: TossColors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: TossSpacing.space3),
            width: 36,
            height: 4,
            decoration: BoxDecoration(
              color: TossColors.gray300,
              borderRadius: BorderRadius.circular(TossBorderRadius.full),
            ),
          ),
          // Header with user info
          Container(
            padding: const EdgeInsets.fromLTRB(
              TossSpacing.space5,
              TossSpacing.space4,
              TossSpacing.space5,
              TossSpacing.space3,
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        TossColors.primary.withValues(alpha: 0.8),
                        TossColors.primary,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(TossBorderRadius.xxl),
                  ),
                  child: Center(
                    child: Text(
                      (card['user_name'] ?? '?')[0].toUpperCase(),
                      style: TossTextStyles.body.copyWith(
                        color: TossColors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: TossSpacing.space3),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        card['user_name'] ?? 'Unknown',
                        style: TossTextStyles.body.copyWith(
                          color: TossColors.gray900,
                          fontWeight: FontWeight.w700,
                          fontSize: 17,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${card['shift_name'] ?? ''} • ${card['request_date'] ?? ''}',
                        style: TossTextStyles.bodySmall.copyWith(
                          color: TossColors.gray600,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: TossColors.gray100,
                      borderRadius: BorderRadius.circular(TossBorderRadius.xl),
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
          // Tab Bar - Same style as main page
          Container(
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
                      alignment: _tabController.index == 0 
                        ? Alignment.centerLeft 
                        : _tabController.index == 1
                          ? Alignment.center
                          : Alignment.centerRight,
                      duration: Duration(milliseconds: 250),
                      curve: Curves.easeInOut,
                      child: FractionallySizedBox(
                        widthFactor: 1/3,
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
                                  child: Text('Info'),
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
                                  child: Text('Manage'),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              if (_tabController.index != 2) {
                                _tabController.animateTo(2);
                                HapticFeedback.lightImpact();
                              }
                            },
                            child: Container(
                              color: TossColors.transparent,
                              child: Center(
                                child: AnimatedDefaultTextStyle(
                                  duration: Duration(milliseconds: 200),
                                  style: TossTextStyles.bodySmall.copyWith(
                                    color: _tabController.index == 2 
                                      ? TossColors.gray900 
                                      : TossColors.gray600,
                                    fontWeight: _tabController.index == 2 
                                      ? FontWeight.w700 
                                      : FontWeight.w500,
                                  ),
                                  child: Text('Bonus'),
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
          const SizedBox(height: TossSpacing.space3),
          // Tab Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Info Tab
                _buildInfoTab(card, hasUnsolvedProblem),
                // Manage Tab
                _buildManageTab(card),
                // Bonus Tab
                _buildBonusTab(card),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildInfoTab(Map<String, dynamic> card, bool hasUnsolvedProblem) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Problem Alert if there's an unsolved problem
          if (hasUnsolvedProblem) ...[
            Container(
              margin: const EdgeInsets.fromLTRB(
                TossSpacing.space5,
                TossSpacing.space2,
                TossSpacing.space5,
                TossSpacing.space3,
              ),
              padding: const EdgeInsets.all(TossSpacing.space4),
              decoration: BoxDecoration(
                color: TossColors.error.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(TossBorderRadius.xl),
                border: Border.all(
                  color: TossColors.error.withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.warning_amber_rounded,
                        color: TossColors.error,
                        size: 20,
                      ),
                      const SizedBox(width: TossSpacing.space2),
                      Text(
                        'Problem Detected',
                        style: TossTextStyles.body.copyWith(
                          color: TossColors.error,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  if (card['problem_type'] != null) ...[
                    const SizedBox(height: TossSpacing.space2),
                    Text(
                      'Type: ${card['problem_type']}',
                      style: TossTextStyles.bodySmall.copyWith(
                        color: TossColors.error.withValues(alpha: 0.8),
                      ),
                    ),
                  ],
                  if (card['problem_description'] != null) ...[
                    const SizedBox(height: TossSpacing.space2),
                    Text(
                      card['problem_description'],
                      style: TossTextStyles.bodySmall.copyWith(
                        color: TossColors.gray700,
                      ),
                    ),
                  ],
                  // Display report reason if the problem has been reported
                  if (card['is_reported'] == true && card['report_reason'] != null) ...[
                    const SizedBox(height: TossSpacing.space2),
                    Text(
                      card['report_reason'],
                      style: TossTextStyles.bodySmall.copyWith(
                        color: TossColors.gray700,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
          
          // Primary Time Info - Most Important (Confirmed Times)
          Container(
                      margin: const EdgeInsets.fromLTRB(
                        TossSpacing.space5,
                        TossSpacing.space2,
                        TossSpacing.space5,
                        TossSpacing.space3,
                      ),
                      padding: const EdgeInsets.all(TossSpacing.space5),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            TossColors.primary.withValues(alpha: 0.05),
                            TossColors.primary.withValues(alpha: 0.02),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(TossBorderRadius.xxl),
                        border: Border.all(
                          color: TossColors.primary.withValues(alpha: 0.1),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title with icon
                          Row(
                            children: [
                              Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  color: TossColors.primary.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(TossBorderRadius.md),
                                ),
                                child: const Icon(
                                  Icons.access_time_filled,
                                  size: 18,
                                  color: TossColors.primary,
                                ),
                              ),
                              const SizedBox(width: TossSpacing.space3),
                              Text(
                                'Confirmed Working Hours',
                                style: TossTextStyles.body.copyWith(
                                  color: TossColors.gray700,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: TossSpacing.space5),
                          // Time display in big format
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      'START',
                                      style: TossTextStyles.caption.copyWith(
                                        color: TossColors.gray500,
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                    const SizedBox(height: TossSpacing.space2),
                                    Text(
                                      card['confirm_start_time'] ?? '--:--',
                                      style: TossTextStyles.display.copyWith(
                                        fontWeight: FontWeight.w700,
                                        color: card['confirm_start_time'] != null 
                                          ? TossColors.gray900 
                                          : TossColors.gray400,
                                        fontFamily: 'JetBrains Mono',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                width: 1,
                                height: 50,
                                color: TossColors.gray200,
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      'END',
                                      style: TossTextStyles.caption.copyWith(
                                        color: TossColors.gray500,
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                    const SizedBox(height: TossSpacing.space2),
                                    Text(
                                      card['confirm_end_time'] ?? '--:--',
                                      style: TossTextStyles.display.copyWith(
                                        fontWeight: FontWeight.w700,
                                        color: card['confirm_end_time'] != null 
                                          ? TossColors.gray900 
                                          : TossColors.gray400,
                                        fontFamily: 'JetBrains Mono',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          // Total hours if available
                          if (card['paid_hour'] != null && card['paid_hour'] > 0) ...[
                            const SizedBox(height: TossSpacing.space4),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: TossSpacing.space3,
                                vertical: TossSpacing.space2,
                              ),
                              decoration: BoxDecoration(
                                color: TossColors.background,
                                borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.timer_outlined,
                                    size: 16,
                                    color: TossColors.gray600,
                                  ),
                                  const SizedBox(width: TossSpacing.space2),
                                  Text(
                                    'Total: ${card['paid_hour']} hours',
                                    style: TossTextStyles.body.copyWith(
                                      color: TossColors.gray700,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    
                    // Quick Status Pills
                    Container(
                      height: 36,
                      margin: const EdgeInsets.only(bottom: TossSpacing.space4),
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space5),
                        children: [
                          // Approval status
                          _buildStatusPill(
                            icon: card['is_approved'] == true 
                              ? Icons.check_circle 
                              : Icons.pending,
                            label: card['is_approved'] == true ? 'Approved' : 'Pending',
                            color: card['is_approved'] == true 
                              ? TossColors.success 
                              : TossColors.warning,
                          ),
                          // Problem status
                          if (card['is_problem'] == true)
                            _buildStatusPill(
                              icon: card['is_problem_solved'] == true 
                                ? Icons.check_circle_outline 
                                : Icons.warning_amber_rounded,
                              label: card['is_problem_solved'] == true 
                                ? 'Problem Solved' 
                                : 'Has Problem',
                              color: card['is_problem_solved'] == true 
                                ? TossColors.success 
                                : TossColors.error,
                            ),
                          // Late status
                          if (card['is_late'] == true)
                            _buildStatusPill(
                              icon: Icons.schedule,
                              label: 'Late ${card['late_minute']}min',
                              color: TossColors.error,
                            ),
                          // Overtime
                          if (card['is_over_time'] == true)
                            _buildStatusPill(
                              icon: Icons.trending_up,
                              label: 'OT ${card['over_time_minute']}min',
                              color: TossColors.info,
                            ),
                        ],
                      ),
                    ),
                    
                    // Shift Information Card
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: TossSpacing.space5),
                      padding: const EdgeInsets.all(TossSpacing.space4),
                      decoration: BoxDecoration(
                        color: TossColors.gray50,
                        borderRadius: BorderRadius.circular(TossBorderRadius.xl),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Shift Details',
                            style: TossTextStyles.body.copyWith(
                              color: TossColors.gray900,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: TossSpacing.space3),
                          _buildDetailRow('Store', card['store_name'] ?? 'N/A'),
                          _buildDetailRow('Shift Type', card['shift_name'] ?? 'N/A'),
                          _buildDetailRow('Scheduled Time', card['shift_time'] ?? 'N/A'),
                        ],
                      ),
                    ),
                    const SizedBox(height: TossSpacing.space3),
                    
                    // Actual Check-in/out Times
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: TossSpacing.space5),
                      padding: const EdgeInsets.all(TossSpacing.space4),
                      decoration: BoxDecoration(
                        color: TossColors.gray50,
                        borderRadius: BorderRadius.circular(TossBorderRadius.xl),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Check-in/out Records',
                            style: TossTextStyles.body.copyWith(
                              color: TossColors.gray900,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: TossSpacing.space3),
                          _buildDetailRow('Actual Check-in', card['actual_start'] ?? 'Not checked in'),
                          _buildDetailRow('Actual Check-out', card['actual_end'] ?? 'Not checked out'),
                        ],
                      ),
                    ),
                    const SizedBox(height: TossSpacing.space3),
                    
                    // Location section (if available)
                    if (card['is_valid_checkin_location'] != null || card['is_valid_checkout_location'] != null) ...[
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: TossSpacing.space5),
                        padding: const EdgeInsets.all(TossSpacing.space4),
                        decoration: BoxDecoration(
                          color: TossColors.gray50,
                          borderRadius: BorderRadius.circular(TossBorderRadius.xl),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Location',
                              style: TossTextStyles.body.copyWith(
                                color: TossColors.gray900,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: TossSpacing.space3),
                            if (card['is_valid_checkin_location'] != null)
                              _buildDetailRow('Check-in Location', 
                                card['is_valid_checkin_location'] == true ? 'Valid' : 'Invalid',
                                valueColor: card['is_valid_checkin_location'] == true ? TossColors.success : TossColors.error),
                            if (card['checkin_distance_from_store'] != null && card['checkin_distance_from_store'] > 0)
                              _buildDetailRow('Check-in Distance', '${card['checkin_distance_from_store']}m from store'),
                            if (card['is_valid_checkout_location'] != null)
                              _buildDetailRow('Check-out Location', 
                                card['is_valid_checkout_location'] == true ? 'Valid' : 'Invalid',
                                valueColor: card['is_valid_checkout_location'] == true ? TossColors.success : TossColors.error),
                            if (card['checkout_distance_from_store'] != null && card['checkout_distance_from_store'] > 0)
                              _buildDetailRow('Check-out Distance', '${card['checkout_distance_from_store']}m from store'),
                          ],
                        ),
                      ),
                      const SizedBox(height: TossSpacing.space4),
                    ],
                    
                    // Additional info
                    if (card['notice_tag'] != null && (card['notice_tag'] as List).isNotEmpty) ...[
                      _buildSectionTitle('Notice Tags'),
                      Container(
                        padding: const EdgeInsets.all(TossSpacing.space4),
                        decoration: BoxDecoration(
                          color: TossColors.gray50,
                          borderRadius: BorderRadius.circular(TossBorderRadius.xl),
                        ),
                        child: Wrap(
                          spacing: TossSpacing.space2,
                          runSpacing: TossSpacing.space2,
                          children: (card['notice_tag'] as List).map((tag) {
                            // Parse tag as a Map and extract only content
                            final tagData = tag is Map ? tag : {};
                            final content = tagData['content'] ?? 'No content';
                            
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: TossSpacing.space3,
                                vertical: TossSpacing.space1,
                              ),
                              decoration: BoxDecoration(
                                color: TossColors.primary.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                              ),
                              child: Text(
                                content,
                                style: TossTextStyles.caption.copyWith(
                                  color: TossColors.primary,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      const SizedBox(height: TossSpacing.space4),
                    ],
                    
                    const SizedBox(height: TossSpacing.space5),
                  ],
                ),
              );
  }
  
  Widget _buildManageTab(Map<String, dynamic> card) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(TossSpacing.space5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Edit Confirmed Times Section
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(TossSpacing.space4),
                  decoration: BoxDecoration(
                    color: TossColors.gray50,
                    borderRadius: BorderRadius.circular(TossBorderRadius.xl),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.edit_outlined,
                            size: 20,
                            color: TossColors.gray700,
                          ),
                          const SizedBox(width: TossSpacing.space2),
                          Text(
                            'Edit Confirmed Times',
                            style: TossTextStyles.body.copyWith(
                              color: TossColors.gray900,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: TossSpacing.space4),
                      // Start Time Editor
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Start Time',
                            style: TossTextStyles.body.copyWith(
                              color: TossColors.gray600,
                            ),
                          ),
                          SizedBox(
                            width: 120,
                            child: TossTimePicker(
                              time: _parseTimeString(editedStartTime),
                              placeholder: '--:--',
                              use24HourFormat: false,
                              onTimeChanged: (TimeOfDay time) {
                                setState(() {
                                  editedStartTime = _formatTimeOfDay(time);
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: TossSpacing.space3),
                      // End Time Editor
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'End Time',
                            style: TossTextStyles.body.copyWith(
                              color: TossColors.gray600,
                            ),
                          ),
                          SizedBox(
                            width: 120,
                            child: TossTimePicker(
                              time: _parseTimeString(editedEndTime),
                              placeholder: '--:--',
                              use24HourFormat: false,
                              onTimeChanged: (TimeOfDay time) {
                                setState(() {
                                  editedEndTime = _formatTimeOfDay(time);
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: TossSpacing.space4),
                
                // Problem Status Section
                Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(TossSpacing.space4),
                    decoration: BoxDecoration(
                      color: TossColors.gray50,
                      borderRadius: BorderRadius.circular(TossBorderRadius.xl),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header with problem status
                        Row(
                          children: [
                            Icon(
                              Icons.warning_amber_rounded,
                              size: 20,
                              color: isProblemSolved ? TossColors.success : TossColors.warning,
                            ),
                            const SizedBox(width: TossSpacing.space2),
                            Text(
                              'Problem Status',
                              style: TossTextStyles.body.copyWith(
                                color: TossColors.gray900,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: TossSpacing.space3),
                        // Animated toggle button - Same style as journal input
                        Container(
                          height: 48,
                          decoration: BoxDecoration(
                            color: TossColors.gray50,
                            borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                          ),
                          padding: EdgeInsets.all(TossSpacing.space1),
                          child: Stack(
                            children: [
                              // Animated selection indicator
                              AnimatedAlign(
                                alignment: isProblemSolved 
                                  ? Alignment.centerRight 
                                  : Alignment.centerLeft,
                                duration: Duration(milliseconds: 250),
                                curve: Curves.easeInOut,
                                child: FractionallySizedBox(
                                  widthFactor: 0.5,
                                  child: Container(
                                    margin: EdgeInsets.symmetric(horizontal: 2),
                                    decoration: BoxDecoration(
                                      color: isProblemSolved 
                                        ? TossColors.success 
                                        : TossColors.warning,
                                      borderRadius: BorderRadius.circular(TossBorderRadius.xxl),
                                      boxShadow: [
                                        BoxShadow(
                                          color: (isProblemSolved 
                                            ? TossColors.success 
                                            : TossColors.warning).withValues(alpha: 0.3),
                                          blurRadius: 8,
                                          offset: Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              // Buttons
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildProblemToggleButton('Not solve', false),
                                  ),
                                  Expanded(
                                    child: _buildProblemToggleButton('Solved', true),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: TossSpacing.space2),
                        // Status description
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          child: Row(
                            children: [
                              Icon(
                                isProblemSolved ? Icons.check_circle_outline : Icons.info_outline,
                                size: 16,
                                color: isProblemSolved ? TossColors.success : TossColors.gray600,
                              ),
                              const SizedBox(width: TossSpacing.space1),
                              Expanded(
                                child: Text(
                                  isProblemSolved 
                                    ? 'The shift problem has been resolved'
                                    : 'Toggle on when the problem is resolved',
                                  style: TossTextStyles.caption.copyWith(
                                    color: isProblemSolved ? TossColors.success : TossColors.gray600,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                ),
                const SizedBox(height: TossSpacing.space4),
                
                // Add Tag Section
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(TossSpacing.space4),
                  decoration: BoxDecoration(
                    color: TossColors.gray50,
                    borderRadius: BorderRadius.circular(TossBorderRadius.xl),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.label_outline,
                            size: 20,
                            color: TossColors.gray700,
                          ),
                          const SizedBox(width: TossSpacing.space2),
                          Text(
                            'Add Tag',
                            style: TossTextStyles.body.copyWith(
                              color: TossColors.gray900,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: TossSpacing.space4),
                      
                      // Tag Type Selector
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: TossSpacing.space3,
                          vertical: TossSpacing.space1,
                        ),
                        decoration: BoxDecoration(
                          color: TossColors.background,
                          borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                          border: Border.all(
                            color: TossColors.gray200,
                            width: 1,
                          ),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: selectedTagType,
                            hint: Text(
                              'Select Tag Type',
                              style: TossTextStyles.body.copyWith(
                                color: TossColors.gray400,
                              ),
                            ),
                            isExpanded: true,
                            icon: const Icon(
                              Icons.keyboard_arrow_down,
                              color: TossColors.gray500,
                            ),
                            style: TossTextStyles.body.copyWith(
                              color: TossColors.gray900,
                            ),
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedTagType = newValue;
                              });
                            },
                            items: tagTypes.map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      const SizedBox(height: TossSpacing.space3),
                      
                      // Tag Content Text Field
                      Container(
                        decoration: BoxDecoration(
                          color: TossColors.background,
                          borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                          border: Border.all(
                            color: TossColors.gray200,
                            width: 1,
                          ),
                        ),
                        child: TextField(
                          onChanged: (value) {
                            setState(() {
                              tagContent = value.isEmpty ? null : value;
                            });
                          },
                          decoration: InputDecoration(
                            hintText: 'Enter tag content...',
                            hintStyle: TossTextStyles.body.copyWith(
                              color: TossColors.gray400,
                            ),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.all(TossSpacing.space3),
                          ),
                          style: TossTextStyles.body.copyWith(
                            color: TossColors.gray900,
                          ),
                          maxLines: 3,
                          minLines: 2,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Existing Tags Display - Always show the section for consistent layout
                const SizedBox(height: TossSpacing.space4),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(TossSpacing.space4),
                  decoration: BoxDecoration(
                    color: TossColors.gray50,
                    borderRadius: BorderRadius.circular(TossBorderRadius.xl),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Existing Tags',
                        style: TossTextStyles.body.copyWith(
                          color: TossColors.gray900,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: TossSpacing.space3),
                      if (card['notice_tag'] != null && (card['notice_tag'] as List).isNotEmpty)
                        Wrap(
                          spacing: TossSpacing.space2,
                          runSpacing: TossSpacing.space2,
                          children: (card['notice_tag'] as List).map((tag) {
                            // Parse tag as a Map if it's not already
                            final tagData = tag is Map ? tag : {};
                            final content = tagData['content'] ?? 'No content';
                            final tagId = tagData['id']?.toString() ?? '';
                            
                            // Only show delete option if tag has a valid ID
                            if (tagId.isEmpty) {
                              return Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: TossSpacing.space3,
                                  vertical: TossSpacing.space2,
                                ),
                                decoration: BoxDecoration(
                                  color: TossColors.gray100,
                                  borderRadius: BorderRadius.circular(TossBorderRadius.xxl),
                                ),
                                child: Text(
                                  content,
                                  style: TossTextStyles.bodySmall.copyWith(
                                    color: TossColors.gray600,
                                  ),
                                ),
                              );
                            }
                            
                            return GestureDetector(
                              onTap: () => _showDeleteTagDialog(context, tagId.toString(), content),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: TossSpacing.space3,
                                  vertical: TossSpacing.space2,
                                ),
                                decoration: BoxDecoration(
                                  color: TossColors.primary.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(TossBorderRadius.xxl),
                                  border: Border.all(
                                    color: TossColors.primary.withValues(alpha: 0.2),
                                    width: 1,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      content,
                                      style: TossTextStyles.bodySmall.copyWith(
                                        color: TossColors.primary,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(width: TossSpacing.space1),
                                    Icon(
                                      Icons.close,
                                      size: 14,
                                      color: TossColors.primary.withValues(alpha: 0.6),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        )
                      else
                        Text(
                          'No tags added yet',
                          style: TossTextStyles.bodySmall.copyWith(
                            color: TossColors.gray400,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: TossSpacing.space5),
              ],
            ),
          ),
        ),
        
        // Bottom Action Buttons
        Container(
          padding: const EdgeInsets.all(TossSpacing.space4),
          decoration: BoxDecoration(
            color: TossColors.background,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            boxShadow: [
              BoxShadow(
                color: TossColors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: SafeArea(
            child: Column(
              children: [
                // First Row: Not Approve button (full width)
                _buildBottomButton(
                  'Not Approve',
                  TossColors.warning,
                  Icons.remove_circle_outline,
                  card['is_approved'] == false ? null : () => _showNotApproveDialog(context, card),
                  outlined: true,
                  disabled: card['is_approved'] == false,
                ),
                const SizedBox(height: TossSpacing.space3),
                // Second Row: Save button (full width)
                _buildBottomButton(
                  'Save',
                  TossColors.primary,
                  Icons.save_outlined,
                  hasChanges() ? () async {
                    // Validate tag inputs - both must be provided or both must be empty
                    final hasTagType = selectedTagType != null && selectedTagType!.trim().isNotEmpty;
                    final hasTagContent = tagContent != null && tagContent!.trim().isNotEmpty;
                    
                    if (hasTagType != hasTagContent) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Please fill both tag type and content or leave both empty',
                            style: TossTextStyles.body.copyWith(color: TossColors.white),
                          ),
                          backgroundColor: TossColors.error,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                          ),
                        ),
                      );
                      return;
                    }
                    
                    // Additional validation for tag content length
                    if (hasTagContent && tagContent!.trim().length > 500) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Tag content cannot exceed 500 characters',
                            style: TossTextStyles.body.copyWith(color: TossColors.white),
                          ),
                          backgroundColor: TossColors.error,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                          ),
                        ),
                      );
                      return;
                    }
                    
                    // Show confirmation dialog
                    final bool? shouldSave = await showDialog<bool>(
                      context: context,
                      builder: (BuildContext dialogContext) {
                        return AlertDialog(
                          backgroundColor: TossColors.background,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(TossBorderRadius.xxl),
                          ),
                          title: Text(
                            'Confirm Save',
                            style: TossTextStyles.body.copyWith(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: TossColors.gray900,
                            ),
                          ),
                          content: Text(
                            'Do you want to save the changes?',
                            style: TossTextStyles.body.copyWith(
                              color: TossColors.gray700,
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(dialogContext, false),
                              child: Text(
                                'Cancel',
                                style: TossTextStyles.body.copyWith(
                                  color: TossColors.gray600,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(dialogContext, true),
                              style: TextButton.styleFrom(
                                backgroundColor: TossColors.primary.withValues(alpha: 0.1),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space2),
                                child: Text(
                                  'OK',
                                  style: TossTextStyles.body.copyWith(
                                    color: TossColors.primary,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                    
                    // If user cancelled, return
                    if (shouldSave != true) {
                      return;
                    }
                    
                    // Get values from app state and card
                    final appState = ref.read(appStateProvider);
                    final userId = appState.user['user_id'];
                    final shiftRequestId = widget.card['shift_request_id'];
                    final isLate = widget.card['is_late'] ?? false;
                    
                    // Show loading indicator
                    showDialog(
                      context: context,
                      barrierDismissible: true, // Allow dismissing loading dialogs
                      builder: (BuildContext context) {
                        return const Center(
                          child: const TossLoadingView(
                          ),
                        );
                      },
                    );
                    
                    try {
                      // Format times to ensure HH:mm format (24-hour)
                      String? formatTimeToHHmm(String? timeStr) {
                        if (timeStr == null || timeStr == '--:--' || timeStr.isEmpty) return null;
                        
                        // If already in HH:mm format, validate and return
                        if (RegExp(r'^\d{2}:\d{2}$').hasMatch(timeStr)) {
                          final parts = timeStr.split(':');
                          final hour = int.parse(parts[0]);
                          final minute = int.parse(parts[1]);
                          // Validate time values
                          if (hour >= 0 && hour <= 23 && minute >= 0 && minute <= 59) {
                            return timeStr;
                          }
                        }
                        
                        // Try to extract time from datetime string
                        try {
                          if (timeStr.contains('T') || timeStr.contains(' ')) {
                            final parts = timeStr.split(RegExp(r'[T ]'));
                            if (parts.length > 1) {
                              final timePart = parts[1];
                              final timeComponents = timePart.split(':');
                              if (timeComponents.length >= 2) {
                                final hour = int.tryParse(timeComponents[0]) ?? 0;
                                final minute = int.tryParse(timeComponents[1]) ?? 0;
                                if (hour >= 0 && hour <= 23 && minute >= 0 && minute <= 59) {
                                  return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
                                }
                              }
                            }
                          }
                          return null; // Return null if can't parse properly
                        } catch (e) {
                          return null;
                        }
                      }
                      
                      // Format times - these should already be in HH:mm format from _formatTimeOfDay
                      final startTime = formatTimeToHHmm(editedStartTime ?? widget.card['confirm_start_time']);
                      final endTime = formatTimeToHHmm(editedEndTime ?? widget.card['confirm_end_time']);
                      
                      // Prepare tag parameters - ensure null instead of empty strings
                      final processedTagContent = (tagContent != null && tagContent!.trim().isNotEmpty) 
                          ? tagContent!.trim() 
                          : null;
                      final processedTagType = (selectedTagType != null && selectedTagType!.trim().isNotEmpty)
                          ? selectedTagType!.trim()
                          : null;
                      
                      // Ensure shiftRequestId is valid
                      if (shiftRequestId == null || shiftRequestId.isEmpty) {
                        throw Exception('Invalid shift request ID');
                      }
                      
                      // Debug log to verify parameters
                      print('RPC Parameters:');
                      print('  p_manager_id: $userId');
                      print('  p_shift_request_id: $shiftRequestId');
                      print('  p_confirm_start_time: $startTime');
                      print('  p_confirm_end_time: $endTime');
                      print('  p_new_tag_content: $processedTagContent');
                      print('  p_new_tag_type: $processedTagType');
                      print('  p_is_late: $isLate');
                      print('  p_is_problem_solved: $isProblemSolved');
                      
                      // Call the RPC with properly formatted parameters
                      final response = await Supabase.instance.client.rpc(
                        'manager_shift_input_card',
                        params: {
                          'p_manager_id': userId,
                          'p_confirm_start_time': startTime,
                          'p_confirm_end_time': endTime,
                          'p_new_tag_content': processedTagContent,
                          'p_new_tag_type': processedTagType,
                          'p_is_late': isLate,
                          'p_shift_request_id': shiftRequestId,
                          'p_is_problem_solved': isProblemSolved,
                        },
                      );
                      
                      // Check if RPC returned an error structure
                      if (response != null && response is Map) {
                        if (response['success'] == false) {
                          final errorMessage = response['message'] ?? 'Unknown error occurred';
                          final errorCode = response['error'] ?? 'UNKNOWN_ERROR';
                          throw Exception('$errorCode: $errorMessage');
                        }
                      }
                      
                      // Close loading dialog
                      Navigator.pop(context);
                      
                      // Show success message
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Successfully saved',
                            style: TossTextStyles.body.copyWith(color: TossColors.white),
                          ),
                          backgroundColor: TossColors.success,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                          ),
                        ),
                      );
                      
                      // Close bottom sheet and trigger refresh
                      Navigator.pop(context, true); // Return true to indicate data changed
                      
                    } catch (e) {
                      // Close loading dialog
                      Navigator.pop(context);
                      
                      // Show error message
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Failed to save: ${e.toString()}',
                            style: TossTextStyles.body.copyWith(color: TossColors.white),
                          ),
                          backgroundColor: TossColors.error,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                          ),
                        ),
                      );
                    }
                  } : null,
                  outlined: false,
                  fullWidth: true,
                  disabled: !hasChanges(),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
  
  Widget _buildBottomButton(
    String label,
    Color color,
    IconData icon,
    VoidCallback? onTap, {
    bool outlined = false,
    bool fullWidth = false,
    bool disabled = false,
  }) {
    final effectiveColor = disabled ? TossColors.gray300 : color;
    
    return Material(
      color: TossColors.transparent,
      child: InkWell(
        onTap: disabled ? null : onTap,
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: TossSpacing.space4,
            vertical: TossSpacing.space3,
          ),
          decoration: BoxDecoration(
            color: outlined ? TossColors.transparent : (disabled ? TossColors.gray100 : effectiveColor),
            borderRadius: BorderRadius.circular(TossBorderRadius.lg),
            border: Border.all(
              color: outlined ? (disabled ? TossColors.gray200 : effectiveColor.withValues(alpha: 0.3)) : (disabled ? TossColors.gray200 : effectiveColor),
              width: outlined ? 1.5 : 0,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 20,
                color: disabled 
                    ? TossColors.gray400 
                    : (outlined ? effectiveColor : TossColors.white),
              ),
              const SizedBox(width: TossSpacing.space2),
              Text(
                label,
                style: TossTextStyles.body.copyWith(
                  color: disabled 
                      ? TossColors.gray400 
                      : (outlined ? effectiveColor : TossColors.white),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  // Helper widget for detail rows
  Widget _buildDetailRow(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: TossSpacing.space2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TossTextStyles.bodySmall.copyWith(
              color: TossColors.gray600,
            ),
          ),
          Text(
            value,
            style: TossTextStyles.bodySmall.copyWith(
              color: valueColor ?? TossColors.gray900,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
  
  // Helper widget for status pills in bottom sheet
  Widget _buildStatusPill({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      margin: const EdgeInsets.only(right: TossSpacing.space2),
      padding: const EdgeInsets.symmetric(
        horizontal: TossSpacing.space3,
        vertical: TossSpacing.space2,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(TossBorderRadius.xl),
        border: Border.all(
          color: color.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: color,
          ),
          const SizedBox(width: TossSpacing.space1),
          Text(
            label,
            style: TossTextStyles.bodySmall.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
  
  // Helper widget for section titles
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(
        top: TossSpacing.space2,
        bottom: TossSpacing.space3,
      ),
      child: Text(
        title,
        style: TossTextStyles.body.copyWith(
          color: TossColors.gray900,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
  
  // Build Bonus tab content
  Widget _buildBonusTab(Map<String, dynamic> card) {
    // Extract salary information from card data
    final String salaryType = card['salary_type'] ?? 'hourly';
    final String salaryAmountStr = card['salary_amount'] ?? '0';
    final dynamic rawBasePay = card['base_pay'] ?? '0';
    final dynamic rawBonusAmount = card['bonus_amount'];
    final dynamic rawTotalPay = card['total_pay_with_bonus'] ?? '0';
    
    // Parse numeric values
    final num salaryAmount = num.tryParse(salaryAmountStr.replaceAll(',', '')) ?? 0;
    final num basePay = rawBasePay is String 
        ? num.tryParse(rawBasePay.replaceAll(',', '')) ?? 0 
        : rawBasePay ?? 0;
    final num bonusAmount = rawBonusAmount is String 
        ? num.tryParse(rawBonusAmount) ?? 0 
        : rawBonusAmount ?? 0;
    final num totalPay = rawTotalPay is String 
        ? num.tryParse(rawTotalPay.replaceAll(',', '')) ?? 0 
        : rawTotalPay ?? 0;
    
    // Helper function to format salary type display
    String getSalaryTypeDisplay() {
      if (salaryType == 'hourly') {
        return 'Hourly Rate';
      } else if (salaryType == 'monthly') {
        return 'Monthly Salary';
      }
      return salaryType;
    }
    
    // Create scroll controller for auto-scroll when keyboard appears
    final ScrollController scrollController = ScrollController();
    
    return GestureDetector(
      onTap: () {
        // Dismiss keyboard when tapping outside
        FocusScope.of(context).unfocus();
      },
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              controller: scrollController,
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.only(
                left: TossSpacing.space5,
                right: TossSpacing.space5,
                top: TossSpacing.space5,
                bottom: MediaQuery.of(context).viewInsets.bottom + TossSpacing.space5,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                // Title
                Text(
                  'Salary & Bonus Information',
                  style: TossTextStyles.h3.copyWith(
                    color: TossColors.gray900,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: TossSpacing.space2),
                Text(
                  'View salary details and set bonus amount',
                  style: TossTextStyles.bodySmall.copyWith(
                    color: TossColors.gray600,
                  ),
                ),
                const SizedBox(height: TossSpacing.space5),
                
                // Salary Type and Amount
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(TossSpacing.space4),
                  decoration: BoxDecoration(
                    color: TossColors.gray50,
                    borderRadius: BorderRadius.circular(TossBorderRadius.xl),
                    border: Border.all(
                      color: TossColors.gray200,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            getSalaryTypeDisplay(),
                            style: TossTextStyles.caption.copyWith(
                              color: TossColors.gray600,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: TossSpacing.space1),
                          Text(
                            salaryAmount > 0 
                                ? NumberFormat('#,###').format(salaryAmount.toInt())
                                : '0',
                            style: TossTextStyles.body.copyWith(
                              color: TossColors.gray900,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: TossSpacing.space3,
                          vertical: TossSpacing.space2,
                        ),
                        decoration: BoxDecoration(
                          color: salaryType == 'hourly' 
                              ? TossColors.primary.withValues(alpha: 0.1)
                              : TossColors.success.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(TossBorderRadius.md),
                        ),
                        child: Text(
                          salaryType == 'hourly' ? 'Per Hour' : 'Per Month',
                          style: TossTextStyles.caption.copyWith(
                            color: salaryType == 'hourly' 
                                ? TossColors.primary
                                : TossColors.success,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: TossSpacing.space3),
                
                // Combined Payment Information Box with Blue Design
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(TossSpacing.space4),
                  decoration: BoxDecoration(
                    color: TossColors.info.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(TossBorderRadius.xl),
                    border: Border.all(
                      color: TossColors.info.withValues(alpha: 0.2),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      Text(
                        'Payment Details',
                        style: TossTextStyles.body.copyWith(
                          color: TossColors.gray900,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: TossSpacing.space3),
                      
                      // Base Pay Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Base Pay',
                            style: TossTextStyles.caption.copyWith(
                              color: TossColors.gray600,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            basePay != 0 
                                ? NumberFormat('#,###').format(basePay.toInt())
                                : '0',
                            style: TossTextStyles.body.copyWith(
                              color: basePay < 0 ? TossColors.error : TossColors.gray700,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: TossSpacing.space2),
                      
                      // Current Bonus Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Current Bonus',
                            style: TossTextStyles.caption.copyWith(
                              color: TossColors.gray600,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            bonusAmount > 0 
                                ? '+ ${NumberFormat('#,###').format(bonusAmount.toInt())}'
                                : '+ 0',
                            style: TossTextStyles.body.copyWith(
                              color: TossColors.info,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      
                      // Divider
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: TossSpacing.space2),
                        height: 1,
                        color: TossColors.info.withValues(alpha: 0.2),
                      ),
                      
                      // Total Pay Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total Pay',
                            style: TossTextStyles.body.copyWith(
                              color: TossColors.gray700,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            totalPay != 0 
                                ? NumberFormat('#,###').format(totalPay.toInt())
                                : NumberFormat('#,###').format((basePay + bonusAmount).toInt()),
                            style: TossTextStyles.h3.copyWith(
                              color: (totalPay != 0 ? totalPay : (basePay + bonusAmount)) < 0 
                                  ? TossColors.error 
                                  : TossColors.info,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: TossSpacing.space5),
                
                // Divider
                Container(
                  height: 1,
                  color: TossColors.gray200,
                ),
                const SizedBox(height: TossSpacing.space5),
                
                // New Bonus Section Title
                Text(
                  'Set New Bonus',
                  style: TossTextStyles.body.copyWith(
                    color: TossColors.gray900,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: TossSpacing.space2),
                Text(
                  'Enter a new bonus amount for this shift',
                  style: TossTextStyles.caption.copyWith(
                    color: TossColors.gray600,
                  ),
                ),
                const SizedBox(height: TossSpacing.space3),
                
                // Bonus input field
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: TossSpacing.space4,
                    vertical: TossSpacing.space3,
                  ),
                  decoration: BoxDecoration(
                    color: TossColors.white,
                    borderRadius: BorderRadius.circular(TossBorderRadius.xl),
                    border: Border.all(
                      color: TossColors.gray300,
                      width: 1.5,
                    ),
                  ),
                  child: TextField(
                    controller: bonusController,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      ThousandSeparatorInputFormatter(),
                    ],
                    style: TossTextStyles.h3.copyWith(
                      color: TossColors.gray900,
                      fontWeight: FontWeight.w700,
                    ),
                    decoration: InputDecoration(
                      hintText: '0',
                      hintStyle: TossTextStyles.h3.copyWith(
                        color: TossColors.gray400,
                        fontWeight: FontWeight.w700,
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                    ),
                    onTap: () {
                      // Auto-scroll to make the input field visible when keyboard appears
                      Future.delayed(const Duration(milliseconds: 300), () {
                        if (scrollController.hasClients) {
                          scrollController.animateTo(
                            scrollController.position.maxScrollExtent,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        }
                      });
                    },
                  ),
                ),
                // Add extra padding at the bottom for keyboard
                const SizedBox(height: TossSpacing.space10),
              ],
            ),
          ),
        ),
        // Bottom button section
        Container(
          padding: const EdgeInsets.all(TossSpacing.space5),
          decoration: BoxDecoration(
            color: TossColors.background,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(TossBorderRadius.xxl),
              topRight: Radius.circular(TossBorderRadius.xxl),
            ),
            boxShadow: [
              BoxShadow(
                color: TossColors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: SafeArea(
            child: _buildBottomButton(
              'Confirm Bonus',
              TossColors.primary,
              Icons.check_circle_outline,
              () {
                HapticFeedback.lightImpact();
                _showBonusConfirmationDialog();
              },
              disabled: bonusInputText.isEmpty,
            ),
          ),
        ),
      ],
      ),
    );
  }

  TimeOfDay? _parseTimeString(String? timeStr) {
    if (timeStr == null || timeStr == '--:--') return null;
    final parts = timeStr.split(':');
    if (parts.length != 2) return null;
    return TimeOfDay(
      hour: int.parse(parts[0]),
      minute: int.parse(parts[1]),
    );
  }
  
  Widget _buildProblemToggleButton(String label, bool isSolved) {
    final isSelected = isProblemSolved == isSolved;
    return GestureDetector(
      onTap: () {
        if (!isSelected) {
          setState(() {
            isProblemSolved = isSolved;
          });
          // Add haptic feedback for better user experience
          HapticFeedback.lightImpact();
        }
      },
      child: Container(
        color: TossColors.transparent,
        child: Center(
          child: AnimatedDefaultTextStyle(
            duration: Duration(milliseconds: 200),
            style: TossTextStyles.bodySmall.copyWith(
              color: isSelected ? TossColors.white : TossColors.gray700,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            ),
            child: Text(label),
          ),
        ),
      ),
    );
  }

  String _formatTimeOfDay(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }
  
  // Build stat card widget
}

// Add Shift Bottom Sheet
class _AddShiftBottomSheet extends ConsumerStatefulWidget {
  const _AddShiftBottomSheet({Key? key}) : super(key: key);

  @override
  ConsumerState<_AddShiftBottomSheet> createState() => _AddShiftBottomSheetState();
}

class _AddShiftBottomSheetState extends ConsumerState<_AddShiftBottomSheet> {
  bool _isLoading = true;
  bool _isSaving = false;
  String? _error;
  
  // Data from RPC
  List<Map<String, dynamic>> _employees = [];
  List<Map<String, dynamic>> _shifts = [];
  
  // Selected values
  String? _selectedEmployeeId;
  String? _selectedShiftId;
  DateTime? _selectedDate;
  
  @override
  void initState() {
    super.initState();
    _fetchScheduleData();
  }
  
  Future<void> _fetchScheduleData() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });
      
      // Get store_id from app state
      final appState = ref.read(appStateProvider);
      final storeId = appState.storeChoosen.isNotEmpty ? appState.storeChoosen : null;
      
      if (storeId == null || storeId.isEmpty) {
        setState(() {
          _error = 'Please select a store first';
          _isLoading = false;
        });
        return;
      }
      
      // Call RPC to get employees and shifts
      final response = await Supabase.instance.client.rpc(
        'manager_shift_get_schedule',
        params: {
          'p_store_id': storeId,
        },
      );
      
      if (response != null) {
        setState(() {
          _employees = List<Map<String, dynamic>>.from(response['store_employees'] ?? []);
          _shifts = List<Map<String, dynamic>>.from(response['store_shifts'] ?? []);
          _isLoading = false;
        });
      } else {
        setState(() {
          _error = 'Failed to load data';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Error: ${e.toString()}';
        _isLoading = false;
      });
    }
  }
  
  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 90)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: TossColors.primary,
              onPrimary: TossColors.white,
              surface: TossColors.white,
              onSurface: TossColors.gray900,
            ),
          ),
          child: child!,
        );
      },
    );
    
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }
  
  Future<void> _saveShift() async {
    try {
      setState(() {
        _isSaving = true;
      });
      
      // Get required data from app state
      final appState = ref.read(appStateProvider);
      final storeId = appState.storeChoosen.isNotEmpty ? appState.storeChoosen : null;
      final approvedBy = appState.user['user_id'] ?? '';
      
      if (storeId == null || storeId.isEmpty || approvedBy.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Error: Missing store or user information'),
            backgroundColor: TossColors.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(TossBorderRadius.md)),
          ),
        );
        setState(() {
          _isSaving = false;
        });
        return;
      }
      
      // Format the date as yyyy-MM-dd
      final formattedDate = '${_selectedDate!.year}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.day.toString().padLeft(2, '0')}';
      
      // Call RPC to insert the schedule
      await Supabase.instance.client.rpc(
        'manager_shift_insert_schedule',
        params: {
          'p_user_id': _selectedEmployeeId,
          'p_shift_id': _selectedShiftId,
          'p_store_id': storeId,
          'p_request_date': formattedDate,
          'p_approved_by': approvedBy,
        },
      );
      
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Shift scheduled successfully'),
          backgroundColor: TossColors.success,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(TossBorderRadius.md)),
        ),
      );
      
      // Close the bottom sheet and return true to indicate success
      Navigator.pop(context, true);
      
    } catch (e) {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: TossColors.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(TossBorderRadius.md)),
        ),
      );
      
      setState(() {
        _isSaving = false;
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    // Check if all required fields are filled
    final bool isFormValid = _selectedEmployeeId != null && 
                            _selectedShiftId != null && 
                            _selectedDate != null && 
                            !_isLoading && 
                            !_isSaving;
    
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: const BoxDecoration(
        color: TossColors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: TossColors.gray300,
              borderRadius: BorderRadius.circular(TossBorderRadius.xs),
            ),
          ),
          
          // Header
          Container(
            padding: const EdgeInsets.all(TossSpacing.space5),
            child: Row(
              children: [
                Text(
                  'Add Shift',
                  style: TossTextStyles.h2.copyWith(
                    color: TossColors.gray900,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Spacer(),
                InkWell(
                  onTap: () {
                    Navigator.pop(context, false);
                  },
                  borderRadius: BorderRadius.circular(TossBorderRadius.xxl),
                  child: Container(
                    padding: const EdgeInsets.all(TossSpacing.space2),
                    child: const Icon(
                      Icons.close,
                      size: 24,
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
            color: TossColors.gray200,
          ),
          
          // Content
          Expanded(
            child: _isLoading
                ? Center(
                    child: const TossLoadingView(
                    ),
                  )
                : _error != null
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.error_outline,
                              size: 48,
                              color: TossColors.error,
                            ),
                            const SizedBox(height: TossSpacing.space3),
                            Text(
                              _error!,
                              style: TossTextStyles.body.copyWith(
                                color: TossColors.error,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: TossSpacing.space4),
                            InkWell(
                              onTap: _fetchScheduleData,
                              borderRadius: BorderRadius.circular(TossBorderRadius.md),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: TossSpacing.space4,
                                  vertical: TossSpacing.space2,
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(color: TossColors.primary),
                                  borderRadius: BorderRadius.circular(TossBorderRadius.md),
                                ),
                                child: Text(
                                  'Retry',
                                  style: TossTextStyles.bodyLarge.copyWith(
                                    color: TossColors.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : SingleChildScrollView(
                        padding: const EdgeInsets.all(TossSpacing.space5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Employee Dropdown
                            Text(
                              'Employee',
                              style: TossTextStyles.bodyLarge.copyWith(
                                color: TossColors.gray900,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: TossSpacing.space2),
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: TossColors.gray300),
                                borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: _selectedEmployeeId,
                                  hint: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: TossSpacing.space3,
                                    ),
                                    child: Text(
                                      'Select Employee',
                                      style: TossTextStyles.body.copyWith(
                                        color: TossColors.gray500,
                                      ),
                                    ),
                                  ),
                                  isExpanded: true,
                                  icon: const Padding(
                                    padding: EdgeInsets.only(right: TossSpacing.space3),
                                    child: Icon(
                                      Icons.arrow_drop_down,
                                      color: TossColors.gray600,
                                    ),
                                  ),
                                  items: _employees.map((employee) {
                                    return DropdownMenuItem<String>(
                                      value: employee['user_id'],
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: TossSpacing.space3,
                                        ),
                                        child: Text(
                                          employee['full_name'] ?? 'Unknown',
                                          style: TossTextStyles.body.copyWith(
                                            color: TossColors.gray900,
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: _isSaving ? null : (value) {
                                    setState(() {
                                      _selectedEmployeeId = value;
                                    });
                                  },
                                ),
                              ),
                            ),
                            
                            const SizedBox(height: TossSpacing.space5),
                            
                            // Shift Dropdown
                            Text(
                              'Shift',
                              style: TossTextStyles.bodyLarge.copyWith(
                                color: TossColors.gray900,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: TossSpacing.space2),
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: TossColors.gray300),
                                borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: _selectedShiftId,
                                  hint: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: TossSpacing.space3,
                                    ),
                                    child: Text(
                                      'Select Shift',
                                      style: TossTextStyles.body.copyWith(
                                        color: TossColors.gray500,
                                      ),
                                    ),
                                  ),
                                  isExpanded: true,
                                  icon: const Padding(
                                    padding: EdgeInsets.only(right: TossSpacing.space3),
                                    child: Icon(
                                      Icons.arrow_drop_down,
                                      color: TossColors.gray600,
                                    ),
                                  ),
                                  items: _shifts.map((shift) {
                                    return DropdownMenuItem<String>(
                                      value: shift['shift_id'],
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: TossSpacing.space3,
                                        ),
                                        child: Text(
                                          '${shift['shift_name']} (${shift['start_time']} - ${shift['end_time']})',
                                          style: TossTextStyles.body.copyWith(
                                            color: TossColors.gray900,
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: _isSaving ? null : (value) {
                                    setState(() {
                                      _selectedShiftId = value;
                                    });
                                  },
                                ),
                              ),
                            ),
                            
                            const SizedBox(height: TossSpacing.space5),
                            
                            // Date Selector
                            Text(
                              'Date',
                              style: TossTextStyles.bodyLarge.copyWith(
                                color: TossColors.gray900,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: TossSpacing.space2),
                            InkWell(
                              onTap: _isSaving ? null : _selectDate,
                              borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                              child: Container(
                                padding: const EdgeInsets.all(TossSpacing.space4),
                                decoration: BoxDecoration(
                                  border: Border.all(color: TossColors.gray300),
                                  borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.calendar_today,
                                      size: 20,
                                      color: TossColors.gray600,
                                    ),
                                    const SizedBox(width: TossSpacing.space3),
                                    Expanded(
                                      child: Text(
                                        _selectedDate != null
                                            ? '${_selectedDate!.year}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.day.toString().padLeft(2, '0')}'
                                            : 'Select Date',
                                        style: TossTextStyles.body.copyWith(
                                          color: _selectedDate != null
                                              ? TossColors.gray900
                                              : TossColors.gray500,
                                        ),
                                      ),
                                    ),
                                    Icon(
                                      Icons.chevron_right,
                                      size: 20,
                                      color: TossColors.gray400,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            
                            const SizedBox(height: TossSpacing.space4),
                            
                            // Required fields note
                            if (!isFormValid)
                              Container(
                                padding: const EdgeInsets.all(TossSpacing.space3),
                                decoration: BoxDecoration(
                                  color: TossColors.warning.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(TossBorderRadius.md),
                                  border: Border.all(
                                    color: TossColors.warning.withValues(alpha: 0.3),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.info_outline,
                                      size: 16,
                                      color: TossColors.warning,
                                    ),
                                    const SizedBox(width: TossSpacing.space2),
                                    Expanded(
                                      child: Text(
                                        'Please select all required fields to continue',
                                        style: TossTextStyles.caption.copyWith(
                                          color: TossColors.warning,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
          ),
          
          // Bottom buttons
          Container(
            padding: const EdgeInsets.all(TossSpacing.space5),
            decoration: BoxDecoration(
              color: TossColors.white,
              border: Border(
                top: BorderSide(
                  color: TossColors.gray200,
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Opacity(
                    opacity: _isSaving ? 0.5 : 1.0,
                    child: AbsorbPointer(
                      absorbing: _isSaving,
                      child: InkWell(
                        onTap: () {
                          Navigator.pop(context, false);
                        },
                        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                        child: Container(
                          height: 52,
                          decoration: BoxDecoration(
                            color: TossColors.gray100,
                            borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                          ),
                          child: Center(
                            child: Text(
                              'Cancel',
                              style: TossTextStyles.bodyLarge.copyWith(
                                color: TossColors.gray700,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: TossSpacing.space3),
                Expanded(
                  child: Opacity(
                    opacity: isFormValid ? 1.0 : 0.5,
                    child: AbsorbPointer(
                      absorbing: !isFormValid,
                      child: InkWell(
                        onTap: isFormValid
                            ? () async {
                                HapticFeedback.mediumImpact();
                                await _saveShift();
                              }
                            : null,
                        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                        child: Container(
                          height: 52,
                          decoration: BoxDecoration(
                            color: isFormValid
                                ? TossColors.primary
                                : TossColors.gray200,
                            borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                          ),
                          child: Center(
                            child: _isSaving
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: TossLoadingView(),
                                  )
                                : Text(
                                    'Save',
                                    style: TossTextStyles.bodyLarge.copyWith(
                                      color: isFormValid
                                          ? TossColors.white
                                          : TossColors.gray400,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    ),
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
  
