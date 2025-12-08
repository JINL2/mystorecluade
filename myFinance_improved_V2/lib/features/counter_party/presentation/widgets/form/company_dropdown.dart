import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinance_improved/shared/themes/toss_border_radius.dart';
import 'package:myfinance_improved/shared/themes/toss_colors.dart';
import 'package:myfinance_improved/shared/themes/toss_spacing.dart';
import 'package:myfinance_improved/shared/themes/toss_text_styles.dart';
import '../../providers/counter_party_providers.dart';

/// Company dropdown selector for counter party form
///
/// Fetches and displays available companies from the backend.
/// Shows all companies, but marks already linked ones as disabled.
/// Already linked companies are sorted to the bottom.
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
        // Check if all companies are already linked
        final availableCompanies = companies.where(
          (c) => c['is_already_linked'] != true
        ).toList();

        // Empty state - no available companies
        if (availableCompanies.isEmpty && companies.isNotEmpty) {
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
                Expanded(
                  child: Text(
                    'All companies are already registered as counterparties',
                    style: TossTextStyles.caption.copyWith(color: TossColors.warning),
                  ),
                ),
              ],
            ),
          );
        }

        // No companies at all
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

        // Build custom dropdown with disabled items
        return _buildCustomDropdown(companies);
      },

      // Loading state
      loading: () => _buildLoadingState(),

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

  Widget _buildLoadingState() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Linked Company',
          style: TossTextStyles.caption.copyWith(
            color: TossColors.gray600,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: TossSpacing.space2),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: TossSpacing.space4,
            vertical: TossSpacing.space3,
          ),
          decoration: BoxDecoration(
            color: TossColors.gray50,
            borderRadius: BorderRadius.circular(TossBorderRadius.md),
            border: Border.all(color: TossColors.gray200),
          ),
          child: Row(
            children: [
              const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
              const SizedBox(width: TossSpacing.space2),
              Text(
                'Loading companies...',
                style: TossTextStyles.body.copyWith(color: TossColors.gray400),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCustomDropdown(List<Map<String, dynamic>> companies) {
    // Find currently selected company name
    String? selectedName;
    if (linkedCompanyId != null) {
      final selected = companies.firstWhere(
        (c) => c['company_id'] == linkedCompanyId,
        orElse: () => {},
      );
      if (selected.isNotEmpty) {
        selectedName = selected['company_name'] as String?;
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Linked Company',
          style: TossTextStyles.caption.copyWith(
            color: TossColors.gray600,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: TossSpacing.space2),
        Builder(
          builder: (context) {
            return GestureDetector(
              onTap: () => _showCompanyPicker(context, companies),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: TossSpacing.space4,
                  vertical: TossSpacing.space3,
                ),
                decoration: BoxDecoration(
                  color: TossColors.white,
                  borderRadius: BorderRadius.circular(TossBorderRadius.md),
                  border: Border.all(
                    color: linkedCompanyId != null
                        ? TossColors.primary
                        : TossColors.gray200,
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        selectedName ?? 'Select linked company',
                        style: TossTextStyles.body.copyWith(
                          color: selectedName != null
                              ? TossColors.gray900
                              : TossColors.gray400,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.keyboard_arrow_down,
                      color: TossColors.gray400,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  void _showCompanyPicker(BuildContext context, List<Map<String, dynamic>> companies) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.6,
        ),
        decoration: const BoxDecoration(
          color: TossColors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle
            Container(
              margin: const EdgeInsets.only(top: 12, bottom: 8),
              width: 48,
              height: 4,
              decoration: BoxDecoration(
                color: TossColors.gray300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            // Title
            Padding(
              padding: const EdgeInsets.all(TossSpacing.space4),
              child: Text(
                'Select Company',
                style: TossTextStyles.h3.copyWith(fontWeight: FontWeight.w600),
              ),
            ),
            const Divider(height: 1),
            // Company list
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: companies.length,
                itemBuilder: (context, index) {
                  final company = companies[index];
                  final companyId = company['company_id'] as String;
                  final companyName = (company['company_name'] as String?) ?? 'Unknown';
                  final isAlreadyLinked = company['is_already_linked'] == true;
                  final isSelected = companyId == linkedCompanyId;

                  return ListTile(
                    onTap: isAlreadyLinked
                        ? null // Disable tap for already linked companies
                        : () {
                            onChanged(companyId);
                            Navigator.pop(context);
                          },
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: isAlreadyLinked
                            ? TossColors.gray100
                            : (isSelected ? TossColors.primary.withValues(alpha: 0.1) : TossColors.gray50),
                        borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                      ),
                      child: Icon(
                        Icons.business,
                        color: isAlreadyLinked
                            ? TossColors.gray400
                            : (isSelected ? TossColors.primary : TossColors.gray600),
                        size: 20,
                      ),
                    ),
                    title: Text(
                      companyName,
                      style: TossTextStyles.body.copyWith(
                        color: isAlreadyLinked ? TossColors.gray400 : TossColors.gray900,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                      ),
                    ),
                    subtitle: isAlreadyLinked
                        ? Text(
                            'Already registered',
                            style: TossTextStyles.caption.copyWith(
                              color: TossColors.gray400,
                            ),
                          )
                        : null,
                    trailing: isSelected
                        ? const Icon(Icons.check, color: TossColors.primary)
                        : (isAlreadyLinked
                            ? Icon(Icons.block, color: TossColors.gray300, size: 18)
                            : null),
                    enabled: !isAlreadyLinked,
                  );
                },
              ),
            ),
            const SizedBox(height: TossSpacing.space4),
          ],
        ),
      ),
    );
  }
}
