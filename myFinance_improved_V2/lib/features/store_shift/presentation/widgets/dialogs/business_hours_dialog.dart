import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_font_weight.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';
import '../../../domain/entities/business_hours.dart';
import '../../providers/store_shift_providers.dart';
import 'widgets/day_hours_data.dart';
import 'widgets/day_item.dart';
import 'widgets/quick_fill_section.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

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
  late Map<int, DayHoursData> _hoursMap;
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
      _hoursMap[i] = DayHoursData(
        dayOfWeek: i,
        dayName: dayName,
        isOpen: true,
        openTime: i == 0 || i == 6 ? '10:00' : '09:00',
        closeTime: i == 0 ? '21:00' : (i == 6 ? '23:00' : '22:00'),
      );
    }

    // Override with initial values
    for (final h in widget.initialHours) {
      _hoursMap[h.dayOfWeek] = DayHoursData(
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
          QuickFillSection(
            weekdayOpen: _weekdayOpen,
            weekdayClose: _weekdayClose,
            weekendOpen: _weekendOpen,
            weekendClose: _weekendClose,
            onWeekdayOpenChanged: (time) => setState(() => _weekdayOpen = time),
            onWeekdayCloseChanged: (time) =>
                setState(() => _weekdayClose = time),
            onWeekendOpenChanged: (time) => setState(() => _weekendOpen = time),
            onWeekendCloseChanged: (time) =>
                setState(() => _weekendClose = time),
            onApplyWeekdays: _applyToWeekdays,
            onApplyWeekend: _applyToWeekend,
            onApplyBoth: _applyBoth,
            onShowTimePicker: _showTimePicker,
          ),
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
              fontWeight: TossFontWeight.semibold,
            ),
          ),
          const SizedBox(height: TossSpacing.space3),

          // Days List (Monday first)
          ..._buildDaysList(),

          const SizedBox(height: TossSpacing.space6),

          // Save Button
          TossButton.primary(
            text: 'Save Changes',
            onPressed: _isSubmitting ? null : _handleSave,
            fullWidth: true,
            leadingIcon: _isSubmitting
                ? TossLoadingView.inline(size: 20, color: TossColors.white)
                : null,
          ),
        ],
      ),
    );
  }

  List<Widget> _buildDaysList() {
    // Order: Monday (1) to Sunday (0)
    final orderedDays = [1, 2, 3, 4, 5, 6, 0];

    return orderedDays.map((dayOfWeek) {
      final data = _hoursMap[dayOfWeek]!;
      return DayItem(
        data: data,
        onToggleOpen: () => _toggleDayOpen(data.dayOfWeek),
        onOpenTimeChanged: (time) => _updateDayTime(
          data.dayOfWeek,
          openTime: time,
        ),
        onCloseTimeChanged: (time) => _updateDayTime(
          data.dayOfWeek,
          closeTime: time,
        ),
        onShowTimePicker: _showTimePicker,
      );
    }).toList();
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
