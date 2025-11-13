import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinance_improved/shared/themes/toss_border_radius.dart';
import 'package:myfinance_improved/shared/themes/toss_colors.dart';
import 'package:myfinance_improved/shared/themes/toss_spacing.dart';
import 'package:myfinance_improved/shared/themes/toss_text_styles.dart';
import 'package:myfinance_improved/shared/widgets/toss/toss_dropdown.dart';
import '../../providers/counter_party_providers.dart';

/// Company dropdown selector for counter party form
///
/// Fetches and displays available companies from the backend.
/// Handles loading, error, and empty states automatically.
class CompanyDropdown extends ConsumerWidget {
  final String? linkedCompanyId;
  final ValueChanged<String?> onChanged;

  const CompanyDropdown({
    super.key,
    required this.linkedCompanyId,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final companiesAsync = ref.watch(unlinkedCompaniesProvider);

    return companiesAsync.when(
      data: (companies) {
        // Empty state
        if (companies.isEmpty) {
          return Container(
            padding: const EdgeInsets.all(TossSpacing.space3),
            decoration: BoxDecoration(
              color: TossColors.warning.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(TossBorderRadius.md),
            ),
            child: Row(
              children: [
                const Icon(Icons.info_outline, size: 16, color: TossColors.warning),
                const SizedBox(width: TossSpacing.space2),
                Text(
                  'No companies available',
                  style: TossTextStyles.caption.copyWith(color: TossColors.warning),
                ),
              ],
            ),
          );
        }

        // Convert companies to TossDropdownItems
        final dropdownItems = companies.map((company) {
          return TossDropdownItem<String>(
            value: company['company_id'] as String,
            label: (company['company_name'] as String?) ?? 'Unknown Company',
          );
        }).toList();

        return TossDropdown<String>(
          label: 'Linked Company',
          value: linkedCompanyId,
          items: dropdownItems,
          hint: 'Select linked company',
          onChanged: onChanged,
        );
      },

      // Loading state
      loading: () => const TossDropdown<String>(
        label: 'Linked Company',
        value: null,
        items: [],
        hint: 'Loading companies...',
        isLoading: true,
        onChanged: null,
      ),

      // Error state
      error: (_, __) => Container(
        padding: const EdgeInsets.all(TossSpacing.space3),
        decoration: BoxDecoration(
          color: TossColors.error.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(TossBorderRadius.md),
        ),
        child: Row(
          children: [
            const Icon(Icons.error_outline, size: 16, color: TossColors.error),
            const SizedBox(width: TossSpacing.space2),
            Text(
              'Error loading companies',
              style: TossTextStyles.caption.copyWith(color: TossColors.error),
            ),
          ],
        ),
      ),
    );
  }
}
