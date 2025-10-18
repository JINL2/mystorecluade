import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/themes/toss_colors.dart';
import '../../../../core/themes/toss_text_styles.dart';
import '../../../../core/themes/toss_spacing.dart';
import '../../../../core/themes/toss_border_radius.dart';
import '../../../providers/app_state_provider.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/session_manager_provider.dart';
import '../../../widgets/toss/toss_primary_button.dart';
import '../../../widgets/toss/toss_dropdown.dart';
import '../../../../data/services/enhanced_company_service.dart';
import '../../../../data/services/enhanced_store_service.dart';
import '../../../../data/services/company_service.dart';
import '../providers/homepage_providers.dart';
import '../../../widgets/common/toss_dialog.dart';
import '../../../../data/services/unified_join_service.dart';
import 'package:myfinance_improved/core/themes/index.dart';
import 'package:flutter/foundation.dart';

// Provider for unified join service
final unifiedJoinServiceProvider = Provider<UnifiedJoinService>((ref) {
  return UnifiedJoinService();
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
      builder: (context) => AnimatedPadding(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
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
    ref.watch(appStateProvider);
    final userCompaniesAsync = ref.watch(userCompaniesProvider);
    
    // Use the latest data from the provider if available
    final userData = userCompaniesAsync.maybeWhen(
      data: (data) => data ?? widget.userData, // Handle null data when user is not authenticated
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
            color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
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
          bottom: BorderSide(color: Theme.of(context).colorScheme.outline.withOpacity(0.2), width: 1),
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
                context.push('/myPage');
              },
              borderRadius: BorderRadius.circular(TossBorderRadius.md),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: TossSpacing.space2),
                child: Row(
                  children: [
                    // Profile Image
                    CircleAvatar(
                      radius: TossSpacing.paddingXL,
                      backgroundImage: userData != null && ((userData['profile_image'] ?? '') as String).isNotEmpty
                          ? NetworkImage(userData['profile_image'] as String)
                          : null,
                      backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                      child: userData == null || ((userData['profile_image'] ?? '') as String).isEmpty
                          ? Text(
                              userData != null && ((userData['user_first_name'] ?? '') as String).isNotEmpty ? (userData['user_first_name'] as String)[0] : 'U',
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
                                userData != null 
                                  ? '${userData['user_first_name'] ?? ''} ${userData['user_last_name'] ?? ''}'
                                  : 'User',
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
                            'View profile • ${userData != null ? (userData['company_count'] ?? 0) : 0} companies',
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
                final companies = userData != null ? (userData['companies'] as List<dynamic>? ?? []) : [];
                
                // Remove any duplicate companies by ID
                final uniqueCompanies = <String, dynamic>{};
                for (final company in companies) {
                  uniqueCompanies[company['company_id'] as String] = company;
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
                color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
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
            ? Theme.of(context).colorScheme.primary.withOpacity(0.3) 
            : Theme.of(context).colorScheme.outline.withOpacity(0.1),
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
                // Clickable company area - always selects first store
                Expanded(
                  child: InkWell(
                    onTap: () async {
                      // Always select the company and its first store
                      final stores = company['stores'] as List<dynamic>? ?? [];
                      
                      await ref.read(appStateProvider.notifier).setCompanyChoosen(company['company_id'] as String);
                      
                      if (stores.isNotEmpty) {
                        // Select the first store
                        await ref.read(appStateProvider.notifier).setStoreChoosen(stores[0]['store_id'] as String);
                      }
                      
                      // Navigate to dashboard
                      Navigator.of(context).pop();
                      context.go('/');
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
                                (company['company_name'] ?? '') as String,
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
                                    (company['role']?['role_name'] ?? '') as String,
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
                        _expandedCompanies[company['company_id'] as String] = !(_expandedCompanies[company['company_id'] as String] ?? isSelected);
                      });
                    },
                    borderRadius: BorderRadius.circular(TossBorderRadius.full),
                    child: Container(
                      padding: const EdgeInsets.all(TossSpacing.space2),
                      decoration: BoxDecoration(
                        color: (_expandedCompanies[company['company_id'] as String] ?? isSelected) 
                          ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
                          : TossColors.transparent,
                        borderRadius: BorderRadius.circular(TossBorderRadius.full),
                      ),
                      child: Icon(
                        (_expandedCompanies[company['company_id'] as String] ?? isSelected) ? Icons.expand_less : Icons.expand_more,
                        color: (_expandedCompanies[company['company_id'] as String] ?? isSelected)
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
          if (_expandedCompanies[company['company_id'] as String] ?? isSelected) ...[
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
                      uniqueStores[store['store_id'] as String] = store;
                    }
                    
                    return uniqueStores.values.map((store) => _buildStoreItem(
                      context, ref, store, selectedStore?['store_id'] == store['store_id'], company,
                    )).toList();
                  }(),

                  // View Codes and Create Store buttons side by side
                  if (isSelected)
                    Padding(
                      padding: const EdgeInsets.only(top: TossSpacing.space2, left: TossSpacing.space3),
                      child: Row(
                        children: [
                          // View Codes Button
                          Expanded(
                            child: _buildViewCodesButtonCompact(context, ref, company),
                          ),
                          const SizedBox(width: TossSpacing.space2),
                          // Create Store Button
                          Expanded(
                            child: _buildAddStoreSlotCompact(context, ref, company),
                          ),
                        ],
                      ),
                    ),
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
            await ref.read(appStateProvider.notifier).setCompanyChoosen(company['company_id'] as String);
            await ref.read(appStateProvider.notifier).setStoreChoosen(store['store_id'] as String);
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
                    (store['store_name'] ?? '') as String,
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
              color: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.5),
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
                color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
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

  // Compact versions for side-by-side layout
  Widget _buildViewCodesButtonCompact(BuildContext context, WidgetRef ref, dynamic company) {
    return Material(
      color: TossColors.transparent,
      child: InkWell(
        onTap: () => _showCodesBottomSheet(context, company),
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space3, vertical: TossSpacing.space3),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(TossBorderRadius.md),
            border: Border.all(
              color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.qr_code_2,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                size: TossSpacing.iconSM,
              ),
              const SizedBox(width: TossSpacing.space2),
              Flexible(
                child: Text(
                  'View codes',
                  style: TossTextStyles.body.copyWith(
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAddStoreSlotCompact(BuildContext context, WidgetRef ref, dynamic company) {
    return Material(
      color: TossColors.transparent,
      child: InkWell(
        onTap: () => _showStoreActionsBottomSheet(context, ref, company),
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space3, vertical: TossSpacing.space3),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.5),
            borderRadius: BorderRadius.circular(TossBorderRadius.md),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.add,
                color: Theme.of(context).colorScheme.primary,
                size: TossSpacing.iconSM,
              ),
              const SizedBox(width: TossSpacing.space2),
              Flexible(
                child: Text(
                  'Create Store',
                  style: TossTextStyles.body.copyWith(
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
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
                color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
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
                color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
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
                        'For ${(company['company_name'] ?? '') as String}',
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
                    subtitle: 'Add a new store to ${(company['company_name'] ?? '') as String}',
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
              color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: TossSpacing.inputHeightLG,
                height: TossSpacing.inputHeightLG,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
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
                  color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
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
                    color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
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
                            'For ${(company['company_name'] ?? '') as String}',
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
                    color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
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
    _showLoadingSnackBar(scaffoldMessenger, 'Creating company "$name"...');
    
    try {
      
      final companyService = ref.read(enhancedCompanyServiceProvider);
      final result = await companyService.createCompanyEnhanced(
        companyName: name,
        companyTypeId: companyTypeId,
        baseCurrencyId: baseCurrencyId,
      );
      
      // Dismiss loading
      _dismissSnackBar(scaffoldMessenger);
      
      if (result.isSuccess) {
        debugPrint('🟢 [CreateCompany] Company created successfully: ${result.companyName}');
        
        // Select the new company in app state FIRST
        final appStateNotifier = ref.read(appStateProvider.notifier);
        if (result.companyId != null) {
          debugPrint('🟢 [CreateCompany] Setting new company as selected: ${result.companyId}');
          await appStateNotifier.setCompanyChoosen(result.companyId!);
        }
        
        // Close modals (create company modal + drawer)
        if (navigator.canPop()) {
          navigator.pop(); // Close the modal
        }
        if (navigator.canPop()) {
          navigator.pop(); // Close the drawer
        }
        
        debugPrint('🟢 [CreateCompany] Navigating to dashboard with fresh data fetch...');
        // Navigate to dashboard with state refresh
        await _navigateToDashboard(context, ref);
        
        // Show success message
        _showSuccessSnackBar(
          scaffoldMessenger,
          'Company "${result.companyName}" created successfully!',
          actionLabel: result.companyCode != null ? 'Share Code' : null,
          onAction: result.companyCode != null ? () {
            _copyToClipboard(context, result.companyCode!, 'Company code');
          } : null,
        );
      } else {
        // Show error via snackbar to avoid context issues
        _showErrorSnackBar(
          scaffoldMessenger,
          result.userMessage ?? 'Failed to create company',
          onRetry: () => _createCompany(context, ref, name, companyTypeId, baseCurrencyId),
        );
      }
    } catch (e) {
      // Dismiss loading
      _dismissSnackBar(scaffoldMessenger);
      
      // Show error via snackbar to avoid context issues
      _showErrorSnackBar(
        scaffoldMessenger,
        'Error: ${e.toString().replaceAll('Exception: ', '')}',
        onRetry: () => _createCompany(context, ref, name, companyTypeId, baseCurrencyId),
      );
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
                  valueColor: AlwaysStoppedAnimation<Color>(TossColors.white),
                ),
              ),
              SizedBox(width: TossSpacing.space4),
              Text('Joining company...'),
            ],
          ),
          backgroundColor: TossColors.primary,
          duration: Duration(seconds: 30), // Long duration, will be dismissed manually
        ),
      );
    }
    
    try {
      
      // Import the unified join service
      final unifiedJoinService = ref.read(unifiedJoinServiceProvider);
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
      
      // Call the unified join_user_by_code RPC (server determines if it's a company code)
      final result = await unifiedJoinService.joinByCode(
        userId: user.id,
        code: code,
      );
      
      if (result != null && (result['success'] == true || result['company_id'] != null)) {
        
        // Success! Close all modals (input modal + drawer)
        // Safely close up to 2 modals: input modal + drawer
        if (navigator.canPop()) {
          navigator.pop(); // Close the input modal
        }
        if (navigator.canPop()) {
          navigator.pop(); // Close the drawer
        }
        
        // Dismiss loading
        if (scaffoldMessenger != null) {
          scaffoldMessenger.hideCurrentSnackBar();
        }
        
        // Force comprehensive data refresh for immediate UI update
        await Future.delayed(Duration(milliseconds: 300));
        
        // Expire cache to ensure fresh data is fetched
        await ref.read(sessionManagerProvider.notifier).expireCache();
        
        // Invalidate all company-related providers for real-time update
        ref.invalidate(userCompaniesProvider);
        ref.invalidate(forceRefreshUserCompaniesProvider);
        ref.invalidate(categoriesWithFeaturesProvider);
        ref.invalidate(forceRefreshCategoriesProvider);
        
        // Force fetch fresh data immediately
        try {
          await ref.read(forceRefreshUserCompaniesProvider.future);
          await ref.read(forceRefreshCategoriesProvider.future);
        } catch (e) {
          // Continue even if refresh fails
        }
        
        // Set the new company as selected if company_id is returned
        if (result['company_id'] != null) {
          final appStateNotifier = ref.read(appStateProvider.notifier);
          await appStateNotifier.setCompanyChoosen(result['company_id'] as String);
          
          // Auto-select first store of the joined company if available
          try {
            final userData = await ref.read(userCompaniesProvider.future);
            final companies = userData != null ? (userData['companies'] as List? ?? []) : [];
            final joinedCompany = companies.firstWhere(
              (c) => c['company_id'] == result['company_id'],
              orElse: () => null,
            );
            
            if (joinedCompany != null) {
              final stores = joinedCompany['stores'] as List? ?? [];
              if (stores.isNotEmpty) {
                final firstStore = stores.first;
                await appStateNotifier.setStoreChoosen(firstStore['store_id'] as String);
              }
            }
          } catch (e) {
            // Handle error silently
          }
        }
        
        // Navigate to dashboard to show the new company/store immediately
        if (context.mounted) {
          final companyName = (result['company_name'] ?? result['entity_name'] ?? 'the company') as String;
          
          // Show success dialog with proper navigation
          await TossSuccessDialogs.showBusinessJoined(
            context: context,
            companyName: companyName,
            roleName: (result['role_assigned'] ?? 'Member') as String,
            onContinue: () {
              Navigator.of(context).pop(); // Close dialog
              context.go('/'); // Navigate to dashboard
            },
          );
        }
      } else {
        // Show error dialog for invalid response
        if (scaffoldMessenger != null) {
          scaffoldMessenger.hideCurrentSnackBar();
        }
        await TossErrorDialogs.showBusinessJoinFailed(
          context: context,
          error: 'Invalid response from server',
          onRetry: () {
            Navigator.of(context).pop();
            _joinCompany(context, ref, code);
          },
        );
        return;
      }
      
    } catch (e) {
      
      // Dismiss loading and show error dialog
      if (scaffoldMessenger != null) {
        scaffoldMessenger.hideCurrentSnackBar();
      }
      
      await TossErrorDialogs.showBusinessJoinFailed(
        context: context,
        error: e.toString().replaceAll('Exception: ', ''),
        onRetry: () {
          Navigator.of(context).pop();
          _joinCompany(context, ref, code);
        },
      );
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
    _showLoadingSnackBar(scaffoldMessenger, 'Creating store "$name"...');
    
    try {
      
      final storeService = ref.read(enhancedStoreServiceProvider);
      final result = await storeService.createStoreEnhanced(
        storeName: name,
        companyId: company['company_id'] as String,
        storeAddress: address,
        storePhone: phone,
      );
      
      // Dismiss loading
      _dismissSnackBar(scaffoldMessenger);
      
      if (result.isSuccess) {
        // Select the new company and store in app state FIRST
        final appStateNotifier = ref.read(appStateProvider.notifier);
        if (result.companyId != null) {
          await appStateNotifier.setCompanyChoosen(result.companyId!);
        }
        if (result.storeId != null) {
          await appStateNotifier.setStoreChoosen(result.storeId!);
        }
        
        // Close modals (create store modal + drawer)
        if (navigator.canPop()) {
          navigator.pop(); // Close the create store modal
        }
        if (navigator.canPop()) {
          navigator.pop(); // Close the drawer
        }
        
        // Navigate to dashboard with state refresh
        await _navigateToDashboard(context, ref);
        
        // Show success message
        _showSuccessSnackBar(
          scaffoldMessenger,
          'Store "${result.storeName}" created successfully!',
          actionLabel: result.storeCode != null ? 'Share Code' : null,
          onAction: result.storeCode != null ? () {
            _copyToClipboard(context, result.storeCode!, 'Store code');
          } : null,
        );
      } else {
        // Show error via snackbar to avoid context issues
        _showErrorSnackBar(
          scaffoldMessenger,
          result.userMessage ?? 'Failed to create store',
          onRetry: () => _createStore(context, ref, name, company, address, phone),
        );
      }
    } catch (e) {
      // Dismiss loading
      _dismissSnackBar(scaffoldMessenger);
      
      // Show error via snackbar to avoid context issues
      _showErrorSnackBar(
        scaffoldMessenger,
        'Error: ${e.toString().replaceAll('Exception: ', '')}',
        onRetry: () => _createStore(context, ref, name, company, address, phone),
      );
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
                  valueColor: AlwaysStoppedAnimation<Color>(TossColors.white),
                ),
              ),
              SizedBox(width: TossSpacing.space4),
              Text('Joining store...'),
            ],
          ),
          backgroundColor: TossColors.primary,
          duration: Duration(seconds: 30), // Long duration, will be dismissed manually
        ),
      );
    }
    
    try {
      // Import the unified join service
      final unifiedJoinService = ref.read(unifiedJoinServiceProvider);
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
      
      
      // Call the unified join_user_by_code RPC (server determines if it's a store code)
      final result = await unifiedJoinService.joinByCode(
        userId: user.id,
        code: code,
      );
      
      if (result != null && (result['success'] == true || result['store_id'] != null)) {
        
        // Success! Close all modals (input modal + drawer)
        // Safely close up to 2 modals: input modal + drawer
        if (navigator.canPop()) {
          navigator.pop(); // Close the input modal
        }
        if (navigator.canPop()) {
          navigator.pop(); // Close the drawer
        }
        
        // Dismiss loading
        if (scaffoldMessenger != null) {
          scaffoldMessenger.hideCurrentSnackBar();
        }
        
        // Force comprehensive data refresh for immediate UI update
        await Future.delayed(Duration(milliseconds: 300));
        
        // Invalidate all store and company-related providers for real-time update
        ref.invalidate(userCompaniesProvider);
        ref.invalidate(forceRefreshUserCompaniesProvider);
        ref.invalidate(categoriesWithFeaturesProvider);
        ref.invalidate(forceRefreshCategoriesProvider);
        
        // Force fetch fresh data immediately
        try {
          await ref.read(forceRefreshUserCompaniesProvider.future);
          await ref.read(forceRefreshCategoriesProvider.future);
        } catch (e) {
          // Continue even if refresh fails
        }
        
        // Set the company and store as selected
        final appStateNotifier = ref.read(appStateProvider.notifier);
        
        // Set company first if provided
        if (result['company_id'] != null) {
          await appStateNotifier.setCompanyChoosen(result['company_id'] as String);
        }
        
        // Then set the store if provided  
        if (result['store_id'] != null) {
          await appStateNotifier.setStoreChoosen(result['store_id'] as String);
        }
        
        // Navigate to dashboard to show the new store/company immediately
        if (context.mounted) {
          final entityName = (result['store_name'] ?? result['company_name'] ?? result['entity_name'] ?? 'the organization') as String;
          
          // Show success dialog
          await TossSuccessDialogs.showBusinessJoined(
            context: context,
            companyName: entityName,
            roleName: (result['role_assigned'] ?? 'Member') as String?,
            onContinue: () => Navigator.of(context).pop(true),
          );
          
          // Navigate to homepage dashboard to show new data
          context.go('/');
        }
      } else {
        // Show error dialog for invalid response
        if (scaffoldMessenger != null) {
          scaffoldMessenger.hideCurrentSnackBar();
        }
        await TossErrorDialogs.showBusinessJoinFailed(
          context: context,
          error: 'Invalid response from server',
          onRetry: () {
            Navigator.of(context).pop();
            _joinStore(context, ref, code);
          },
        );
        return;
      }
    } catch (e) {
      
      // Dismiss loading and show error dialog
      if (scaffoldMessenger != null) {
        scaffoldMessenger.hideCurrentSnackBar();
      }
      
      await TossErrorDialogs.showBusinessJoinFailed(
        context: context,
        error: e.toString().replaceAll('Exception: ', ''),
        onRetry: () {
          Navigator.of(context).pop();
          _joinCompany(context, ref, code);
        },
      );
    }
  }

  void _showCodesBottomSheet(BuildContext context, dynamic company) {
    final stores = (company['stores'] as List<dynamic>? ?? []);
    final maxHeight = MediaQuery.of(context).size.height * 0.85;
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: TossColors.transparent,
      builder: (context) => Container(
        constraints: BoxConstraints(
          maxHeight: maxHeight,
        ),
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
                color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
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
            
            // Codes List - Now scrollable
            Flexible(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.fromLTRB(
                  TossSpacing.paddingXL,
                  0,
                  TossSpacing.paddingXL,
                  TossSpacing.paddingXL + MediaQuery.of(context).padding.bottom,
                ),
                child: Column(
                  children: [
                    // Company Code
                    _buildCodeItem(
                      context: context,
                      icon: Icons.business,
                      title: (company['company_name'] ?? '') as String,
                      subtitle: 'Company Code',
                      code: (company['company_code'] ?? '') as String,
                      onCopy: () => _copyToClipboard(context, (company['company_code'] ?? '') as String, 'Company code'),
                    ),
                    
                    if (stores.isNotEmpty) ...[
                      const SizedBox(height: TossSpacing.space3),
                      
                      // Store Codes
                      ...stores.map((store) => Padding(
                        padding: const EdgeInsets.only(bottom: TossSpacing.space3),
                        child: _buildCodeItem(
                          context: context,
                          icon: Icons.store_outlined,
                          title: (store['store_name'] ?? '') as String,
                          subtitle: 'Store Code',
                          code: (store['store_code'] ?? '') as String,
                          onCopy: () => _copyToClipboard(context, (store['store_code'] ?? '') as String, 'Store code'),
                        ),
                      )),
                    ],
                  ],
                ),
              ),
            ),
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
            color: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.3),
            borderRadius: BorderRadius.circular(TossBorderRadius.lg),
            border: Border.all(
              color: Theme.of(context).colorScheme.outline.withOpacity(0.1),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: TossSpacing.iconXL,
                height: TossSpacing.iconXL,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
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
                      color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
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
  
  // Helper methods to reduce duplication
  
  /// Show a loading snackbar with consistent styling
  void _showLoadingSnackBar(ScaffoldMessengerState? messenger, String message) {
    if (messenger == null) return;
    
    messenger.showSnackBar(
      SnackBar(
        content: Row(
          children: [
            SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(TossColors.white),
              ),
            ),
            SizedBox(width: TossSpacing.space4),
            Text(message),
          ],
        ),
        backgroundColor: TossColors.primary,
        duration: Duration(seconds: 30),
      ),
    );
  }
  
  /// Show a success snackbar with optional action
  void _showSuccessSnackBar(
    ScaffoldMessengerState? messenger,
    String message, {
    String? actionLabel,
    VoidCallback? onAction,
    Duration? duration,
  }) {
    if (messenger == null) return;
    
    messenger.showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: TossColors.success,
        duration: duration ?? Duration(seconds: 3),
        action: actionLabel != null && onAction != null
          ? SnackBarAction(
              label: actionLabel,
              textColor: TossColors.white,
              onPressed: onAction,
            )
          : null,
      ),
    );
  }
  
  /// Show an error snackbar with optional retry
  void _showErrorSnackBar(
    ScaffoldMessengerState? messenger,
    String message, {
    VoidCallback? onRetry,
    Duration? duration,
  }) {
    if (messenger == null) return;
    
    messenger.showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: TossColors.error,
        duration: duration ?? Duration(seconds: 4),
        action: onRetry != null
          ? SnackBarAction(
              label: 'Retry',
              textColor: TossColors.white,
              onPressed: onRetry,
            )
          : null,
      ),
    );
  }
  
  /// Dismiss current snackbar if any
  void _dismissSnackBar(ScaffoldMessengerState? messenger) {
    messenger?.hideCurrentSnackBar();
  }
  
  /// Copy text to clipboard and show feedback
  void _copyToClipboard(BuildContext context, String text, String label) {
    Clipboard.setData(ClipboardData(text: text));
    final messenger = ScaffoldMessenger.maybeOf(context);
    _showSuccessSnackBar(
      messenger,
      '$label "$text" copied!',
      duration: Duration(seconds: 2),
    );
  }
  
  /// Navigate to dashboard with proper state refresh
  Future<void> _navigateToDashboard(BuildContext context, WidgetRef ref) async {
    debugPrint('🔄 [NavigateToDashboard] Starting dashboard navigation with data refresh...');
    
    // First expire the cache to ensure fresh data
    await ref.read(sessionManagerProvider.notifier).expireCache();
    
    // Invalidate providers to force refresh
    debugPrint('🔄 [NavigateToDashboard] Invalidating all data providers...');
    ref.invalidate(userCompaniesProvider);
    ref.invalidate(forceRefreshUserCompaniesProvider);
    ref.invalidate(categoriesWithFeaturesProvider);
    ref.invalidate(forceRefreshCategoriesProvider);
    
    // Force immediate fetch of fresh data
    // This ensures the new company/store is included
    debugPrint('🔄 [NavigateToDashboard] Forcing immediate data fetch...');
    try {
      await ref.read(forceRefreshUserCompaniesProvider.future);
      await ref.read(forceRefreshCategoriesProvider.future);
      debugPrint('✅ [NavigateToDashboard] Fresh data fetched successfully');
    } catch (e) {
      // Continue even if fetch fails - navigation should still work
      debugPrint('❌ [NavigateToDashboard] Error fetching fresh data: $e');
    }
    
    // Navigate
    debugPrint('🔄 [NavigateToDashboard] Navigating to homepage...');
    context.go('/');
  }
}