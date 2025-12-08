import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:myfinance_improved/shared/themes/toss_border_radius.dart';
import 'package:myfinance_improved/shared/themes/toss_colors.dart';
import 'package:myfinance_improved/shared/themes/toss_spacing.dart';
import 'package:myfinance_improved/shared/themes/toss_text_styles.dart';

import '../providers/employee_providers.dart';

/// Bottom sheet for sorting employees
class EmployeeSortSheet extends ConsumerWidget {
  const EmployeeSortSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentSort = ref.watch(employeeSortOptionProvider);
    final isAscending = ref.watch(employeeSortDirectionProvider);

    // Dynamic labels based on current direction
    final sortOptions = [
      {
        'value': 'name',
        'label': isAscending ? 'Name (A-Z)' : 'Name (Z-A)',
        'icon': Icons.sort_by_alpha,
        'directionIcon': isAscending ? Icons.arrow_upward : Icons.arrow_downward,
      },
      {
        'value': 'salary',
        'label': isAscending ? 'Salary (Low to High)' : 'Salary (High to Low)',
        'icon': Icons.attach_money,
        'directionIcon': isAscending ? Icons.arrow_upward : Icons.arrow_downward,
      },
      {
        'value': 'role',
        'label': isAscending ? 'Role (A-Z)' : 'Role (Z-A)',
        'icon': Icons.badge_outlined,
        'directionIcon': isAscending ? Icons.arrow_upward : Icons.arrow_downward,
      },
      {
        'value': 'recent',
        'label': isAscending ? 'Oldest First' : 'Recently Added',
        'icon': Icons.access_time,
        'directionIcon': isAscending ? Icons.arrow_upward : Icons.arrow_downward,
      },
    ];

    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).padding.bottom,
      ),
      decoration: const BoxDecoration(
        color: TossColors.surface,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(TossBorderRadius.xl),
          topRight: Radius.circular(TossBorderRadius.xl),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            width: 48,
            height: 4,
            margin: const EdgeInsets.only(top: TossSpacing.space3),
            decoration: BoxDecoration(
              color: TossColors.gray300,
              borderRadius: BorderRadius.circular(TossBorderRadius.xs),
            ),
          ),

          // Title
          Container(
            padding: const EdgeInsets.all(TossSpacing.space4),
            child: Text(
              'Sort by',
              style: TossTextStyles.h3.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),

          // Sort Options
          ...sortOptions.map((option) {
            final isSelected = option['value'] == currentSort;
            return Material(
              color: TossColors.transparent,
              child: InkWell(
                onTap: () {
                  HapticFeedback.selectionClick();

                  // If clicking the same sort option, toggle direction
                  if (option['value'] == currentSort) {
                    ref.read(employeeSortDirectionProvider.notifier).state = !isAscending;
                  } else {
                    // Set new sort option with default direction
                    ref.read(employeeSortOptionProvider.notifier).state = (option['value']! as String);
                    // Reset to default direction for each sort type
                    if (option['value'] == 'name' || option['value'] == 'role') {
                      ref.read(employeeSortDirectionProvider.notifier).state = true; // A-Z by default
                    } else {
                      ref.read(employeeSortDirectionProvider.notifier).state =
                          false; // High-to-Low/Recent first by default
                    }
                  }

                  Navigator.pop(context);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: TossSpacing.space4,
                    vertical: TossSpacing.space3,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        option['icon']! as IconData,
                        size: 20,
                        color: isSelected ? TossColors.primary : TossColors.gray600,
                      ),
                      const SizedBox(width: TossSpacing.space3),
                      Expanded(
                        child: Text(
                          option['label']! as String,
                          style: TossTextStyles.body.copyWith(
                            color: isSelected ? TossColors.primary : TossColors.gray900,
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                          ),
                        ),
                      ),
                      // Show direction indicator for selected item
                      if (isSelected) ...[
                        Icon(
                          option['directionIcon']! as IconData,
                          size: 16,
                          color: TossColors.primary,
                        ),
                        const SizedBox(width: TossSpacing.space2),
                        const Icon(
                          Icons.check_rounded,
                          color: TossColors.primary,
                          size: 20,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            );
          }),

          const SizedBox(height: TossSpacing.space4),
        ],
      ),
    );
  }
}
