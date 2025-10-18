import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinance_improved/core/themes/toss_colors.dart';
import 'package:myfinance_improved/core/themes/toss_text_styles.dart';
import 'package:myfinance_improved/core/themes/toss_spacing.dart';
import 'package:myfinance_improved/core/themes/toss_border_radius.dart';
import 'package:myfinance_improved/core/themes/toss_design_system.dart';
import 'package:myfinance_improved/core/themes/toss_shadows.dart';
import 'package:myfinance_improved/core/themes/toss_icons.dart';
import 'package:myfinance_improved/presentation/widgets/common/toss_app_bar.dart';
import 'package:myfinance_improved/presentation/widgets/common/toss_scaffold.dart';
import 'package:myfinance_improved/presentation/widgets/common/toss_loading_view.dart';
import 'package:myfinance_improved/presentation/widgets/common/toss_error_view.dart';
import 'package:myfinance_improved/presentation/widgets/common/toss_empty_view.dart';
import 'package:myfinance_improved/presentation/widgets/toss/toss_refresh_indicator.dart';
import 'package:myfinance_improved/presentation/widgets/toss/toss_tab_bar.dart';
import '../../../../../core/navigation/safe_navigation.dart';
import 'package:myfinance_improved/core/themes/index.dart';

// Import main app state provider  
import '../../../../providers/app_state_provider.dart';

// Updated imports to use new layer architecture
import '../providers/template_provider.dart';
import '../providers/states/template_state.dart';
import '../../domain/providers/repository_providers.dart'; // ✅ Changed from data to domain
import '../../domain/constants/permission_constants.dart';

// Import global entity providers (as used in original backup files)
import '../../../../providers/entities/account_provider.dart';
import '../../../../providers/entities/cash_location_provider.dart';

// Import migrated UI components from new presentation layer
import '../modals/add_template_bottom_sheet.dart';
import '../modals/template_usage_bottom_sheet.dart';
import '../modals/template_filter_sheet.dart';

class TransactionTemplatePage extends ConsumerStatefulWidget {
  const TransactionTemplatePage({super.key});

  @override
  ConsumerState<TransactionTemplatePage> createState() => _TransactionTemplatePageState();
}

class _TransactionTemplatePageState extends ConsumerState<TransactionTemplatePage>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  bool? _lastHasAdminPermission;
  
  // Local state for immediate UI updates
  List<Map<String, dynamic>> _optimisticTemplates = [];
  bool _hasOptimisticUpdates = false;
  
  @override
  void initState() {
    super.initState();

    // 🔄 AUTO-LOAD: Load templates after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final appState = ref.read(appStateProvider);
      if (appState.companyChoosen.isNotEmpty && appState.storeChoosen.isNotEmpty) {
        print('🔵 DEBUG: initState - Loading templates for company=${appState.companyChoosen}, store=${appState.storeChoosen}');
        ref.read(templateProvider.notifier).loadTemplates(
          companyId: appState.companyChoosen,
          storeId: appState.storeChoosen,
        );
      } else {
        print('⚠️ DEBUG: initState - Company or Store not selected yet');
      }
    });
  }
  
  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  bool _hasAdminPermission(WidgetRef ref) {
    // Use page state providers for template-specific permissions
    print('🔐 [TransactionTemplatePage] Checking admin permission...');
    final hasPermission = ref.watch(canDeleteTemplatesProvider);
    print('🔐 [TransactionTemplatePage] Admin permission result: $hasPermission');
    return hasPermission;
  }

  void _updateTabController(bool hasAdminPermission) {
    print('🔐 [TransactionTemplatePage] _updateTabController called with hasAdminPermission: $hasAdminPermission');
    print('🔐 [TransactionTemplatePage] _lastHasAdminPermission: $_lastHasAdminPermission');

    if (_lastHasAdminPermission != hasAdminPermission) {
      print('🔐 [TransactionTemplatePage] Permission changed! Creating new TabController with ${hasAdminPermission ? 2 : 1} tabs');
      _tabController?.dispose();
      _tabController = TabController(
        length: hasAdminPermission ? 2 : 1,
        vsync: this,
      );
      _lastHasAdminPermission = hasAdminPermission;
    } else {
      print('🔐 [TransactionTemplatePage] No permission change, keeping existing TabController');
    }
  }

  @override
  Widget build(BuildContext context) {
    final companyChoosen = ref.watch(appStateProvider).companyChoosen;
    final storeChoosen = ref.watch(appStateProvider).storeChoosen;

    // 🔄 REACTIVE-LOAD: Reload templates when company/store changes
    ref.listen(
      appStateProvider.select((s) => '${s.companyChoosen}_${s.storeChoosen}'),
      (prev, next) {
        if (companyChoosen.isNotEmpty && storeChoosen.isNotEmpty) {
          print('🔵 DEBUG: build.listen - Company/Store changed, reloading templates');
          ref.read(templateProvider.notifier).loadTemplates(
            companyId: companyChoosen,
            storeId: storeChoosen,
          );
        }
      },
    );

    // Watch the filtered templates provider from new data layer
    final templatesAsync = ref.watch(filteredTemplatesProvider);
    final currentFilter = ref.watch(templateFilterProvider);

    // ⚡ PERFORMANCE: Preload commonly used data to reduce bottom sheet loading time
    if (companyChoosen.isNotEmpty && storeChoosen.isNotEmpty) {
      // Preload cash locations and counterparties for faster bottom sheet opening
      ref.watch(currentCashLocationsProvider);
      // ref.watch(counterpartiesProvider);
    }
    
    // Check if user has admin permission using new state providers
    final hasAdminPermission = _hasAdminPermission(ref);
    
    // Initialize or update tab controller
    if (_tabController == null) {
      _tabController = TabController(
        length: hasAdminPermission ? 2 : 1,
        vsync: this,
      );
      _lastHasAdminPermission = hasAdminPermission;
    } else {
      _updateTabController(hasAdminPermission);
    }

    return TossScaffold(
      backgroundColor: TossColors.gray100,
      appBar: TossAppBar(
        title: 'Transaction Templates',
        leading: IconButton(
          icon: Icon(TossIcons.back, color: TossColors.textPrimary),
          onPressed: () => context.safePop(),
        ),
        actions: [
          _buildFilterButton(currentFilter),
        ],
      ),
      body: templatesAsync.when(
        data: (templates) {
          // Combine provider data with optimistic updates
          final displayTemplates = _hasOptimisticUpdates ? _optimisticTemplates : templates;
          
          
          if (companyChoosen.isEmpty || storeChoosen.isEmpty) {
            return Center(
              child: Container(
                padding: EdgeInsets.all(TossSpacing.space6),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      TossIcons.business,
                      size: TossSpacing.space16,
                      color: TossColors.gray400,
                    ),
                    SizedBox(height: TossSpacing.space4),
                    Text(
                      'No Company or Store Selected',
                      style: TossTextStyles.h3.copyWith(
                        color: TossColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: TossSpacing.space2),
                    Text(
                      'Please select a company and store from the menu',
                      style: TossTextStyles.body.copyWith(
                        color: TossColors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }

          // Filter templates based on permission
          final generalTemplates = displayTemplates.where((template) {
            final permission = template['permission']?.toString() ?? '';
            return permission != PermissionIds.adminPermission;
          }).toList();

          final adminTemplates = displayTemplates.where((template) {
            final permission = template['permission']?.toString() ?? '';
            return permission == PermissionIds.adminPermission;
          }).toList();

          return Column(
            children: [
              // Tab Bar - show Admin tab only if user has permission
              if (_tabController != null)
                TossTabBar(
                  tabs: hasAdminPermission ? const ['General', 'Admin'] : const ['General'],
                  controller: _tabController!,
                  padding: EdgeInsets.symmetric(horizontal: TossSpacing.space4),
                ),
              // Filter Status Indicator
              if (currentFilter.hasActiveFilter)
                _buildFilterStatusIndicator(currentFilter),
              // Tab Bar View
              Expanded(
                child: Stack(
                  children: [
                    if (_tabController != null)
                      TabBarView(
                        controller: _tabController!,
                        children: hasAdminPermission
                          ? [
                              // General Tab
                              _buildTemplateList(generalTemplates),
                              // Admin Tab
                              _buildTemplateList(adminTemplates),
                            ]
                          : [
                              // Only General Tab
                              _buildTemplateList(generalTemplates),
                            ],
                      ),
                    // Floating Action Button
                    if (companyChoosen.isNotEmpty && storeChoosen.isNotEmpty)
                      Positioned(
                        bottom: TossSpacing.space6,
                        right: TossSpacing.space6,
                        child: _buildFloatingActionButton(context),
                      ),
                  ],
                ),
              ),
            ],
          );
        },
        loading: () => const TossLoadingView(
          message: 'Loading templates...',
        ),
        error: (error, stack) => TossErrorView(
          title: 'Failed to load templates',
          error: error,
          onRetry: () {
            ref.invalidate(filteredTemplatesProvider);
          },
        ),
      ),
    );
  }

  // Build template list widget
  Widget _buildTemplateList(List<Map<String, dynamic>> templates) {
    if (templates.isEmpty) {
      return TossEmptyView(
        icon: Icon(
          TossIcons.receipt,
          size: TossSpacing.space16,
          color: TossColors.gray400,
        ),
        title: 'No Templates Found',
        description: 'Create your first transaction template to get started',
      );
    }

    return TossRefreshIndicator(
      onRefresh: () async {
        // Refresh using new repository pattern
        final refreshFunction = ref.read(refreshTemplatesProvider);
        await refreshFunction();
      },
      child: ListView.builder(
        padding: EdgeInsets.all(TossSpacing.space4),
        itemCount: templates.length,
        itemBuilder: (context, index) {
          final template = templates[index];
          return _buildTemplateCard(context, template);
        },
      ),
    );
  }

  Widget _buildFloatingActionButton(BuildContext context) {
    return Container(
      width: TossDesignSystem.fabSize,
      height: TossDesignSystem.fabSize,
      decoration: BoxDecoration(
        color: TossColors.primary,
        borderRadius: BorderRadius.circular(TossDesignSystem.fabSize / 2),
        boxShadow: TossShadows.fab,
      ),
      child: Material(
        color: TossColors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(TossDesignSystem.fabSize / 2),
          onTap: () {
            AddTemplateBottomSheet.show(context);
          },
          child: Icon(
            TossIcons.add,
            color: TossColors.white,
            size: TossSpacing.space7,
          ),
        ),
      ),
    );
  }

  Widget _buildFilterButton(TemplateFilterState currentFilter) {
    final hasActiveFilters = currentFilter.hasActiveFilter;
    
    return Stack(
      clipBehavior: Clip.none,
      children: [
        IconButton(
          icon: Icon(
            TossIcons.filter,
            color: hasActiveFilters ? TossColors.primary : TossColors.gray600,
            size: TossSpacing.iconSM,
          ),
          onPressed: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: TossColors.transparent,
              builder: (context) => const TemplateFilterSheet(),
            );
          },
        ),
        if (hasActiveFilters)
          Positioned(
            top: 8,
            right: 8,
            child: Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: TossColors.primary,
                shape: BoxShape.circle,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildFilterStatusIndicator(TemplateFilterState filter) {
    final activeFilters = <String>[];
    
    if (filter.searchText.isNotEmpty) {
      activeFilters.add('Search: "${filter.searchText}"');
    }
    
    if (filter.showMyTemplatesOnly) {
      activeFilters.add('My Templates');
    }
    
    if (filter.visibilityFilter != 'all') {
      activeFilters.add(filter.visibilityFilter.toUpperCase());
    }
    
    if (filter.statusFilter != 'all') {
      activeFilters.add(filter.statusFilter.toUpperCase());
    }

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: TossSpacing.space4,
        vertical: TossSpacing.space2,
      ),
      padding: EdgeInsets.all(TossSpacing.space3),
      decoration: BoxDecoration(
        color: TossColors.primarySurface,
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
        border: Border.all(color: TossColors.primary.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Icon(
            TossIcons.filter,
            size: TossSpacing.iconXS,
            color: TossColors.primary,
          ),
          const SizedBox(width: TossSpacing.space2),
          Expanded(
            child: Text(
              'Filters: ${activeFilters.take(2).join(', ')}${activeFilters.length > 2 ? ' (+${activeFilters.length - 2} more)' : ''}',
              style: TossTextStyles.caption.copyWith(
                color: TossColors.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          InkWell(
            onTap: () {
              ref.read(templateFilterProvider.notifier).clearFilter();
            },
            borderRadius: BorderRadius.circular(TossSpacing.iconXS),
            child: Padding(
              padding: EdgeInsets.all(TossSpacing.space1),
              child: Icon(
                TossIcons.close,
                size: TossSpacing.iconXS,
                color: TossColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTemplateCard(BuildContext context, Map<String, dynamic> template) {
    return Consumer(
      builder: (context, ref, child) {
        final hasAdminPermission = _hasAdminPermission(ref);
        final isAdminTemplate = template['permission']?.toString() == PermissionIds.adminPermission;
        final canDelete = hasAdminPermission || !isAdminTemplate; // Admin can delete anything, users can only delete general templates
        final usageCount = template['usage_count'] as int? ?? 0;
        final isFrequentlyUsed = usageCount > 3; // Lower threshold for star display
        
        return TossDesignSystem.buildCard(
          margin: EdgeInsets.only(bottom: TossSpacing.space4),
          padding: EdgeInsets.all(TossSpacing.space4),
          onTap: () {
            // Check if this is an admin template and user lacks permission
            if (isAdminTemplate && !hasAdminPermission) {
              _showUnauthorizedAccessNotification(context);
              return;
            }
            // Track template selection before showing usage sheet
            _trackTemplateSelection(template);
            
            // Always use modal bottom sheet for consistent design
            TemplateUsageBottomSheet.show(context, template);
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with title and delete button
              Row(
                children: [
                  // Template icon
                  Container(
                    width: TossSpacing.iconXL,
                    height: TossSpacing.iconXL,
                    decoration: BoxDecoration(
                      color: TossColors.primarySurface,
                      borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                    ),
                    child: Icon(
                      TossIcons.receipt,
                      color: TossColors.primary,
                      size: TossSpacing.iconSM,
                    ),
                  ),
                  SizedBox(width: TossSpacing.space3),
                  
                  // Template name with star and admin badge
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            // Star indicator for frequently used templates
                            if (isFrequentlyUsed) ...[
                              Icon(
                                TossIcons.star,
                                size: TossSpacing.iconXS,
                                color: TossColors.warning,
                              ),
                              SizedBox(width: TossSpacing.space1),
                            ],
                            Expanded(
                              child: Text(
                                (template['name'] as String?) ?? 'Unnamed Template',
                                style: TossTextStyles.bodyLarge.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: TossColors.textPrimary,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (isAdminTemplate) ...[
                              SizedBox(width: TossSpacing.space1),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: TossSpacing.space1,
                                  vertical: TossSpacing.space1 / 2,
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: TossColors.border,
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(TossBorderRadius.xs),
                                ),
                                child: Text(
                                  'ADMIN',
                                  style: TossTextStyles.small.copyWith(
                                    color: TossColors.textSecondary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                        // Transaction flow (always show)
                        Text(
                          _buildTransactionFlow(template),
                          style: TossTextStyles.caption.copyWith(
                            color: TossColors.textSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Delete button
                  if (canDelete)
                    IconButton(
                      icon: Icon(
                        TossIcons.delete,
                        color: TossColors.error,
                        size: TossSpacing.iconSM,
                      ),
                      onPressed: () {
                        _showDeleteConfirmationDialog(context, ref, template);
                      },
                    ),
                ],
              ),
              
              SizedBox(height: TossSpacing.space2),
              
              // Template details
              _buildTemplateDetails(template),
              
              // Template description (if exists)
              _buildTemplateDescription(template),
            ],
          ),
        );
      },
    );
  }

  void _showUnauthorizedAccessNotification(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              TossIcons.lock,
              color: TossColors.white,
              size: TossSpacing.iconSM,
            ),
            SizedBox(width: TossSpacing.space2),
            Expanded(
              child: Text(
                'Admin permission required to access this template',
                style: TossTextStyles.body.copyWith(
                  color: TossColors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: TossColors.warning,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(TossSpacing.space4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(TossBorderRadius.md),
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  String _buildTransactionFlow(Map<String, dynamic> template) {
    final data = template['data'] as List? ?? [];
    if (data.isEmpty) return 'Empty template';
    
    final accounts = <String>[];
    for (var entry in data) {
      final accountName = entry['account_name'] as String? ?? 'Unknown';
      final categoryTag = entry['category_tag'] as String? ?? '';
      
      // Create display name with simple category indicator
      String displayName = accountName;
      if (categoryTag == 'cash') {
        displayName = '💰 $accountName';
      } else if (categoryTag == 'payable' || categoryTag == 'receivable') {
        displayName = '👤 $accountName';
      } else {
        displayName = accountName;
      }
      
      if (!accounts.contains(displayName)) {
        accounts.add(displayName);
      }
    }
    
    return accounts.join(' → ');
  }

  Widget _buildTemplateDetails(Map<String, dynamic> template) {
    // Analyze template data
    final data = template['data'] as List? ?? [];
    bool hasCash = false;
    bool hasCounterparty = false;
    String? cashLocationName;
    String? counterpartyName;
    String? counterpartyCashLocationName;
    String? counterpartyId;
    
    for (var entry in data) {
      final categoryTag = entry['category_tag'] as String? ?? '';
      
      // Check for cash account
      if (categoryTag == 'cash') {
        hasCash = true;
        // Look for cash location name in entry or tags
        cashLocationName ??= entry['cash_location_name'] as String?;
        if (cashLocationName == null || cashLocationName.isEmpty) {
          // Try to get from tags
          final tags = template['tags'] as Map? ?? {};
          final cashLocations = tags['cash_locations'] as List? ?? [];
          if (cashLocations.isNotEmpty) {
            cashLocationName = cashLocations.first as String?;
          }
        }
      }
      
      // Check for counterparty info
      if (categoryTag == 'payable' || categoryTag == 'receivable') {
        hasCounterparty = true;
        counterpartyName ??= entry['counterparty_name'] as String?;
        counterpartyId ??= entry['counterparty_id'] as String?;
      }
      
      // Check for counterparty cash location name (internal transfers)
      final entryCounterpartyCashLocName = entry['counterparty_cash_location_name'] as String?;
      if (entryCounterpartyCashLocName != null && entryCounterpartyCashLocName != 'none') {
        counterpartyCashLocationName = entryCounterpartyCashLocName;
      }
    }
    
    // Check template-level counterparty info
    counterpartyName ??= template['counterparty_name'] as String?;
    counterpartyId ??= template['counterparty_id'] as String?;
    
    // Try to get counterparty cash location name from template level
    if (counterpartyCashLocationName == null) {
      final tags = template['tags'] as Map? ?? {};
      counterpartyCashLocationName = tags['counterparty_cash_location_name'] as String?;
    }
    
    // Build info rows for cleaner organization
    final infoRows = <Widget>[];
    
    // Check if MY cash and THEIR cash are the same location
    final bool sameCashLocation = cashLocationName != null && 
                                  counterpartyCashLocationName != null && 
                                  cashLocationName == counterpartyCashLocationName;
    
    // Define colors for consistency
    final myColor = TossColors.primary; // Blue for MY side
    final theirColor = TossColors.warning; // Orange for THEIR side
    
    // Row 1: My cash location (more prominent display)
    if (hasCash && cashLocationName != null) {
      infoRows.add(
        Row(
          children: [
            Icon(TossIcons.bank, size: TossSpacing.iconXS, color: myColor),
            SizedBox(width: TossSpacing.space1),
            Text(
              'My Cash: ',
              style: TossTextStyles.caption.copyWith(
                color: TossColors.gray500,
                fontWeight: FontWeight.w500,
              ),
            ),
            Flexible(
              child: Text(
                cashLocationName,
                style: TossTextStyles.caption.copyWith(
                  color: TossColors.gray700,
                  fontWeight: FontWeight.w600,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      );
    }
    
    // Row 2: Counterparty name (use THEIR color for consistency)
    if (hasCounterparty && counterpartyName != null && counterpartyName != 'none') {
      infoRows.add(
        Row(
          children: [
            Icon(TossIcons.person, size: TossSpacing.iconXS, color: theirColor),
            SizedBox(width: TossSpacing.space1),
            Text(
              'Party: ',
              style: TossTextStyles.caption.copyWith(
                color: TossColors.gray500,
                fontWeight: FontWeight.w500,
              ),
            ),
            Flexible(
              child: Text(
                counterpartyName,
                style: TossTextStyles.caption.copyWith(
                  color: TossColors.gray700,
                  fontWeight: FontWeight.w600,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      );
    }
    
    // Row 3: Counterparty cash location (use same icon as MY cash if same location)
    if (counterpartyCashLocationName != null && counterpartyCashLocationName != 'none') {
      infoRows.add(
        Row(
          children: [
            Icon(
              sameCashLocation ? TossIcons.bank : TossIcons.store, 
              size: TossSpacing.iconXS, 
              color: theirColor
            ),
            SizedBox(width: TossSpacing.space1),
            Text(
              'Their Cash: ',
              style: TossTextStyles.caption.copyWith(
                color: TossColors.gray500,
                fontWeight: FontWeight.w500,
              ),
            ),
            Flexible(
              child: Text(
                counterpartyCashLocationName,
                style: TossTextStyles.caption.copyWith(
                  color: TossColors.gray700,
                  fontWeight: FontWeight.w600,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      );
    }
    
    if (infoRows.isEmpty) {
      return SizedBox.shrink();
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: infoRows.map((row) => 
        Padding(
          padding: EdgeInsets.only(top: TossSpacing.space1),
          child: row,
        ),
      ).toList(),
    );
  }


  Widget _buildTemplateDescription(Map<String, dynamic> template) {
    final description = template['template_description'] as String?;
    if (description == null || description.isEmpty) {
      return SizedBox.shrink();
    }
    
    return Padding(
      padding: EdgeInsets.only(top: TossSpacing.space2),
      child: Text(
        description,
        style: TossTextStyles.caption.copyWith(
          color: TossColors.textSecondary,
          fontStyle: FontStyle.italic,
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }


  void _showDeleteConfirmationDialog(BuildContext context, WidgetRef ref, Map<String, dynamic> template) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(TossBorderRadius.lg),
          ),
          title: Row(
            children: [
              Container(
                width: TossSpacing.iconXL,
                height: TossSpacing.iconXL,
                decoration: BoxDecoration(
                  color: TossColors.errorLight,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  TossIcons.warning,
                  color: TossColors.error,
                  size: TossSpacing.iconMD,
                ),
              ),
              SizedBox(width: TossSpacing.space3),
              Expanded(
                child: Text(
                  'Delete Template',
                  style: TossTextStyles.h3.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Are you sure you want to delete this template?',
                style: TossTextStyles.body.copyWith(
                  color: TossColors.textPrimary,
                ),
              ),
              SizedBox(height: TossSpacing.space3),
              Container(
                padding: EdgeInsets.all(TossSpacing.space3),
                decoration: BoxDecoration(
                  color: TossColors.gray50,
                  borderRadius: BorderRadius.circular(TossBorderRadius.md),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      (template['name'] as String?) ?? 'Unnamed Template',
                      style: TossTextStyles.bodyLarge.copyWith(
                        fontWeight: FontWeight.w600,
                        color: TossColors.textPrimary,
                      ),
                    ),
                    if (template['template_description'] != null && 
                        template['template_description'].toString().isNotEmpty) ...[
                      SizedBox(height: TossSpacing.space1),
                      Text(
                        template['template_description'].toString(),
                        style: TossTextStyles.caption.copyWith(
                          color: TossColors.textSecondary,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              SizedBox(height: TossSpacing.space3),
              Text(
                'This action cannot be undone.',
                style: TossTextStyles.caption.copyWith(
                  color: TossColors.error,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(
                'Cancel',
                style: TossTextStyles.button.copyWith(
                  color: TossColors.gray600,
                ),
              ),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(dialogContext).pop();
                await _deleteTemplate(context, ref, template);
              },
              child: Text(
                'Delete',
                style: TossTextStyles.button.copyWith(
                  color: TossColors.error,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteTemplate(BuildContext context, WidgetRef ref, Map<String, dynamic> template) async {
    final templateRepository = ref.read(templateRepositoryProvider);
    final templateId = template['template_id'] as String?;
    final appState = ref.read(appStateProvider);
    final companyId = appState.companyChoosen;
    final storeId = appState.storeChoosen;
    
    if (templateId == null) {
      _showErrorSnackBar(context, 'Unable to delete template: Invalid template ID');
      return;
    }
    
    // 1. IMMEDIATE UI UPDATE - Remove from display using local state
    setState(() {
      // Get current displayed templates
      final currentTemplates = _hasOptimisticUpdates ? _optimisticTemplates : 
        ref.read(filteredTemplatesProvider).value ?? [];
      
      // Remove deleted template and keep local state active
      _hasOptimisticUpdates = true;
      _optimisticTemplates = currentTemplates
        .where((t) => t['template_id'] != templateId)
        .toList();
    });
    
    // 2. BACKGROUND DATABASE UPDATE using repository
    try {
      await templateRepository.deleteTemplate(
        templateId: templateId!,
        userId: 'current_user_id', // TODO: Get from auth provider
        companyId: companyId.toString(),
        storeId: storeId.toString(),
      );
      
      // 3. Show success immediately
      if (context.mounted) {
        _showSuccessSnackBar(context, 'Template deleted');
      }
    } catch (e) {
      // Revert optimistic update if deletion failed
      setState(() {
        _hasOptimisticUpdates = false;
        _optimisticTemplates = [];
      });
      
      if (context.mounted) {
        _showErrorSnackBar(context, 'Failed to delete template: $e');
      }
    }
  }

  /// Track template selection for analytics
  void _trackTemplateSelection(Map<String, dynamic> template) async {
    try {
      // TODO: Implement analytics tracking using new business layer services
      // This would use the business layer analytics service once implemented
      print('Template selected: ${template['template_id']}');
    } catch (e) {
      // Don't interrupt user experience, but silently handle error
    }
  }

  void _showSuccessSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              TossIcons.checkCircle,
              color: TossColors.white,
              size: TossSpacing.iconSM,
            ),
            SizedBox(width: TossSpacing.space2),
            Expanded(
              child: Text(
                message,
                style: TossTextStyles.body.copyWith(
                  color: TossColors.white,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: TossColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(TossBorderRadius.md),
        ),
        margin: EdgeInsets.all(TossSpacing.space4),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              TossIcons.errorOutline,
              color: TossColors.white,
              size: TossSpacing.iconSM,
            ),
            SizedBox(width: TossSpacing.space2),
            Expanded(
              child: Text(
                message,
                style: TossTextStyles.body.copyWith(
                  color: TossColors.white,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: TossColors.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(TossBorderRadius.md),
        ),
        margin: EdgeInsets.all(TossSpacing.space4),
        duration: const Duration(seconds: 4),
      ),
    );
  }
}