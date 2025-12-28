import 'package:flutter/material.dart';
import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_border_radius.dart';
import '../../../../shared/themes/toss_spacing.dart';
import '../../../../shared/themes/toss_text_styles.dart';

// ============================================================
// Trade Simple Widgets - Clean, minimal design components
// ============================================================

/// Simple stat chip with dot indicator (e.g., ● Active L/C 5)
///
/// Usage:
/// ```dart
/// TradeStatChip(
///   label: 'Active L/C',
///   value: '5',
///   color: TossColors.success,
/// )
/// ```
class TradeStatChip extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final VoidCallback? onTap;

  const TradeStatChip({
    super.key,
    required this.label,
    required this.value,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: TossSpacing.space3,
          vertical: TossSpacing.space2,
        ),
        decoration: BoxDecoration(
          color: TossColors.white,
          borderRadius: BorderRadius.circular(TossBorderRadius.full),
          border: Border.all(color: TossColors.gray200),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TossTextStyles.caption.copyWith(
                color: TossColors.gray600,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              value,
              style: TossTextStyles.caption.copyWith(
                color: TossColors.gray900,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Horizontal scrollable stat chips row
///
/// Usage:
/// ```dart
/// TradeStatChipsRow(
///   chips: [
///     TradeStatChipData(label: 'Active L/C', value: '5', color: TossColors.success),
///     TradeStatChipData(label: 'In Transit', value: '3', color: TossColors.primary),
///   ],
/// )
/// ```
class TradeStatChipsRow extends StatelessWidget {
  final List<TradeStatChipData> chips;
  final EdgeInsetsGeometry? padding;

  const TradeStatChipsRow({
    super.key,
    required this.chips,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: padding,
      child: Row(
        children: chips.asMap().entries.map((entry) {
          final index = entry.key;
          final chip = entry.value;
          return Padding(
            padding: EdgeInsets.only(
              right: index < chips.length - 1 ? TossSpacing.space2 : 0,
            ),
            child: TradeStatChip(
              label: chip.label,
              value: chip.value,
              color: chip.color,
              onTap: chip.onTap,
            ),
          );
        }).toList(),
      ),
    );
  }
}

/// Data class for TradeStatChip
class TradeStatChipData {
  final String label;
  final String value;
  final Color color;
  final VoidCallback? onTap;

  const TradeStatChipData({
    required this.label,
    required this.value,
    required this.color,
    this.onTap,
  });
}

/// Simple action chip with icon (e.g., + New PI)
///
/// Usage:
/// ```dart
/// TradeActionChip(
///   icon: Icons.add,
///   label: 'New PI',
///   color: TossColors.primary,
///   onTap: () {},
/// )
/// ```
class TradeActionChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback? onTap;

  const TradeActionChip({
    super.key,
    required this.icon,
    required this.label,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(TossBorderRadius.full),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: TossSpacing.space3,
          vertical: TossSpacing.space2,
        ),
        decoration: BoxDecoration(
          color: TossColors.white,
          borderRadius: BorderRadius.circular(TossBorderRadius.full),
          border: Border.all(color: TossColors.gray200),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: color,
              size: 16,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TossTextStyles.caption.copyWith(
                fontWeight: FontWeight.w600,
                color: TossColors.gray700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Horizontal scrollable action chips row
class TradeActionChipsRow extends StatelessWidget {
  final List<TradeActionChipData> chips;
  final EdgeInsetsGeometry? padding;

  const TradeActionChipsRow({
    super.key,
    required this.chips,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: padding,
      child: Row(
        children: chips.asMap().entries.map((entry) {
          final index = entry.key;
          final chip = entry.value;
          return Padding(
            padding: EdgeInsets.only(
              right: index < chips.length - 1 ? TossSpacing.space2 : 0,
            ),
            child: TradeActionChip(
              icon: chip.icon,
              label: chip.label,
              color: chip.color,
              onTap: chip.onTap,
            ),
          );
        }).toList(),
      ),
    );
  }
}

/// Data class for TradeActionChip
class TradeActionChipData {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback? onTap;

  const TradeActionChipData({
    required this.icon,
    required this.label,
    required this.color,
    this.onTap,
  });
}

/// Simple white card with border (no shadow, no gradient)
///
/// Usage:
/// ```dart
/// TradeSimpleCard(
///   child: Column(...),
///   onTap: () {},
/// )
/// ```
class TradeSimpleCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;

  const TradeSimpleCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: padding ?? const EdgeInsets.all(TossSpacing.space4),
        decoration: BoxDecoration(
          color: TossColors.white,
          borderRadius: BorderRadius.circular(TossBorderRadius.lg),
          border: Border.all(color: TossColors.gray200),
        ),
        child: child,
      ),
    );
  }
}

/// Simple amount display card
///
/// Usage:
/// ```dart
/// TradeSimpleAmountCard(
///   title: 'Total Trade Volume',
///   amount: '1,234,567.89',
///   currency: 'USD',
/// )
/// ```
class TradeSimpleAmountCard extends StatelessWidget {
  final String title;
  final String amount;
  final String currency;
  final VoidCallback? onTap;

  const TradeSimpleAmountCard({
    super.key,
    required this.title,
    required this.amount,
    this.currency = 'USD',
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return TradeSimpleCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TossTextStyles.caption.copyWith(
              color: TossColors.gray500,
            ),
          ),
          const SizedBox(height: TossSpacing.space1),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                currency,
                style: TossTextStyles.bodySmall.copyWith(
                  color: TossColors.gray600,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                amount,
                style: TossTextStyles.h2.copyWith(
                  color: TossColors.gray900,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Simple info row with dot, label, value and optional chevron
///
/// Usage:
/// ```dart
/// TradeSimpleInfoRow(
///   label: 'Pending Payment',
///   value: '3',
///   amount: 'USD 50,000.00',
///   dotColor: TossColors.warning,
///   showChevron: true,
///   onTap: () {},
/// )
/// ```
class TradeSimpleInfoRow extends StatelessWidget {
  final String label;
  final String? value;
  final String? amount;
  final Color dotColor;
  final bool showChevron;
  final VoidCallback? onTap;

  const TradeSimpleInfoRow({
    super.key,
    required this.label,
    this.value,
    this.amount,
    required this.dotColor,
    this.showChevron = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return TradeSimpleCard(
      onTap: onTap,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: dotColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      label,
                      style: TossTextStyles.caption.copyWith(
                        color: TossColors.gray500,
                      ),
                    ),
                    if (value != null) ...[
                      const SizedBox(width: 4),
                      Text(
                        value!,
                        style: TossTextStyles.caption.copyWith(
                          color: dotColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ],
                ),
                if (amount != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    amount!,
                    style: TossTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                      color: TossColors.gray900,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (showChevron)
            const Icon(
              Icons.chevron_right,
              color: TossColors.gray400,
              size: 20,
            ),
        ],
      ),
    );
  }
}

/// Section header with title and optional action
///
/// Usage:
/// ```dart
/// TradeSectionHeader(
///   title: 'Quick Actions',
///   actionLabel: 'View all',
///   onAction: () {},
/// )
/// ```
class TradeSectionHeader extends StatelessWidget {
  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;
  final Color? dotColor;
  final String? badge;
  final Color? badgeColor;

  const TradeSectionHeader({
    super.key,
    required this.title,
    this.actionLabel,
    this.onAction,
    this.dotColor,
    this.badge,
    this.badgeColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (dotColor != null) ...[
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: dotColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
        ],
        Text(
          title,
          style: TossTextStyles.caption.copyWith(
            fontWeight: FontWeight.w600,
            color: TossColors.gray500,
          ),
        ),
        if (badge != null) ...[
          const SizedBox(width: 4),
          Text(
            badge!,
            style: TossTextStyles.caption.copyWith(
              fontWeight: FontWeight.w600,
              color: badgeColor ?? TossColors.gray900,
            ),
          ),
        ],
        const Spacer(),
        if (actionLabel != null)
          GestureDetector(
            onTap: onAction,
            child: Text(
              actionLabel!,
              style: TossTextStyles.caption.copyWith(
                color: TossColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
      ],
    );
  }
}

/// Simple list item with dot indicator
///
/// Usage:
/// ```dart
/// TradeSimpleListItem(
///   title: 'L/C Expiry Warning',
///   subtitle: 'LC-2024-001 expires in 7 days',
///   dotColor: TossColors.warning,
///   onTap: () {},
/// )
/// ```
class TradeSimpleListItem extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Color dotColor;
  final bool showChevron;
  final VoidCallback? onTap;

  const TradeSimpleListItem({
    super.key,
    required this.title,
    this.subtitle,
    required this.dotColor,
    this.showChevron = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(TossSpacing.space3),
        child: Row(
          children: [
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: dotColor,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: TossSpacing.space3),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TossTextStyles.bodySmall.copyWith(
                      fontWeight: FontWeight.w500,
                      color: TossColors.gray900,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (subtitle != null && subtitle!.isNotEmpty)
                    Text(
                      subtitle!,
                      style: TossTextStyles.caption.copyWith(
                        color: TossColors.gray500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),
            if (showChevron)
              const Icon(
                Icons.chevron_right,
                color: TossColors.gray400,
                size: 18,
              ),
          ],
        ),
      ),
    );
  }
}

/// Simple list card with items and dividers
///
/// Usage:
/// ```dart
/// TradeSimpleListCard(
///   items: [
///     TradeSimpleListItemData(title: 'Item 1', dotColor: TossColors.error),
///     TradeSimpleListItemData(title: 'Item 2', subtitle: 'Details', dotColor: TossColors.warning),
///   ],
/// )
/// ```
class TradeSimpleListCard extends StatelessWidget {
  final List<TradeSimpleListItemData> items;

  const TradeSimpleListCard({
    super.key,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const SizedBox.shrink();

    return Container(
      decoration: BoxDecoration(
        color: TossColors.white,
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        border: Border.all(color: TossColors.gray200),
      ),
      child: Column(
        children: items.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          final isLast = index == items.length - 1;

          return Column(
            children: [
              TradeSimpleListItem(
                title: item.title,
                subtitle: item.subtitle,
                dotColor: item.dotColor,
                showChevron: item.showChevron,
                onTap: item.onTap,
              ),
              if (!isLast)
                Divider(
                  height: 1,
                  indent: TossSpacing.space4,
                  endIndent: TossSpacing.space4,
                  color: TossColors.gray100,
                ),
            ],
          );
        }).toList(),
      ),
    );
  }
}

/// Data class for TradeSimpleListItem
class TradeSimpleListItemData {
  final String title;
  final String? subtitle;
  final Color dotColor;
  final bool showChevron;
  final VoidCallback? onTap;

  const TradeSimpleListItemData({
    required this.title,
    this.subtitle,
    required this.dotColor,
    this.showChevron = true,
    this.onTap,
  });
}
