import 'package:flutter/material.dart';
import 'package:myfinance_improved/shared/themes/toss_border_radius.dart';
import 'package:myfinance_improved/shared/themes/toss_colors.dart';
import 'package:myfinance_improved/shared/themes/toss_spacing.dart';
import 'package:myfinance_improved/shared/themes/toss_text_styles.dart';

import 'alert_preview_helper.dart';

/// Alert mode selection section
class AlertModeSection extends StatelessWidget {
  final int selectedMode;
  final ValueChanged<int> onModeChanged;

  const AlertModeSection({
    super.key,
    required this.selectedMode,
    required this.onModeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: TossSpacing.space2,
            bottom: TossSpacing.space3,
          ),
          child: Text(
            'ALERT MODE',
            style: TossTextStyles.bodySmall.copyWith(
              fontWeight: FontWeight.w700,
              color: TossColors.gray700,
              letterSpacing: 0.5,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: TossColors.white,
            borderRadius: BorderRadius.circular(TossBorderRadius.xl),
            boxShadow: [
              BoxShadow(
                color: TossColors.gray900.withValues(alpha: 0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              _AlertModeOption(
                icon: Icons.notifications_active_rounded,
                title: 'Full Alerts',
                description: 'Sound + Vibration',
                mode: 0,
                isSelected: selectedMode == 0,
                isFirst: true,
                onTap: () {
                  onModeChanged(0);
                  AlertPreviewHelper.playAlertPreview(context, 0);
                },
              ),
              const _Divider(),
              _AlertModeOption(
                icon: Icons.volume_up_rounded,
                title: 'Sound Only',
                description: 'Best for desk work',
                mode: 1,
                isSelected: selectedMode == 1,
                onTap: () {
                  onModeChanged(1);
                  AlertPreviewHelper.playAlertPreview(context, 1);
                },
              ),
              const _Divider(),
              _AlertModeOption(
                icon: Icons.vibration_rounded,
                title: 'Vibration Only',
                description: 'Best for meetings',
                mode: 2,
                isSelected: selectedMode == 2,
                onTap: () {
                  onModeChanged(2);
                  AlertPreviewHelper.playAlertPreview(context, 2);
                },
              ),
              const _Divider(),
              _AlertModeOption(
                icon: Icons.notifications_off_rounded,
                title: 'Visual Only',
                description: 'Silent notifications',
                mode: 3,
                isSelected: selectedMode == 3,
                isLast: true,
                onTap: () {
                  onModeChanged(3);
                  AlertPreviewHelper.playAlertPreview(context, 3);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space4),
      child: Divider(height: 1, thickness: 1, color: TossColors.gray100),
    );
  }
}

class _AlertModeOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final int mode;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isFirst;
  final bool isLast;

  const _AlertModeOption({
    required this.icon,
    required this.title,
    required this.description,
    required this.mode,
    required this.isSelected,
    required this.onTap,
    this.isFirst = false,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.vertical(
        top: isFirst ? const Radius.circular(TossBorderRadius.xl) : Radius.zero,
        bottom: isLast ? const Radius.circular(TossBorderRadius.xl) : Radius.zero,
      ),
      child: Container(
        padding: const EdgeInsets.all(TossSpacing.space4),
        decoration: BoxDecoration(
          color: isSelected ? TossColors.primarySurface : TossColors.white,
        ),
        child: Row(
          children: [
            _buildIcon(),
            const SizedBox(width: TossSpacing.space3),
            Expanded(child: _buildContent()),
            _buildCheckIndicator(),
          ],
        ),
      ),
    );
  }

  Widget _buildIcon() {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: isSelected
            ? TossColors.primary.withValues(alpha: 0.15)
            : TossColors.gray100,
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
      ),
      child: Icon(
        icon,
        size: 22,
        color: isSelected ? TossColors.primary : TossColors.gray600,
      ),
    );
  }

  Widget _buildContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TossTextStyles.body.copyWith(
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            color: isSelected ? TossColors.primary : TossColors.gray900,
          ),
        ),
        const SizedBox(height: TossSpacing.space1),
        Text(
          description,
          style: TossTextStyles.caption.copyWith(
            color: isSelected
                ? TossColors.primary.withValues(alpha: 0.7)
                : TossColors.gray600,
            height: 1.3,
          ),
        ),
      ],
    );
  }

  Widget _buildCheckIndicator() {
    if (isSelected) {
      return const Icon(
        Icons.check_circle_rounded,
        color: TossColors.primary,
        size: 24,
      );
    }
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: TossColors.gray300,
          width: 2,
        ),
      ),
    );
  }
}
