import 'package:flutter/material.dart';
import 'package:myfinance_improved/shared/themes/index.dart';

/// Main Entry Type Card Widget
class EntryTypeCard extends StatelessWidget {
  final String label;
  final String description;
  final IconData icon;
  final bool isSelected;
  final bool isHighlighted;
  final VoidCallback onTap;

  const EntryTypeCard({
    super.key,
    required this.label,
    required this.description,
    required this.icon,
    required this.isSelected,
    this.isHighlighted = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(TossSpacing.space4),
        decoration: BoxDecoration(
          color: TossColors.white,
          borderRadius: BorderRadius.circular(TossBorderRadius.lg),
          border: Border.all(
            color: isSelected ? TossColors.gray900 : TossColors.gray200,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: isHighlighted ? TossColors.gray200 : TossColors.gray100,
                borderRadius: BorderRadius.circular(TossBorderRadius.md),
              ),
              child: Center(
                child: Icon(
                  icon,
                  color: TossColors.gray600,
                  size: 24,
                ),
              ),
            ),
            const SizedBox(width: TossSpacing.space3),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TossTextStyles.body.copyWith(
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                      color: TossColors.gray900,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    description,
                    style: TossTextStyles.caption.copyWith(
                      color: TossColors.gray500,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              isSelected ? Icons.check : Icons.chevron_right,
              color: isSelected ? TossColors.gray900 : TossColors.gray300,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}

/// Expense SubType Card Widget
class ExpenseSubTypeCard extends StatelessWidget {
  final String label;
  final String description;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const ExpenseSubTypeCard({
    super.key,
    required this.label,
    required this.description,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(TossSpacing.space4),
        decoration: BoxDecoration(
          color: TossColors.white,
          borderRadius: BorderRadius.circular(TossBorderRadius.lg),
          border: Border.all(
            color: isSelected ? TossColors.gray900 : TossColors.gray200,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: TossColors.gray100,
                borderRadius: BorderRadius.circular(TossBorderRadius.md),
              ),
              child: Center(
                child: Icon(
                  icon,
                  color: TossColors.gray600,
                  size: 22,
                ),
              ),
            ),
            const SizedBox(width: TossSpacing.space3),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TossTextStyles.body.copyWith(
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                      color: TossColors.gray900,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    description,
                    style: TossTextStyles.caption.copyWith(
                      color: TossColors.gray500,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              isSelected ? Icons.check : Icons.chevron_right,
              color: isSelected ? TossColors.gray900 : TossColors.gray300,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}

/// Generic Selection Card Widget
class GenericSelectionCard extends StatelessWidget {
  final String title;
  final String? description;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const GenericSelectionCard({
    super.key,
    required this.title,
    this.description,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(TossSpacing.space4),
        decoration: BoxDecoration(
          color: TossColors.white,
          borderRadius: BorderRadius.circular(TossBorderRadius.lg),
          border: Border.all(
            color: isSelected ? TossColors.gray900 : TossColors.gray200,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: TossColors.gray100,
                borderRadius: BorderRadius.circular(TossBorderRadius.md),
              ),
              child: Center(
                child: Icon(
                  icon,
                  color: TossColors.gray600,
                  size: 22,
                ),
              ),
            ),
            const SizedBox(width: TossSpacing.space3),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: TossTextStyles.body.copyWith(
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                      color: TossColors.gray900,
                    ),
                  ),
                  if (description != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      description!,
                      style: TossTextStyles.caption.copyWith(
                        color: TossColors.gray500,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Icon(
              isSelected ? Icons.check : Icons.chevron_right,
              color: isSelected ? TossColors.gray900 : TossColors.gray300,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
