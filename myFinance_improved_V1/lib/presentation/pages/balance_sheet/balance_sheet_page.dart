import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:myfinance_improved/core/themes/toss_colors.dart';
import 'package:myfinance_improved/core/themes/toss_text_styles.dart';
import 'package:myfinance_improved/core/themes/toss_spacing.dart';
import 'package:myfinance_improved/core/themes/toss_shadows.dart';
import 'package:myfinance_improved/core/themes/toss_border_radius.dart';
import 'providers/balance_sheet_providers.dart';
import '../../providers/app_state_provider.dart';
import 'widgets/balance_sheet_display.dart';
import 'widgets/income_statement_display.dart';
import '../../widgets/common/toss_scaffold.dart';
import '../../widgets/common/toss_app_bar.dart';

class BalanceSheetPage extends ConsumerStatefulWidget {
  const BalanceSheetPage({super.key});

  @override
  ConsumerState<BalanceSheetPage> createState() => _BalanceSheetPageState();
}

class _BalanceSheetPageState extends ConsumerState<BalanceSheetPage> 
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String? selectedStoreId; // null means Headquarters (all stores combined)
  DateTime? fromDate;
  DateTime? toDate;
  bool showBalanceSheet = false;
  
  // Stores from Supabase
  List<Map<String, dynamic>> stores = [];
  bool isLoadingStores = true;
  
  // Balance Sheet Data
  Map<String, dynamic>? balanceSheetData;
  bool isLoadingBalanceSheet = false;
  String? balanceSheetError;
  
  // Income Statement Data  
  Map<String, dynamic>? incomeStatementData;
  bool isLoadingIncomeStatement = false;
  String? incomeStatementError;
  bool showIncomeStatement = false;
  
  // Currency Data
  String currencySymbol = '₩'; // Default fallback
  String currencyCode = 'KRW'; // Default fallback
  bool isLoadingCurrency = false;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        HapticFeedback.selectionClick();
      }
    });
    
    // Initialize date range to current month
    final now = DateTime.now();
    fromDate = DateTime(now.year, now.month, 1);
    toDate = DateTime(now.year, now.month + 1, 0); // Last day of current month
    
    // Load stores from Supabase
    _loadStores();
    
    // Set initial selected store from app state after first build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final appState = ref.read(appStateProvider);
      if (appState.storeChoosen.isNotEmpty) {
        setState(() {
          selectedStoreId = appState.storeChoosen;
        });
      } else {
        // If no store is chosen in app state, default to headquarters (null)
        setState(() {
          selectedStoreId = null;
        });
      }
      // Fetch currency data when page loads
      _fetchCurrencyData();
    });
  }
  
  // Load stores from Supabase
  Future<void> _loadStores() async {
    try {
      final appState = ref.read(appStateProvider);
      final companyId = appState.companyChoosen;
      
      if (companyId.isEmpty) {
        setState(() {
          stores = [];
          isLoadingStores = false;
        });
        return;
      }
      
      final response = await Supabase.instance.client
          .from('stores')
          .select('store_id, store_name, store_code')
          .eq('company_id', companyId)
          .order('store_name');
      
      setState(() {
        stores = List<Map<String, dynamic>>.from(response);
        isLoadingStores = false;
        
        // Auto-select first store if available
        if (stores.isNotEmpty && selectedStoreId == null) {
          selectedStoreId = stores.first['store_id'];
        }
      });
    } catch (e) {
      setState(() {
        stores = [];
        isLoadingStores = false;
      });
    }
  }
  
  // Fetch currency data from database
  Future<void> _fetchCurrencyData() async {
    if (isLoadingCurrency) return;
    
    setState(() {
      isLoadingCurrency = true;
    });
    
    try {
      final appState = ref.read(appStateProvider);
      final companyId = appState.companyChoosen;
      
      if (companyId.isEmpty) {
        // Use default currency if no company selected
        return;
      }
      
      // Get company's base_currency_id from companies table
      final companyResponse = await Supabase.instance.client
          .from('companies')
          .select('base_currency_id')
          .eq('company_id', companyId)
          .single();
      
      final baseCurrencyId = companyResponse['base_currency_id'];
      
      if (baseCurrencyId != null) {
        // Get currency details from currency_types table
        final currencyResponse = await Supabase.instance.client
            .from('currency_types')
            .select('currency_code, symbol')
            .eq('currency_id', baseCurrencyId)
            .single();
        
        setState(() {
          currencyCode = currencyResponse['currency_code'] ?? 'KRW';
          currencySymbol = currencyResponse['symbol'] ?? '₩';
        });
      }
    } catch (e) {
      // Keep default currency on error
    } finally {
      setState(() {
        isLoadingCurrency = false;
      });
    }
  }
  
  // Generate Balance Sheet
  Future<void> _generateBalanceSheet() async {
    // Validate inputs
    if (fromDate == null || toDate == null) {
      setState(() {
        balanceSheetError = 'Please select a date range';
      });
      return;
    }
    
    setState(() {
      isLoadingBalanceSheet = true;
      balanceSheetError = null;
      showBalanceSheet = false;
    });
    
    try {
      final appState = ref.read(appStateProvider);
      final companyId = appState.companyChoosen;
      
      if (companyId.isEmpty) {
        throw Exception('No company selected');
      }
      
      // Format dates as YYYY-MM-DD
      final startDate = '${fromDate!.year}-${fromDate!.month.toString().padLeft(2, '0')}-${fromDate!.day.toString().padLeft(2, '0')}';
      final endDate = '${toDate!.year}-${toDate!.month.toString().padLeft(2, '0')}-${toDate!.day.toString().padLeft(2, '0')}';
      
      // Call RPC function with exact parameter order from database
      final response = await Supabase.instance.client.rpc(
        'get_balance_sheet',
        params: {
          'p_company_id': companyId,
          'p_start_date': startDate,
          'p_end_date': endDate,
          'p_store_id': selectedStoreId, // null for headquarters
        },
      );
      
      if (response != null && response['success'] == true) {
        setState(() {
          balanceSheetData = response;
          showBalanceSheet = true;
          isLoadingBalanceSheet = false;
        });
      } else {
        throw Exception(response?['message'] ?? 'Failed to generate balance sheet');
      }
    } catch (e) {
      setState(() {
        balanceSheetError = e.toString();
        isLoadingBalanceSheet = false;
        showBalanceSheet = false;
      });
    }
  }

  // Generate Income Statement
  Future<void> _generateIncomeStatement() async {
    // Validate inputs
    if (fromDate == null || toDate == null) {
      setState(() {
        incomeStatementError = 'Please select a date range';
      });
      return;
    }
    
    setState(() {
      isLoadingIncomeStatement = true;
      incomeStatementError = null;
      showIncomeStatement = false;
    });
    
    try {
      final appState = ref.read(appStateProvider);
      final companyId = appState.companyChoosen;
      
      if (companyId.isEmpty) {
        throw Exception('No company selected');
      }
      
      // Format dates as YYYY-MM-DD
      final startDate = '${fromDate!.year}-${fromDate!.month.toString().padLeft(2, '0')}-${fromDate!.day.toString().padLeft(2, '0')}';
      final endDate = '${toDate!.year}-${toDate!.month.toString().padLeft(2, '0')}-${toDate!.day.toString().padLeft(2, '0')}';
      
      // Call RPC function for Income Statement v2
      dynamic response;
      try {
        response = await Supabase.instance.client.rpc(
          'get_income_statement_v2',
          params: {
            'p_company_id': companyId,
            'p_store_id': selectedStoreId, // null for headquarters
            'p_start_date': startDate,
            'p_end_date': endDate,
          },
        );
      } catch (rpcError) {
        // Fallback to original function name if v2 doesn't exist
        try {
          response = await Supabase.instance.client.rpc(
            'get_income_statement',
            params: {
              'p_company_id': companyId,
              'p_store_id': selectedStoreId, // null for headquarters
              'p_start_date': startDate,
              'p_end_date': endDate,
            },
          );
        } catch (fallbackError) {
          throw Exception('Income statement function not available on server');
        }
      }
      
      // Handle different response types more flexibly
      if (response != null) {
        if (response is List && response.isNotEmpty) {
          setState(() {
            incomeStatementData = {'data': response, 'parameters': {'start_date': startDate, 'end_date': endDate, 'store_id': selectedStoreId, 'company_id': companyId}};
            showIncomeStatement = true;
            isLoadingIncomeStatement = false;
          });
        } else if (response is List && response.isEmpty) {
          throw Exception('No income statement data found for the selected period and store');
        } else if (response is Map) {
          final map = response as Map<String, dynamic>;
          if (map.containsKey('error')) {
            throw Exception(map['error']);
          } else if (map.containsKey('message')) {
            throw Exception(map['message']);
          } else {
            // Try to extract data from map structure
            if (map.containsKey('data') && map['data'] is List) {
              final data = map['data'] as List;
              if (data.isNotEmpty) {
                setState(() {
                  incomeStatementData = {'data': data, 'parameters': {'start_date': startDate, 'end_date': endDate, 'store_id': selectedStoreId, 'company_id': companyId}};
                  showIncomeStatement = true;
                  isLoadingIncomeStatement = false;
                });
              } else {
                throw Exception('No income statement data found for the selected period and store');
              }
            } else {
              throw Exception('Unexpected response format from server');
            }
          }
        } else {
          throw Exception('Unexpected response format from server');
        }
      } else {
        throw Exception('No response from server');
      }
    } catch (e) {
      setState(() {
        incomeStatementError = e.toString();
        isLoadingIncomeStatement = false;
        showIncomeStatement = false;
      });
    }
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
    final selectedCompany = ref.watch(balanceSheetSelectedCompanyProvider);
    final selectedStore = ref.watch(balanceSheetSelectedStoreProvider);

    return TossScaffold(
      backgroundColor: TossColors.background,
      appBar: const TossAppBar(
        title: 'Financial Statements',
      ),
      body: SafeArea(
        child: userCompaniesAsync.when(
          data: (userData) => Column(
            children: [
              // Tab Bar Container
              Container(
                color: TossColors.background,
                child: Column(
                  children: [
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
                              borderRadius: BorderRadius.circular(TossBorderRadius.xxxl),
                            ),
                          ),
                          // Tab Bar
                          TabBar(
                            controller: _tabController,
                            indicator: BoxDecoration(
                              color: TossColors.background,
                              borderRadius: BorderRadius.circular(TossBorderRadius.xxl),
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
                            splashBorderRadius: BorderRadius.circular(TossBorderRadius.xxl),
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
                      child: (showBalanceSheet && balanceSheetData != null) || balanceSheetError != null
                        ? _buildNewBalanceSheetView(context)
                        : SingleChildScrollView(
                            padding: EdgeInsets.all(TossSpacing.space4),
                            child: Column(
                              children: [
                                // Store Selector
                                _buildStoreSelector(userData),
                                SizedBox(height: TossSpacing.space4),
                                // Date Selector
                                _buildDateSelector(),
                                SizedBox(height: TossSpacing.space6),
                                // Generate Button
                                _buildGenerateButton(),
                              ],
                            ),
                          ),
                    ),
                    
                    // Income Statement Tab
                    RefreshIndicator(
                      onRefresh: () => _handleRefresh(ref),
                      color: TossColors.primary,
                      child: (showIncomeStatement && incomeStatementData != null) || incomeStatementError != null
                        ? CustomScrollView(
                            slivers: [
                              _buildIncomeStatementContent(context),
                            ],
                          )
                        : SingleChildScrollView(
                            padding: EdgeInsets.all(TossSpacing.space4),
                            child: Column(
                              children: [
                                // Store Selector
                                _buildStoreSelector(userData),
                                SizedBox(height: TossSpacing.space4),
                                // Date Selector
                                _buildDateSelector(),
                                SizedBox(height: TossSpacing.space6),
                                // Generate Button
                                _buildIncomeStatementGenerateButton(),
                              ],
                            ),
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
                            style: TossTextStyles.small.copyWith(
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
                              style: TossTextStyles.small.copyWith(
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
                boxShadow: TossShadows.elevation2,
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
        boxShadow: TossShadows.card,
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
    // Show the actual Income Statement if data is available
    if (showIncomeStatement && incomeStatementData != null) {
      return SliverFillRemaining(
        child: IncomeStatementDisplay(
          incomeStatementData: incomeStatementData!,
          currencySymbol: currencySymbol,
          onEdit: () {
            setState(() {
              showIncomeStatement = false;
            });
          },
        ),
      );
    }
    
    // Show error state
    if (incomeStatementError != null) {
      return SliverFillRemaining(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(TossSpacing.space6),
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
                  'Error Loading Income Statement',
                  style: TossTextStyles.h3.copyWith(
                    color: TossColors.gray900,
                  ),
                ),
                SizedBox(height: TossSpacing.space2),
                Text(
                  incomeStatementError!,
                  style: TossTextStyles.body.copyWith(
                    color: TossColors.gray600,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: TossSpacing.space4),
                ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      incomeStatementError = null;
                    });
                  },
                  icon: Icon(Icons.refresh, size: 20),
                  label: Text('Try Again'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: TossColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(TossBorderRadius.md),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
    
    // Show empty state with form (default state)
    return SliverToBoxAdapter(
      child: Container(
        padding: EdgeInsets.all(TossSpacing.space4),
        child: Column(
          children: [
            // Empty State Illustration
            Container(
              padding: EdgeInsets.all(TossSpacing.space8),
              child: Column(
                children: [
                  Icon(
                    Icons.receipt_long_outlined,
                    size: 80,
                    color: TossColors.gray300,
                  ),
                  SizedBox(height: TossSpacing.space4),
                  Text(
                    'Income Statement',
                    style: TossTextStyles.h2.copyWith(
                      color: TossColors.gray700,
                    ),
                  ),
                  SizedBox(height: TossSpacing.space2),
                  Text(
                    'Select your parameters and generate an Income Statement to view your revenue, expenses, and profitability',
                    style: TossTextStyles.body.copyWith(
                      color: TossColors.gray500,
                    ),
                    textAlign: TextAlign.center,
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
        boxShadow: TossShadows.card,
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

  // Store Selector Widget - Matching Cash Ending Page Style
  Widget _buildStoreSelector(dynamic userData) {
    // If loading stores
    if (isLoadingStores) {
      return Container(
        padding: const EdgeInsets.all(TossSpacing.space4),
        decoration: BoxDecoration(
          color: TossColors.gray50,
          borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        ),
        child: Center(
          child: CircularProgressIndicator(
            color: TossColors.primary,
            strokeWidth: 2,
          ),
        ),
      );
    }
    
    // If no stores available
    if (stores.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(TossSpacing.space4),
        decoration: BoxDecoration(
          color: TossColors.gray50,
          borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.info_outline, color: TossColors.gray500, size: 20),
            const SizedBox(width: TossSpacing.space2),
            Text(
              'No stores available',
              style: TossTextStyles.body.copyWith(color: TossColors.gray500),
            ),
          ],
        ),
      );
    }
    
    // Get selected store name
    String storeName = 'Select Store';
    if (selectedStoreId == null && stores.isNotEmpty) {
      // null means Headquarters is selected
      storeName = 'Headquarters';
    } else if (selectedStoreId != null) {
      try {
        final store = stores.firstWhere(
          (s) => s['store_id'] == selectedStoreId,
        );
        storeName = store['store_name'] ?? 'Unknown Store';
      } catch (e) {
        storeName = 'Select Store';
        selectedStoreId = null;
      }
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Store',
          style: TossTextStyles.caption.copyWith(
            color: TossColors.gray500,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: TossSpacing.space2),
        InkWell(
          onTap: () => _showStoreSelector(),
          borderRadius: BorderRadius.circular(TossBorderRadius.xl),
          child: Container(
            padding: const EdgeInsets.all(TossSpacing.space4),
            decoration: BoxDecoration(
              color: TossColors.background,
              borderRadius: BorderRadius.circular(TossBorderRadius.xl),
              border: Border.all(
                color: selectedStoreId != null ? TossColors.primary.withOpacity(0.3) : TossColors.gray200,
                width: selectedStoreId != null ? 1.5 : 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: (selectedStoreId != null || (selectedStoreId == null && stores.isNotEmpty))
                      ? TossColors.primary.withOpacity(0.1) 
                      : TossColors.gray50,
                    borderRadius: BorderRadius.circular(TossBorderRadius.buttonLarge),
                  ),
                  child: Icon(
                    selectedStoreId == null && stores.isNotEmpty
                      ? Icons.business_outlined
                      : Icons.store_outlined,
                    size: 20,
                    color: (selectedStoreId != null || (selectedStoreId == null && stores.isNotEmpty))
                      ? TossColors.primary 
                      : TossColors.gray600,
                  ),
                ),
                const SizedBox(width: TossSpacing.space3),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Store',
                        style: TossTextStyles.caption.copyWith(
                          color: TossColors.gray500,
                          fontSize: 11,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        storeName,
                        style: TossTextStyles.body.copyWith(
                          color: selectedStoreId != null 
                            ? TossColors.gray900 
                            : TossColors.gray500,
                          fontWeight: selectedStoreId != null 
                            ? FontWeight.w600 
                            : FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: selectedStoreId != null 
                    ? TossColors.primary 
                    : TossColors.gray400,
                  size: 24,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
  
  // Show Store Selector Modal - Matching Cash Ending Page Style
  void _showStoreSelector() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              margin: const EdgeInsets.only(top: TossSpacing.space3),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: TossColors.gray300,
                borderRadius: BorderRadius.circular(TossBorderRadius.full),
              ),
            ),
            // Title
            Padding(
              padding: const EdgeInsets.all(TossSpacing.space5),
              child: Row(
                children: [
                  Text(
                    'Select Store',
                    style: TossTextStyles.h3.copyWith(
                      color: TossColors.gray900,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            // Store list with Headquarters at the top
            Container(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.5,
              ),
              child: ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                itemCount: stores.length + 1, // +1 for Headquarters
                itemBuilder: (context, index) {
                  // First item is Headquarters
                  if (index == 0) {
                    final isSelected = selectedStoreId == null;
                    
                    return InkWell(
                      onTap: () async {
                        setState(() {
                          selectedStoreId = null; // null for headquarters
                          showBalanceSheet = false; // Reset view when store changes
                        });
                        // Update app state - empty string for headquarters
                        await ref.read(appStateProvider.notifier).setStoreChoosen('');
                        Navigator.pop(context);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: TossSpacing.space5,
                          vertical: TossSpacing.space4,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected ? TossColors.primary.withOpacity(0.05) : Colors.transparent,
                          border: Border(
                            bottom: BorderSide(
                              color: TossColors.gray100,
                              width: 1,
                            ),
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: isSelected 
                                  ? TossColors.primary.withOpacity(0.1) 
                                  : TossColors.gray50,
                                borderRadius: BorderRadius.circular(TossBorderRadius.buttonLarge),
                              ),
                              child: Icon(
                                Icons.business_outlined,
                                size: 20,
                                color: isSelected ? TossColors.primary : TossColors.gray600,
                              ),
                            ),
                            const SizedBox(width: TossSpacing.space3),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Headquarters',
                                    style: TossTextStyles.body.copyWith(
                                      color: TossColors.gray900,
                                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    'All stores combined',
                                    style: TossTextStyles.caption.copyWith(
                                      color: TossColors.gray500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (isSelected)
                              Icon(
                                Icons.check_circle,
                                color: TossColors.primary,
                                size: 24,
                              ),
                          ],
                        ),
                      ),
                    );
                  }
                  
                  // Regular store items
                  final storeIndex = index - 1; // Adjust index for stores array
                  final store = stores[storeIndex];
                  final isSelected = selectedStoreId == store['store_id'];
                  
                  return InkWell(
                    onTap: () async {
                      setState(() {
                        selectedStoreId = store['store_id'];
                        showBalanceSheet = false; // Reset view when store changes
                      });
                      // Update app state with selected store
                      await ref.read(appStateProvider.notifier).setStoreChoosen(store['store_id'] ?? '');
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: TossSpacing.space5,
                        vertical: TossSpacing.space4,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected ? TossColors.primary.withOpacity(0.05) : Colors.transparent,
                        border: Border(
                          bottom: BorderSide(
                            color: TossColors.gray100,
                            width: index == stores.length ? 0 : 1, // Last item has no border
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: isSelected 
                                ? TossColors.primary.withOpacity(0.1) 
                                : TossColors.gray50,
                              borderRadius: BorderRadius.circular(TossBorderRadius.buttonLarge),
                            ),
                            child: Icon(
                              Icons.store_outlined,
                              size: 20,
                              color: isSelected ? TossColors.primary : TossColors.gray600,
                            ),
                          ),
                          const SizedBox(width: TossSpacing.space3),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  store['store_name'] ?? '',
                                  style: TossTextStyles.body.copyWith(
                                    color: TossColors.gray900,
                                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                                  ),
                                ),
                                if (store['store_code'] != null) ...[
                                  const SizedBox(height: 2),
                                  Text(
                                    'Code: ${store['store_code']}',
                                    style: TossTextStyles.caption.copyWith(
                                      color: TossColors.gray500,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                          if (isSelected)
                            Icon(
                              Icons.check_circle,
                              color: TossColors.primary,
                              size: 24,
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            // Bottom padding for safe area
            SizedBox(height: MediaQuery.of(context).padding.bottom + TossSpacing.space4),
          ],
        ),
      ),
    );
  }

  // Date Range Selector Widget - Single Calendar Style
  Widget _buildDateSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Period',
          style: TossTextStyles.caption.copyWith(
            color: TossColors.gray500,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: TossSpacing.space2),
        // Single Date Range Selector
        InkWell(
          onTap: () => _showDateRangePicker('range'),
          borderRadius: BorderRadius.circular(TossBorderRadius.xl),
          child: Container(
            padding: const EdgeInsets.all(TossSpacing.space4),
            decoration: BoxDecoration(
              color: TossColors.background,
              borderRadius: BorderRadius.circular(TossBorderRadius.xl),
              border: Border.all(
                color: (fromDate != null && toDate != null) 
                  ? TossColors.primary.withOpacity(0.3) 
                  : TossColors.gray200,
                width: (fromDate != null && toDate != null) ? 1.5 : 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: (fromDate != null && toDate != null)
                      ? TossColors.primary.withOpacity(0.1) 
                      : TossColors.gray50,
                    borderRadius: BorderRadius.circular(TossBorderRadius.buttonLarge),
                  ),
                  child: Icon(
                    Icons.date_range_outlined,
                    size: 20,
                    color: (fromDate != null && toDate != null)
                      ? TossColors.primary 
                      : TossColors.gray600,
                  ),
                ),
                const SizedBox(width: TossSpacing.space3),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Date Range',
                        style: TossTextStyles.caption.copyWith(
                          color: TossColors.gray500,
                          fontSize: 11,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        (fromDate != null && toDate != null)
                          ? '${fromDate!.year}.${fromDate!.month.toString().padLeft(2, '0')}.${fromDate!.day.toString().padLeft(2, '0')} ~ ${toDate!.year}.${toDate!.month.toString().padLeft(2, '0')}.${toDate!.day.toString().padLeft(2, '0')}'
                          : 'Select date range',
                        style: TossTextStyles.body.copyWith(
                          color: (fromDate != null && toDate != null)
                            ? TossColors.gray900 
                            : TossColors.gray500,
                          fontWeight: (fromDate != null && toDate != null)
                            ? FontWeight.w600 
                            : FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: (fromDate != null && toDate != null)
                    ? TossColors.primary 
                    : TossColors.gray400,
                  size: 24,
                ),
              ],
            ),
          ),
        ),
        // Quick selection buttons
        const SizedBox(height: TossSpacing.space3),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildQuickDateButton('This Month', () {
                final now = DateTime.now();
                setState(() {
                  fromDate = DateTime(now.year, now.month, 1);
                  toDate = DateTime(now.year, now.month + 1, 0);
                  showBalanceSheet = false;
                });
              }),
              const SizedBox(width: TossSpacing.space2),
              _buildQuickDateButton('Last Month', () {
                final now = DateTime.now();
                setState(() {
                  fromDate = DateTime(now.year, now.month - 1, 1);
                  toDate = DateTime(now.year, now.month, 0);
                  showBalanceSheet = false;
                });
              }),
              const SizedBox(width: TossSpacing.space2),
              _buildQuickDateButton('This Quarter', () {
                final now = DateTime.now();
                final quarter = ((now.month - 1) ~/ 3);
                setState(() {
                  fromDate = DateTime(now.year, quarter * 3 + 1, 1);
                  toDate = DateTime(now.year, quarter * 3 + 4, 0);
                  showBalanceSheet = false;
                });
              }),
              const SizedBox(width: TossSpacing.space2),
              _buildQuickDateButton('This Year', () {
                final now = DateTime.now();
                setState(() {
                  fromDate = DateTime(now.year, 1, 1);
                  toDate = DateTime(now.year, 12, 31);
                  showBalanceSheet = false;
                });
              }),
            ],
          ),
        ),
      ],
    );
  }
  
  // Quick date selection button
  Widget _buildQuickDateButton(String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(TossBorderRadius.xxl),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: TossSpacing.space3,
          vertical: TossSpacing.space2,
        ),
        decoration: BoxDecoration(
          color: TossColors.gray50,
          borderRadius: BorderRadius.circular(TossBorderRadius.xxl),
          border: Border.all(
            color: TossColors.gray200,
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: TossTextStyles.caption.copyWith(
            color: TossColors.gray700,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
  
  // Show date range picker with Toss style
  void _showDateRangePicker(String type) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _TossDateRangePicker(
        initialFromDate: fromDate,
        initialToDate: toDate,
        onDatesSelected: (from, to) {
          setState(() {
            fromDate = from;
            toDate = to;
            showBalanceSheet = false;
          });
          Navigator.pop(context);
        },
      ),
    );
  }

  // Helper method to get store name
  String _getStoreName() {
    if (selectedStoreId == null || stores.isEmpty) {
      return 'Unknown Store';
    }
    
    try {
      final store = stores.firstWhere((s) => s['store_id'] == selectedStoreId);
      return store['store_name'] ?? 'Unknown Store';
    } catch (e) {
      return 'Unknown Store';
    }
  }
  
  // Balance Sheet Generate Button
  Widget _buildGenerateButton() {
    return Container(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: !isLoadingBalanceSheet
          ? () {
              _generateBalanceSheet();
              HapticFeedback.mediumImpact();
            }
          : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: TossColors.primary,
          disabledBackgroundColor: TossColors.gray200,
          foregroundColor: Colors.white,
          disabledForegroundColor: TossColors.gray400,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(TossBorderRadius.lg),
          ),
        ),
        child: isLoadingBalanceSheet
          ? SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2.5,
              ),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.assessment_outlined, size: 24),
                SizedBox(width: TossSpacing.space2),
                Text(
                  'Generate Balance Sheet',
                  style: TossTextStyles.labelLarge.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
      ),
    );
  }

  // Income Statement Generate Button
  Widget _buildIncomeStatementGenerateButton() {
    return Container(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: !isLoadingIncomeStatement
          ? () {
              _generateIncomeStatement();
              HapticFeedback.mediumImpact();
            }
          : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: TossColors.primary,
          disabledBackgroundColor: TossColors.gray200,
          foregroundColor: Colors.white,
          disabledForegroundColor: TossColors.gray400,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(TossBorderRadius.lg),
          ),
        ),
        child: isLoadingIncomeStatement
          ? SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2.5,
              ),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.receipt_long_outlined, size: 24),
                SizedBox(width: TossSpacing.space2),
                Text(
                  'Generate Income Statement',
                  style: TossTextStyles.labelLarge.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
      ),
    );
  }

  // New Balance Sheet View
  Widget _buildNewBalanceSheetView(BuildContext context) {
    // Error state
    if (balanceSheetError != null) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(TossSpacing.space6),
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
                'Error Loading Balance Sheet',
                style: TossTextStyles.h3.copyWith(
                  color: TossColors.gray900,
                ),
              ),
              SizedBox(height: TossSpacing.space2),
              Text(
                balanceSheetError!,
                style: TossTextStyles.body.copyWith(
                  color: TossColors.gray600,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: TossSpacing.space6),
              ElevatedButton(
                onPressed: _generateBalanceSheet,
                style: ElevatedButton.styleFrom(
                  backgroundColor: TossColors.primary,
                  padding: EdgeInsets.symmetric(
                    horizontal: TossSpacing.space6,
                    vertical: TossSpacing.space3,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(TossBorderRadius.md),
                  ),
                ),
                child: Text('Try Again'),
              ),
            ],
          ),
        ),
      );
    }
    
    // Loading state
    if (balanceSheetData == null) {
      return Center(
        child: CircularProgressIndicator(
          color: TossColors.primary,
        ),
      );
    }
    
    // Success state - Display balance sheet data
    return BalanceSheetDisplay(
      balanceSheetData: balanceSheetData!,
      currencySymbol: currencySymbol,
      onEdit: () {
        setState(() {
          showBalanceSheet = false;
        });
      },
    );
  }
  
  Widget _buildOldBalanceSheetView(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Column(
            children: [
              // Header with Store and Date info
              Container(
                padding: EdgeInsets.all(TossSpacing.space4),
                color: TossColors.gray50,
                child: Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Icon(Icons.store_outlined, 
                            color: TossColors.primary,
                            size: 20,
                          ),
                          SizedBox(width: TossSpacing.space2),
                          Text(
                            'Store: ${_getStoreName()}',
                            style: TossTextStyles.body.copyWith(
                              color: TossColors.gray700,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 20,
                      color: TossColors.gray300,
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Icon(Icons.calendar_today_outlined,
                            color: TossColors.primary,
                            size: 20,
                          ),
                          SizedBox(width: TossSpacing.space2),
                          Text(
                            fromDate != null && toDate != null
                              ? '${fromDate!.year}.${fromDate!.month.toString().padLeft(2, '0')}.${fromDate!.day.toString().padLeft(2, '0')} ~ ${toDate!.year}.${toDate!.month.toString().padLeft(2, '0')}.${toDate!.day.toString().padLeft(2, '0')}'
                              : 'Select Date Range',
                            style: TossTextStyles.bodySmall.copyWith(
                              color: TossColors.gray700,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: TossSpacing.space3),
                    IconButton(
                      icon: Icon(Icons.edit_outlined,
                        color: TossColors.gray600,
                        size: 20,
                      ),
                      onPressed: () {
                        setState(() {
                          showBalanceSheet = false;
                        });
                      },
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints(),
                    ),
                  ],
                ),
              ),
              
              // Balance Sheet Content
              Padding(
                padding: EdgeInsets.all(TossSpacing.space4),
                child: Column(
                  children: [
                    // Summary Card
                    _buildSummaryCard(),
                    SizedBox(height: TossSpacing.space4),
                    
                    // Assets Section
                    _buildAssetsSection(),
                    SizedBox(height: TossSpacing.space4),
                    
                    // Liabilities Section
                    _buildLiabilitiesSection(),
                    SizedBox(height: TossSpacing.space4),
                    
                    // Equity Section
                    _buildEquitySection(),
                    SizedBox(height: TossSpacing.space6),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Summary Card
  Widget _buildSummaryCard() {
    return Container(
      padding: EdgeInsets.all(TossSpacing.space5),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            TossColors.primary.withOpacity(0.08),
            TossColors.primary.withOpacity(0.03),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(TossBorderRadius.xl),
        border: Border.all(
          color: TossColors.primary.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Text(
            'Total Balance',
            style: TossTextStyles.caption.copyWith(
              color: TossColors.gray600,
              letterSpacing: 0.5,
            ),
          ),
          SizedBox(height: TossSpacing.space2),
          Text(
            '\$2,458,320',
            style: TossTextStyles.amount.copyWith(
              color: TossColors.gray900,
              fontSize: 36,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: TossSpacing.space4),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(TossSpacing.space3),
                  decoration: BoxDecoration(
                    color: TossColors.background,
                    borderRadius: BorderRadius.circular(TossBorderRadius.md),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Assets',
                        style: TossTextStyles.caption.copyWith(
                          color: TossColors.gray500,
                        ),
                      ),
                      SizedBox(height: TossSpacing.space1),
                      Text(
                        '\$2,458,320',
                        style: TossTextStyles.bodyLarge.copyWith(
                          color: TossColors.success,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: TossSpacing.space3),
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(TossSpacing.space3),
                  decoration: BoxDecoration(
                    color: TossColors.background,
                    borderRadius: BorderRadius.circular(TossBorderRadius.md),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Liabilities',
                        style: TossTextStyles.caption.copyWith(
                          color: TossColors.gray500,
                        ),
                      ),
                      SizedBox(height: TossSpacing.space1),
                      Text(
                        '\$842,100',
                        style: TossTextStyles.bodyLarge.copyWith(
                          color: TossColors.warning,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: TossSpacing.space3),
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(TossSpacing.space3),
                  decoration: BoxDecoration(
                    color: TossColors.background,
                    borderRadius: BorderRadius.circular(TossBorderRadius.md),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Equity',
                        style: TossTextStyles.caption.copyWith(
                          color: TossColors.gray500,
                        ),
                      ),
                      SizedBox(height: TossSpacing.space1),
                      Text(
                        '\$1,616,220',
                        style: TossTextStyles.bodyLarge.copyWith(
                          color: TossColors.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Assets Section
  Widget _buildAssetsSection() {
    return Container(
      decoration: BoxDecoration(
        color: TossColors.background,
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        boxShadow: TossShadows.card,
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(TossSpacing.space4),
            decoration: BoxDecoration(
              color: TossColors.success.withOpacity(0.05),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(TossBorderRadius.lg),
                topRight: Radius.circular(TossBorderRadius.lg),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(TossSpacing.space2),
                  decoration: BoxDecoration(
                    color: TossColors.success.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                  ),
                  child: Icon(Icons.account_balance_wallet_outlined,
                    color: TossColors.success,
                    size: 20,
                  ),
                ),
                SizedBox(width: TossSpacing.space3),
                Text(
                  'Assets',
                  style: TossTextStyles.h3.copyWith(
                    color: TossColors.gray900,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Spacer(),
                Text(
                  '\$2,458,320',
                  style: TossTextStyles.bodyLarge.copyWith(
                    color: TossColors.success,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(TossSpacing.space4),
            child: Column(
              children: [
                _buildBalanceItem('Current Assets', '', true, false),
                _buildBalanceItem('  Cash & Cash Equivalents', '\$523,450', false, false),
                _buildBalanceItem('  Accounts Receivable', '\$342,100', false, false),
                _buildBalanceItem('  Inventory', '\$285,600', false, false),
                _buildBalanceItem('  Prepaid Expenses', '\$65,200', false, false),
                Divider(color: TossColors.gray100),
                _buildBalanceItem('  Total Current Assets', '\$1,216,350', true, true),
                SizedBox(height: TossSpacing.space3),
                _buildBalanceItem('Non-Current Assets', '', true, false),
                _buildBalanceItem('  Property & Equipment', '\$856,300', false, false),
                _buildBalanceItem('  Intangible Assets', '\$125,000', false, false),
                _buildBalanceItem('  Long-term Investments', '\$260,670', false, false),
                Divider(color: TossColors.gray100),
                _buildBalanceItem('  Total Non-Current Assets', '\$1,241,970', true, true),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Liabilities Section
  Widget _buildLiabilitiesSection() {
    return Container(
      decoration: BoxDecoration(
        color: TossColors.background,
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        boxShadow: TossShadows.card,
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(TossSpacing.space4),
            decoration: BoxDecoration(
              color: TossColors.warning.withOpacity(0.05),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(TossBorderRadius.lg),
                topRight: Radius.circular(TossBorderRadius.lg),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(TossSpacing.space2),
                  decoration: BoxDecoration(
                    color: TossColors.warning.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                  ),
                  child: Icon(Icons.receipt_long_outlined,
                    color: TossColors.warning,
                    size: 20,
                  ),
                ),
                SizedBox(width: TossSpacing.space3),
                Text(
                  'Liabilities',
                  style: TossTextStyles.h3.copyWith(
                    color: TossColors.gray900,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Spacer(),
                Text(
                  '\$842,100',
                  style: TossTextStyles.bodyLarge.copyWith(
                    color: TossColors.warning,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(TossSpacing.space4),
            child: Column(
              children: [
                _buildBalanceItem('Current Liabilities', '', true, false),
                _buildBalanceItem('  Accounts Payable', '\$186,200', false, false),
                _buildBalanceItem('  Short-term Debt', '\$125,000', false, false),
                _buildBalanceItem('  Accrued Expenses', '\$98,500', false, false),
                Divider(color: TossColors.gray100),
                _buildBalanceItem('  Total Current Liabilities', '\$409,700', true, true),
                SizedBox(height: TossSpacing.space3),
                _buildBalanceItem('Non-Current Liabilities', '', true, false),
                _buildBalanceItem('  Long-term Debt', '\$350,000', false, false),
                _buildBalanceItem('  Deferred Tax Liabilities', '\$82,400', false, false),
                Divider(color: TossColors.gray100),
                _buildBalanceItem('  Total Non-Current Liabilities', '\$432,400', true, true),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Equity Section
  Widget _buildEquitySection() {
    return Container(
      decoration: BoxDecoration(
        color: TossColors.background,
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        boxShadow: TossShadows.card,
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(TossSpacing.space4),
            decoration: BoxDecoration(
              color: TossColors.primary.withOpacity(0.05),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(TossBorderRadius.lg),
                topRight: Radius.circular(TossBorderRadius.lg),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(TossSpacing.space2),
                  decoration: BoxDecoration(
                    color: TossColors.primary.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                  ),
                  child: Icon(Icons.pie_chart_outline,
                    color: TossColors.primary,
                    size: 20,
                  ),
                ),
                SizedBox(width: TossSpacing.space3),
                Text(
                  'Shareholder\'s Equity',
                  style: TossTextStyles.h3.copyWith(
                    color: TossColors.gray900,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Spacer(),
                Text(
                  '\$1,616,220',
                  style: TossTextStyles.bodyLarge.copyWith(
                    color: TossColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(TossSpacing.space4),
            child: Column(
              children: [
                _buildBalanceItem('Common Stock', '\$500,000', false, false),
                _buildBalanceItem('Retained Earnings', '\$1,016,220', false, false),
                _buildBalanceItem('Additional Paid-in Capital', '\$100,000', false, false),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Balance Item Widget
  Widget _buildBalanceItem(String label, String value, bool isBold, bool isSubtotal) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: TossSpacing.space2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: isBold
              ? TossTextStyles.body.copyWith(
                  color: TossColors.gray900,
                  fontWeight: FontWeight.w600,
                )
              : TossTextStyles.bodySmall.copyWith(
                  color: TossColors.gray600,
                ),
          ),
          if (value.isNotEmpty)
            Text(
              value,
              style: isSubtotal
                ? TossTextStyles.bodyLarge.copyWith(
                    color: TossColors.gray900,
                    fontWeight: FontWeight.w700,
                  )
                : TossTextStyles.body.copyWith(
                    color: TossColors.gray700,
                    fontWeight: isBold ? FontWeight.w600 : FontWeight.w400,
                  ),
            ),
        ],
      ),
    );
  }
}

// Custom Toss-style Date Range Picker Widget
class _TossDateRangePicker extends StatefulWidget {
  final DateTime? initialFromDate;
  final DateTime? initialToDate;
  final Function(DateTime, DateTime) onDatesSelected;

  const _TossDateRangePicker({
    Key? key,
    this.initialFromDate,
    this.initialToDate,
    required this.onDatesSelected,
  }) : super(key: key);

  @override
  State<_TossDateRangePicker> createState() => _TossDateRangePickerState();
}

class _TossDateRangePickerState extends State<_TossDateRangePicker> {
  late DateTime? _fromDate;
  late DateTime? _toDate;
  late DateTime _currentMonth;

  @override
  void initState() {
    super.initState();
    _fromDate = widget.initialFromDate;
    _toDate = widget.initialToDate;
    _currentMonth = DateTime.now();
  }

  List<DateTime> _getDaysInMonth(DateTime month) {
    final firstDay = DateTime(month.year, month.month, 1);
    final lastDay = DateTime(month.year, month.month + 1, 0);
    final days = <DateTime>[];
    
    // Add empty days for alignment
    for (int i = 0; i < firstDay.weekday % 7; i++) {
      days.add(DateTime(0));
    }
    
    // Add actual days
    for (int i = 1; i <= lastDay.day; i++) {
      days.add(DateTime(month.year, month.month, i));
    }
    
    return days;
  }

  String _getMonthName(int month) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return months[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    final days = _getDaysInMonth(_currentMonth);
    
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: TossSpacing.space3),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: TossColors.gray300,
              borderRadius: BorderRadius.circular(TossBorderRadius.full),
            ),
          ),
          // Header
          Padding(
            padding: const EdgeInsets.all(TossSpacing.space5),
            child: Column(
              children: [
                Text(
                  'Select date range',
                  style: TossTextStyles.h3.copyWith(
                    color: TossColors.gray900,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: TossSpacing.space3),
                // Date range display - Minimalist Toss Style
                Container(
                  padding: const EdgeInsets.all(TossSpacing.space4),
                  decoration: BoxDecoration(
                    color: (_fromDate != null && _toDate != null)
                      ? TossColors.primary.withOpacity(0.05)
                      : TossColors.gray50,
                    borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                  ),
                  child: Row(
                    children: [
                      // Start date
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 6,
                                  height: 6,
                                  decoration: BoxDecoration(
                                    color: _fromDate != null
                                      ? TossColors.primary
                                      : TossColors.gray400,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'Start',
                                  style: TossTextStyles.caption.copyWith(
                                    color: TossColors.gray500,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _fromDate != null
                                ? '${_fromDate!.year}.${_fromDate!.month.toString().padLeft(2, '0')}.${_fromDate!.day.toString().padLeft(2, '0')}'
                                : 'Not selected',
                              style: TossTextStyles.bodyLarge.copyWith(
                                color: _fromDate != null 
                                  ? TossColors.gray900 
                                  : TossColors.gray400,
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Arrow
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space3),
                        child: Icon(
                          Icons.arrow_forward_rounded,
                          color: TossColors.gray300,
                          size: 18,
                        ),
                      ),
                      // End date
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 6,
                                  height: 6,
                                  decoration: BoxDecoration(
                                    color: _toDate != null
                                      ? TossColors.primary
                                      : TossColors.gray400,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'End',
                                  style: TossTextStyles.caption.copyWith(
                                    color: TossColors.gray500,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _toDate != null
                                ? '${_toDate!.year}.${_toDate!.month.toString().padLeft(2, '0')}.${_toDate!.day.toString().padLeft(2, '0')}'
                                : 'Not selected',
                              style: TossTextStyles.bodyLarge.copyWith(
                                color: _toDate != null 
                                  ? TossColors.gray900 
                                  : TossColors.gray400,
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Month selector
          Container(
            padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      _currentMonth = DateTime(
                        _currentMonth.year,
                        _currentMonth.month - 1,
                      );
                    });
                  },
                  icon: Icon(
                    Icons.chevron_left,
                    color: TossColors.gray600,
                  ),
                ),
                InkWell(
                  onTap: () {
                    // Could show month/year picker here
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: TossSpacing.space3,
                      vertical: TossSpacing.space2,
                    ),
                    decoration: BoxDecoration(
                      color: TossColors.gray50,
                      borderRadius: BorderRadius.circular(TossBorderRadius.md),
                    ),
                    child: Row(
                      children: [
                        Text(
                          '${_getMonthName(_currentMonth.month)} ${_currentMonth.year}',
                          style: TossTextStyles.body.copyWith(
                            color: TossColors.gray900,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: TossSpacing.space1),
                        Icon(
                          Icons.arrow_drop_down,
                          color: TossColors.gray600,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      _currentMonth = DateTime(
                        _currentMonth.year,
                        _currentMonth.month + 1,
                      );
                    });
                  },
                  icon: Icon(
                    Icons.chevron_right,
                    color: TossColors.gray600,
                  ),
                ),
              ],
            ),
          ),
          // Helper text - Toss minimalist style
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space5),
            child: Text(
              _fromDate == null 
                  ? 'Tap any date to select a new range'
                  : _toDate == null 
                      ? 'Tap any date to select a new range'
                      : 'Tap any date to select a new range',
              style: TossTextStyles.caption.copyWith(
                color: TossColors.gray500,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(height: TossSpacing.space3),
          // Calendar grid
          Container(
            padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space5),
            child: Column(
              children: [
                // Weekday headers - Toss style
                Container(
                  padding: const EdgeInsets.symmetric(vertical: TossSpacing.space2),
                  child: Row(
                    children: ['S', 'M', 'T', 'W', 'T', 'F', 'S']
                        .map((day) => Expanded(
                              child: Center(
                                child: Text(
                                  day,
                                  style: TossTextStyles.bodySmall.copyWith(
                                    color: TossColors.gray400,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ))
                        .toList(),
                  ),
                ),
                const SizedBox(height: TossSpacing.space1),
                // Days grid with better spacing
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 7,
                    childAspectRatio: 1,
                    mainAxisSpacing: 2,
                    crossAxisSpacing: 2,
                  ),
                  itemCount: days.length,
                  itemBuilder: (context, index) {
                    final day = days[index];
                    if (day.year == 0) {
                      return const SizedBox();
                    }
                    
                    final isFromDate = _fromDate != null && 
                        day.year == _fromDate!.year &&
                        day.month == _fromDate!.month &&
                        day.day == _fromDate!.day;
                    final isToDate = _toDate != null &&
                        day.year == _toDate!.year &&
                        day.month == _toDate!.month &&
                        day.day == _toDate!.day;
                    final isInRange = _fromDate != null && _toDate != null &&
                        day.isAfter(_fromDate!.subtract(const Duration(days: 1))) &&
                        day.isBefore(_toDate!.add(const Duration(days: 1)));
                    final isToday = day.year == DateTime.now().year &&
                        day.month == DateTime.now().month &&
                        day.day == DateTime.now().day;
                    
                    // Clean Toss-style date visualization
                    return InkWell(
                      onTap: () {
                        setState(() {
                          if (_fromDate == null || (_fromDate != null && _toDate != null)) {
                            // Start new selection
                            _fromDate = day;
                            _toDate = null;
                          } else if (_toDate == null) {
                            // Complete the range
                            if (day.isBefore(_fromDate!)) {
                              _toDate = _fromDate;
                              _fromDate = day;
                            } else {
                              _toDate = day;
                            }
                          }
                        });
                        HapticFeedback.selectionClick();
                      },
                      borderRadius: BorderRadius.circular(TossBorderRadius.md),
                      child: Container(
                        margin: const EdgeInsets.all(3),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // Range background connector - Toss style
                            if (isInRange && !isFromDate && !isToDate)
                              Positioned.fill(
                                child: Container(
                                  margin: const EdgeInsets.symmetric(vertical: 6),
                                  color: TossColors.primary.withOpacity(0.08),
                                ),
                              ),
                            // Special background for start/end with proper connection
                            if (isFromDate || isToDate)
                              Positioned.fill(
                                child: Container(
                                  margin: const EdgeInsets.symmetric(vertical: 6),
                                  decoration: BoxDecoration(
                                    color: TossColors.primary.withOpacity(0.08),
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(isFromDate ? 8 : 0),
                                      bottomLeft: Radius.circular(isFromDate ? 8 : 0),
                                      topRight: Radius.circular(isToDate ? 8 : 0),
                                      bottomRight: Radius.circular(isToDate ? 8 : 0),
                                    ),
                                  ),
                                ),
                              ),
                            // Date circle - Toss minimalist style
                            Container(
                              width: 38,
                              height: 38,
                              decoration: BoxDecoration(
                                color: (isFromDate || isToDate)
                                    ? TossColors.primary
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(TossBorderRadius.md),
                                border: isToday && !(isFromDate || isToDate)
                                    ? Border.all(
                                        color: TossColors.primary,
                                        width: 1,
                                      )
                                    : null,
                              ),
                              child: Center(
                                child: Text(
                                  '${day.day}',
                                  style: TossTextStyles.body.copyWith(
                                    color: (isFromDate || isToDate)
                                        ? Colors.white
                                        : isInRange
                                            ? TossColors.primary
                                            : isToday
                                                ? TossColors.primary
                                                : TossColors.gray700,
                                    fontWeight: (isFromDate || isToDate)
                                        ? FontWeight.w700
                                        : isToday
                                            ? FontWeight.w600
                                            : FontWeight.w400,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          // Action buttons
          Container(
            padding: const EdgeInsets.all(TossSpacing.space5),
            child: Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: TossSpacing.space4),
                    ),
                    child: Text(
                      'Cancel',
                      style: TossTextStyles.body.copyWith(
                        color: TossColors.gray600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: TossSpacing.space3),
                Expanded(
                  child: ElevatedButton(
                    onPressed: (_fromDate != null && _toDate != null)
                        ? () => widget.onDatesSelected(_fromDate!, _toDate!)
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: TossColors.primary,
                      disabledBackgroundColor: TossColors.gray200,
                      foregroundColor: Colors.white,
                      disabledForegroundColor: TossColors.gray400,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: TossSpacing.space4),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                      ),
                    ),
                    child: Text(
                      'OK',
                      style: TossTextStyles.body.copyWith(
                        color: (_fromDate != null && _toDate != null) 
                            ? Colors.white 
                            : TossColors.gray400,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Bottom safe area
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }
}

