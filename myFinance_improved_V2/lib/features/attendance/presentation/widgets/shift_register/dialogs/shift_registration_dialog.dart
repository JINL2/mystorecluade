import 'package:flutter/material.dart';
import '../../../../../../shared/themes/toss_colors.dart';
import '../../../../../../shared/themes/toss_spacing.dart';
import '../../../../../../shared/themes/toss_text_styles.dart';
import '../../../../../../shared/themes/toss_border_radius.dart';
import '../utils/shift_register_formatters.dart';

/// Modal dialog for shift registration
class ShiftRegistrationDialog {
  static Future<void> show({
    required BuildContext context,
    required DateTime selectedDate,
    required bool hasShift,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: TossColors.transparent,
      builder: (context) => _ShiftRegistrationContent(
        selectedDate: selectedDate,
        hasShift: hasShift,
      ),
    );
  }
}

class _ShiftRegistrationContent extends StatelessWidget {
  final DateTime selectedDate;
  final bool hasShift;

  const _ShiftRegistrationContent({
    required this.selectedDate,
    required this.hasShift,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      decoration: const BoxDecoration(
        color: TossColors.background,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          // Drag handle
          Container(
            margin: const EdgeInsets.only(top: TossSpacing.space3),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: TossColors.gray300,
              borderRadius: BorderRadius.circular(TossBorderRadius.full),
            ),
          ),

          // Title
          Padding(
            padding: const EdgeInsets.all(TossSpacing.space5),
            child: Text(
              hasShift ? 'Edit Shift' : 'Register Shift',
              style: TossTextStyles.h2.copyWith(
                color: TossColors.gray900,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),

          // Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space5),
              child: Column(
                children: [
                  // Date Display
                  Container(
                    padding: const EdgeInsets.all(TossSpacing.space3),
                    decoration: BoxDecoration(
                      color: TossColors.gray50,
                      borderRadius: BorderRadius.circular(TossBorderRadius.md),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.calendar_today, size: 20, color: TossColors.primary),
                        const SizedBox(width: TossSpacing.space2),
                        Text(
                          '${selectedDate.day} ${ShiftRegisterFormatters.getMonthName(selectedDate.month)} ${selectedDate.year}',
                          style: TossTextStyles.body.copyWith(
                            color: TossColors.gray900,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: TossSpacing.space4),

                  // Placeholder content
                  Text(
                    'Time selection UI would go here',
                    style: TossTextStyles.body.copyWith(
                      color: TossColors.gray600,
                    ),
                  ),

                  const Spacer(),

                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text(
                            'Cancel',
                            style: TossTextStyles.body.copyWith(
                              color: TossColors.gray600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: TossSpacing.space3),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            // Save shift logic here
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: TossColors.primary,
                            padding: const EdgeInsets.symmetric(vertical: TossSpacing.space3),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(TossBorderRadius.md),
                            ),
                          ),
                          child: Text(
                            'Save',
                            style: TossTextStyles.body.copyWith(
                              color: TossColors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: TossSpacing.space5),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
