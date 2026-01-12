import 'package:flutter/material.dart';
import 'package:myfinance_improved/shared/themes/index.dart';

import '../../domain/entities/sales_analytics.dart';

/// Drill-down Breadcrumb Widget
/// Horizontal scrollable breadcrumb for navigation
class DrillDownBreadcrumb extends StatelessWidget {
  final List<BreadcrumbItem> items;
  final void Function(int) onTap;

  const DrillDownBreadcrumb({
    super.key,
    required this.items,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: items.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          final isLast = index == items.length - 1;

          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: isLast ? null : () => onTap(index),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: TossSpacing.space3,
                    vertical: TossSpacing.space1 + 2,
                  ),
                  decoration: BoxDecoration(
                    color: isLast ? TossColors.primary : TossColors.gray100,
                    borderRadius: BorderRadius.circular(TossBorderRadius.dialog),
                  ),
                  child: Text(
                    item.name,
                    style: TossTextStyles.caption.copyWith(
                      color: isLast ? TossColors.white : TossColors.gray700,
                      fontWeight: isLast ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                ),
              ),
              if (!isLast)
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: TossSpacing.space1),
                  child: Icon(
                    Icons.chevron_right,
                    size: 16,
                    color: TossColors.gray400,
                  ),
                ),
            ],
          );
        }).toList(),
      ),
    );
  }
}
