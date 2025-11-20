import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:myfinance_improved/shared/themes/toss_animations.dart';
import 'package:myfinance_improved/shared/themes/toss_border_radius.dart';
// Shared - Themes
import 'package:myfinance_improved/shared/themes/toss_colors.dart';
import 'package:myfinance_improved/shared/themes/toss_shadows.dart';
import 'package:myfinance_improved/shared/themes/toss_spacing.dart';
import 'package:myfinance_improved/shared/themes/toss_text_styles.dart';
import 'package:myfinance_improved/shared/widgets/common/toss_app_bar_1.dart';
import 'package:myfinance_improved/shared/widgets/common/toss_loading_view.dart';
// Shared - Widgets
import 'package:myfinance_improved/shared/widgets/common/toss_scaffold.dart';
import 'package:myfinance_improved/shared/widgets/common/toss_success_error_dialog.dart';
import 'package:myfinance_improved/shared/widgets/toss/toss_bottom_sheet.dart';
import 'package:myfinance_improved/shared/widgets/toss/toss_search_field.dart';
import 'package:myfinance_improved/shared/widgets/toss/toss_selection_bottom_sheet.dart';

// Core

// Feature
import '../../domain/entities/counter_party.dart';
import '../../domain/entities/counter_party_stats.dart';
import '../../domain/value_objects/counter_party_filter.dart';
import '../../domain/value_objects/counter_party_type.dart';
import '../providers/counter_party_providers.dart';
import '../widgets/counter_party_form.dart';
import '../widgets/counter_party_list_item.dart';

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
    final companyId = ref.read(selectedCompanyIdProvider);
    if (companyId != null) {
      final cacheManager = ref.read(counterPartyCacheProvider);
      // Refresh data if cache is stale, otherwise use cached data
      cacheManager.refreshIfStale(companyId);
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
    TossBottomSheet.showWithBuilder<void>(
      context: context,
      heightFactor: 0.8,
      builder: (context) => Container(
        decoration: const BoxDecoration(
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
    ref.watch(selectedCompanyIdProvider); // Keep watching for reactivity

    return TossScaffold(
      backgroundColor: TossColors.gray100,
      appBar: TossAppBar1(
        title: 'Counter Party',
        backgroundColor: TossColors.gray100, // ✅ 배경색과 일치
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: TossColors.textPrimary),
          onPressed: () => context.pop(),
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
        padding: const EdgeInsets.all(TossSpacing.space4),
        child: statsAsync.when(
          data: (stats) => TossStatsCard(
            title: 'Total Counterparties',
            totalCount: stats.total,
            items: [
              TossStatItem(
                label: 'My Company',
                count: stats.myCompanies,
                icon: Icons.business,
                color: TossColors.primary,
              ),
              TossStatItem(
                label: 'Team Member',
                count: stats.teamMembers,
                icon: Icons.group,
                color: TossColors.success,
              ),
              TossStatItem(
                label: 'Suppliers',
                count: stats.suppliers,
                icon: Icons.local_shipping,
                color: TossColors.info,
              ),
              TossStatItem(
                label: 'Employees',
                count: stats.employees,
                icon: Icons.badge,
                color: TossColors.warning,
              ),
              TossStatItem(
                label: 'Customers',
                count: stats.customers,
                icon: Icons.people,
                color: TossColors.error,
              ),
              TossStatItem(
                label: 'Others',
                count: stats.others,
                icon: Icons.category,
                color: TossColors.gray500,
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
            items: const [],
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
        margin: const EdgeInsets.symmetric(horizontal: TossSpacing.space4),
        padding: const EdgeInsets.symmetric(
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
                  padding: const EdgeInsets.symmetric(
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
                                decoration: const BoxDecoration(
                                  color: TossColors.primary,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(width: TossSpacing.space2),
                      Expanded(
                        child: Text(
                          _getFilterLabel(),
                          style: TossTextStyles.labelLarge.copyWith(
                            color: TossColors.gray700,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const Icon(
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
                  padding: const EdgeInsets.symmetric(
                    horizontal: TossSpacing.space3,
                    vertical: TossSpacing.space2,
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.sort_rounded,
                        size: 22,
                        color: TossColors.primary,
                      ),
                      const SizedBox(width: TossSpacing.space2),
                      Expanded(
                        child: Text(
                          _getSortLabel(filter),
                          style: TossTextStyles.labelLarge.copyWith(
                            color: TossColors.gray700,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const Icon(
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
        padding: const EdgeInsets.fromLTRB(
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
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: TossColors.transparent,
      builder: (context) => _buildFilterSheet(),
    );
  }

  void _showSortOptionsSheet() {
    final filter = ref.read(counterPartyFilterProvider);

    final sortOptions = [
      TossSelectionItem(
        id: 'name',
        title: 'Name',
        subtitle: filter.sortBy == CounterPartySortOption.name
            ? '(${filter.ascending ? 'A-Z' : 'Z-A'})'
            : null,
        icon: Icons.sort_by_alpha,
      ),
      TossSelectionItem(
        id: 'type',
        title: 'Type',
        subtitle: filter.sortBy == CounterPartySortOption.type
            ? '(${filter.ascending ? 'A-Z' : 'Z-A'})'
            : null,
        icon: Icons.category,
      ),
      TossSelectionItem(
        id: 'created',
        title: 'Created Date',
        subtitle: filter.sortBy == CounterPartySortOption.createdAt
            ? '(${filter.ascending ? 'Old-New' : 'New-Old'})'
            : null,
        icon: Icons.calendar_today,
      ),
      TossSelectionItem(
        id: 'internal',
        title: 'Internal/External',
        subtitle: filter.sortBy == CounterPartySortOption.isInternal
            ? '(${filter.ascending ? 'External First' : 'Internal First'})'
            : null,
        icon: Icons.home_work,
      ),
    ];

    String? currentSelectedId;
    switch (filter.sortBy) {
      case CounterPartySortOption.name:
        currentSelectedId = 'name';
        break;
      case CounterPartySortOption.type:
        currentSelectedId = 'type';
        break;
      case CounterPartySortOption.createdAt:
        currentSelectedId = 'created';
        break;
      case CounterPartySortOption.isInternal:
        currentSelectedId = 'internal';
        break;
    }

    TossSelectionBottomSheet.show<void>(
      context: context,
      title: 'Sort by',
      items: sortOptions,
      selectedId: currentSelectedId,
      onItemSelected: (item) {
        final currentFilter = ref.read(counterPartyFilterProvider);
        CounterPartySortOption sortBy;

        switch (item.id) {
          case 'name':
            sortBy = CounterPartySortOption.name;
            break;
          case 'type':
            sortBy = CounterPartySortOption.type;
            break;
          case 'created':
            sortBy = CounterPartySortOption.createdAt;
            break;
          case 'internal':
            sortBy = CounterPartySortOption.isInternal;
            break;
          default:
            return;
        }

        // Toggle direction if same sort option is selected
        final ascending = currentFilter.sortBy == sortBy ? !currentFilter.ascending : true;

        ref.read(counterPartyFilterProvider.notifier).state =
            currentFilter.copyWith(sortBy: sortBy, ascending: ascending);
      },
    );
  }

  Widget _buildFilterSheet() {
    final filter = ref.watch(counterPartyFilterProvider);
    
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.8,
      ),
      decoration: const BoxDecoration(
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
            margin: const EdgeInsets.only(top: TossSpacing.space3),
            decoration: BoxDecoration(
              color: TossColors.gray300,
              borderRadius: BorderRadius.circular(TossBorderRadius.xs),
            ),
          ),
          
          // Title
          Container(
            padding: const EdgeInsets.all(TossSpacing.space4),
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
          
          const SizedBox(height: TossSpacing.space4),
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
              final type = option['type']! as CounterPartyType;
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
          color: TossColors.transparent,
          child: InkWell(
            onTap: onTap,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: TossSpacing.space4,
                vertical: TossSpacing.space4,
              ),
              child: Row(
                children: [
                  Icon(
                    option['icon']! as IconData,
                    size: 20,
                    color: TossColors.gray600,
                  ),
                  const SizedBox(width: TossSpacing.space3),
                  Text(
                    option['label']! as String,
                    style: TossTextStyles.body.copyWith(
                      color: TossColors.gray900,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Spacer(),
                  if (isSelected)
                    const Icon(
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
                  const Icon(
                    Icons.people_outline,
                    size: TossSpacing.iconXL + 24,
                    color: TossColors.textTertiary,
                  ),
                  const SizedBox(height: TossSpacing.space4),
                  Text(
                    'No counterparties yet',
                    style: TossTextStyles.h3.copyWith(
                      color: TossColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: TossSpacing.space2),
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
          padding: const EdgeInsets.all(TossSpacing.space4),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final counterParty = counterParties[index];
                return Padding(
                  key: ValueKey('counter_party_${counterParty.counterpartyId}'),
                  padding: const EdgeInsets.only(bottom: TossSpacing.space3),
                  child: CounterPartyListItem(
                    key: ValueKey('list_item_${counterParty.counterpartyId}'),
                    counterParty: counterParty,
                    onEdit: () => _showEditForm(counterParty),
                    onAccountSettings: () {
                      if (counterParty.isInternal) {
                        context.push<void>('/debtAccountSettings/${counterParty.counterpartyId}/${Uri.encodeComponent(counterParty.name)}');
                      } else {
                        showDialog(
                          context: context,
                          barrierDismissible: true,
                          builder: (context) => TossDialog.error(
                            title: 'Not Available',
                            message: 'Account settings are only available for internal companies',
                            primaryButtonText: 'OK',
                            onPrimaryPressed: () => context.pop(),
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
      loading: () => const SliverFillRemaining(
        child: Center(
          child: TossLoadingView(),
        ),
      ),
      error: (error, _) => SliverFillRemaining(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: TossSpacing.inputHeightLG,
                color: TossColors.error,
              ),
              const SizedBox(height: TossSpacing.space4),
              Text(
                'Failed to load counterparties',
                style: TossTextStyles.h3.copyWith(
                  color: TossColors.textPrimary,
                ),
              ),
              const SizedBox(height: TossSpacing.space2),
              Text(
                error.toString(),
                style: TossTextStyles.body.copyWith(
                  color: TossColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: TossSpacing.space4),
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
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: TossColors.transparent,
      constraints: BoxConstraints(
        maxHeight: (MediaQuery.of(context).size.height - 
                   MediaQuery.of(context).viewInsets.bottom) * 0.8,
      ),
      builder: (context) => Container(
        decoration: const BoxDecoration(
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
      if (!mounted) return;

      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (dialogContext) => TossDialog.success(
          title: 'Counter Party Deleted!',
          message: '${counterParty.name} has been deleted successfully',
          primaryButtonText: 'Done',
          onPrimaryPressed: () {
            if (Navigator.canPop(dialogContext)) {
              Navigator.pop(dialogContext);
            }
          },
        ),
      );
    } catch (e) {
      // Show error message
      if (!mounted) return;

      await showDialog(
        context: context,
        barrierDismissible: true,
        builder: (dialogContext) => TossDialog.error(
          title: 'Failed to Delete',
          message: 'Could not delete counter party: ${e.toString()}',
          primaryButtonText: 'OK',
          onPrimaryPressed: () {
            if (Navigator.canPop(dialogContext)) {
              Navigator.pop(dialogContext);
            }
          },
        ),
      );
    }
  }
}

// Local widgets - only used in this file
class TossStatsCard extends StatelessWidget {
  final String title;
  final int totalCount;
  final List<TossStatItem> items;
  final bool isLoading;
  final String? errorMessage;
  final VoidCallback? onRetry;

  const TossStatsCard({
    super.key,
    required this.title,
    required this.totalCount,
    required this.items,
    this.isLoading = false,
    this.errorMessage,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return _buildLoadingState();
    }

    if (errorMessage != null) {
      return _buildErrorState();
    }

    return Container(
      padding: const EdgeInsets.all(TossSpacing.space4),
      decoration: BoxDecoration(
        color: TossColors.surface,
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        boxShadow: TossShadows.card,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with title and total count
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TossTextStyles.body.copyWith(
                  color: TossColors.textSecondary,
                ),
              ),
              Text(
                totalCount.toString(),
                style: TossTextStyles.h2.copyWith(
                  color: TossColors.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: TossSpacing.space3),
          
          // Divider
          Container(
            height: TossSpacing.space0 + 1,
            color: TossColors.border,
          ),
          
          const SizedBox(height: TossSpacing.space3),
          
          // Grid of stat items
          _buildStatsGrid(),
        ],
      ),
    );
  }

  Widget _buildStatsGrid() {
    // Split items into rows of 3
    final rows = <List<TossStatItem>>[];
    for (int i = 0; i < items.length; i += 3) {
      final endIndex = (i + 3 > items.length) ? items.length : i + 3;
      rows.add(items.sublist(i, endIndex));
    }

    return Column(
      children: rows.map((row) {
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: row.map((item) => _buildStatItem(item)).toList(),
            ),
            if (row != rows.last) const SizedBox(height: TossSpacing.space3),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildStatItem(TossStatItem item) {
    return Column(
      children: [
        Container(
          width: TossSpacing.space10,
          height: TossSpacing.space10,
          decoration: BoxDecoration(
            color: TossColors.gray100,
            borderRadius: BorderRadius.circular(TossBorderRadius.sm),
          ),
          child: Icon(
            item.icon,
            color: item.color,
            size: TossSpacing.iconSM,
          ),
        ),
        const SizedBox(height: TossSpacing.space2),
        Text(
          item.count.toString(),
          style: TossTextStyles.h3.copyWith(
            color: TossColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          item.label,
          style: TossTextStyles.caption.copyWith(
            color: TossColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingState() {
    return Container(
      height: TossSpacing.space10 * 3.5,
      padding: const EdgeInsets.all(TossSpacing.space4),
      decoration: BoxDecoration(
        color: TossColors.surface,
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        boxShadow: TossShadows.card,
      ),
      child: const Center(
        child: CircularProgressIndicator(
          color: TossColors.primary,
          strokeWidth: TossSpacing.space0 + 2,
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return Container(
      padding: const EdgeInsets.all(TossSpacing.space4),
      decoration: BoxDecoration(
        color: TossColors.surface,
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        boxShadow: TossShadows.card,
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              errorMessage ?? 'Failed to load statistics',
              style: TossTextStyles.body.copyWith(
                color: TossColors.error,
              ),
            ),
            if (onRetry != null) ...[
              const SizedBox(height: TossSpacing.space3),
              TextButton(
                onPressed: onRetry,
                child: Text(
                  'Retry',
                  style: TossTextStyles.body.copyWith(
                    color: TossColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Data class for individual stat items
class TossStatItem {
  final String label;
  final int count;
  final IconData icon;
  final Color color;

  const TossStatItem({
    required this.label,
    required this.count,
    required this.icon,
    required this.color,
  });
}