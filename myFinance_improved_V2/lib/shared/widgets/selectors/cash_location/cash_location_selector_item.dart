/// Cash Location Selector Item
///
/// Individual cash location item widget used in the selector list.
library;

import 'package:flutter/material.dart';
import 'package:myfinance_improved/core/domain/entities/selector_entities.dart';
import 'package:myfinance_improved/shared/themes/index.dart';

/// Cash location selector item widget
class CashLocationSelectorItem extends StatelessWidget {
  final CashLocationData location;
  final bool isSelected;
  final bool isBlocked;
  final VoidCallback? onTap;
  final bool showTransactionCount;

  const CashLocationSelectorItem({
    super.key,
    required this.location,
    required this.isSelected,
    this.isBlocked = false,
    this.onTap,
    this.showTransactionCount = true,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isBlocked ? null : onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        color: isBlocked
            ? TossColors.gray100
            : isSelected
                ? TossColors.primary.withValues(alpha: 0.05)
                : null,
        child: Row(
          children: [
            _buildIcon(),
            const SizedBox(width: TossSpacing.space3),
            _buildContent(),
            _buildTrailingIcon(),
          ],
        ),
      ),
    );
  }

  Widget _buildIcon() {
    return Icon(
      isBlocked ? Icons.block : Icons.location_on,
      size: TossSpacing.iconSM,
      color: isBlocked
          ? TossColors.gray400
          : isSelected
              ? TossColors.primary
              : TossColors.gray500,
    );
  }

  Widget _buildContent() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            location.displayName,
            style: TossTextStyles.body.copyWith(
              color: isBlocked
                  ? TossColors.gray400
                  : isSelected
                      ? TossColors.primary
                      : TossColors.gray900,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              decoration: isBlocked ? TextDecoration.lineThrough : null,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
          if (showTransactionCount && location.subtitle.isNotEmpty) ...[
            const SizedBox(height: 2),
            Text(
              location.subtitle,
              style: TossTextStyles.small.copyWith(
                color: isBlocked ? TossColors.gray300 : TossColors.gray500,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ],
          if (isBlocked) ...[
            const SizedBox(height: 2),
            Text(
              'Already selected',
              style: TossTextStyles.small.copyWith(
                color: TossColors.error,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTrailingIcon() {
    if (isSelected) {
      return const Icon(
        Icons.check,
        size: TossSpacing.iconSM,
        color: TossColors.primary,
      );
    }
    if (isBlocked) {
      return const Icon(
        Icons.block,
        size: TossSpacing.iconSM,
        color: TossColors.error,
      );
    }
    return const SizedBox.shrink();
  }
}
