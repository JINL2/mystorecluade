import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/constants/icon_mapper.dart';
import '../../../../shared/themes/toss_border_radius.dart';
import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_font_weight.dart';
import '../../../../shared/themes/toss_spacing.dart';
import '../../../../shared/themes/toss_text_styles.dart';
import '../../domain/entities/business_hours.dart';
import '../providers/store_shift_providers.dart';
import 'dialogs/business_hours_dialog.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

/// Business Hours Section Widget
///
/// Displays store operating hours with edit action.
/// Shows each day's hours in a compact format.
class BusinessHoursSection extends ConsumerWidget {
  final String storeId;

  const BusinessHoursSection({
    super.key,
    required this.storeId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hoursAsync = ref.watch(businessHoursProvider);

    return TossCard(
      padding: const EdgeInsets.all(TossSpacing.space5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: TossSpacing.iconXL,
                    height: TossSpacing.iconXL,
                    decoration: BoxDecoration(
                      color: TossColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(TossBorderRadius.md),
                    ),
                    child: const Icon(
                      LucideIcons.clock,
                      color: TossColors.primary,
                      size: TossSpacing.iconSM,
                    ),
                  ),
                  const SizedBox(width: TossSpacing.space3),
                  Text(
                    'Business Hours',
                    style: TossTextStyles.bodyLarge.copyWith(
                      color: TossColors.gray900,
                      fontWeight: TossFontWeight.bold,
                    ),
                  ),
                ],
              ),
              IconButton(
                onPressed: () => _showEditDialog(context, ref, hoursAsync),
                icon: Icon(
                  IconMapper.getIcon('editRegular'),
                  color: TossColors.primary,
                  size: TossSpacing.iconSM,
                ),
              ),
            ],
          ),
          const SizedBox(height: TossSpacing.space4),

          // Hours List
          hoursAsync.when(
            data: (hours) => _buildHoursList(hours),
            loading: () => const Padding(
              padding: EdgeInsets.all(TossSpacing.space4),
              child: TossLoadingView(),
            ),
            error: (e, _) => Center(
              child: Text(
                'Failed to load hours',
                style: TossTextStyles.caption.copyWith(color: TossColors.error),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHoursList(List<BusinessHours> hours) {
    // Sort by day of week, starting from Monday (1) to Sunday (0)
    final sortedHours = List<BusinessHours>.from(hours);
    sortedHours.sort((a, b) {
      // Convert to Monday-first ordering (Mon=0, Tue=1, ..., Sun=6)
      final aOrder = a.dayOfWeek == 0 ? 6 : a.dayOfWeek - 1;
      final bOrder = b.dayOfWeek == 0 ? 6 : b.dayOfWeek - 1;
      return aOrder.compareTo(bOrder);
    });

    return Column(
      children: sortedHours.map((h) => _buildDayRow(h)).toList(),
    );
  }

  Widget _buildDayRow(BusinessHours hours) {
    final isWeekend = hours.dayOfWeek == 0 || hours.dayOfWeek == 6;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: TossSpacing.space2),
      child: Row(
        children: [
          // Day name
          SizedBox(
            width: 80,
            child: Text(
              _getShortDayName(hours.dayName),
              style: TossTextStyles.body.copyWith(
                color: isWeekend ? TossColors.primary : TossColors.gray700,
                fontWeight: isWeekend ? TossFontWeight.semibold : TossFontWeight.medium,
              ),
            ),
          ),
          // Hours or Closed
          Expanded(
            child: hours.isOpen
                ? Row(
                    children: [
                      Text(
                        '${_formatTimeToAmPm(hours.openTime)} - ${_formatTimeToAmPm(hours.closeTime)}',
                        style: TossTextStyles.body.copyWith(
                          color: TossColors.gray900,
                        ),
                      ),
                      if (hours.closesNextDay) ...[
                        SizedBox(width: TossSpacing.space1),
                        const Icon(
                          LucideIcons.moon,
                          size: TossSpacing.space3,
                          color: TossColors.warning,
                        ),
                      ],
                    ],
                  )
                : Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: TossSpacing.space2,
                      vertical: TossSpacing.space1,
                    ),
                    decoration: BoxDecoration(
                      color: TossColors.gray100,
                      borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                    ),
                    child: Text(
                      'Closed',
                      style: TossTextStyles.caption.copyWith(
                        color: TossColors.gray500,
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  /// Convert 24-hour format to AM/PM format
  String _formatTimeToAmPm(String? time) {
    if (time == null) return '--:--';
    final parts = time.split(':');
    if (parts.length < 2) return time;

    final hour = int.tryParse(parts[0]) ?? 0;
    final minute = parts[1];

    if (hour == 0) {
      return '12:$minute AM';
    } else if (hour < 12) {
      return '$hour:$minute AM';
    } else if (hour == 12) {
      return '12:$minute PM';
    } else {
      return '${hour - 12}:$minute PM';
    }
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

  void _showEditDialog(
    BuildContext context,
    WidgetRef ref,
    AsyncValue<List<BusinessHours>> hoursAsync,
  ) {
    final hours = hoursAsync.valueOrNull ?? BusinessHours.defaultHours();
    showBusinessHoursDialog(context, storeId, hours);
  }
}
