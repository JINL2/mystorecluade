import 'package:flutter/material.dart';

import '../../../../../../core/constants/icon_mapper.dart';
import '../../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../../shared/themes/toss_colors.dart';
import '../../../../../../shared/themes/toss_spacing.dart';
import '../../../../../../shared/themes/toss_text_styles.dart';

/// Shift Settings Section Widget
///
/// Displays number of employees stepper and overtime toggle
class ShiftSettingsSection extends StatelessWidget {
  final int numberShift;
  final bool isCanOvertime;
  final void Function(int) onNumberShiftChanged;
  final void Function(bool) onIsCanOvertimeChanged;

  const ShiftSettingsSection({
    super.key,
    required this.numberShift,
    required this.isCanOvertime,
    required this.onNumberShiftChanged,
    required this.onIsCanOvertimeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(TossSpacing.space4),
      decoration: BoxDecoration(
        color: TossColors.gray100,
        borderRadius: BorderRadius.circular(TossBorderRadius.xl),
        border: Border.all(
          color: TossColors.gray200,
          width: TossSpacing.space1 / 4,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: TossSpacing.space4),
          _buildNumberOfEmployees(),
          const SizedBox(height: TossSpacing.space4),
          const Divider(height: 1, color: TossColors.gray200),
          const SizedBox(height: TossSpacing.space4),
          _buildOvertimeToggle(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Icon(
          IconMapper.getIcon('users'),
          color: TossColors.gray700,
          size: TossSpacing.iconSM,
        ),
        const SizedBox(width: TossSpacing.space2),
        Text(
          'Shift Settings',
          style: TossTextStyles.body.copyWith(
            color: TossColors.gray700,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildNumberOfEmployees() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Required Employees',
                style: TossTextStyles.caption.copyWith(
                  color: TossColors.gray600,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: TossSpacing.space1),
              Text(
                'Number of staff needed for this shift',
                style: TossTextStyles.caption.copyWith(
                  color: TossColors.gray500,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: TossSpacing.space3),
        Row(
          children: [
            _StepperButton(
              icon: Icons.remove,
              onTap: () {
                if (numberShift > 1) {
                  onNumberShiftChanged(numberShift - 1);
                }
              },
              enabled: numberShift > 1,
            ),
            Container(
              width: 48,
              alignment: Alignment.center,
              child: Text(
                '$numberShift',
                style: TossTextStyles.bodyLarge.copyWith(
                  fontWeight: FontWeight.w700,
                  color: TossColors.gray900,
                ),
              ),
            ),
            _StepperButton(
              icon: Icons.add,
              onTap: () {
                if (numberShift < 99) {
                  onNumberShiftChanged(numberShift + 1);
                }
              },
              enabled: numberShift < 99,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildOvertimeToggle() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Allow Overtime',
                style: TossTextStyles.caption.copyWith(
                  color: TossColors.gray600,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: TossSpacing.space1),
              Text(
                'Enable overtime work for this shift',
                style: TossTextStyles.caption.copyWith(
                  color: TossColors.gray500,
                ),
              ),
            ],
          ),
        ),
        Switch(
          value: isCanOvertime,
          onChanged: onIsCanOvertimeChanged,
          activeTrackColor: TossColors.primary.withValues(alpha: 0.5),
          thumbColor: WidgetStateProperty.resolveWith<Color>(
            (states) => states.contains(WidgetState.selected)
                ? TossColors.primary
                : TossColors.gray300,
          ),
        ),
      ],
    );
  }
}

/// Stepper Button Widget
class _StepperButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool enabled;

  const _StepperButton({
    required this.icon,
    required this.onTap,
    required this.enabled,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: enabled ? TossColors.gray200 : TossColors.gray100,
          borderRadius: BorderRadius.circular(TossBorderRadius.md),
        ),
        child: Icon(
          icon,
          size: TossSpacing.iconSM,
          color: enabled ? TossColors.gray700 : TossColors.gray400,
        ),
      ),
    );
  }
}
