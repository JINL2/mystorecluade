// lib/features/transaction_history/presentation/widgets/filter_sheet/filter_options_section.dart
//
// Filter options section extracted from transaction_filter_sheet.dart
// Following Clean Architecture 2025 - Single Responsibility Principle

import 'package:flutter/material.dart';

import '../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';
import '../../../domain/entities/transaction_filter.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

/// Filter options section for transaction type and created by
class FilterOptionsSection extends StatelessWidget {
  final AsyncSnapshot<FilterOptions> optionsSnapshot;
  final String? selectedJournalType;
  final String? selectedCreatedBy;
  final ValueChanged<String?> onJournalTypeChanged;
  final ValueChanged<String?> onCreatedByChanged;

  const FilterOptionsSection({
    super.key,
    required this.optionsSnapshot,
    this.selectedJournalType,
    this.selectedCreatedBy,
    required this.onJournalTypeChanged,
    required this.onCreatedByChanged,
  });

  @override
  Widget build(BuildContext context) {
    if (optionsSnapshot.connectionState == ConnectionState.waiting) {
      return const Column(
        children: [
          SizedBox(height: TossSpacing.space6),
          Center(child: TossLoadingView()),
          SizedBox(height: TossSpacing.space6),
        ],
      );
    }

    if (optionsSnapshot.hasError) {
      return Column(
        children: [
          Container(
            padding: const EdgeInsets.all(TossSpacing.space4),
            decoration: BoxDecoration(
              color: TossColors.error.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(TossBorderRadius.md),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.error_outline,
                  color: TossColors.error,
                  size: TossSpacing.iconSM,
                ),
                const SizedBox(width: TossSpacing.space2),
                Expanded(
                  child: Text(
                    'Failed to load filter options',
                    style: TossTextStyles.caption.copyWith(
                      color: TossColors.error,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: TossSpacing.space4),
        ],
      );
    }

    final options = optionsSnapshot.data;
    if (options == null) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        // Transaction Type
        TossDropdown<String?>(
          label: 'Transaction Type',
          value: selectedJournalType,
          hint: 'All Types',
          items: [
            const TossDropdownItem(
              value: null,
              label: 'All Types',
            ),
            ...options.journalTypes.map(
              (type) => TossDropdownItem(
                value: type.id,
                label: type.name,
                subtitle: '${type.transactionCount} transactions',
              ),
            ),
          ],
          onChanged: onJournalTypeChanged,
        ),
        const SizedBox(height: TossSpacing.space4),

        // Created By
        TossDropdown<String?>(
          label: 'Created By',
          value: selectedCreatedBy,
          hint: 'All Users',
          items: [
            const TossDropdownItem(
              value: null,
              label: 'All Users',
            ),
            ...options.users.map(
              (user) => TossDropdownItem(
                value: user.id,
                label: user.name,
                subtitle: '${user.transactionCount} transactions',
              ),
            ),
          ],
          onChanged: onCreatedByChanged,
        ),
        const SizedBox(height: TossSpacing.space4),
      ],
    );
  }
}
