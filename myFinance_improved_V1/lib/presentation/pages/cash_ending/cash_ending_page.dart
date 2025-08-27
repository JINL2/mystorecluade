import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../core/themes/toss_colors.dart';
import '../../../core/themes/toss_text_styles.dart';
import '../../../core/themes/toss_spacing.dart';
import '../../../core/themes/toss_border_radius.dart';
import '../../../core/themes/toss_shadows.dart';
import '../../../core/themes/toss_animations.dart';
import '../../../core/themes/toss_icons.dart';
import '../../../core/constants/ui_constants.dart';
import '../../providers/app_state_provider.dart';
import '../../widgets/toss/toss_primary_button.dart';
import '../../widgets/toss/toss_card.dart';
import '../../widgets/toss/toss_tab_bar.dart';
import '../../widgets/common/toss_app_bar.dart';
import '../../widgets/common/toss_empty_state_card.dart';
import '../../widgets/common/toss_white_card.dart';
import '../../widgets/common/toss_currency_chip.dart';
import '../../widgets/common/toss_section_header.dart';
import '../../widgets/common/toss_number_input.dart';
import '../../widgets/common/toss_toggle_button.dart';
import '../../widgets/common/toss_scaffold.dart';
import '../../../data/services/stock_flow_service.dart';

// Page for cash ending functionality with tabs
class CashEndingPage extends ConsumerStatefulWidget {
  const CashEndingPage({super.key});

  @override
  ConsumerState<CashEndingPage> createState() => _CashEndingPageState();
}

class _CashEndingPageState extends ConsumerState<CashEndingPage>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late TabController _journalTabController; // For Journal/Real tabs
  String? selectedStoreId;
  String? selectedLocationId;
  
  // Recent cash endings data
  List<Map<String, dynamic>> recentCashEndings = [];
  bool isLoadingRecentEndings = false;
  
  // Currency data from Supabase
  List<Map<String, dynamic>> currencyTypes = [];
  bool isLoadingCurrency = true;
  
  // Company currencies from Supabase
  List<Map<String, dynamic>> companyCurrencies = [];
  
  // Currency denominations from Supabase
  Map<String, List<Map<String, dynamic>>> currencyDenominations = {};
  
  // Cash locations from Supabase
  List<Map<String, dynamic>> cashLocations = [];
  bool isLoadingCashLocations = false;
  
  // Bank locations from Supabase
  List<Map<String, dynamic>> bankLocations = [];
  bool isLoadingBankLocations = false;
  String? selectedBankLocationId;
  
  // Bank tab specific variables
  TextEditingController bankAmountController = TextEditingController();
  String? selectedBankCurrencyType; // Selected currency_id for bank tab
  List<Map<String, dynamic>> recentBankTransactions = [];
  bool isLoadingBankTransactions = false;
  
  // View All transactions variables
  List<Map<String, dynamic>> allBankTransactions = [];
  bool isLoadingAllTransactions = false;
  bool hasMoreTransactions = true;
  int transactionOffset = 0;
  final int transactionLimit = 10;
  
  // Vault balance state variables
  Map<String, dynamic>? vaultBalanceData;
  bool isLoadingVaultBalance = false;
  
  // Vault transaction type (debit/credit)
  String? vaultTransactionType; // 'debit' or 'credit'
  
  // Vault locations from Supabase
  List<Map<String, dynamic>> vaultLocations = [];
  bool isLoadingVaultLocations = false;
  String? selectedVaultLocationId;
  
  // Stores from Supabase
  List<Map<String, dynamic>> stores = [];
  bool isLoadingStores = true;
  
  // Denomination controllers for cash counting - dynamically created
  Map<String, Map<String, TextEditingController>> denominationControllers = {};
  
  // Selected currency for each tab
  String? selectedCashCurrencyId;
  String? selectedBankCurrencyId;
  String? selectedVaultCurrencyId;
  
  // Stock flow data for Real/Journal tabs
  List<JournalFlow> journalFlows = [];
  List<ActualFlow> actualFlows = [];
  LocationSummary? locationSummary;
  bool isLoadingFlows = false;
  int flowsOffset = 0;
  final int flowsLimit = 20;
  bool hasMoreFlows = false;
  String? selectedCashLocationIdForFlow;
  String selectedFilter = 'All';
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _journalTabController = TabController(length: 2, vsync: this);
    
    // Add listener to update UI when tab changes
    _tabController.addListener(() {
      if (mounted) {
        setState(() {
          // This will trigger a rebuild to update the button text
        });
      }
    });
    
    // Add listener for journal/real tab changes
    _journalTabController.addListener(() {
      if (mounted) {
        setState(() {
          // Update UI when switching between Real and Journal tabs
        });
      }
    });
    
    // Initialize selectedStoreId from app state
    final appState = ref.read(appStateProvider);
    final storeChoosenId = appState.storeChoosen;
    
    // Set selectedStoreId - storeChoosen contains the store_id from Supabase
    if (storeChoosenId.isNotEmpty) {
      selectedStoreId = storeChoosenId;
    }
    
    // Load currency data from Supabase
    _loadCurrencyTypes();
    
    // Load company currencies and denominations
    _loadCompanyCurrencies();
    
    // Load stores from Supabase
    _loadStores();
    
    // Load cash locations if store is already selected
    if (selectedStoreId != null && selectedStoreId!.isNotEmpty) {
      // Fetching all locations on init
      _fetchLocations('cash');
      _fetchLocations('bank');
      _fetchLocations('vault');
    }
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    _journalTabController.dispose();
    bankAmountController.dispose();
    denominationControllers.forEach((currencyId, controllers) {
      controllers.forEach((denomValue, controller) {
        controller.dispose();
      });
    });
    super.dispose();
  }
  
  // Load company currencies from Supabase
  Future<void> _loadCompanyCurrencies() async {
    try {
      final appState = ref.read(appStateProvider);
      final companyId = appState.companyChoosen;
      
      if (companyId.isEmpty) {
        return;
      }
      
      // Step 1: Query company_currency table to get currency_ids for this company
      final companyCurrencyResponse = await Supabase.instance.client
          .from('company_currency')
          .select('currency_id, company_currency_id')
          .eq('company_id', companyId);
      
      if (companyCurrencyResponse.isEmpty) {
        setState(() {
          companyCurrencies = [];
        });
        return;
      }
      
      // Step 2: Extract currency_ids
      final currencyIds = companyCurrencyResponse
          .map((item) => item['currency_id'].toString())
          .toList();
      
      // Step 3: Query currency_types to get full currency details
      final currencyTypesResponse = await Supabase.instance.client
          .from('currency_types')
          .select('currency_id, currency_code, currency_name, symbol')
          .inFilter('currency_id', currencyIds);
      
      // Step 4: Combine the data - match currency details with company_currency records
      final combinedCurrencies = <Map<String, dynamic>>[];
      for (var companyCurrency in companyCurrencyResponse) {
        final currencyId = companyCurrency['currency_id'].toString();
        final currencyType = currencyTypesResponse.firstWhere(
          (type) => type['currency_id'].toString() == currencyId,
          orElse: () => <String, dynamic>{},
        );
        
        if (currencyType.isNotEmpty) {
          // Combine company_currency data with currency_type details
          combinedCurrencies.add({
            'currency_id': currencyId,
            'company_currency_id': companyCurrency['company_currency_id'],
            'currency_code': currencyType['currency_code'],
            'currency_name': currencyType['currency_name'],
            'symbol': currencyType['symbol'],
          });
        }
      }
      
      setState(() {
        companyCurrencies = combinedCurrencies;
      });
      
      // Load denominations for each currency
      await _loadCurrencyDenominations();
    } catch (e) {
      // Error loading company currencies: $e
      setState(() {
        companyCurrencies = [];
      });
    }
  }
  
  // Load currency denominations from Supabase
  Future<void> _loadCurrencyDenominations() async {
    try {
      final appState = ref.read(appStateProvider);
      final companyId = appState.companyChoosen;
      
      if (companyId.isEmpty || companyCurrencies.isEmpty) {
        return;
      }
      
      
      // Query currency_denominations table
      final response = await Supabase.instance.client
          .from('currency_denominations')
          .select('*')
          .eq('company_id', companyId)
          .order('value', ascending: false);
      
      if (response.isNotEmpty) {
      }
      
      // Group denominations by currency_id
      Map<String, List<Map<String, dynamic>>> grouped = {};
      Map<String, Map<String, TextEditingController>> controllers = {};
      
      for (var denom in response) {
        final currencyId = denom['currency_id'].toString();
        if (!grouped.containsKey(currencyId)) {
          grouped[currencyId] = [];
          controllers[currencyId] = {};
        }
        grouped[currencyId]!.add(denom);
        // Create controller for each denomination
        controllers[currencyId]![denom['value'].toString()] = TextEditingController();
      }
      
      
      setState(() {
        currencyDenominations = grouped;
        denominationControllers = controllers;
        
        // Set default selected currency (first one)
        if (companyCurrencies.isNotEmpty) {
          selectedCashCurrencyId = companyCurrencies.first['currency_id'].toString();
          selectedBankCurrencyId = companyCurrencies.first['currency_id'].toString();
          selectedVaultCurrencyId = companyCurrencies.first['currency_id'].toString();
        }
      });
    } catch (e) {
    }
  }
  
  // Load currency types from Supabase
  Future<void> _loadCurrencyTypes() async {
    try {
      setState(() {
        isLoadingCurrency = true;
      });
      
      // Fetch all currency types from the currency_types table
      final response = await Supabase.instance.client
          .from('currency_types')
          .select('currency_id, currency_code, currency_name, symbol');
      
      setState(() {
        currencyTypes = List<Map<String, dynamic>>.from(response);
        isLoadingCurrency = false;
      });
      
      // Currency types loaded successfully
    } catch (e) {
      // Error loading currency types: $e
      setState(() {
        isLoadingCurrency = false;
        currencyTypes = [];
      });
    }
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
      });
    } catch (e) {
      // Error loading stores: $e
      setState(() {
        stores = [];
        isLoadingStores = false;
      });
    }
  }
  
  // Get the default currency (KRW) or first available
  Map<String, dynamic> getDefaultCurrency() {
    if (currencyTypes.isEmpty) {
      return {
        'currency_id': '',
        'currency_code': 'KRW',
        'currency_name': 'Korean Won',
        'symbol': '₩',
      };
    }
    
    // Try to find KRW as default
    final krw = currencyTypes.firstWhere(
      (currency) => currency['currency_code'] == 'KRW',
      orElse: () => currencyTypes.first,
    );
    
    return krw;
  }
  
  // Fetch locations for the selected store and type
  // locationType parameter allows filtering by 'cash', 'bank', or 'vault'
  Future<void> _fetchLocations(String locationType) async {
    // For headquarter (null store_id) or regular store
    try {
      setState(() {
        if (locationType == 'cash') {
          isLoadingCashLocations = true;
        } else if (locationType == 'bank') {
          isLoadingBankLocations = true;
        } else if (locationType == 'vault') {
          isLoadingVaultLocations = true;
        }
      });
      
      final appState = ref.read(appStateProvider);
      final companyId = appState.companyChoosen;
      
      if (companyId.isEmpty) {
        setState(() {
          if (locationType == 'cash') {
            cashLocations = [];
            isLoadingCashLocations = false;
          } else if (locationType == 'bank') {
            bankLocations = [];
            isLoadingBankLocations = false;
          } else if (locationType == 'vault') {
            vaultLocations = [];
            isLoadingVaultLocations = false;
          }
        });
        return;
      }
      
      // Build the query based on whether it's headquarter or a regular store
      final List<Map<String, dynamic>> response;
      
      if (selectedStoreId == 'headquarter') {
        // For headquarter, filter by null store_id and location_type
        response = await Supabase.instance.client
            .from('cash_locations')
            .select('*')  // Select all columns to see what's available
            .eq('company_id', companyId)
            .isFilter('store_id', null)
            .eq('location_type', locationType)  // Filter by location type (cash/bank/vault)
            .eq('is_deleted', false)  // Only show active locations
            .order('location_name');
      } else if (selectedStoreId != null && selectedStoreId!.isNotEmpty) {
        // For regular store, filter by store_id and location_type
        response = await Supabase.instance.client
            .from('cash_locations')
            .select('*')  // Select all columns to see what's available
            .eq('company_id', companyId)
            .eq('store_id', selectedStoreId!)
            .eq('location_type', locationType)  // Filter by location type (cash/bank/vault)
            .eq('is_deleted', false)  // Only show active locations
            .order('location_name');
      } else {
        // No store selected
        setState(() {
          if (locationType == 'cash') {
            cashLocations = [];
            isLoadingCashLocations = false;
          } else if (locationType == 'bank') {
            bankLocations = [];
            isLoadingBankLocations = false;
          } else if (locationType == 'vault') {
            vaultLocations = [];
            isLoadingVaultLocations = false;
          }
        });
        return;
      }
      
      // Debug: Print the first location to see its structure
      if (response.isNotEmpty) {
      }
      
      setState(() {
        if (locationType == 'cash') {
          cashLocations = List<Map<String, dynamic>>.from(response);
          isLoadingCashLocations = false;
          selectedLocationId = null;
        } else if (locationType == 'bank') {
          bankLocations = List<Map<String, dynamic>>.from(response);
          isLoadingBankLocations = false;
          selectedBankLocationId = null;
        } else if (locationType == 'vault') {
          vaultLocations = List<Map<String, dynamic>>.from(response);
          isLoadingVaultLocations = false;
          selectedVaultLocationId = null;
        }
      });
      
      // Cash locations loaded successfully
    } catch (e) {
      // Error fetching locations: $e
      setState(() {
        if (locationType == 'cash') {
          cashLocations = [];
          isLoadingCashLocations = false;
        } else if (locationType == 'bank') {
          bankLocations = [];
          isLoadingBankLocations = false;
        } else if (locationType == 'vault') {
          vaultLocations = [];
          isLoadingVaultLocations = false;
        }
      });
    }
  }
  
  bool _hasVaultBankPermission() {
    // Check if user has permission for Bank and Vault tabs
    final appState = ref.read(appStateProvider);
    final userData = appState.user;
    
    if (userData == null || userData['companies'] == null) {
      return false;
    }
    
    final companies = userData['companies'] as List<dynamic>;
    final selectedCompanyId = appState.companyChoosen;
    
    // Find the selected company
    final selectedCompany = companies.firstWhere(
      (company) => company['company_id'] == selectedCompanyId,
      orElse: () => null,
    );
    
    if (selectedCompany == null) {
      return false;
    }
    
    // Check if user has the required permission
    final role = selectedCompany['role'] as Map<String, dynamic>?;
    final permissions = role?['permissions'] as List<dynamic>? ?? [];
    
    // Check for the specific permission ID for Bank/Vault access
    const requiredPermission = 'b478a1ca-ba8e-4b55-949a-053f44ea2e36';
    return permissions.contains(requiredPermission);
  }
  
  @override
  Widget build(BuildContext context) {
    // Show loading indicator while fetching initial data
    if (isLoadingCurrency || isLoadingStores) {
      return TossScaffold(
        backgroundColor: TossColors.gray100,
        body: const Center(
          child: CircularProgressIndicator(color: TossColors.primary),
        ),
      );
    }
    
    final hasVaultBankAccess = _hasVaultBankPermission();
    
    return TossScaffold(
      backgroundColor: TossColors.gray100,
      appBar: TossAppBar(
        title: 'Cash Ending',
        backgroundColor: TossColors.gray100,
        leading: IconButton(
          icon: FaIcon(
            FontAwesomeIcons.chevronLeft,
            color: TossColors.gray700,
            size: TossSpacing.iconMD,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Tab Bar without background to match Cash Control design
            TossMinimalTabBar(
              tabs: const ['Cash', 'Bank', 'Vault'],
              controller: _tabController,
              selectedColor: Colors.black87, // Use black87 to match Cash Control page exactly
              showDivider: false, // Remove bottom divider to match Cash Control design
              unselectedColor: hasVaultBankAccess 
                  ? TossColors.gray400 
                  : TossColors.gray300, // Lighter gray for disabled tabs
              onTap: (index) {
                // Prevent switching to Bank or Vault tabs if no permission
                if (index > 0 && !hasVaultBankAccess) {
                  // Reset to Cash tab
                  _tabController.index = 0;
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('You do not have permission to access Bank/Vault features'),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                }
              },
            ),
            // Tab Content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                physics: hasVaultBankAccess ? null : const NeverScrollableScrollPhysics(),
                children: [
                  _buildCashTab(),
                  hasVaultBankAccess ? _buildBankTab() : _buildDisabledTabContent('Bank'),
                  hasVaultBankAccess ? _buildVaultTab() : _buildDisabledTabContent('Vault'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildDisabledTabContent(String tabName) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            TossIcons.lock,
            size: UIConstants.iconSizeHuge + 16, // 64px for large empty state
            color: TossColors.gray400,
          ),
          const SizedBox(height: TossSpacing.space4),
          Text(
            '$tabName tab is disabled',
            style: TossTextStyles.h3.copyWith(
              color: TossColors.gray600,
            ),
          ),
          const SizedBox(height: TossSpacing.space2),
          Text(
            'You do not have permission to access this feature',
            style: TossTextStyles.body.copyWith(
              color: TossColors.gray500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
  
  Widget _buildCashTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(TossSpacing.paddingMD),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Input Section - wrapped in white card
          TossCard(
            padding: const EdgeInsets.all(TossSpacing.space5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildStoreSelector(),
                if (selectedStoreId != null) ...[
                  const SizedBox(height: TossSpacing.space6),
                  _buildLocationSelector('cash'),
                ],
                if (selectedLocationId != null) ...[
                  const SizedBox(height: TossSpacing.space8),
                  _buildDenominationSection(tabType: 'cash'),
                  const SizedBox(height: TossSpacing.space8),
                  _buildTotalSection(tabType: 'cash'),
                  const SizedBox(height: TossSpacing.space10),
                  _buildSubmitButton(),
                ],
              ],
            ),
          ),
          
          // Show Journal/Real tabs only when location is selected
          _buildRealJournalSection(
            showSection: selectedLocationId != null && selectedLocationId!.isNotEmpty,
          ),
        ],
      ),
    );
  }
  
  // NOTE: This method is commented out as the history section has been replaced with Journal/Real tabs
  // Keeping for reference in case needed in the future
  /*
  Widget _buildRecentEndingDetail(Map<String, dynamic> ending) {
    final createdAt = ending['created_at'] != null
        ? DateTime.parse(ending['created_at'].toString())
        : DateTime.now();
    final dateFormat = DateFormat('yyyy.MM.dd');
    final timeFormat = DateFormat('HH:mm:ss');
    final userFullName = ending['user_full_name'] ?? 'Unknown User';
    final currencies = ending['parsed_currencies'] ?? [];
    final denominationData = ending['denomination_data'] ?? {};
    final currencyData = ending['currency_data'] ?? {};
    
    return TossWhiteCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Date and Time
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                dateFormat.format(createdAt),
                style: TossTextStyles.body.copyWith(
                  color: TossColors.gray600,
                ),
              ),
              Text(
                timeFormat.format(createdAt),
                style: TossTextStyles.body.copyWith(
                  color: TossColors.gray500,
                ),
              ),
            ],
          ),
          const SizedBox(height: TossSpacing.space3),
          
          // User who edited
          Row(
            children: [
              Icon(
                TossIcons.person,
                size: UIConstants.iconSizeXS,
                color: TossColors.gray500,
              ),
              const SizedBox(width: TossSpacing.space2),
              Text(
                'Edited by: $userFullName',
                style: TossTextStyles.bodySmall.copyWith(
                  color: TossColors.gray600,
                ),
              ),
            ],
          ),
          const SizedBox(height: TossSpacing.space4),
          
          // Denomination details
          if (currencies.isNotEmpty) ...[
            // Process each currency
            for (var currency in currencies) ...[
              () {
                final currencyId = currency['currency_id'];
                final denominations = currency['denominations'] ?? [];
                
                
                // Get currency details - first try currencyData, then currencyTypes, then companyCurrencies
                var currencyInfo = currencyData[currencyId];
                
                if (currencyInfo == null || currencyInfo.isEmpty) {
                  // Try to find in currencyTypes (loaded from currency_types table)
                  currencyInfo = currencyTypes.firstWhere(
                    (c) => c['currency_id'] == currencyId,
                    orElse: () => companyCurrencies.firstWhere(
                      (c) => c['currency_id'] == currencyId,
                      orElse: () => {},
                    ),
                  );
                }
                
                // Use the actual currency symbol and code from the data
                final currencySymbol = currencyInfo['symbol'] ?? '';
                final currencyCode = currencyInfo['currency_code'] ?? '';
                
                
                // Calculate total amount
                double totalAmount = 0;
                for (var denom in denominations) {
                  final denominationId = denom['denomination_id'];
                  final quantity = (denom['quantity'] ?? 0) is int 
                      ? (denom['quantity'] ?? 0) as int 
                      : ((denom['quantity'] ?? 0) as num).toInt();
                  
                  // Find denomination value - use the denomination data we loaded
                  final denominationsList = denominationData[currencyId] ?? currencyDenominations[currencyId];
                  if (denominationsList != null) {
                    final denominationInfo = denominationsList.firstWhere(
                      (d) => d['denomination_id'] == denominationId,
                      orElse: () => {'value': 0},
                    );
                    final valueRaw = denominationInfo['value'] ?? 0;
                    final value = valueRaw is int ? valueRaw : (valueRaw as num).toDouble();
                    totalAmount += value * quantity;
                  }
                }
                
                
                // Only display if we have denomination data or if total is 0
                if (totalAmount > 0 || denominations.isNotEmpty) {
                  // Display total
                  return Container(
                    padding: const EdgeInsets.all(TossSpacing.space3),
                    margin: const EdgeInsets.only(bottom: TossSpacing.space3),
                    decoration: BoxDecoration(
                      color: TossColors.gray50,
                      borderRadius: BorderRadius.circular(TossBorderRadius.md),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Total Amount ($currencyCode)',
                          style: TossTextStyles.caption.copyWith(
                            color: TossColors.gray500,
                          ),
                        ),
                        const SizedBox(height: TossSpacing.space1),
                        Text(
                          NumberFormat.currency(
                            symbol: currencySymbol,
                            decimalDigits: 0,
                          ).format(totalAmount),
                          style: TossTextStyles.h3.copyWith(
                            color: TossColors.gray900,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'JetBrains Mono',
                          ),
                        ),
                        const SizedBox(height: TossSpacing.space3),
                        
                        // Show denomination breakdown
                        if (denominations.isNotEmpty) ...[
                          Text(
                            'Denomination Breakdown',
                            style: TossTextStyles.caption.copyWith(
                              color: TossColors.gray500,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: TossSpacing.space2),
                          // First, prepare and sort denominations by value
                          () {
                            // Create a list of denominations with their values
                            List<Map<String, dynamic>> sortedDenoms = [];
                            for (var denom in denominations) {
                              final denominationId = denom['denomination_id'];
                              final quantity = denom['quantity'] ?? 0;
                              
                              if (quantity > 0) {
                                // Find denomination value
                                final denominationsList = denominationData[currencyId] ?? currencyDenominations[currencyId];
                                var value = 0;
                                if (denominationsList != null) {
                                  final denominationInfo = denominationsList.firstWhere(
                                    (d) => d['denomination_id'] == denominationId,
                                    orElse: () => {'value': 0},
                                  );
                                  final valueRaw = denominationInfo['value'] ?? 0;
                                  value = valueRaw is int ? valueRaw : (valueRaw as num).toInt();
                                }
                                
                                sortedDenoms.add({
                                  'value': value,
                                  'quantity': quantity,
                                  'denominationId': denominationId,
                                });
                              }
                            }
                            
                            // Sort by value in descending order (largest first)
                            sortedDenoms.sort((a, b) {
                              final bValue = b['value'] is int ? b['value'] as int : (b['value'] as num).toInt();
                              final aValue = a['value'] is int ? a['value'] as int : (a['value'] as num).toInt();
                              return bValue.compareTo(aValue);
                            });
                            
                            // Now build the widgets
                            return Column(
                              children: sortedDenoms.map((item) {
                                final value = item['value'] is int 
                                    ? item['value'] as int 
                                    : (item['value'] as num).toInt();
                                final quantity = item['quantity'] is int 
                                    ? item['quantity'] as int 
                                    : (item['quantity'] as num).toInt();
                                
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: TossSpacing.space2),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '$currencySymbol${NumberFormat('#,###').format(value)}',
                                        style: TossTextStyles.bodySmall.copyWith(
                                          color: TossColors.gray600,
                                        ),
                                      ),
                                      Text(
                                        '× $quantity pcs',
                                        style: TossTextStyles.bodySmall.copyWith(
                                          color: TossColors.gray500,
                                        ),
                                      ),
                                      Text(
                                        '$currencySymbol${NumberFormat('#,###').format(value * quantity)}',
                                        style: TossTextStyles.bodySmall.copyWith(
                                          color: TossColors.gray700,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            );
                          }(),
                        ],
                      ],
                    ),
                  );
                } else {
                  return const SizedBox.shrink();
                }
              }(),
            ],
          ],
        ],
      ),
    );
  }
  */
  
  Widget _buildDebitCreditToggle() {
    return TossToggleButtonGroup(
      buttons: [
        TossToggleButtonData(
          label: 'In',
          value: 'debit',
          activeColor: TossColors.primary,
        ),
        TossToggleButtonData(
          label: 'Out',
          value: 'credit',
          activeColor: TossColors.success,
        ),
      ],
      selectedValue: vaultTransactionType,
      onPressed: (value) {
        setState(() {
          vaultTransactionType = value;
        });
      },
    );
  }
  
  Widget _buildVaultBalance() {
    if (isLoadingVaultBalance) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(TossSpacing.space4),
          child: CircularProgressIndicator(
            color: TossColors.primary,
            strokeWidth: 2,
          ),
        ),
      );
    }
    
    if (vaultBalanceData == null || vaultBalanceData!['vaults'] == null) {
      return TossEmptyStateCard(
        message: 'No vault balance data available',
      );
    }
    
    // Find the selected vault's data
    final vaults = vaultBalanceData!['vaults'] as List;
    final selectedVault = vaults.firstWhere(
      (vault) => vault['cash_location_id'] == selectedVaultLocationId,
      orElse: () => null,
    );
    
    if (selectedVault == null) {
      return TossEmptyStateCard(
        message: 'No balance data for this vault',
      );
    }
    
    final currencies = selectedVault['currencies'] as List;
    final locationName = selectedVault['location_name'] ?? 'Vault';
    final baseCurrencyCode = vaultBalanceData!['summary']['base_currency_code'] ?? '';
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Vault location name header
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: TossSpacing.space4,
            vertical: TossSpacing.space3,
          ),
          decoration: BoxDecoration(
            color: TossColors.primary.withOpacity(0.05),
            borderRadius: BorderRadius.circular(TossBorderRadius.lg),
          ),
          child: Row(
            children: [
              Icon(
                TossIcons.wallet,
                color: TossColors.primary,
                size: UIConstants.iconSizeMedium,
              ),
              const SizedBox(width: TossSpacing.space2),
              Text(
                locationName,
                style: TossTextStyles.bodyLarge.copyWith(
                  color: TossColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: TossSpacing.space4),
        
        // Currency balances
        TossWhiteCard(
          child: Column(
            children: [
              // Display each currency balance
              ...currencies.asMap().entries.map((entry) {
                final index = entry.key;
                final currency = entry.value;
                final currencySymbol = currency['currency_symbol'] ?? '';
                final totalAmount = currency['total_amount'] ?? 0;
                final currencyCode = currency['currency_code'] ?? '';
                final isBaseCurrency = currency['is_base_currency'] ?? false;
                final baseAmount = currency['base_currency_amount'] ?? 0;
                final exchangeRate = currency['exchange_rate'] ?? 1.0;
                
                return Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(TossSpacing.space4),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Currency info
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: TossSpacing.space2,
                                      vertical: TossSpacing.space1,
                                    ),
                                    decoration: BoxDecoration(
                                      color: isBaseCurrency 
                                        ? TossColors.primary.withOpacity(0.1) 
                                        : TossColors.gray100,
                                      borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                                    ),
                                    child: Text(
                                      currencyCode,
                                      style: TossTextStyles.body.copyWith(
                                        color: isBaseCurrency 
                                          ? TossColors.primary 
                                          : TossColors.gray700,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  if (isBaseCurrency) ...[
                                    const SizedBox(width: TossSpacing.space2),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: TossSpacing.space2,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: TossColors.success.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(TossBorderRadius.xs),
                                      ),
                                      child: Text(
                                        'BASE',
                                        style: TossTextStyles.caption.copyWith(
                                          color: TossColors.success,
                                          fontSize: 10,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                              // Amount
                              Text(
                                '$currencySymbol${NumberFormat('#,###').format(totalAmount)}',
                                style: TossTextStyles.h3.copyWith(
                                  color: TossColors.gray900,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: 'JetBrains Mono',
                                ),
                              ),
                            ],
                          ),
                          // Show exchange rate and base currency amount for non-base currencies
                          if (!isBaseCurrency) ...[
                            const SizedBox(height: TossSpacing.space3),
                            Container(
                              padding: const EdgeInsets.all(TossSpacing.space3),
                              decoration: BoxDecoration(
                                color: TossColors.gray50,
                                borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        TossIcons.currency,
                                        size: 14,
                                        color: TossColors.gray600,
                                      ),
                                      const SizedBox(width: TossSpacing.space1),
                                      Text(
                                        'Exchange Rate',
                                        style: TossTextStyles.caption.copyWith(
                                          color: TossColors.gray600,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: TossSpacing.space1),
                                  Text(
                                    '1 $currencyCode = ${NumberFormat('#,###.##').format(exchangeRate)} $baseCurrencyCode',
                                    style: TossTextStyles.body.copyWith(
                                      color: TossColors.gray700,
                                    ),
                                  ),
                                  const SizedBox(height: TossSpacing.space2),
                                  Container(
                                    padding: const EdgeInsets.all(TossSpacing.space2),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(TossBorderRadius.xs),
                                      border: Border.all(
                                        color: TossColors.gray200,
                                        width: UIConstants.borderWidth,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Equivalent Value',
                                          style: TossTextStyles.body.copyWith(
                                            color: TossColors.gray600,
                                          ),
                                        ),
                                        Text(
                                          '${NumberFormat('#,###').format(baseAmount)} $baseCurrencyCode',
                                          style: TossTextStyles.bodyLarge.copyWith(
                                            color: TossColors.primary,
                                            fontWeight: FontWeight.w600,
                                            fontFamily: 'JetBrains Mono',
                                          ),
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
                    ),
                    if (index < currencies.length - 1)
                      const Divider(
                        color: TossColors.gray100,
                        thickness: 1,
                        height: UIConstants.borderWidth,
                      ),
                  ],
                );
              }).toList(),
              
              // Show total in base currency if there are multiple currencies
              if (currencies.length > 1) ...[
                Container(
                  padding: const EdgeInsets.all(TossSpacing.space4),
                  decoration: BoxDecoration(
                    color: TossColors.primary.withOpacity(0.05),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(TossBorderRadius.lg),
                      bottomRight: Radius.circular(TossBorderRadius.lg),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total Balance',
                        style: TossTextStyles.bodyLarge.copyWith(
                          color: TossColors.gray700,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '${NumberFormat('#,###').format(selectedVault['vault_total_base_amount'] ?? 0)} $baseCurrencyCode',
                        style: TossTextStyles.h3.copyWith(
                          color: TossColors.primary,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'JetBrains Mono',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
  
  Widget _buildHistoryItem(int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: TossSpacing.space4),
      child: TossWhiteCard(
        padding: const EdgeInsets.all(TossSpacing.space4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: TossSpacing.space2,
                    vertical: TossSpacing.space1,
                  ),
                  decoration: BoxDecoration(
                    color: TossColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                  ),
                  child: Text(
                    cashLocations.isNotEmpty 
                        ? (cashLocations[index % cashLocations.length]['location_name'] ?? 'Location ${index + 1}')
                        : 'Location ${index + 1}',
                    style: TossTextStyles.caption.copyWith(
                      color: TossColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Text(
                  '2024.01.${15 - index}',
                  style: TossTextStyles.caption.copyWith(
                    color: TossColors.gray500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: TossSpacing.space3),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '09:${30 + index}:00',
                  style: TossTextStyles.bodySmall.copyWith(
                    color: TossColors.gray500,
                  ),
                ),
                Text(
                  formatCurrency(1234560 + index * 10000),
                  style: TossTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.w700,
                    color: TossColors.gray900,
                    fontFamily: 'JetBrains Mono',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildStoreSelector() {
    // If no stores available
    if (stores.isEmpty) {
      return TossEmptyStateCard(
        message: 'No stores available',
        icon: TossIcons.info,
      );
    }
    
    // Get selected store name
    String storeName = 'Select Store';
    if (selectedStoreId == 'headquarter') {
      storeName = 'Headquarter';
    } else if (selectedStoreId != null) {
      try {
        final store = stores.firstWhere(
          (s) => s['store_id'] == selectedStoreId,
        );
        storeName = store['store_name'] ?? 'Unknown Store';
      } catch (e) {
        // Store not found in the list
        storeName = 'Select Store';
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
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(TossSpacing.space4),
            decoration: BoxDecoration(
              color: TossColors.background,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: TossColors.gray200,
                width: 1,
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
                  width: UIConstants.avatarSizeSmall,
                  height: UIConstants.avatarSizeSmall,
                  decoration: BoxDecoration(
                    color: TossColors.gray50,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    TossIcons.getStoreIcon(selectedStoreId == 'headquarter' ? 'headquarter' : 'store'),
                    size: UIConstants.iconSizeMedium,
                    color: TossColors.gray600,
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
                          color: TossColors.gray900,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  TossIcons.forward,
                  color: TossColors.gray400,
                  size: UIConstants.iconSizeLarge,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
  
  Widget _buildLocationSelector(String locationType) {
    final bool isLoading;
    final List<Map<String, dynamic>> locations;
    final String? selectedLocation;
    
    if (locationType == 'cash') {
      isLoading = isLoadingCashLocations;
      locations = cashLocations;
      selectedLocation = selectedLocationId;
    } else if (locationType == 'bank') {
      isLoading = isLoadingBankLocations;
      locations = bankLocations;
      selectedLocation = selectedBankLocationId;
    } else {
      isLoading = isLoadingVaultLocations;
      locations = vaultLocations;
      selectedLocation = selectedVaultLocationId;
    }
    
    if (isLoading) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(TossSpacing.space4),
          child: CircularProgressIndicator(
            color: TossColors.primary,
            strokeWidth: 2,
          ),
        ),
      );
    }
    
    if (locations.isEmpty) {
      return TossEmptyStateCard(
        message: 'No ${locationType} locations available for this store',
        icon: TossIcons.locationOff,
      );
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Cash Location',
          style: TossTextStyles.label.copyWith(
            color: TossColors.gray700,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: TossSpacing.space3),
        Wrap(
          spacing: TossSpacing.space3,
          runSpacing: TossSpacing.space3,
          children: locations.map((location) {
            // Debug: Print location structure
            
            // Try different possible field names for the location ID
            final locationId = location['cash_location_id']?.toString() ?? 
                              location['bank_location_id']?.toString() ?? 
                              location['vault_location_id']?.toString() ?? 
                              location['id']?.toString() ?? 
                              location['location_id']?.toString() ?? 
                              '';
            final locationName = location['location_name'] ?? 'Unknown';
            final isSelected = selectedLocation == locationId;
            
            // Check if this location has a fixed currency (for bank and vault locations)
            final locationCurrencyId = location['currency_id']?.toString();
            final hasFixedCurrency = (locationType == 'bank' || locationType == 'vault') && 
                                    locationCurrencyId != null && 
                                    locationCurrencyId.isNotEmpty;
            
            // Get currency code if location has fixed currency
            String? currencyCode;
            if (hasFixedCurrency) {
              final currency = currencyTypes.firstWhere(
                (c) => c['currency_id']?.toString() == locationCurrencyId,
                orElse: () => {},
              );
              currencyCode = currency['currency_code']?.toString();
            }
            
            return GestureDetector(
              onTap: () {
                setState(() {
                  if (locationType == 'cash') {
                    selectedLocationId = locationId;
                  } else if (locationType == 'bank') {
                    selectedBankLocationId = locationId;
                    
                    // Get currency_id from the selected bank location
                    final locationCurrencyId = location['currency_id']?.toString();
                    if (locationCurrencyId != null && locationCurrencyId.isNotEmpty) {
                      // Auto-select the currency based on location's currency_id
                      selectedBankCurrencyType = locationCurrencyId;
                    }
                    
                    // Fetch recent transactions when bank location is selected
                    _fetchRecentBankTransactions();
                  } else {
                    selectedVaultLocationId = locationId;
                    // Fetch vault balance when vault location is selected
                    _fetchVaultBalance();
                  }
                });
                
                // Load stock flow data for Real/Journal tabs for all location types
                if (locationId.isNotEmpty) {
                  selectedCashLocationIdForFlow = locationId;
                  _fetchLocationStockFlow(locationId);
                  
                  // Also load recent cash endings for compatibility (cash tab only)
                  if (locationType == 'cash') {
                    _loadRecentCashEndings(locationId);
                  }
                }
                
                HapticFeedback.selectionClick();
              },
              child: AnimatedContainer(
                duration: TossAnimations.normal,
                padding: const EdgeInsets.symmetric(
                  horizontal: TossSpacing.space5,
                  vertical: TossSpacing.space3,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? TossColors.primary : Colors.white,
                  borderRadius: BorderRadius.circular(TossBorderRadius.full),
                  border: Border.all(
                    color: isSelected ? TossColors.primary : TossColors.gray300,
                    width: 1.5,
                  ),
                  boxShadow: isSelected ? TossShadows.elevation2 : [],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      locationName,
                      style: TossTextStyles.body.copyWith(
                        color: isSelected ? Colors.white : TossColors.gray700,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                      ),
                    ),
                    if (hasFixedCurrency && currencyCode != null) ...[
                      const SizedBox(width: TossSpacing.space2),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: TossSpacing.space2,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected 
                              ? Colors.white.withOpacity(0.2)
                              : TossColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(TossBorderRadius.xs),
                        ),
                        child: Text(
                          currencyCode,
                          style: TossTextStyles.caption.copyWith(
                            color: isSelected ? Colors.white : TossColors.primary,
                            fontWeight: FontWeight.w600,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
  
  Widget _buildDenominationSection({String tabType = 'cash'}) {
    
    // Get selected currency ID based on tab
    final String? selectedCurrencyId;
    if (tabType == 'cash') {
      selectedCurrencyId = selectedCashCurrencyId;
    } else if (tabType == 'bank') {
      selectedCurrencyId = selectedBankCurrencyId;
    } else {
      selectedCurrencyId = selectedVaultCurrencyId;
    }
    
    // For Cash and Vault tabs: Always show currency selector first
    if (tabType != 'bank') {
      // Show currency selector even if no currency is selected yet
      if (companyCurrencies.isEmpty) {
        return TossEmptyStateCard(
          message: 'Loading currency data...',
        );
      }
      
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Always show currency selector for cash/vault tabs
          _buildCurrencySelector(tabType),
          const SizedBox(height: TossSpacing.space6),
          
          // Only show denominations if a currency is selected
          if (selectedCurrencyId != null && currencyDenominations.containsKey(selectedCurrencyId)) ...[
            _buildDenominationList(selectedCurrencyId, tabType),
          ],
        ],
      );
    }
    
    // For Bank tab: Must have a selected currency from location
    if (selectedCurrencyId == null || !currencyDenominations.containsKey(selectedCurrencyId)) {
      return TossEmptyStateCard(
        message: 'Loading currency data...',
      );
    }
    
    // Bank tab continues with denominations only (no currency selector)
    return _buildDenominationList(selectedCurrencyId, tabType);
  }
  
  Widget _buildDenominationList(String selectedCurrencyId, String tabType) {
    // Get currency info from companyCurrencies (already has all details)
    final currencyInfo = companyCurrencies.firstWhere(
      (c) => c['currency_id'].toString() == selectedCurrencyId,
      orElse: () => {},
    );
    
    final currencyCode = currencyInfo['currency_code'] ?? 'N/A';
    final currencySymbol = currencyInfo['symbol'] ?? '';
    
    final denominations = currencyDenominations[selectedCurrencyId] ?? [];
    final controllers = denominationControllers[selectedCurrencyId] ?? {};
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TossSectionHeader(
          title: 'Cash Count',
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(width: TossSpacing.space2),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: TossSpacing.space2,
                  vertical: TossSpacing.space1,
                ),
                decoration: BoxDecoration(
                  color: TossColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                ),
                child: Text(
                  currencyCode,
                  style: TossTextStyles.caption.copyWith(
                    color: TossColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: TossSpacing.space5),
        ...denominations.map((denom) {
          final denomValue = denom['value'].toString();
          final controller = controllers[denomValue] ?? TextEditingController();
          return _buildDenominationInput(
            denomination: denom,
            controller: controller,
            currencySymbol: currencySymbol,
          );
        }).toList(),
      ],
    );
  }
  
  // Build currency selector for multiple currencies
  Widget _buildCurrencySelector(String tabType) {
    final String? selectedCurrencyId;
    if (tabType == 'cash') {
      selectedCurrencyId = selectedCashCurrencyId;
    } else if (tabType == 'bank') {
      selectedCurrencyId = selectedBankCurrencyId;
    } else {
      selectedCurrencyId = selectedVaultCurrencyId;
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Currency',
          style: TossTextStyles.label.copyWith(
            color: TossColors.gray700,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: TossSpacing.space3),
        Wrap(
          spacing: TossSpacing.space3,
          runSpacing: TossSpacing.space3,
          children: companyCurrencies.map((currency) {
            final currencyId = currency['currency_id'].toString();
            // Currency details are already in companyCurrencies after the join
            final symbol = currency['symbol'] ?? '';
            final currencyCode = currency['currency_code'] ?? 'N/A';
            final isSelected = selectedCurrencyId == currencyId;
            
            return TossCurrencyChip(
              currencyId: currencyId,
              symbol: symbol,
              currencyCode: currencyCode,
              isSelected: isSelected,
              onTap: () {
                setState(() {
                  // Store the previously selected currency ID
                  String? previousCurrencyId;
                  if (tabType == 'cash') {
                    previousCurrencyId = selectedCashCurrencyId;
                    selectedCashCurrencyId = currencyId;
                  } else if (tabType == 'bank') {
                    previousCurrencyId = selectedBankCurrencyId;
                    selectedBankCurrencyId = currencyId;
                  } else {
                    previousCurrencyId = selectedVaultCurrencyId;
                    selectedVaultCurrencyId = currencyId;
                  }
                  
                  // Clear denomination data if currency changed
                  if (previousCurrencyId != currencyId && previousCurrencyId != null) {
                    // Clear controllers for the previous currency
                    if (denominationControllers.containsKey(previousCurrencyId)) {
                      denominationControllers[previousCurrencyId]!.forEach((key, controller) {
                        controller.clear();
                      });
                    }
                  }
                });
                HapticFeedback.selectionClick();
              },
            );
          }).toList(),
        ),
      ],
    );
  }
  
  Widget _buildDenominationInput({
    required Map<String, dynamic> denomination,
    required TextEditingController controller,
    required String currencySymbol,
  }) {
    final amountRaw = denomination['value'] ?? 0;
    final amount = amountRaw is int ? amountRaw : (amountRaw as num).toInt();
    final formattedAmount = NumberFormat('#,###').format(amount);
    
    return Container(
      margin: const EdgeInsets.only(bottom: TossSpacing.space4),
      child: Row(
        children: [
          // Denomination label
          SizedBox(
            width: 100, // Fixed width for cash count button
            child: Row(
              children: [
                Container(
                  width: 8, // Small indicator dot
                  height: 8,
                  decoration: BoxDecoration(
                    color: amount >= 10000 ? TossColors.primary : TossColors.gray400,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: TossSpacing.space3),
                Text(
                  '$currencySymbol$formattedAmount',
                  style: TossTextStyles.body.copyWith(
                    fontWeight: FontWeight.w600,
                    color: TossColors.gray700,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: TossSpacing.space4),
          // Quantity input
          Expanded(
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                color: TossColors.surface,
                borderRadius: BorderRadius.circular(TossBorderRadius.md),
                border: Border.all(
                  color: controller.text.isNotEmpty 
                      ? TossColors.primary.withOpacity(0.3) 
                      : TossColors.gray200,
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TossNumberInput(
                      controller: controller,
                      hintText: '0',
                      textAlign: TextAlign.center,
                      onChanged: (_) => setState(() {}),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space3),
                    child: Text(
                      'pcs',
                      style: TossTextStyles.caption.copyWith(
                        color: TossColors.gray500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: TossSpacing.space3),
          // Subtotal
          SizedBox(
            width: 100, // Fixed width for cash count button
            child: Text(
              _calculateSubtotal(denomination['value'].toString(), controller.text, currencySymbol),
              style: TossTextStyles.body.copyWith(
                fontWeight: FontWeight.w600,
                color: TossColors.gray900,
                fontFamily: 'JetBrains Mono',
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildTotalSection({String tabType = 'cash'}) {
    final total = _calculateTotal(tabType: tabType);
    
    return TossCard(
      child: Container(
        padding: const EdgeInsets.all(TossSpacing.space5),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total Amount',
                  style: TossTextStyles.body.copyWith(
                    color: TossColors.gray600,
                  ),
                ),
                AnimatedSwitcher(
                  duration: TossAnimations.slow,
                  child: Text(
                    total,
                    key: ValueKey(total),
                    style: TossTextStyles.h2.copyWith(
                      color: TossColors.primary,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'JetBrains Mono',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: TossSpacing.space3),
            Container(
              height: 3,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    TossColors.primary.withOpacity(0.1),
                    TossColors.primary.withOpacity(0.3),
                    TossColors.primary.withOpacity(0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(TossBorderRadius.full),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildSubmitButton() {
    // Determine button text and calculate total based on current tab
    String buttonText = 'Save Cash Ending';
    bool canSubmit = false;
    
    if (_tabController.index == 0) {
      // Cash tab
      canSubmit = _calculateTotalAmount(tabType: 'cash') > 0;
    } else if (_tabController.index == 1) {
      // Bank tab  
      canSubmit = _calculateTotalAmount(tabType: 'bank') > 0;
    } else if (_tabController.index == 2) {
      // Vault tab
      buttonText = 'Save Vault Balance';
      canSubmit = _calculateTotalAmount(tabType: 'vault') > 0 && vaultTransactionType != null;
    }
    
    return TossPrimaryButton(
      text: buttonText,
      onPressed: canSubmit ? () async {
        if (_tabController.index == 2) {
          // For vault tab, use the vault-specific save function
          await _saveVaultBalance();
        } else {
          // For cash and bank tabs, use the existing save function
          await _saveCashEnding();
        }
      } : null,
      isLoading: false,
    );
  }
  
  Widget _buildBankTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(TossSpacing.paddingMD),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Input Section - wrapped in white card
          TossCard(
            padding: const EdgeInsets.all(TossSpacing.space5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildStoreSelector(),
                if (selectedStoreId != null) ...[
                  const SizedBox(height: TossSpacing.space6),
                  _buildLocationSelector('bank'),
                ],
                if (selectedBankLocationId != null) ...[
                  const SizedBox(height: TossSpacing.space8),
                  _buildBankAmountInput(),
                  const SizedBox(height: TossSpacing.space6),
                  _buildBankCurrencySelector(),
                  const SizedBox(height: TossSpacing.space6),
                  _buildBankSaveButton(),
                ],
              ],
            ),
          ),
          
          // Show Journal/Real tabs when bank location is selected
          const SizedBox(height: TossSpacing.space5),
          _buildRealJournalSection(
            showSection: selectedBankLocationId != null && selectedBankLocationId!.isNotEmpty,
          ),
        ],
      ),
    );
  }
  
  // Build bank amount input field
  Widget _buildBankAmountInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              TossIcons.bank,
              size: UIConstants.iconSizeMedium,
              color: TossColors.primary,
            ),
            const SizedBox(width: TossSpacing.space2),
            Text(
              'Bank Balance',
              style: TossTextStyles.bodyLarge.copyWith(
                color: TossColors.gray900,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: TossSpacing.space3),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(TossBorderRadius.lg),
            border: Border.all(
              color: bankAmountController.text.isNotEmpty 
                  ? TossColors.primary.withOpacity(0.3) 
                  : TossColors.gray200,
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TossNumberInput(
            controller: bankAmountController,
            hintText: '0',
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              TextInputFormatter.withFunction((oldValue, newValue) {
                if (newValue.text.isEmpty) return newValue;
                final number = int.parse(newValue.text.replaceAll(',', ''));
                final formatted = NumberFormat('#,###').format(number);
                return TextEditingValue(
                  text: formatted,
                  selection: TextSelection.collapsed(offset: formatted.length),
                );
              }),
            ],
            onChanged: (_) => setState(() {}),
          ),
        ),
        const SizedBox(height: TossSpacing.space2),
        Text(
          'Enter the current bank balance amount',
          style: TossTextStyles.caption.copyWith(
            color: TossColors.gray500,
          ),
        ),
      ],
    );
  }
  
  // Build save button for bank amount
  Widget _buildBankSaveButton() {
    // Enable button only when both amount is entered AND currency is selected
    final hasAmount = bankAmountController.text.isNotEmpty;
    final hasCurrency = selectedBankCurrencyType != null;
    final isEnabled = hasAmount && hasCurrency;
    
    return TossPrimaryButton(
      text: 'Save Bank Balance',
      onPressed: isEnabled ? () async {
        await _saveBankBalance();
      } : null,
      isLoading: false,
    );
  }
  
  // Fetch recent bank transactions from Supabase
  Future<void> _fetchRecentBankTransactions() async {
    if (selectedStoreId == null || selectedBankLocationId == null) return;
    
    setState(() {
      isLoadingBankTransactions = true;
    });
    
    try {
      final appState = ref.read(appStateProvider);
      final companyId = appState.companyChoosen;
      
      // Query bank_amount table with filters - get only the most recent one
      final query = Supabase.instance.client
          .from('bank_amount')
          .select('location_id, currency_id, total_amount, created_by, created_at, record_date')
          .eq('company_id', companyId)
          .eq('location_id', selectedBankLocationId!);
      
      // Handle store_id filter - only add if not headquarter
      if (selectedStoreId != 'headquarter' && selectedStoreId != null) {
        query.eq('store_id', selectedStoreId!);
      } else if (selectedStoreId == 'headquarter') {
        query.isFilter('store_id', null);
      }
      
      final response = await query
          .order('created_at', ascending: false)
          .limit(1); // Get only the most recent transaction
      
      if (response != null && response.isNotEmpty) {
        // Fetch user information for the transaction
        final transaction = response[0];
        final userId = transaction['created_by'];
        
        if (userId != null) {
          // Query users table to get user name
          final userResponse = await Supabase.instance.client
              .from('users')
              .select('first_name, last_name')
              .eq('user_id', userId)
              .single();
          
          if (userResponse != null) {
            // Add user name to transaction data
            transaction['user_first_name'] = userResponse['first_name'] ?? '';
            transaction['user_last_name'] = userResponse['last_name'] ?? '';
            transaction['user_full_name'] = '${userResponse['first_name'] ?? ''} ${userResponse['last_name'] ?? ''}'.trim();
          }
        }
        
        setState(() {
          recentBankTransactions = [transaction]; // Store as single-item list
          isLoadingBankTransactions = false;
        });
      } else {
        setState(() {
          recentBankTransactions = [];
          isLoadingBankTransactions = false;
        });
      }
      
    } catch (e) {
      setState(() {
        isLoadingBankTransactions = false;
      });
    }
  }
  
  // Fetch vault balance
  Future<void> _fetchVaultBalance() async {
    if (selectedStoreId == null || selectedVaultLocationId == null) return;
    
    setState(() {
      isLoadingVaultBalance = true;
    });
    
    try {
      final appState = ref.read(appStateProvider);
      final companyId = appState.companyChoosen;
      
      final response = await Supabase.instance.client.rpc(
        'get_vault_amount_line_history',
        params: {
          'p_company_id': companyId,
          'p_store_id': selectedStoreId,
        },
      );
      
      if (response != null && response['success'] == true) {
        setState(() {
          vaultBalanceData = response['data'];
          isLoadingVaultBalance = false;
        });
      } else {
        setState(() {
          vaultBalanceData = null;
          isLoadingVaultBalance = false;
        });
      }
    } catch (e) {
      setState(() {
        vaultBalanceData = null;
        isLoadingVaultBalance = false;
      });
    }
  }
  
  // Fetch all bank transactions with pagination
  Future<void> _fetchAllBankTransactions({bool loadMore = false, Function? updateUI}) async {
    if (selectedStoreId == null || selectedBankLocationId == null) return;
    
    if (!loadMore) {
      // Use updateUI callback if provided (for bottom sheet), otherwise use setState
      if (updateUI != null) {
        isLoadingAllTransactions = true;
        transactionOffset = 0;
        allBankTransactions = [];
        hasMoreTransactions = true;
        updateUI();
      } else {
        setState(() {
          isLoadingAllTransactions = true;
          transactionOffset = 0;
          allBankTransactions = [];
          hasMoreTransactions = true;
        });
      }
    } else {
      if (!hasMoreTransactions || isLoadingAllTransactions) return;
      if (updateUI != null) {
        isLoadingAllTransactions = true;
        updateUI();
      } else {
        setState(() {
          isLoadingAllTransactions = true;
        });
      }
    }
    
    try {
      final appState = ref.read(appStateProvider);
      final companyId = appState.companyChoosen;
      
      // Query bank_amount table with filters
      final query = Supabase.instance.client
          .from('bank_amount')
          .select('location_id, currency_id, total_amount, created_by, created_at, record_date')
          .eq('company_id', companyId)
          .eq('location_id', selectedBankLocationId!);
      
      // Handle store_id filter
      if (selectedStoreId != 'headquarter' && selectedStoreId != null) {
        query.eq('store_id', selectedStoreId!);
      } else if (selectedStoreId == 'headquarter') {
        query.isFilter('store_id', null);
      }
      
      final response = await query
          .order('created_at', ascending: false)
          .range(transactionOffset, transactionOffset + transactionLimit - 1);
      
      if (response != null && response.isNotEmpty) {
        // Fetch user information for all transactions
        final List<Map<String, dynamic>> transactionsWithUsers = [];
        
        for (var transaction in response) {
          final userId = transaction['created_by'];
          
          if (userId != null) {
            try {
              final userResponse = await Supabase.instance.client
                  .from('users')
                  .select('first_name, last_name')
                  .eq('user_id', userId)
                  .single();
              
              if (userResponse != null) {
                transaction['user_first_name'] = userResponse['first_name'] ?? '';
                transaction['user_last_name'] = userResponse['last_name'] ?? '';
                transaction['user_full_name'] = '${userResponse['first_name'] ?? ''} ${userResponse['last_name'] ?? ''}'.trim();
              }
            } catch (e) {
              transaction['user_full_name'] = 'Unknown User';
            }
          } else {
            transaction['user_full_name'] = 'Unknown User';
          }
          
          transactionsWithUsers.add(transaction);
        }
        
        // Update state using callback if provided, otherwise use setState
        if (updateUI != null) {
          if (loadMore) {
            allBankTransactions.addAll(transactionsWithUsers);
          } else {
            allBankTransactions = transactionsWithUsers;
          }
          transactionOffset += transactionsWithUsers.length;
          hasMoreTransactions = transactionsWithUsers.length >= transactionLimit;
          isLoadingAllTransactions = false;
          updateUI();
        } else {
          setState(() {
            if (loadMore) {
              allBankTransactions.addAll(transactionsWithUsers);
            } else {
              allBankTransactions = transactionsWithUsers;
            }
            transactionOffset += transactionsWithUsers.length;
            hasMoreTransactions = transactionsWithUsers.length >= transactionLimit;
            isLoadingAllTransactions = false;
          });
        }
      } else {
        if (updateUI != null) {
          hasMoreTransactions = false;
          isLoadingAllTransactions = false;
          updateUI();
        } else {
          setState(() {
            hasMoreTransactions = false;
            isLoadingAllTransactions = false;
          });
        }
      }
    } catch (e) {
      if (updateUI != null) {
        isLoadingAllTransactions = false;
        updateUI();
      } else {
        setState(() {
          isLoadingAllTransactions = false;
        });
      }
    }
  }
  
  // Save bank balance to database
  Future<void> _saveBankBalance() async {
    try {
      // Get app state for company_id and user_id
      final appState = ref.read(appStateProvider);
      final companyId = appState.companyChoosen;
      final userId = appState.user['user_id'];
      
      // Validation
      if (companyId.isEmpty || userId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Missing company or user information'),
            backgroundColor: TossColors.error,
          ),
        );
        return;
      }
      
      if (selectedBankLocationId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select a bank location'),
            backgroundColor: TossColors.error,
          ),
        );
        return;
      }
      
      if (selectedBankCurrencyType == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select a currency'),
            backgroundColor: TossColors.error,
          ),
        );
        return;
      }
      
      // Get current date and time
      final now = DateTime.now();
      final recordDate = DateFormat('yyyy-MM-dd').format(now);
      
      // Format created_at with microseconds like "2025-06-07 23:40:55.948829"
      final createdAt = DateFormat('yyyy-MM-dd HH:mm:ss').format(now) + 
                       '.${now.microsecond.toString().padLeft(6, '0')}';
      
      // Parse the amount (remove commas) as integer
      final amountText = bankAmountController.text.replaceAll(',', '');
      final totalAmount = int.tryParse(amountText) ?? 0;
      
      // Prepare parameters for RPC call
      final Map<String, dynamic> params = {
        'p_company_id': companyId,
        'p_store_id': selectedStoreId == 'headquarter' ? null : selectedStoreId,
        'p_record_date': recordDate,
        'p_location_id': selectedBankLocationId,
        'p_currency_id': selectedBankCurrencyType,
        'p_total_amount': totalAmount,
        'p_created_by': userId,
        'p_created_at': createdAt,
      };
      
      // Debug: Log the params
      
      // Call the RPC function
      final response = await Supabase.instance.client
          .rpc('bank_amount_insert_v2', params: params);
      
      
      // Show success message
      if (mounted) {
        HapticFeedback.mediumImpact();
        
        // Get currency symbol for display
        final currency = currencyTypes.firstWhere(
          (c) => c['currency_id'].toString() == selectedBankCurrencyType,
          orElse: () => {'symbol': '', 'currency_code': ''},
        );
        final currencySymbol = currency['symbol'] ?? '';
        
        // Show success popup
        _showBankBalanceResultDialog(
          isSuccess: true,
          amount: '$currencySymbol${bankAmountController.text}',
        );
        
        // Clear the form after successful save and refresh transactions
        setState(() {
          bankAmountController.clear();
          // Don't clear selectedBankLocationId to keep showing transactions
          
          // Check if the selected location has a fixed currency
          Map<String, dynamic>? selectedLocation;
          if (selectedBankLocationId != null) {
            try {
              selectedLocation = bankLocations.firstWhere(
                (loc) => loc['cash_location_id']?.toString() == selectedBankLocationId,
              );
            } catch (e) {
              // Location not found
            }
          }
          
          // Only clear currency if the location doesn't have a fixed currency
          final locationCurrencyId = selectedLocation?['currency_id']?.toString();
          if (locationCurrencyId == null || locationCurrencyId.isEmpty) {
            selectedBankCurrencyType = null;
          }
          // If location has fixed currency, keep it selected
        });
        
        // Refresh the transaction list
        await _fetchRecentBankTransactions();
        
        // Refresh the Real/Journal tabs data
        if (selectedBankLocationId != null && selectedBankLocationId!.isNotEmpty) {
          selectedCashLocationIdForFlow = selectedBankLocationId;
          await _fetchLocationStockFlow(selectedBankLocationId!);
        }
      }
      
    } catch (e) {
      if (mounted) {
        // Parse error message for user-friendly display
        String errorMessage = 'Failed to save bank balance';
        if (e.toString().contains('network')) {
          errorMessage = 'Network error. Please check your connection and try again.';
        } else if (e.toString().contains('duplicate')) {
          errorMessage = 'Bank balance for today already exists.';
        } else if (e.toString().contains('permission')) {
          errorMessage = 'You do not have permission to save bank balance.';
        } else {
          errorMessage = 'An unexpected error occurred. Please try again.';
        }
        
        _showBankBalanceResultDialog(
          isSuccess: false,
          errorMessage: errorMessage,
        );
      }
    }
  }
  
  // Show all transactions bottom sheet
  void _showAllTransactionsBottomSheet() {
    // Reset state before showing bottom sheet
    allBankTransactions = [];
    transactionOffset = 0;
    hasMoreTransactions = true;
    isLoadingAllTransactions = true;
    
    // Show the bottom sheet
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setBottomSheetState) {
            // Fetch data when bottom sheet is first built
            if (isLoadingAllTransactions && allBankTransactions.isEmpty) {
              Future.microtask(() {
                _fetchAllBankTransactions(
                  loadMore: false,
                  updateUI: () => setBottomSheetState(() {}),
                );
              });
            }
            
            return Container(
              height: MediaQuery.of(context).size.height * 0.8,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(TossBorderRadius.xxl),
                  topRight: Radius.circular(TossBorderRadius.xxl),
                ),
              ),
              child: Column(
                children: [
                  // Handle bar
                  Container(
                    margin: const EdgeInsets.only(top: TossSpacing.space3),
                    width: UIConstants.iconSizeHuge,
                    height: UIConstants.modalDragHandleHeight,
                    decoration: BoxDecoration(
                      color: TossColors.gray300,
                      borderRadius: BorderRadius.circular(TossBorderRadius.full),
                    ),
                  ),
                  // Header
                  Container(
                    padding: const EdgeInsets.all(TossSpacing.space5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'All Bank Transactions',
                          style: TossTextStyles.h2.copyWith(
                            fontWeight: FontWeight.w700,
                            color: TossColors.gray900,
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: Icon(TossIcons.close, color: TossColors.gray700),
                        ),
                      ],
                    ),
                  ),
                  Divider(color: TossColors.gray200, height: 1),
                  // Transaction list
                  Expanded(
                    child: isLoadingAllTransactions && allBankTransactions.isEmpty
                        ? Center(
                            child: CircularProgressIndicator(
                              color: TossColors.primary,
                              strokeWidth: 2,
                            ),
                          )
                        : allBankTransactions.isEmpty && !isLoadingAllTransactions
                            ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      TossIcons.receipt,
                                      color: TossColors.gray400,
                                      size: UIConstants.iconSizeHuge + 16, // 64px for empty state
                                    ),
                                    const SizedBox(height: TossSpacing.space4),
                                    Text(
                                      'No transactions found',
                                      style: TossTextStyles.bodyLarge.copyWith(
                                        color: TossColors.gray500,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : ListView.builder(
                                padding: const EdgeInsets.all(TossSpacing.space5),
                                itemCount: allBankTransactions.length + (hasMoreTransactions ? 1 : 0),
                                itemBuilder: (context, index) {
                                  if (index == allBankTransactions.length) {
                                    // Load more button
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(vertical: TossSpacing.space4),
                                      child: TossPrimaryButton(
                                        text: 'Load More',
                                        onPressed: isLoadingAllTransactions
                                            ? null
                                            : () async {
                                                await _fetchAllBankTransactions(
                                                  loadMore: true,
                                                  updateUI: () => setBottomSheetState(() {}),
                                                );
                                              },
                                        isLoading: isLoadingAllTransactions,
                                      ),
                                    );
                                  }
                                  
                                  final transaction = allBankTransactions[index];
                                  return _buildTransactionCard(transaction);
                                },
                              ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
  
  // Build transaction card for bottom sheet
  Widget _buildTransactionCard(Map<String, dynamic> transaction) {
    // Get location name
    final locationName = bankLocations.firstWhere(
      (loc) => loc['cash_location_id']?.toString() == transaction['location_id']?.toString() ||
               loc['location_id']?.toString() == transaction['location_id']?.toString(),
      orElse: () => {'location_name': 'Unknown'},
    )['location_name'] ?? 'Unknown';
    
    // Get currency info
    final currency = currencyTypes.firstWhere(
      (c) => c['currency_id']?.toString() == transaction['currency_id']?.toString(),
      orElse: () => {'symbol': '', 'currency_code': ''},
    );
    final currencySymbol = currency['symbol'] ?? '';
    final currencyCode = currency['currency_code'] ?? '';
    
    // Parse dates
    final createdAt = DateTime.tryParse(transaction['created_at'] ?? '');
    final recordDate = transaction['record_date'] ?? '';
    final dateStr = recordDate.isNotEmpty ? recordDate : 
                   (createdAt != null ? DateFormat('yyyy-MM-dd').format(createdAt) : 'Unknown');
    final timeStr = createdAt != null ? DateFormat('HH:mm').format(createdAt) : '';
    
    // Get user info
    final userFullName = transaction['user_full_name'] ?? 'Unknown User';
    final amount = transaction['total_amount'] ?? 0;
    
    return Container(
      margin: const EdgeInsets.only(bottom: TossSpacing.space4),
      child: TossWhiteCard(
        padding: const EdgeInsets.all(TossSpacing.space4),
        child: Column(
          children: [
            // Header row with location and amount
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(TossSpacing.space2),
                      decoration: BoxDecoration(
                        color: TossColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                      ),
                      child: Icon(
                        TossIcons.bank,
                        size: UIConstants.iconSizeXS,
                        color: TossColors.primary,
                      ),
                    ),
                    const SizedBox(width: TossSpacing.space3),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          locationName,
                          style: TossTextStyles.body.copyWith(
                            color: TossColors.gray900,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          '$dateStr $timeStr',
                          style: TossTextStyles.caption.copyWith(
                            color: TossColors.gray500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '$currencySymbol${NumberFormat('#,###').format(amount)}',
                      style: TossTextStyles.bodyLarge.copyWith(
                        color: TossColors.gray900,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'JetBrains Mono',
                      ),
                    ),
                    if (currencyCode.isNotEmpty)
                      Text(
                        currencyCode,
                        style: TossTextStyles.caption.copyWith(
                          color: TossColors.gray500,
                        ),
                      ),
                  ],
              ),
            ],
          ),
          const SizedBox(height: TossSpacing.space3),
          // Divider
          Container(
            height: 1,
            color: TossColors.gray100,
          ),
          const SizedBox(height: TossSpacing.space3),
          // Bottom row with user and record date
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    TossIcons.person,
                    size: UIConstants.textSizeRegular,
                    color: TossColors.gray400,
                  ),
                  const SizedBox(width: TossSpacing.space1),
                  Text(
                    userFullName,
                    style: TossTextStyles.caption.copyWith(
                      color: TossColors.gray600,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Icon(
                    TossIcons.calendar,
                    size: UIConstants.textSizeRegular,
                    color: TossColors.gray400,
                  ),
                  const SizedBox(width: TossSpacing.space1),
                  Text(
                    'Record: $dateStr $timeStr',
                    style: TossTextStyles.caption.copyWith(
                      color: TossColors.gray600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ),
  );
  }
  
  // Show result dialog for bank balance save
  void _showBankBalanceResultDialog({
    required bool isSuccess,
    String? amount,
    String? errorMessage,
  }) {
    showDialog(
      context: context,
      barrierDismissible: true, // Allow dismissing loading dialogs
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(TossBorderRadius.xxl),
          ),
          child: Container(
            padding: const EdgeInsets.all(TossSpacing.space6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(TossBorderRadius.xxl),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icon
                Container(
                  width: 72, // Custom size for transaction result
                  height: 72,
                  decoration: BoxDecoration(
                    color: isSuccess 
                        ? TossColors.success.withOpacity(0.1)
                        : TossColors.error.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isSuccess ? TossIcons.checkCircle : TossIcons.error,
                    color: isSuccess ? TossColors.success : TossColors.error,
                    size: UIConstants.avatarSizeSmall,
                  ),
                ),
                const SizedBox(height: TossSpacing.space5),
                
                // Title
                Text(
                  isSuccess ? 'Success!' : 'Failed',
                  style: TossTextStyles.h2.copyWith(
                    fontWeight: FontWeight.w700,
                    color: TossColors.gray900,
                  ),
                ),
                const SizedBox(height: TossSpacing.space3),
                
                // Message
                Text(
                  isSuccess 
                      ? 'Bank balance saved'
                      : errorMessage ?? 'Failed to save bank balance',
                  style: TossTextStyles.body.copyWith(
                    color: TossColors.gray600,
                  ),
                  textAlign: TextAlign.center,
                ),
                
                // Amount (for success only)
                if (isSuccess && amount != null) ...[
                  const SizedBox(height: TossSpacing.space3),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: TossSpacing.space4,
                      vertical: TossSpacing.space2,
                    ),
                    decoration: BoxDecoration(
                      color: TossColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(TossBorderRadius.md),
                    ),
                    child: Text(
                      amount,
                      style: TossTextStyles.h3.copyWith(
                        color: TossColors.primary,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'JetBrains Mono',
                      ),
                    ),
                  ),
                ],
                
                const SizedBox(height: TossSpacing.space6),
                
                // Button
                SizedBox(
                  width: double.infinity,
                  child: TossPrimaryButton(
                    text: isSuccess ? 'Done' : 'Try Again',
                    onPressed: () {
                      Navigator.of(context).pop();
                      if (!isSuccess) {
                        // Keep the form data for retry
                        HapticFeedback.lightImpact();
                      }
                    },
                    isLoading: false,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  
  // Build currency selector for bank tab
  Widget _buildBankCurrencySelector() {
    // For bank tab, ALWAYS show fixed currency (no selection allowed)
    // Get the selected bank location to find its currency
    Map<String, dynamic>? selectedBankLocation;
    if (selectedBankLocationId != null) {
      try {
        selectedBankLocation = bankLocations.firstWhere(
          (loc) => loc['cash_location_id']?.toString() == selectedBankLocationId,
        );
      } catch (e) {
        // Location not found
      }
    }
    
    // Get the currency from the location
    final locationCurrencyId = selectedBankLocation?['currency_id']?.toString();
    
    // If no currency is set for this location, show a message
    if (locationCurrencyId == null || locationCurrencyId.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Currency',
                style: TossTextStyles.label.copyWith(
                  color: TossColors.gray700,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(width: TossSpacing.space2),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: TossSpacing.space2,
                  vertical: TossSpacing.space1,
                ),
                decoration: BoxDecoration(
                  color: TossColors.error.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                ),
                child: Text(
                  'Not configured',
                  style: TossTextStyles.caption.copyWith(
                    color: TossColors.error,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: TossSpacing.space3),
          Container(
            padding: const EdgeInsets.all(TossSpacing.space4),
            decoration: BoxDecoration(
              color: TossColors.gray50,
              borderRadius: BorderRadius.circular(TossBorderRadius.lg),
              border: Border.all(color: TossColors.gray200),
            ),
            child: Row(
              children: [
                Icon(
                  TossIcons.info,
                  size: UIConstants.iconSizeSmall,
                  color: TossColors.gray500,
                ),
                const SizedBox(width: TossSpacing.space3),
                Expanded(
                  child: Text(
                    'This bank location has no currency configured. Please contact your administrator.',
                    style: TossTextStyles.caption.copyWith(
                      color: TossColors.gray600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }
    
    // Find the fixed currency details from companyCurrencies
    // First check if we have this currency in companyCurrencies
    final fixedCurrency = companyCurrencies.firstWhere(
      (c) => c['currency_id']?.toString() == locationCurrencyId,
      orElse: () => {
        // If not in companyCurrencies, fall back to currencyTypes
        ...currencyTypes.firstWhere(
          (c) => c['currency_id']?.toString() == locationCurrencyId,
          orElse: () => {'currency_name': 'Unknown', 'currency_code': '', 'symbol': ''},
        )
      },
    );
    final currencyName = fixedCurrency['currency_name'] ?? 'Unknown';
    final currencyCode = fixedCurrency['currency_code'] ?? '';
    final currencySymbol = fixedCurrency['symbol'] ?? '';
    
    // Always show the bank location's currency as fixed (non-selectable)
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Currency',
              style: TossTextStyles.label.copyWith(
                color: TossColors.gray700,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(width: TossSpacing.space2),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: TossSpacing.space2,
                vertical: TossSpacing.space1,
              ),
              decoration: BoxDecoration(
                color: TossColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(TossBorderRadius.sm),
              ),
              child: Text(
                'Fixed by location',
                style: TossTextStyles.caption.copyWith(
                  color: TossColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: TossSpacing.space3),
        // Show only the fixed currency as a non-clickable selected chip
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: TossSpacing.space4,
                vertical: TossSpacing.space3,
              ),
              decoration: BoxDecoration(
                color: TossColors.primary,
                borderRadius: BorderRadius.circular(TossBorderRadius.full),
                border: Border.all(
                  color: TossColors.primary,
                  width: 1.5,
                ),
                boxShadow: TossShadows.elevation2,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (currencySymbol.isNotEmpty) ...[
                    Text(
                      currencySymbol,
                      style: TossTextStyles.h3.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(width: TossSpacing.space2),
                  ],
                  Text(
                    currencyName,
                    style: TossTextStyles.body.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (currencyCode.isNotEmpty) ...[
                    const SizedBox(width: TossSpacing.space2),
                    Text(
                      '($currencyCode)',
                      style: TossTextStyles.caption.copyWith(
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
  
  // Build bank transaction history with real data
  Widget _buildBankTransactionHistory() {
    if (isLoadingBankTransactions) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(TossSpacing.space8),
          child: CircularProgressIndicator(
            color: TossColors.primary,
            strokeWidth: 2,
          ),
        ),
      );
    }
    
    if (recentBankTransactions.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(TossSpacing.space6),
        decoration: BoxDecoration(
          color: TossColors.gray50,
          borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        ),
        child: Center(
          child: Column(
            children: [
              Icon(
                TossIcons.receipt,
                color: TossColors.gray400,
                size: UIConstants.iconSizeHuge,
              ),
              const SizedBox(height: TossSpacing.space3),
              Text(
                'No transactions yet',
                style: TossTextStyles.body.copyWith(
                  color: TossColors.gray500,
                ),
              ),
            ],
          ),
        ),
      );
    }
    
    return Column(
      children: recentBankTransactions.map((transaction) {
        // Get location name
        final locationName = bankLocations.firstWhere(
          (loc) => loc['cash_location_id']?.toString() == transaction['location_id']?.toString() ||
                   loc['location_id']?.toString() == transaction['location_id']?.toString(),
          orElse: () => {'location_name': 'Unknown'},
        )['location_name'] ?? 'Unknown';
        
        // Get currency info
        final currency = currencyTypes.firstWhere(
          (c) => c['currency_id']?.toString() == transaction['currency_id']?.toString(),
          orElse: () => {'symbol': '', 'currency_code': ''},
        );
        final currencySymbol = currency['symbol'] ?? '';
        final currencyCode = currency['currency_code'] ?? '';
        
        // Parse dates
        final createdAt = DateTime.tryParse(transaction['created_at'] ?? '');
        final recordDate = transaction['record_date'] ?? '';
        final dateStr = recordDate.isNotEmpty ? recordDate : 
                       (createdAt != null ? DateFormat('yyyy.MM.dd').format(createdAt) : 'Unknown');
        final timeStr = createdAt != null ? DateFormat('HH:mm').format(createdAt) : '';
        
        // Get user info
        final userFullName = transaction['user_full_name'] ?? 'Unknown User';
        final amount = transaction['total_amount'] ?? 0;
        
        return Container(
          margin: const EdgeInsets.only(bottom: TossSpacing.space4),
          child: TossWhiteCard(
            padding: const EdgeInsets.all(TossSpacing.space4),
            child: Column(
              children: [
              // Header row with location and amount
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(TossSpacing.space2),
                        decoration: BoxDecoration(
                          color: TossColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                        ),
                        child: Icon(
                          TossIcons.bank,
                          size: UIConstants.iconSizeXS,
                          color: TossColors.primary,
                        ),
                      ),
                      const SizedBox(width: TossSpacing.space3),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            locationName,
                            style: TossTextStyles.body.copyWith(
                              color: TossColors.gray900,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            '$dateStr $timeStr',
                            style: TossTextStyles.caption.copyWith(
                              color: TossColors.gray500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '$currencySymbol${NumberFormat('#,###').format(amount)}',
                        style: TossTextStyles.bodyLarge.copyWith(
                          color: TossColors.gray900,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'JetBrains Mono',
                        ),
                      ),
                      if (currencyCode.isNotEmpty)
                        Text(
                          currencyCode,
                          style: TossTextStyles.caption.copyWith(
                            color: TossColors.gray500,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: TossSpacing.space3),
              // Divider
              Container(
                height: UIConstants.borderWidth,
                color: TossColors.gray100,
              ),
              const SizedBox(height: TossSpacing.space3),
              // Bottom row with user and record date
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        TossIcons.person,
                        size: UIConstants.textSizeRegular,
                        color: TossColors.gray400,
                      ),
                      const SizedBox(width: TossSpacing.space1),
                      Text(
                        userFullName,
                        style: TossTextStyles.caption.copyWith(
                          color: TossColors.gray600,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(
                        TossIcons.calendar,
                        size: UIConstants.textSizeRegular,
                        color: TossColors.gray400,
                      ),
                      const SizedBox(width: TossSpacing.space1),
                      Text(
                        'Record: $dateStr $timeStr',
                        style: TossTextStyles.caption.copyWith(
                          color: TossColors.gray600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      );
      }).toList(),
    );
  }
  
  Widget _buildVaultTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(TossSpacing.paddingMD),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Input Section - wrapped in white card
          TossCard(
            padding: const EdgeInsets.all(TossSpacing.space5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildStoreSelector(),
                if (selectedStoreId != null) ...[
                  const SizedBox(height: TossSpacing.space6),
                  _buildLocationSelector('vault'),
                ],
                if (selectedVaultLocationId != null) ...[
                  const SizedBox(height: TossSpacing.space8),
                  _buildDenominationSection(tabType: 'vault'),
                  const SizedBox(height: TossSpacing.space8),
                  _buildDebitCreditToggle(),
                  const SizedBox(height: TossSpacing.space8),
                  _buildTotalSection(tabType: 'vault'),
                  const SizedBox(height: TossSpacing.space10),
                  _buildSubmitButton(),
                ],
              ],
            ),
          ),
          // Real/Journal Section for vault locations
          const SizedBox(height: TossSpacing.space5),
          _buildRealJournalSection(
            showSection: selectedVaultLocationId != null && selectedVaultLocationId!.isNotEmpty,
          ),
        ],
      ),
    );
  }
  
  String _calculateSubtotal(String denomination, String quantity, String currencySymbol) {
    final denom = int.tryParse(denomination) ?? 0;
    final qty = int.tryParse(quantity) ?? 0;
    final subtotal = denom * qty;
    return '$currencySymbol${NumberFormat('#,###').format(subtotal)}';
  }
  
  String _calculateTotal({String tabType = 'cash'}) {
    // Get selected currency ID based on tab
    final String? selectedCurrencyId;
    if (tabType == 'cash') {
      selectedCurrencyId = selectedCashCurrencyId;
    } else if (tabType == 'bank') {
      selectedCurrencyId = selectedBankCurrencyId;
    } else {
      selectedCurrencyId = selectedVaultCurrencyId;
    }
    
    if (selectedCurrencyId == null || !denominationControllers.containsKey(selectedCurrencyId)) {
      return '0';
    }
    
    // Get currency info from companyCurrencies (already has all details)
    final currencyInfo = companyCurrencies.firstWhere(
      (c) => c['currency_id'].toString() == selectedCurrencyId,
      orElse: () => {'symbol': ''},
    );
    
    int total = 0;
    final controllers = denominationControllers[selectedCurrencyId] ?? {};
    final denominations = currencyDenominations[selectedCurrencyId] ?? [];
    
    for (var denom in denominations) {
      final denomValue = denom['value'].toString();
      final controller = controllers[denomValue];
      if (controller != null) {
        final value = ((denom['value'] ?? 0) as num).toInt();
        final qty = int.tryParse(controller.text) ?? 0;
        total += value * qty;
      }
    }
    
    final currencySymbol = currencyInfo['symbol'] ?? '';
    return '$currencySymbol${NumberFormat('#,###').format(total)}';
  }
  
  int _calculateTotalAmount({String tabType = 'cash'}) {
    // Get selected currency ID based on tab
    final String? selectedCurrencyId;
    if (tabType == 'cash') {
      selectedCurrencyId = selectedCashCurrencyId;
    } else if (tabType == 'bank') {
      selectedCurrencyId = selectedBankCurrencyId;
    } else {
      selectedCurrencyId = selectedVaultCurrencyId;
    }
    
    if (selectedCurrencyId == null || !denominationControllers.containsKey(selectedCurrencyId)) {
      return 0;
    }
    
    int total = 0;
    final controllers = denominationControllers[selectedCurrencyId] ?? {};
    final denominations = currencyDenominations[selectedCurrencyId] ?? [];
    
    for (var denom in denominations) {
      final denomValue = denom['value'].toString();
      final controller = controllers[denomValue];
      if (controller != null) {
        final value = ((denom['value'] ?? 0) as num).toInt();
        final qty = int.tryParse(controller.text) ?? 0;
        total += value * qty;
      }
    }
    
    return total;
  }
  
  Future<void> _saveVaultBalance() async {
    try {
      // Get app state for company_id and user_id
      final appState = ref.read(appStateProvider);
      final companyId = appState.companyChoosen;
      final userId = appState.user['user_id'];
      
      if (companyId.isEmpty || userId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Missing company or user information')),
        );
        return;
      }
      
      if (selectedVaultLocationId == null || selectedVaultCurrencyId == null || vaultTransactionType == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select location, currency, and transaction type')),
        );
        return;
      }
      
      // Get current date and time
      final now = DateTime.now();
      final recordDate = DateFormat('yyyy-MM-dd').format(now);
      final createdAt = DateFormat('yyyy-MM-dd HH:mm:ss.SSSSSS').format(now);
      
      // Build vault_amount_line_json with denomination details
      List<Map<String, dynamic>> vaultAmountLineJson = [];
      
      if (denominationControllers.containsKey(selectedVaultCurrencyId)) {
        final controllers = denominationControllers[selectedVaultCurrencyId]!;
        final denominations = currencyDenominations[selectedVaultCurrencyId] ?? [];
        
        for (var denom in denominations) {
          final denomId = denom['denomination_id']?.toString() ?? denom['id']?.toString() ?? '';
          final denomValue = denom['value'].toString();
          final controller = controllers[denomValue];
          
          if (controller != null && controller.text.isNotEmpty) {
            final quantity = int.tryParse(controller.text) ?? 0;
            if (quantity > 0) {
              vaultAmountLineJson.add({
                'quantity': quantity.toString(),
                'denomination_id': denomId,
                'denomination_value': denomValue,
                'denomination_type': denom['denomination_type'] ?? 'BILL',
              });
            }
          }
        }
      }
      
      // Prepare RPC parameters
      final params = {
        'p_location_id': selectedVaultLocationId,
        'p_company_id': companyId,
        'p_created_at': createdAt,
        'p_created_by': userId,
        'p_credit': vaultTransactionType == 'credit',
        'p_debit': vaultTransactionType == 'debit',
        'p_currency_id': selectedVaultCurrencyId,
        'p_record_date': recordDate,
        'p_store_id': selectedStoreId,
        'p_vault_amount_line_json': vaultAmountLineJson,
      };
      
      
      // Call the RPC function
      final response = await Supabase.instance.client
          .rpc('vault_amount_insert', params: params);
      
      
      // Show success message
      if (mounted) {
        // Calculate the total before clearing the form
        final savedTotal = _calculateTotalAmount(tabType: 'vault').toDouble();
        
        _showSuccessBottomSheet(savedTotal);
        
        // Clear the form after success
        if (denominationControllers.containsKey(selectedVaultCurrencyId)) {
          denominationControllers[selectedVaultCurrencyId]!.forEach((key, controller) {
            controller.clear();
          });
        }
        
        // Reset the selected transaction type
        setState(() {
          vaultTransactionType = null;
        });
        
        // Refresh vault balance
        _fetchVaultBalance();
        
        // Refresh the Real/Journal tabs data for Vault tab
        if (selectedVaultLocationId != null && selectedVaultLocationId!.isNotEmpty) {
          selectedCashLocationIdForFlow = selectedVaultLocationId;
          _fetchLocationStockFlow(selectedVaultLocationId!);
        }
      }
      
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving vault balance: ${e.toString()}')),
        );
      }
    }
  }
  
  Future<void> _saveCashEnding() async {
    try {
      // Get app state for company_id and user_id
      final appState = ref.read(appStateProvider);
      final companyId = appState.companyChoosen;
      final userId = appState.user['user_id'];
      
      if (companyId.isEmpty || userId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Missing company or user information')),
        );
        return;
      }
      
      // Get current date and time
      final now = DateTime.now();
      final recordDate = DateFormat('yyyy-MM-dd').format(now);
      final createdAt = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
      
      // Determine which tab's data to save
      String? locationId;
      if (_tabController.index == 0) {
        locationId = selectedLocationId;
      } else if (_tabController.index == 1) {
        locationId = selectedBankLocationId;
      } else if (_tabController.index == 2) {
        locationId = selectedVaultLocationId;
      }
      
      if (locationId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a location')),
        );
        return;
      }
      
      // Build currencies JSON structure
      List<Map<String, dynamic>> currencies = [];
      
      // Determine which currency ID to use based on the current tab
      String? currentCurrencyId;
      if (_tabController.index == 0) {
        currentCurrencyId = selectedCashCurrencyId;
      } else if (_tabController.index == 1) {
        currentCurrencyId = selectedBankCurrencyId;
      } else if (_tabController.index == 2) {
        currentCurrencyId = selectedVaultCurrencyId;
      }
      
      if (currentCurrencyId != null) {
        List<Map<String, dynamic>> denominationsList = [];
        
        // Get the controllers for the selected currency
        final controllers = denominationControllers[currentCurrencyId] ?? {};
        
        // Get denominations for the current currency
        final denominationsForCurrency = currencyDenominations[currentCurrencyId] ?? [];
        
        // Iterate through denominations and add ONLY those with quantity > 0
        // Users can enter just one denomination or multiple - it's flexible
        for (var denomination in denominationsForCurrency) {
          final denominationId = denomination['denomination_id']?.toString();
          final denominationValue = denomination['value']?.toString(); // Controllers are keyed by value
          
          // Controllers are keyed by the denomination value, not the ID
          if (denominationValue != null && controllers.containsKey(denominationValue)) {
            final controller = controllers[denominationValue];
            final quantityText = controller?.text.trim() ?? '';
            
            // Only add if user actually entered a value
            if (quantityText.isNotEmpty && quantityText != '0') {
              final quantity = int.tryParse(quantityText) ?? 0;
              if (quantity > 0) {
                denominationsList.add({
                  'denomination_id': denominationId,
                  'quantity': quantity,
                });
              }
            }
          }
        }
        
        // Only require at least one denomination to be entered
        if (denominationsList.isNotEmpty) {
          currencies.add({
            'currency_id': currentCurrencyId,
            'denominations': denominationsList,
          });
        }
      }
      
      // Check if at least one denomination was entered
      if (currencies.isEmpty || 
          (currencies.isNotEmpty && currencies[0]['denominations'].isEmpty)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter at least one denomination quantity')),
        );
        return;
      }
      
      // Prepare parameters for RPC call
      final Map<String, dynamic> params = {
        'p_company_id': companyId,
        'p_location_id': locationId,
        'p_record_date': recordDate,
        'p_created_by': userId,
        'p_currencies': currencies,
        'p_created_at': createdAt,
        // Always include p_store_id, set to null for Headquarter
        'p_store_id': (selectedStoreId == 'headquarter') ? null : selectedStoreId,
      };
      
      // Debug: Log the params to see what's being sent
      
      // Call the RPC function
      final response = await Supabase.instance.client
          .rpc('insert_cashier_amount_lines', params: params);
      
      
      // RPC returns null on success, so we don't check the response
      // Show success message
      if (mounted) {
        // Calculate the total BEFORE clearing the form
        final savedTotal = _calculateTotalAmount().toDouble();
        
        _showSuccessBottomSheet(savedTotal);
        
        // Refresh the Real/Journal tabs data for Cash tab
        if (_tabController.index == 0 && selectedLocationId != null && selectedLocationId!.isNotEmpty) {
          selectedCashLocationIdForFlow = selectedLocationId;
          await _fetchLocationStockFlow(selectedLocationId!);
          // Also reload recent cash endings
          await _loadRecentCashEndings(selectedLocationId!);
        }
        
        // Clear the form after success
        denominationControllers.forEach((currencyId, controllers) {
          controllers.forEach((denominationId, controller) {
            controller.clear();
          });
        });
        
        // Optionally reset the selected location
        setState(() {
          if (_tabController.index == 0) {
            selectedLocationId = null;
          } else if (_tabController.index == 1) {
            selectedBankLocationId = null;
          } else if (_tabController.index == 2) {
            selectedVaultLocationId = null;
          }
        });
      }
      
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving cash ending: ${e.toString()}')),
        );
      }
    }
  }
  
  void _showSuccessBottomSheet(double savedTotal) {
    // Get the currency symbol from the selected currency
    String currencySymbol = '₫';
    if (_tabController.index == 0 && selectedCashCurrencyId != null) {
      final currency = companyCurrencies.firstWhere(
        (c) => c['currency_id'].toString() == selectedCashCurrencyId,
        orElse: () => {'symbol': '₫'},
      );
      currencySymbol = currency['symbol'] ?? '₫';
    } else if (_tabController.index == 1 && selectedBankCurrencyType != null) {
      final currency = companyCurrencies.firstWhere(
        (c) => c['currency_id'].toString() == selectedBankCurrencyType,
        orElse: () => {'symbol': '₫'},
      );
      currencySymbol = currency['symbol'] ?? '₫';
    } else if (_tabController.index == 2 && selectedVaultCurrencyId != null) {
      final currency = companyCurrencies.firstWhere(
        (c) => c['currency_id'].toString() == selectedVaultCurrencyId,
        orElse: () => {'symbol': '₫'},
      );
      currencySymbol = currency['symbol'] ?? '₫';
    }
    
    // Format the total amount with currency
    final formattedTotal = NumberFormat.currency(
      symbol: currencySymbol,
      decimalDigits: 0,
    ).format(savedTotal);
    
    // Show dialog in center of screen instead of bottom sheet
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(TossBorderRadius.xxl),
        ),
        child: Container(
          padding: const EdgeInsets.all(TossSpacing.space6),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(TossBorderRadius.xxl),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: UIConstants.iconSizeHuge + 16, // 64px for success state
                height: UIConstants.iconSizeHuge + 16,
                decoration: BoxDecoration(
                  color: TossColors.success.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  TossIcons.check,
                  color: TossColors.success,
                  size: UIConstants.iconSizeXL,
                ),
              ),
              const SizedBox(height: TossSpacing.space4),
              Text(
                'Cash Ending Saved',
                style: TossTextStyles.h3.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: TossSpacing.space2),
              Text(
                formattedTotal,
                style: TossTextStyles.h2.copyWith(
                  color: TossColors.primary,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'JetBrains Mono',
                ),
              ),
              const SizedBox(height: TossSpacing.space6),
              SizedBox(
                width: double.infinity,
                child: TossPrimaryButton(
                  text: 'Done',
                  onPressed: () {
                    Navigator.pop(context);
                    // Reset form only for cash tab
                    if (_tabController.index == 0) {
                      setState(() {
                        selectedLocationId = null;
                        if (selectedCashCurrencyId != null && denominationControllers.containsKey(selectedCashCurrencyId)) {
                          denominationControllers[selectedCashCurrencyId]!.forEach((key, controller) {
                            controller.clear();
                          });
                        }
                      });
                    }
                  },
                  isLoading: false,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  
  // Show store selector bottom sheet
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
              width: UIConstants.modalDragHandleWidth,
              height: UIConstants.modalDragHandleHeight,
              decoration: BoxDecoration(
                color: TossColors.gray600,
                borderRadius: BorderRadius.circular(100),
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
            // Store list
            Container(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.5,
              ),
              child: ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                itemCount: stores.length + 1, // +1 for Headquarter
                itemBuilder: (context, index) {
                  // First item is Headquarter
                  if (index == 0) {
                    final isSelected = selectedStoreId == 'headquarter';
                    return InkWell(
                      onTap: () async {
                        HapticFeedback.selectionClick();
                        Navigator.pop(context);
                        
                        setState(() {
                          selectedStoreId = 'headquarter';
                          selectedLocationId = null; // Reset location when store changes
                        });
                        
                        // Fetch cash locations for headquarter
                        await _fetchLocations('cash');
                        await _fetchLocations('bank');
                        await _fetchLocations('vault');
                        
                        // Refresh data
                        _refreshData();
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: TossSpacing.space5,
                          vertical: TossSpacing.space4,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected ? TossColors.gray50 : Colors.transparent,
                          border: const Border(
                            bottom: BorderSide(
                              color: TossColors.gray100,
                              width: 0.5,
                            ),
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: isSelected ? TossColors.primary.withOpacity(0.1) : TossColors.gray50,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(
                                TossIcons.business,
                                size: 20,
                                color: isSelected ? TossColors.primary : TossColors.gray500,
                              ),
                            ),
                            const SizedBox(width: TossSpacing.space3),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Headquarter',
                                    style: TossTextStyles.body.copyWith(
                                      color: TossColors.gray900,
                                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    'Company Level',
                                    style: TossTextStyles.caption.copyWith(
                                      color: TossColors.gray500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (isSelected)
                              Container(
                                padding: const EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  color: TossColors.primary,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  TossIcons.check,
                                  size: 16,
                                  color: Colors.white,
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  }
                  
                  // Regular stores (adjust index by -1)
                  final store = stores[index - 1];
                  final isSelected = store['store_id'] == selectedStoreId;
                  
                  return InkWell(
                    onTap: () async {
                      HapticFeedback.selectionClick();
                      Navigator.pop(context);
                      
                      setState(() {
                        selectedStoreId = store['store_id'];
                        selectedLocationId = null; // Reset location when store changes
                      });
                      
                      // Update app state with the new store selection
                      await ref.read(appStateProvider.notifier).setStoreChoosen(store['store_id']);
                      
                      // Fetch locations for the new store
                      await _fetchLocations('cash');
                      await _fetchLocations('bank');
                      await _fetchLocations('vault');
                      
                      // Refresh data for the new store
                      _refreshData();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: TossSpacing.space5,
                        vertical: TossSpacing.space4,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected ? TossColors.gray50 : Colors.transparent,
                        border: Border(
                          bottom: BorderSide(
                            color: TossColors.gray100,
                            width: index == stores.length ? 0 : 0.5, // Adjusted for +1 Headquarter
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: isSelected ? TossColors.primary.withOpacity(0.1) : TossColors.gray50,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              TossIcons.store,
                              size: 20,
                              color: isSelected ? TossColors.primary : TossColors.gray500,
                            ),
                          ),
                          const SizedBox(width: TossSpacing.space3),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  store['store_name'] ?? 'Unknown Store',
                                  style: TossTextStyles.body.copyWith(
                                    color: TossColors.gray900,
                                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                  ),
                                ),
                                if (store['store_code'] != null)
                                  Text(
                                    'Code: ${store['store_code']}',
                                    style: TossTextStyles.caption.copyWith(
                                      color: TossColors.gray500,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          if (isSelected)
                            Container(
                              width: 24,
                              height: 24,
                              decoration: const BoxDecoration(
                                color: TossColors.primary,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                TossIcons.check,
                                size: UIConstants.iconSizeXS,
                                color: Colors.white,
                              ),
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
  
  // Helper method to format currency
  String formatCurrency(double amount) {
    final defaultCurrency = getDefaultCurrency();
    final currencySymbol = defaultCurrency['symbol'] ?? '₩';
    final currencyCode = defaultCurrency['currency_code'] ?? 'KRW';
    
    // Use different locale based on currency
    String locale = 'ko_KR'; // Default for KRW
    if (currencyCode == 'USD') locale = 'en_US';
    else if (currencyCode == 'EUR') locale = 'de_DE';
    else if (currencyCode == 'VND') locale = 'vi_VN';
    
    final format = NumberFormat.currency(
      locale: locale,
      symbol: currencySymbol,
      decimalDigits: currencyCode == 'VND' || currencyCode == 'KRW' ? 0 : 2,
    );
    
    return format.format(amount);
  }
  
  void _refreshData() {
    // Refresh cash ending data for the selected store
    // This would typically call a Supabase function
  }
  
  Future<void> _loadRecentCashEndings(String locationId) async {
    try {
      setState(() {
        isLoadingRecentEndings = true;
      });
      
      final appState = ref.read(appStateProvider);
      final companyId = appState.companyChoosen;
      
      
      if (companyId.isEmpty || selectedStoreId == null || locationId.isEmpty) {
        setState(() {
          recentCashEndings = [];
          isLoadingRecentEndings = false;
        });
        return;
      }
      
      // Query cashier_amount_lines table - get all rows for this location
      // We need to group them by record_date and created_at to get the most recent transaction
      
      // First, let's try a simpler query to see if we get any data at all
      final testResponse = await Supabase.instance.client
          .from('cashier_amount_lines')
          .select('*')
          .eq('location_id', locationId);
      
      if (testResponse != null && testResponse.isNotEmpty) {
      }
      
      // Build the query based on whether it's headquarter or a regular store
      var query = Supabase.instance.client
          .from('cashier_amount_lines')
          .select('currency_id, record_date, denomination_id, quantity, created_at, created_by, company_id, store_id, location_id')
          .eq('company_id', companyId)
          .eq('location_id', locationId);
      
      // For headquarter, store_id should be null in the database
      if (selectedStoreId == 'headquarter') {
        query = query.isFilter('store_id', null);
      } else {
        query = query.eq('store_id', selectedStoreId!);
      }
      
      final response = await query.order('created_at', ascending: false);
      
      if (response != null && response.isNotEmpty) {
      }
      
      if (response != null && response.isNotEmpty) {
        // Group by created_at to get the most recent transaction
        // All rows with the same created_at belong to the same cash ending
        final latestCreatedAt = response[0]['created_at'];
        final latestRecordDate = response[0]['record_date'];
        final createdBy = response[0]['created_by'];
        
        // Filter all rows that belong to this transaction
        final transactionRows = response.where((row) => 
          row['created_at'] == latestCreatedAt
        ).toList();
        
        
        // Get user's full name from users table
        String fullName = 'Unknown User';
        if (createdBy != null) {
          final userResponse = await Supabase.instance.client
              .from('users')
              .select('first_name, last_name')
              .eq('user_id', createdBy)
              .single();
          
          if (userResponse != null) {
            final firstName = userResponse['first_name'] ?? '';
            final lastName = userResponse['last_name'] ?? '';
            fullName = '$firstName $lastName'.trim();
          }
        }
        
        // Group transaction rows by currency_id
        Map<String, List<Map<String, dynamic>>> transactionByCurrency = {};
        for (var row in transactionRows) {
          final currencyId = row['currency_id'];
          if (!transactionByCurrency.containsKey(currencyId)) {
            transactionByCurrency[currencyId] = [];
          }
          transactionByCurrency[currencyId]!.add({
            'denomination_id': row['denomination_id'],
            'quantity': row['quantity'],
          });
        }
        
        // Load currency and denomination data for all currencies in the transaction
        Map<String, List<Map<String, dynamic>>> denominationData = {};
        Map<String, Map<String, dynamic>> currencyData = {};
        
        for (var currencyId in transactionByCurrency.keys) {
          // Fetch denominations for this currency
          final denomResponse = await Supabase.instance.client
              .from('currency_denominations')
              .select('*')
              .eq('currency_id', currencyId)
              .order('value', ascending: false);
          
          if (denomResponse != null) {
            denominationData[currencyId] = List<Map<String, dynamic>>.from(denomResponse);
          }
          
          // Get currency info from currencyTypes table data (loaded when page loads)
          
          // Find the currency in currencyTypes by matching currency_id
          final currencyInfo = currencyTypes.firstWhere(
            (c) => c['currency_id'] == currencyId,
            orElse: () {
              // Fallback to companyCurrencies if not found in currencyTypes
              return companyCurrencies.firstWhere(
                (c) => c['currency_id'] == currencyId,
                orElse: () => {
                  'currency_id': currencyId,
                  'symbol': '\$',  // Only use default if not found anywhere
                  'currency_code': 'USD'
                },
              );
            },
          );
          
          
          if (currencyInfo.isNotEmpty) {
            currencyData[currencyId] = currencyInfo;
          }
        }
        
        // Build the currencies array in the format expected by the display widget
        List<Map<String, dynamic>> currencies = [];
        for (var entry in transactionByCurrency.entries) {
          currencies.add({
            'currency_id': entry.key,
            'denominations': entry.value,
          });
        }
        
        setState(() {
          recentCashEndings = [{
            'created_at': latestCreatedAt,
            'record_date': latestRecordDate,
            'created_by': createdBy,
            'user_full_name': fullName,
            'parsed_currencies': currencies,
            'denomination_data': denominationData,
            'currency_data': currencyData,
            'transaction_rows': transactionRows, // Store raw rows for debugging
          }];
          isLoadingRecentEndings = false;
        });
        
        for (var currency in currencies) {
        }
      } else {
        setState(() {
          recentCashEndings = [];
          isLoadingRecentEndings = false;
        });
      }
    } catch (e) {
      setState(() {
        recentCashEndings = [];
        isLoadingRecentEndings = false;
      });
    }
  }
  
  Future<void> _fetchLocationStockFlow(String locationId, {bool isLoadMore = false}) async {
    if (!isLoadMore) {
      setState(() {
        isLoadingFlows = true;
        journalFlows = [];
        actualFlows = [];
        flowsOffset = 0;
        hasMoreFlows = false;
      });
    }
    
    try {
      final appState = ref.read(appStateProvider);
      final companyId = appState.companyChoosen;
      final storeId = selectedStoreId;
      
      if (companyId.isEmpty || storeId == null || locationId.isEmpty) {
        setState(() {
          isLoadingFlows = false;
        });
        return;
      }
      
      final service = ref.read(stockFlowServiceProvider);
      final response = await service.getLocationStockFlow(
        StockFlowParams(
          companyId: companyId,
          storeId: storeId,
          cashLocationId: locationId,
          offset: isLoadMore ? flowsOffset : 0,
          limit: flowsLimit,
        ),
      );
      
      if (response.success && response.data != null) {
        setState(() {
          if (isLoadMore) {
            journalFlows.addAll(response.data!.journalFlows);
            actualFlows.addAll(response.data!.actualFlows);
          } else {
            journalFlows = response.data!.journalFlows;
            actualFlows = response.data!.actualFlows;
            locationSummary = response.data!.locationSummary;
          }
          
          if (response.pagination != null) {
            hasMoreFlows = response.pagination!.hasMore;
            flowsOffset = response.pagination!.offset + flowsLimit;
          }
          
          isLoadingFlows = false;
        });
      } else {
        setState(() {
          isLoadingFlows = false;
        });
      }
    } catch (e) {
      print('Error fetching stock flow: $e');
      setState(() {
        isLoadingFlows = false;
      });
    }
  }
  
  String _formatCurrency(double amount, [String? currencySymbol]) {
    final formatter = NumberFormat('#,###', 'en_US');
    final symbol = currencySymbol ?? '';
    return '$symbol${formatter.format(amount.abs().round())}';
  }
  
  String _formatTransactionAmount(double amount, [String? currencySymbol]) {
    final formatter = NumberFormat('#,###', 'en_US');
    final symbol = currencySymbol ?? '';
    final isIncome = amount > 0;
    final prefix = isIncome ? '+$symbol' : '-$symbol';
    return '$prefix${formatter.format(amount.abs().round())}';
  }
  
  String _formatBalance(double amount, [String? currencySymbol]) {
    final formatter = NumberFormat('#,###', 'en_US');
    final symbol = currencySymbol ?? '';
    return '$symbol${formatter.format(amount.round())}';
  }
  
  void _showFilterBottomSheet() {
    // Different filters based on tab
    List<String> filterOptions;
    if (_journalTabController.index == 1) {
      // Journal tab filters
      filterOptions = ['All', 'Money In', 'Money Out', 'Today', 'Yesterday', 'Last Week'];
    } else {
      // Real tab filters
      filterOptions = ['All', 'Today', 'Yesterday', 'Last Week', 'Last Month'];
    }
    
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar
              Container(
                margin: EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              
              // Header
              Padding(
                padding: EdgeInsets.fromLTRB(24, 20, 20, 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Filter',
                      style: TossTextStyles.h2.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close, size: 24),
                      onPressed: () => Navigator.pop(context),
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints(),
                    ),
                  ],
                ),
              ),
              
              // Filter options
              ...filterOptions.map((option) => 
                _buildFilterOption(option, selectedFilter == option)
              ),
              
              // Bottom safe area
              SizedBox(height: MediaQuery.of(context).padding.bottom + 20),
            ],
          ),
        );
      },
    );
  }
  
  Widget _buildFilterOption(String title, bool isSelected) {
    return InkWell(
      onTap: () {
        setState(() {
          selectedFilter = title;
        });
        Navigator.pop(context);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TossTextStyles.body.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check,
                color: TossColors.primary,
                size: 28,
                weight: 900,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildRealTabContent() {
    if (isLoadingFlows) {
      return Center(
        child: CircularProgressIndicator(
          color: TossColors.primary,
          strokeWidth: 2,
        ),
      );
    }
    
    if (actualFlows.isEmpty) {
      return Container(
        padding: EdgeInsets.all(TossSpacing.space5),
        child: Center(
          child: Text(
            'No real data available',
            style: TossTextStyles.body.copyWith(
              color: Colors.grey[500],
            ),
          ),
        ),
      );
    }
    
    // Apply filters
    var filteredFlows = List<ActualFlow>.from(actualFlows);
    
    if (selectedFilter == 'Today') {
      final today = DateTime.now();
      filteredFlows = filteredFlows.where((f) {
        try {
          final date = DateTime.parse(f.createdAt);
          return date.year == today.year && date.month == today.month && date.day == today.day;
        } catch (e) {
          return false;
        }
      }).toList();
    } else if (selectedFilter == 'Yesterday') {
      final yesterday = DateTime.now().subtract(Duration(days: 1));
      filteredFlows = filteredFlows.where((f) {
        try {
          final date = DateTime.parse(f.createdAt);
          return date.year == yesterday.year && date.month == yesterday.month && date.day == yesterday.day;
        } catch (e) {
          return false;
        }
      }).toList();
    } else if (selectedFilter == 'Last Week') {
      final lastWeek = DateTime.now().subtract(Duration(days: 7));
      filteredFlows = filteredFlows.where((f) {
        try {
          final date = DateTime.parse(f.createdAt);
          return date.isAfter(lastWeek);
        } catch (e) {
          return false;
        }
      }).toList();
    } else if (selectedFilter == 'Last Month') {
      final lastMonth = DateTime.now().subtract(Duration(days: 30));
      filteredFlows = filteredFlows.where((f) {
        try {
          final date = DateTime.parse(f.createdAt);
          return date.isAfter(lastMonth);
        } catch (e) {
          return false;
        }
      }).toList();
    }
    
    if (filteredFlows.isEmpty) {
      return Container(
        padding: EdgeInsets.all(TossSpacing.space5),
        child: Center(
          child: Text(
            'No data for selected filter',
            style: TossTextStyles.body.copyWith(
              color: Colors.grey[500],
            ),
          ),
        ),
      );
    }
    
    return ListView.builder(
      padding: EdgeInsets.symmetric(vertical: TossSpacing.space3),
      itemCount: filteredFlows.length + (hasMoreFlows && selectedFilter == 'All' ? 1 : 0),
      itemBuilder: (context, index) {
        if (index >= filteredFlows.length) {
          // Load more button
          return GestureDetector(
            onTap: () {
              if (selectedCashLocationIdForFlow != null) {
                _fetchLocationStockFlow(selectedCashLocationIdForFlow!, isLoadMore: true);
              }
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: TossSpacing.space4),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Load More',
                      style: TossTextStyles.body.copyWith(
                        color: TossColors.primary,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(width: TossSpacing.space2),
                    Icon(
                      Icons.arrow_downward,
                      size: 16,
                      color: TossColors.primary,
                    ),
                  ],
                ),
              ),
            ),
          );
        }
        
        final flow = filteredFlows[index];
        final showDate = index == 0 || 
            flow.getFormattedDate() != filteredFlows[index - 1].getFormattedDate();
        
        return _buildRealItem(flow, showDate);
      },
    );
  }
  
  Widget _buildJournalTabContent() {
    if (isLoadingFlows) {
      return Center(
        child: CircularProgressIndicator(
          color: TossColors.primary,
          strokeWidth: 2,
        ),
      );
    }
    
    if (journalFlows.isEmpty) {
      return Container(
        padding: EdgeInsets.all(TossSpacing.space5),
        child: Center(
          child: Text(
            'No journal entries found',
            style: TossTextStyles.body.copyWith(
              color: Colors.grey[500],
            ),
          ),
        ),
      );
    }
    
    // Apply filters
    var filteredFlows = List<JournalFlow>.from(journalFlows);
    
    if (selectedFilter == 'Money In') {
      filteredFlows = filteredFlows.where((f) => f.flowAmount > 0).toList();
    } else if (selectedFilter == 'Money Out') {
      filteredFlows = filteredFlows.where((f) => f.flowAmount < 0).toList();
    } else if (selectedFilter == 'Today') {
      final today = DateTime.now();
      filteredFlows = filteredFlows.where((f) {
        try {
          final date = DateTime.parse(f.createdAt);
          return date.year == today.year && date.month == today.month && date.day == today.day;
        } catch (e) {
          return false;
        }
      }).toList();
    } else if (selectedFilter == 'Yesterday') {
      final yesterday = DateTime.now().subtract(Duration(days: 1));
      filteredFlows = filteredFlows.where((f) {
        try {
          final date = DateTime.parse(f.createdAt);
          return date.year == yesterday.year && date.month == yesterday.month && date.day == yesterday.day;
        } catch (e) {
          return false;
        }
      }).toList();
    } else if (selectedFilter == 'Last Week') {
      final lastWeek = DateTime.now().subtract(Duration(days: 7));
      filteredFlows = filteredFlows.where((f) {
        try {
          final date = DateTime.parse(f.createdAt);
          return date.isAfter(lastWeek);
        } catch (e) {
          return false;
        }
      }).toList();
    }
    
    if (filteredFlows.isEmpty) {
      return Container(
        padding: EdgeInsets.all(TossSpacing.space5),
        child: Center(
          child: Text(
            'No data for selected filter',
            style: TossTextStyles.body.copyWith(
              color: Colors.grey[500],
            ),
          ),
        ),
      );
    }
    
    return ListView.builder(
      padding: EdgeInsets.symmetric(vertical: TossSpacing.space3),
      itemCount: filteredFlows.length + (hasMoreFlows && selectedFilter == 'All' ? 1 : 0),
      itemBuilder: (context, index) {
        if (index >= filteredFlows.length) {
          // Load more button
          return GestureDetector(
            onTap: () {
              if (selectedCashLocationIdForFlow != null) {
                _fetchLocationStockFlow(selectedCashLocationIdForFlow!, isLoadMore: true);
              }
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: TossSpacing.space4),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Load More',
                      style: TossTextStyles.body.copyWith(
                        color: TossColors.primary,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(width: TossSpacing.space2),
                    Icon(
                      Icons.arrow_downward,
                      size: 16,
                      color: TossColors.primary,
                    ),
                  ],
                ),
              ),
            ),
          );
        }
        
        final flow = filteredFlows[index];
        final showDate = index == 0 || 
            flow.getFormattedDate() != filteredFlows[index - 1].getFormattedDate();
        
        return _buildJournalItem(flow, showDate);
      },
    );
  }
  
  Widget _buildRealItem(ActualFlow flow, bool showDate) {
    final currencySymbol = flow.currency.symbol;
    
    return GestureDetector(
      onTap: () {
        // Determine location type based on current tab
        String locationType = 'cash';
        if (_tabController.index == 1) {
          locationType = 'bank';
        } else if (_tabController.index == 2) {
          locationType = 'vault';
        }
        _showRealDetailBottomSheet(flow, locationType: locationType);
      },
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: EdgeInsets.only(
          left: TossSpacing.space4,
          right: TossSpacing.space4,
          top: TossSpacing.space3,
          bottom: TossSpacing.space3,
        ),
        child: Row(
          children: [
          // Date section
          Container(
            width: 42,
            padding: EdgeInsets.only(left: TossSpacing.space1),
            child: showDate
                ? Text(
                    flow.getFormattedDate(),
                    style: TossTextStyles.caption.copyWith(
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      height: 1.2,
                    ),
                  )
                : SizedBox.shrink(),
          ),
          
          SizedBox(width: TossSpacing.space3),
          
          // Transaction details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Cash Count',
                  style: TossTextStyles.body.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: Colors.black87,
                    height: 1.2,
                  ),
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        flow.createdBy.fullName,
                        style: TossTextStyles.caption.copyWith(
                          color: Colors.grey[500],
                          fontSize: 13,
                          height: 1.2,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (flow.getFormattedTime().isNotEmpty) ...[
                      Text(
                        ' • ',
                        style: TossTextStyles.caption.copyWith(
                          color: Colors.grey[500],
                          fontSize: 13,
                          height: 1.2,
                        ),
                      ),
                      Text(
                        flow.getFormattedTime(),
                        style: TossTextStyles.caption.copyWith(
                          color: Colors.grey[500],
                          fontSize: 13,
                          height: 1.2,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          
          SizedBox(width: TossSpacing.space2),
          
          // Flow amount and balance after
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Flow amount (the transaction amount) - blue for positive, black for negative
              Text(
                _formatBalance(flow.flowAmount, currencySymbol),
                style: TossTextStyles.body.copyWith(
                  color: flow.flowAmount >= 0 
                      ? TossColors.primary 
                      : Colors.black87,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  height: 1.2,
                ),
              ),
              SizedBox(height: 4),
              // Balance after in gray
              Text(
                _formatBalance(flow.balanceAfter, currencySymbol),
                style: TossTextStyles.caption.copyWith(
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  height: 1.2,
                ),
              ),
            ],
          ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildJournalItem(JournalFlow flow, bool showDate) {
    final isIncome = flow.flowAmount > 0;
    final currencySymbol = locationSummary?.currencyCode == 'VND' ? '₫' : 
                          locationSummary?.currencyCode == 'USD' ? '\$' : '';
    
    return GestureDetector(
      onTap: () => _showJournalDetailBottomSheet(flow),
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: EdgeInsets.only(
          left: TossSpacing.space4,
          right: TossSpacing.space4,
          top: TossSpacing.space3,
          bottom: TossSpacing.space3,
        ),
        child: Row(
          children: [
          // Date section
          Container(
            width: 42,
            padding: EdgeInsets.only(left: TossSpacing.space1),
            child: showDate
                ? Text(
                    flow.getFormattedDate(),
                    style: TossTextStyles.caption.copyWith(
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      height: 1.2,
                    ),
                  )
                : SizedBox.shrink(),
          ),
          
          SizedBox(width: TossSpacing.space3),
          
          // Transaction details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  flow.journalDescription,
                  style: TossTextStyles.body.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: Colors.black87,
                    height: 1.2,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        flow.createdBy.fullName,
                        style: TossTextStyles.caption.copyWith(
                          color: Colors.grey[500],
                          fontSize: 13,
                          height: 1.2,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (flow.getFormattedTime().isNotEmpty) ...[
                      Text(
                        ' • ',
                        style: TossTextStyles.caption.copyWith(
                          color: Colors.grey[500],
                          fontSize: 13,
                          height: 1.2,
                        ),
                      ),
                      Text(
                        flow.getFormattedTime(),
                        style: TossTextStyles.caption.copyWith(
                          color: Colors.grey[500],
                          fontSize: 13,
                          height: 1.2,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          
          SizedBox(width: TossSpacing.space2),
          
          // Amount and balance
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                _formatTransactionAmount(flow.flowAmount, currencySymbol),
                style: TossTextStyles.body.copyWith(
                  color: isIncome 
                      ? TossColors.primary 
                      : Colors.black87,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  height: 1.2,
                ),
              ),
              SizedBox(height: 8),
              Text(
                _formatBalance(flow.balanceAfter, currencySymbol),
                style: TossTextStyles.caption.copyWith(
                  color: Colors.grey[500],
                  fontSize: 13,
                  height: 1.2,
                ),
              ),
            ],
          ),
          ],
        ),
      ),
    );
  }
  
  void _showRealDetailBottomSheet(ActualFlow flow, {String locationType = 'cash'}) {
    final currencySymbol = flow.currency.symbol;
    
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.9,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar
              Container(
                margin: const EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              
              // Header
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 20, 16, 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Cash Count Details',
                      style: TossTextStyles.h2.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, size: 24, color: Colors.grey),
                      onPressed: () => Navigator.pop(context),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              ),
              
              // Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Total Balance Section
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8F0FF),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Total Balance',
                              style: TossTextStyles.body.copyWith(
                                color: Colors.grey[700],
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  _formatBalance(flow.balanceAfter, currencySymbol),
                                  style: TossTextStyles.h1.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: TossColors.primary,
                                    fontSize: 32,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Icon(
                                    Icons.account_balance_wallet_outlined,
                                    color: TossColors.primary,
                                    size: 24,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Previous Balance',
                                        style: TossTextStyles.caption.copyWith(
                                          color: Colors.grey[600],
                                          fontSize: 12,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        _formatBalance(flow.balanceBefore, currencySymbol),
                                        style: TossTextStyles.body.copyWith(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 15,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 40),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Change',
                                        style: TossTextStyles.caption.copyWith(
                                          color: Colors.grey[600],
                                          fontSize: 12,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        _formatTransactionAmount(flow.flowAmount, currencySymbol),
                                        style: TossTextStyles.body.copyWith(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 15,
                                          color: flow.flowAmount >= 0 ? TossColors.primary : Colors.black87,
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
                      
                      const SizedBox(height: 24),
                      
                      // Denomination Breakdown Section (only show for cash and vault, not for bank)
                      if (flow.currentDenominations.isNotEmpty && locationType != 'bank') ...[
                        Text(
                          'Denomination Breakdown',
                          style: TossTextStyles.body.copyWith(
                            fontWeight: FontWeight.w700,
                            fontSize: 17,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 16),
                        
                        // Denomination cards
                        ...flow.currentDenominations.map((denomination) {
                          final subtotal = denomination.denominationValue * denomination.currentQuantity;
                          return Container(
                            margin: const EdgeInsets.only(bottom: 16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey[200]!),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.04),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                // Denomination header
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[50],
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(12),
                                      topRight: Radius.circular(12),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        _formatCurrency(denomination.denominationValue, currencySymbol),
                                        style: TossTextStyles.body.copyWith(
                                          fontWeight: FontWeight.w700,
                                          color: TossColors.primary,
                                          fontSize: 16,
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: TossColors.primary.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: Text(
                                          denomination.denominationType.toUpperCase(),
                                          style: TossTextStyles.caption.copyWith(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w600,
                                            color: TossColors.primary,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                
                                // Quantity details
                                Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                  'Previous Qty',
                                                  style: TossTextStyles.caption.copyWith(
                                                    color: Colors.grey[600],
                                                    fontSize: 12,
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  '${denomination.previousQuantity}',
                                                  style: TossTextStyles.body.copyWith(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 15,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                  'Change',
                                                  style: TossTextStyles.caption.copyWith(
                                                    color: Colors.grey[600],
                                                    fontSize: 12,
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  '${denomination.quantityChange > 0 ? "+" : ""}${denomination.quantityChange}',
                                                  style: TossTextStyles.body.copyWith(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 15,
                                                    color: denomination.quantityChange > 0 
                                                        ? Colors.green[600] 
                                                        : denomination.quantityChange < 0 
                                                            ? Colors.red[600] 
                                                            : Colors.black87,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                  'Current Qty',
                                                  style: TossTextStyles.caption.copyWith(
                                                    color: Colors.grey[600],
                                                    fontSize: 12,
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  '${denomination.currentQuantity}',
                                                  style: TossTextStyles.body.copyWith(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 15,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      
                                      const SizedBox(height: 16),
                                      Divider(color: Colors.grey[200], thickness: 1),
                                      const SizedBox(height: 12),
                                      
                                      // Subtotal
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Subtotal',
                                            style: TossTextStyles.body.copyWith(
                                              color: Colors.grey[700],
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          Text(
                                            _formatBalance(subtotal, currencySymbol),
                                            style: TossTextStyles.body.copyWith(
                                              fontWeight: FontWeight.w700,
                                              fontSize: 16,
                                              color: Colors.black87,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                      ],
                      
                      const SizedBox(height: 24),
                      
                      // Footer information
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            _buildInfoRow('Counted By', flow.createdBy.fullName),
                            const SizedBox(height: 12),
                            _buildInfoRow('Date', DateFormat('MMM d, yyyy').format(DateTime.parse(flow.createdAt))),
                            const SizedBox(height: 12),
                            _buildInfoRow('Time', flow.getFormattedTime()),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
              
              // Bottom safe area
              SizedBox(height: MediaQuery.of(context).padding.bottom),
            ],
          ),
        );
      },
    );
  }
  
  void _showJournalDetailBottomSheet(JournalFlow flow) {
    final currencySymbol = locationSummary?.currencyCode == 'VND' ? '₫' : 
                          locationSummary?.currencyCode == 'USD' ? '\$' : '';
    
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.9,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar
              Container(
                margin: const EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              
              // Header
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 20, 16, 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Journal Entry Details',
                      style: TossTextStyles.h2.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, size: 24, color: Colors.grey),
                      onPressed: () => Navigator.pop(context),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              ),
              
              // Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Description Section
                      Text(
                        'Description',
                        style: TossTextStyles.body.copyWith(
                          color: Colors.grey[700],
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        flow.journalDescription,
                        style: TossTextStyles.body.copyWith(
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                          color: Colors.black87,
                        ),
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Transaction Amount Section
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF0F5),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Transaction\nAmount',
                                  style: TossTextStyles.body.copyWith(
                                    color: Colors.grey[700],
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    height: 1.3,
                                  ),
                                ),
                                Text(
                                  _formatTransactionAmount(flow.flowAmount, currencySymbol),
                                  style: TossTextStyles.h2.copyWith(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 24,
                                    color: flow.flowAmount >= 0 ? TossColors.primary : Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Balance Before',
                                        style: TossTextStyles.caption.copyWith(
                                          color: Colors.grey[600],
                                          fontSize: 12,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        _formatBalance(flow.balanceBefore, currencySymbol),
                                        style: TossTextStyles.body.copyWith(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 15,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 40),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Balance After',
                                        style: TossTextStyles.caption.copyWith(
                                          color: Colors.grey[600],
                                          fontSize: 12,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        _formatBalance(flow.balanceAfter, currencySymbol),
                                        style: TossTextStyles.body.copyWith(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 15,
                                          color: Colors.black87,
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
                      
                      const SizedBox(height: 24),
                      
                      // Transaction details
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            _buildInfoRow('Account', flow.accountName),
                            const SizedBox(height: 12),
                            _buildInfoRow('Type', flow.journalType),
                            const SizedBox(height: 12),
                            _buildInfoRow('Created By', flow.createdBy.fullName),
                            const SizedBox(height: 12),
                            _buildInfoRow('Date', DateFormat('MMM d, yyyy').format(DateTime.parse(flow.createdAt))),
                            const SizedBox(height: 12),
                            _buildInfoRow('Time', flow.getFormattedTime()),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
              
              // Bottom safe area
              SizedBox(height: MediaQuery.of(context).padding.bottom),
            ],
          ),
        );
      },
    );
  }
  
  Widget _buildDetailRow(String label, String value, {bool isHighlighted = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TossTextStyles.body.copyWith(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TossTextStyles.body.copyWith(
                fontWeight: isHighlighted ? FontWeight.w700 : FontWeight.w500,
                fontSize: isHighlighted ? 16 : 14,
                color: isHighlighted ? TossColors.primary : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TossTextStyles.body.copyWith(
            color: Colors.grey[600],
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: TossTextStyles.body.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
  
  // Shared method to build Real/Journal tabs section for all tabs
  Widget _buildRealJournalSection({required bool showSection}) {
    if (!showSection || selectedCashLocationIdForFlow == null || selectedCashLocationIdForFlow!.isEmpty) {
      return const SizedBox.shrink();
    }
    
    return Column(
      children: [
        const SizedBox(height: TossSpacing.space5),
        
        // Journal/Real Section - wrapped in white card
        Container(
          height: 400, // Fixed height for the container
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(TossBorderRadius.lg),
            boxShadow: TossShadows.card,
          ),
          child: Column(
            children: [
              // Tab bar for Journal/Real
              Container(
                height: 48,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: const Color(0xFFE5E8EB),
                      width: 1,
                    ),
                  ),
                ),
                child: Theme(
                  data: ThemeData(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                  ),
                  child: TabBar(
                    controller: _journalTabController,
                    indicatorSize: TabBarIndicatorSize.tab,
                    indicator: UnderlineTabIndicator(
                      borderSide: BorderSide(
                        width: 2.0,
                        color: Colors.black87,
                      ),
                      insets: EdgeInsets.zero,
                    ),
                    indicatorColor: Colors.black87,
                    labelColor: Colors.black87,
                    unselectedLabelColor: Colors.grey[400],
                    labelStyle: TossTextStyles.body.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 17,
                    ),
                    unselectedLabelStyle: TossTextStyles.body.copyWith(
                      fontSize: 17,
                    ),
                    overlayColor: WidgetStateProperty.all(Colors.transparent),
                    tabs: const [
                      Tab(text: 'Real'),
                      Tab(text: 'Journal'),
                    ],
                  ),
                ),
              ),
              
              // Filter header
              Container(
                padding: EdgeInsets.only(
                  left: TossSpacing.space5,
                  right: TossSpacing.space4,
                  top: TossSpacing.space5,
                  bottom: TossSpacing.space3,
                ),
                child: GestureDetector(
                  onTap: () => _showFilterBottomSheet(),
                  child: Row(
                    children: [
                      Text(
                        selectedFilter,
                        style: TossTextStyles.body.copyWith(
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      Icon(
                        Icons.keyboard_arrow_down,
                        size: 18,
                        color: Colors.grey[600],
                      ),
                    ],
                  ),
                ),
              ),
              
              // Content area with tab-specific content
              Expanded(
                child: TabBarView(
                  controller: _journalTabController,
                  children: [
                    // Real tab content
                    _buildRealTabContent(),
                    // Journal tab content
                    _buildJournalTabContent(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
  
}
