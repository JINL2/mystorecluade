import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/themes/toss_colors.dart';
import '../../../../core/themes/toss_text_styles.dart';
import '../../../../core/themes/toss_spacing.dart';
import '../../../../core/themes/toss_border_radius.dart';
import '../../../providers/app_state_provider.dart';
import '../../../providers/auth_provider.dart';
import '../../../widgets/toss/toss_primary_button.dart';
import '../../../widgets/toss/toss_dropdown.dart';
import '../../../widgets/common/toss_loading_view.dart';
import '../../../../data/services/company_service.dart';
import '../providers/homepage_providers.dart';
import '../../../../data/services/store_service.dart';
import '../../../../data/services/store_join_service.dart';
import '../../../../data/services/company_join_service.dart';
import '../../../../core/navigation/safe_navigation.dart';

// Provider for store join service
final storeJoinServiceProvider = Provider<StoreJoinService>((ref) {
  return StoreJoinService();
});

// Provider for company join service
final companyJoinServiceProvider = Provider<CompanyJoinService>((ref) {
  return CompanyJoinService();
});

/// Modern bottom drawer using bottom sheet pattern
class ModernBottomDrawer extends ConsumerStatefulWidget {
  const ModernBottomDrawer({
    super.key,
    required this.userData,
  });

  final dynamic userData;

  /// Show the bottom drawer as a modal bottom sheet
  static Future<T?> show<T>({
    required BuildContext context,
    required dynamic userData,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      backgroundColor: TossColors.transparent,
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(TossBorderRadius.bottomSheet),
            topRight: Radius.circular(TossBorderRadius.bottomSheet),
          ),
        ),
        child: ModernBottomDrawer(userData: userData),
      ),
    );
  }

  @override
  ConsumerState<ModernBottomDrawer> createState() => _ModernBottomDrawerState();
}

class _ModernBottomDrawerState extends ConsumerState<ModernBottomDrawer> {
  final Map<String, bool> _expandedCompanies = {};
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Watch for updates
    final appState = ref.watch(appStateProvider);
    final userCompaniesAsync = ref.watch(userCompaniesProvider);
    
    // Use the latest data from the provider if available
    final userData = userCompaniesAsync.maybeWhen(
      data: (data) => data,
      orElse: () => widget.userData,
    );
    
    final selectedCompany = ref.read(appStateProvider.notifier).selectedCompany;

    return Column(
      children: [
        // Handle bar
        Container(
          width: TossSpacing.space10,
          height: TossSpacing.space1,
          margin: const EdgeInsets.only(top: TossSpacing.space2, bottom: TossSpacing.space4),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(TossBorderRadius.xs),
          ),
        ),
        
        // Header
        _buildHeader(context, userData),
        
        // Companies Section
        Expanded(
          child: _buildCompaniesSection(context, ref, userData, selectedCompany),
        ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context, dynamic userData) {
    return Container(
      padding: const EdgeInsets.fromLTRB(TossSpacing.paddingXL, 0, TossSpacing.paddingXL, TossSpacing.paddingXL),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          bottom: BorderSide(color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2), width: 1),
        ),
      ),
      child: Row(
        children: [
          // Profile Section - Make it clickable to navigate to My Page
          Expanded(
            child: InkWell(
              onTap: () {
                // Navigate to My Page
                Navigator.of(context).pop(); // Close drawer first
                context.safePush('/myPage');
              },
              borderRadius: BorderRadius.circular(TossBorderRadius.md),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: TossSpacing.space2),
                child: Row(
                  children: [
                    // Profile Image
                    CircleAvatar(
                      radius: TossSpacing.paddingXL,
                      backgroundImage: (userData['profile_image'] ?? '').isNotEmpty
                          ? NetworkImage(userData['profile_image'])
                          : null,
                      backgroundColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
                      child: (userData['profile_image'] ?? '').isEmpty
                          ? Text(
                              (userData['user_first_name'] ?? '').isNotEmpty ? userData['user_first_name'][0] : 'U',
                              style: TossTextStyles.h3.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.w700,
                              ),
                            )
                          : null,
                    ),
                    const SizedBox(width: TossSpacing.space4),
                    
                    // User Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                '${userData['user_first_name'] ?? ''} ${userData['user_last_name'] ?? ''}',
                                style: TossTextStyles.body.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: Theme.of(context).colorScheme.onSurface,
                                ),
                              ),
                              const SizedBox(width: TossSpacing.space2),
                              Icon(
                                Icons.chevron_right,
                                size: TossSpacing.iconXS,
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                              ),
                            ],
                          ),
                          const SizedBox(height: TossSpacing.space1/2),
                          Text(
                            'View profile • ${userData['company_count'] ?? 0} companies',
                            style: TossTextStyles.caption.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          // Close Button
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(
              Icons.close,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompaniesSection(
    BuildContext context,
    WidgetRef ref,
    dynamic userData,
    dynamic selectedCompany,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        Padding(
          padding: const EdgeInsets.fromLTRB(TossSpacing.paddingXL, TossSpacing.paddingXL, TossSpacing.paddingXL, TossSpacing.space4),
          child: Row(
            children: [
              Container(
                width: TossSpacing.space1,
                height: TossSpacing.iconSM,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(TossBorderRadius.xs),
                ),
              ),
              const SizedBox(width: TossSpacing.space3),
              Text(
                'Companies & Stores',
                style: TossTextStyles.h3.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        
        // Companies with Stores Hierarchy
        Expanded(
          child: ListView(
            controller: _scrollController,
            padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space4),
            children: [
              // Existing Companies with their Stores (selected company first)
              ...() {
                // Get companies from userData
                final companies = userData['companies'] as List<dynamic>? ?? [];
                
                // Remove any duplicate companies by ID
                final uniqueCompanies = <String, dynamic>{};
                for (final company in companies) {
                  uniqueCompanies[company['company_id']] = company;
                }
                
                final companiesList = uniqueCompanies.values.toList();
                
                // Sort to put selected company first
                companiesList.sort((a, b) {
                  if (a['company_id'] == selectedCompany?['company_id']) return -1;
                  if (b['company_id'] == selectedCompany?['company_id']) return 1;
                  return 0;
                });
                
                return companiesList.map((company) => _buildCompanyWithStores(
                  context,
                  ref,
                  company,
                  company['company_id'] == selectedCompany?['company_id'],
                  selectedCompany,
                ));
              }(),
              
              const SizedBox(height: TossSpacing.space20), // Space for bottom button
            ],
          ),
        ),
        
        // Create Company Button at bottom
        Container(
          padding: EdgeInsets.only(
            left: TossSpacing.space4,
            right: TossSpacing.space4,
            top: TossSpacing.space4,
            bottom: TossSpacing.space4 + MediaQuery.of(context).padding.bottom,
          ),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            border: Border(
              top: BorderSide(
                color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
          ),
          child: SizedBox(
            width: double.infinity,
            child: TossPrimaryButton(
              text: 'Create Company',
              leadingIcon: const Icon(Icons.add, size: TossSpacing.iconSM),
              onPressed: () => _showCompanyActionsBottomSheet(context, ref),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCompanyWithStores(
    BuildContext context,
    WidgetRef ref,
    dynamic company,
    bool isSelected,
    dynamic selectedCompany,
  ) {
    final selectedStore = ref.read(appStateProvider.notifier).selectedStore;
    
    return Container(
      margin: const EdgeInsets.only(bottom: TossSpacing.space3),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        border: Border.all(
          color: isSelected 
            ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.3) 
            : Theme.of(context).colorScheme.outline.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Company Header - Split into two touch areas
          Container(
            padding: const EdgeInsets.all(TossSpacing.paddingMD),
            child: Row(
              children: [
                // Clickable company area (everything except expand button)
                Expanded(
                  child: InkWell(
                    onTap: () async {
                      // Only select company, don't toggle expansion
                      await ref.read(appStateProvider.notifier).setCompanyChoosen(company['company_id']);
                      await ref.read(appStateProvider.notifier).setStoreChoosen(''); // Clear store selection for HQ view
                      
                      // Auto-expand when selecting
                      setState(() {
                        _expandedCompanies[company['company_id']] = true;
                      });
                      
                      // Don't close drawer - let user explore
                    },
                    borderRadius: BorderRadius.circular(TossBorderRadius.md),
                    child: Row(
                      children: [
                        // Company Icon
                        Container(
                          width: TossSpacing.iconXL,
                          height: TossSpacing.iconXL,
                          decoration: BoxDecoration(
                            color: isSelected 
                              ? Theme.of(context).colorScheme.primary 
                              : Theme.of(context).colorScheme.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(TossBorderRadius.md),
                          ),
                          child: Icon(
                            Icons.business,
                            color: isSelected 
                              ? TossColors.white
                              : Theme.of(context).colorScheme.onSurfaceVariant,
                            size: TossSpacing.iconSM,
                          ),
                        ),
                        const SizedBox(width: TossSpacing.space3),
                        
                        // Company Info
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                company['company_name'] ?? '',
                                style: TossTextStyles.bodyLarge.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: Theme.of(context).colorScheme.onSurface,
                                ),
                              ),
                              const SizedBox(height: TossSpacing.space1/2),
                              Row(
                                children: [
                                  Text(
                                    '${(company['stores'] as List<dynamic>? ?? []).length} stores',
                                    style: TossTextStyles.caption.copyWith(
                                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                  const SizedBox(width: TossSpacing.space2),
                                  Text(
                                    '•',
                                    style: TossTextStyles.caption.copyWith(
                                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                  const SizedBox(width: TossSpacing.space2),
                                  Text(
                                    company['role']?['role_name'] ?? '',
                                    style: TossTextStyles.caption.copyWith(
                                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                // Separate expand/collapse button with better touch target
                Material(
                  color: TossColors.transparent,
                  child: InkWell(
                    onTap: () {
                      // Only toggle expand/collapse, don't select company
                      setState(() {
                        _expandedCompanies[company['company_id']] = !(_expandedCompanies[company['company_id']] ?? isSelected);
                      });
                    },
                    borderRadius: BorderRadius.circular(TossBorderRadius.full),
                    child: Container(
                      padding: const EdgeInsets.all(TossSpacing.space2),
                      decoration: BoxDecoration(
                        color: (_expandedCompanies[company['company_id']] ?? isSelected) 
                          ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.1)
                          : TossColors.transparent,
                        borderRadius: BorderRadius.circular(TossBorderRadius.full),
                      ),
                      child: Icon(
                        (_expandedCompanies[company['company_id']] ?? isSelected) ? Icons.expand_less : Icons.expand_more,
                        color: (_expandedCompanies[company['company_id']] ?? isSelected)
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.onSurfaceVariant,
                        size: TossSpacing.iconMD,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Stores Section (show if expanded)
          if (_expandedCompanies[company['company_id']] ?? isSelected) ...[
            // Stores Container
            Container(
              padding: const EdgeInsets.fromLTRB(TossSpacing.space4, 0, TossSpacing.space4, TossSpacing.space4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Store Items - deduplicate by store ID
                  ...() {
                    final stores = company['stores'] as List<dynamic>? ?? [];
                    
                    final uniqueStores = <String, dynamic>{};
                    for (final store in stores) {
                      uniqueStores[store['store_id']] = store;
                    }
                    
                    return uniqueStores.values.map((store) => _buildStoreItem(
                      context, ref, store, selectedStore?['store_id'] == store['store_id'], company,
                    )).toList();
                  }(),
                  
                  // Add Store Slot
                  if (isSelected) _buildAddStoreSlot(context, ref, company),
                  
                  // View Codes Button (only show if selected)
                  if (isSelected) _buildViewCodesButton(context, ref, company),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStoreItem(BuildContext context, WidgetRef ref, dynamic store, bool isSelected, dynamic company) {
    return Container(
      margin: const EdgeInsets.only(bottom: TossSpacing.space2/2, left: TossSpacing.space3),
      child: Material(
        color: TossColors.transparent,
        child: InkWell(
          onTap: () async {
            // Set both company and store when selecting a store
            await ref.read(appStateProvider.notifier).setCompanyChoosen(company['company_id']);
            await ref.read(appStateProvider.notifier).setStoreChoosen(store['store_id']);
            if (context.mounted) {
              Navigator.of(context).pop();
            }
          },
          borderRadius: BorderRadius.circular(TossBorderRadius.md),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space3, vertical: TossSpacing.space3/2),
            decoration: BoxDecoration(
              color: isSelected 
                ? Theme.of(context).colorScheme.surfaceContainerHighest 
                : TossColors.transparent,
              borderRadius: BorderRadius.circular(TossBorderRadius.md),
            ),
            child: Row(
              children: [
                // Store Icon
                Icon(
                  Icons.store_outlined,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  size: TossSpacing.iconSM,
                ),
                const SizedBox(width: TossSpacing.space3),
                
                // Store Name
                Expanded(
                  child: Text(
                    store['store_name'] ?? '',
                    style: TossTextStyles.body.copyWith(
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ),
                
                // Check icon if selected
                if (isSelected)
                  Icon(
                    Icons.check,
                    color: Theme.of(context).colorScheme.primary,
                    size: TossSpacing.iconSM,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAddStoreSlot(BuildContext context, WidgetRef ref, dynamic company) {
    return Container(
      margin: const EdgeInsets.only(top: TossSpacing.space1, left: TossSpacing.space3),
      child: Material(
        color: TossColors.transparent,
        child: InkWell(
          onTap: () => _showStoreActionsBottomSheet(context, ref, company),
          borderRadius: BorderRadius.circular(TossBorderRadius.md),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space3, vertical: TossSpacing.space3/2),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(TossBorderRadius.md),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.add,
                  color: Theme.of(context).colorScheme.primary,
                  size: TossSpacing.iconSM,
                ),
                const SizedBox(width: TossSpacing.space3),
                Text(
                  'Add store',
                  style: TossTextStyles.body.copyWith(
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildViewCodesButton(BuildContext context, WidgetRef ref, dynamic company) {
    return Container(
      margin: const EdgeInsets.only(top: TossSpacing.space2, left: TossSpacing.space3),
      child: Material(
        color: TossColors.transparent,
        child: InkWell(
          onTap: () => _showCodesBottomSheet(context, company),
          borderRadius: BorderRadius.circular(TossBorderRadius.md),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space3, vertical: TossSpacing.space3/2),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(TossBorderRadius.md),
              border: Border.all(
                color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.qr_code_2,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  size: TossSpacing.iconSM,
                ),
                const SizedBox(width: TossSpacing.space3),
                Text(
                  'View codes',
                  style: TossTextStyles.body.copyWith(
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                const Spacer(),
                Icon(
                  Icons.chevron_right,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  size: TossSpacing.iconSM,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showCompanyActionsBottomSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: TossColors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(TossBorderRadius.bottomSheet),
            topRight: Radius.circular(TossBorderRadius.bottomSheet),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              width: TossSpacing.space10,
              height: TossSpacing.space1,
              margin: const EdgeInsets.only(top: TossSpacing.space2, bottom: TossSpacing.paddingXL),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(TossBorderRadius.xs),
              ),
            ),
            
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: TossSpacing.paddingXL),
              child: Row(
                children: [
                  Text(
                    'Company Actions',
                    style: TossTextStyles.h3.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icon(
                      Icons.close,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: TossSpacing.space8),
            
            // Options
            Padding(
              padding: const EdgeInsets.fromLTRB(TossSpacing.paddingXL, 0, TossSpacing.paddingXL, TossSpacing.paddingXL),
              child: Column(
                children: [
                  // Create Company
                  _buildOptionCard(
                    context,
                    icon: Icons.business,
                    title: 'Create Company',
                    subtitle: 'Start a new company and invite others',
                    onTap: () => _handleCreateCompany(context, ref),
                  ),
                  
                  const SizedBox(height: TossSpacing.space4),
                  
                  // Join Company by Code
                  _buildOptionCard(
                    context,
                    icon: Icons.group_add,
                    title: 'Join Company',
                    subtitle: 'Enter company invite code to join',
                    onTap: () => _handleJoinCompany(context, ref),
                  ),
                  
                ],
              ),
            ),
            SizedBox(height: MediaQuery.of(context).padding.bottom),
          ],
        ),
      ),
    );
  }

  void _showStoreActionsBottomSheet(BuildContext context, WidgetRef ref, dynamic company) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: TossColors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(TossBorderRadius.bottomSheet),
            topRight: Radius.circular(TossBorderRadius.bottomSheet),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              width: TossSpacing.space10,
              height: TossSpacing.space1,
              margin: const EdgeInsets.only(top: TossSpacing.space2, bottom: TossSpacing.paddingXL),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(TossBorderRadius.xs),
              ),
            ),
            
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: TossSpacing.paddingXL),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Store Actions',
                        style: TossTextStyles.h3.copyWith(
                          color: Theme.of(context).colorScheme.onSurface,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        'For ${company['company_name'] ?? ''}',
                        style: TossTextStyles.caption.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icon(
                      Icons.close,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: TossSpacing.space8),
            
            // Options
            Padding(
              padding: const EdgeInsets.fromLTRB(TossSpacing.paddingXL, 0, TossSpacing.paddingXL, TossSpacing.paddingXL),
              child: Column(
                children: [
                  // Create Store
                  _buildOptionCard(
                    context,
                    icon: Icons.store,
                    title: 'Create Store',
                    subtitle: 'Add a new store to ${company['company_name'] ?? ''}',
                    onTap: () => _handleCreateStore(context, ref, company),
                  ),
                  
                  const SizedBox(height: TossSpacing.space4),
                  
                  // Join Store by Code
                  _buildOptionCard(
                    context,
                    icon: Icons.add_location,
                    title: 'Join Store',
                    subtitle: 'Enter store invite code to join',
                    onTap: () => _handleJoinStore(context, ref),
                  ),
                  
                ],
              ),
            ),
            SizedBox(height: MediaQuery.of(context).padding.bottom),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Material(
      color: TossColors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        child: Container(
          padding: const EdgeInsets.all(TossSpacing.paddingMD),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(TossBorderRadius.lg),
            border: Border.all(
              color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: TossSpacing.inputHeightLG,
                height: TossSpacing.inputHeightLG,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                ),
                child: Icon(
                  icon,
                  color: Theme.of(context).colorScheme.primary,
                  size: TossSpacing.iconMD,
                ),
              ),
              const SizedBox(width: TossSpacing.space4),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TossTextStyles.body.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: TossSpacing.space1/2),
                    Text(
                      subtitle,
                      style: TossTextStyles.caption.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                size: TossSpacing.iconXS,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleCreateCompany(BuildContext context, WidgetRef ref) {
    // Don't close the drawer yet - let _createCompany handle it after success
    _showCreateCompanyBottomSheet(context, ref);
  }

  void _handleJoinCompany(BuildContext context, WidgetRef ref) {
    // Don't close the drawer yet - let _joinCompany handle it after success
    _showInputBottomSheet(
      context,
      ref,
      title: 'Join Company',
      subtitle: 'Enter company invite code',
      inputLabel: 'Company Code',
      buttonText: 'Join Company',
      onSubmit: (code) async {
        await _joinCompany(context, ref, code);
      },
    );
  }

  void _handleCreateStore(BuildContext context, WidgetRef ref, dynamic company) {
    // Don't close the drawer yet - let _createStore handle it after success
    _showCreateStoreBottomSheet(context, ref, company);
  }

  void _handleJoinStore(BuildContext context, WidgetRef ref) {
    // Don't close the drawer yet - let _joinStore handle it after success
    _showInputBottomSheet(
      context,
      ref,
      title: 'Join Store',
      subtitle: 'Enter store invite code',
      inputLabel: 'Store Code',
      buttonText: 'Join Store',
      onSubmit: (code) async {
        await _joinStore(context, ref, code);
      },
    );
  }


  void _showInputBottomSheet(
    BuildContext context,
    WidgetRef ref, {
    required String title,
    required String subtitle,
    required String inputLabel,
    required String buttonText,
    required Function(String) onSubmit,
  }) {
    final controller = TextEditingController();
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: TossColors.transparent,
      builder: (modalContext) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.5,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              // Handle bar
              Container(
                width: TossSpacing.space10,
                height: TossSpacing.space1,
                margin: const EdgeInsets.only(top: TossSpacing.space2, bottom: TossSpacing.paddingXL),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(TossBorderRadius.xs),
                ),
              ),
              
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: TossSpacing.paddingXL),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TossTextStyles.h3.copyWith(
                            color: Theme.of(context).colorScheme.onSurface,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          subtitle,
                          style: TossTextStyles.caption.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: Icon(
                        Icons.close,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: TossSpacing.space8),
              
              // Input Form
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: TossSpacing.paddingXL),
                  child: Column(
                    children: [
                      TextField(
                        controller: controller,
                        decoration: InputDecoration(
                          labelText: inputLabel,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                          ),
                        ),
                        autofocus: true,
                      ),
                      
                      const SizedBox(height: TossSpacing.paddingXL),
                      
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            final code = controller.text.trim();
                            if (code.isNotEmpty) {
                              // Basic validation for code format (alphanumeric, 8-12 chars)
                              final validPattern = RegExp(r'^[a-zA-Z0-9]{6,15}$');
                              if (!validPattern.hasMatch(code)) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Invalid code format. Please use alphanumeric characters only.'),
                                    backgroundColor: TossColors.error,
                                    behavior: SnackBarBehavior.floating,
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                                return;
                              }
                              // Close the input modal first
                              Navigator.of(modalContext).pop();
                              // Execute the submit callback
                              onSubmit(code);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).colorScheme.primary,
                            foregroundColor: Theme.of(context).colorScheme.onPrimary,
                            padding: const EdgeInsets.symmetric(vertical: TossSpacing.space4),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                            ),
                          ),
                          child: Text(buttonText),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showCreateStoreBottomSheet(BuildContext context, WidgetRef ref, dynamic company) {
    final nameController = TextEditingController();
    final addressController = TextEditingController();
    final phoneController = TextEditingController();
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: TossColors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.7,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Column(
              children: [
                // Handle bar
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(top: TossSpacing.space2, bottom: TossSpacing.paddingXL),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(TossBorderRadius.xs),
                  ),
                ),
                
                // Header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: TossSpacing.paddingXL),
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Create Store',
                            style: TossTextStyles.h3.copyWith(
                              color: Theme.of(context).colorScheme.onSurface,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            'For ${company['company_name'] ?? ''}',
                            style: TossTextStyles.caption.copyWith(
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: Icon(
                          Icons.close,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: TossSpacing.space8),
                
                // Form
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: TossSpacing.paddingXL),
                    child: Column(
                      children: [
                        // Store Name Input
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Store Name',
                              style: TossTextStyles.caption.copyWith(
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: TossSpacing.space1),
                            TextField(
                              controller: nameController,
                              decoration: InputDecoration(
                                hintText: 'Enter store name',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                                ),
                              ),
                              autofocus: true,
                              onChanged: (value) {
                                setState(() {}); // Trigger rebuild to update button state
                              },
                            ),
                          ],
                        ),
                        
                        SizedBox(height: TossSpacing.space6),
                        
                        // Store Address Input (Optional)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Store Address (Optional)',
                              style: TossTextStyles.caption.copyWith(
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: TossSpacing.space1),
                            TextField(
                              controller: addressController,
                              decoration: InputDecoration(
                                hintText: 'Enter store address',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                                ),
                              ),
                              maxLines: 2,
                            ),
                          ],
                        ),
                        
                        SizedBox(height: TossSpacing.space6),
                        
                        // Store Phone Input (Optional)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Store Phone (Optional)',
                              style: TossTextStyles.caption.copyWith(
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: TossSpacing.space1),
                            TextField(
                              controller: phoneController,
                              decoration: InputDecoration(
                                hintText: 'Enter store phone number',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                                ),
                              ),
                              keyboardType: TextInputType.phone,
                            ),
                          ],
                        ),
                        
                        SizedBox(height: TossSpacing.space8),
                        
                        // Create Button
                        SizedBox(
                          width: double.infinity,
                          child: TossPrimaryButton(
                            text: 'Create Store',
                            onPressed: nameController.text.trim().isNotEmpty
                                ? () => _createStore(
                                    context,
                                    ref,
                                    nameController.text.trim(),
                                    company,
                                    addressController.text.trim(),
                                    phoneController.text.trim(),
                                  )
                                : null,
                          ),
                        ),
                        
                        SizedBox(height: TossSpacing.space4),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showCreateCompanyBottomSheet(BuildContext context, WidgetRef ref) {
    final nameController = TextEditingController();
    String? selectedCompanyTypeId;
    String? selectedCurrencyId;
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: TossColors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.75,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Column(
              children: [
                // Handle bar
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(top: TossSpacing.space2, bottom: TossSpacing.paddingXL),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(TossBorderRadius.xs),
                  ),
                ),
                
                // Header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: TossSpacing.paddingXL),
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Create Company',
                            style: TossTextStyles.h3.copyWith(
                              color: Theme.of(context).colorScheme.onSurface,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            'Enter company details',
                            style: TossTextStyles.caption.copyWith(
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: Icon(
                          Icons.close,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: TossSpacing.space8),
                
                // Form
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: TossSpacing.paddingXL),
                    child: Column(
                      children: [
                        // Company Name Input
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Company Name',
                              style: TossTextStyles.caption.copyWith(
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: TossSpacing.space1),
                            TextField(
                              controller: nameController,
                              decoration: InputDecoration(
                                hintText: 'Enter company name',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                                ),
                              ),
                              autofocus: true,
                              onChanged: (value) {
                                setState(() {}); // Trigger rebuild to update button state
                              },
                            ),
                          ],
                        ),
                        
                        SizedBox(height: TossSpacing.space6),
                        
                        // Company Type Dropdown
                        Consumer(
                          builder: (context, ref, child) {
                            final companyTypesAsync = ref.watch(companyTypesProvider);
                            
                            return companyTypesAsync.when(
                              data: (companyTypes) => TossDropdown<String>(
                                label: 'Company Type',
                                value: selectedCompanyTypeId,
                                hint: 'Select company type',
                                items: companyTypes.map((type) => TossDropdownItem(
                                  value: type.companyTypeId,
                                  label: type.typeName,
                                )).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    selectedCompanyTypeId = value;
                                  });
                                },
                              ),
                              loading: () => const TossDropdown<String>(
                                label: 'Company Type',
                                items: [],
                                isLoading: true,
                              ),
                              error: (_, __) => TossDropdown<String>(
                                label: 'Company Type',
                                items: [],
                                errorText: 'Failed to load company types',
                              ),
                            );
                          },
                        ),
                        
                        SizedBox(height: TossSpacing.space6),
                        
                        // Currency Dropdown
                        Consumer(
                          builder: (context, ref, child) {
                            final currenciesAsync = ref.watch(currenciesProvider);
                            
                            return currenciesAsync.when(
                              data: (currencies) => TossDropdown<String>(
                                label: 'Base Currency',
                                value: selectedCurrencyId,
                                hint: 'Select base currency',
                                items: currencies.map((currency) => TossDropdownItem(
                                  value: currency.currencyId,
                                  label: '${currency.currencyName} (${currency.currencyCode})',
                                  subtitle: currency.symbol,
                                )).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    selectedCurrencyId = value;
                                  });
                                },
                              ),
                              loading: () => const TossDropdown<String>(
                                label: 'Base Currency',
                                items: [],
                                isLoading: true,
                              ),
                              error: (_, __) => TossDropdown<String>(
                                label: 'Base Currency',
                                items: [],
                                errorText: 'Failed to load currencies',
                              ),
                            );
                          },
                        ),
                        
                        SizedBox(height: TossSpacing.space8),
                        
                        // Create Button
                        SizedBox(
                          width: double.infinity,
                          child: TossPrimaryButton(
                            text: 'Create Company',
                            onPressed: nameController.text.trim().isNotEmpty &&
                                    selectedCompanyTypeId != null &&
                                    selectedCurrencyId != null
                                ? () => _createCompany(
                                    context,
                                    ref,
                                    nameController.text.trim(),
                                    selectedCompanyTypeId!,
                                    selectedCurrencyId!,
                                  )
                                : null,
                          ),
                        ),
                        
                        SizedBox(height: TossSpacing.space4),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  // API methods
  Future<void> _createCompany(
    BuildContext context,
    WidgetRef ref,
    String name,
    String companyTypeId,
    String baseCurrencyId,
  ) async {
    // Capture the navigator and scaffold messenger before any async operations
    final navigator = Navigator.of(context);
    final scaffoldMessenger = ScaffoldMessenger.maybeOf(context);
    
    // Show loading indicator
    if (scaffoldMessenger != null) {
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Row(
            children: [
              SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
              SizedBox(width: 16),
              Text('Creating company "$name"...'),
            ],
          ),
          backgroundColor: TossColors.primary,
          duration: Duration(seconds: 30), // Long duration, will be dismissed manually
        ),
      );
    }
    
    try {
      
      final companyService = ref.read(companyServiceProvider);
      final companyData = await companyService.createCompany(
        companyName: name,
        companyTypeId: companyTypeId,
        baseCurrencyId: baseCurrencyId,
      );
      
      if (companyData != null && companyData['company_id'] != null) {
        
        // Close both the modal and the drawer
        // First close the create company modal
        if (navigator.canPop()) {
          navigator.pop(); // Close the modal
        }
        // Then close the drawer
        if (navigator.canPop()) {
          navigator.pop(); // Close the drawer
        }
        
        // Dismiss loading and show success message
        if (scaffoldMessenger != null) {
          scaffoldMessenger.hideCurrentSnackBar();
          scaffoldMessenger.showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.white),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text('Company "$name" created successfully!'),
                  ),
                ],
              ),
              backgroundColor: TossColors.success,
              behavior: SnackBarBehavior.floating,
              duration: Duration(seconds: 3),
            ),
          );
        }
        
        // Force refresh user data after drawer is closed
        await Future.delayed(Duration(milliseconds: 300));
        
        // Invalidate all company-related providers
        ref.invalidate(userCompaniesProvider);
        ref.invalidate(forceRefreshUserCompaniesProvider);
        ref.invalidate(categoriesWithFeaturesProvider);
        ref.invalidate(forceRefreshCategoriesProvider);
        
        // Wait for data to refresh
        await Future.delayed(Duration(milliseconds: 500));
        
        // Select the new company and its first store (if created)
        final appStateNotifier = ref.read(appStateProvider.notifier);
        await appStateNotifier.setCompanyChoosen(companyData['company_id'] as String);
        
        // If a store was also created, select it
        if (companyData['store_id'] != null) {
          await appStateNotifier.setStoreChoosen(companyData['store_id'] as String);
        }
      } else {
        throw Exception('Failed to create company - no data returned');
      }
    } catch (e) {
      
      // Dismiss loading and show error message
      if (scaffoldMessenger != null) {
        scaffoldMessenger.hideCurrentSnackBar();
        scaffoldMessenger.showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.error_outline, color: Colors.white),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Failed to create company: ${e.toString().replaceAll('Exception: ', '')}',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            backgroundColor: TossColors.error,
            behavior: SnackBarBehavior.floating,
            duration: Duration(seconds: 4),
          ),
        );
      }
    }
  }

  Future<void> _joinCompany(BuildContext context, WidgetRef ref, String code) async {
    // Capture the navigator and scaffold messenger before any async operations
    final navigator = Navigator.of(context);
    final scaffoldMessenger = ScaffoldMessenger.maybeOf(context);
    
    // Show loading indicator
    if (scaffoldMessenger != null) {
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Row(
            children: [
              SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
              SizedBox(width: 16),
              Text('Joining company...'),
            ],
          ),
          backgroundColor: TossColors.primary,
          duration: Duration(seconds: 30), // Long duration, will be dismissed manually
        ),
      );
    }
    
    try {
      
      // Import the company join service
      final companyJoinService = ref.read(companyJoinServiceProvider);
      final user = ref.read(authStateProvider);
      
      if (user == null) {
        // Dismiss loading snackbar
        if (scaffoldMessenger != null) {
          scaffoldMessenger.hideCurrentSnackBar();
          scaffoldMessenger.showSnackBar(
            SnackBar(
              content: Text('Please log in first'),
              backgroundColor: TossColors.error,
            ),
          );
        }
        return;
      }
      
      // Call the join_company_by_code RPC (will fail gracefully if not implemented yet)
      final result = await companyJoinService.joinCompanyByCode(
        userId: user.id,
        companyCode: code,
      );
      
      if (result != null && (result['success'] == true || result['company_id'] != null)) {
        
        // Success! Close the drawer FIRST
        if (navigator.canPop()) {
          navigator.pop(); // Close the drawer
        }
        
        // Dismiss loading and show success message
        if (scaffoldMessenger != null) {
          scaffoldMessenger.hideCurrentSnackBar();
          
          final companyName = result['company_name'] ?? 'the company';
          scaffoldMessenger.showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.white),
                  SizedBox(width: 12),
                  Text('Successfully joined $companyName!'),
                ],
              ),
              backgroundColor: TossColors.success,
              behavior: SnackBarBehavior.floating,
              duration: Duration(seconds: 3),
            ),
          );
        }
        
        // Force refresh user data after drawer is closed
        await Future.delayed(Duration(milliseconds: 300));
        ref.invalidate(userCompaniesProvider);
        ref.invalidate(forceRefreshUserCompaniesProvider);
        
        // Wait for data to refresh
        await Future.delayed(Duration(milliseconds: 500));
        
        // Set the new company as selected if company_id is returned
        if (result['company_id'] != null) {
          final appStateNotifier = ref.read(appStateProvider.notifier);
          await appStateNotifier.setCompanyChoosen(result['company_id']);
          
          // Auto-select first store of the joined company if available
          try {
            final userData = await ref.read(userCompaniesProvider.future);
            final companies = userData['companies'] as List? ?? [];
            final joinedCompany = companies.firstWhere(
              (c) => c['company_id'] == result['company_id'],
              orElse: () => null,
            );
            
            if (joinedCompany != null) {
              final stores = joinedCompany['stores'] as List? ?? [];
              if (stores.isNotEmpty) {
                final firstStore = stores.first;
                await appStateNotifier.setStoreChoosen(firstStore['store_id']);
              }
            }
          } catch (e) {
            // Handle error silently
          }
        }
      } else {
        throw Exception('Failed to join company');
      }
      
    } catch (e) {
      
      // Dismiss loading and show error message
      if (scaffoldMessenger != null) {
        scaffoldMessenger.hideCurrentSnackBar();
        scaffoldMessenger.showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.error_outline, color: Colors.white),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Failed: ${e.toString().replaceAll('Exception: ', '')}',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            backgroundColor: TossColors.error,
            behavior: SnackBarBehavior.floating,
            duration: Duration(seconds: 4),
          ),
        );
      }
    }
  }

  Future<void> _createStore(
    BuildContext context, 
    WidgetRef ref, 
    String name, 
    dynamic company,
    String? address,
    String? phone,
  ) async {
    // Capture the navigator and scaffold messenger before any async operations
    final navigator = Navigator.of(context);
    final scaffoldMessenger = ScaffoldMessenger.maybeOf(context);
    
    // Show loading indicator
    if (scaffoldMessenger != null) {
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Row(
            children: [
              SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
              SizedBox(width: 16),
              Text('Creating store "$name"...'),
            ],
          ),
          backgroundColor: TossColors.primary,
          duration: Duration(seconds: 30), // Long duration, will be dismissed manually
        ),
      );
    }
    
    try {
      
      final storeService = ref.read(storeServiceProvider);
      final storeData = await storeService.createStore(
        storeName: name,
        companyId: company['company_id'],
        storeAddress: address,
        storePhone: phone,
      );
      
      if (storeData != null && storeData['store_id'] != null) {
        
        // Close both the modal and the drawer
        // First close the create store modal
        if (navigator.canPop()) {
          navigator.pop(); // Close the modal
        }
        // Then close the drawer
        if (navigator.canPop()) {
          navigator.pop(); // Close the drawer
        }
        
        // Dismiss loading and show success message
        if (scaffoldMessenger != null) {
          scaffoldMessenger.hideCurrentSnackBar();
          
          final storeCode = storeData['store_code'] ?? '';
          scaffoldMessenger.showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.white),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text('Store "$name" created! Code: $storeCode'),
                  ),
                ],
              ),
              backgroundColor: TossColors.success,
              behavior: SnackBarBehavior.floating,
              duration: Duration(seconds: 4),
            ),
          );
        }
        
        // Force refresh user data after drawer is closed
        await Future.delayed(Duration(milliseconds: 300));
        
        // Invalidate all store-related providers
        ref.invalidate(userCompaniesProvider);
        ref.invalidate(forceRefreshUserCompaniesProvider);
        ref.invalidate(categoriesWithFeaturesProvider);
        
        // Wait for data to refresh
        await Future.delayed(Duration(milliseconds: 500));
        
        // Select the new store
        final appStateNotifier = ref.read(appStateProvider.notifier);
        await appStateNotifier.setStoreChoosen(storeData['store_id'] as String);
      } else {
        throw Exception('Failed to create store - no data returned');
      }
    } catch (e) {
      
      // Dismiss loading and show error message
      if (scaffoldMessenger != null) {
        scaffoldMessenger.hideCurrentSnackBar();
        scaffoldMessenger.showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.error_outline, color: Colors.white),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Failed to create store: ${e.toString().replaceAll('Exception: ', '')}',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            backgroundColor: TossColors.error,
            behavior: SnackBarBehavior.floating,
            duration: Duration(seconds: 4),
          ),
        );
      }
    }
  }

  Future<void> _joinStore(BuildContext context, WidgetRef ref, String code) async {
    // Capture the navigator and scaffold messenger before any async operations
    final navigator = Navigator.of(context);
    final scaffoldMessenger = ScaffoldMessenger.maybeOf(context);
    
    // Show loading indicator
    if (scaffoldMessenger != null) {
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Row(
            children: [
              SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
              SizedBox(width: 16),
              Text('Joining store...'),
            ],
          ),
          backgroundColor: TossColors.primary,
          duration: Duration(seconds: 30), // Long duration, will be dismissed manually
        ),
      );
    }
    
    try {
      // Import the store join service
      final storeJoinService = ref.read(storeJoinServiceProvider);
      final user = ref.read(authStateProvider);
      
      if (user == null) {
        // Dismiss loading snackbar
        if (scaffoldMessenger != null) {
          scaffoldMessenger.hideCurrentSnackBar();
          scaffoldMessenger.showSnackBar(
            SnackBar(
              content: Text('Please log in first'),
              backgroundColor: TossColors.error,
            ),
          );
        }
        return;
      }
      
      
      // Call the join_user_by_code RPC
      final result = await storeJoinService.joinStoreByCode(
        userId: user.id,
        storeCode: code,
      );
      
      if (result != null && (result['success'] == true || result['store_id'] != null)) {
        
        // Success! Close the drawer FIRST
        if (navigator.canPop()) {
          navigator.pop(); // Close the drawer
        }
        
        // Dismiss loading and show success message
        if (scaffoldMessenger != null) {
          scaffoldMessenger.hideCurrentSnackBar();
          
          final storeName = result['store_name'] ?? 'the store';
          scaffoldMessenger.showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.white),
                  SizedBox(width: 12),
                  Text('Successfully joined $storeName!'),
                ],
              ),
              backgroundColor: TossColors.success,
              behavior: SnackBarBehavior.floating,
              duration: Duration(seconds: 3),
            ),
          );
        }
        
        // Force refresh user data after drawer is closed
        await Future.delayed(Duration(milliseconds: 300));
        ref.invalidate(userCompaniesProvider);
        ref.invalidate(forceRefreshUserCompaniesProvider);
        
        // Set the company and store as selected
        final appStateNotifier = ref.read(appStateProvider.notifier);
        
        // Set company first if provided
        if (result['company_id'] != null) {
          await appStateNotifier.setCompanyChoosen(result['company_id']);
        }
        
        // Then set the store if provided
        if (result['store_id'] != null) {
          await appStateNotifier.setStoreChoosen(result['store_id']);
        }
      } else {
        throw Exception('Failed to join store');
      }
    } catch (e) {
      
      // Dismiss loading and show error message
      if (scaffoldMessenger != null) {
        scaffoldMessenger.hideCurrentSnackBar();
        scaffoldMessenger.showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.error_outline, color: Colors.white),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Failed: ${e.toString().replaceAll('Exception: ', '')}',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            backgroundColor: TossColors.error,
            behavior: SnackBarBehavior.floating,
            duration: Duration(seconds: 4),
          ),
        );
      }
    }
  }

  void _copyToClipboard(BuildContext context, String text, String label) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$label copied to clipboard'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(TossBorderRadius.md)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showCodesBottomSheet(BuildContext context, dynamic company) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: TossColors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(TossBorderRadius.bottomSheet),
            topRight: Radius.circular(TossBorderRadius.bottomSheet),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              width: TossSpacing.space10,
              height: TossSpacing.space1,
              margin: const EdgeInsets.only(top: TossSpacing.space2, bottom: TossSpacing.paddingXL),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(TossBorderRadius.xs),
              ),
            ),
            
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: TossSpacing.paddingXL),
              child: Row(
                children: [
                  Text(
                    'Company & Store Codes',
                    style: TossTextStyles.h3.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icon(
                      Icons.close,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: TossSpacing.space4),
            
            // Codes List
            Padding(
              padding: const EdgeInsets.fromLTRB(TossSpacing.paddingXL, 0, TossSpacing.paddingXL, TossSpacing.paddingXL),
              child: Column(
                children: [
                  // Company Code
                  _buildCodeItem(
                    context: context,
                    icon: Icons.business,
                    title: company['company_name'] ?? '',
                    subtitle: 'Company Code',
                    code: company['company_code'] ?? '',
                    onCopy: () => _copyToClipboard(context, company['company_code'] ?? '', 'Company code'),
                  ),
                  
                  const SizedBox(height: TossSpacing.space3),
                  
                  // Store Codes
                  ...(company['stores'] as List<dynamic>? ?? []).map((store) => Padding(
                    padding: const EdgeInsets.only(bottom: TossSpacing.space3),
                    child: _buildCodeItem(
                      context: context,
                      icon: Icons.store_outlined,
                      title: store['store_name'] ?? '',
                      subtitle: 'Store Code',
                      code: store['store_code'] ?? '',
                      onCopy: () => _copyToClipboard(context, store['store_code'] ?? '', 'Store code'),
                    ),
                  )),
                ],
              ),
            ),
            SizedBox(height: MediaQuery.of(context).padding.bottom),
          ],
        ),
      ),
    );
  }

  Widget _buildCodeItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required String code,
    required VoidCallback onCopy,
  }) {
    return Material(
      color: TossColors.transparent,
      child: InkWell(
        onTap: onCopy,
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        child: Container(
          padding: const EdgeInsets.all(TossSpacing.paddingMD),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(TossBorderRadius.lg),
            border: Border.all(
              color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.1),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: TossSpacing.iconXL,
                height: TossSpacing.iconXL,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(TossBorderRadius.md),
                ),
                child: Icon(
                  icon,
                  color: Theme.of(context).colorScheme.primary,
                  size: TossSpacing.iconSM,
                ),
              ),
              const SizedBox(width: TossSpacing.space3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TossTextStyles.body.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: TossSpacing.space1/2),
                    Text(
                      subtitle,
                      style: TossTextStyles.caption.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    code,
                    style: TossTextStyles.body.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: TossSpacing.space1/2),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space2, vertical: TossSpacing.space1),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(TossBorderRadius.xs),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.copy_outlined,
                          size: TossSpacing.iconXS,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(width: TossSpacing.space1),
                        Text(
                          'Copy',
                          style: TossTextStyles.caption.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}