import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:myfinance_improved/shared/models/index.dart';
import 'package:myfinance_improved/shared/themes/index.dart';
import 'package:myfinance_improved/shared/widgets/atoms/sheets/check_indicator.dart';
import 'package:myfinance_improved/shared/widgets/atoms/sheets/icon_container.dart';
import 'package:myfinance_improved/shared/widgets/atoms/sheets/avatar_circle.dart';

/// Visual style variants for selection items
enum SelectionItemVariant {
  /// Icon + title + subtitle (default)
  standard,

  /// Title only, no icon
  minimal,

  /// Avatar image + title + subtitle
  avatar,

  /// Compact with smaller padding
  compact,
}

/// A single selectable item in a selection list
class SelectionListItem extends StatelessWidget {
  final SelectionItem item;
  final bool isSelected;
  final VoidCallback? onTap;
  final SelectionItemVariant variant;
  final bool enableHaptic;
  final bool showDivider;
  final IconData? defaultIcon;

  const SelectionListItem({
    super.key,
    required this.item,
    this.isSelected = false,
    this.onTap,
    this.variant = SelectionItemVariant.standard,
    this.enableHaptic = false,
    this.showDivider = false,
    this.defaultIcon,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (enableHaptic) {
          HapticFeedback.selectionClick();
        }
        onTap?.call();
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: TossSpacing.space5,
          vertical: variant == SelectionItemVariant.compact
              ? TossSpacing.space2
              : TossSpacing.space3,
        ),
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: showDivider
              ? const Border(
                  bottom: BorderSide(color: TossColors.gray100, width: 0.5),
                )
              : null,
        ),
        child: Row(
          children: [
            // Leading (icon or avatar)
            if (variant != SelectionItemVariant.minimal) ...[
              _buildLeading(),
              const SizedBox(width: TossSpacing.space3),
            ],

            // Content
            Expanded(child: _buildContent()),

            // Trailing widget (if any)
            if (item.trailing != null) ...[
              const SizedBox(width: 8),
              item.trailing!,
            ],

            // Check indicator
            CheckIndicator(isVisible: isSelected),
          ],
        ),
      ),
    );
  }

  Widget _buildLeading() {
    if (variant == SelectionItemVariant.avatar) {
      return AvatarCircle(
        imageUrl: item.avatarUrl,
        isSelected: isSelected,
        size: 40,
      );
    }

    return IconContainer(
      icon: item.icon ?? defaultIcon ?? LucideIcons.circle,
      isSelected: isSelected,
    );
  }

  Widget _buildContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          item.title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            color: TossColors.gray900,
          ),
        ),
        if (item.subtitle != null &&
            variant != SelectionItemVariant.minimal) ...[
          const SizedBox(height: 2),
          Text(
            item.subtitle!,
            style: const TextStyle(
              fontSize: 13,
              color: TossColors.gray500,
            ),
          ),
        ],
      ],
    );
  }
}
