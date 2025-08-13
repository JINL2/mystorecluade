import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:myfinance_improved/core/themes/toss_colors.dart';
import 'package:myfinance_improved/core/themes/toss_text_styles.dart';
import 'package:myfinance_improved/core/themes/toss_spacing.dart';
import 'package:myfinance_improved/core/themes/toss_shadows.dart';
import 'package:myfinance_improved/core/themes/toss_border_radius.dart';
import 'providers/counter_party_providers.dart';
import 'models/counter_party_models.dart';
import 'widgets/counter_party_list_item.dart';
import 'widgets/counter_party_form.dart';
import 'widgets/counter_party_filter.dart' as filter_widget;
import '../../providers/app_state_provider.dart';

class CounterPartyPage extends ConsumerStatefulWidget {
  const CounterPartyPage({super.key});

  @override
  ConsumerState<CounterPartyPage> createState() => _CounterPartyPageState();
}

class _CounterPartyPageState extends ConsumerState<CounterPartyPage> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    // Initialize data fetch
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _refreshData();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _refreshData() async {
    // Refresh counterparties list
    ref.invalidate(counterPartiesProvider);
    ref.invalidate(counterPartyStatsProvider);
  }

  void _showCreateForm() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: const CounterPartyForm(),
      ),
    );
  }

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: 500, // Increased height to show all content including Sort By dropdown
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: const filter_widget.CounterPartyFilter(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final counterPartiesAsync = ref.watch(counterPartiesProvider);
    final statsAsync = ref.watch(counterPartyStatsProvider);
    final appState = ref.watch(appStateProvider);
    final selectedCompany = ref.watch(selectedCompanyProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: RefreshIndicator(
        onRefresh: _refreshData,
        color: Theme.of(context).colorScheme.primary,
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            // App Bar
            _buildAppBar(context),
            
            // Stats Card
            _buildStatsCard(context, statsAsync),
            
            // Search Bar
            _buildSearchBar(context),
            
            // Counter Party List
            _buildCounterPartyList(context, counterPartiesAsync),
          ],
        ),
      ),
      // Floating Action Button - Extended with text
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showCreateForm,
        backgroundColor: TossColors.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add, size: 20),
        label: Text(
          'Add New',
          style: TossTextStyles.body.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      floating: false,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Theme.of(context).colorScheme.onSurface),
        onPressed: () => context.pop(),
      ),
      title: Text(
        'Counter Party',
        style: TossTextStyles.h2.copyWith(
          color: Theme.of(context).colorScheme.onSurface,
          fontWeight: FontWeight.w600,
        ),
      ),
      centerTitle: true,
    );
  }

  Widget _buildStatsCard(BuildContext context, AsyncValue<CounterPartyStats> statsAsync) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.all(TossSpacing.space4),
        child: statsAsync.when(
          data: (stats) => Container(
            padding: EdgeInsets.all(TossSpacing.space4),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(TossBorderRadius.lg),
              boxShadow: TossShadows.cardShadow,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total Counterparties',
                      style: TossTextStyles.body.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                    Text(
                      stats.total.toString(),
                      style: TossTextStyles.h2.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: TossSpacing.space3),
                Container(
                  height: 1,
                  color: Theme.of(context).colorScheme.outline.withOpacity(0.1),
                ),
                SizedBox(height: TossSpacing.space3),
                // Show all 6 counter party types in 2 rows
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatItem(
                          context,
                          'My Company',
                          stats.myCompanies,
                          Icons.business,
                          const Color(0xFF007AFF),
                        ),
                        _buildStatItem(
                          context,
                          'Team Member',
                          stats.teamMembers,
                          Icons.group,
                          const Color(0xFF34C759),
                        ),
                        _buildStatItem(
                          context,
                          'Suppliers',
                          stats.suppliers,
                          Icons.local_shipping,
                          const Color(0xFF5856D6),
                        ),
                      ],
                    ),
                    SizedBox(height: TossSpacing.space3),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatItem(
                          context,
                          'Employees',
                          stats.employees,
                          Icons.badge,
                          const Color(0xFFFF9500),
                        ),
                        _buildStatItem(
                          context,
                          'Customers',
                          stats.customers,
                          Icons.people,
                          const Color(0xFFFF3B30),
                        ),
                        _buildStatItem(
                          context,
                          'Others',
                          stats.others,
                          Icons.category,
                          const Color(0xFF8E8E93),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          loading: () => Container(
            height: 140,
            padding: EdgeInsets.all(TossSpacing.space4),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(TossBorderRadius.lg),
              boxShadow: TossShadows.cardShadow,
            ),
            child: Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).colorScheme.primary,
                strokeWidth: 2,
              ),
            ),
          ),
          error: (error, _) => Container(
            padding: EdgeInsets.all(TossSpacing.space4),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(TossBorderRadius.lg),
              boxShadow: TossShadows.cardShadow,
            ),
            child: Center(
              child: Text(
                'Failed to load statistics',
                style: TossTextStyles.body.copyWith(
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context,
    String label,
    int count,
    IconData icon,
    Color color,
  ) {
    return Column(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(TossBorderRadius.sm),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        SizedBox(height: TossSpacing.space2),
        Text(
          count.toString(),
          style: TossTextStyles.h3.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          label,
          style: TossTextStyles.caption.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: TossSpacing.space4),
        child: Row(
          children: [
            // Search bar
            Expanded(
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(TossBorderRadius.md),
                  boxShadow: TossShadows.cardShadow,
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: (value) {
                    ref.read(counterPartySearchProvider.notifier).state = value;
                  },
                  decoration: InputDecoration(
                    hintText: 'Search counterparties...',
                    hintStyle: TossTextStyles.body.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.6),
                    ),
                    prefixIcon: Padding(
                      padding: EdgeInsets.only(left: 12, right: 8),
                      child: Icon(
                        Icons.search,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        size: 20,
                      ),
                    ),
                    prefixIconConstraints: BoxConstraints(minWidth: 0, minHeight: 0),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: Icon(
                              Icons.clear,
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                              size: 18,
                            ),
                            onPressed: () {
                              _searchController.clear();
                              ref.read(counterPartySearchProvider.notifier).state = '';
                            },
                          )
                        : null,
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: TossSpacing.space4,
                      vertical: TossSpacing.space3,
                    ),
                  ),
                  style: TossTextStyles.body.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ),
            ),
            
            // Filter button - Modern with badge for active filters
            SizedBox(width: TossSpacing.space2),
            GestureDetector(
              onTap: _showFilterSheet,
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(TossBorderRadius.md),
                  boxShadow: TossShadows.cardShadow,
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Icon(
                      Icons.tune,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      size: 22,
                    ),
                    // Show badge if filters are active
                    Consumer(
                      builder: (context, ref, child) {
                        final filter = ref.watch(counterPartyFilterProvider);
                        final hasActiveFilters = (filter.types?.isNotEmpty ?? false) || 
                                                 filter.isInternal != null;
                        if (hasActiveFilters) {
                          return Positioned(
                            top: 8,
                            right: 8,
                            child: Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: TossColors.primary,
                                shape: BoxShape.circle,
                              ),
                            ),
                          );
                        }
                        return SizedBox.shrink();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
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
                    size: 64,
                    color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.5),
                  ),
                  SizedBox(height: TossSpacing.space4),
                  Text(
                    'No counterparties yet',
                    style: TossTextStyles.h3.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  SizedBox(height: TossSpacing.space2),
                  Text(
                    'Tap the + button to add your first counterparty',
                    style: TossTextStyles.body.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        // Apply search filter
        final searchQuery = ref.watch(counterPartySearchProvider).toLowerCase();
        final filteredList = searchQuery.isEmpty
            ? counterParties
            : counterParties.where((cp) {
                return cp.name.toLowerCase().contains(searchQuery) ||
                    (cp.email?.toLowerCase().contains(searchQuery) ?? false) ||
                    (cp.phone?.contains(searchQuery) ?? false);
              }).toList();

        return SliverPadding(
          padding: EdgeInsets.all(TossSpacing.space4),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final counterParty = filteredList[index];
                return Padding(
                  padding: EdgeInsets.only(bottom: TossSpacing.space3),
                  child: CounterPartyListItem(
                    counterParty: counterParty,
                    onTap: () => _showEditForm(counterParty),
                  ),
                );
              },
              childCount: filteredList.length,
            ),
          ),
        );
      },
      loading: () => SliverFillRemaining(
        child: Center(
          child: CircularProgressIndicator(
            color: Theme.of(context).colorScheme.primary,
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
                size: 48,
                color: Theme.of(context).colorScheme.error,
              ),
              SizedBox(height: TossSpacing.space4),
              Text(
                'Failed to load counterparties',
                style: TossTextStyles.h3.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              SizedBox(height: TossSpacing.space2),
              Text(
                error.toString(),
                style: TossTextStyles.body.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: TossSpacing.space4),
              TextButton(
                onPressed: _refreshData,
                child: Text(
                  'Retry',
                  style: TossTextStyles.body.copyWith(
                    color: Theme.of(context).colorScheme.primary,
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
      backgroundColor: Colors.transparent,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: CounterPartyForm(counterParty: counterParty),
      ),
    );
  }
}