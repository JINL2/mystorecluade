import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myfinance_improved/shared/models/selection_item.dart';
import 'package:myfinance_improved/shared/themes/index.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

import 'transfer_summary_widgets.dart';

/// Store Selection Section - Within Company (Step 1)
class WithinCompanyStoreSection extends StatelessWidget {
  final String fromCashLocationName;
  final String? fromCompanyName;
  final List<Map<String, dynamic>> otherStores;
  final String? selectedStoreId;
  final void Function(String storeId, String storeName) onStoreSelected;
  final VoidCallback onChangeFromPressed;

  const WithinCompanyStoreSection({
    super.key,
    required this.fromCashLocationName,
    this.fromCompanyName,
    required this.otherStores,
    required this.selectedStoreId,
    required this.onStoreSelected,
    required this.onChangeFromPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: TossSpacing.space3),

        // From summary
        FromSummaryCard(
          fromCashLocationName: fromCashLocationName,
          onChangePressed: onChangeFromPressed,
        ),

        // Arrow
        const Padding(
          padding: EdgeInsets.symmetric(vertical: TossSpacing.space2),
          child: Center(
            child: Icon(Icons.arrow_downward, color: TossColors.gray400, size: 20),
          ),
        ),

        Text(
          'To which store?',
          style: TossTextStyles.h4.copyWith(
            fontWeight: FontWeight.bold,
            color: TossColors.gray900,
          ),
        ),
        const SizedBox(height: TossSpacing.space1),
        Text(
          'Select destination store in ${fromCompanyName ?? 'the company'}',
          style: TossTextStyles.body.copyWith(
            color: TossColors.gray500,
          ),
        ),

        const SizedBox(height: TossSpacing.space4),

        if (otherStores.isEmpty)
          Center(
            child: Text(
              'No other stores available',
              style: TossTextStyles.body.copyWith(color: TossColors.gray500),
            ),
          )
        else
          ...otherStores.map((store) {
            final storeId = store['store_id'] as String? ?? '';
            final storeName = store['store_name'] as String? ?? 'Unknown Store';
            final isSelected = selectedStoreId == storeId;
            return SelectionListItem(
              item: SelectionItem(id: storeId, title: storeName, icon: Icons.store),
              isSelected: isSelected,
              onTap: () {
                HapticFeedback.lightImpact();
                onStoreSelected(storeId, storeName);
              },
            );
          }),

        const SizedBox(height: TossSpacing.space2),
        InfoCard.alertWarning(
          message: 'This transfer will create a debt entry between stores/companies.',
        ),
      ],
    );
  }
}

/// Company Selection Section - Between Companies (Step 1)
class BetweenCompaniesCompanySection extends StatelessWidget {
  final String fromCashLocationName;
  final List<Map<String, dynamic>> otherCompanies;
  final String? selectedCompanyId;
  final void Function(String companyId, String companyName) onCompanySelected;
  final VoidCallback onChangeFromPressed;

  const BetweenCompaniesCompanySection({
    super.key,
    required this.fromCashLocationName,
    required this.otherCompanies,
    required this.selectedCompanyId,
    required this.onCompanySelected,
    required this.onChangeFromPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: TossSpacing.space3),

        // From summary
        FromSummaryCard(
          fromCashLocationName: fromCashLocationName,
          onChangePressed: onChangeFromPressed,
        ),

        // Arrow
        const Padding(
          padding: EdgeInsets.symmetric(vertical: TossSpacing.space2),
          child: Center(
            child: Icon(Icons.arrow_downward, color: TossColors.gray400, size: 20),
          ),
        ),

        Text(
          'To which company?',
          style: TossTextStyles.h4.copyWith(
            fontWeight: FontWeight.bold,
            color: TossColors.gray900,
          ),
        ),
        const SizedBox(height: TossSpacing.space1),
        Text(
          'Select destination company',
          style: TossTextStyles.body.copyWith(
            color: TossColors.gray500,
          ),
        ),

        const SizedBox(height: TossSpacing.space4),

        if (otherCompanies.isEmpty)
          Center(
            child: Text(
              'No other companies available',
              style: TossTextStyles.body.copyWith(color: TossColors.gray500),
            ),
          )
        else
          ...otherCompanies.map((company) {
            final companyId = company['company_id'] as String? ?? '';
            final companyName = company['company_name'] as String? ?? 'Unknown Company';
            final stores = company['stores'] as List<dynamic>? ?? [];
            final isSelected = selectedCompanyId == companyId;
            return SelectionListItem(
              item: SelectionItem(
                id: companyId,
                title: companyName,
                subtitle: '${stores.length} store${stores.length > 1 ? 's' : ''}',
                icon: Icons.business,
              ),
              isSelected: isSelected,
              onTap: () {
                HapticFeedback.lightImpact();
                onCompanySelected(companyId, companyName);
              },
            );
          }),

        const SizedBox(height: TossSpacing.space2),
        InfoCard.alertWarning(
          message: 'This transfer will create a debt entry between stores/companies.',
        ),
      ],
    );
  }
}

/// Store Selection In Company Section - Between Companies (Step 2)
class BetweenCompaniesStoreSection extends StatelessWidget {
  final String fromCashLocationName;
  final String? toCompanyName;
  final List<Map<String, dynamic>> targetStores;
  final String? selectedStoreId;
  final void Function(String storeId, String storeName) onStoreSelected;
  final VoidCallback onChangeFromPressed;
  final VoidCallback onChangeCompanyPressed;

  const BetweenCompaniesStoreSection({
    super.key,
    required this.fromCashLocationName,
    this.toCompanyName,
    required this.targetStores,
    required this.selectedStoreId,
    required this.onStoreSelected,
    required this.onChangeFromPressed,
    required this.onChangeCompanyPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: TossSpacing.space3),

        // From summary
        FromSummaryCard(
          fromCashLocationName: fromCashLocationName,
          onChangePressed: onChangeFromPressed,
        ),

        // Arrow
        const Padding(
          padding: EdgeInsets.symmetric(vertical: TossSpacing.space2),
          child: Center(
            child: Icon(Icons.arrow_downward, color: TossColors.gray400, size: 20),
          ),
        ),

        // To company summary
        InfoCard.summary(
          icon: Icons.business,
          label: 'TO Company',
          value: toCompanyName ?? '',
          onEdit: onChangeCompanyPressed,
        ),

        const SizedBox(height: TossSpacing.space4),

        Text(
          'To which store?',
          style: TossTextStyles.h4.copyWith(
            fontWeight: FontWeight.bold,
            color: TossColors.gray900,
          ),
        ),
        const SizedBox(height: TossSpacing.space1),
        Text(
          'Select destination store in ${toCompanyName ?? 'the company'}',
          style: TossTextStyles.body.copyWith(
            color: TossColors.gray500,
          ),
        ),

        const SizedBox(height: TossSpacing.space4),

        if (targetStores.isEmpty)
          Center(
            child: Text(
              'No stores available in this company',
              style: TossTextStyles.body.copyWith(color: TossColors.gray500),
            ),
          )
        else
          ...targetStores.map((store) {
            final storeId = store['store_id'] as String? ?? '';
            final storeName = store['store_name'] as String? ?? 'Unknown Store';
            final isSelected = selectedStoreId == storeId;
            return SelectionListItem(
              item: SelectionItem(id: storeId, title: storeName, icon: Icons.store),
              isSelected: isSelected,
              onTap: () {
                HapticFeedback.lightImpact();
                onStoreSelected(storeId, storeName);
              },
            );
          }),
      ],
    );
  }
}
