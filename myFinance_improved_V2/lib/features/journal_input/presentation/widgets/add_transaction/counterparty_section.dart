import 'package:flutter/material.dart';

import 'package:myfinance_improved/core/domain/entities/selector_entities.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import 'account_mapping_status.dart';
import 'counterparty_store_picker.dart';

/// Counterparty selection section for payable/receivable transactions
///
/// Contains counterparty selector, store picker (for internal counterparties),
/// counterparty cash location selector, and account mapping status.
class CounterpartySection extends StatelessWidget {
  final String? categoryTag;
  final String? selectedCounterpartyId;
  final String? selectedCounterpartyName;
  final String? selectedCounterpartyStoreId;
  final String? selectedCounterpartyStoreName;
  final String? linkedCompanyId;
  final String? selectedCounterpartyCashLocationId;
  final bool isInternal;
  final Map<String, dynamic>? accountMapping;
  final String? mappingError;
  final Set<String>? blockedCashLocationIds;
  final Function(CounterpartyData) onCounterpartySelected;
  final Function(String?) onCounterpartyIdChanged;
  final Function(String?, String?) onStoreSelected;
  final Function(CashLocationData) onCounterpartyCashLocationSelected;
  final Function(String?) onCounterpartyCashLocationChanged;

  const CounterpartySection({
    super.key,
    required this.categoryTag,
    required this.selectedCounterpartyId,
    required this.selectedCounterpartyName,
    required this.selectedCounterpartyStoreId,
    required this.selectedCounterpartyStoreName,
    required this.linkedCompanyId,
    required this.selectedCounterpartyCashLocationId,
    required this.isInternal,
    required this.accountMapping,
    required this.mappingError,
    required this.blockedCashLocationIds,
    required this.onCounterpartySelected,
    required this.onCounterpartyIdChanged,
    required this.onStoreSelected,
    required this.onCounterpartyCashLocationSelected,
    required this.onCounterpartyCashLocationChanged,
  });

  String _getCounterpartyLabel() {
    if (categoryTag == 'payable') {
      return 'Counterparty (Supplier/Vendor)';
    } else if (categoryTag == 'receivable') {
      return 'Counterparty (Customer)';
    }
    return 'Counterparty';
  }

  String _getCounterpartyHint() {
    if (categoryTag == 'payable') {
      return 'Select Supplier/Vendor';
    } else if (categoryTag == 'receivable') {
      return 'Select Customer';
    }
    return 'Select Counterparty';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Counterparty Selector
        CounterpartySelector(
          selectedCounterpartyId: selectedCounterpartyId,
          label: _getCounterpartyLabel(),
          hint: _getCounterpartyHint(),
          onCounterpartySelected: onCounterpartySelected,
          onChanged: onCounterpartyIdChanged,
        ),

        // Store Picker (for internal counterparties with linked company)
        if (linkedCompanyId != null) ...[
          const SizedBox(height: TossSpacing.space5),
          CounterpartyStorePicker(
            linkedCompanyId: linkedCompanyId,
            selectedStoreId: selectedCounterpartyStoreId,
            selectedStoreName: selectedCounterpartyStoreName,
            onStoreSelected: onStoreSelected,
          ),
        ],

        // Counterparty Cash Location Selector
        if (linkedCompanyId != null) ...[
          const SizedBox(height: TossSpacing.space5),
          CashLocationSelector(
            companyId: linkedCompanyId,
            storeId: selectedCounterpartyStoreId,
            selectedLocationId: selectedCounterpartyCashLocationId,
            label: 'Counterparty Cash Location',
            hint: 'Select counterparty cash location',
            showScopeTabs: false,
            storeOnly: true,
            blockedLocationIds: blockedCashLocationIds,
            onCashLocationSelected: onCounterpartyCashLocationSelected,
            onChanged: onCounterpartyCashLocationChanged,
          ),
        ],

        // Account Mapping Status
        AccountMappingStatus(
          isInternal: isInternal,
          accountMapping: accountMapping,
          mappingError: mappingError,
        ),
      ],
    );
  }
}
