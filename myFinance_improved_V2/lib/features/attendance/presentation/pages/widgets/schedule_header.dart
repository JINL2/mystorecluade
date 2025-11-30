import 'package:flutter/material.dart';

import '../../../../../shared/widgets/toss/toggle_button.dart';
import '../../../../../shared/widgets/toss/toss_today_shift_card.dart';
import '../../../domain/entities/shift_card.dart';

enum ViewMode { week, month }

/// Header component with Today's Shift Card and View Toggle
class ScheduleHeader extends StatelessWidget {
  final GlobalKey? cardKey;
  final ViewMode viewMode;
  final VoidCallback? onCheckIn;
  final VoidCallback? onCheckOut;
  final ValueChanged<ViewMode> onViewModeChanged;

  const ScheduleHeader({
    super.key,
    this.cardKey,
    required this.viewMode,
    this.onCheckIn,
    this.onCheckOut,
    required this.onViewModeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Today's Shift Card (with GlobalKey to measure height)
        Container(
          key: cardKey,
          child: TossTodayShiftCard(
            shiftType: 'Morning',
            date: 'Tue, 18 Jun 2025',
            timeRange: '09:00 - 17:00',
            location: 'Downtown Store',
            status: ShiftStatus.onTime,
            onCheckIn: onCheckIn ?? () {},
            onCheckOut: onCheckOut ?? () {},
          ),
        ),
        const SizedBox(height: 16),

        // Toggle Button (Week/Month toggle) - Left aligned with 8px offset
        Padding(
          padding: const EdgeInsets.only(left: 8),
          child: ToggleButtonGroup(
            items: const [
              ToggleButtonItem(id: 'week', label: 'Week'),
              ToggleButtonItem(id: 'month', label: 'Month'),
            ],
            selectedId: viewMode == ViewMode.week ? 'week' : 'month',
            onToggle: (id) {
              onViewModeChanged(
                id == 'week' ? ViewMode.week : ViewMode.month,
              );
            },
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
