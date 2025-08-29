import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/themes/toss_text_styles.dart';
import '../../../core/themes/toss_spacing.dart';
import '../../../core/themes/toss_border_radius.dart';
import '../../../core/themes/toss_shadows.dart';
import '../../../core/themes/toss_colors.dart';
import '../../../core/themes/toss_animations.dart';
import '../../providers/app_state_provider.dart';
import '../../widgets/toss/toss_tab_bar.dart';
import '../../../data/services/cash_location_service.dart';
import 'add_account_page.dart';
import 'total_journal_page.dart';
import 'total_real_page.dart';
import 'bank_real_page.dart';
import 'vault_real_page.dart';
import '../../widgets/common/toss_scaffold.dart';
import '../../widgets/common/toss_app_bar.dart';
import '../../../core/navigation/safe_navigation.dart';

class CashLocationPage extends ConsumerStatefulWidget {
  const CashLocationPage({super.key});

  @override
  ConsumerState<CashLocationPage> createState() => _CashLocationPageState();
}

class _CashLocationPageState extends ConsumerState<CashLocationPage>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  late TabController _tabController;
  late AnimationController _entryController;
  late AnimationController _refreshController;
  late AnimationController _loadingController;
  late List<Animation<double>> _animations;
  late Animation<double> _loadingAnimation;
  int _selectedTab = 0;
  bool _isRefreshing = false;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      if (_selectedTab != _tabController.index) {
        setState(() {
          _selectedTab = _tabController.index;
        });
        // Reset and replay animations when switching tabs
        _entryController.reset();
        _entryController.forward();
      }
    });
    
    // Setup animations
    _setupAnimations();
    
    // Add observer to detect when app comes to foreground
    WidgetsBinding.instance.addObserver(this);
    
    // Force initial data refresh
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _forceRefreshData();
      _entryController.forward();
    });
  }
  
  void _setupAnimations() {
    _entryController = AnimationController(
      duration: TossAnimations.slower,  // 400ms for entrance animations
      vsync: this,
    );
    
    _refreshController = AnimationController(
      duration: TossAnimations.medium,  // 250ms for refresh animations
      vsync: this,
    );
    
    _loadingController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    
    // Create staggered animations for balance and accounts sections
    _animations = [
      // Balance section animation - starts immediately
      Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
          parent: _entryController,
          curve: const Interval(0, 0.6, curve: Curves.easeOutCubic),
        ),
      ),
      // Accounts section animation - starts slightly delayed
      Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
          parent: _entryController,
          curve: const Interval(0.15, 0.75, curve: Curves.easeOutCubic),
        ),
      ),
    ];
    
    // Circular loading animation
    _loadingAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _loadingController,
        curve: Curves.linear,
      ),
    );
  }
  
  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _tabController.dispose();
    _entryController.dispose();
    _refreshController.dispose();
    _loadingController.dispose();
    super.dispose();
  }
  
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    // Refresh data when app returns to foreground
    if (state == AppLifecycleState.resumed) {
      print('App resumed - refreshing cash location data');
      _forceRefreshData();
    }
  }
  
  Future<void> _refreshData() async {
    if (_isRefreshing) return;
    
    setState(() {
      _isRefreshing = true;
    });
    
    // Start circular loading animation
    _loadingController.repeat();
    
    // Reset animations for fresh display after refresh
    _entryController.reset();
    
    try {
      final appState = ref.read(appStateProvider);
      final companyId = appState.companyChoosen;
      final storeId = appState.storeChoosen;
      
      if (companyId.isNotEmpty && storeId.isNotEmpty) {
        print('Refreshing cash location data via pull-to-refresh');
        
        // Add a small delay to ensure loading animation is visible
        await Future.delayed(const Duration(milliseconds: 300));
        
        // Invalidate the provider to force a refresh
        ref.invalidate(allCashLocationsProvider(
          CashLocationQueryParams(
            companyId: companyId, 
            storeId: storeId,
          ),
        ));
        
        // Force the provider to re-fetch by reading it again
        await ref.read(allCashLocationsProvider(
          CashLocationQueryParams(
            companyId: companyId,
            storeId: storeId,
          ),
        ).future);
        
        // Stop loading animation and play entrance animation
        _loadingController.stop();
        _loadingController.reset();
        // Play entrance animation for smooth transition
        _entryController.forward();
        
        // Show success feedback
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Data refreshed successfully'),
              backgroundColor: TossColors.success,
              behavior: SnackBarBehavior.floating,
              duration: const Duration(seconds: 2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
        }
      }
    } catch (e) {
      print('Error refreshing cash location data: $e');
      // Show error feedback
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to refresh: ${e.toString()}'),
            backgroundColor: TossColors.error,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 3),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
    } finally {
      // Stop loading animation and reset state
      if (mounted) {
        _loadingController.stop();
        _loadingController.reset();
        setState(() {
          _isRefreshing = false;
        });
      }
    }
  }
  
  // Force refresh without showing feedback (for navigation and lifecycle)
  void _forceRefreshData() {
    final appState = ref.read(appStateProvider);
    final companyId = appState.companyChoosen;
    final storeId = appState.storeChoosen;
    
    if (companyId.isNotEmpty && storeId.isNotEmpty) {
      print('Force refreshing cash location data');
      // Invalidate to ensure fresh data
      ref.invalidate(allCashLocationsProvider(
        CashLocationQueryParams(
          companyId: companyId,
          storeId: storeId,
        ),
      ));
      
      // Replay animations when data refreshes
      _entryController.reset();
      _entryController.forward();
    }
  }
  
  String _formatCurrency(double amount, [String? currencySymbol]) {
    final formatter = NumberFormat('#,###', 'en_US');
    final symbol = currencySymbol ?? '';
    return '$symbol${formatter.format(amount.round())}';
  }
  
  String get _currentLocationType {
    switch (_selectedTab) {
      case 0:
        return 'cash';
      case 1:
        return 'bank';
      case 2:
        return 'vault';
      default:
        return 'cash';
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final appState = ref.watch(appStateProvider);
    final companyId = appState.companyChoosen;
    final storeId = appState.storeChoosen;
    
    if (companyId.isEmpty || storeId.isEmpty) {
      return TossScaffold(
        appBar: TossAppBar(
          title: 'Cash Control',
          backgroundColor: const Color(0xFFF7F8FA),
        ),
        backgroundColor: const Color(0xFFF7F8FA),
        body: SafeArea(
          child: Column(
            children: [
              _buildTabBar(),
              Expanded(
                child: Center(
                  child: Text(
                    'Please select a company and store',
                    style: TossTextStyles.body.copyWith(
                      color: Colors.grey[500],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
    
    final allLocationsAsync = ref.watch(allCashLocationsProvider(
      CashLocationQueryParams(
        companyId: companyId, 
        storeId: storeId,
      ),
    ));
    
    return TossScaffold(
      appBar: TossAppBar(
        title: 'Cash Control',
        backgroundColor: const Color(0xFFF7F8FA),
      ),
      backgroundColor: const Color(0xFFF7F8FA),
      body: SafeArea(
        child: Column(
          children: [
            // Tab Bar
            _buildTabBar(),
            
            // Content
            Expanded(
              child: allLocationsAsync.when(
                data: (allLocations) {
                  // Filter locations by selected tab
                  final filteredLocations = allLocations
                      .where((location) => location.locationType == _currentLocationType)
                      .toList();
                  
                  // Ensure animations play when data loads
                  if (_entryController.status == AnimationStatus.dismissed) {
                    _entryController.forward();
                  }
                  
                  return RefreshIndicator(
                    onRefresh: _refreshData,
                    color: Colors.transparent,
                    backgroundColor: Colors.transparent,
                    displacement: 0,
                    strokeWidth: 0,
                    edgeOffset: 0,  // Remove edge offset to prevent visual interference
                    child: CustomScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      slivers: [
                        // Loading indicator when refreshing
                        if (_isRefreshing)
                          SliverToBoxAdapter(
                            child: Container(
                              alignment: Alignment.center,
                              padding: EdgeInsets.symmetric(vertical: 12),
                              child: _buildLoadingIndicator(),
                            ),
                          ),
                        // Main content
                        SliverPadding(
                          padding: EdgeInsets.only(
                            left: TossSpacing.space4,
                            right: TossSpacing.space4,
                            top: _isRefreshing ? 0 : TossSpacing.space4,
                            bottom: 0,
                          ),
                          sliver: SliverList(
                            delegate: SliverChildListDelegate([
                              // Balance Section with animation - always visible
                              AnimatedBuilder(
                                animation: _animations[0],
                                builder: (context, child) {
                                  return Opacity(
                                    opacity: _animations[0].value,
                                    child: Transform.translate(
                                      offset: Offset(0, 20 * (1 - _animations[0].value)),
                                      child: Transform.scale(
                                        scale: 0.95 + (0.05 * _animations[0].value),
                                        child: child,
                                      ),
                                    ),
                                  );
                                },
                                child: _buildBalanceSection(filteredLocations),
                              ),
                              
                              SizedBox(height: TossSpacing.space3),
                              
                              // Accounts Section with animation - always visible
                              AnimatedBuilder(
                                animation: _animations[1],
                                builder: (context, child) {
                                  return Opacity(
                                    opacity: _animations[1].value,
                                    child: Transform.translate(
                                      offset: Offset(0, 20 * (1 - _animations[1].value)),
                                      child: Transform.scale(
                                        scale: 0.95 + (0.05 * _animations[1].value),
                                        child: child,
                                      ),
                                    ),
                                  );
                                },
                                child: _buildAccountsSection(filteredLocations),
                              ),
                            ]),
                          ),
                        ),
                      ],
                    ),
                  );
                },
                loading: () => Center(
                  child: _buildLoadingIndicator(),
                ),
                error: (error, stack) => RefreshIndicator(
                  onRefresh: _refreshData,
                  color: Colors.transparent,
                  backgroundColor: Colors.transparent,
                  displacement: 0,
                  strokeWidth: 0,
                  edgeOffset: 0,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Container(
                      height: MediaQuery.of(context).size.height - 200,
                      padding: EdgeInsets.all(TossSpacing.space5),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Error icon
                          Icon(
                            Icons.wifi_off_rounded,
                            size: 64,
                            color: Colors.grey[400],
                          ),
                          SizedBox(height: TossSpacing.space4),
                          Text(
                            'Connection Error',
                            style: TossTextStyles.h2.copyWith(
                              color: Colors.grey[700],
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: TossSpacing.space3),
                          Text(
                            'Unable to load cash locations.\nPlease check your internet connection.',
                            style: TossTextStyles.body.copyWith(
                              color: Colors.grey[500],
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: TossSpacing.space5),
                          // Retry button
                          ElevatedButton.icon(
                            onPressed: () => _refreshData(),
                            icon: Icon(Icons.refresh),
                            label: Text('Retry'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).colorScheme.primary,
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(
                                horizontal: TossSpacing.space5,
                                vertical: TossSpacing.space3,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(TossBorderRadius.md),
                              ),
                            ),
                          ),
                          // Show technical error details in debug mode
                          if (error.toString().contains('SocketException'))
                            Padding(
                              padding: EdgeInsets.only(top: TossSpacing.space4),
                              child: Container(
                                padding: EdgeInsets.all(TossSpacing.space3),
                                decoration: BoxDecoration(
                                  color: Colors.red[50],
                                  borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                                  border: Border.all(color: Colors.red[200]!),
                                ),
                                child: Text(
                                  'Network connection failed',
                                  style: TossTextStyles.caption.copyWith(
                                    color: Colors.red[700],
                                    fontSize: 12,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  // Removed _buildHeader method - now using TossAppBar
  
  Widget _buildTabBar() {
    return TossTabBar(
      tabs: const ['Cash', 'Bank', 'Vault'],
      controller: _tabController,
      onTabChanged: (index) {
        setState(() {
          _selectedTab = index;
        });
      },
    );
  }
  
  Widget _buildLoadingIndicator() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 20,
          height: 20,
          child: AnimatedBuilder(
            animation: _loadingAnimation,
            builder: (context, child) {
              return CustomPaint(
                painter: _CircularLoadingPainter(
                  progress: _loadingAnimation.value,
                  color: Theme.of(context).colorScheme.primary,
                ),
              );
            },
          ),
        ),
        SizedBox(width: TossSpacing.space2),
        Text(
          'Refreshing...',
          style: TossTextStyles.caption.copyWith(
            color: Theme.of(context).colorScheme.primary,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
  
  Widget _buildBalanceSection(List<CashLocation> cashLocations) {
    
    // Calculate totals from cash locations
    final totalJournal = cashLocations.fold<double>(
      0, (sum, location) => sum + location.totalJournalCashAmount
    );
    final totalReal = cashLocations.fold<double>(
      0, (sum, location) => sum + location.totalRealCashAmount
    );
    final totalError = totalReal - totalJournal;
    
    // Get currency symbol from first location (all should have same symbol)
    final currencySymbol = cashLocations.isNotEmpty ? cashLocations.first.currencySymbol : '';
    
    return Container(
      padding: EdgeInsets.all(TossSpacing.space5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        boxShadow: TossShadows.card,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Balance',
            style: TossTextStyles.body.copyWith(
              fontWeight: FontWeight.w700,
              fontSize: 17,
            ),
          ),
          SizedBox(height: TossSpacing.space4),
          
          // Total Journal
          _buildBalanceRow(
            'Total Journal',
            _formatCurrency(totalJournal, currencySymbol),
            isIncome: true,
          ),
          
          SizedBox(height: TossSpacing.space3),
          
          // Total Real (clickable for all tabs)
          _buildBalanceRow(
            'Total Real',
            _formatCurrency(totalReal, currencySymbol),
            isIncome: false,
            isClickable: true, // Now clickable for all tabs: cash, bank, vault
          ),
          
          // Divider
          Container(
            margin: EdgeInsets.symmetric(vertical: TossSpacing.space4),
            height: 1,
            color: const Color(0xFFE5E8EB),
          ),
          
          // Error
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Error',
                style: TossTextStyles.body.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                _formatCurrency(totalError, currencySymbol),
                style: TossTextStyles.h3.copyWith(
                  color: const Color(0xFFE53935),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildBalanceRow(String label, String amount, {required bool isIncome, bool isClickable = true}) {
    final Widget rowContent = Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(
                label,
                style: TossTextStyles.body.copyWith(
                  fontSize: 15,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Text(
                amount,
                style: TossTextStyles.body.copyWith(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(width: TossSpacing.space1),
              if (isClickable)
                Icon(
                  Icons.chevron_right,
                  size: 20,
                  color: Colors.grey[400],
                ),
            ],
          ),
        ],
    );
    
    if (!isClickable) {
      // Return non-clickable row (not used anymore, but kept for flexibility)
      return rowContent;
    }
    
    // Return clickable row with navigation
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () async {
        // Navigate to appropriate page based on label
        if (label.toLowerCase().contains('journal')) {
          // Total Journal works for all tabs (cash, bank, vault)
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TotalJournalPage(
                locationType: _currentLocationType,
                journalType: 'journal',
              ),
            ),
          );
        } else if (label.toLowerCase().contains('real')) {
          // Total Real works for all tabs
          if (_currentLocationType == 'cash') {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TotalRealPage(
                  locationType: _currentLocationType,
                ),
              ),
            );
          } else if (_currentLocationType == 'bank') {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const BankRealPage(),
              ),
            );
          } else if (_currentLocationType == 'vault') {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const VaultRealPage(),
              ),
            );
          }
        }
        
        // Force refresh data when returning from detail pages
        _forceRefreshData();
      },
      child: rowContent,
    );
  }
  
  Widget _buildAccountsSection(List<CashLocation> cashLocations) {
    // Calculate total for percentage calculations
    final totalAmount = cashLocations.fold<double>(
      0, (sum, location) => sum + location.totalJournalCashAmount
    );
    
    return Container(
      padding: EdgeInsets.only(
        left: TossSpacing.space5,
        right: TossSpacing.space5,
        top: TossSpacing.space5,
        bottom: TossSpacing.space4,  // Reduced bottom padding
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        boxShadow: TossShadows.card,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Accounts',
            style: TossTextStyles.body.copyWith(
              fontWeight: FontWeight.w700,
              fontSize: 17,
            ),
          ),
          SizedBox(height: TossSpacing.space3),
          
          ...cashLocations.asMap().entries.map((entry) {
            final index = entry.key;
            final location = entry.value;
            // Add staggered animation for each card
            return AnimatedBuilder(
              key: ValueKey('${_currentLocationType}_${location.locationId}'),
              animation: _entryController,
              builder: (context, child) {
                // Only staggered entrance animation, no refresh animation
                final delayFactor = (index * 0.1).clamp(0.0, 0.5);
                final progress = Curves.easeOutCubic.transform(
                  (_entryController.value - delayFactor).clamp(0.0, 1.0)
                );
                return Opacity(
                  opacity: progress,
                  child: Transform.translate(
                    offset: Offset(0, 15 * (1 - progress)),
                    child: Transform.scale(
                      scale: 0.95 + (0.05 * progress),
                      child: child,
                    ),
                  ),
                );
              },
              child: _buildAccountCard(location, totalAmount),
            );
          }),
          
          // Add New Account button with animation
          AnimatedBuilder(
            animation: _entryController,
            builder: (context, child) {
              // Only entrance animation with delay, no refresh animation
              final delayFactor = ((cashLocations.length * 0.1) + 0.2).clamp(0.0, 0.6);
              final progress = Curves.easeOutCubic.transform(
                (_entryController.value - delayFactor).clamp(0.0, 1.0)
              );
              return Opacity(
                opacity: progress,
                child: Transform.translate(
                  offset: Offset(0, 10 * (1 - progress)),
                  child: child,
                ),
              );
            },
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () async {
              // Navigate to Add Account page
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddAccountPage(
                    locationType: _currentLocationType,
                  ),
                ),
              );
              
              // Force refresh data when returning from add account page
              _forceRefreshData();
            },
            child: Container(
              padding: EdgeInsets.only(
                top: TossSpacing.space3,
                bottom: 0,  // No bottom padding
              ),
              child: Row(
                children: [
                  // Plus icon
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.add,
                      color: Colors.grey[600],
                      size: 24,
                    ),
                  ),
                  
                  SizedBox(width: TossSpacing.space3),
                  
                  // Text
                  Text(
                    _getAddAccountText(),
                    style: TossTextStyles.body.copyWith(
                      color: Colors.grey[600],
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),  // Closing GestureDetector
          ),  // Closing AnimatedBuilder
        ],
      ),
    );
  }
  
  Widget _buildAccountCard(CashLocation location, double totalAmount) {
    // Calculate percentage
    final percentage = totalAmount > 0 
        ? ((location.totalJournalCashAmount / totalAmount) * 100).round()
        : 0;
    
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () async {
        print('Navigating to account detail: ${location.locationName}');
        
        // Debug logging (uncomment for debugging)
        // print('Navigating to account detail:');
        // print('  locationId: ${location.locationId}');
        // print('  locationName: ${location.locationName}');
        // print('  locationType: $_currentLocationType');
        
        await context.safePush(
          '/cashLocation/account/${Uri.encodeComponent(location.locationName)}',
          extra: {
            'locationId': location.locationId,
            'locationType': _currentLocationType,
            'accountName': location.locationName,
            'totalJournal': location.totalJournalCashAmount.round(),
            'totalReal': location.totalRealCashAmount.round(),
            'cashDifference': location.cashDifference.round(),
            'currencySymbol': location.currencySymbol,
            // Legacy fields for compatibility (can be removed later)
            'balance': location.totalJournalCashAmount.round(),
            'errors': location.cashDifference.abs().round(),
          },
        );
        
        print('Returned from account detail - forcing refresh');
        // Force refresh data when returning from detail page
        _forceRefreshData();
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: TossSpacing.space3,  // Reduced vertical padding
        ),
        child: Row(
          children: [
              // Logo icon
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  _getLocationIcon(_currentLocationType),
                  color: Theme.of(context).colorScheme.primary,
                  size: 22,
                ),
              ),
              
              SizedBox(width: TossSpacing.space3),
              
              // Account details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      location.locationName,
                      style: TossTextStyles.body.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: TossSpacing.space1),
                    Text(
                      '$percentage% of total balance',
                      style: TossTextStyles.caption.copyWith(
                        color: Colors.grey[600],
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Total Journal and Error with arrow
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        _formatCurrency(location.totalJournalCashAmount, location.currencySymbol),
                        style: TossTextStyles.body.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                      SizedBox(height: TossSpacing.space1),
                      Text(
                        _formatCurrency(location.cashDifference.abs(), ''),
                        style: TossTextStyles.caption.copyWith(
                          color: const Color(0xFFE53935),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: TossSpacing.space2),
                  Icon(
                    Icons.chevron_right,
                    color: Colors.grey[400],
                    size: 22,
                  ),
                ],
              ),
            ],
          ),
        ),
      );
  }
  
  IconData _getLocationIcon(String type) {
    switch (type) {
      case 'bank':
        return Icons.account_balance_outlined;
      case 'vault':
        return Icons.lock_outline;
      case 'cash':
      default:
        return Icons.attach_money_outlined;
    }
  }
  
  String _getAddAccountText() {
    switch (_currentLocationType) {
      case 'bank':
        return 'Add New Bank Account';
      case 'vault':
        return 'Add New Vault Account';
      case 'cash':
      default:
        return 'Add New Cash Account';
    }
  }
}

class _CircularLoadingPainter extends CustomPainter {
  final double progress;
  final Color color;

  _CircularLoadingPainter({
    required this.progress,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2.5;  // Adjusted for smaller indicator
    
    // Background circle (light gray)
    final backgroundPaint = Paint()
      ..color = Colors.grey.withValues(alpha: 0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;
    
    canvas.drawCircle(center, radius, backgroundPaint);
    
    // Progress arc
    final progressPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;
    
    final startAngle = -90 * (3.14159 / 180);
    final sweepAngle = 360 * progress * (3.14159 / 180);
    
    canvas.drawArc(
      Rect.fromCenter(center: center, width: radius * 2, height: radius * 2),
      startAngle,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(_CircularLoadingPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.color != color;
  }
}