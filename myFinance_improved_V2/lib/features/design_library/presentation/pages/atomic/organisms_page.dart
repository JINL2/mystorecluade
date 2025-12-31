import 'package:flutter/material.dart';
import 'package:myfinance_improved/shared/themes/index.dart';
// Dialogs
import 'package:myfinance_improved/shared/widgets/organisms/dialogs/toss_confirm_cancel_dialog.dart';
import 'package:myfinance_improved/shared/widgets/organisms/dialogs/toss_info_dialog.dart';
import 'package:myfinance_improved/shared/widgets/organisms/dialogs/toss_success_error_dialog.dart';
// Sheets
import 'package:myfinance_improved/shared/widgets/organisms/sheets/toss_bottom_sheet.dart';
import 'package:myfinance_improved/shared/widgets/organisms/sheets/toss_selection_bottom_sheet.dart';
// Pickers
import 'package:myfinance_improved/shared/widgets/organisms/pickers/toss_date_picker.dart';
import 'package:myfinance_improved/shared/widgets/organisms/pickers/toss_time_picker.dart';
// Calendars
import 'package:myfinance_improved/shared/widgets/organisms/calendars/toss_month_calendar.dart';
import 'package:myfinance_improved/shared/widgets/organisms/calendars/toss_month_navigation.dart';
import 'package:myfinance_improved/shared/widgets/organisms/calendars/toss_week_navigation.dart';
// Shift
import 'package:myfinance_improved/shared/widgets/organisms/shift/toss_today_shift_card.dart';
import 'package:myfinance_improved/shared/widgets/organisms/shift/toss_week_shift_card.dart';
// Atoms
import 'package:myfinance_improved/shared/widgets/atoms/buttons/toss_button.dart';

/// Organisms Page - 복잡한 UI 컴포넌트 (Atoms + Molecules 조합)
///
/// Dialogs, Sheets, Pickers 카테고리로 구성
class OrganismsPage extends StatefulWidget {
  const OrganismsPage({super.key});
  @override
  State<OrganismsPage> createState() => OrganismsPageState();
}
class OrganismsPageState extends State<OrganismsPage> {
  // Interactive states
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  TossSelectionItem? _selectedItem;
  // Calendar states
  DateTime _currentMonth = DateTime.now();
  DateTime _selectedCalendarDate = DateTime.now();
  String? _highlightedWidget;
  // Scroll controller for programmatic scrolling
  final ScrollController _scrollController = ScrollController();
  // Widget keys for scrolling
  final Map<String, GlobalKey> _widgetKeys = {};
  GlobalKey _getKeyForWidget(String name) {
    return _widgetKeys.putIfAbsent(name, () => GlobalKey());
  }
  /// Scroll to a specific widget by name. Returns true if successful.
  bool scrollToWidget(String widgetName) {
    // First try exact match
    var key = _widgetKeys[widgetName];
    // If not found, try to find by base name (for variants)
    if (key?.currentContext == null) {
      for (final entry in _widgetKeys.entries) {
        if (entry.key.split(' ').first == widgetName) {
          key = entry.value;
          break;
        }
      }
    }
    if (key?.currentContext != null) {
      Scrollable.ensureVisible(
        key!.currentContext!,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        alignment: 0.3,
      );
      setState(() => _highlightedWidget = widgetName);
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) setState(() => _highlightedWidget = null);
      });
      return true;
    return false;
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  Widget build(BuildContext context) {
    return ListView(
      controller: _scrollController,
      padding: const EdgeInsets.all(TossSpacing.space4),
      children: [
        _buildSectionHeader('Dialogs', Icons.chat_bubble),
        _buildDialogsSection(),
        const SizedBox(height: TossSpacing.space6),
        _buildSectionHeader('Sheets', Icons.vertical_align_bottom),
        _buildSheetsSection(),
        _buildSectionHeader('Pickers', Icons.date_range),
        _buildPickersSection(),
        _buildSectionHeader('Calendars', Icons.calendar_month),
        _buildCalendarsSection(),
        _buildSectionHeader('Shift Cards', Icons.work_outline),
        _buildShiftSection(),
        const SizedBox(height: TossSpacing.space8),
      ],
    );
  Widget _buildSectionHeader(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: TossSpacing.space4),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: TossColors.warningLight,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: TossColors.warning, size: 20),
          ),
          const SizedBox(width: TossSpacing.space3),
          Text(
            title,
            style: TossTextStyles.h3.copyWith(
              fontWeight: FontWeight.w700,
        ],
      ),
  Widget _buildDialogsSection() {
    return _buildShowcaseCard(
        _buildWidgetItem(
          'TossConfirmCancelDialog',
          'lib/shared/widgets/organisms/dialogs/toss_confirm_cancel_dialog.dart',
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildActionButton(
                'Default',
                TossColors.primary,
                () => _showConfirmDialog(),
              ),
                'Delete',
                TossColors.error,
                () => _showDeleteDialog(),
                'Save',
                TossColors.success,
                () => _showSaveDialog(),
            ],
        ),
          'TossInfoDialog',
          'lib/shared/widgets/organisms/dialogs/toss_info_dialog.dart',
          _buildActionButton(
            'Show Info',
            TossColors.info,
            () => _showInfoDialog(),
          'TossDialog (Success/Error/Warning)',
          'lib/shared/widgets/organisms/dialogs/toss_success_error_dialog.dart',
                'Success',
                () => _showSuccessDialog(),
                'Error',
                () => _showErrorDialog(),
                'Warning',
                TossColors.warning,
                () => _showWarningDialog(),
  Widget _buildSheetsSection() {
          'TossBottomSheet',
          'lib/shared/widgets/organisms/sheets/toss_bottom_sheet.dart',
                'Basic',
                () => _showBasicBottomSheet(),
                'With Actions',
                () => _showActionsBottomSheet(),
          'TossSelectionBottomSheet (Interactive)',
          'lib/shared/widgets/organisms/sheets/toss_selection_bottom_sheet.dart',
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
                'Select Store',
                () => _showSelectionSheet(),
              if (_selectedItem != null) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: TossColors.successLight,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle, color: TossColors.success, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'Selected: ${_selectedItem!.title}',
                        style: TossTextStyles.body.copyWith(color: TossColors.success),
                      ),
                    ],
                ),
              ],
  Widget _buildPickersSection() {
          'TossDatePicker (Interactive)',
          'lib/shared/widgets/organisms/pickers/toss_date_picker.dart',
              TossDatePicker(
                date: _selectedDate,
                placeholder: 'Select date',
                onDateChanged: (date) => setState(() => _selectedDate = date),
              if (_selectedDate != null) ...[
                Text(
                  'Selected: ${_selectedDate!.month}/${_selectedDate!.day}/${_selectedDate!.year}',
                  style: TossTextStyles.caption.copyWith(color: TossColors.warning),
          'TossTimePicker (Interactive)',
          'lib/shared/widgets/organisms/pickers/toss_time_picker.dart',
              TossTimePicker(
                time: _selectedTime,
                placeholder: 'Select time',
                onTimeChanged: (time) => setState(() => _selectedTime = time),
              if (_selectedTime != null) ...[
                  'Selected: ${_formatTime(_selectedTime!)}',
  Widget _buildCalendarsSection() {
    // Sample shift data for the calendar
    final now = DateTime.now();
    final sampleShifts = <DateTime, bool>{
      DateTime(now.year, now.month, now.day + 1): true, // available
      DateTime(now.year, now.month, now.day + 2): true,
      DateTime(now.year, now.month, now.day + 3): false, // assigned
      DateTime(now.year, now.month, now.day + 5): true,
    };
    // Month names for display
    const months = ['January', 'February', 'March', 'April', 'May', 'June',
                    'July', 'August', 'September', 'October', 'November', 'December'];
          'TossMonthNavigation',
          'lib/shared/widgets/organisms/calendars/toss_month_navigation.dart',
          TossMonthNavigation(
            currentMonth: months[_currentMonth.month - 1],
            year: _currentMonth.year,
            onPrevMonth: () => setState(() {
              _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1);
            }),
            onCurrentMonth: () => setState(() {
              _currentMonth = DateTime.now();
              _showSnackBar('Jumped to current month');
            onNextMonth: () => setState(() {
              _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1);
          'TossWeekNavigation',
          'lib/shared/widgets/organisms/calendars/toss_week_navigation.dart',
          TossWeekNavigation(
            weekLabel: 'This week',
            dateRange: '${now.day} - ${now.day + 6} ${months[now.month - 1].substring(0, 3)}',
            onPrevWeek: () => _showSnackBar('Previous week'),
            onCurrentWeek: () => _showSnackBar('Current week'),
            onNextWeek: () => _showSnackBar('Next week'),
          'TossMonthCalendar',
          'lib/shared/widgets/organisms/calendars/toss_month_calendar.dart',
          TossMonthCalendar(
            selectedDate: _selectedCalendarDate,
            currentMonth: _currentMonth,
            shiftsInMonth: sampleShifts,
            onDateSelected: (date) {
              setState(() => _selectedCalendarDate = date);
              _showSnackBar('Selected: ${date.day}/${date.month}');
            },
  Widget _buildShiftSection() {
          'TossTodayShiftCard (Upcoming)',
          'lib/shared/widgets/organisms/shift/toss_today_shift_card.dart',
          TossTodayShiftCard(
            shiftType: 'Morning Shift',
            date: 'Tue, 31 Dec 2024',
            timeRange: '09:00 - 17:00',
            location: 'Downtown Store',
            status: ShiftStatus.upcoming,
            onCheckIn: () => _showSnackBar('Check-in pressed!'),
          'TossTodayShiftCard (In Progress)',
            shiftType: 'Evening Shift',
            timeRange: '14:00 - 22:00',
            location: 'Main Office',
            status: ShiftStatus.inProgress,
            onCheckOut: () => _showSnackBar('Check-out pressed!'),
          'TossTodayShiftCard (No Shift)',
            status: ShiftStatus.noShift,
            onGoToShiftSignUp: () => _showSnackBar('Go to shift sign up!'),
          'TossWeekShiftCard',
          'lib/shared/widgets/organisms/shift/toss_week_shift_card.dart',
              TossWeekShiftCard(
                date: 'Mon, 30 Dec',
                shiftType: 'Morning Shift',
                timeRange: '09:00 - 17:00',
                status: ShiftCardStatus.onTime,
                onTap: () => _showSnackBar('Shift card tapped!'),
              const SizedBox(height: 8),
                date: 'Tue, 31 Dec',
                shiftType: 'Evening Shift',
                timeRange: '14:00 - 22:00',
                status: ShiftCardStatus.upcoming,
                isClosestUpcoming: true,
                onTap: () => _showSnackBar('Upcoming shift tapped!'),
  Widget _buildActionButton(String label, Color color, VoidCallback onPressed) {
    return Material(
      color: color.withValues(alpha: 0.1),
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Text(
            label,
            style: TossTextStyles.body.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
  // Dialog methods
  void _showConfirmDialog() {
    showDialog(
      context: context,
      builder: (_) => TossConfirmCancelDialog(
        title: 'Confirm Action',
        message: 'Are you sure you want to proceed with this action?',
        onConfirm: () {
          Navigator.pop(context);
          _showSnackBar('Confirmed!');
        },
        onCancel: () {
          _showSnackBar('Cancelled');
  void _showDeleteDialog() {
      builder: (_) => TossConfirmCancelDialog.delete(
        title: 'Delete Item',
        message: 'This action cannot be undone. Are you sure?',
          _showSnackBar('Deleted!');
  void _showSaveDialog() {
      builder: (_) => TossConfirmCancelDialog.save(
        title: 'Save Changes',
          _showSnackBar('Saved!');
  void _showInfoDialog() {
    TossInfoDialog.show(
      title: 'What is an SKU?',
      bulletPoints: [
        'An SKU (Stock Keeping Unit) is a unique code.',
        'You can enter your own or have one generated.',
        'SKUs help you find items quickly.',
  void _showSuccessDialog() {
      builder: (_) => TossDialog.success(
        title: 'Success!',
        message: 'Your operation completed successfully.',
        primaryButtonText: 'Continue',
        onPrimaryPressed: () => Navigator.pop(context),
  void _showErrorDialog() {
      builder: (_) => TossDialog.error(
        title: 'Error Occurred',
        message: 'Something went wrong. Please try again.',
        primaryButtonText: 'Retry',
  void _showWarningDialog() {
      builder: (_) => TossDialog.warning(
        title: 'Warning',
        message: 'This action may have consequences.',
        primaryButtonText: 'Proceed',
        secondaryButtonText: 'Cancel',
        onSecondaryPressed: () => Navigator.pop(context),
  // Sheet methods
  void _showBasicBottomSheet() {
    TossBottomSheet.show(
      title: 'Bottom Sheet',
      content: Column(
        mainAxisSize: MainAxisSize.min,
          Text('This is a basic bottom sheet.', style: TossTextStyles.body),
          const SizedBox(height: 16),
          TossButton.primary(
            text: 'Close',
            fullWidth: true,
            onPressed: () => Navigator.pop(context),
  void _showActionsBottomSheet() {
      title: 'Choose Action',
      content: const SizedBox.shrink(),
      actions: [
        TossActionItem(
          title: 'Edit',
          icon: Icons.edit,
          onTap: () => _showSnackBar('Edit selected'),
          title: 'Share',
          icon: Icons.share,
          onTap: () => _showSnackBar('Share selected'),
          title: 'Delete',
          icon: Icons.delete,
          isDestructive: true,
          onTap: () => _showSnackBar('Delete selected'),
  void _showSelectionSheet() {
    TossSelectionBottomSheet.show(
      title: 'Select Store',
      items: const [
        TossSelectionItem(
          id: '1',
          title: 'Main Store',
          subtitle: 'ST001',
          icon: Icons.store,
          id: '2',
          title: 'Branch A',
          subtitle: 'ST002',
          id: '3',
          title: 'Branch B',
          subtitle: 'ST003',
      selectedId: _selectedItem?.id,
      onItemSelected: (item) {
        setState(() => _selectedItem = item);
      },
  Widget _buildShowcaseCard({required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: TossColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: TossColors.gray100),
      child: Column(
        children: children,
  Widget _buildWidgetItem(String name, String path, Widget widget) {
    // Use full name as key to avoid duplicates
    final baseName = name.split(' ').first;
    final isHighlighted = _highlightedWidget == baseName || _highlightedWidget == name;
      key: _getKeyForWidget(name),
        color: isHighlighted ? TossColors.warningLight : null,
        border: Border(
          bottom: BorderSide(color: TossColors.gray100),
          left: isHighlighted
              ? BorderSide(color: TossColors.warning, width: 3)
              : BorderSide.none,
        crossAxisAlignment: CrossAxisAlignment.start,
          Row(
              Expanded(
                child: Text(
                  name,
                  style: TossTextStyles.body.copyWith(
                    fontWeight: FontWeight.w600,
                    color: isHighlighted ? TossColors.warning : TossColors.gray900,
              GestureDetector(
                onTap: () => _showPathDialog(name, path),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    color: TossColors.gray50,
                    borderRadius: BorderRadius.circular(4),
                    mainAxisSize: MainAxisSize.min,
                      Icon(Icons.code, size: 12, color: TossColors.gray500),
                      const SizedBox(width: 4),
                        'Code',
                        style: TossTextStyles.small.copyWith(color: TossColors.gray500),
          const SizedBox(height: TossSpacing.space3),
          widget,
  String _formatTime(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:${time.minute.toString().padLeft(2, '0')} $period';
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
  void _showPathDialog(String name, String path) {
      builder: (context) => AlertDialog(
        title: Text(name, style: TossTextStyles.h3),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('File Path:', style: TossTextStyles.caption),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: TossColors.gray50,
                borderRadius: BorderRadius.circular(8),
              child: Text(
                path,
                style: TossTextStyles.small.copyWith(
                  fontFamily: 'monospace',
                  color: TossColors.gray700,
          ],
        actions: [
          TextButton(
            child: const Text('Close'),
