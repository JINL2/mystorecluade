/// Entry Card - Individual template entry editor
///
/// Purpose: Displays and allows editing of a single template entry
/// - Shows debit/credit type badge
/// - Entry note field
/// - Conditional cash location selector
/// - Conditional counterparty selectors
///
/// Clean Architecture: PRESENTATION LAYER - Widget
library;

import 'package:myfinance_improved/shared/widgets/index.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinance_improved/shared/themes/index.dart';

import 'entry_edit_state.dart';
import 'counterparty_section.dart';

/// Individual entry card for editing
class EntryCard extends ConsumerWidget {
  final int index;
  final Map<String, dynamic> entry;
  final EntryEditState entryState;
  final String storeId;
  final VoidCallback onStateChanged;
  final Future<void> Function(int, EntryEditState) onCheckAccountMapping;
  final void Function(String, String) onNavigateToAccountSettings;

  const EntryCard({
    super.key,
    required this.index,
    required this.entry,
    required this.entryState,
    required this.storeId,
    required this.onStateChanged,
    required this.onCheckAccountMapping,
    required this.onNavigateToAccountSettings,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final type = entry['type']?.toString() ?? '';
    final categoryTag = entry['category_tag']?.toString().toLowerCase() ?? '';
    final accountName = entry['account_name']?.toString() ?? 'Unknown';

    final showCashLocationSelector = categoryTag == 'cash' || categoryTag == 'bank';
    final showCounterpartySelector = categoryTag == 'payable' || categoryTag == 'receivable';

    return Container(
      margin: const EdgeInsets.only(bottom: TossSpacing.space3),
      padding: const EdgeInsets.all(TossSpacing.space3),
      decoration: BoxDecoration(
        border: Border.all(color: TossColors.gray300),
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Entry header (non-editable)
          _EntryHeader(type: type, accountName: accountName),

          const SizedBox(height: TossSpacing.space3),

          // Entry description (editable)
          TossTextField(
            controller: entryState.descriptionController,
            label: 'Entry Note',
            hintText: 'Add a note for this entry (optional)',
          ),

          // Cash location selector (conditional)
          if (showCashLocationSelector) ...[
            const SizedBox(height: TossSpacing.space3),
            AutonomousCashLocationSelector(
              storeId: storeId,
              selectedLocationId: entryState.cashLocationId,
              onChanged: (cashLocationId) {
                entryState.cashLocationId = cashLocationId;
                onStateChanged();
              },
            ),
          ],

          // Counterparty section (conditional)
          if (showCounterpartySelector) ...[
            const SizedBox(height: TossSpacing.space3),
            CounterpartySection(
              index: index,
              entryState: entryState,
              onStateChanged: onStateChanged,
              onCheckAccountMapping: onCheckAccountMapping,
              onNavigateToAccountSettings: onNavigateToAccountSettings,
            ),
          ],
        ],
      ),
    );
  }
}

/// Entry header showing type badge and account name
class _EntryHeader extends StatelessWidget {
  final String type;
  final String accountName;

  const _EntryHeader({
    required this.type,
    required this.accountName,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: TossSpacing.space2,
            vertical: TossSpacing.space1,
          ),
          decoration: BoxDecoration(
            color: type == 'debit'
                ? TossColors.primary.withValues(alpha: 0.1)
                : TossColors.success.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(TossBorderRadius.sm),
          ),
          child: Text(
            type.toUpperCase(),
            style: TossTextStyles.caption.copyWith(
              color: type == 'debit' ? TossColors.primary : TossColors.success,
              fontWeight: TossFontWeight.bold,
            ),
          ),
        ),
        const SizedBox(width: TossSpacing.space2),
        Expanded(
          child: Text(
            accountName,
            style: TossTextStyles.body.copyWith(
              fontWeight: TossFontWeight.semibold,
              color: TossColors.gray900,
            ),
          ),
        ),
      ],
    );
  }
}
