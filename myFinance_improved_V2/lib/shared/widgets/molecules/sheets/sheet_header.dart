import 'package:flutter/material.dart';
import 'package:myfinance_improved/shared/themes/index.dart';
import 'package:myfinance_improved/shared/widgets/atoms/sheets/drag_handle.dart';

/// Bottom sheet header with drag handle and title
class SheetHeader extends StatelessWidget {
  final String title;
  final TextStyle? titleStyle;
  final VoidCallback? onClose;
  final bool showCloseButton;

  const SheetHeader({
    super.key,
    required this.title,
    this.titleStyle,
    this.onClose,
    this.showCloseButton = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: TossSpacing.space3),
        const DragHandle(),
        Padding(
          padding: const EdgeInsets.all(TossSpacing.space5),
          child: Row(
            children: [
              if (showCloseButton) const SizedBox(width: 40),
              Expanded(
                child: Text(
                  title,
                  style: titleStyle ??
                      TossTextStyles.h3.copyWith(
                        color: TossColors.gray900,
                        fontWeight: FontWeight.w700,
                      ),
                  textAlign: TextAlign.center,
                ),
              ),
              if (showCloseButton)
                IconButton(
                  onPressed: onClose ?? () => Navigator.pop(context),
                  icon: const Icon(Icons.close, size: 24),
                )
              else
                const SizedBox.shrink(),
            ],
          ),
        ),
      ],
    );
  }
}
