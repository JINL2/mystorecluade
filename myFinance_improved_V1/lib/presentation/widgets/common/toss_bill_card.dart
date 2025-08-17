import 'package:flutter/material.dart';
import '../../../core/themes/toss_colors.dart';
import '../../../core/themes/toss_text_styles.dart';
import '../../../core/themes/toss_spacing.dart';
import '../../../core/themes/toss_border_radius.dart';
import '../../../core/themes/toss_shadows.dart';

/// Minimal Toss-style Bill Card Component
/// Follows Toss design principles: minimal colors, clear hierarchy, purposeful design
class TossBillCard extends StatelessWidget {
  final String amount;
  final String label;
  final VoidCallback? onTap;
  final bool isSelected;
  final IconData? icon;

  const TossBillCard({
    super.key,
    required this.amount,
    required this.label,
    this.onTap,
    this.isSelected = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(TossSpacing.space5),
        decoration: BoxDecoration(
          // Toss Principle: Clean white surface with subtle border
          color: isSelected 
              ? TossColors.primarySurface  // Very subtle blue tint when selected
              : TossColors.surface,
          borderRadius: BorderRadius.circular(TossBorderRadius.lg),
          border: Border.all(
            color: isSelected 
                ? TossColors.primary.withOpacity(0.2)  // Subtle blue border when selected
                : TossColors.gray200,  // Minimal gray border
            width: 1,
          ),
          // Toss Principle: Subtle, elegant shadows
          boxShadow: isSelected 
              ? TossShadows.card  // Add depth when selected
              : [
                  BoxShadow(
                    color: TossColors.shadow.withOpacity(0.02),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon - Minimal, monochromatic, purposeful
            Container(
              width: TossSpacing.space12,
              height: TossSpacing.space12,
              decoration: BoxDecoration(
                // Toss Principle: Single accent color, very subtle background
                color: isSelected 
                    ? TossColors.primary.withOpacity(0.1)
                    : TossColors.gray100,
                borderRadius: BorderRadius.circular(TossBorderRadius.md),
              ),
              child: Icon(
                icon ?? Icons.receipt_long_outlined,  // Clean, minimal icon
                size: TossSpacing.iconLG,
                color: isSelected 
                    ? TossColors.primary  // Toss Blue for selected state
                    : TossColors.gray600,  // Neutral gray for default state
              ),
            ),
            
            SizedBox(height: TossSpacing.space4),
            
            // Amount - Clear financial hierarchy
            Text(
              amount,
              style: TossTextStyles.h2.copyWith(
                color: TossColors.textPrimary,  // High contrast for clarity
                fontWeight: FontWeight.w700,    // Bold for financial amounts
                letterSpacing: -0.5,            // Tighter spacing for numbers
              ),
            ),
            
            SizedBox(height: TossSpacing.space1),
            
            // Label - Minimal, secondary
            Text(
              label,
              style: TossTextStyles.body.copyWith(
                color: TossColors.textSecondary,  // Lower hierarchy
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Grid of Toss Bill Cards for dashboard/overview pages
class TossBillGrid extends StatelessWidget {
  final List<TossBillItem> items;
  final int crossAxisCount;
  final double spacing;
  final String? selectedBillId;
  final Function(String billId)? onBillTap;

  const TossBillGrid({
    super.key,
    required this.items,
    this.crossAxisCount = 2,
    this.spacing = TossSpacing.space3,
    this.selectedBillId,
    this.onBillTap,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: spacing,
        crossAxisSpacing: spacing,
        childAspectRatio: 1.1,  // Slightly taller for better proportion
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return TossBillCard(
          amount: item.amount,
          label: item.label,
          icon: item.icon,
          isSelected: selectedBillId == item.id,
          onTap: () => onBillTap?.call(item.id),
        );
      },
    );
  }
}

/// Data class for bill items
class TossBillItem {
  final String id;
  final String amount;
  final String label;
  final IconData? icon;

  const TossBillItem({
    required this.id,
    required this.amount,
    required this.label,
    this.icon,
  });
}

/// Example usage with different bill types
class TossBillExamples {
  static const List<TossBillItem> sampleBills = [
    TossBillItem(
      id: 'electricity',
      amount: '₩45,200',
      label: 'Electricity',
      icon: Icons.bolt_outlined,
    ),
    TossBillItem(
      id: 'water',
      amount: '₩18,500',
      label: 'Water',
      icon: Icons.water_drop_outlined,
    ),
    TossBillItem(
      id: 'gas',
      amount: '₩32,100',
      label: 'Gas',
      icon: Icons.local_gas_station_outlined,
    ),
    TossBillItem(
      id: 'internet',
      amount: '₩55,000',
      label: 'Internet',
      icon: Icons.wifi_outlined,
    ),
  ];
}