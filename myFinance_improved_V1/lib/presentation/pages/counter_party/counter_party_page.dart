import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinance_improved/core/themes/toss_colors.dart';
import 'package:myfinance_improved/core/themes/toss_text_styles.dart';
import 'package:myfinance_improved/core/themes/toss_spacing.dart';
import 'package:myfinance_improved/core/themes/toss_border_radius.dart';
import 'package:myfinance_improved/core/themes/toss_animations.dart';
import 'dart:async';
import 'constants/counter_party_colors.dart';
import 'providers/counter_party_providers.dart';
import 'providers/counter_party_optimized_providers.dart';
import 'models/counter_party_models.dart';
import 'widgets/counter_party_list_item.dart';
import 'widgets/counter_party_form.dart';
import '../../providers/app_state_provider.dart';
import '../../widgets/common/toss_scaffold.dart';
import '../../widgets/common/toss_stats_card.dart';
import '../../widgets/common/toss_app_bar.dart';
import '../../widgets/toss/toss_search_field.dart';
import '../../../core/navigation/safe_navigation.dart';

class CounterPartyPage extends ConsumerStatefulWidget {
  const CounterPartyPage({super.key});

  @override
  ConsumerState<CounterPartyPage> createState() => _CounterPartyPageState();
}

class _CounterPartyPageState extends ConsumerState<CounterPartyPage> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  Timer? _searchDebounce;

  @override
  void initState() {
    super.initState();
    // Initialize data fetch with cache management
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeData();
    });
  }

  void _initializeData() {
    final selectedCompany = ref.read(selectedCompanyProvider);
    if (selectedCompany != null) {
      final cacheManager = ref.read(counterPartyCacheProvider);
      // Refresh data if cache is stale, otherwise use cached data
      cacheManager.refreshIfStale(selectedCompany['company_id']);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    _searchDebounce?.cancel();
    super.dispose();
  }

  // Debounced search to prevent excessive rebuilds
  void _onSearchChanged(String value) {
    _searchDebounce?.cancel();
    _searchDebounce = Timer(TossAnimations.slow, () {
      ref.read(counterPartySearchProvider.notifier).state = value;
    });
  }

  Future<void> _refreshData() async {
    // Use optimized refresh functionality
    final refresh = ref.read(counterPartyRefreshProvider);
    refresh();
  }

  void _showCreateForm() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: TossColors.transparent,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.8,
      ),
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: TossColors.surface,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(TossBorderRadius.xl),
            topRight: Radius.circular(TossBorderRadius.xl),
          ),
        ),
        child: const CounterPartyForm(),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    // Use optimized providers for better performance
    final counterPartiesAsync = ref.watch(optimizedCounterPartiesProvider);
    final statsAsync = ref.watch(optimizedCounterPartyStatsProvider);
    ref.watch(selectedCompanyProvider); // Keep watching for reactivity

    return TossScaffold(
      backgroundColor: TossColors.gray100,
      appBar: TossAppBar(
        title: 'Counter Party',
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: TossColors.textPrimary),
          onPressed: () => context.safePop(),
        ),
        primaryActionText: 'Add',
        primaryActionIcon: Icons.add,
        onPrimaryAction: _showCreateForm,
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        color: TossColors.primary,
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            // Stats Card
            _buildStatsCard(context, statsAsync),
            
            // Filter and Sort Dropdowns
            _buildFilterAndSortSection(context),
            
            // Search Field
            _buildSearchField(context),
            
            // Counter Party List
            _buildCounterPartyList(context, counterPartiesAsync),
          ],
        ),
      ),
      // Floating action button removed - now in app bar
    );
  }


  Widget _buildStatsCard(BuildContext context, AsyncValue<CounterPartyStats> statsAsync) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.all(TossSpacing.space4),
        child: statsAsync.when(
          data: (stats) => TossStatsCard(
            title: 'Total Counterparties',
            totalCount: stats.total,
            items: [
              TossStatItem(
                label: 'My Company',
                count: stats.myCompanies,
                icon: CounterPartyColors.getTypeIcon(CounterPartyType.myCompany),
                color: CounterPartyColors.myCompany,
              ),
              TossStatItem(
                label: 'Team Member',
                count: stats.teamMembers,
                icon: CounterPartyColors.getTypeIcon(CounterPartyType.teamMember),
                color: CounterPartyColors.teamMember,
              ),
              TossStatItem(
                label: 'Suppliers',
                count: stats.suppliers,
                icon: CounterPartyColors.getTypeIcon(CounterPartyType.supplier),
                color: CounterPartyColors.supplier,
              ),
              TossStatItem(
                label: 'Employees',
                count: stats.employees,
                icon: CounterPartyColors.getTypeIcon(CounterPartyType.employee),
                color: CounterPartyColors.employee,
              ),
              TossStatItem(
                label: 'Customers',
                count: stats.customers,
                icon: CounterPartyColors.getTypeIcon(CounterPartyType.customer),
                color: CounterPartyColors.customer,
              ),
              TossStatItem(
                label: 'Others',
                count: stats.others,
                icon: CounterPartyColors.getTypeIcon(CounterPartyType.other),
                color: CounterPartyColors.other,
              ),
            ],
            onRetry: _refreshData,
          ),
          loading: () => const TossStatsCard(
            title: 'Total Counterparties',
            totalCount: 0,
            items: [],
            isLoading: true,
          ),
          error: (error, _) => TossStatsCard(
            title: 'Total Counterparties',
            totalCount: 0,
            items: [],
            errorMessage: 'Failed to load statistics',
            onRetry: _refreshData,
          ),
        ),
      ),
    );
  }


  Widget _buildFilterAndSortSection(BuildContext context) {
    final filter = ref.watch(counterPartyFilterProvider);
    
    return SliverToBoxAdapter(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: TossSpacing.space4),
        padding: EdgeInsets.symmetric(
          horizontal: TossSpacing.space3,
          vertical: TossSpacing.space2,
        ),
        decoration: BoxDecoration(
          color: TossColors.surface,
          borderRadius: BorderRadius.circular(TossBorderRadius.md),
          boxShadow: [
            BoxShadow(
              color: TossColors.black.withOpacity(0.02),
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          children: [
            // Filter Section - 50% space
            Expanded(
              flex: 50,
              child: InkWell(
                onTap: () => _showFilterOptionsSheet(),
                borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: TossSpacing.space3,
                    vertical: TossSpacing.space2,
                  ),
                  child: Row(
                    children: [
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Icon(
                            Icons.filter_list_rounded,
                            size: 22,
                            color: _hasActiveFilters() ? TossColors.primary : TossColors.gray600,
                          ),
                          if (_hasActiveFilters())
                            Positioned(
                              right: -4,
                              top: -4,
                              child: Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: TossColors.primary,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                        ],
                      ),
                      SizedBox(width: TossSpacing.space2),
                      Expanded(
                        child: Text(
                          _getFilterLabel(),
                          style: TossTextStyles.labelLarge.copyWith(
                            color: TossColors.gray700,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Icon(
                        Icons.keyboard_arrow_down_rounded,
                        size: 20,
                        color: TossColors.gray500,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
            Container(
              width: 1,
              height: 20,
              color: TossColors.gray200,
            ),
            
            // Sort Section - 50% space
            Expanded(
              flex: 50,
              child: InkWell(
                onTap: () => _showSortOptionsSheet(),
                borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: TossSpacing.space3,
                    vertical: TossSpacing.space2,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.sort_rounded,
                        size: 22,
                        color: TossColors.primary,
                      ),
                      SizedBox(width: TossSpacing.space2),
                      Expanded(
                        child: Text(
                          _getSortLabel(filter),
                          style: TossTextStyles.labelLarge.copyWith(
                            color: TossColors.gray700,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Icon(
                        Icons.keyboard_arrow_down_rounded,
                        size: 20,
                        color: TossColors.gray500,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchField(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          TossSpacing.space4,
          TossSpacing.space2,
          TossSpacing.space4,
          TossSpacing.space3,
        ),
        child: TossSearchField(
          controller: _searchController,
          hintText: 'Search counterparties...',
          prefixIcon: Icons.search,
          onChanged: _onSearchChanged,
          onClear: () {
            _searchController.clear();
            _onSearchChanged('');
          },
        ),
      ),
    );
  }

  String _getFilterLabel() {
    final filter = ref.watch(counterPartyFilterProvider);
    final activeFilters = <String>[];
    
    if (filter.types != null && filter.types!.isNotEmpty) {
      if (filter.types!.length == 1) {
        activeFilters.add(filter.types!.first.displayName);
      } else {
        activeFilters.add('${filter.types!.length} types');
      }
    }
    
    if (filter.isInternal != null) {
      activeFilters.add(filter.isInternal! ? 'Internal' : 'External');
    }
    
    if (activeFilters.isEmpty) {
      return 'Filter';
    }
    
    return activeFilters.join(' • ');
  }

  String _getSortLabel(CounterPartyFilter filter) {
    switch (filter.sortBy) {
      case CounterPartySortOption.name:
        return 'Name (${filter.ascending ? 'A-Z' : 'Z-A'})';
      case CounterPartySortOption.type:
        return 'Type (${filter.ascending ? 'A-Z' : 'Z-A'})';
      case CounterPartySortOption.createdAt:
        return 'Created (${filter.ascending ? 'Old-New' : 'New-Old'})';
      case CounterPartySortOption.isInternal:
        return 'Internal (${filter.ascending ? 'External First' : 'Internal First'})';
    }
  }

  bool _hasActiveFilters() {
    final filter = ref.watch(counterPartyFilterProvider);
    return (filter.types?.isNotEmpty ?? false) || filter.isInternal != null;
  }

  void _showFilterOptionsSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: TossColors.transparent,
      builder: (context) => _buildFilterSheet(),
    );
  }

  void _showSortOptionsSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: TossColors.transparent,
      builder: (context) => _buildSortSheet(),
    );
  }

  Widget _buildFilterSheet() {
    final filter = ref.watch(counterPartyFilterProvider);
    
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.8,
      ),
      decoration: BoxDecoration(
        color: TossColors.surface,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(TossBorderRadius.xl),
          topRight: Radius.circular(TossBorderRadius.xl),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            width: 48,
            height: 4,
            margin: EdgeInsets.only(top: TossSpacing.space3),
            decoration: BoxDecoration(
              color: TossColors.gray300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          // Title
          Container(
            padding: EdgeInsets.all(TossSpacing.space4),
            child: Text(
              'Filter Counter Parties',
              style: TossTextStyles.h3.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          
          // Scrollable Filter options
          Flexible(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).padding.bottom + TossSpacing.space4,
              ),
              child: _buildFilterOptions(filter),
            ),
          ),
          
          SizedBox(height: TossSpacing.space4),
        ],
      ),
    );
  }

  Widget _buildFilterOptions(CounterPartyFilter filter) {
    final allOptions = [
      // Type options
      {'type': 'all', 'label': 'All Types', 'icon': Icons.clear_all_rounded, 'category': 'type'},
      {'type': CounterPartyType.myCompany, 'label': 'My Company', 'icon': Icons.business, 'category': 'type'},
      {'type': CounterPartyType.teamMember, 'label': 'Team Member', 'icon': Icons.group, 'category': 'type'},
      {'type': CounterPartyType.supplier, 'label': 'Suppliers', 'icon': Icons.local_shipping, 'category': 'type'},
      {'type': CounterPartyType.employee, 'label': 'Employees', 'icon': Icons.badge, 'category': 'type'},
      {'type': CounterPartyType.customer, 'label': 'Customers', 'icon': Icons.people, 'category': 'type'},
      {'type': CounterPartyType.other, 'label': 'Others', 'icon': Icons.category, 'category': 'type'},
      
      // Internal/External options
      {'value': null, 'label': 'All Locations', 'icon': Icons.all_inclusive, 'category': 'internal'},
      {'value': true, 'label': 'Internal Only', 'icon': Icons.home_work, 'category': 'internal'},
      {'value': false, 'label': 'External Only', 'icon': Icons.public, 'category': 'internal'},
    ];
    
    return Column(
      children: allOptions.map((option) {
        final bool isSelected;
        final VoidCallback onTap;
        
        if (option['category'] == 'type') {
          // Handle type filters
          final isAll = option['type'] == 'all';
          isSelected = isAll 
              ? (filter.types?.isEmpty ?? true)
              : (filter.types?.contains(option['type']) ?? false);
          
          onTap = () {
            final currentFilter = ref.read(counterPartyFilterProvider);
            List<CounterPartyType>? newTypes;
            
            if (isAll) {
              newTypes = null;
            } else {
              final type = option['type'] as CounterPartyType;
              final currentTypes = List<CounterPartyType>.from(currentFilter.types ?? []);
              
              if (currentTypes.contains(type)) {
                currentTypes.remove(type);
              } else {
                currentTypes.add(type);
              }
              
              newTypes = currentTypes.isEmpty ? null : currentTypes;
            }
            
            ref.read(counterPartyFilterProvider.notifier).state = 
                currentFilter.copyWith(types: newTypes);
            
            Navigator.pop(context);
          };
        } else {
          // Handle internal/external filters
          isSelected = filter.isInternal == option['value'];
          
          onTap = () {
            final currentFilter = ref.read(counterPartyFilterProvider);
            ref.read(counterPartyFilterProvider.notifier).state = currentFilter.copyWith(
              isInternal: option['value'] as bool?,
            );
            Navigator.pop(context);
          };
        }
        
        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: TossSpacing.space4,
                vertical: TossSpacing.space4,
              ),
              child: Row(
                children: [
                  Icon(
                    option['icon'] as IconData,
                    size: 20,
                    color: TossColors.gray600,
                  ),
                  SizedBox(width: TossSpacing.space3),
                  Text(
                    option['label'] as String,
                    style: TossTextStyles.body.copyWith(
                      color: TossColors.gray900,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Spacer(),
                  if (isSelected)
                    Icon(
                      Icons.check_rounded,
                      color: TossColors.primary,
                      size: 20,
                    ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSortSheet() {
    final filter = ref.watch(counterPartyFilterProvider);
    
    final sortOptions = [
      {'value': CounterPartySortOption.name, 'label': 'Name', 'icon': Icons.sort_by_alpha},
      {'value': CounterPartySortOption.type, 'label': 'Type', 'icon': Icons.category},
      {'value': CounterPartySortOption.createdAt, 'label': 'Created Date', 'icon': Icons.calendar_today},
      {'value': CounterPartySortOption.isInternal, 'label': 'Internal/External', 'icon': Icons.home_work},
    ];
    
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).padding.bottom,
      ),
      decoration: BoxDecoration(
        color: TossColors.surface,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(TossBorderRadius.xl),
          topRight: Radius.circular(TossBorderRadius.xl),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            width: 48,
            height: 4,
            margin: EdgeInsets.only(top: TossSpacing.space3),
            decoration: BoxDecoration(
              color: TossColors.gray300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          // Title
          Container(
            padding: EdgeInsets.all(TossSpacing.space4),
            child: Text(
              'Sort by',
              style: TossTextStyles.h3.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          
          // Sort Options
          ...sortOptions.map((option) {
            final isSelected = option['value'] == filter.sortBy;
            String label = option['label'] as String;
            
            // Add direction indicator for the selected option
            if (isSelected) {
              switch (option['value'] as CounterPartySortOption) {
                case CounterPartySortOption.name:
                case CounterPartySortOption.type:
                  label += ' (${filter.ascending ? 'A-Z' : 'Z-A'})';
                  break;
                case CounterPartySortOption.createdAt:
                  label += ' (${filter.ascending ? 'Old-New' : 'New-Old'})';
                  break;
                case CounterPartySortOption.isInternal:
                  label += ' (${filter.ascending ? 'External First' : 'Internal First'})';
                  break;
              }
            }
            
            return Material(
              color: TossColors.transparent,
              child: InkWell(
                onTap: () {
                  final currentFilter = ref.read(counterPartyFilterProvider);
                  final sortBy = option['value'] as CounterPartySortOption;
                  
                  // Toggle direction if same sort option is selected
                  final ascending = currentFilter.sortBy == sortBy ? !currentFilter.ascending : true;
                  
                  ref.read(counterPartyFilterProvider.notifier).state = 
                      currentFilter.copyWith(sortBy: sortBy, ascending: ascending);
                  
                  Navigator.pop(context);
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: TossSpacing.space4,
                    vertical: TossSpacing.space3,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        option['icon'] as IconData,
                        size: 20,
                        color: TossColors.gray600,
                      ),
                      SizedBox(width: TossSpacing.space3),
                      Text(
                        label,
                        style: TossTextStyles.body.copyWith(
                          color: TossColors.gray900,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Spacer(),
                      if (isSelected)
                        Icon(
                          Icons.check_rounded,
                          color: TossColors.primary,
                          size: 20,
                        ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
          
          SizedBox(height: TossSpacing.space4),
        ],
      ),
    );
  }

  Widget _buildCounterPartyList(
    BuildContext context,
    AsyncValue<List<CounterParty>> counterPartiesAsync,
  ) {
    return counterPartiesAsync.when(
      data: (counterParties) {
        if (counterParties.isEmpty) {
          return SliverFillRemaining(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.people_outline,
                    size: TossSpacing.iconXL + 24,
                    color: TossColors.textTertiary,
                  ),
                  SizedBox(height: TossSpacing.space4),
                  Text(
                    'No counterparties yet',
                    style: TossTextStyles.h3.copyWith(
                      color: TossColors.textSecondary,
                    ),
                  ),
                  SizedBox(height: TossSpacing.space2),
                  Text(
                    'Tap the + button to add your first counterparty',
                    style: TossTextStyles.body.copyWith(
                      color: TossColors.textTertiary,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        // No need to filter here - optimizedCounterPartiesProvider already handles it
        return SliverPadding(
          padding: EdgeInsets.all(TossSpacing.space4),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final counterParty = counterParties[index];
                return Padding(
                  padding: EdgeInsets.only(bottom: TossSpacing.space3),
                  child: CounterPartyListItem(
                    counterParty: counterParty,
                    onEdit: () => _showEditForm(counterParty),
                    onAccountSettings: () {
                      if (counterParty.isInternal) {
                        context.safePush('/debtAccountSettings/${counterParty.counterpartyId}/${Uri.encodeComponent(counterParty.name)}');
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Account settings are only available for internal companies'),
                            backgroundColor: TossColors.warning,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(TossBorderRadius.md),
                            ),
                          ),
                        );
                      }
                    },
                    onDelete: () => _deleteCounterParty(counterParty),
                  ),
                );
              },
              childCount: counterParties.length,
            ),
          ),
        );
      },
      loading: () => SliverFillRemaining(
        child: Center(
          child: CircularProgressIndicator(
            color: TossColors.primary,
          ),
        ),
      ),
      error: (error, _) => SliverFillRemaining(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: TossSpacing.inputHeightLG,
                color: TossColors.error,
              ),
              SizedBox(height: TossSpacing.space4),
              Text(
                'Failed to load counterparties',
                style: TossTextStyles.h3.copyWith(
                  color: TossColors.textPrimary,
                ),
              ),
              SizedBox(height: TossSpacing.space2),
              Text(
                error.toString(),
                style: TossTextStyles.body.copyWith(
                  color: TossColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: TossSpacing.space4),
              TextButton(
                onPressed: _refreshData,
                child: Text(
                  'Retry',
                  style: TossTextStyles.body.copyWith(
                    color: TossColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showEditForm(CounterParty counterParty) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: TossColors.transparent,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.8,
      ),
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: TossColors.surface,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(TossBorderRadius.xl),
            topRight: Radius.circular(TossBorderRadius.xl),
          ),
        ),
        child: CounterPartyForm(counterParty: counterParty),
      ),
    );
  }

  Future<void> _deleteCounterParty(CounterParty counterParty) async {
    try {
      // Use the delete provider to soft delete the counter party
      await ref.read(deleteCounterPartyProvider(counterParty.counterpartyId).future);
      
      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${counterParty.name} deleted successfully'),
            backgroundColor: TossColors.success,
          ),
        );
      }
    } catch (e) {
      // Show error message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to delete: ${e.toString()}'),
            backgroundColor: TossColors.error,
          ),
        );
      }
    }
  }
}