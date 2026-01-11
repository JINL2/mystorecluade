import 'package:flutter/material.dart';
import 'package:myfinance_improved/shared/themes/index.dart';
import 'package:myfinance_improved/core/constants/ui_constants.dart';
import 'toss_dropdown.dart';

/// Bottom sheet content for TossDropdown selection
///
/// Separated for easier customization and control.
/// Can be used standalone via [TossDropdownBottomSheet.show].
class TossDropdownBottomSheet<T> extends StatelessWidget {
  final String title;
  final List<TossDropdownItem<T>> items;
  final T? selectedValue;
  final ValueChanged<T?>? onSelected;

  // Configurable constants
  static const double maxHeightRatio = 0.8;
  static const double minHeight = 200.0;
  static const double handleBarWidth = 36.0;
  static const double handleBarHeight = 4.0;
  static const double iconSize = TossSpacing.iconMD;

  const TossDropdownBottomSheet({
    super.key,
    required this.title,
    required this.items,
    this.selectedValue,
    this.onSelected,
  });

  /// Show the bottom sheet as a modal
  static Future<T?> show<T>({
    required BuildContext context,
    required String title,
    required List<TossDropdownItem<T>> items,
    T? selectedValue,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      backgroundColor: TossColors.transparent,
      barrierColor: TossColors.black54,
      isScrollControlled: true,
      enableDrag: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(TossBorderRadius.xl),
          topRight: Radius.circular(TossBorderRadius.xl),
        ),
      ),
      builder: (context) => TossDropdownBottomSheet<T>(
        title: title,
        items: items,
        selectedValue: selectedValue,
        onSelected: (value) => Navigator.of(context).pop(value),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * maxHeightRatio,
        minHeight: minHeight,
      ),
      decoration: _buildDecoration(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHandleBar(),
          _buildHeader(),
          const SizedBox(height: TossSpacing.space3),
          _buildOptionsList(context),
        ],
      ),
    );
  }

  BoxDecoration _buildDecoration() {
    return BoxDecoration(
      color: TossColors.surface,
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(TossBorderRadius.xl),
        topRight: Radius.circular(TossBorderRadius.xl),
      ),
      boxShadow: [
        BoxShadow(
          color: TossColors.gray900.withValues(alpha: 0.08),
          blurRadius: 16,
          offset: const Offset(0, -4),
        ),
      ],
    );
  }

  Widget _buildHandleBar() {
    return Container(
      width: handleBarWidth,
      height: handleBarHeight,
      margin: const EdgeInsets.only(
        top: TossSpacing.space3,
        bottom: TossSpacing.space4,
      ),
      decoration: BoxDecoration(
        color: TossColors.gray300,
        borderRadius: BorderRadius.circular(TossBorderRadius.xs),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: TossTextStyles.h4,
          ),
        ],
      ),
    );
  }

  Widget _buildOptionsList(BuildContext context) {
    return Flexible(
      child: ListView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).padding.bottom + TossSpacing.space4,
        ),
        itemCount: items.length,
        itemBuilder: (context, index) => _buildOptionItem(context, items[index]),
      ),
    );
  }

  Widget _buildOptionItem(BuildContext context, TossDropdownItem<T> item) {
    final isSelected = item.value == selectedValue;

    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: TossSpacing.space4,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        color: TossColors.transparent,
      ),
      child: Material(
        color: TossColors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(TossBorderRadius.lg),
          onTap: () {
            onSelected?.call(item.value);
          },
          child: _buildOptionContent(item, isSelected),
        ),
      ),
    );
  }

  Widget _buildOptionContent(TossDropdownItem<T> item, bool isSelected) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: TossSpacing.space3,
        vertical: TossSpacing.space3,
      ),
      child: Row(
        children: [
          // Icon (if provided)
          if (item.icon != null) ...[
            Icon(
              item.icon,
              size: TossSpacing.iconMD,
              color: TossColors.gray400,
            ),
            const SizedBox(width: TossSpacing.space3),
          ],
          Expanded(
            child: _buildOptionText(item, isSelected),
          ),
          if (isSelected) _buildCheckIcon(),
        ],
      ),
    );
  }

  Widget _buildOptionText(TossDropdownItem<T> item, bool isSelected) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          item.label,
          style: TossTextStyles.body.copyWith(
            color: TossColors.textPrimary,
            fontWeight: FontWeight.w500,
            fontSize: UIConstants.textSizeLarge,
          ),
        ),
        if (item.subtitle != null) ...[
          SizedBox(height: TossSpacing.space1 / 2),
          Text(
            item.subtitle!,
            style: TossTextStyles.caption.copyWith(
              color: TossColors.gray600,
              fontSize: UIConstants.textSizeCompact,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildCheckIcon() {
    return const Icon(
      Icons.check,
      color: TossColors.primary,
      size: iconSize,
    );
  }
}
