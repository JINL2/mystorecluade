import 'package:flutter/material.dart';
import 'package:myfinance_improved/core/themes/toss_colors.dart';
import 'package:myfinance_improved/core/themes/toss_text_styles.dart';
import 'package:myfinance_improved/core/themes/toss_spacing.dart';
import 'package:myfinance_improved/core/themes/toss_shadows.dart';
import 'package:myfinance_improved/domain/entities/company.dart';
import 'package:myfinance_improved/domain/entities/store.dart';

class HomepageDrawer extends StatelessWidget {
  const HomepageDrawer({
    super.key,
    required this.companies,
    required this.selectedCompany,
    required this.selectedStore,
    required this.onCompanySelect,
    required this.onStoreSelect,
    required this.canAddStore,
  });

  final List<Company> companies;
  final Company? selectedCompany;
  final Store? selectedStore;
  final Function(Company) onCompanySelect;
  final Function(Store) onStoreSelect;
  final bool canAddStore;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: TossColors.background,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(TossSpacing.space5),
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: TossColors.gray200,
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: TossColors.primary.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.business,
                      color: TossColors.primary,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: TossSpacing.space3),
                  Text(
                    'Companies & Stores',
                    style: TossTextStyles.h3.copyWith(
                      color: TossColors.gray900,
                    ),
                  ),
                ],
              ),
            ),

            // Companies List
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(TossSpacing.space3),
                itemCount: companies.length,
                itemBuilder: (context, index) {
                  final company = companies[index];
                  final isSelected = selectedCompany?.id == company.id;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Company Item
                      Container(
                        margin: const EdgeInsets.only(bottom: TossSpacing.space2),
                        decoration: BoxDecoration(
                          color: isSelected ? TossColors.primary.withOpacity(0.05) : TossColors.background,
                          borderRadius: BorderRadius.circular(12),
                          border: isSelected 
                            ? Border.all(color: TossColors.primary.withOpacity(0.3), width: 1)
                            : Border.all(color: TossColors.gray200, width: 1),
                          boxShadow: isSelected ? TossShadows.shadow1 : null,
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: TossSpacing.space4,
                            vertical: TossSpacing.space2,
                          ),
                          leading: Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: isSelected ? TossColors.primary : TossColors.gray100,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.business,
                              color: isSelected ? TossColors.background : TossColors.gray600,
                              size: 18,
                            ),
                          ),
                          title: Text(
                            company.companyName,
                            style: TossTextStyles.body.copyWith(
                              color: isSelected ? TossColors.primary : TossColors.gray900,
                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                            ),
                          ),
                          subtitle: Text(
                            company.role.roleName,
                            style: TossTextStyles.caption.copyWith(
                              color: TossColors.gray600,
                            ),
                          ),
                          onTap: () => onCompanySelect(company),
                        ),
                      ),

                      // Stores for selected company
                      if (isSelected && company.stores.isNotEmpty) ...[
                        const SizedBox(height: TossSpacing.space2),
                        Padding(
                          padding: const EdgeInsets.only(left: TossSpacing.space4),
                          child: Text(
                            'Stores',
                            style: TossTextStyles.labelSmall.copyWith(
                              color: TossColors.gray600,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(height: TossSpacing.space2),
                        ...company.stores.map((store) {
                          final isStoreSelected = selectedStore?.id == store.id;
                          
                          return Container(
                            margin: const EdgeInsets.only(
                              left: TossSpacing.space4,
                              bottom: TossSpacing.space1,
                            ),
                            decoration: BoxDecoration(
                              color: isStoreSelected 
                                ? TossColors.primary.withOpacity(0.05) 
                                : TossColors.gray50,
                              borderRadius: BorderRadius.circular(8),
                              border: isStoreSelected 
                                ? Border.all(color: TossColors.primary.withOpacity(0.3), width: 1)
                                : Border.all(color: TossColors.gray200, width: 0.5),
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: TossSpacing.space3,
                                vertical: TossSpacing.space1,
                              ),
                              leading: Icon(
                                Icons.store,
                                color: isStoreSelected ? TossColors.primary : TossColors.gray500,
                                size: 16,
                              ),
                              title: Text(
                                store.storeName,
                                style: TossTextStyles.caption.copyWith(
                                  color: isStoreSelected ? TossColors.primary : TossColors.gray800,
                                  fontWeight: isStoreSelected ? FontWeight.w600 : FontWeight.w500,
                                ),
                              ),
                              onTap: () => onStoreSelect(store),
                            ),
                          );
                        }),
                        
                        // Add Store button for owners
                        if (canAddStore) ...[
                          const SizedBox(height: TossSpacing.space2),
                          Container(
                            margin: const EdgeInsets.only(left: TossSpacing.space4),
                            child: TextButton.icon(
                              onPressed: () {
                                // TODO: Navigate to add store page
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Add Store feature coming soon!'),
                                    backgroundColor: TossColors.info,
                                  ),
                                );
                              },
                              icon: const Icon(
                                Icons.add,
                                size: 14,
                                color: TossColors.primary,
                              ),
                              label: Text(
                                'Add Store',
                                style: TossTextStyles.caption.copyWith(
                                  color: TossColors.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: TossSpacing.space3,
                                  vertical: TossSpacing.space2,
                                ),
                                backgroundColor: TossColors.primary.withOpacity(0.05),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  side: BorderSide(
                                    color: TossColors.primary.withOpacity(0.2),
                                    width: 1,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ],
                      
                      const SizedBox(height: TossSpacing.space4),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}