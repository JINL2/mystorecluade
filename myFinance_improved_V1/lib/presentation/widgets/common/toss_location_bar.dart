import 'package:flutter/material.dart';
import '../../../core/themes/toss_colors.dart';
import '../../../core/themes/toss_text_styles.dart';
import '../../../core/themes/toss_spacing.dart';

/// Toss-style location bar for displaying company/store context
class TossLocationBar extends StatelessWidget {
  final String companyName;
  final String? storeName;
  final Color? backgroundColor;
  final Color? textColor;
  final IconData? icon;
  
  const TossLocationBar({
    super.key,
    required this.companyName,
    this.storeName,
    this.backgroundColor,
    this.textColor,
    this.icon,
  });
  
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: TossSpacing.space4,
        vertical: TossSpacing.space2,
      ),
      decoration: BoxDecoration(
        color: backgroundColor ?? const Color(0xFFEFF6FF),
        border: Border(
          bottom: BorderSide(
            color: TossColors.borderLight,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: TossSpacing.iconSM,
              color: textColor ?? const Color(0xFF1E40AF),
            ),
            SizedBox(width: TossSpacing.space2),
          ],
          Expanded(
            child: Text(
              storeName != null 
                ? '$companyName > $storeName'
                : companyName,
              style: TossTextStyles.caption.copyWith(
                color: textColor ?? const Color(0xFF1E40AF),
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}