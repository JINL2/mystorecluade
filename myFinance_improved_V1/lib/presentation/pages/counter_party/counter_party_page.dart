import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
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
import 'widgets/counter_party_form.dart';
import '../../providers/app_state_provider.dart';
import '../../widgets/common/toss_scaffold.dart';
import '../../widgets/common/toss_app_bar.dart';
import '../../widgets/SB_widget/SB_searchbar_filter.dart';
import '../../widgets/SB_widget/SB_headline_group.dart';

class CounterPartyPage extends ConsumerStatefulWidget {
  const CounterPartyPage({super.key});

  @override
  ConsumerState<CounterPartyPage> createState() => _CounterPartyPageState();
}

class _CounterPartyPageState extends ConsumerState<CounterPartyPage> 
    with WidgetsBindingObserver, TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  Timer? _searchDebounce;
  bool _showScrollToTop = false;
  String _searchQuery = '';
  
  // Animation controllers
  late AnimationController _filterAnimationController;
  late AnimationController _cardAnimationController;
  late Animation<double> _filterAnimation;
  late Animation<double> _cardAnimation;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _scrollController.addListener(_onScroll);
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase();
      });
    });
    
    // Initialize animation controllers
    _filterAnimationController = AnimationController(
      duration: TossAnimations.normal,
      vsync: this,
    );
    _cardAnimationController = AnimationController(
      duration: TossAnimations.medium,
      vsync: this,
    );
    
    _filterAnimation = CurvedAnimation(
      parent: _filterAnimationController,
      curve: TossAnimations.standard,
    );
    _cardAnimation = CurvedAnimation(
      parent: _cardAnimationController,
      curve: TossAnimations.standard,
    );
    
    // Start animations
    _filterAnimationController.forward();
    _cardAnimationController.forward();
    
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
    WidgetsBinding.instance.removeObserver(this);
    _scrollController.dispose();
    _searchController.dispose();
    _searchDebounce?.cancel();
    _filterAnimationController.dispose();
    _cardAnimationController.dispose();
    super.dispose();
  }
  
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _refreshData();
    }
  }
  
  void _onScroll() {
    if (_scrollController.offset > 200 && !_showScrollToTop) {
      setState(() => _showScrollToTop = true);
    } else if (_scrollController.offset <= 200 && _showScrollToTop) {
      setState(() => _showScrollToTop = false);
    }
  }

  // Debounced search to prevent excessive rebuilds
  void _onSearchChanged(String value) {
    _searchDebounce?.cancel();
    _searchDebounce = Timer(TossAnimations.slow, () {
      setState(() {
        _searchQuery = value.toLowerCase();
      });
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
        maxHeight: MediaQuery.of(context).size.height * 0.85,
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

    return TossScaffold(
      backgroundColor: TossColors.gray100,
      appBar: TossAppBar(
        title: 'Counter Party',
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: TossColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        primaryActionText: 'Add',
        primaryActionIcon: Icons.add,
        onPrimaryAction: _showCreateForm,
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        color: TossColors.primary,
        child: Stack(
          children: [
            CustomScrollView(
              controller: _scrollController,
              slivers: [
                // Stats Section
                SliverToBoxAdapter(
                  child: FadeTransition(
                    opacity: _filterAnimation,
                    child: _buildStatsSection(statsAsync),
                  ),
                ),
                
                // Search and Filter Section
                SliverToBoxAdapter(
                  child: FadeTransition(
                    opacity: _filterAnimation,
                    child: _buildSearchFilterSection(),
                  ),
                ),
                
                // Counter Party List
                _buildCounterPartyList(context, counterPartiesAsync),
              ],
            ),
            
            // Floating Action Buttons
            if (counterPartiesAsync.hasValue && counterPartiesAsync.value!.isNotEmpty)
              _buildFloatingActions(),
          ],
        ),
      ),
    );
  }


  Widget _buildStatsSection(AsyncValue<CounterPartyStats> statsAsync) {
    return Container(
      margin: EdgeInsets.fromLTRB(
        TossSpacing.space4,
        TossSpacing.space4,
        TossSpacing.space4,
        TossSpacing.space3,
      ),
      child: statsAsync.when(
        data: (stats) => Column(
          children: [
            // Total Counter Parties Header
            _buildTotalHeader(
              total: stats.total,
              internal: stats.myCompanies + stats.teamMembers + stats.employees,
              external: stats.suppliers + stats.customers + stats.others,
            ),
            
            SizedBox(height: TossSpacing.space4),
            
            // 6 Card Grid Layout
            GridView.count(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              crossAxisCount: 3,
              childAspectRatio: 1.05,
              mainAxisSpacing: TossSpacing.space2,
              crossAxisSpacing: TossSpacing.space2,
              children: [
                _buildSimpleStatCard(
                  label: 'My Company',
                  count: stats.myCompanies,
                  icon: Icons.business,
                  isSelected: false,
                  isInternal: true,
                ),
                _buildSimpleStatCard(
                  label: 'Team Member',
                  count: stats.teamMembers,
                  icon: Icons.people_outline,
                  isSelected: false,
                  isInternal: true,
                ),
                _buildSimpleStatCard(
                  label: 'Suppliers',
                  count: stats.suppliers,
                  icon: Icons.local_shipping_outlined,
                  isSelected: false,
                  isInternal: false,
                ),
                _buildSimpleStatCard(
                  label: 'Employees',
                  count: stats.employees,
                  icon: Icons.badge_outlined,
                  isSelected: false,
                  isInternal: true,
                ),
                _buildSimpleStatCard(
                  label: 'Customers',
                  count: stats.customers,
                  icon: Icons.shopping_bag_outlined,
                  isSelected: false,
                  isInternal: false,
                ),
                _buildSimpleStatCard(
                  label: 'Others',
                  count: stats.others,
                  icon: Icons.category_outlined,
                  isSelected: false,
                  isInternal: false,
                ),
              ],
            ),
          ],
        ),
        loading: () => Column(
          children: [
            _buildTotalHeader(total: 0, internal: 0, external: 0),
            SizedBox(height: TossSpacing.space4),
            GridView.count(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              crossAxisCount: 3,
              childAspectRatio: 1.05,
              mainAxisSpacing: TossSpacing.space2,
              crossAxisSpacing: TossSpacing.space2,
              children: [
                // Internal cards
                _buildSimpleStatCard(
                  label: 'My Company',
                  count: 0,
                  icon: Icons.business,
                  isSelected: false,
                  isInternal: true,
                  isLoading: true,
                ),
                _buildSimpleStatCard(
                  label: 'Team Member',
                  count: 0,
                  icon: Icons.people_outline,
                  isSelected: false,
                  isInternal: true,
                  isLoading: true,
                ),
                _buildSimpleStatCard(
                  label: 'Suppliers',
                  count: 0,
                  icon: Icons.local_shipping_outlined,
                  isSelected: false,
                  isInternal: false,
                  isLoading: true,
                ),
                _buildSimpleStatCard(
                  label: 'Employees',
                  count: 0,
                  icon: Icons.badge_outlined,
                  isSelected: false,
                  isInternal: true,
                  isLoading: true,
                ),
                _buildSimpleStatCard(
                  label: 'Customers',
                  count: 0,
                  icon: Icons.shopping_bag_outlined,
                  isSelected: false,
                  isInternal: false,
                  isLoading: true,
                ),
                _buildSimpleStatCard(
                  label: 'Others',
                  count: 0,
                  icon: Icons.category_outlined,
                  isSelected: false,
                  isInternal: false,
                  isLoading: true,
                ),
              ],
            ),
          ],
        ),
        error: (error, _) => Center(
          child: Column(
            children: [
              Icon(
                Icons.error_outline,
                size: 48,
                color: TossColors.error,
              ),
              SizedBox(height: TossSpacing.space3),
              Text(
                'Unable to load statistics',
                style: TossTextStyles.body.copyWith(
                  color: TossColors.error,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildModernStatCard({
    required String value,
    required String label,
    required IconData icon,
    required Color color,
  }) {
    // Create background colors based on the primary color
    final backgroundColor = color == TossColors.primary 
        ? Color(0xFFE8F0FF)  // Light blue
        : color == TossColors.success 
            ? Color(0xFFE8F5E9)  // Light green
            : color == TossColors.warning
                ? Color(0xFFFFF3E0)  // Light orange
                : Color(0xFFE3F2FD);  // Light info blue
    
    return Container(
      height: 72,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: TossSpacing.space3,
          vertical: TossSpacing.space2,
        ),
        child: Row(
          children: [
            // Left side - Text content
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    value,
                    style: TossTextStyles.h3.copyWith(
                      color: TossColors.gray900,
                      fontWeight: FontWeight.w800,
                      fontSize: 28,
                      height: 1.1,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    label,
                    style: TossTextStyles.caption.copyWith(
                      color: TossColors.gray600,
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            
            // Right side - Icon
            Container(
              padding: EdgeInsets.all(TossSpacing.space2),
              child: Icon(
                icon,
                color: color.withValues(alpha: 0.7),
                size: 22,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTotalHeader({
    required int total,
    required int internal,
    required int external,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: TossSpacing.space2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          // Total count
          Text(
            total.toString(),
            style: TossTextStyles.h1.copyWith(
              color: TossColors.textPrimary,
              fontWeight: FontWeight.w700,
              fontSize: 32,
            ),
          ),
          SizedBox(width: TossSpacing.space2),
          
          // Label
          Text(
            'Counter Parties',
            style: TossTextStyles.body.copyWith(
              color: TossColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
          
          Spacer(),
          
          // Subtle breakdown info
          if (total > 0)
            Row(
              children: [
                _buildCountBadge(
                  count: internal,
                  label: 'internal',
                  color: TossColors.primary,
                ),
                SizedBox(width: TossSpacing.space2),
                _buildCountBadge(
                  count: external,
                  label: 'external',
                  color: TossColors.warning,
                ),
              ],
            ),
        ],
      ),
    );
  }
  
  Widget _buildCountBadge({
    required int count,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: TossSpacing.space2,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(TossBorderRadius.full),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 4),
          Text(
            '$count',
            style: TossTextStyles.caption.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
          SizedBox(width: 4),
          Text(
            label,
            style: TossTextStyles.caption.copyWith(
              color: color.withValues(alpha: 0.8),
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSimpleStatCard({
    required String label,
    required int count,
    required IconData icon,
    required bool isSelected,
    bool isInternal = false,
    bool isLoading = false,
  }) {
    // Determine colors based on internal/external category
    final Color baseColor = isInternal ? TossColors.primary : TossColors.warning;
    final Color backgroundColor = isSelected 
        ? baseColor.withValues(alpha: 0.15)
        : isInternal 
            ? Color(0xFFF8FBFF)  // Very light blue tint for internal
            : Color(0xFFFFFBF8); // Very light warm tint for external
    
    final Color iconBackgroundColor = baseColor.withValues(alpha: 0.08);
    final Color borderColor = isSelected 
        ? baseColor 
        : baseColor.withValues(alpha: 0.15);
    
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          // Handle card tap for filtering
        },
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        child: Container(
          padding: EdgeInsets.all(TossSpacing.space3),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(TossBorderRadius.lg),
            border: Border.all(
              color: borderColor,
              width: isSelected ? 1.5 : 1,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon with subtle background
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: iconBackgroundColor,
                  borderRadius: BorderRadius.circular(TossBorderRadius.md),
                ),
                child: Center(
                  child: isLoading
                      ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: baseColor,
                            strokeWidth: 2,
                          ),
                        )
                      : Icon(
                          icon,
                          size: 24,
                          color: baseColor,
                        ),
                ),
              ),
              SizedBox(height: TossSpacing.space2),
              Text(
                isLoading ? '-' : count.toString(),
                style: TossTextStyles.h3.copyWith(
                  color: TossColors.textPrimary,
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                ),
              ),
              SizedBox(height: 2),
              Text(
                label,
                style: TossTextStyles.caption.copyWith(
                  color: TossColors.textSecondary,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildSearchFilterSection() {
    return Container(
      margin: const EdgeInsets.fromLTRB(
        TossSpacing.space4,
        TossSpacing.space3,
        TossSpacing.space4,
        TossSpacing.space4,
      ),
      child: SBSearchBarFilter(
        searchController: _searchController,
        searchHint: 'Search counterparties...',
        onSearchChanged: _onSearchChanged,
        onFilterTap: _showFilterOptionsSheet,
      ),
    );
  }


  bool _hasActiveFilters() {
    final filter = ref.watch(counterPartyFilterProvider);
    return (filter.types?.isNotEmpty ?? false) || filter.isInternal != null || filter.sortBy != CounterPartySortOption.name || !filter.ascending;
  }
  
  int _getActiveFilterCount() {
    final filter = ref.watch(counterPartyFilterProvider);
    int count = 0;
    if (filter.types?.isNotEmpty ?? false) count++;
    if (filter.isInternal != null) count++;
    if (filter.sortBy != CounterPartySortOption.name || !filter.ascending) count++;
    return count;
  }

  void _showFilterOptionsSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: TossColors.transparent,
      builder: (context) => _buildFilterSheet(),
    );
  }

  Widget _buildFilterSheet() {
    
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.8,
      ),
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
          
          // Header with title and clear all
          Container(
            padding: EdgeInsets.all(TossSpacing.space4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Filter Counter Parties',
                  style: TossTextStyles.h3.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (_hasActiveFilters())
                  TextButton(
                    onPressed: () {
                      ref.read(counterPartyFilterProvider.notifier).state = CounterPartyFilter();
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Clear All',
                      style: TossTextStyles.body.copyWith(
                        color: TossColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          
          // Filter Categories (Scrollable)
          Flexible(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildFilterCategory('Type', Icons.category_outlined),
                  _buildFilterCategory('Location', Icons.location_on_outlined),
                  _buildFilterCategory('Sort By', Icons.sort_outlined),
                ],
              ),
            ),
          ),
          
          // Active Filters Summary
          if (_hasActiveFilters())
            Container(
              margin: EdgeInsets.all(TossSpacing.space4),
              padding: EdgeInsets.all(TossSpacing.space3),
              decoration: BoxDecoration(
                color: TossColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(TossBorderRadius.md),
                border: Border.all(
                  color: TossColors.primary.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.filter_list_rounded,
                    color: TossColors.primary,
                    size: 20,
                  ),
                  SizedBox(width: TossSpacing.space2),
                  Expanded(
                    child: Text(
                      '${_getActiveFilterCount()} filter${_getActiveFilterCount() > 1 ? 's' : ''} active',
                      style: TossTextStyles.body.copyWith(
                        color: TossColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          
          SizedBox(height: TossSpacing.space2),
        ],
      ),
    );
  }

  Widget _buildFilterCategory(String title, IconData icon) {
    final filter = ref.watch(counterPartyFilterProvider);
    
    return Column(
      children: [
        // Category Header
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: TossSpacing.space4,
            vertical: TossSpacing.space2,
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: 20,
                color: TossColors.gray600,
              ),
              SizedBox(width: TossSpacing.space2),
              Text(
                title,
                style: TossTextStyles.body.copyWith(
                  fontWeight: FontWeight.w600,
                  color: TossColors.gray800,
                ),
              ),
            ],
          ),
        ),
        
        if (title == 'Type') ...[
          _buildFilterOption('All Types', null, filter.types == null || filter.types!.isEmpty),
          _buildFilterOption('My Company', CounterPartyType.myCompany, filter.types?.contains(CounterPartyType.myCompany) ?? false),
          _buildFilterOption('Team Member', CounterPartyType.teamMember, filter.types?.contains(CounterPartyType.teamMember) ?? false),
          _buildFilterOption('Suppliers', CounterPartyType.supplier, filter.types?.contains(CounterPartyType.supplier) ?? false),
          _buildFilterOption('Employees', CounterPartyType.employee, filter.types?.contains(CounterPartyType.employee) ?? false),
          _buildFilterOption('Customers', CounterPartyType.customer, filter.types?.contains(CounterPartyType.customer) ?? false),
          _buildFilterOption('Others', CounterPartyType.other, filter.types?.contains(CounterPartyType.other) ?? false),
        ] else if (title == 'Location') ...[
          _buildLocationOption('All Locations', null, filter.isInternal == null),
          _buildLocationOption('Internal Only', true, filter.isInternal == true),
          _buildLocationOption('External Only', false, filter.isInternal == false),
        ] else if (title == 'Sort By') ...[
          _buildSortOption('Name', CounterPartySortOption.name, filter.sortBy == CounterPartySortOption.name, filter.ascending),
          _buildSortOption('Type', CounterPartySortOption.type, filter.sortBy == CounterPartySortOption.type, filter.ascending),
          _buildSortOption('Created Date', CounterPartySortOption.createdAt, filter.sortBy == CounterPartySortOption.createdAt, filter.ascending),
        ],
        
        SizedBox(height: TossSpacing.space2),
      ],
    );
  }
  
  Widget _buildFilterOption(String text, CounterPartyType? type, bool isSelected) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          final currentFilter = ref.read(counterPartyFilterProvider);
          List<CounterPartyType>? newTypes;
          
          if (type == null) {
            newTypes = null;
          } else {
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
        },
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: TossSpacing.space6,
            vertical: TossSpacing.space3,
          ),
          child: Row(
            children: [
              SizedBox(width: TossSpacing.space6), // Indentation
              Expanded(
                child: Text(
                  text,
                  style: TossTextStyles.body.copyWith(
                    color: isSelected ? TossColors.primary : TossColors.gray700,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ),
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
  }
  
  Widget _buildLocationOption(String text, bool? isInternal, bool isSelected) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          final currentFilter = ref.read(counterPartyFilterProvider);
          ref.read(counterPartyFilterProvider.notifier).state = currentFilter.copyWith(
            isInternal: isInternal,
          );
        },
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: TossSpacing.space6,
            vertical: TossSpacing.space3,
          ),
          child: Row(
            children: [
              SizedBox(width: TossSpacing.space6), // Indentation
              Expanded(
                child: Text(
                  text,
                  style: TossTextStyles.body.copyWith(
                    color: isSelected ? TossColors.primary : TossColors.gray700,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ),
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
  }
  
  Widget _buildSortOption(String text, CounterPartySortOption sortBy, bool isSelected, bool ascending) {
    String displayText = text;
    if (isSelected) {
      switch (sortBy) {
        case CounterPartySortOption.name:
        case CounterPartySortOption.type:
          displayText += ' (${ascending ? 'A-Z' : 'Z-A'})';
          break;
        case CounterPartySortOption.createdAt:
          displayText += ' (${ascending ? 'Old-New' : 'New-Old'})';
          break;
        case CounterPartySortOption.isInternal:
          displayText += ' (${ascending ? 'External First' : 'Internal First'})';
          break;
      }
    }
    
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          final currentFilter = ref.read(counterPartyFilterProvider);
          final newAscending = currentFilter.sortBy == sortBy ? !currentFilter.ascending : true;
          
          ref.read(counterPartyFilterProvider.notifier).state = 
              currentFilter.copyWith(sortBy: sortBy, ascending: newAscending);
        },
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: TossSpacing.space6,
            vertical: TossSpacing.space3,
          ),
          child: Row(
            children: [
              SizedBox(width: TossSpacing.space6), // Indentation
              Expanded(
                child: Text(
                  displayText,
                  style: TossTextStyles.body.copyWith(
                    color: isSelected ? TossColors.primary : TossColors.gray700,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ),
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
  }


  Widget _buildCounterPartyList(
    BuildContext context,
    AsyncValue<List<CounterParty>> counterPartiesAsync,
  ) {
    return counterPartiesAsync.when(
      data: (allCounterParties) {
        // Apply search filter
        final counterParties = _searchQuery.isEmpty
            ? allCounterParties
            : allCounterParties.where((cp) {
                final name = cp.name.toLowerCase();
                final type = cp.type.displayName.toLowerCase();
                final location = cp.isInternal ? 'internal' : 'external';
                
                return name.contains(_searchQuery) ||
                       type.contains(_searchQuery) ||
                       location.contains(_searchQuery);
              }).toList();
        
        if (counterParties.isEmpty) {
          return SliverFillRemaining(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _searchQuery.isNotEmpty || _hasActiveFilters()
                        ? Icons.search_off_rounded
                        : Icons.people_outline,
                    size: 64,
                    color: TossColors.gray400,
                  ),
                  SizedBox(height: TossSpacing.space4),
                  Text(
                    _searchQuery.isNotEmpty || _hasActiveFilters()
                        ? 'No results found'
                        : 'No counterparties yet',
                    style: TossTextStyles.h3.copyWith(
                      color: TossColors.textSecondary,
                    ),
                  ),
                  SizedBox(height: TossSpacing.space2),
                  Text(
                    _searchQuery.isNotEmpty || _hasActiveFilters()
                        ? 'Try adjusting your search or filters'
                        : 'Tap the + button to add your first counterparty',
                    style: TossTextStyles.body.copyWith(
                      color: TossColors.textTertiary,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return SliverPadding(
          padding: EdgeInsets.only(
            left: TossSpacing.space4,
            right: TossSpacing.space4,
            bottom: TossSpacing.space4,
          ),
          sliver: SliverToBoxAdapter(
            child: FadeTransition(
              opacity: _cardAnimation,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 0.05),
                  end: Offset.zero,
                ).animate(_cardAnimation),
                child: _buildCounterPartyListSection(counterParties),
              ),
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
                size: 64,
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
  
  Widget _buildCounterPartyListSection(List<CounterParty> counterParties) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header - No background, separated from list
        SBHeadlineGroup(
          title: 'Counter Parties',
        ),
        
        // Counter Party List Container
        Container(
          decoration: BoxDecoration(
            color: TossColors.surface,
            borderRadius: BorderRadius.circular(TossBorderRadius.lg),
          ),
          child: Column(
            children: [
              // Counter Party List
              ...counterParties.asMap().entries.map((entry) {
                final index = entry.key;
                final counterParty = entry.value;
                
                return Column(
                  children: [
                    _buildCounterPartyCard(counterParty, index),
                    if (index < counterParties.length - 1) 
                      Divider(
                        height: 1,
                        color: TossColors.gray100,
                        indent: TossSpacing.space4,
                        endIndent: TossSpacing.space4,
                      ),
                  ],
                );
              }).toList(),
            ],
          ),
        ),
      ],
    );
  }
  
  Widget _buildCounterPartyCard(CounterParty counterParty, int index) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _showEditForm(counterParty),
        onLongPress: () => _showCounterPartyOptions(counterParty),
        borderRadius: index == 0 
            ? BorderRadius.only(
                topLeft: Radius.circular(TossBorderRadius.lg),
                topRight: Radius.circular(TossBorderRadius.lg),
              )
            : BorderRadius.zero,
        child: Container(
          padding: EdgeInsets.all(TossSpacing.space4),
          child: Row(
            children: [
              // Type Icon with color
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: CounterPartyColors.getTypeColor(counterParty.type).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(28),
                ),
                child: Center(
                  child: Icon(
                    CounterPartyColors.getTypeIcon(counterParty.type),
                    size: 24,
                    color: CounterPartyColors.getTypeColor(counterParty.type),
                  ),
                ),
              ),
              
              SizedBox(width: TossSpacing.space4),
              
              // Counter Party Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name with internal/external indicator
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            counterParty.name,
                            style: TossTextStyles.body.copyWith(
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: TossSpacing.space2),
                          padding: EdgeInsets.symmetric(
                            horizontal: TossSpacing.space2,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: counterParty.isInternal 
                                ? TossColors.primary.withValues(alpha: 0.1)
                                : TossColors.warning.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                          ),
                          child: Text(
                            counterParty.isInternal ? 'Internal' : 'External',
                            style: TossTextStyles.caption.copyWith(
                              color: counterParty.isInternal 
                                  ? TossColors.primary
                                  : TossColors.warning,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: TossSpacing.space1),
                    // Type info
                    Text(
                      counterParty.type.displayName,
                      style: TossTextStyles.caption.copyWith(
                        color: Colors.grey[600],
                        fontSize: 13,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              
              // Actions
              if (counterParty.isInternal)
                IconButton(
                  icon: Icon(
                    Icons.settings_outlined,
                    color: TossColors.gray600,
                    size: 20,
                  ),
                  onPressed: () {
                    context.push('/debtAccountSettings/${counterParty.counterpartyId}/${Uri.encodeComponent(counterParty.name)}');
                  },
                ),
              
              // Arrow icon
              Icon(
                Icons.chevron_right,
                color: Colors.grey[400],
                size: 22,
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  void _showCounterPartyOptions(CounterParty counterParty) {
    showModalBottomSheet(
      context: context,
      backgroundColor: TossColors.transparent,
      builder: (context) => Container(
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
            
            // Options
            ListTile(
              leading: Icon(Icons.edit, color: TossColors.primary),
              title: Text('Edit'),
              onTap: () {
                Navigator.pop(context);
                _showEditForm(counterParty);
              },
            ),
            if (counterParty.isInternal)
              ListTile(
                leading: Icon(Icons.settings, color: TossColors.gray700),
                title: Text('Account Settings'),
                onTap: () {
                  Navigator.pop(context);
                  context.push('/debtAccountSettings/${counterParty.counterpartyId}/${Uri.encodeComponent(counterParty.name)}');
                },
              ),
            ListTile(
              leading: Icon(Icons.delete, color: TossColors.error),
              title: Text('Delete', style: TextStyle(color: TossColors.error)),
              onTap: () {
                Navigator.pop(context);
                _deleteCounterParty(counterParty);
              },
            ),
            
            SizedBox(height: TossSpacing.space2),
          ],
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
        maxHeight: MediaQuery.of(context).size.height * 0.85,
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
  
  Widget _buildFloatingActions() {
    return Positioned(
      bottom: TossSpacing.space4,
      right: TossSpacing.space4,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Scroll to Top FAB
          AnimatedScale(
            scale: _showScrollToTop ? 1.0 : 0.0,
            duration: TossAnimations.normal,
            curve: TossAnimations.standard,
            child: FloatingActionButton.small(
              heroTag: 'scroll_to_top',
              backgroundColor: TossColors.surface,
              foregroundColor: TossColors.primary,
              elevation: 4,
              onPressed: () {
                _scrollController.animateTo(
                  0,
                  duration: TossAnimations.medium,
                  curve: TossAnimations.decelerate,
                );
              },
              child: Icon(Icons.arrow_upward_rounded),
            ),
          ),
        ],
      ),
    );
  }
}