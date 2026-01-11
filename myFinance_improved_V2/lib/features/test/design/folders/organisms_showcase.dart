/// Organisms Showcase
///
/// Displays all organism components from shared/widgets/organisms folder.
library;

import 'package:flutter/material.dart';
import 'package:myfinance_improved/shared/themes/index.dart';
import 'package:myfinance_improved/shared/widgets/organisms/calendars/toss_month_calendar.dart';
import 'package:myfinance_improved/shared/widgets/organisms/calendars/toss_month_navigation.dart';
import 'package:myfinance_improved/shared/widgets/organisms/calendars/toss_week_navigation.dart';
import 'package:myfinance_improved/shared/widgets/organisms/dialogs/toss_confirm_cancel_dialog.dart';
import 'package:myfinance_improved/shared/widgets/organisms/dialogs/toss_info_dialog.dart';
import 'package:myfinance_improved/shared/widgets/organisms/pickers/toss_date_picker.dart';
import 'package:myfinance_improved/shared/widgets/organisms/pickers/toss_time_picker.dart';
import 'package:myfinance_improved/shared/widgets/organisms/sheets/toss_bottom_sheet.dart';
import 'package:myfinance_improved/shared/widgets/organisms/sheets/toss_selection_bottom_sheet.dart' show TossSelectionBottomSheet, TossSelectionItem;
import 'package:myfinance_improved/shared/widgets/atoms/buttons/toss_button.dart';
import 'package:intl/intl.dart';

class OrganismsShowcase extends StatefulWidget {
  const OrganismsShowcase({super.key});

  @override
  State<OrganismsShowcase> createState() => _OrganismsShowcaseState();
}

class _OrganismsShowcaseState extends State<OrganismsShowcase>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<String> _tabs = [
    'Calendars',
    'Dialogs',
    'Pickers',
    'Sheets',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: TossColors.white,
          child: TabBar(
            controller: _tabController,
            isScrollable: true,
            labelColor: TossColors.primary,
            unselectedLabelColor: TossColors.gray600,
            indicatorColor: TossColors.primary,
            tabs: _tabs.map((tab) => Tab(text: tab)).toList(),
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: const [
              _CalendarsTab(),
              _DialogsTab(),
              _PickersTab(),
              _SheetsTab(),
            ],
          ),
        ),
      ],
    );
  }
}

// ==================== Calendars Tab ====================
class _CalendarsTab extends StatefulWidget {
  const _CalendarsTab();

  @override
  State<_CalendarsTab> createState() => _CalendarsTabState();
}

class _CalendarsTabState extends State<_CalendarsTab> {
  DateTime _currentMonth = DateTime.now();
  DateTime _currentWeek = DateTime.now();
  DateTime _selectedDate = DateTime.now();

  String _getMonthName(DateTime date) {
    return DateFormat('MMMM').format(date);
  }

  String _getWeekDateRange(DateTime date) {
    final startOfWeek = date.subtract(Duration(days: date.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 6));
    return '${DateFormat('d').format(startOfWeek)} - ${DateFormat('d MMM').format(endOfWeek)}';
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(TossSpacing.space4),
      children: [
        _buildComponentCard(
          'TossMonthNavigation',
          'Navigation control for month selection',
          TossMonthNavigation(
            currentMonth: _getMonthName(_currentMonth),
            year: _currentMonth.year,
            onPrevMonth: () => setState(() {
              _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1);
            }),
            onCurrentMonth: () => setState(() {
              _currentMonth = DateTime.now();
            }),
            onNextMonth: () => setState(() {
              _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1);
            }),
          ),
        ),
        const SizedBox(height: TossSpacing.space4),
        _buildComponentCard(
          'TossWeekNavigation',
          'Navigation control for week selection',
          TossWeekNavigation(
            weekLabel: 'This week',
            dateRange: _getWeekDateRange(_currentWeek),
            onPrevWeek: () => setState(() {
              _currentWeek = _currentWeek.subtract(const Duration(days: 7));
            }),
            onCurrentWeek: () => setState(() {
              _currentWeek = DateTime.now();
            }),
            onNextWeek: () => setState(() {
              _currentWeek = _currentWeek.add(const Duration(days: 7));
            }),
          ),
        ),
        const SizedBox(height: TossSpacing.space4),
        _buildComponentCard(
          'TossMonthCalendar',
          'Full month calendar view',
          Container(
            decoration: BoxDecoration(
              color: TossColors.white,
              borderRadius: BorderRadius.circular(TossBorderRadius.lg),
            ),
            child: TossMonthCalendar(
              currentMonth: _currentMonth,
              selectedDate: _selectedDate,
              shiftsInMonth: const {}, // Empty map for demo
              onDateSelected: (date) => setState(() => _selectedDate = date),
            ),
          ),
        ),
      ],
    );
  }
}

// ==================== Dialogs Tab ====================
class _DialogsTab extends StatelessWidget {
  const _DialogsTab();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(TossSpacing.space4),
      children: [
        _buildComponentCard(
          'TossConfirmCancelDialog',
          'Dialog for confirmation with cancel option',
          Center(
            child: TossButton.primary(
              text: 'Show Confirm Dialog',
              onPressed: () {
                TossConfirmCancelDialog.show(
                  context: context,
                  title: 'Delete Transaction',
                  message: 'Are you sure you want to delete this transaction? This action cannot be undone.',
                  confirmButtonText: 'Delete',
                  cancelButtonText: 'Cancel',
                  isDangerousAction: true,
                );
              },
            ),
          ),
        ),
        const SizedBox(height: TossSpacing.space4),
        _buildComponentCard(
          'TossInfoDialog',
          'Dialog for displaying information with bullet points',
          Center(
            child: TossButton.primary(
              text: 'Show Info Dialog',
              onPressed: () {
                TossInfoDialog.show(
                  context: context,
                  title: 'About This Feature',
                  bulletPoints: [
                    'Track your expenses and income across multiple accounts.',
                    'View detailed analytics and reports.',
                    'Set budgets and receive alerts.',
                  ],
                  buttonText: 'Got it',
                );
              },
            ),
          ),
        ),
        const SizedBox(height: TossSpacing.space4),
        _buildComponentCard(
          'TossConfirmCancelDialog.delete',
          'Delete confirmation dialog',
          Center(
            child: TossButton.destructive(
              text: 'Show Delete Dialog',
              onPressed: () {
                TossConfirmCancelDialog.showDelete(
                  context: context,
                  title: 'Delete Transaction',
                  message: 'This action cannot be undone.',
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

// ==================== Pickers Tab ====================
class _PickersTab extends StatefulWidget {
  const _PickersTab();

  @override
  State<_PickersTab> createState() => _PickersTabState();
}

class _PickersTabState extends State<_PickersTab> {
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(TossSpacing.space4),
      children: [
        _buildComponentCard(
          'TossDatePicker',
          'Date picker with wheel selection',
          Column(
            children: [
              TossDatePicker(
                date: _selectedDate,
                placeholder: 'Select date',
                onDateChanged: (date) => setState(() => _selectedDate = date),
              ),
            ],
          ),
        ),
        const SizedBox(height: TossSpacing.space4),
        _buildComponentCard(
          'TossTimePicker',
          'Time picker with wheel selection',
          Column(
            children: [
              TossTimePicker(
                time: _selectedTime,
                placeholder: 'Select time',
                onTimeChanged: (time) => setState(() => _selectedTime = time),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ==================== Sheets Tab ====================
class _SheetsTab extends StatelessWidget {
  const _SheetsTab();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(TossSpacing.space4),
      children: [
        _buildComponentCard(
          'TossBottomSheet',
          'Standard bottom sheet with header',
          Center(
            child: TossButton.primary(
              text: 'Show Bottom Sheet',
              onPressed: () {
                TossBottomSheet.show(
                  context: context,
                  title: 'Transaction Details',
                  content: Padding(
                    padding: const EdgeInsets.all(TossSpacing.space4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _infoRow('Date', 'Jan 15, 2026'),
                        _infoRow('Amount', '\$250.00'),
                        _infoRow('Category', 'Shopping'),
                        _infoRow('Account', 'Checking'),
                        _infoRow('Status', 'Completed'),
                        const SizedBox(height: TossSpacing.space4),
                        TossButton.primary(
                          text: 'Edit Transaction',
                          fullWidth: true,
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        const SizedBox(height: TossSpacing.space4),
        _buildComponentCard(
          'TossSelectionBottomSheet',
          'Bottom sheet for item selection',
          Center(
            child: TossButton.primary(
              text: 'Show Selection Sheet',
              onPressed: () {
                TossSelectionBottomSheet.show(
                  context: context,
                  title: 'Select Account',
                  items: const [
                    TossSelectionItem(id: 'checking', title: 'Checking Account', subtitle: '\$5,250.00'),
                    TossSelectionItem(id: 'savings', title: 'Savings Account', subtitle: '\$12,000.00'),
                    TossSelectionItem(id: 'business', title: 'Business Account', subtitle: '\$45,000.00'),
                  ],
                  selectedId: 'checking',
                  onItemSelected: (item) {},
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  static Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: TossSpacing.space2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TossTextStyles.caption.copyWith(color: TossColors.gray600)),
          Text(value, style: TossTextStyles.bodyMedium),
        ],
      ),
    );
  }
}

// ==================== Helper ====================
Widget _buildComponentCard(String title, String description, Widget child) {
  return Container(
    decoration: BoxDecoration(
      color: TossColors.white,
      borderRadius: BorderRadius.circular(TossBorderRadius.lg),
      border: Border.all(color: TossColors.gray200),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(TossSpacing.space4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TossTextStyles.titleMedium.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: TossSpacing.space1),
              Text(
                description,
                style: TossTextStyles.caption.copyWith(
                  color: TossColors.gray600,
                ),
              ),
            ],
          ),
        ),
        const Divider(height: 1),
        Padding(
          padding: const EdgeInsets.all(TossSpacing.space4),
          child: child,
        ),
      ],
    ),
  );
}
