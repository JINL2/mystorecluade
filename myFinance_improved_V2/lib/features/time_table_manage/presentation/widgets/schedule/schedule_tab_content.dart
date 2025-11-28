import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../app/providers/app_state_provider.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_text_styles.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/widgets/toss/toss_dropdown.dart';
import '../../../../../shared/widgets/toss/toss_week_navigation.dart';
import '../../../../../shared/widgets/toss/week_dates_picker.dart';
import '../shift_management_card.dart';
import '../../models/schedule_models.dart';
import '../../providers/state/manager_shift_cards_provider.dart';
import '../../providers/state/shift_metadata_provider.dart';
import '../../../domain/entities/shift_card.dart';
import 'package:intl/intl.dart';

/// Schedule Tab Content - Redesigned
///
/// Displays weekly schedule view with shift management.
/// Shows shifts with applicants and waitlist in expandable cards.
class ScheduleTabContent extends ConsumerStatefulWidget {
  final String? selectedStoreId;
  final DateTime selectedDate;
  final DateTime focusedMonth;
  final ScrollController scrollController;
  final String Function(int month) getMonthName;
  final VoidCallback onAddShiftTap;
  final void Function(DateTime date) onDateSelected;
  final Future<void> Function() onPreviousMonth;
  final Future<void> Function() onNextMonth;
  final Future<void> Function() onApprovalSuccess;
  final Future<void> Function() fetchMonthlyShiftStatus;
  final VoidCallback onStoreSelectorTap;

  const ScheduleTabContent({
    super.key,
    required this.selectedStoreId,
    required this.selectedDate,
    required this.focusedMonth,
    required this.scrollController,
    required this.getMonthName,
    required this.onAddShiftTap,
    required this.onDateSelected,
    required this.onPreviousMonth,
    required this.onNextMonth,
    required this.onApprovalSuccess,
    required this.fetchMonthlyShiftStatus,
    required this.onStoreSelectorTap,
  });

  @override
  ConsumerState<ScheduleTabContent> createState() => _ScheduleTabContentState();
}

class _ScheduleTabContentState extends ConsumerState<ScheduleTabContent> {
  late DateTime _currentWeekStart;
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.selectedDate;
    _currentWeekStart = _getWeekStart(_selectedDate);

    // Load shift data for current month
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadMonthData();
    });
  }

  /// Load shift cards data for current month
  void _loadMonthData() {
    if (widget.selectedStoreId == null) return;

    // Load shift cards (requests)
    ref.read(managerCardsProvider(widget.selectedStoreId!).notifier).loadMonth(
      month: _selectedDate,
    );

    // Load shift metadata (available shifts)
    ref.invalidate(shiftMetadataProvider(widget.selectedStoreId!));
  }

  @override
  void didUpdateWidget(ScheduleTabContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedDate != oldWidget.selectedDate) {
      setState(() {
        _selectedDate = widget.selectedDate;
        _currentWeekStart = _getWeekStart(_selectedDate);
      });
      _loadMonthData();
    }

    // Reload if store changed
    if (widget.selectedStoreId != oldWidget.selectedStoreId) {
      _loadMonthData();
    }
  }

  /// Get Monday of the week for a given date
  DateTime _getWeekStart(DateTime date) {
    final weekday = date.weekday; // Monday = 1, Sunday = 7
    return date.subtract(Duration(days: weekday - 1));
  }

  @override
  Widget build(BuildContext context) {
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

    return SingleChildScrollView(
      controller: widget.scrollController,
      padding: const EdgeInsets.symmetric(
        horizontal: TossSpacing.space3,
        vertical: TossSpacing.space2,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Store selector dropdown
          _buildStoreSelector(stores),

          const SizedBox(height: TossSpacing.space3),

          // Week navigation
          TossWeekNavigation(
            weekLabel: 'This week',
            dateRange: _formatWeekRange(),
            onPrevWeek: () => _changeWeek(-7),
            onCurrentWeek: () => _jumpToToday(),
            onNextWeek: () => _changeWeek(7),
          ),

          const SizedBox(height: TossSpacing.space3),

          // Week date picker
          WeekDatesPicker(
            selectedDate: _selectedDate,
            weekStartDate: _currentWeekStart,
            datesWithAssignedShifts: _getDatesWithShifts(), // User's assigned shifts
            datesWithAvailableShifts: {}, // No available shifts on My Schedule tab
            datesWithFullShifts: {}, // No full shifts indicator needed
            onDateSelected: (date) {
              setState(() => _selectedDate = date);
              widget.onDateSelected(date);
            },
          ),

          const SizedBox(height: TossSpacing.space4),

          // "Shifts for..." label
          Text(
            'Shifts for ${_formatSelectedDate()}',
            style: TossTextStyles.label.copyWith(
              color: TossColors.gray600,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: TossSpacing.space3),

          // Shift cards or empty state
          ..._buildShiftsList(),

          const SizedBox(height: TossSpacing.space4),
        ],
      ),
    );
  }

  /// Build shifts list or empty/loading state
  List<Widget> _buildShiftsList() {
    if (widget.selectedStoreId == null) {
      return [
        _buildEmptyState('Please select a store'),
      ];
    }

    final cardsState = ref.watch(managerCardsProvider(widget.selectedStoreId!));

    // Show loading state
    if (cardsState.isLoading) {
      return [
        Center(
          child: Padding(
            padding: const EdgeInsets.all(TossSpacing.space8),
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(TossColors.primary),
            ),
          ),
        ),
      ];
    }

    // Show error state
    if (cardsState.error != null) {
      return [
        _buildEmptyState('Error loading shifts\n${cardsState.error}'),
      ];
    }

    final shifts = _getShiftsForSelectedDate();

    // Show empty state if no shifts
    if (shifts.isEmpty) {
      return [
        _buildEmptyState('No shifts scheduled for this day'),
      ];
    }

    // Show shift cards
    return shifts.map((shift) => Padding(
      padding: const EdgeInsets.only(bottom: TossSpacing.space3),
      child: ShiftManagementCard(
        shift: shift,
        onApprove: _handleApprove,
        onOverbook: _handleOverbook,
        onRemoveFromShift: _handleRemove,
      ),
    )).toList();
  }

  /// Build empty state widget
  Widget _buildEmptyState(String message) {
    return Container(
      padding: const EdgeInsets.all(TossSpacing.space8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.calendar_today_outlined,
            size: 48,
            color: TossColors.gray400,
          ),
          const SizedBox(height: TossSpacing.space3),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TossTextStyles.body.copyWith(
              color: TossColors.gray500,
            ),
          ),
        ],
      ),
    );
  }

  /// Build store selector dropdown
  Widget _buildStoreSelector(List<dynamic> stores) {
    final storeItems = stores.map((store) {
      final storeMap = store as Map<String, dynamic>;
      return TossDropdownItem<String>(
        value: storeMap['store_id']?.toString() ?? '',
        label: storeMap['store_name']?.toString() ?? 'Unknown',
      );
    }).toList();

    return TossDropdown<String>(
      label: 'Store',
      value: widget.selectedStoreId,
      items: storeItems,
      onChanged: (newValue) {
        if (newValue != null) {
          widget.onStoreSelectorTap();
        }
      },
    );
  }

  /// Format week range for navigation (e.g., "10-16 Jun")
  String _formatWeekRange() {
    final weekEnd = _currentWeekStart.add(const Duration(days: 6));
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${_currentWeekStart.day}-${weekEnd.day} ${months[_currentWeekStart.month - 1]}';
  }

  /// Format selected date (e.g., "Wed, 12 Jun")
  String _formatSelectedDate() {
    final weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    final dayName = weekdays[_selectedDate.weekday - 1];
    return '$dayName, ${_selectedDate.day} ${months[_selectedDate.month - 1]}';
  }

  /// Change week by number of days
  void _changeWeek(int days) {
    final newWeekStart = _currentWeekStart.add(Duration(days: days));
    final newSelectedDate = _selectedDate.add(Duration(days: days));

    setState(() {
      _currentWeekStart = newWeekStart;
      _selectedDate = newSelectedDate;
    });

    // Load new month data if month changed
    if (_selectedDate.month != newSelectedDate.month ||
        _selectedDate.year != newSelectedDate.year) {
      _loadMonthData();
    }

    widget.onDateSelected(_selectedDate);
  }

  /// Jump to today
  void _jumpToToday() {
    final today = DateTime.now();
    setState(() {
      _selectedDate = today;
      _currentWeekStart = _getWeekStart(today);
    });

    // Load current month data
    _loadMonthData();
    widget.onDateSelected(_selectedDate);
  }

  /// Get dates with available shifts from real data
  /// Shows ALL days in the week (since shifts are available every day)
  Set<DateTime> _getDatesWithShifts() {
    if (widget.selectedStoreId == null) return {};

    // Get shift metadata to check if store has active shifts
    final metadataAsync = ref.watch(shiftMetadataProvider(widget.selectedStoreId!));
    if (!metadataAsync.hasValue || metadataAsync.value == null) return {};

    final metadata = metadataAsync.value!;

    // If no active shifts configured, show nothing
    if (metadata.activeShifts.isEmpty) return {};

    // Show all 7 days of the week (shifts are available every day)
    final dateSet = <DateTime>{};
    for (int i = 0; i < 7; i++) {
      final date = _currentWeekStart.add(Duration(days: i));
      dateSet.add(DateTime(date.year, date.month, date.day));
    }

    return dateSet;
  }

  /// Get shifts for selected date from real data
  /// Combines shift metadata (available shifts) with shift cards (requests)
  List<ShiftData> _getShiftsForSelectedDate() {
    if (widget.selectedStoreId == null) return [];

    // Get shift metadata (available shifts)
    final metadataAsync = ref.watch(shiftMetadataProvider(widget.selectedStoreId!));

    // Return empty if metadata still loading
    if (!metadataAsync.hasValue || metadataAsync.value == null) return [];

    final metadata = metadataAsync.value!;
    final activeShifts = metadata.activeShifts;

    // Get shift cards (actual requests)
    final cardsState = ref.watch(managerCardsProvider(widget.selectedStoreId!));
    final monthKey = '${_selectedDate.year}-${_selectedDate.month.toString().padLeft(2, '0')}';
    final monthData = cardsState.dataByMonth[monthKey];

    // Get cards for selected date
    final selectedDateStr = DateFormat('yyyy-MM-dd').format(_selectedDate);
    final cardsForDate = monthData?.getCardsByDate(selectedDateStr) ?? [];

    // Group cards by shift ID
    final cardsMap = <String, List<ShiftCard>>{};
    for (final card in cardsForDate) {
      cardsMap.putIfAbsent(card.shift.shiftId, () => []).add(card);
    }

    // Create ShiftData for ALL active shifts (whether they have requests or not)
    return activeShifts.map((shiftMeta) {
      final cardsForShift = cardsMap[shiftMeta.shiftId] ?? [];

      // Separate approved and pending employees
      final assignedEmployees = cardsForShift
          .where((c) => c.isApproved)
          .map((c) => Employee(
                id: c.employee.userId,
                name: c.employee.userName,
                avatarUrl: c.employee.profileImage ?? '',
              ))
          .toList();

      final applicants = cardsForShift
          .where((c) => !c.isApproved)
          .map((c) => Employee(
                id: c.employee.userId,
                name: c.employee.userName,
                avatarUrl: c.employee.profileImage ?? '',
              ))
          .toList();

      return ShiftData(
        id: shiftMeta.shiftId,
        name: shiftMeta.shiftName,
        startTime: shiftMeta.startTime,
        endTime: shiftMeta.endTime,
        assignedCount: assignedEmployees.length,
        maxCapacity: shiftMeta.targetCount,
        assignedEmployees: assignedEmployees,
        applicants: applicants,
        waitlist: [], // No waitlist in current domain model
      );
    }).toList();
  }

  /// Handle approve action
  void _handleApprove(Employee employee) {
    // TODO: Implement real approval logic with backend API
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('✓ ${employee.name} approved (API integration needed)'),
        duration: const Duration(milliseconds: 1500),
        backgroundColor: TossColors.success,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  /// Handle overbook action
  void _handleOverbook(Employee employee) {
    // TODO: Implement real overbook logic with backend API
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('✓ ${employee.name} overbooked (API integration needed)'),
        duration: const Duration(milliseconds: 1500),
        backgroundColor: TossColors.primary,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  /// Handle remove from shift action
  void _handleRemove(Employee employee) {
    // TODO: Implement real remove logic with backend API
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('✓ ${employee.name} removed (API integration needed)'),
        duration: const Duration(milliseconds: 1500),
        backgroundColor: TossColors.gray700,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
