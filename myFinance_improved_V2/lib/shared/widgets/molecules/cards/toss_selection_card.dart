import 'package:flutter/material.dart';
import 'package:myfinance_improved/shared/themes/index.dart';

/// Toss-style selection card for list item selection
///
/// A unified, reusable selection card that replaces multiple duplicate widgets:
/// - SelectionCard
/// - StoreSelectionCard
/// - CompanySelectionCard
/// - EntryTypeCard
/// - ExpenseSubTypeCard
/// - GenericSelectionCard
///
/// Features:
/// - Leading icon with customizable background
/// - Title with optional description and subtitle
/// - Selection state with check/chevron indicator
/// - Optional highlighted state for special items
///
/// Usage examples:
/// ```dart
/// // Simple - title only
/// TossSelectionCard(
///   title: 'Cash',
///   icon: Icons.payments,
///   isSelected: true,
///   onTap: () {},
/// )
///
/// // With description
/// TossSelectionCard(
///   title: 'Income',
///   description: 'Record incoming money',
///   icon: Icons.arrow_downward,
///   isSelected: false,
///   onTap: () {},
/// )
///
/// // With subtitle (like "3 stores")
/// TossSelectionCard(
///   title: 'ABC Company',
///   subtitle: '3 stores',
///   icon: Icons.business,
///   isSelected: true,
///   onTap: () {},
/// )
///
/// // Factory constructors for common patterns
/// TossSelectionCard.store(
///   storeName: 'Main Branch',
///   isSelected: true,
///   onTap: () {},
/// )
/// ```
class TossSelectionCard extends StatelessWidget {
  /// Main title text
  final String title;

  /// Optional description text (below title, smaller)
  final String? description;

  /// Optional subtitle text (below title, smaller, gray)
  final String? subtitle;

  /// Leading icon
  final IconData icon;

  /// Whether this card is currently selected
  final bool isSelected;

  /// Whether this card should be highlighted (different background)
  final bool isHighlighted;

  /// Icon container size (default: 40)
  final double iconContainerSize;

  /// Icon size (default: 20)
  final double iconSize;

  /// Callback when card is tapped
  final VoidCallback onTap;

  const TossSelectionCard({
    super.key,
    required this.title,
    this.description,
    this.subtitle,
    required this.icon,
    required this.isSelected,
    this.isHighlighted = false,
    this.iconContainerSize = 40,
    this.iconSize = 20,
    required this.onTap,
  });

  /// Factory constructor for store selection
  /// Uses store icon with standard sizing
  factory TossSelectionCard.store({
    Key? key,
    required String storeName,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return TossSelectionCard(
      key: key,
      title: storeName,
      icon: Icons.store,
      isSelected: isSelected,
      onTap: onTap,
    );
  }

  /// Factory constructor for company selection
  /// Shows company name with store count subtitle
  factory TossSelectionCard.company({
    Key? key,
    required String companyName,
    required int storeCount,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return TossSelectionCard(
      key: key,
      title: companyName,
      subtitle: '$storeCount store${storeCount > 1 ? 's' : ''}',
      icon: Icons.business,
      isSelected: isSelected,
      isHighlighted: true, // Company cards have gray200 background
      onTap: onTap,
    );
  }

  /// Factory constructor for entry type selection
  /// Has larger icon container and includes description
  factory TossSelectionCard.entryType({
    Key? key,
    required String label,
    required String description,
    required IconData icon,
    required bool isSelected,
    bool isHighlighted = false,
    required VoidCallback onTap,
  }) {
    return TossSelectionCard(
      key: key,
      title: label,
      description: description,
      icon: icon,
      isSelected: isSelected,
      isHighlighted: isHighlighted,
      iconContainerSize: 48,
      iconSize: 24,
      onTap: onTap,
    );
  }

  /// Factory constructor for expense sub-type selection
  /// Similar to entry type but with smaller icon container
  factory TossSelectionCard.expenseSubType({
    Key? key,
    required String label,
    required String description,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return TossSelectionCard(
      key: key,
      title: label,
      description: description,
      icon: icon,
      isSelected: isSelected,
      iconContainerSize: 44,
      iconSize: 22,
      onTap: onTap,
    );
  }

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
            // Icon container
            _buildIconContainer(),
            const SizedBox(width: TossSpacing.space3),

            // Content area
            Expanded(
              child: _buildContent(),
            ),

            // Trailing indicator
            Icon(
              isSelected ? Icons.check : Icons.chevron_right,
              color: isSelected ? TossColors.gray900 : TossColors.gray300,
              size: TossSpacing.iconMD,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIconContainer() {
    return Container(
      width: iconContainerSize,
      height: iconContainerSize,
      decoration: BoxDecoration(
        color: isHighlighted ? TossColors.gray200 : TossColors.gray100,
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
      ),
      child: Center(
        child: Icon(
          icon,
          color: TossColors.gray600,
          size: iconSize,
        ),
      ),
    );
  }

  Widget _buildContent() {
    // Title only
    if (description == null && subtitle == null) {
      return Text(
        title,
        style: TossTextStyles.body.copyWith(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
          color: TossColors.gray900,
        ),
      );
    }

    // Title + description/subtitle
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: TossTextStyles.body.copyWith(
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
            color: TossColors.gray900,
          ),
        ),
        if (description != null) ...[
          SizedBox(height: TossSpacing.space1 / 2),
          Text(
            description!,
            style: TossTextStyles.caption.copyWith(
              color: TossColors.gray500,
            ),
          ),
        ],
        if (subtitle != null) ...[
          SizedBox(height: TossSpacing.space1 / 2),
          Text(
            subtitle!,
            style: TossTextStyles.caption.copyWith(
              color: TossColors.gray500,
            ),
          ),
        ],
      ],
    );
  }
}

/// Summary card for displaying selected information
/// Used in multi-step flows to show previous selections
class TossSummaryCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final VoidCallback? onEdit;

  const TossSummaryCard({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(TossSpacing.space3),
      decoration: BoxDecoration(
        color: TossColors.gray50,
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
      ),
      child: Row(
        children: [
          Icon(icon, size: TossSpacing.iconSM, color: TossColors.gray500),
          const SizedBox(width: TossSpacing.space2),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TossTextStyles.caption.copyWith(
                    color: TossColors.gray500,
                  ),
                ),
                Text(
                  value,
                  style: TossTextStyles.body.copyWith(
                    fontWeight: FontWeight.w500,
                    color: TossColors.gray900,
                  ),
                ),
              ],
            ),
          ),
          if (onEdit != null)
            GestureDetector(
              onTap: onEdit,
              child: Text(
                'Change',
                style: TossTextStyles.caption.copyWith(
                  color: TossColors.gray600,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Notice card for informational messages
/// Used to display warnings or information in flows
class TossNoticeCard extends StatelessWidget {
  final String message;
  final Color? backgroundColor;
  final Color? borderColor;
  final Color? iconColor;
  final Color? textColor;
  final IconData icon;

  const TossNoticeCard({
    super.key,
    required this.message,
    this.backgroundColor,
    this.borderColor,
    this.iconColor,
    this.textColor,
    this.icon = Icons.info_outline,
  });

  /// Factory for warning-style notice
  factory TossNoticeCard.warning({
    Key? key,
    required String message,
  }) {
    return TossNoticeCard(
      key: key,
      message: message,
      backgroundColor: TossColors.warningLight,
      borderColor: TossColors.warning.withValues(alpha: 0.3),
      iconColor: TossColors.warning,
      textColor: TossColors.warning,
    );
  }

  /// Factory for info-style notice
  factory TossNoticeCard.info({
    Key? key,
    required String message,
  }) {
    return TossNoticeCard(
      key: key,
      message: message,
      backgroundColor: TossColors.infoLight,
      borderColor: TossColors.info.withValues(alpha: 0.3),
      iconColor: TossColors.info,
      textColor: TossColors.info,
    );
  }

  /// Factory for success-style notice
  factory TossNoticeCard.success({
    Key? key,
    required String message,
  }) {
    return TossNoticeCard(
      key: key,
      message: message,
      backgroundColor: TossColors.successLight,
      borderColor: TossColors.success.withValues(alpha: 0.3),
      iconColor: TossColors.success,
      textColor: TossColors.success,
    );
  }

  /// Factory for error-style notice
  factory TossNoticeCard.error({
    Key? key,
    required String message,
  }) {
    return TossNoticeCard(
      key: key,
      message: message,
      backgroundColor: TossColors.errorLight,
      borderColor: TossColors.error.withValues(alpha: 0.3),
      iconColor: TossColors.error,
      textColor: TossColors.error,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(TossSpacing.space3),
      decoration: BoxDecoration(
        color: backgroundColor ?? TossColors.warningLight,
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
        border: Border.all(color: borderColor ?? TossColors.warning.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: iconColor ?? TossColors.warning,
            size: TossSpacing.iconMD,
          ),
          const SizedBox(width: TossSpacing.space2),
          Expanded(
            child: Text(
              message,
              style: TossTextStyles.caption.copyWith(
                color: textColor ?? TossColors.warning,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Transfer arrow indicator widget
/// Shows directional flow between selections
class TossTransferArrow extends StatelessWidget {
  final IconData icon;
  final Color? color;

  const TossTransferArrow({
    super.key,
    this.icon = Icons.arrow_downward,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: TossSpacing.space2),
      child: Center(
        child: Icon(
          icon,
          color: color ?? TossColors.gray400,
          size: TossSpacing.iconMD,
        ),
      ),
    );
  }
}
