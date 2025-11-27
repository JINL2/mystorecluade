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
  final Function(DateTime date) onDateSelected;
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
  late List<ShiftData> _shifts;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.selectedDate;
    _currentWeekStart = _getWeekStart(_selectedDate);
    _shifts = _initializeShifts();
  }

  @override
  void didUpdateWidget(ScheduleTabContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedDate != oldWidget.selectedDate) {
      setState(() {
        _selectedDate = widget.selectedDate;
        _currentWeekStart = _getWeekStart(_selectedDate);
      });
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
            datesWithShifts: _getDatesWithShifts(),
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

          // Shift cards
          ..._getShiftsForSelectedDate().map(
            (shift) => ShiftManagementCard(
              shift: shift,
              onApprove: _handleApprove,
              onOverbook: _handleOverbook,
              onRemoveFromShift: _handleRemove,
            ),
          ),

          const SizedBox(height: TossSpacing.space4),
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
    setState(() {
      _currentWeekStart = _currentWeekStart.add(Duration(days: days));
      _selectedDate = _selectedDate.add(Duration(days: days));
    });
    widget.onDateSelected(_selectedDate);
  }

  /// Jump to today
  void _jumpToToday() {
    final today = DateTime.now();
    setState(() {
      _selectedDate = today;
      _currentWeekStart = _getWeekStart(today);
    });
    widget.onDateSelected(_selectedDate);
  }

  /// Get dates with available shifts (mock data - replace with real data)
  Set<DateTime> _getDatesWithShifts() {
    // TODO: Replace with real data from providers
    return {
      _currentWeekStart.add(const Duration(days: 1)), // Tuesday
      _currentWeekStart.add(const Duration(days: 2)), // Wednesday
      _currentWeekStart.add(const Duration(days: 3)), // Thursday
      _currentWeekStart.add(const Duration(days: 4)), // Friday
      _currentWeekStart.add(const Duration(days: 5)), // Saturday
    };
  }

  /// Initialize shifts with mock data
  List<ShiftData> _initializeShifts() {
    // TODO: Replace with real data from providers
    return [
      // Morning shift
      ShiftData(
        name: 'Morning',
        startTime: '09:00',
        endTime: '13:00',
        assignedCount: 2,
        maxCapacity: 4,
        assignedEmployees: [
          Employee(
            name: 'John Doe',
            avatarUrl: 'https://i.pravatar.cc/150?img=1',
          ),
          Employee(
            name: 'Jane Smith',
            avatarUrl: 'https://i.pravatar.cc/150?img=2',
          ),
        ],
        applicants: [
          Employee(
            name: 'Alex Rivera',
            avatarUrl: 'https://i.pravatar.cc/150?img=3',
          ),
          Employee(
            name: 'Jamie Lee',
            avatarUrl: 'https://i.pravatar.cc/150?img=4',
          ),
          Employee(
            name: 'Taylor Kim',
            avatarUrl: 'https://i.pravatar.cc/150?img=5',
          ),
        ],
        waitlist: [],
      ),

      // Afternoon shift
      ShiftData(
        name: 'Afternoon',
        startTime: '13:00',
        endTime: '17:00',
        assignedCount: 4,
        maxCapacity: 4,
        assignedEmployees: [
          Employee(
            name: 'John Doe',
            avatarUrl: 'https://i.pravatar.cc/150?img=1',
          ),
          Employee(
            name: 'Jane Smith',
            avatarUrl: 'https://i.pravatar.cc/150?img=2',
          ),
          Employee(
            name: 'Alex Rivera',
            avatarUrl: 'https://i.pravatar.cc/150?img=3',
          ),
          Employee(
            name: 'Jamie Lee',
            avatarUrl: 'https://i.pravatar.cc/150?img=4',
          ),
        ],
        applicants: [],
        waitlist: [
          Employee(
            name: 'Morgan Chen',
            avatarUrl: 'https://i.pravatar.cc/150?img=6',
          ),
          Employee(
            name: 'Sam Patel',
            avatarUrl: 'https://i.pravatar.cc/150?img=7',
          ),
        ],
      ),
    ];
  }

  /// Get shifts for selected date
  List<ShiftData> _getShiftsForSelectedDate() {
    return _shifts;
  }

  /// Handle approve action
  void _handleApprove(Employee employee) {
    setState(() {
      // Find the shift containing this employee in applicants
      for (var i = 0; i < _shifts.length; i++) {
        final shift = _shifts[i];
        final applicantIndex = shift.applicants.indexWhere((e) => e.id == employee.id);
        if (applicantIndex != -1) {
          // Create updated lists
          final updatedApplicants = List<Employee>.from(shift.applicants)
            ..removeAt(applicantIndex);
          final updatedAssigned = List<Employee>.from(shift.assignedEmployees)
            ..add(employee);

          // Replace shift with updated version
          _shifts[i] = shift.copyWith(
            applicants: updatedApplicants,
            assignedEmployees: updatedAssigned,
            assignedCount: shift.assignedCount + 1,
          );
          break;
        }
      }
    });

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('✓ ${employee.name} approved'),
        duration: const Duration(milliseconds: 1500),
        backgroundColor: TossColors.success,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  /// Handle overbook action
  void _handleOverbook(Employee employee) {
    setState(() {
      // Find the shift containing this employee in waitlist
      for (var i = 0; i < _shifts.length; i++) {
        final shift = _shifts[i];
        final waitlistIndex = shift.waitlist.indexWhere((e) => e.id == employee.id);
        if (waitlistIndex != -1) {
          // Create updated lists
          final updatedWaitlist = List<Employee>.from(shift.waitlist)
            ..removeAt(waitlistIndex);
          final updatedAssigned = List<Employee>.from(shift.assignedEmployees)
            ..add(employee);

          // Replace shift with updated version
          _shifts[i] = shift.copyWith(
            waitlist: updatedWaitlist,
            assignedEmployees: updatedAssigned,
            assignedCount: shift.assignedCount + 1,
          );
          break;
        }
      }
    });

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('✓ ${employee.name} overbooked'),
        duration: const Duration(milliseconds: 1500),
        backgroundColor: TossColors.primary,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  /// Handle remove from shift action
  void _handleRemove(Employee employee) {
    setState(() {
      // Find the shift containing this employee in assigned employees
      for (var i = 0; i < _shifts.length; i++) {
        final shift = _shifts[i];
        final assignedIndex = shift.assignedEmployees.indexWhere((e) => e.id == employee.id);
        if (assignedIndex != -1) {
          // Create updated list with employee removed
          final updatedAssigned = List<Employee>.from(shift.assignedEmployees)
            ..removeAt(assignedIndex);

          // Replace shift with updated version
          _shifts[i] = shift.copyWith(
            assignedEmployees: updatedAssigned,
            assignedCount: shift.assignedCount - 1,
          );
          break;
        }
      }
    });

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('✓ ${employee.name} removed from shift'),
        duration: const Duration(milliseconds: 1500),
        backgroundColor: TossColors.gray700,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
