import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../app/providers/app_state_provider.dart';
import '../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';
import '../../../../cash_location/presentation/providers/cash_location_providers.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

/// Bank account selector section for PI form
class PIBankAccountSection extends ConsumerWidget {
  final List<String> selectedBankAccountIds;
  final ValueChanged<List<String>> onSelectionChanged;

  const PIBankAccountSection({
    super.key,
    required this.selectedBankAccountIds,
    required this.onSelectionChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appState = ref.watch(appStateProvider);
    final companyId = appState.companyChoosen;

    if (companyId.isEmpty) {
      return const Text('No company selected');
    }

    final params = CashLocationQueryParams(
      companyId: companyId,
      locationType: 'bank',
    );

    final bankAccountsAsync = ref.watch(allCashLocationsProvider(params));

    return bankAccountsAsync.when(
      loading: () => const Padding(
        padding: EdgeInsets.all(TossSpacing.space4),
        child: TossLoadingView(),
      ),
      error: (error, _) => Text(
        'Failed to load bank accounts: $error',
        style: TextStyle(color: TossColors.error),
      ),
      data: (bankAccounts) {
        if (bankAccounts.isEmpty) {
          return Container(
            padding: const EdgeInsets.all(TossSpacing.space4),
            decoration: BoxDecoration(
              color: TossColors.gray50,
              borderRadius: BorderRadius.circular(TossBorderRadius.md),
            ),
            child: Text(
              'No bank accounts registered. Add bank accounts in Cash Location settings.',
              style: TossTextStyles.caption.copyWith(color: TossColors.gray600),
            ),
          );
        }

        final tossDropdownItems = bankAccounts.map((bank) {
          final primaryName = bank.locationName;
          final bankName = bank.bankName;
          final currencyCode = bank.currencyCode ?? '';

          String label = primaryName;
          if (currencyCode.isNotEmpty) {
            label = '$primaryName ($currencyCode)';
          }

          String? subtitle;
          if (bankName != null && bankName.isNotEmpty && bankName != primaryName) {
            subtitle = bankName;
          }

          return TossDropdownItem<String>(
            value: bank.locationId,
            label: label,
            subtitle: subtitle,
          );
        }).toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TossDropdown<String>(
              label: '',
              hint: 'Select bank account',
              value: selectedBankAccountIds.isNotEmpty
                  ? selectedBankAccountIds.first
                  : null,
              items: tossDropdownItems,
              onChanged: (value) {
                final newSelection = <String>[];
                if (value != null) {
                  newSelection.add(value);
                }
                onSelectionChanged(newSelection);
              },
            ),

            if (selectedBankAccountIds.isNotEmpty) ...[
              const SizedBox(height: TossSpacing.space3),
              Builder(
                builder: (context) {
                  final selectedBank = bankAccounts.firstWhere(
                    (b) => b.locationId == selectedBankAccountIds.first,
                    orElse: () => bankAccounts.first,
                  );
                  return _BankDetailCard(bank: selectedBank);
                },
              ),
            ],
          ],
        );
      },
    );
  }
}

/// Bank detail card widget
class _BankDetailCard extends StatelessWidget {
  final CashLocation bank;

  const _BankDetailCard({required this.bank});

  @override
  Widget build(BuildContext context) {
    final details = <MapEntry<String, String>>[];

    if (bank.bankName != null && bank.bankName!.isNotEmpty) {
      details.add(MapEntry('Bank Name', bank.bankName!));
    }
    if (bank.bankAccount != null && bank.bankAccount!.isNotEmpty) {
      details.add(MapEntry('Account No.', bank.bankAccount!));
    }
    if (bank.beneficiaryName != null && bank.beneficiaryName!.isNotEmpty) {
      details.add(MapEntry('Beneficiary', bank.beneficiaryName!));
    }
    if (bank.swiftCode != null && bank.swiftCode!.isNotEmpty) {
      details.add(MapEntry('SWIFT Code', bank.swiftCode!));
    }
    if (bank.bankBranch != null && bank.bankBranch!.isNotEmpty) {
      details.add(MapEntry('Branch', bank.bankBranch!));
    }
    if (bank.bankAddress != null && bank.bankAddress!.isNotEmpty) {
      details.add(MapEntry('Bank Address', bank.bankAddress!));
    }
    if (bank.currencyCode != null && bank.currencyCode!.isNotEmpty) {
      details.add(MapEntry('Currency', bank.currencyCode!));
    }
    if (bank.accountType != null && bank.accountType!.isNotEmpty) {
      details.add(MapEntry('Account Type', bank.accountType!));
    }

    if (details.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(TossSpacing.space3),
        decoration: BoxDecoration(
          color: TossColors.surface,
          borderRadius: BorderRadius.circular(TossBorderRadius.lg),
          border: Border.all(color: TossColors.border),
        ),
        child: Text(
          'No additional details available for this bank account.',
          style: TossTextStyles.label.copyWith(
            color: TossColors.textSecondary,
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(TossSpacing.space3),
      decoration: BoxDecoration(
        color: TossColors.surface,
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        border: Border.all(color: TossColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: details.asMap().entries.map((mapEntry) {
          final entry = mapEntry.value;
          final isLast = mapEntry.key == details.length - 1;
          return Padding(
            padding: EdgeInsets.only(bottom: isLast ? 0 : TossSpacing.space2),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 110,
                  child: Text(
                    entry.key,
                    style: TossTextStyles.label.copyWith(
                      color: TossColors.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    entry.value,
                    style: TossTextStyles.bodyLarge.copyWith(
                      color: TossColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
