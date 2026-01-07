// lib/features/transaction_history/presentation/widgets/filter_sheet/scope_toggle_section.dart
//
// Scope toggle section extracted from transaction_filter_sheet.dart
// Following Clean Architecture 2025 - Single Responsibility Principle

import 'package:flutter/material.dart';

import '../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_dimensions.dart';
import '../../../../../shared/themes/toss_font_weight.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';
import '../../../domain/entities/transaction_filter.dart';

/// Scope toggle section for store/company view
class ScopeToggleSection extends StatelessWidget {
  final TransactionScope selectedScope;
  final ValueChanged<TransactionScope> onScopeChanged;

  const ScopeToggleSection({
    super.key,
    required this.selectedScope,
    required this.onScopeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Scope',
          style: TossTextStyles.label.copyWith(
            color: TossColors.textSecondary,
            fontWeight: TossFontWeight.semibold,
          ),
        ),
        const SizedBox(height: TossSpacing.space2),
        Container(
          decoration: BoxDecoration(
            color: TossColors.gray50,
            borderRadius: BorderRadius.circular(TossBorderRadius.lg),
            border: Border.all(color: TossColors.gray200),
          ),
          child: Row(
            children: [
              _ScopeOption(
                label: 'Store View',
                icon: Icons.store,
                isSelected: selectedScope == TransactionScope.store,
                onTap: () => onScopeChanged(TransactionScope.store),
                isLeft: true,
              ),
              Container(
                width: TossDimensions.dividerThickness,
                height: TossSpacing.space6,
                color: TossColors.gray200,
              ),
              _ScopeOption(
                label: 'Company View',
                icon: Icons.business,
                isSelected: selectedScope == TransactionScope.company,
                onTap: () => onScopeChanged(TransactionScope.company),
                isLeft: false,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Scope option button
class _ScopeOption extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isLeft;

  const _ScopeOption({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
    required this.isLeft,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.horizontal(
          left: isLeft ? const Radius.circular(TossBorderRadius.lg - 1) : Radius.zero,
          right: isLeft ? Radius.zero : const Radius.circular(TossBorderRadius.lg - 1),
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: TossSpacing.space3),
          decoration: BoxDecoration(
            color: isSelected ? TossColors.white : TossColors.transparent,
            borderRadius: BorderRadius.horizontal(
              left: isLeft ? const Radius.circular(TossBorderRadius.lg - 1) : Radius.zero,
              right: isLeft ? Radius.zero : const Radius.circular(TossBorderRadius.lg - 1),
            ),
            border: isSelected ? Border.all(color: TossColors.primary) : null,
          ),
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  size: TossSpacing.iconXS,
                  color: isSelected ? TossColors.primary : TossColors.gray500,
                ),
                const SizedBox(width: TossSpacing.space1),
                Text(
                  label,
                  style: TossTextStyles.caption.copyWith(
                    color: isSelected ? TossColors.primary : TossColors.gray600,
                    fontWeight: isSelected ? TossFontWeight.semibold : TossFontWeight.regular,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
