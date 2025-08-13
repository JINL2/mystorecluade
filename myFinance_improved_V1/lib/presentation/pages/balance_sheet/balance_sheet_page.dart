import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:myfinance_improved/core/themes/toss_colors.dart';
import 'package:myfinance_improved/core/themes/toss_text_styles.dart';
import 'package:myfinance_improved/core/themes/toss_spacing.dart';
import 'package:myfinance_improved/core/themes/toss_shadows.dart';
import 'package:myfinance_improved/core/themes/toss_border_radius.dart';
import 'providers/balance_sheet_providers.dart';
import '../../providers/app_state_provider.dart';
import '../../providers/auth_provider.dart';

class BalanceSheetPage extends ConsumerStatefulWidget {
  const BalanceSheetPage({super.key});

  @override
  ConsumerState<BalanceSheetPage> createState() => _BalanceSheetPageState();
}

class _BalanceSheetPageState extends ConsumerState<BalanceSheetPage> 
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late TabController _tabController;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        HapticFeedback.selectionClick();
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Watch the app state and providers exactly like homepage
    final userCompaniesAsync = ref.watch(userCompaniesProvider);
    final categoriesAsync = ref.watch(categoriesWithFeaturesProvider);
    final appState = ref.watch(appStateProvider);
    final selectedCompany = ref.watch(selectedCompanyProvider);
    final selectedStore = ref.watch(selectedStoreProvider);

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: TossColors.background,
      body: SafeArea(
        child: userCompaniesAsync.when(
          data: (userData) => Column(
            children: [
              // App Bar with Tabs
              Container(
                color: TossColors.background,
                child: Column(
                  children: [
                    // Title Bar
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: TossSpacing.space5,
                        vertical: TossSpacing.space4,
                      ),
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back_ios, size: 24),
                            onPressed: () => context.pop(),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                          const Spacer(),
                          Text(
                            'Financial Statements',
                            style: TossTextStyles.h3.copyWith(
                              color: TossColors.gray900,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const Spacer(),
                          _buildPeriodSelector(),
                        ],
                      ),
                    ),
                    
                    // Tab Bar - Toss Style (Same as Attendance)
                    Container(
                      height: 48,
                      margin: const EdgeInsets.symmetric(horizontal: TossSpacing.space5),
                      child: Stack(
                        children: [
                          // Background
                          Container(
                            decoration: BoxDecoration(
                              color: TossColors.gray100,
                              borderRadius: BorderRadius.circular(24),
                            ),
                          ),
                          // Tab Bar
                          TabBar(
                            controller: _tabController,
                            indicator: BoxDecoration(
                              color: TossColors.background,
                              borderRadius: BorderRadius.circular(22),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.08),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            indicatorSize: TabBarIndicatorSize.tab,
                            indicatorPadding: const EdgeInsets.all(2),
                            dividerColor: Colors.transparent,
                            labelColor: TossColors.gray900,
                            unselectedLabelColor: TossColors.gray500,
                            labelStyle: TossTextStyles.labelLarge.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                            unselectedLabelStyle: TossTextStyles.labelLarge.copyWith(
                              fontWeight: FontWeight.w400,
                            ),
                            splashBorderRadius: BorderRadius.circular(22),
                            tabs: const [
                              Tab(
                                text: 'Balance Sheet',
                                height: 44,
                              ),
                              Tab(
                                text: 'Income Statement',
                                height: 44,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: TossSpacing.space4),
                  ],
                ),
              ),
              
              // Tab Views
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    // Balance Sheet Tab
                    RefreshIndicator(
                      onRefresh: () => _handleRefresh(ref),
                      color: TossColors.primary,
                      child: CustomScrollView(
                        slivers: [
                          // Header Section with Total Balance
                          _buildHeaderSection(context, selectedCompany, selectedStore),
                          
                          // Balance Sheet Content
                          _buildBalanceSheetContent(context),
                        ],
                      ),
                    ),
                    
                    // Income Statement Tab
                    RefreshIndicator(
                      onRefresh: () => _handleRefresh(ref),
                      color: TossColors.primary,
                      child: CustomScrollView(
                        slivers: [
                          // Income Statement Content
                          _buildIncomeStatementContent(context),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        loading: () => Center(
          child: CircularProgressIndicator(
            color: TossColors.primary,
            strokeWidth: 2,
          ),
        ),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline_rounded, 
                size: 48, 
                color: TossColors.gray400,
              ),
              SizedBox(height: TossSpacing.space4),
              Text('Something went wrong', 
                style: TossTextStyles.body.copyWith(color: TossColors.gray700),
              ),
              SizedBox(height: TossSpacing.space2),
              Text(error.toString(), 
                style: TossTextStyles.caption.copyWith(color: TossColors.gray500),
              ),
            ],
          ),
        ),
        ),
      ),
    );
  }


  Widget _buildPeriodSelector() {
    return IconButton(
      icon: Icon(Icons.calendar_today_outlined,
        color: TossColors.gray600,
        size: 22,
      ),
      onPressed: () {
        // Show period selector
      },
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(),
    );
  }

  Widget _buildHeaderSection(BuildContext context, dynamic selectedCompany, dynamic selectedStore) {
    return SliverToBoxAdapter(
      child: Container(
        color: TossColors.background,
        child: Column(
          children: [
            // Company & Store Badge
            if (selectedCompany != null)
              Container(
                padding: EdgeInsets.symmetric(horizontal: TossSpacing.space4),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: TossSpacing.space3,
                        vertical: TossSpacing.space1,
                      ),
                      decoration: BoxDecoration(
                        color: TossColors.primary.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(TossBorderRadius.full),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: TossColors.primary,
                              shape: BoxShape.circle,
                            ),
                          ),
                          SizedBox(width: TossSpacing.space2),
                          Text(
                            selectedCompany['company_name'] ?? '',
                            style: TossTextStyles.labelSmall.copyWith(
                              color: TossColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          if (selectedStore != null) ...[
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: TossSpacing.space2),
                              width: 1,
                              height: 10,
                              color: TossColors.primary.withOpacity(0.3),
                            ),
                            Text(
                              selectedStore['store_name'] ?? '',
                              style: TossTextStyles.labelSmall.copyWith(
                                color: TossColors.primary.withOpacity(0.7),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            
            // Total Balance Card
            Container(
              margin: EdgeInsets.all(TossSpacing.space4),
              padding: EdgeInsets.all(TossSpacing.space5),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    TossColors.primary.withOpacity(0.03),
                    Colors.white,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(TossBorderRadius.xl),
                boxShadow: TossShadows.shadow2,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Total Assets',
                            style: TossTextStyles.caption.copyWith(
                              color: TossColors.gray500,
                              letterSpacing: 0.5,
                            ),
                          ),
                          SizedBox(height: TossSpacing.space2),
                          Text(
                            '\$2,458,320',
                            style: TossTextStyles.amount.copyWith(
                              color: TossColors.gray900,
                              fontSize: 32,
                            ),
                          ),
                        ],
                      ),
                      // Trend Indicator
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: TossSpacing.space3,
                          vertical: TossSpacing.space2,
                        ),
                        decoration: BoxDecoration(
                          color: TossColors.success.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(TossBorderRadius.full),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.trending_up_rounded, 
                              color: TossColors.success, 
                              size: 16,
                            ),
                            SizedBox(width: TossSpacing.space1),
                            Text(
                              '+12.5%',
                              style: TossTextStyles.label.copyWith(
                                color: TossColors.success,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: TossSpacing.space4),
                  
                  // Quick Stats Row
                  Row(
                    children: [
                      Expanded(
                        child: _buildQuickStat(
                          'Liabilities',
                          '\$842,100',
                          TossColors.gray700,
                        ),
                      ),
                      Container(
                        width: 1,
                        height: 40,
                        color: TossColors.gray200,
                      ),
                      Expanded(
                        child: _buildQuickStat(
                          'Equity',
                          '\$1,616,220',
                          TossColors.primary,
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
    );
  }

  Widget _buildQuickStat(String label, String value, Color valueColor) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: TossSpacing.space3),
      child: Column(
        children: [
          Text(
            label,
            style: TossTextStyles.caption.copyWith(
              color: TossColors.gray500,
            ),
          ),
          SizedBox(height: TossSpacing.space1),
          Text(
            value,
            style: TossTextStyles.bodyLarge.copyWith(
              color: valueColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildBalanceSheetContent(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        padding: EdgeInsets.all(TossSpacing.space4),
        child: Column(
          children: [
            // Assets Section
            _buildSectionCard(
              title: 'Assets',
              icon: Icons.account_balance_wallet_outlined,
              iconColor: TossColors.primary,
              items: [
                _buildLineItem('Current Assets', '', true, false),
                _buildLineItem('Cash & Cash Equivalents', '\$523,450', false, false),
                _buildLineItem('Accounts Receivable', '\$342,100', false, false),
                _buildLineItem('Inventory', '\$285,600', false, false),
                _buildLineItem('Prepaid Expenses', '\$65,200', false, false),
                _buildLineItem('Total Current Assets', '\$1,216,350', true, true),
                
                SizedBox(height: TossSpacing.space3),
                
                _buildLineItem('Non-Current Assets', '', true, false),
                _buildLineItem('Property & Equipment', '\$856,300', false, false),
                _buildLineItem('Intangible Assets', '\$125,000', false, false),
                _buildLineItem('Long-term Investments', '\$260,670', false, false),
                _buildLineItem('Total Non-Current Assets', '\$1,241,970', true, true),
                
                Divider(color: TossColors.gray200, height: TossSpacing.space6),
                _buildLineItem('Total Assets', '\$2,458,320', true, true, 
                  isHighlight: true),
              ],
            ),
            
            SizedBox(height: TossSpacing.space4),
            
            // Liabilities Section
            _buildSectionCard(
              title: 'Liabilities',
              icon: Icons.receipt_long_outlined,
              iconColor: TossColors.warning,
              items: [
                _buildLineItem('Current Liabilities', '', true, false),
                _buildLineItem('Accounts Payable', '\$186,200', false, false),
                _buildLineItem('Short-term Debt', '\$125,000', false, false),
                _buildLineItem('Accrued Expenses', '\$98,500', false, false),
                _buildLineItem('Total Current Liabilities', '\$409,700', true, true),
                
                SizedBox(height: TossSpacing.space3),
                
                _buildLineItem('Non-Current Liabilities', '', true, false),
                _buildLineItem('Long-term Debt', '\$350,000', false, false),
                _buildLineItem('Deferred Tax Liabilities', '\$82,400', false, false),
                _buildLineItem('Total Non-Current Liabilities', '\$432,400', true, true),
                
                Divider(color: TossColors.gray200, height: TossSpacing.space6),
                _buildLineItem('Total Liabilities', '\$842,100', true, true,
                  isHighlight: true),
              ],
            ),
            
            SizedBox(height: TossSpacing.space4),
            
            // Equity Section
            _buildSectionCard(
              title: "Shareholder's Equity",
              icon: Icons.pie_chart_outline,
              iconColor: TossColors.success,
              items: [
                _buildLineItem('Common Stock', '\$500,000', false, false),
                _buildLineItem('Retained Earnings', '\$1,016,220', false, false),
                _buildLineItem('Additional Paid-in Capital', '\$100,000', false, false),
                
                Divider(color: TossColors.gray200, height: TossSpacing.space6),
                _buildLineItem('Total Equity', '\$1,616,220', true, true,
                  isHighlight: true),
              ],
            ),
            
            SizedBox(height: TossSpacing.space4),
            
            // Financial Ratios Card
            _buildRatiosCard(),
            
            SizedBox(height: TossSpacing.space8),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required Color iconColor,
    required List<Widget> items,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: TossColors.background,
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        boxShadow: TossShadows.cardShadow,
      ),
      child: Column(
        children: [
          // Section Header
          Container(
            padding: EdgeInsets.all(TossSpacing.space4),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: TossColors.gray100, width: 1),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(TossSpacing.space2),
                  decoration: BoxDecoration(
                    color: iconColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                  ),
                  child: Icon(icon, color: iconColor, size: 20),
                ),
                SizedBox(width: TossSpacing.space3),
                Text(
                  title,
                  style: TossTextStyles.h3.copyWith(
                    color: TossColors.gray900,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          // Section Items
          Container(
            padding: EdgeInsets.all(TossSpacing.space4),
            child: Column(
              children: items,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLineItem(String label, String value, bool isBold, bool isSubtotal,
      {bool isHighlight = false}) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: TossSpacing.space2),
      decoration: isHighlight
          ? BoxDecoration(
              color: TossColors.primary.withOpacity(0.05),
              borderRadius: BorderRadius.circular(TossBorderRadius.sm),
            )
          : null,
      child: Padding(
        padding: isHighlight 
            ? EdgeInsets.symmetric(horizontal: TossSpacing.space2)
            : EdgeInsets.zero,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: isBold
                  ? TossTextStyles.body.copyWith(
                      color: isHighlight ? TossColors.primary : TossColors.gray900,
                      fontWeight: FontWeight.w600,
                    )
                  : TossTextStyles.bodySmall.copyWith(
                      color: TossColors.gray600,
                    ),
            ),
            if (value.isNotEmpty)
              Text(
                value,
                style: isSubtotal || isHighlight
                    ? TossTextStyles.bodyLarge.copyWith(
                        color: isHighlight ? TossColors.primary : TossColors.gray900,
                        fontWeight: FontWeight.w700,
                      )
                    : TossTextStyles.body.copyWith(
                        color: TossColors.gray700,
                        fontWeight: isBold ? FontWeight.w600 : FontWeight.w400,
                      ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildRatiosCard() {
    return Container(
      padding: EdgeInsets.all(TossSpacing.space4),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            TossColors.gray50,
            TossColors.background,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        border: Border.all(color: TossColors.gray200, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.analytics_outlined, 
                color: TossColors.primary, 
                size: 20,
              ),
              SizedBox(width: TossSpacing.space2),
              Text(
                'Key Ratios',
                style: TossTextStyles.h3.copyWith(
                  color: TossColors.gray900,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: TossSpacing.space4),
          
          Row(
            children: [
              Expanded(
                child: _buildRatioItem(
                  'Current Ratio',
                  '2.97',
                  TossColors.success,
                  Icons.trending_up_rounded,
                ),
              ),
              SizedBox(width: TossSpacing.space3),
              Expanded(
                child: _buildRatioItem(
                  'Debt to Equity',
                  '0.52',
                  TossColors.primary,
                  Icons.balance_rounded,
                ),
              ),
            ],
          ),
          SizedBox(height: TossSpacing.space3),
          Row(
            children: [
              Expanded(
                child: _buildRatioItem(
                  'ROE',
                  '18.5%',
                  TossColors.success,
                  Icons.show_chart_rounded,
                ),
              ),
              SizedBox(width: TossSpacing.space3),
              Expanded(
                child: _buildRatioItem(
                  'Quick Ratio',
                  '2.27',
                  TossColors.info,
                  Icons.speed_rounded,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRatioItem(String label, String value, Color color, IconData icon) {
    return Container(
      padding: EdgeInsets.all(TossSpacing.space3),
      decoration: BoxDecoration(
        color: TossColors.background,
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
        border: Border.all(color: TossColors.gray100, width: 1),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(TossSpacing.space2),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(TossBorderRadius.sm),
            ),
            child: Icon(icon, color: color, size: 16),
          ),
          SizedBox(width: TossSpacing.space3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TossTextStyles.caption.copyWith(
                    color: TossColors.gray500,
                  ),
                ),
                Text(
                  value,
                  style: TossTextStyles.bodyLarge.copyWith(
                    color: TossColors.gray900,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleRefresh(WidgetRef ref) async {
    try {
      // Invalidate providers to refresh data
      ref.invalidate(forceRefreshUserCompaniesProvider);
      ref.invalidate(forceRefreshCategoriesProvider);
      
      // Fetch fresh data
      await ref.read(forceRefreshUserCompaniesProvider.future);
      await ref.read(forceRefreshCategoriesProvider.future);
      
      // Invalidate regular providers to show new data
      ref.invalidate(userCompaniesProvider);
      ref.invalidate(categoriesWithFeaturesProvider);
      
      // Show success feedback
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Data refreshed', 
              style: TossTextStyles.body.copyWith(color: Colors.white),
            ),
            backgroundColor: TossColors.success,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(TossBorderRadius.sm),
            ),
          ),
        );
      }
    } catch (e) {
      // Show error feedback
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to refresh', 
              style: TossTextStyles.body.copyWith(color: Colors.white),
            ),
            backgroundColor: TossColors.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(TossBorderRadius.sm),
            ),
          ),
        );
      }
    }
  }

  Widget _buildIncomeStatementContent(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        padding: EdgeInsets.all(TossSpacing.space4),
        child: Column(
          children: [
            // Revenue Section
            _buildIncomeSection(
              title: 'Revenue',
              icon: Icons.trending_up_rounded,
              iconColor: TossColors.success,
              items: [
                _buildIncomeItem('Sales Revenue', '\$1,250,000', false, false),
                _buildIncomeItem('Service Revenue', '\$320,500', false, false),
                _buildIncomeItem('Other Revenue', '\$45,200', false, false),
                _buildIncomeItem('Total Revenue', '\$1,615,700', true, true,
                  isHighlight: true),
              ],
            ),
            
            SizedBox(height: TossSpacing.space4),
            
            // Cost of Goods Sold Section
            _buildIncomeSection(
              title: 'Cost of Goods Sold',
              icon: Icons.shopping_cart_outlined,
              iconColor: TossColors.warning,
              items: [
                _buildIncomeItem('Beginning Inventory', '\$185,000', false, false),
                _buildIncomeItem('Purchases', '\$650,000', false, false),
                _buildIncomeItem('Less: Ending Inventory', '(\$195,000)', false, false),
                _buildIncomeItem('Total COGS', '\$640,000', true, true),
              ],
            ),
            
            // Gross Profit
            Container(
              margin: EdgeInsets.symmetric(vertical: TossSpacing.space3),
              padding: EdgeInsets.all(TossSpacing.space4),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    TossColors.success.withOpacity(0.05),
                    TossColors.success.withOpacity(0.02),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                border: Border.all(
                  color: TossColors.success.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.assessment_outlined,
                        color: TossColors.success,
                        size: 20,
                      ),
                      SizedBox(width: TossSpacing.space2),
                      Text(
                        'Gross Profit',
                        style: TossTextStyles.bodyLarge.copyWith(
                          color: TossColors.gray900,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '\$975,700',
                        style: TossTextStyles.h3.copyWith(
                          color: TossColors.success,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        '60.4% margin',
                        style: TossTextStyles.caption.copyWith(
                          color: TossColors.success,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            SizedBox(height: TossSpacing.space4),
            
            // Operating Expenses Section
            _buildIncomeSection(
              title: 'Operating Expenses',
              icon: Icons.receipt_outlined,
              iconColor: TossColors.error,
              items: [
                _buildIncomeItem('Salaries & Wages', '\$385,000', false, false),
                _buildIncomeItem('Rent Expense', '\$120,000', false, false),
                _buildIncomeItem('Utilities', '\$24,500', false, false),
                _buildIncomeItem('Marketing', '\$65,000', false, false),
                _buildIncomeItem('Depreciation', '\$42,000', false, false),
                _buildIncomeItem('Other Operating', '\$38,500', false, false),
                _buildIncomeItem('Total Operating Expenses', '\$675,000', true, true),
              ],
            ),
            
            // Operating Income
            Container(
              margin: EdgeInsets.symmetric(vertical: TossSpacing.space3),
              padding: EdgeInsets.all(TossSpacing.space3),
              decoration: BoxDecoration(
                color: TossColors.gray50,
                borderRadius: BorderRadius.circular(TossBorderRadius.md),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Operating Income',
                    style: TossTextStyles.bodyLarge.copyWith(
                      color: TossColors.gray700,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    '\$300,700',
                    style: TossTextStyles.bodyLarge.copyWith(
                      color: TossColors.gray900,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            
            SizedBox(height: TossSpacing.space4),
            
            // Other Income/Expenses
            _buildIncomeSection(
              title: 'Other Income & Expenses',
              icon: Icons.swap_horiz_rounded,
              iconColor: TossColors.info,
              items: [
                _buildIncomeItem('Interest Income', '\$8,500', false, false),
                _buildIncomeItem('Interest Expense', '(\$22,000)', false, false),
                _buildIncomeItem('Other Income', '\$5,200', false, false),
                _buildIncomeItem('Net Other', '(\$8,300)', true, true),
              ],
            ),
            
            // Income Before Tax
            Container(
              margin: EdgeInsets.symmetric(vertical: TossSpacing.space3),
              padding: EdgeInsets.all(TossSpacing.space3),
              decoration: BoxDecoration(
                color: TossColors.primary.withOpacity(0.05),
                borderRadius: BorderRadius.circular(TossBorderRadius.md),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Income Before Tax',
                    style: TossTextStyles.bodyLarge.copyWith(
                      color: TossColors.gray700,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    '\$292,400',
                    style: TossTextStyles.bodyLarge.copyWith(
                      color: TossColors.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            
            // Tax
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: TossSpacing.space3,
                vertical: TossSpacing.space2,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Income Tax (21%)',
                    style: TossTextStyles.body.copyWith(
                      color: TossColors.gray600,
                    ),
                  ),
                  Text(
                    '(\$61,404)',
                    style: TossTextStyles.body.copyWith(
                      color: TossColors.error,
                    ),
                  ),
                ],
              ),
            ),
            
            // Net Income
            Container(
              margin: EdgeInsets.only(top: TossSpacing.space3),
              padding: EdgeInsets.all(TossSpacing.space4),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    TossColors.primary.withOpacity(0.1),
                    TossColors.primary.withOpacity(0.05),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                border: Border.all(
                  color: TossColors.primary.withOpacity(0.3),
                  width: 2,
                ),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.account_balance_wallet_outlined,
                            color: TossColors.primary,
                            size: 24,
                          ),
                          SizedBox(width: TossSpacing.space3),
                          Text(
                            'Net Income',
                            style: TossTextStyles.h3.copyWith(
                              color: TossColors.gray900,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '\$230,996',
                            style: TossTextStyles.amount.copyWith(
                              color: TossColors.primary,
                              fontSize: 28,
                            ),
                          ),
                          Text(
                            '14.3% net margin',
                            style: TossTextStyles.caption.copyWith(
                              color: TossColors.gray600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: TossSpacing.space3),
                  // EPS
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: TossSpacing.space3,
                      vertical: TossSpacing.space2,
                    ),
                    decoration: BoxDecoration(
                      color: TossColors.background,
                      borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Earnings Per Share',
                          style: TossTextStyles.caption.copyWith(
                            color: TossColors.gray600,
                          ),
                        ),
                        Text(
                          '\$2.31',
                          style: TossTextStyles.body.copyWith(
                            color: TossColors.gray900,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            SizedBox(height: TossSpacing.space8),
          ],
        ),
      ),
    );
  }

  Widget _buildIncomeSection({
    required String title,
    required IconData icon,
    required Color iconColor,
    required List<Widget> items,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: TossColors.background,
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        boxShadow: TossShadows.cardShadow,
      ),
      child: Column(
        children: [
          // Section Header
          Container(
            padding: EdgeInsets.all(TossSpacing.space4),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: TossColors.gray100, width: 1),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(TossSpacing.space2),
                  decoration: BoxDecoration(
                    color: iconColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                  ),
                  child: Icon(icon, color: iconColor, size: 20),
                ),
                SizedBox(width: TossSpacing.space3),
                Text(
                  title,
                  style: TossTextStyles.h3.copyWith(
                    color: TossColors.gray900,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          // Section Items
          Container(
            padding: EdgeInsets.all(TossSpacing.space4),
            child: Column(
              children: items,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIncomeItem(String label, String value, bool isBold, bool isSubtotal,
      {bool isHighlight = false}) {
    final isNegative = value.contains('(');
    final displayValue = value.replaceAll('(', '').replaceAll(')', '');
    
    return Container(
      padding: EdgeInsets.symmetric(vertical: TossSpacing.space2),
      decoration: isHighlight
          ? BoxDecoration(
              color: TossColors.primary.withOpacity(0.05),
              borderRadius: BorderRadius.circular(TossBorderRadius.sm),
            )
          : null,
      child: Padding(
        padding: isHighlight 
            ? EdgeInsets.symmetric(horizontal: TossSpacing.space2)
            : EdgeInsets.zero,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: isBold
                  ? TossTextStyles.body.copyWith(
                      color: isHighlight ? TossColors.primary : TossColors.gray900,
                      fontWeight: FontWeight.w600,
                    )
                  : TossTextStyles.bodySmall.copyWith(
                      color: TossColors.gray600,
                    ),
            ),
            if (value.isNotEmpty)
              Text(
                isNegative ? '($displayValue)' : value,
                style: isSubtotal || isHighlight
                    ? TossTextStyles.bodyLarge.copyWith(
                        color: isNegative 
                            ? TossColors.error 
                            : (isHighlight ? TossColors.primary : TossColors.gray900),
                        fontWeight: FontWeight.w700,
                      )
                    : TossTextStyles.body.copyWith(
                        color: isNegative 
                            ? TossColors.error 
                            : TossColors.gray700,
                        fontWeight: isBold ? FontWeight.w600 : FontWeight.w400,
                      ),
              ),
          ],
        ),
      ),
    );
  }
}

// Custom delegate for tab bar - Not needed anymore since we're not using SliverPersistentHeader
// Keeping for potential future use
class _TabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;

  _TabBarDelegate(this.tabBar);

  @override
  double get minExtent => tabBar.preferredSize.height;
  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: TossColors.background,
      child: tabBar,
    );
  }

  @override
  bool shouldRebuild(_TabBarDelegate oldDelegate) {
    return false;
  }
}