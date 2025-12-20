import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';
import '../../../../../shared/widgets/common/toss_success_error_dialog.dart';
import '../../../../../shared/widgets/toss/toss_bottom_sheet.dart';
import '../../../../../shared/widgets/toss/toss_primary_button.dart';
import '../../../../../shared/widgets/toss/toss_time_picker.dart';
import '../../../domain/entities/business_hours.dart';
import '../../providers/store_shift_providers.dart';

/// Show Business Hours Dialog
void showBusinessHoursDialog(
  BuildContext context,
  String storeId,
  List<BusinessHours> initialHours,
) {
  TossBottomSheet.show<void>(
    context: context,
    title: 'Edit Business Hours',
    content: _BusinessHoursContent(
      storeId: storeId,
      initialHours: initialHours,
    ),
  );
}

/// Business Hours Content Widget
class _BusinessHoursContent extends ConsumerStatefulWidget {
  final String storeId;
  final List<BusinessHours> initialHours;

  const _BusinessHoursContent({
    required this.storeId,
    required this.initialHours,
  });

  @override
  ConsumerState<_BusinessHoursContent> createState() =>
      _BusinessHoursContentState();
}

class _BusinessHoursContentState extends ConsumerState<_BusinessHoursContent> {
  late Map<int, _DayHoursData> _hoursMap;
  bool _isSubmitting = false;

  // Quick fill state
  String _weekdayOpen = '09:00';
  String _weekdayClose = '22:00';
  String _weekendOpen = '10:00';
  String _weekendClose = '21:00';

  @override
  void initState() {
    super.initState();
    _initializeHoursMap();
  }

  void _initializeHoursMap() {
    _hoursMap = {};

    // Initialize with defaults for all 7 days
    for (var i = 0; i < 7; i++) {
      final dayName = BusinessHours.dayNumberToName[i] ?? '';
      _hoursMap[i] = _DayHoursData(
        dayOfWeek: i,
        dayName: dayName,
        isOpen: true,
        openTime: i == 0 || i == 6 ? '10:00' : '09:00',
        closeTime: i == 0 ? '21:00' : (i == 6 ? '23:00' : '22:00'),
      );
    }

    // Override with initial values
    for (final h in widget.initialHours) {
      _hoursMap[h.dayOfWeek] = _DayHoursData(
        dayOfWeek: h.dayOfWeek,
        dayName: h.dayName,
        isOpen: h.isOpen,
        openTime: h.openTime ?? '09:00',
        closeTime: h.closeTime ?? '22:00',
        closesNextDay: h.closesNextDay,
      );
    }

    // Update quick fill values from first weekday and weekend
    final monday = _hoursMap[1];
    if (monday != null && monday.isOpen) {
      _weekdayOpen = monday.openTime;
      _weekdayClose = monday.closeTime;
    }

    final sunday = _hoursMap[0];
    if (sunday != null && sunday.isOpen) {
      _weekendOpen = sunday.openTime;
      _weekendClose = sunday.closeTime;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Quick Fill Section
          _buildQuickFillSection(),
          const SizedBox(height: TossSpacing.space5),

          // Divider
          Container(
            height: 1,
            color: TossColors.gray100,
          ),
          const SizedBox(height: TossSpacing.space5),

          // Individual Days Section
          Text(
            'Individual Days',
            style: TossTextStyles.body.copyWith(
              color: TossColors.gray700,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: TossSpacing.space3),

          // Days List (Monday first)
          ..._buildDaysList(),

          const SizedBox(height: TossSpacing.space6),

          // Save Button
          TossPrimaryButton(
            text: 'Save Changes',
            onPressed: _isSubmitting ? null : _handleSave,
            fullWidth: true,
            leadingIcon: _isSubmitting
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: TossColors.white,
                      strokeWidth: 2,
                    ),
                  )
                : null,
          ),
        ],
      ),
    );
  }

  Widget _buildQuickFillSection() {
    return Container(
      padding: const EdgeInsets.all(TossSpacing.space4),
      decoration: BoxDecoration(
        color: TossColors.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        border: Border.all(
          color: TossColors.primary.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                LucideIcons.zap,
                color: TossColors.primary,
                size: TossSpacing.iconSM,
              ),
              const SizedBox(width: TossSpacing.space2),
              Text(
                'Quick Fill',
                style: TossTextStyles.body.copyWith(
                  color: TossColors.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: TossSpacing.space3),

          // Weekday Quick Fill
          _buildQuickFillRow(
            label: 'Weekdays (Mon-Fri)',
            openTime: _weekdayOpen,
            closeTime: _weekdayClose,
            onOpenChanged: (time) => setState(() => _weekdayOpen = time),
            onCloseChanged: (time) => setState(() => _weekdayClose = time),
            onApply: () => _applyToWeekdays(),
          ),

          const SizedBox(height: TossSpacing.space3),

          // Weekend Quick Fill
          _buildQuickFillRow(
            label: 'Weekend (Sat-Sun)',
            openTime: _weekendOpen,
            closeTime: _weekendClose,
            onOpenChanged: (time) => setState(() => _weekendOpen = time),
            onCloseChanged: (time) => setState(() => _weekendClose = time),
            onApply: () => _applyToWeekend(),
          ),

          const SizedBox(height: TossSpacing.space3),

          // Apply All Button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: _applyBoth,
              icon: const Icon(LucideIcons.copyCheck, size: 16),
              label: const Text('Apply Both'),
              style: OutlinedButton.styleFrom(
                foregroundColor: TossColors.primary,
                side: const BorderSide(color: TossColors.primary),
                padding: const EdgeInsets.symmetric(
                  vertical: TossSpacing.space3,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickFillRow({
    required String label,
    required String openTime,
    required String closeTime,
    required ValueChanged<String> onOpenChanged,
    required ValueChanged<String> onCloseChanged,
    required VoidCallback onApply,
  }) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Text(
            label,
            style: TossTextStyles.caption.copyWith(
              color: TossColors.gray700,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: _buildTimeButton(
            time: openTime,
            onChanged: onOpenChanged,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space2),
          child: Text(
            '-',
            style: TossTextStyles.body.copyWith(color: TossColors.gray500),
          ),
        ),
        Expanded(
          flex: 2,
          child: _buildTimeButton(
            time: closeTime,
            onChanged: onCloseChanged,
          ),
        ),
        const SizedBox(width: TossSpacing.space2),
        IconButton(
          onPressed: onApply,
          icon: const Icon(LucideIcons.check, size: 18),
          color: TossColors.success,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(
            minWidth: 32,
            minHeight: 32,
          ),
          tooltip: 'Apply',
        ),
      ],
    );
  }

  List<Widget> _buildDaysList() {
    // Order: Monday (1) to Sunday (0)
    final orderedDays = [1, 2, 3, 4, 5, 6, 0];

    return orderedDays.map((dayOfWeek) {
      final data = _hoursMap[dayOfWeek]!;
      return _buildDayItem(data);
    }).toList();
  }

  Widget _buildDayItem(_DayHoursData data) {
    final isWeekend = data.dayOfWeek == 0 || data.dayOfWeek == 6;
    final isOvernight = data.isOpen && data.isOvernight;

    return Container(
      margin: const EdgeInsets.only(bottom: TossSpacing.space2),
      padding: const EdgeInsets.symmetric(
        horizontal: TossSpacing.space3,
        vertical: TossSpacing.space2,
      ),
      decoration: BoxDecoration(
        color: isWeekend
            ? TossColors.primary.withValues(alpha: 0.05)
            : TossColors.gray50,
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Day name
              SizedBox(
                width: 50,
                child: Text(
                  _getShortDayName(data.dayName),
                  style: TossTextStyles.body.copyWith(
                    color: isWeekend ? TossColors.primary : TossColors.gray700,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              // Open/Closed Toggle
              GestureDetector(
                onTap: () => _toggleDayOpen(data.dayOfWeek),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: TossSpacing.space2,
                    vertical: TossSpacing.space1,
                  ),
                  decoration: BoxDecoration(
                    color: data.isOpen
                        ? TossColors.success.withValues(alpha: 0.1)
                        : TossColors.gray200,
                    borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                  ),
                  child: Text(
                    data.isOpen ? 'Open' : 'Closed',
                    style: TossTextStyles.caption.copyWith(
                      color:
                          data.isOpen ? TossColors.success : TossColors.gray500,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              const Spacer(),

              // Time Selectors (only if open)
              if (data.isOpen) ...[
                _buildTimeButton(
                  time: data.openTime,
                  onChanged: (time) => _updateDayTime(
                    data.dayOfWeek,
                    openTime: time,
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: TossSpacing.space2),
                  child: Text(
                    '-',
                    style:
                        TossTextStyles.body.copyWith(color: TossColors.gray400),
                  ),
                ),
                _buildTimeButton(
                  time: data.closeTime,
                  onChanged: (time) => _updateDayTime(
                    data.dayOfWeek,
                    closeTime: time,
                  ),
                ),
              ],
            ],
          ),
          // Overnight indicator
          if (isOvernight)
            Padding(
              padding: const EdgeInsets.only(top: TossSpacing.space1),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Icon(
                    LucideIcons.moon,
                    size: 12,
                    color: TossColors.warning,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Closes next day',
                    style: TossTextStyles.caption.copyWith(
                      color: TossColors.warning,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTimeButton({
    required String time,
    required ValueChanged<String> onChanged,
  }) {
    return InkWell(
      onTap: () => _showTimePicker(time, onChanged),
      borderRadius: BorderRadius.circular(TossBorderRadius.sm),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: TossSpacing.space3,
          vertical: TossSpacing.space2,
        ),
        decoration: BoxDecoration(
          color: TossColors.white,
          borderRadius: BorderRadius.circular(TossBorderRadius.sm),
          border: Border.all(color: TossColors.gray200),
        ),
        child: Text(
          time,
          style: TossTextStyles.body.copyWith(
            color: TossColors.gray900,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Future<void> _showTimePicker(
    String currentTime,
    ValueChanged<String> onChanged,
  ) async {
    final parts = currentTime.split(':');
    final hour = int.tryParse(parts[0]) ?? 9;
    final minute = int.tryParse(parts.length > 1 ? parts[1] : '0') ?? 0;

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return TossSimpleWheelTimePicker(
          initialTime: TimeOfDay(hour: hour, minute: minute),
          title: 'Select Time',
          use24HourFormat: false, // Use AM/PM format for easier overnight input
          onTimeSelected: (TimeOfDay? picked) {
            Navigator.of(dialogContext).pop();
            if (picked != null) {
              // Store as 24-hour format internally
              final formattedTime =
                  '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
              onChanged(formattedTime);
            }
          },
        );
      },
    );
  }

  void _toggleDayOpen(int dayOfWeek) {
    setState(() {
      final current = _hoursMap[dayOfWeek]!;
      _hoursMap[dayOfWeek] = current.copyWith(isOpen: !current.isOpen);
    });
  }

  void _updateDayTime(int dayOfWeek, {String? openTime, String? closeTime}) {
    setState(() {
      final current = _hoursMap[dayOfWeek]!;
      _hoursMap[dayOfWeek] = current.copyWith(
        openTime: openTime ?? current.openTime,
        closeTime: closeTime ?? current.closeTime,
        closesNextDay: false, // Reset - will be auto-detected by isOvernight
      );
    });
  }

  void _applyToWeekdays() {
    setState(() {
      for (var i = 1; i <= 5; i++) {
        final current = _hoursMap[i]!;
        _hoursMap[i] = current.copyWith(
          isOpen: true,
          openTime: _weekdayOpen,
          closeTime: _weekdayClose,
          closesNextDay: false, // Reset - will be auto-detected by isOvernight
        );
      }
    });
  }

  void _applyToWeekend() {
    setState(() {
      // Saturday (6) and Sunday (0)
      for (final i in [0, 6]) {
        final current = _hoursMap[i]!;
        _hoursMap[i] = current.copyWith(
          isOpen: true,
          openTime: _weekendOpen,
          closeTime: _weekendClose,
          closesNextDay: false, // Reset - will be auto-detected by isOvernight
        );
      }
    });
  }

  void _applyBoth() {
    setState(() {
      // Apply weekday hours to Mon-Fri (1-5)
      for (var i = 1; i <= 5; i++) {
        final current = _hoursMap[i]!;
        _hoursMap[i] = current.copyWith(
          isOpen: true,
          openTime: _weekdayOpen,
          closeTime: _weekdayClose,
          closesNextDay: false, // Reset - will be auto-detected by isOvernight
        );
      }
      // Apply weekend hours to Sat (6) and Sun (0)
      for (final i in [0, 6]) {
        final current = _hoursMap[i]!;
        _hoursMap[i] = current.copyWith(
          isOpen: true,
          openTime: _weekendOpen,
          closeTime: _weekendClose,
          closesNextDay: false, // Reset - will be auto-detected by isOvernight
        );
      }
    });
  }

  String _getShortDayName(String dayName) {
    const shortNames = {
      'Sunday': 'Sun',
      'Monday': 'Mon',
      'Tuesday': 'Tue',
      'Wednesday': 'Wed',
      'Thursday': 'Thu',
      'Friday': 'Fri',
      'Saturday': 'Sat',
    };
    return shortNames[dayName] ?? dayName;
  }

  Future<void> _handleSave() async {
    setState(() => _isSubmitting = true);

    try {
      // Convert to BusinessHours entities
      final hours = _hoursMap.values.map((data) {
        return BusinessHours(
          dayOfWeek: data.dayOfWeek,
          dayName: data.dayName,
          isOpen: data.isOpen,
          openTime: data.isOpen ? data.openTime : null,
          closeTime: data.isOpen ? data.closeTime : null,
          closesNextDay: data.isOpen ? data.isOvernight : false,
        );
      }).toList();

      // Call update provider
      final updateHours = ref.read(updateBusinessHoursProvider);
      final success = await updateHours(
        storeId: widget.storeId,
        hours: hours,
      );

      if (mounted) {
        Navigator.pop(context);

        if (success) {
          await showDialog<bool>(
            context: context,
            barrierDismissible: false,
            builder: (context) => TossDialog.success(
              title: 'Hours Updated',
              message: 'Business hours updated successfully',
              primaryButtonText: 'OK',
            ),
          );
        } else {
          await showDialog<bool>(
            context: context,
            barrierDismissible: true,
            builder: (context) => TossDialog.error(
              title: 'Update Failed',
              message: 'Failed to update business hours',
              primaryButtonText: 'OK',
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isSubmitting = false);
        await showDialog<bool>(
          context: context,
          barrierDismissible: true,
          builder: (context) => TossDialog.error(
            title: 'Update Failed',
            message: 'Failed to update hours: $e',
            primaryButtonText: 'OK',
          ),
        );
      }
    }
  }
}

/// Internal data class for managing day hours state
class _DayHoursData {
  final int dayOfWeek;
  final String dayName;
  final bool isOpen;
  final String openTime;
  final String closeTime;
  final bool closesNextDay; // True if close_time is on the next day (overnight)

  _DayHoursData({
    required this.dayOfWeek,
    required this.dayName,
    required this.isOpen,
    required this.openTime,
    required this.closeTime,
    this.closesNextDay = false,
  });

  _DayHoursData copyWith({
    int? dayOfWeek,
    String? dayName,
    bool? isOpen,
    String? openTime,
    String? closeTime,
    bool? closesNextDay,
  }) {
    return _DayHoursData(
      dayOfWeek: dayOfWeek ?? this.dayOfWeek,
      dayName: dayName ?? this.dayName,
      isOpen: isOpen ?? this.isOpen,
      openTime: openTime ?? this.openTime,
      closeTime: closeTime ?? this.closeTime,
      closesNextDay: closesNextDay ?? this.closesNextDay,
    );
  }

  /// Check if this is an overnight schedule (close time is on the next day)
  /// Auto-detect if close time is earlier than open time
  bool get isOvernight {
    if (closesNextDay) return true;
    // Auto-detect: if close time is before open time, it's overnight
    final openParts = openTime.split(':');
    final closeParts = closeTime.split(':');
    final openMinutes = int.parse(openParts[0]) * 60 + int.parse(openParts[1]);
    final closeMinutes =
        int.parse(closeParts[0]) * 60 + int.parse(closeParts[1]);
    return closeMinutes < openMinutes;
  }
}
