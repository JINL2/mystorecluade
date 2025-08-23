import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/themes/toss_colors.dart';
import '../../../../core/themes/toss_text_styles.dart';
import '../../../../core/themes/toss_spacing.dart';
import '../../../../core/themes/toss_animations.dart';
import '../../../providers/app_state_provider.dart';
import '../../../providers/auth_provider.dart';
import '../../../widgets/toss/toss_primary_button.dart';
import '../../../widgets/toss/toss_dropdown.dart';
import '../../../../data/services/company_service.dart';
import '../providers/homepage_providers.dart';
import '../../../../data/services/store_service.dart';

class ModernDrawer extends ConsumerStatefulWidget {
  const ModernDrawer({
    super.key,
    required this.userData,
  });

  final dynamic userData;

  @override
  ConsumerState<ModernDrawer> createState() => _ModernDrawerState();
}

class _ModernDrawerState extends ConsumerState<ModernDrawer> {
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

    return Drawer(
      backgroundColor: TossColors.gray50,
      width: MediaQuery.of(context).size.width * 0.85, // 85% of screen width
      child: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(context, userData),
            
            // Companies Section
            Expanded(
              child: _buildCompaniesSection(context, ref, userData, selectedCompany),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, dynamic userData) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
      decoration: BoxDecoration(
        color: TossColors.white,  // White header for contrast against gray background
        border: Border(
          bottom: BorderSide(color: Theme.of(context).colorScheme.outline.withOpacity(0.2), width: 1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile Section
          Row(
            children: [
              // Profile Image
              CircleAvatar(
                radius: 32,
                backgroundImage: (userData['profile_image'] ?? '').isNotEmpty
                    ? NetworkImage(userData['profile_image'])
                    : null,
                backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                child: (userData['profile_image'] ?? '').isEmpty
                    ? Text(
                        (userData['user_first_name'] ?? '').isNotEmpty ? userData['user_first_name'][0] : 'U',
                        style: TossTextStyles.h2.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      )
                    : null,
              ),
            ],
          ),
          const SizedBox(height: 16),
          // User Info
          Text(
            '${userData['user_first_name'] ?? ''} ${userData['user_last_name'] ?? ''}',
            style: TossTextStyles.h3.copyWith(
              fontWeight: FontWeight.w700,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${userData['company_count'] ?? 0} companies',
            style: TossTextStyles.caption.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontSize: 14,
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
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
          child: Row(
            children: [
              Container(
                width: 4,
                height: 20,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 12),
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
            padding: const EdgeInsets.symmetric(horizontal: 16),
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
              
              const SizedBox(height: 80), // Space for bottom button
            ],
          ),
        ),
        
        // Create Company Button at bottom
        Container(
          padding: EdgeInsets.fromLTRB(
            TossSpacing.space4,
            TossSpacing.space4,
            TossSpacing.space4,
            TossSpacing.space4 + MediaQuery.of(context).padding.bottom,
          ),
          decoration: BoxDecoration(
            color: TossColors.white,  // White footer for consistency
            border: Border(
              top: BorderSide(
                color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
                width: 1,
              ),
            ),
          ),
          child: TossPrimaryButton(
            text: 'Create Company',
            leadingIcon: Icon(Icons.add, size: 20),
            onPressed: () => _showCompanyActionsBottomSheet(context, ref),
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
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: TossColors.white,  // White cards for contrast against gray background
        borderRadius: BorderRadius.circular(12),
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
          // Company Header
          InkWell(
            onTap: () async {
              // Toggle expand/collapse
              setState(() {
                _expandedCompanies[company['company_id']] = !(_expandedCompanies[company['company_id']] ?? isSelected);
              });
              
              // Select company and clear store selection (for headquarters view)
              await ref.read(appStateProvider.notifier).setCompanyChoosen(company['company_id']);
              await ref.read(appStateProvider.notifier).setStoreChoosen(''); // Clear store selection
              
              // Scroll to top when company is selected
              if (_scrollController.hasClients) {
                _scrollController.animateTo(
                  0.0,
                  duration: TossAnimations.slow,
                  curve: Curves.easeOutCubic,
                );
              }
              
              // Close drawer after selection
              if (context.mounted) {
                Navigator.of(context).pop();
              }
            },
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Company Icon
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: isSelected 
                        ? Theme.of(context).colorScheme.primary 
                        : Theme.of(context).colorScheme.surfaceVariant,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.business,
                      color: isSelected 
                        ? Colors.white
                        : Theme.of(context).colorScheme.onSurfaceVariant,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  
                  // Company Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          company['company_name'] ?? '',
                          style: TossTextStyles.body.copyWith(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            Text(
                              '${(company['stores'] as List<dynamic>? ?? []).length} stores',
                              style: TossTextStyles.caption.copyWith(
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '•',
                              style: TossTextStyles.caption.copyWith(
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              company['role']?['role_name'] ?? '',
                              style: TossTextStyles.caption.copyWith(
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  
                  // Expand Icon
                  Icon(
                    (_expandedCompanies[company['company_id']] ?? isSelected) ? Icons.expand_less : Icons.expand_more,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
          
          // Stores Section (show if expanded)
          if (_expandedCompanies[company['company_id']] ?? isSelected) ...[
            // Stores Container
            Container(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Store Items - deduplicate by store ID
                  ...() {
                    final stores = company['stores'] as List<dynamic>? ?? [];
                    for (final store in stores) {
                    }
                    
                    final uniqueStores = <String, dynamic>{};
                    for (final store in stores) {
                      if (uniqueStores.containsKey(store['store_id'])) {
                      }
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
      margin: const EdgeInsets.only(bottom: 6, left: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () async {
            // Set both company and store when selecting a store
            await ref.read(appStateProvider.notifier).setCompanyChoosen(company['company_id']);
            await ref.read(appStateProvider.notifier).setStoreChoosen(store['store_id']);
            if (context.mounted) {
              Navigator.of(context).pop();
            }
          },
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: isSelected 
                ? Theme.of(context).colorScheme.surfaceVariant 
                : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                // Store Icon
                Icon(
                  Icons.store_outlined,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  size: 20,
                ),
                const SizedBox(width: 12),
                
                // Store Name
                Expanded(
                  child: Text(
                    store['store_name'] ?? '',
                    style: TossTextStyles.body.copyWith(
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                      color: Theme.of(context).colorScheme.onSurface,
                      fontSize: 14,
                    ),
                  ),
                ),
                
                // Check icon if selected
                if (isSelected)
                  Icon(
                    Icons.check,
                    color: Theme.of(context).colorScheme.primary,
                    size: 18,
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
      margin: const EdgeInsets.only(top: 4, left: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _showStoreActionsBottomSheet(context, ref, company),
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.add,
                  color: Theme.of(context).colorScheme.primary,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Text(
                  'Add store',
                  style: TossTextStyles.body.copyWith(
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 14,
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
      margin: const EdgeInsets.only(top: 8, left: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _showCodesBottomSheet(context, company),
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: TossColors.white,  // White background for better contrast
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.qr_code_2,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Text(
                  'View codes',
                  style: TossTextStyles.body.copyWith(
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    fontSize: 14,
                  ),
                ),
                const Spacer(),
                Icon(
                  Icons.chevron_right,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  size: 20,
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
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(top: 8, bottom: 24),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
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
            
            const SizedBox(height: 32),
            
            // Options
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
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
                  
                  const SizedBox(height: 16),
                  
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
          ],
        ),
      ),
    );
  }

  void _showStoreActionsBottomSheet(BuildContext context, WidgetRef ref, dynamic company) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(top: 8, bottom: 24),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
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
            
            const SizedBox(height: 32),
            
            // Options
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
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
                  
                  const SizedBox(height: 16),
                  
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
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: Theme.of(context).colorScheme.primary,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
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
                    const SizedBox(height: 2),
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
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleCreateCompany(BuildContext context, WidgetRef ref) {
    Navigator.of(context).pop();
    _showCreateCompanyBottomSheet(context, ref);
  }

  void _handleJoinCompany(BuildContext context, WidgetRef ref) {
    Navigator.of(context).pop();
    _showInputBottomSheet(
      context,
      ref,
      title: 'Join Company',
      subtitle: 'Enter company invite code',
      inputLabel: 'Company Code',
      buttonText: 'Join Company',
      onSubmit: (code) => _joinCompany(context, ref, code),
    );
  }

  void _handleCreateStore(BuildContext context, WidgetRef ref, dynamic company) {
    Navigator.of(context).pop();
    _showCreateStoreBottomSheet(context, ref, company);
  }

  void _handleJoinStore(BuildContext context, WidgetRef ref) {
    Navigator.of(context).pop();
    _showInputBottomSheet(
      context,
      ref,
      title: 'Join Store',
      subtitle: 'Enter store invite code',
      inputLabel: 'Store Code',
      buttonText: 'Join Store',
      onSubmit: (code) => _joinStore(context, ref, code),
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
      backgroundColor: Colors.transparent,
      builder: (context) => Padding(
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
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(top: 8, bottom: 24),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
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
              
              const SizedBox(height: 32),
              
              // Input Form
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      TextField(
                        controller: controller,
                        decoration: InputDecoration(
                          labelText: inputLabel,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 24),
                      
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            if (controller.text.trim().isNotEmpty) {
                              Navigator.of(context).pop();
                              onSubmit(controller.text.trim());
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).colorScheme.primary,
                            foregroundColor: Theme.of(context).colorScheme.onPrimary,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
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
      backgroundColor: Colors.transparent,
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
                  margin: const EdgeInsets.only(top: 8, bottom: 24),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                
                // Header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
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
                
                const SizedBox(height: 32),
                
                // Form
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
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
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
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
                                  borderRadius: BorderRadius.circular(12),
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
                                  borderRadius: BorderRadius.circular(12),
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
      backgroundColor: Colors.transparent,
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
                  margin: const EdgeInsets.only(top: 8, bottom: 24),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                
                // Header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
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
                
                const SizedBox(height: 32),
                
                // Form
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
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
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
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
  
  // Updated create company method with proper parameters
  void _createCompany(
    BuildContext context,
    WidgetRef ref,
    String name,
    String companyTypeId,
    String baseCurrencyId,
  ) async {
    // Show loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: Container(
          padding: EdgeInsets.all(TossSpacing.space4),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(
                color: Theme.of(context).colorScheme.primary,
              ),
              SizedBox(height: TossSpacing.space3),
              Text(
                'Creating company...',
                style: TossTextStyles.body.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
      ),
    );
    
    try {
      final companyService = ref.read(companyServiceProvider);
      final companyDetails = await companyService.createCompany(
        companyName: name,
        companyTypeId: companyTypeId,
        baseCurrencyId: baseCurrencyId,
      );
      
      // Close loading dialog
      if (context.mounted) {
        Navigator.of(context).pop();
      }
      
      if (companyDetails != null) {
        // Extract company ID from the response
        final companyId = companyDetails['company_id'] as String;
        
        // No longer marking refresh needed - will refresh directly
        final appStateNotifier = ref.read(appStateProvider.notifier);
        
        // Force refresh from API using force refresh providers
        try {
          // First invalidate to ensure fresh fetch
          ref.invalidate(forceRefreshUserCompaniesProvider);
          ref.invalidate(forceRefreshCategoriesProvider);
          
          // Then fetch fresh data
          await ref.read(forceRefreshUserCompaniesProvider.future);
          await ref.read(forceRefreshCategoriesProvider.future);
        } catch (e) {
        }
        
        // Invalidate regular providers to show the new data
        ref.invalidate(userCompaniesProvider);
        ref.invalidate(categoriesWithFeaturesProvider);
        
        // Select the new company after data is refreshed
        await appStateNotifier.setCompanyChoosen(companyId);
        
        // Data has been refreshed
        
        if (context.mounted) {
          // Close all bottom sheets and dialogs
          Navigator.of(context).pop(); // Close bottom sheet
          Navigator.of(context).pop(); // Close drawer
          
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Company "$name" created!'),
              backgroundColor: Theme.of(context).colorScheme.primary,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
          );
        }
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Failed to create company. Please try again.'),
              backgroundColor: Theme.of(context).colorScheme.error,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
          );
        }
      }
    } catch (e) {
      // Close loading dialog
      if (context.mounted) {
        Navigator.of(context).pop();
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Theme.of(context).colorScheme.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        );
      }
    }
  }

  void _joinCompany(BuildContext context, WidgetRef ref, String code) {
    // Will refresh data after joining company
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Joining company with code: $code'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
    );
    // TODO: Implement API call to join company by code
  }

  void _createStore(
    BuildContext context, 
    WidgetRef ref, 
    String name, 
    dynamic company,
    String? address,
    String? phone,
  ) async {
    // Show loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: Container(
          padding: EdgeInsets.all(TossSpacing.space4),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(
                color: Theme.of(context).colorScheme.primary,
              ),
              SizedBox(height: TossSpacing.space3),
              Text(
                'Creating store...',
                style: TossTextStyles.body.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
      ),
    );
    
    try {
      final storeService = ref.read(storeServiceProvider);
      final storeResult = await storeService.createStore(
        storeName: name,
        companyId: company['company_id'],
        storeAddress: address,
        storePhone: phone,
      );
      
      // Close loading dialog
      if (context.mounted) {
        Navigator.of(context).pop();
      }
      
      if (storeResult != null) {
        // Extract store_id from the result
        final storeId = storeResult['store_id'] as String;
        
        // No longer marking refresh needed - will refresh directly
        final appStateNotifier = ref.read(appStateProvider.notifier);
        
        // Force refresh from API using force refresh providers
        try {
          // First invalidate to ensure fresh fetch
          ref.invalidate(forceRefreshUserCompaniesProvider);
          ref.invalidate(forceRefreshCategoriesProvider);
          
          // Then fetch fresh data
          await ref.read(forceRefreshUserCompaniesProvider.future);
          await ref.read(forceRefreshCategoriesProvider.future);
        } catch (e) {
        }
        
        // Invalidate regular providers to show the new data
        ref.invalidate(userCompaniesProvider);
        ref.invalidate(categoriesWithFeaturesProvider);
        
        // Select the new store after data is refreshed
        await appStateNotifier.setStoreChoosen(storeId);
        
        // Data has been refreshed
        
        if (context.mounted) {
          // Close all bottom sheets and dialogs
          Navigator.of(context).pop(); // Close bottom sheet
          Navigator.of(context).pop(); // Close drawer
          
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Store "$name" created!'),
              backgroundColor: Theme.of(context).colorScheme.primary,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
          );
        }
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Failed to create store. Please try again.'),
              backgroundColor: Theme.of(context).colorScheme.error,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
          );
        }
      }
    } catch (e) {
      // Close loading dialog
      if (context.mounted) {
        Navigator.of(context).pop();
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Theme.of(context).colorScheme.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        );
      }
    }
  }

  void _joinStore(BuildContext context, WidgetRef ref, String code) {
    // Will refresh data after joining store
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Joining store with code: $code'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
    );
    // TODO: Implement API call to join store by code
  }

  void _copyToClipboard(BuildContext context, String text, String label) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$label copied to clipboard'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showCodesBottomSheet(BuildContext context, dynamic company) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(top: 8, bottom: 24),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
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
            
            const SizedBox(height: 16),
            
            // Codes List
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
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
                  
                  const SizedBox(height: 12),
                  
                  // Store Codes
                  ...(company['stores'] as List<dynamic>? ?? []).map((store) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
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
      color: Colors.transparent,
      child: InkWell(
        onTap: onCopy,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Theme.of(context).colorScheme.outline.withOpacity(0.1),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  color: Theme.of(context).colorScheme.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
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
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TossTextStyles.caption.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        fontSize: 12,
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
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.copy_outlined,
                          size: 12,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Copy',
                          style: TossTextStyles.caption.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: 11,
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