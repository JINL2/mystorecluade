import 'package:flutter/material.dart';
import 'package:myfinance_improved/shared/themes/toss_animations.dart';
import 'package:myfinance_improved/shared/themes/toss_border_radius.dart';
import 'package:myfinance_improved/shared/themes/toss_colors.dart';
import 'package:myfinance_improved/shared/themes/toss_font_weight.dart';
import 'package:myfinance_improved/shared/themes/toss_opacity.dart';
import 'package:myfinance_improved/shared/themes/toss_spacing.dart';
import 'package:myfinance_improved/shared/themes/toss_text_styles.dart';
import '../../../domain/value_objects/counter_party_type.dart';

/// Counter party type selector with animated cards
///
/// Displays all available counter party types in a grid layout with
/// animated selection states and visual feedback.
class TypeSelector extends StatelessWidget {
  final CounterPartyType selectedType;
  final ValueChanged<CounterPartyType> onTypeChanged;

  const TypeSelector({
    super.key,
    required this.selectedType,
    required this.onTypeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Type',
          style: TossTextStyles.labelLarge.copyWith(
            color: TossColors.gray700,
            fontWeight: TossFontWeight.medium,
          ),
        ),
        const SizedBox(height: TossSpacing.space3),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 3,
          mainAxisSpacing: TossSpacing.space3,
          crossAxisSpacing: TossSpacing.space3,
          childAspectRatio: 1.1,
          children: [
            _TypeOptionCard(
              type: CounterPartyType.myCompany,
              icon: Icons.business,
              color: TossColors.primary,
              isSelected: selectedType == CounterPartyType.myCompany,
              onTap: () => onTypeChanged(CounterPartyType.myCompany),
            ),
            _TypeOptionCard(
              type: CounterPartyType.teamMember,
              icon: Icons.group,
              color: TossColors.success,
              isSelected: selectedType == CounterPartyType.teamMember,
              onTap: () => onTypeChanged(CounterPartyType.teamMember),
            ),
            _TypeOptionCard(
              type: CounterPartyType.supplier,
              icon: Icons.local_shipping,
              color: TossColors.info,
              isSelected: selectedType == CounterPartyType.supplier,
              onTap: () => onTypeChanged(CounterPartyType.supplier),
            ),
            _TypeOptionCard(
              type: CounterPartyType.employee,
              icon: Icons.badge,
              color: TossColors.warning,
              isSelected: selectedType == CounterPartyType.employee,
              onTap: () => onTypeChanged(CounterPartyType.employee),
            ),
            _TypeOptionCard(
              type: CounterPartyType.customer,
              icon: Icons.people,
              color: TossColors.error,
              isSelected: selectedType == CounterPartyType.customer,
              onTap: () => onTypeChanged(CounterPartyType.customer),
            ),
            _TypeOptionCard(
              type: CounterPartyType.other,
              icon: Icons.category,
              color: TossColors.gray500,
              isSelected: selectedType == CounterPartyType.other,
              onTap: () => onTypeChanged(CounterPartyType.other),
            ),
          ],
        ),
      ],
    );
  }
}

/// Individual type option card with animation
class _TypeOptionCard extends StatelessWidget {
  final CounterPartyType type;
  final IconData icon;
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  const _TypeOptionCard({
    required this.type,
    required this.icon,
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: TossAnimations.normal,
        decoration: BoxDecoration(
          color: isSelected ? color.withValues(alpha: TossOpacity.subtle) : TossColors.gray50,
          borderRadius: BorderRadius.circular(TossBorderRadius.xl),
          border: Border.all(
            color: isSelected ? color : TossColors.gray200,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: TossAnimations.normal,
              padding: const EdgeInsets.all(TossSpacing.space3),
              decoration: BoxDecoration(
                color: isSelected ? color.withValues(alpha: TossOpacity.light) : TossColors.transparent,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: TossSpacing.iconMD,
                color: isSelected ? color : TossColors.gray500,
              ),
            ),
            const SizedBox(height: TossSpacing.space1),
            Text(
              type.displayName,
              style: TossTextStyles.caption.copyWith(
                color: isSelected ? color : TossColors.gray600,
                fontWeight: isSelected ? TossFontWeight.semibold : TossFontWeight.medium,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
