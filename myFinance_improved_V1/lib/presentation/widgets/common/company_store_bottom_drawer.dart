import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/themes/toss_colors.dart';
import '../../../core/themes/toss_spacing.dart';
import '../../../core/themes/toss_border_radius.dart';
import '../../../core/themes/toss_animations.dart';
import '../../../core/themes/toss_text_styles.dart';
import '../../../core/themes/toss_shadows.dart';
import '../../providers/app_state_provider.dart';

/// Company & Store selector that slides up from bottom
class CompanyStoreBottomDrawer extends ConsumerStatefulWidget {
  final VoidCallback? onSelectionChanged;
  
  const CompanyStoreBottomDrawer({
    super.key,
    this.onSelectionChanged,
  });
  
  static Future<void> show({
    required BuildContext context,
    VoidCallback? onSelectionChanged,
  }) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: TossColors.overlay,
      isScrollControlled: true,
      enableDrag: true,
      isDismissible: true,
      builder: (context) => CompanyStoreBottomDrawer(
        onSelectionChanged: onSelectionChanged,
      ),
    );
  }
  
  @override
  ConsumerState<CompanyStoreBottomDrawer> createState() => _CompanyStoreBottomDrawerState();
}

class _CompanyStoreBottomDrawerState extends ConsumerState<CompanyStoreBottomDrawer> {
  final Map<String, bool> _expandedCompanies = {};
  
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final userData = ref.watch(appStateProvider).userData;
    final selectedCompany = ref.watch(appStateProvider.notifier).selectedCompany;
    final companies = userData['companies'] as List<dynamic>? ?? [];
    
    return AnimatedContainer(
      duration: TossAnimations.medium,
      curve: TossAnimations.enter,
      constraints: BoxConstraints(
        maxHeight: screenHeight * 0.85,
        minHeight: 300,
      ),
      decoration: BoxDecoration(
        color: TossColors.surface,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(TossBorderRadius.xxl),
          topRight: Radius.circular(TossBorderRadius.xxl),
        ),
        boxShadow: TossShadows.bottomSheet,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHeader(context),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space4),
              children: [
                ...companies.map((company) => _buildCompanyCard(
                  context, 
                  company, 
                  company['company_id'] == selectedCompany?['company_id'],
                )),
                const SizedBox(height: 100),
              ],
            ),
          ),
          _buildCreateButton(context),
        ],
      ),
    );
  }
  
  Widget _buildHeader(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: TossSpacing.space3),
        Container(
          width: 40,
          height: 4,
          decoration: BoxDecoration(
            color: TossColors.gray300,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(height: TossSpacing.space5),
        Row(
          children: [
            const SizedBox(width: TossSpacing.space5),
            Text(
              'Companies & Stores',
              style: TossTextStyles.h3.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const Spacer(),
            IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(
                Icons.close,
                color: TossColors.gray600,
              ),
            ),
          ],
        ),
        const Divider(
          color: TossColors.gray200,
          height: 1,
        ),
      ],
    );
  }
  
  Widget _buildCompanyCard(BuildContext context, dynamic company, bool isSelected) {
    final selectedStore = ref.watch(appStateProvider.notifier).selectedStore;
    final isExpanded = _expandedCompanies[company['company_id']] ?? isSelected;
    final stores = company['stores'] as List<dynamic>? ?? [];
    
    return Container(
      margin: const EdgeInsets.only(bottom: TossSpacing.space3),
      decoration: BoxDecoration(
        color: TossColors.surface,
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        border: Border.all(
          color: isSelected 
            ? TossColors.primary.withValues(alpha: 0.3) 
            : TossColors.border,
          width: 1,
        ),
        boxShadow: TossShadows.card,
      ),
      child: Column(
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () async {
                setState(() {
                  _expandedCompanies[company['company_id']] = !isExpanded;
                });
                
                await ref.read(appStateProvider.notifier).setCompanyChoosen(company['company_id']);
                await ref.read(appStateProvider.notifier).setStoreChoosen('');
                
                widget.onSelectionChanged?.call();
              },
              borderRadius: BorderRadius.circular(TossBorderRadius.lg),
              child: Padding(
                padding: const EdgeInsets.all(TossSpacing.space4),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: TossColors.primarySurface,
                        borderRadius: BorderRadius.circular(TossBorderRadius.md),
                      ),
                      child: const Icon(
                        Icons.business,
                        color: TossColors.primary,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: TossSpacing.space4),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            company['company_name'] ?? '',
                            style: TossTextStyles.body.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            '${stores.length} stores • Employee',
                            style: TossTextStyles.bodySmall.copyWith(
                              color: TossColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      isExpanded ? Icons.expand_less : Icons.expand_more,
                      color: TossColors.gray600,
                      size: 24,
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          if (isExpanded) ...[
            const Divider(
              color: TossColors.gray200,
              height: 1,
            ),
            Padding(
              padding: const EdgeInsets.all(TossSpacing.space3),
              child: Column(
                children: [
                  ...stores.map((store) => _buildStoreItem(
                    context, 
                    store, 
                    store['store_id'] == selectedStore?['store_id'],
                    company,
                  )),
                  _buildAddStoreItem(context, company),
                  _buildViewCodesItem(context, company),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
  
  Widget _buildStoreItem(BuildContext context, dynamic store, bool isSelected, dynamic company) {
    return Container(
      margin: const EdgeInsets.only(bottom: TossSpacing.space2),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () async {
            await ref.read(appStateProvider.notifier).setCompanyChoosen(company['company_id']);
            await ref.read(appStateProvider.notifier).setStoreChoosen(store['store_id']);
            
            widget.onSelectionChanged?.call();
            
            if (context.mounted) {
              Navigator.pop(context);
            }
          },
          borderRadius: BorderRadius.circular(TossBorderRadius.md),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: TossSpacing.space3,
              vertical: TossSpacing.space2,
            ),
            decoration: BoxDecoration(
              color: isSelected 
                ? TossColors.primarySurface
                : Colors.transparent,
              borderRadius: BorderRadius.circular(TossBorderRadius.md),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.store_outlined,
                  color: TossColors.gray600,
                  size: 20,
                ),
                const SizedBox(width: TossSpacing.space3),
                Expanded(
                  child: Text(
                    store['store_name'] ?? '',
                    style: TossTextStyles.body.copyWith(
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    ),
                  ),
                ),
                if (isSelected)
                  const Icon(
                    Icons.check,
                    color: TossColors.primary,
                    size: 18,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildAddStoreItem(BuildContext context, dynamic company) {
    return Container(
      margin: const EdgeInsets.only(bottom: TossSpacing.space2),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            // TODO: Implement add store functionality
          },
          borderRadius: BorderRadius.circular(TossBorderRadius.md),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: TossSpacing.space3,
              vertical: TossSpacing.space2,
            ),
            decoration: BoxDecoration(
              color: TossColors.primarySurface,
              borderRadius: BorderRadius.circular(TossBorderRadius.md),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.add,
                  color: TossColors.primary,
                  size: 20,
                ),
                const SizedBox(width: TossSpacing.space3),
                Text(
                  'Add store',
                  style: TossTextStyles.body.copyWith(
                    color: TossColors.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildViewCodesItem(BuildContext context, dynamic company) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          // TODO: Implement view codes functionality
        },
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: TossSpacing.space3,
            vertical: TossSpacing.space2,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(TossBorderRadius.md),
            border: Border.all(
              color: TossColors.border,
            ),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.qr_code_2,
                color: TossColors.gray600,
                size: 20,
              ),
              const SizedBox(width: TossSpacing.space3),
              Text(
                'View codes',
                style: TossTextStyles.body.copyWith(
                  color: TossColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              const Icon(
                Icons.chevron_right,
                color: TossColors.gray600,
                size: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildCreateButton(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        TossSpacing.space5,
        TossSpacing.space4,
        TossSpacing.space5,
        TossSpacing.space4 + MediaQuery.of(context).padding.bottom,
      ),
      decoration: const BoxDecoration(
        color: TossColors.surface,
        border: Border(
          top: BorderSide(
            color: TossColors.gray200,
            width: 1,
          ),
        ),
      ),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: () {
            // TODO: Implement create company functionality
            Navigator.pop(context);
          },
          icon: const Icon(Icons.add),
          label: const Text('Create Company'),
          style: ElevatedButton.styleFrom(
            backgroundColor: TossColors.primary,
            foregroundColor: TossColors.white,
            padding: const EdgeInsets.symmetric(vertical: TossSpacing.space4),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(TossBorderRadius.button),
            ),
          ),
        ),
      ),
    );
  }
}