import 'package:flutter/material.dart';
import 'package:myfinance_improved/shared/themes/index.dart';

/// Collapsible Section Widget with expand/collapse animation
class CollapsibleSection extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool isExpanded;
  final bool hasSelection;
  final String? selectedLabel;
  final IconData? selectedIcon;
  final VoidCallback onToggle;
  final Widget content;

  const CollapsibleSection({
    super.key,
    required this.title,
    required this.subtitle,
    required this.isExpanded,
    required this.hasSelection,
    this.selectedLabel,
    this.selectedIcon,
    required this.onToggle,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: TossAnimations.normal,
      curve: Curves.easeInOut,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          GestureDetector(
            onTap: onToggle,
            child: hasSelection && !isExpanded
                ? _CollapsedHeader(
                    title: title,
                    selectedLabel: selectedLabel ?? '',
                    selectedIcon: selectedIcon,
                  )
                : _ExpandedHeader(
                    title: title,
                    subtitle: subtitle,
                    hasSelection: hasSelection,
                    isExpanded: isExpanded,
                  ),
          ),

          // Content
          AnimatedCrossFade(
            duration: TossAnimations.normal,
            crossFadeState:
                isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
            firstChild: const SizedBox.shrink(),
            secondChild: Padding(
              padding: const EdgeInsets.only(top: TossSpacing.space3),
              child: content,
            ),
          ),
        ],
      ),
    );
  }
}

class _ExpandedHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool hasSelection;
  final bool isExpanded;

  const _ExpandedHeader({
    required this.title,
    required this.subtitle,
    required this.hasSelection,
    required this.isExpanded,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: TossSpacing.space1,
        vertical: TossSpacing.space2,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TossTextStyles.h4.copyWith(
                    fontWeight: FontWeight.bold,
                    color: TossColors.gray900,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TossTextStyles.caption.copyWith(
                    color: TossColors.gray500,
                  ),
                ),
              ],
            ),
          ),
          if (hasSelection)
            Icon(
              isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
              color: TossColors.gray400,
              size: 24,
            ),
        ],
      ),
    );
  }
}

class _CollapsedHeader extends StatelessWidget {
  final String title;
  final String selectedLabel;
  final IconData? selectedIcon;

  const _CollapsedHeader({
    required this.title,
    required this.selectedLabel,
    this.selectedIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(TossSpacing.space3),
      decoration: BoxDecoration(
        color: TossColors.gray50,
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        border: Border.all(color: TossColors.gray200),
      ),
      child: Row(
        children: [
          // Icon
          if (selectedIcon != null)
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: TossColors.gray100,
                borderRadius: BorderRadius.circular(TossBorderRadius.md),
              ),
              child: Center(
                child: Icon(
                  selectedIcon,
                  color: TossColors.gray600,
                  size: 18,
                ),
              ),
            ),
          if (selectedIcon != null) const SizedBox(width: TossSpacing.space3),

          // Title and selection
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TossTextStyles.small.copyWith(
                    color: TossColors.gray500,
                  ),
                ),
                Text(
                  selectedLabel,
                  style: TossTextStyles.body.copyWith(
                    color: TossColors.gray900,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          // Arrow only
          const Icon(
            Icons.keyboard_arrow_down,
            color: TossColors.gray400,
            size: 24,
          ),
        ],
      ),
    );
  }
}

/// Debt Section Header Badge
class DebtSectionHeader extends StatelessWidget {
  final String label;
  final Color color;
  final Color backgroundColor;

  const DebtSectionHeader({
    super.key,
    required this.label,
    required this.color,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}
