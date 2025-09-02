import 'package:flutter/material.dart';
import '../../../../core/themes/toss_colors.dart';
import '../../../../core/themes/toss_text_styles.dart';

class ProductSearchBar extends StatelessWidget {
  final Function(String) onChanged;
  final VoidCallback onBarcodePressed;

  const ProductSearchBar({
    super.key,
    required this.onChanged,
    required this.onBarcodePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: TossColors.gray50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const SizedBox(width: 16),
          Icon(
            Icons.search,
            color: TossColors.gray400,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              onChanged: onChanged,
              style: TossTextStyles.body,
              decoration: InputDecoration(
                hintText: 'Name, code, product code, ...',
                hintStyle: TossTextStyles.body.copyWith(
                  color: TossColors.gray400,
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          IconButton(
            onPressed: onBarcodePressed,
            icon: Icon(
              Icons.qr_code_scanner,
              color: TossColors.gray600,
              size: 24,
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: () {
              // Add product action
            },
            icon: Icon(
              Icons.add,
              color: TossColors.gray600,
              size: 24,
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
    );
  }
}