import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:myfinance_improved/core/themes/toss_colors.dart';
import 'package:myfinance_improved/core/themes/toss_text_styles.dart';
import 'package:myfinance_improved/core/themes/toss_spacing.dart';
import 'package:myfinance_improved/presentation/providers/app_state_provider.dart';

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
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        HapticFeedback.selectionClick();
        // Fetch overview data when switching to Manage tab
        if (_tabController.index == 1 && selectedStoreId != null) {
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
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    // Access app state data
    final appState = ref.watch(appStateProvider);
    final selectedCompany = ref.watch(selectedCompanyProvider);
    final selectedStore = ref.watch(selectedStoreProvider);
    
    // Get company and store names for display
    final companyName = selectedCompany?['company_name'] ?? 'No Company Selected';
    final stores = selectedCompany?['stores'] ?? [];
    
    return Scaffold(
      backgroundColor: TossColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // App Bar with Tabs
            Container(
              color: TossColors.background,
              child: Column(
                children: [
                  // Title Bar
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: TossSpacing.space5,
                      vertical: TossSpacing.space3,
                    ),
                    child: Row(
                      children: [
                        Text(
                          'Time Table',
                          style: TossTextStyles.h2.copyWith(
                            color: TossColors.gray900,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Tab Bar
                  Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: TossColors.gray200,
                          width: 1,
                        ),
                      ),
                    ),
                    child: TabBar(
                      controller: _tabController,
                      indicatorColor: TossColors.primary,
                      indicatorWeight: 2,
                      labelColor: TossColors.gray900,
                      unselectedLabelColor: TossColors.gray500,
                      labelStyle: TossTextStyles.body.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      tabs: const [
                        Tab(text: 'Schedule'),
                        Tab(text: 'Manage'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Tab Content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildScheduleTab(),
                  _buildManageTab(),
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
      
      print('Shift metadata response: $response');
      
      setState(() {
        shiftMetadata = response;
        isLoadingMetadata = false;
      });
      
      print('Shift metadata loaded for store $storeId');
    } catch (e) {
      print('Error fetching shift metadata: $e');
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
      print('Data already loaded for month: $monthKey');
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
      
      print('Monthly shift status response type: ${response.runtimeType}');
      print('Response length: ${(response as List).length}');
      
      setState(() {
        // Append new data to existing data (don't replace)
        if (response != null && response is List) {
          // Remove any duplicate dates before adding
          final existingDates = monthlyShiftData.map((item) => item['request_date']).toSet();
          final newData = response.where((item) => !existingDates.contains(item['request_date'])).toList();
          monthlyShiftData.addAll(newData);
          
          // Mark the months as loaded (current month and next month)
          loadedMonths.add(monthKey);
          // Also mark the next month as loaded since RPC returns 2 months
          final nextMonth = DateTime(targetDate.year, targetDate.month + 1);
          final nextMonthKey = '${nextMonth.year}-${nextMonth.month.toString().padLeft(2, '0')}';
          loadedMonths.add(nextMonthKey);
        }
        isLoadingShiftStatus = false;
      });
      
      print('Monthly shift data loaded: ${monthlyShiftData.length} total days of data');
      print('Loaded months: $loadedMonths');
    } catch (e) {
      print('Error fetching monthly shift status: $e');
      setState(() {
        isLoadingShiftStatus = false;
      });
    }
  }
  
  // Fetch manager overview data from Supabase RPC
  Future<void> fetchManagerOverview({DateTime? forDate}) async {
    if (selectedStoreId == null || selectedStoreId!.isEmpty) return;
    
    // Use provided date or manageSelectedDate for Manage tab
    final targetDate = forDate ?? manageSelectedDate;
    final monthKey = '${targetDate.year}-${targetDate.month.toString().padLeft(2, '0')}';
    
    // Check if we already have data for this month
    if (managerOverviewDataByMonth.containsKey(monthKey)) {
      print('Manager overview data already loaded for month: $monthKey');
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
        print('Company ID not found in app state');
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
      
      print('Manager overview response for $monthKey: $response');
      
      setState(() {
        if (response != null) {
          managerOverviewDataByMonth[monthKey] = response as Map<String, dynamic>;
        }
        isLoadingOverview = false;
      });
      
      print('Manager overview loaded for store $selectedStoreId, month $monthKey');
    } catch (e) {
      print('Error fetching manager overview: $e');
      setState(() {
        isLoadingOverview = false;
      });
    }
  }
  
  // Fetch manager shift cards from Supabase RPC
  Future<void> fetchManagerCards({DateTime? forDate}) async {
    if (selectedStoreId == null || selectedStoreId!.isEmpty) return;
    
    // Use provided date or manageSelectedDate for Manage tab
    final targetDate = forDate ?? manageSelectedDate;
    final monthKey = '${targetDate.year}-${targetDate.month.toString().padLeft(2, '0')}';
    
    // Check if we already have data for this month
    if (managerCardsDataByMonth.containsKey(monthKey)) {
      print('Manager cards data already loaded for month: $monthKey');
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
        print('Company ID not found in app state');
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
      
      print('Manager cards response for $monthKey: $response');
      
      setState(() {
        if (response != null) {
          managerCardsDataByMonth[monthKey] = response as Map<String, dynamic>;
        }
        isLoadingCards = false;
      });
      
      print('Manager cards loaded for store $selectedStoreId, month $monthKey');
    } catch (e) {
      print('Error fetching manager cards: $e');
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
      backgroundColor: Colors.transparent,
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
                  borderRadius: BorderRadius.circular(100),
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
    
    // Process cards data to find dates with problems or pending shifts
    Map<String, bool> datesWithProblems = {};
    Map<String, bool> datesWithPending = {};
    
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
            
            if (isProblem) {
              datesWithProblems[requestDate] = true;
            }
            if (!isApproved) {
              datesWithPending[requestDate] = true;
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
      
      calendarDays.add(
        InkWell(
          onTap: () => onDateSelected(date),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            margin: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: isSelected 
                  ? TossColors.primary 
                  : isToday 
                      ? TossColors.primary.withOpacity(0.1)
                      : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
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
                        ? Colors.white 
                        : isToday 
                            ? TossColors.primary
                            : TossColors.gray900,
                    fontWeight: isSelected || isToday ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
                // Show indicator dots below the date for problems and pending
                if ((hasProblem || hasPending) && !isSelected) ...[
                  const SizedBox(height: 2),
                  Container(
                    width: 4,
                    height: 4,
                    decoration: BoxDecoration(
                      color: hasProblem 
                          ? TossColors.error 
                          : TossColors.warning,
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
      backgroundColor: Colors.transparent,
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
                borderRadius: BorderRadius.circular(100),
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
                        color: isSelected ? TossColors.gray50 : Colors.transparent,
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
                              color: isSelected ? TossColors.primary.withOpacity(0.1) : TossColors.gray100,
                              borderRadius: BorderRadius.circular(10),
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
          
          if (shifts.isEmpty) {
            // No employees registered for any shift on this day
            dotColor = TossColors.error;
          } else {
            // Check if ANY shift has pending employees FIRST
            bool hasAnyPending = false;
            
            for (var shift in shifts) {
              final pendingCount = shift['pending_count'] ?? 0;
              if (pendingCount > 0) {
                hasAnyPending = true;
                break;
              }
            }
            
            // If there's at least one pending, show orange
            if (hasAnyPending) {
              dotColor = TossColors.warning;
            } else {
              // No pending, now check coverage
              int totalShiftsNeeded = allShifts.length;
              int shiftsWithEmployees = shifts.length;
              
              if (shiftsWithEmployees < totalShiftsNeeded) {
                // Not all shifts are covered
                dotColor = TossColors.error;
              } else {
                // All shifts covered and all approved
                dotColor = TossColors.success;
              }
            }
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
          borderRadius: BorderRadius.circular(12),
          child: Container(
            margin: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: isSelected
                  ? TossColors.primary
                  : isToday
                      ? TossColors.primary.withOpacity(0.1)
                      : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
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
                              ? Colors.white
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
                          width: 4,
                          height: 4,
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Colors.white
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
    Map<String, dynamic>? selectedDateData;
    List<dynamic> employeeShifts = [];
    
    for (var dayData in monthlyShiftData) {
      if (dayData['request_date'] == dateStr) {
        selectedDateData = dayData;
        employeeShifts = dayData['shifts'] as List<dynamic>? ?? [];
        break;
      }
    }
    
    // Debug: Print the data structure
    print('Building shift data for date: $dateStr');
    print('Found data: ${selectedDateData != null}');
    print('Employee shifts: ${employeeShifts.length} shifts');
    
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
            ...(shiftMetadata as List).map((shift) {
              final shiftId = shift['shift_id'];
              final shiftName = shift['shift_name'] ?? 'Unknown Shift';
              final startTime = shift['start_time'] ?? shift['shift_start_time'] ?? '--:--';
              final endTime = shift['end_time'] ?? shift['shift_end_time'] ?? '--:--';
              
              // Debug: Print shift data
              print('Processing shift: $shiftName (ID: $shiftId)');
              
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
                      });
                    }
                    
                    // Add approved employees
                    final approvedList = empShift['approved_employees'] as List<dynamic>? ?? [];
                    for (var emp in approvedList) {
                      assignedEmployees.add({
                        'user_name': emp['user_name'] ?? 'Unknown',
                        'is_approved': true,
                        'shift_request_id': emp['shift_request_id'] ?? '',
                      });
                    }
                    break; // Found the matching shift
                  }
                }
              }
              
              print('  Found ${assignedEmployees.length} employees for shift $shiftName');
              
              final hasEmployee = assignedEmployees.isNotEmpty;
              
              return Container(
                margin: const EdgeInsets.only(bottom: TossSpacing.space3),
                decoration: BoxDecoration(
                  color: TossColors.background,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: hasEmployee 
                        ? (assignedEmployees.any((e) => e['is_approved'] == true) 
                            ? TossColors.success.withOpacity(0.3) 
                            : TossColors.warning.withOpacity(0.3))
                        : TossColors.error.withOpacity(0.2),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
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
                            : TossColors.error.withOpacity(0.05),
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
                                  ? TossColors.primary.withOpacity(0.1)
                                  : TossColors.error.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
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
                                color: TossColors.error.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
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
                        
                        // Both pending and approved shifts are now clickable
                        final isClickable = true;
                        
                        // Create unique identifier for this shift request
                        final shiftRequestId = '${shiftId}_$userName';
                        final isSelected = selectedShiftRequest == shiftRequestId;
                        
                        return InkWell(
                          onTap: isClickable ? () {
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
                              }
                            });
                            print('Selected shift request: $selectedShiftRequest, Approved: $selectedShiftIsApproved, Request ID: $selectedShiftRequestId');
                          } : null,
                          child: Container(
                            padding: const EdgeInsets.all(TossSpacing.space3),
                            decoration: BoxDecoration(
                              color: isSelected 
                                  ? TossColors.primary.withOpacity(0.08)
                                  : (isApproved 
                                      ? TossColors.success.withOpacity(0.03)
                                      : TossColors.warning.withOpacity(0.03)),
                              border: Border(
                                top: BorderSide(
                                  color: TossColors.gray100,
                                  width: 1,
                                ),
                                left: BorderSide(
                                  color: isSelected 
                                      ? TossColors.primary 
                                      : Colors.transparent,
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
                                        ? TossColors.primary.withOpacity(0.15)
                                        : (isApproved 
                                            ? TossColors.success.withOpacity(0.1)
                                            : TossColors.warning.withOpacity(0.1)),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    isSelected ? Icons.check_circle : Icons.person_outline,
                                    size: 16,
                                    color: isSelected
                                        ? TossColors.primary
                                        : (isApproved 
                                            ? TossColors.success 
                                            : TossColors.warning),
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
                                        ? TossColors.primary.withOpacity(0.15)
                                        : (isApproved 
                                            ? TossColors.success.withOpacity(0.1)
                                            : TossColors.warning.withOpacity(0.1)),
                                    borderRadius: BorderRadius.circular(12),
                                    border: isSelected 
                                        ? Border.all(
                                            color: TossColors.primary.withOpacity(0.3),
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
                              color: TossColors.error.withOpacity(0.7),
                            ),
                            const SizedBox(width: TossSpacing.space2),
                            Text(
                              'No employee assigned',
                              style: TossTextStyles.bodySmall.copyWith(
                                color: TossColors.error.withOpacity(0.7),
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
                borderRadius: BorderRadius.circular(10),
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
    
    // Calculate week dates (Wednesday to Tuesday)
    final today = DateTime.now();
    final weekday = today.weekday;
    final daysFromWednesday = (weekday - 3 + 7) % 7;
    final wednesday = today.subtract(Duration(days: daysFromWednesday));
    
    if (isLoadingOverview) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(TossSpacing.space10),
          child: CircularProgressIndicator(
            color: TossColors.primary,
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
              color: const Color(0xFFE8EFFA),
              borderRadius: BorderRadius.circular(20),
            ),
            child: SizedBox(
              width: double.infinity,
              child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // Header with Off Duty indicator
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
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
                    // Off Duty indicator
                    Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Color(0xFF9CA3AF),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: TossSpacing.space2),
                        Text(
                          'Off Duty',
                          style: TossTextStyles.bodySmall.copyWith(
                            color: TossColors.gray600,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                
                const SizedBox(height: TossSpacing.space5),
                
                // Stats Grid
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  childAspectRatio: 1.6,
                  mainAxisSpacing: TossSpacing.space3,
                  crossAxisSpacing: TossSpacing.space3,
                  children: [
                    // Total Request
                    _buildStatCard(
                      icon: Icons.calendar_today,
                      iconColor: const Color(0xFF5B8DEF),
                      backgroundColor: const Color(0xFFE8F0FE),
                      title: 'Total Request',
                      value: _getMonthlyStatValue('total_requests'),
                      subtitle: 'requests',
                      filterType: 'all',
                    ),
                    
                    // Problem
                    _buildStatCard(
                      icon: Icons.warning_amber_rounded,
                      iconColor: const Color(0xFFF56565),
                      backgroundColor: const Color(0xFFFEE8E8),
                      title: 'Problem',
                      value: _getMonthlyStatValue('total_problems'),
                      subtitle: 'issues',
                      filterType: 'problem',
                    ),
                    
                    // Total Approve
                    _buildStatCard(
                      icon: Icons.check_circle,
                      iconColor: const Color(0xFF48BB78),
                      backgroundColor: const Color(0xFFE6F9F0),
                      title: 'Total Approve',
                      value: _getMonthlyStatValue('total_approved'),
                      subtitle: 'approved',
                      filterType: 'approved',
                    ),
                    
                    // Pending
                    _buildStatCard(
                      icon: Icons.access_time,
                      iconColor: const Color(0xFFF6AD55),
                      backgroundColor: const Color(0xFFFEF5E7),
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
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: TossSpacing.space3,
                          vertical: TossSpacing.space2,
                        ),
                        decoration: BoxDecoration(
                          color: TossColors.gray50,
                          borderRadius: BorderRadius.circular(12),
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
                                  ? Border.all(color: TossColors.primary.withOpacity(0.3), width: 1)
                                  : null,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  dayName,
                                  style: TossTextStyles.caption.copyWith(
                                    color: isSelected 
                                        ? Colors.white.withOpacity(0.8)
                                        : TossColors.gray500,
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(height: TossSpacing.space2),
                                Text(
                                  '${date.day}',
                                  style: TossTextStyles.h3.copyWith(
                                    color: isSelected 
                                        ? Colors.white 
                                        : TossColors.gray900,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: TossSpacing.space1),
                                Text(
                                  'off',
                                  style: TossTextStyles.caption.copyWith(
                                    color: isSelected 
                                        ? Colors.white.withOpacity(0.8)
                                        : TossColors.gray400,
                                    fontSize: 11,
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
          child: CircularProgressIndicator(
            color: TossColors.primary,
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
                        ? TossColors.error.withOpacity(0.1)
                        : selectedFilter == 'approved'
                            ? TossColors.success.withOpacity(0.1)
                            : TossColors.warning.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
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
    final shiftName = card['shift_name'] ?? 'Unknown Shift';
    final shiftTime = card['shift_time'] ?? '--:--';
    final isApproved = card['is_approved'] ?? false;
    final isProblem = card['is_problem'] ?? false;
    final problemType = card['problem_type'];
    final isLate = card['is_late'] ?? false;
    final lateMinute = card['late_minute'] ?? 0;
    final isOverTime = card['is_over_time'] ?? false;
    final overTimeMinute = card['over_time_minute'] ?? 0;
    final paidHour = card['paid_hour'] ?? 0;
    final actualStart = card['actual_start'];
    final actualEnd = card['actual_end'];
    final confirmStartTime = card['confirm_start_time'];
    final confirmEndTime = card['confirm_end_time'];
    final isReported = card['is_reported'] ?? false;
    
    // Determine card border color based on status
    Color borderColor = TossColors.gray200;
    if (isProblem) {
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
      borderRadius: BorderRadius.circular(16),
      child: Container(
      margin: const EdgeInsets.only(bottom: TossSpacing.space3),
      decoration: BoxDecoration(
        color: TossColors.background,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: borderColor.withOpacity(0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
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
              color: isProblem 
                  ? TossColors.error.withOpacity(0.05)
                  : isApproved
                      ? TossColors.success.withOpacity(0.05)
                      : TossColors.warning.withOpacity(0.05),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
            ),
            child: Row(
              children: [
                // User avatar
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: TossColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: Text(
                      userName.isNotEmpty ? userName[0].toUpperCase() : '?',
                      style: TossTextStyles.body.copyWith(
                        color: TossColors.primary,
                        fontWeight: FontWeight.w700,
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
                if (isProblem)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: TossSpacing.space2,
                      vertical: TossSpacing.space1,
                    ),
                    decoration: BoxDecoration(
                      color: TossColors.error.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Problem',
                      style: TossTextStyles.caption.copyWith(
                        color: TossColors.error,
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
                      color: TossColors.success.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
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
                      color: TossColors.warning.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
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
          if (actualStart != null || actualEnd != null || isLate || isOverTime || paidHour > 0)
            Container(
              padding: const EdgeInsets.all(TossSpacing.space4),
              child: Column(
                children: [
                  // Check-in/out times
                  if (actualStart != null || actualEnd != null)
                    Row(
                      children: [
                        if (actualStart != null) ...[
                          Icon(
                            Icons.login,
                            size: 16,
                            color: TossColors.gray500,
                          ),
                          const SizedBox(width: TossSpacing.space1),
                          Text(
                            confirmStartTime ?? actualStart.substring(0, 5),
                            style: TossTextStyles.bodySmall.copyWith(
                              color: TossColors.gray700,
                            ),
                          ),
                        ],
                        if (actualStart != null && actualEnd != null)
                          const SizedBox(width: TossSpacing.space3),
                        if (actualEnd != null) ...[
                          Icon(
                            Icons.logout,
                            size: 16,
                            color: TossColors.gray500,
                          ),
                          const SizedBox(width: TossSpacing.space1),
                          Text(
                            confirmEndTime ?? actualEnd.substring(0, 5),
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
                              color: TossColors.warning.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(6),
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
                              color: TossColors.info.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(6),
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
                              color: TossColors.error.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              'Reported',
                              style: TossTextStyles.caption.copyWith(
                                color: TossColors.error,
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
    
    return Column(
      children: [
        // Store Selector - Toss Style
        if (stores.isNotEmpty)
              Container(
                margin: const EdgeInsets.all(TossSpacing.space5),
                child: InkWell(
                  onTap: () => _showStoreSelector(stores),
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.all(TossSpacing.space4),
                    decoration: BoxDecoration(
                      color: TossColors.background,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: TossColors.gray200,
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
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
                            borderRadius: BorderRadius.circular(10),
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
                    borderRadius: BorderRadius.circular(20),
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
                    borderRadius: BorderRadius.circular(20),
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
                        child: CircularProgressIndicator(
                          color: TossColors.primary,
                          strokeWidth: 2,
                        ),
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
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                          );
                          return;
                        }
                        
                        try {
                          // Call RPC function to toggle shift approval
                          final response = await Supabase.instance.client.rpc(
                            'toggle_shift_approval',
                            params: {
                              'p_user_id': userId,
                              'p_shift_request_ids': [selectedShiftRequestId],  // Pass as array
                            },
                          );
                          
                          print('Toggle shift approval response: $response');
                          
                          // When clicking approved shift, it changes to pending. When clicking pending shift, it changes to approved.
                          final action = selectedShiftIsApproved == true 
                              ? 'changed to pending' 
                              : 'approved';
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Shift request $action successfully'),
                              backgroundColor: TossColors.success,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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
                          });
                          
                          // Force refresh the shift data to show updated status
                          await fetchMonthlyShiftStatus(forDate: selectedDate, forceRefresh: true);
                          
                        } catch (e) {
                          print('Error toggling shift approval: $e');
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Error: ${e.toString()}'),
                              backgroundColor: TossColors.error,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                          );
                        }
                      } : null,
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        height: 56,
                        decoration: BoxDecoration(
                          color: selectedShiftRequest != null 
                              ? (selectedShiftIsApproved == true 
                                  ? TossColors.warning 
                                  : TossColors.primary)
                              : TossColors.gray300,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Center(
                          child: Text(
                            selectedShiftIsApproved == true ? 'Not Approve' : 'Approve',
                            style: TossTextStyles.bodyLarge.copyWith(
                              color: selectedShiftRequest != null 
                                  ? Colors.white 
                                  : TossColors.gray500,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  
                  // Add bottom padding for comfortable scrolling
                  const SizedBox(height: 24),
                ],
              ),
            ),
      ],
    );
  }

  
  // Show shift details bottom sheet
  void _showShiftDetailsBottomSheet(Map<String, dynamic> card) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _ShiftDetailsBottomSheet(card: card),
    );
  }
}

// Separate StatefulWidget for the bottom sheet to manage tab state
class _ShiftDetailsBottomSheet extends StatefulWidget {
  final Map<String, dynamic> card;
  
  const _ShiftDetailsBottomSheet({required this.card});

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
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(TossSpacing.space4),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(16),
          border: isSelected 
              ? Border.all(
                  color: iconColor.withOpacity(0.5),
                  width: 2,
                )
              : null,
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: iconColor.withOpacity(0.2),
                    blurRadius: 8,
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
                  size: 20,
                  color: iconColor,
                ),
                const SizedBox(width: TossSpacing.space2),
                Text(
                  title,
                  style: TossTextStyles.bodySmall.copyWith(
                    color: TossColors.gray600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  value,
                  style: TossTextStyles.h1.copyWith(
                    color: TossColors.gray900,
                    fontWeight: FontWeight.w700,
                    fontSize: 32,
                  ),
                ),
                const SizedBox(width: TossSpacing.space2),
                Text(
                  subtitle,
                  style: TossTextStyles.bodySmall.copyWith(
                    color: TossColors.gray500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
  late TabController _tabController;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    final card = widget.card;
    final hasUnsolvedProblem = card['is_problem'] == true && card['is_problem_solved'] != true;
    
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.9,
      ),
      decoration: BoxDecoration(
        color: TossColors.background,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
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
              borderRadius: BorderRadius.circular(100),
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
                        TossColors.primary.withOpacity(0.8),
                        TossColors.primary,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: Center(
                    child: Text(
                      (card['user_name'] ?? '?')[0].toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
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
                      borderRadius: BorderRadius.circular(16),
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
          // Tab Bar
          Container(
            margin: const EdgeInsets.symmetric(horizontal: TossSpacing.space5),
            decoration: BoxDecoration(
              color: TossColors.gray50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: TabBar(
              controller: _tabController,
              indicator: BoxDecoration(
                color: TossColors.background,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              indicatorPadding: const EdgeInsets.all(4),
              labelColor: TossColors.gray900,
              unselectedLabelColor: TossColors.gray500,
              labelStyle: TossTextStyles.body.copyWith(
                fontWeight: FontWeight.w600,
              ),
              tabs: const [
                Tab(text: 'Info'),
                Tab(text: 'Manage'),
              ],
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
                color: TossColors.error.withOpacity(0.05),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: TossColors.error.withOpacity(0.2),
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
                        color: TossColors.error.withOpacity(0.8),
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
                            TossColors.primary.withOpacity(0.05),
                            TossColors.primary.withOpacity(0.02),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: TossColors.primary.withOpacity(0.1),
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
                                  color: TossColors.primary.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(10),
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
                                      style: TextStyle(
                                        fontSize: 32,
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
                                      style: TextStyle(
                                        fontSize: 32,
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
                                borderRadius: BorderRadius.circular(12),
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
                        borderRadius: BorderRadius.circular(16),
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
                        borderRadius: BorderRadius.circular(16),
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
                      _buildSectionTitle('Location'),
                      Container(
                        padding: const EdgeInsets.all(TossSpacing.space4),
                        decoration: BoxDecoration(
                          color: TossColors.gray50,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          children: [
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
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Wrap(
                          spacing: TossSpacing.space2,
                          runSpacing: TossSpacing.space2,
                          children: (card['notice_tag'] as List).map((tag) => 
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: TossSpacing.space3,
                                vertical: TossSpacing.space1,
                              ),
                              decoration: BoxDecoration(
                                color: TossColors.primary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                tag.toString(),
                                style: TossTextStyles.caption.copyWith(
                                  color: TossColors.primary,
                                ),
                              ),
                            ),
                          ).toList(),
                        ),
                      ),
                      const SizedBox(height: TossSpacing.space4),
                    ],
                    
                    const SizedBox(height: TossSpacing.space5),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildManageTab(Map<String, dynamic> card) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(TossSpacing.space5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Edit Confirmed Times Section
          Container(
            padding: const EdgeInsets.all(TossSpacing.space4),
            decoration: BoxDecoration(
              color: TossColors.gray50,
              borderRadius: BorderRadius.circular(16),
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
                _buildTimeEditor('Start Time', card['confirm_start_time']),
                const SizedBox(height: TossSpacing.space3),
                // End Time Editor
                _buildTimeEditor('End Time', card['confirm_end_time']),
              ],
            ),
          ),
          const SizedBox(height: TossSpacing.space4),
          
          // Approval Actions
          Container(
            padding: const EdgeInsets.all(TossSpacing.space4),
            decoration: BoxDecoration(
              color: TossColors.gray50,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Approval Actions',
                  style: TossTextStyles.body.copyWith(
                    color: TossColors.gray900,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: TossSpacing.space3),
                // Approve/Reject buttons
                Row(
                  children: [
                    Expanded(
                      child: _buildActionButton(
                        'Approve',
                        TossColors.success,
                        Icons.check_circle_outline,
                        () {},
                      ),
                    ),
                    const SizedBox(width: TossSpacing.space3),
                    Expanded(
                      child: _buildActionButton(
                        'Reject',
                        TossColors.error,
                        Icons.cancel_outlined,
                        () {},
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: TossSpacing.space4),
          
          // Problem Management
          if (card['is_problem'] == true) ...[
            Container(
              padding: const EdgeInsets.all(TossSpacing.space4),
              decoration: BoxDecoration(
                color: TossColors.error.withOpacity(0.05),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: TossColors.error.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Problem Management',
                    style: TossTextStyles.body.copyWith(
                      color: TossColors.gray900,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: TossSpacing.space3),
                  if (card['is_problem_solved'] != true)
                    _buildActionButton(
                      'Mark as Resolved',
                      TossColors.success,
                      Icons.check_circle,
                      () {},
                    )
                  else
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: TossSpacing.space3,
                        vertical: TossSpacing.space2,
                      ),
                      decoration: BoxDecoration(
                        color: TossColors.success.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.check_circle,
                            size: 16,
                            color: TossColors.success,
                          ),
                          const SizedBox(width: TossSpacing.space2),
                          Text(
                            'Problem Resolved',
                            style: TossTextStyles.bodySmall.copyWith(
                              color: TossColors.success,
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
        ],
      ),
    );
  }
  
  Widget _buildTimeEditor(String label, String? currentTime) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TossTextStyles.body.copyWith(
            color: TossColors.gray600,
          ),
        ),
        InkWell(
          onTap: () {
            // Time picker will be implemented
          },
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: TossSpacing.space3,
              vertical: TossSpacing.space2,
            ),
            decoration: BoxDecoration(
              color: TossColors.background,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: TossColors.gray200,
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  currentTime ?? '--:--',
                  style: TossTextStyles.body.copyWith(
                    color: currentTime != null ? TossColors.gray900 : TossColors.gray400,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'JetBrains Mono',
                  ),
                ),
                const SizedBox(width: TossSpacing.space2),
                const Icon(
                  Icons.access_time,
                  size: 16,
                  color: TossColors.gray500,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
  
  Widget _buildActionButton(String label, Color color, IconData icon, VoidCallback onTap) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: TossSpacing.space3,
            vertical: TossSpacing.space3,
          ),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: color.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 18,
                color: color,
              ),
              const SizedBox(width: TossSpacing.space2),
              Text(
                label,
                style: TossTextStyles.bodySmall.copyWith(
                  color: color,
                  fontWeight: FontWeight.w600,
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
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: color.withOpacity(0.2),
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
  
  // Build stat card widget
  
  // Build Schedule Tab Content (current calendar and shift content)
}
