import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../app/providers/app_state_provider.dart';
import '../../../../cash_location/domain/entities/cash_location.dart';
import '../../../../cash_location/domain/value_objects/cash_location_query_params.dart';
import '../../../../cash_location/presentation/providers/cash_location_providers.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

/// Advising Bank section for LC form (cash_location selection)
/// This is for our own bank - selected from cash_location
class LCAdvisingBankSection extends ConsumerWidget {
  final String? advisingBankId;
  final ValueChanged<(String?, Map<String, dynamic>?)> onBankChanged;

  const LCAdvisingBankSection({
    super.key,
    required this.advisingBankId,
    required this.onBankChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appState = ref.watch(appStateProvider);
    final params = CashLocationQueryParams(
      companyId: appState.companyChoosen,
      locationType: 'bank',
    );
    final banksAsync = ref.watch(allCashLocationsProvider(params));

    return banksAsync.when(
      loading: () => TossDropdown<String>(
        label: 'Select Bank Account *',
        items: const [],
        isLoading: true,
      ),
      error: (e, _) => TossDropdown<String>(
        label: 'Select Bank Account *',
        items: const [],
        errorText: 'Failed to load banks',
      ),
      data: (banks) {
        if (banks.isEmpty) {
          return TossDropdown<String>(
            label: 'Select Bank Account *',
            items: const [],
            hint: 'No bank accounts registered',
          );
        }

        return TossDropdown<String>(
          label: 'Select Bank Account *',
          value: advisingBankId,
          hint: 'Select bank',
          items: banks
              .map((b) => TossDropdownItem<String>(
                    value: b.locationId,
                    label: b.locationName,
                    subtitle: b.swiftCode ?? b.bankName,
                  ))
              .toList(),
          onChanged: (v) {
            if (v == null) {
              onBankChanged((null, null));
            } else {
              final bank = banks.firstWhere((b) => b.locationId == v);
              onBankChanged((v, _cashLocationToBankInfo(bank)));
            }
          },
        );
      },
    );
  }

  /// Convert CashLocation to bank_info JSONB format for LC
  Map<String, dynamic>? _cashLocationToBankInfo(CashLocation? bank) {
    if (bank == null) return null;
    return {
      'name': bank.bankName ?? bank.locationName,
      if (bank.swiftCode != null) 'swift': bank.swiftCode,
      if (bank.bankAddress != null) 'address': bank.bankAddress,
      if (bank.bankAccount != null) 'account': bank.bankAccount,
      if (bank.beneficiaryName != null) 'beneficiary': bank.beneficiaryName,
      if (bank.bankBranch != null) 'branch': bank.bankBranch,
    };
  }
}
