import 'package:flutter/material.dart';

import '../../../../core/constants/icon_mapper.dart';
import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_spacing.dart';
import '../../../../shared/themes/toss_text_styles.dart';
import '../../../../shared/widgets/toss/toss_card.dart';

/// Store Operating Hours Widget
///
/// Displays operating hours by day of week with edit action.
/// Feature-specific widget for store_shift.
class StoreOperatingHoursWidget extends StatelessWidget {
  final Map<String, dynamic> store;
  final VoidCallback? onEdit;

  const StoreOperatingHoursWidget({
    super.key,
    required this.store,
    this.onEdit,
  });

  Widget _buildDayHours(String day, String hours) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: TossSpacing.space2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            day,
            style: TossTextStyles.body.copyWith(
              color: TossColors.gray700,
            ),
          ),
          Text(
            hours,
            style: TossTextStyles.body.copyWith(
              color: TossColors.gray900,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return TossCard(
      padding: const EdgeInsets.all(TossSpacing.space5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Operating Hours',
                style: TossTextStyles.bodyLarge.copyWith(
                  color: TossColors.gray900,
                  fontWeight: FontWeight.w700,
                ),
              ),
              if (onEdit != null)
                IconButton(
                  onPressed: onEdit,
                  icon: Icon(
                    IconMapper.getIcon('editRegular'),
                    color: TossColors.primary,
                    size: TossSpacing.iconSM,
                  ),
                ),
            ],
          ),
          const SizedBox(height: TossSpacing.space3),

          // Operating hours list
          _buildDayHours('Monday', '09:00 AM - 10:00 PM'),
          _buildDayHours('Tuesday', '09:00 AM - 10:00 PM'),
          _buildDayHours('Wednesday', '09:00 AM - 10:00 PM'),
          _buildDayHours('Thursday', '09:00 AM - 10:00 PM'),
          _buildDayHours('Friday', '09:00 AM - 11:00 PM'),
          _buildDayHours('Saturday', '10:00 AM - 11:00 PM'),
          _buildDayHours('Sunday', '10:00 AM - 09:00 PM'),
        ],
      ),
    );
  }
}
