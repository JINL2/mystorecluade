import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:myfinance_improved/core/themes/index.dart';

import '../../../core/constants/ui_constants.dart';
import '../../../core/navigation/safe_navigation.dart';
import '../../providers/app_state_provider.dart';
import '../../widgets/common/toss_app_bar.dart';
import '../../widgets/common/toss_loading_view.dart';
import '../../widgets/common/toss_scaffold.dart';
import '../../widgets/toss/toss_card.dart';
import '../../widgets/toss/toss_primary_button.dart';
import '../../widgets/toss/toss_tab_bar.dart';

import 'business/callback_handlers.dart';
import 'business/cash_ending_coordinator.dart';
import 'business/integration_utils.dart';
import 'core/utils/formatting_utils.dart';
import 'core/utils/permission_utils.dart';
import 'data/services/currency_service.dart';
import 'data/services/exchange_rate_service.dart';
import 'data/services/location_service.dart';
import 'data/services/stock_flow_service.dart';
import 'presentation/widgets/displays/real_item_widget.dart';
import 'presentation/widgets/dialogs/result_dialogs.dart';
import 'presentation/widgets/sheets/filter_bottom_sheet.dart';
import 'presentation/widgets/sheets/real_detail_bottom_sheet.dart';
import 'presentation/widgets/sheets/store_selector_sheet.dart';
import 'presentation/widgets/sheets/location_selector_sheet.dart';
import 'presentation/widgets/sheets/transactions_bottom_sheet.dart';
import 'presentation/widgets/tabs/bank_tab.dart';
import 'presentation/widgets/tabs/cash_tab.dart';
import 'presentation/widgets/tabs/vault_tab.dart';
import 'presentation/widgets/common/location_selector.dart';
import 'presentation/widgets/common/store_selector.dart';
import 'presentation/widgets/common/toggle_buttons.dart';
import 'presentation/widgets/forms/denomination_widgets.dart';

/// Main Cash Ending Page with modular LEGO architecture
/// Coordinates all extracted components while preserving exact functionality
class CashEndingPage extends ConsumerStatefulWidget {
  const CashEndingPage({super.key});

  @override
  ConsumerState<CashEndingPage> createState() => _CashEndingPageState();
}

class _CashEndingPageState extends ConsumerState<CashEndingPage>
    with TickerProviderStateMixin {
  
  // Core Controllers
  late TabController _tabController;
  
  // Store and Location Selection
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
  
  // Currency set mode for bank locations without currency
  bool isSettingBankCurrency = false;
  String? tempSelectedBankCurrency; // Temporarily selected currency before saving
  bool isSavingBankCurrency = false; // Loading state for saving currency
  
  // View All transactions variables
  List<Map<String, dynamic>> allBankTransactions = [];
  bool isLoadingAllTransactions = false;
  bool hasMoreTransactions = true;
  int transactionOffset = 0;
  final int transactionLimit = 10;
  
  // Vault balance state variables
  Map<String, dynamic>? vaultBalanceData;
  bool isLoadingVaultBalance = false;
  
  // Vault transaction type (in/out) 
  String? vaultTransactionType; // 'debit' (In) or 'credit' (Out)
  
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
  
  // Stock flow data for Real section only
  List<ActualFlow> actualFlows = [];
  LocationSummary? locationSummary;
  bool isLoadingFlows = false;
  int flowsOffset = 0;
  final int flowsLimit = 20;
  bool hasMoreFlows = false;
  String? selectedCashLocationIdForFlow;
  String selectedFilter = 'All';
  
  // Exchange rate state variables
  String? baseCurrencyId;
  Map<String, double> exchangeRates = {};
  bool isLoadingExchangeRates = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    
    // Clear any existing navigation locks when page loads successfully
    // This helps recover from any previous navigation issues
    WidgetsBinding.instance.addPostFrameCallback((_) {
      try {
        SafeNavigation.instance.clearLockForRoute('/cashEnding');
        SafeNavigation.instance.clearLockForRoute('cashEnding');
      } catch (e) {
        // Silently handle navigation lock clearing errors
      }
    });
    
    // Add listener to update UI when tab changes and manage tab state cleanup
    _tabController.addListener(() {
      if (mounted) {
        // Check if tab is actually changing (not just animation updates)
        if (_tabController.indexIsChanging) {
          final previousIndex = _tabController.previousIndex;
          final currentIndex = _tabController.index;
          
          // Clean up state from previous tab
          _cleanupTabState(previousIndex, currentIndex);
        }
        
        setState(() {
          // This will trigger a rebuild to update the button text
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
    // Clear navigation locks for this page to prevent lock issues
    try {
      SafeNavigation.instance.clearLockForRoute('/cashEnding');
      SafeNavigation.instance.clearLockForRoute('cashEnding');
    } catch (e) {
      // Silently handle navigation lock clearing errors
    }
    
    _tabController.dispose();
    bankAmountController.dispose();
    denominationControllers.forEach((currencyId, controllers) {
      controllers.forEach((denomValue, controller) {
        controller.dispose();
      });
    });
    super.dispose();
  }

  // Tab state management methods
  /// Cleans up state when switching between tabs to ensure clean slate
  /// Based on production patterns but extended for comprehensive cleanup
  void _cleanupTabState(int? previousIndex, int currentIndex) {
    if (previousIndex == null) return;
    
    // Always clear all denomination controller values when switching tabs
    // This prevents shared currency data from persisting across tabs
    _clearAllDenominationInputs();
    
    // Clear tab-specific state based on which tab we're leaving
    switch (previousIndex) {
      case 0: // Leaving Cash Tab
        _clearCashTabState();
        break;
      case 1: // Leaving Bank Tab  
        _clearBankTabState();
        break;
      case 2: // Leaving Vault Tab
        _clearVaultTabState();
        break;
    }
  }
  
  /// Clears all denomination controller input values while preserving controller objects
  /// Follows production pattern used in currency changes and save success
  void _clearAllDenominationInputs() {
    denominationControllers.forEach((currencyId, controllers) {
      controllers.forEach((denomValue, controller) {
        controller.clear(); // Clear text content but keep controller object
      });
    });
  }
  
  /// Clears Cash tab specific state when leaving the tab
  void _clearCashTabState() {
    selectedLocationId = null;
    selectedCashLocationIdForFlow = null;
    recentCashEndings.clear();
    actualFlows.clear();
    locationSummary = null;
    isLoadingFlows = false;
    flowsOffset = 0;
    hasMoreFlows = false;
    selectedFilter = 'All';
  }
  
  /// Clears Bank tab specific state when leaving the tab
  void _clearBankTabState() {
    selectedBankLocationId = null;
    selectedBankCurrencyType = null;
    bankAmountController.clear();
    recentBankTransactions.clear();
    allBankTransactions.clear();
    transactionOffset = 0;
    hasMoreTransactions = true;
    isLoadingBankTransactions = false;
    isLoadingAllTransactions = false;
    isSettingBankCurrency = false;
    tempSelectedBankCurrency = null;
    isSavingBankCurrency = false;
  }
  
  /// Clears Vault tab specific state when leaving the tab
  void _clearVaultTabState() {
    selectedVaultLocationId = null;
    vaultTransactionType = null;
    vaultBalanceData = null;
    isLoadingVaultBalance = false;
  }

  // Service method delegations - delegating to extracted services
  Future<void> _loadCompanyCurrencies() async {
    // Get company ID from app state
    final appState = ref.read(appStateProvider);
    final companyId = appState.companyChoosen;
    
    if (companyId.isEmpty) return;
    
    try {
      setState(() {
        isLoadingCurrency = true;
      });
      
      final currencyService = CurrencyService();
      final result = await currencyService.loadCompanyCurrencies(companyId);
      
      // Load denominations after getting company currencies
      final companyCurrenciesList = (result['companyCurrencies'] as List<dynamic>?)?.cast<Map<String, dynamic>>() ?? [];
      final denomResult = await currencyService.loadCurrencyDenominations(
        companyId,
        companyCurrenciesList,
        denominationControllers,
      );
      
      if (mounted) {
        setState(() {
          companyCurrencies = (result['companyCurrencies'] as List<dynamic>?)?.cast<Map<String, dynamic>>() ?? [];
          currencyDenominations = (denomResult['currencyDenominations'] as Map<String, dynamic>?)?.map(
            (key, value) => MapEntry(key, (value as List<dynamic>).cast<Map<String, dynamic>>())
          ) ?? {};
          denominationControllers = (denomResult['denominationControllers'] as Map<String, dynamic>?)?.map(
            (key, value) => MapEntry(key, (value as Map<String, dynamic>).cast<String, TextEditingController>())
          ) ?? {};
          
          // Set default selected currencies if not already set
          if (companyCurrencies.isNotEmpty) {
            selectedCashCurrencyId ??= companyCurrencies.first['currency_id']?.toString();
            selectedBankCurrencyId ??= companyCurrencies.first['currency_id']?.toString();
            selectedVaultCurrencyId ??= companyCurrencies.first['currency_id']?.toString();
          }
          
          isLoadingCurrency = false;
        });
        
        // Load exchange rates after currencies are loaded
        _loadExchangeRates();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoadingCurrency = false;
        });
      }
    }
  }
  
  // Load exchange rates for all currencies
  Future<void> _loadExchangeRates() async {
    final appState = ref.read(appStateProvider);
    final companyId = appState.companyChoosen;
    
    if (companyId.isEmpty || companyCurrencies.isEmpty) return;
    
    try {
      setState(() {
        isLoadingExchangeRates = true;
      });
      
      // Get base currency ID
      final fetchedBaseCurrencyId = await ExchangeRateService.getCompanyBaseCurrencyId(companyId);
      
      // Load exchange rates
      final fetchedRates = await ExchangeRateService.loadExchangeRates(
        companyId,
        companyCurrencies,
      );
      
      if (mounted) {
        setState(() {
          baseCurrencyId = fetchedBaseCurrencyId;
          exchangeRates = fetchedRates;
          isLoadingExchangeRates = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoadingExchangeRates = false;
        });
      }
    }
  }

  Future<void> _loadCurrencyTypes() async {
    try {
      final currencyService = CurrencyService();
      final result = await currencyService.loadCurrencyTypes();
      
      if (mounted) {
        setState(() {
          currencyTypes = (result['currencyTypes'] as List<dynamic>?)?.cast<Map<String, dynamic>>() ?? [];
          isLoadingCurrency = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoadingCurrency = false;
        });
      }
    }
  }

  Future<void> _loadStores() async {
    try {
      final locationService = LocationService(ref: ref);
      final result = await locationService.loadStores();
      
      if (mounted) {
        setState(() {
          stores = (result['stores'] as List<dynamic>?)?.cast<Map<String, dynamic>>() ?? [];
          isLoadingStores = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoadingStores = false;
        });
      }
    }
  }

  Map<String, dynamic> getBaseCurrency() {
    if (currencyTypes.isEmpty) return {};
    
    // Find USD first, then fallback to first currency
    final usdCurrency = currencyTypes.firstWhere(
      (currency) => currency['currency_code'] == 'USD',
      orElse: () => currencyTypes.first,
    );
    
    return usdCurrency;
  }

  Future<void> _fetchLocations(String locationType) async {
    if (selectedStoreId == null || selectedStoreId!.isEmpty) return;
    
    try {
      // Set loading state before fetching
      setState(() {
        if (locationType == 'cash') {
          isLoadingCashLocations = true;
        } else if (locationType == 'bank') {
          isLoadingBankLocations = true;
        } else if (locationType == 'vault') {
          isLoadingVaultLocations = true;
        }
      });
      
      final locationService = LocationService(ref: ref);
      final result = await locationService.fetchLocations(locationType, selectedStoreId: selectedStoreId);
      
      if (mounted) {
        setState(() {
          switch (locationType) {
            case 'cash':
              cashLocations = (result['cashLocations'] as List<dynamic>?)?.cast<Map<String, dynamic>>() ?? [];
              isLoadingCashLocations = false;
              break;
            case 'bank':
              bankLocations = (result['bankLocations'] as List<dynamic>?)?.cast<Map<String, dynamic>>() ?? [];
              isLoadingBankLocations = false;
              break;
            case 'vault':
              vaultLocations = (result['vaultLocations'] as List<dynamic>?)?.cast<Map<String, dynamic>>() ?? [];
              isLoadingVaultLocations = false;
              break;
          }
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          switch (locationType) {
            case 'cash':
              isLoadingCashLocations = false;
              break;
            case 'bank':
              isLoadingBankLocations = false;
              break;
            case 'vault':
              isLoadingVaultLocations = false;
              break;
          }
        });
      }
    }
  }

  bool _hasVaultBankPermission() {
    return PermissionUtils.hasVaultBankPermission(ref, appStateProvider);
  }

  @override
  Widget build(BuildContext context) {
    // Show loading indicator while fetching initial data
    if (isLoadingCurrency || isLoadingStores) {
      return TossScaffold(
        backgroundColor: TossColors.gray100,
        body: const TossLoadingView(),
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
            // Tab Bar matching Cash Control design
            TossTabBar(
              tabs: const ['Cash', 'Bank', 'Vault'],
              controller: _tabController,
              selectedColor: TossColors.black87, // Use black87 to match Cash Control page exactly
              unselectedColor: hasVaultBankAccess 
                  ? TossColors.gray400 
                  : TossColors.gray300, // Lighter gray for disabled tabs
              onTabChanged: (index) {
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
    return CashTab(
      selectedStoreId: selectedStoreId,
      selectedLocationId: selectedLocationId,
      currencyTypes: currencyTypes,
      companyCurrencies: companyCurrencies,
      currencyDenominations: currencyDenominations,
      buildStoreSelector: () => _buildStoreSelector(),
      buildLocationSelector: (String locationType) => _buildLocationSelector(locationType),
      buildDenominationSection: ({required String tabType}) => _buildDenominationSection(tabType: tabType),
      buildTotalSection: ({required String tabType}) => _buildTotalSection(tabType: tabType),
      buildSubmitButton: () => _buildSubmitButton(),
      buildRealJournalSection: ({required bool showSection}) => _buildRealJournalSection(showSection: showSection),
    );
  }

  // Helper method for building Real item widgets
  // These methods are referenced in the tab builders but need to be implemented
  Widget _buildStoreSelector() {
    return StoreSelector(
      stores: stores,
      selectedStoreId: selectedStoreId,
      onTap: _showStoreSelector,
    );
  }
  
  Widget _buildLocationSelector(String locationType) {
    return LocationSelector(
      locationType: locationType,
      isLoading: locationType == 'cash' ? isLoadingCashLocations 
          : locationType == 'bank' ? isLoadingBankLocations 
          : isLoadingVaultLocations,
      locations: locationType == 'cash' ? cashLocations 
          : locationType == 'bank' ? bankLocations 
          : vaultLocations,
      selectedLocation: locationType == 'cash' ? selectedLocationId 
          : locationType == 'bank' ? selectedBankLocationId 
          : selectedVaultLocationId,
      currencyTypes: currencyTypes,
      onTap: () => _showLocationSelector(locationType),
    );
  }
  
  Widget _buildDenominationSection({required String tabType}) {
    return DenominationWidgets.buildDenominationSection(
      context: context,
      tabType: tabType,
      selectedCashCurrencyId: selectedCashCurrencyId,
      selectedBankCurrencyId: selectedBankCurrencyId,
      selectedVaultCurrencyId: selectedVaultCurrencyId,
      companyCurrencies: companyCurrencies,
      currencyDenominations: currencyDenominations,
      denominationControllers: denominationControllers,
      setState: setState,
      currencyHasData: (currencyId) => CashEndingCoordinator.currencyHasData(
        currencyId: currencyId,
        denominationControllers: denominationControllers,
      ),
      onCurrencySelected: (tabType, currencyId) {
        setState(() {
          if (tabType == 'cash') {
            selectedCashCurrencyId = currencyId;
          } else if (tabType == 'bank') {
            selectedBankCurrencyId = currencyId;
          } else {
            selectedVaultCurrencyId = currencyId;
          }
        });
      },
    );
  }
  
  Widget _buildTotalSection({required String tabType}) {
    final total = _calculateTotal(tabType: tabType);
    
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: TossSpacing.space4,
        vertical: TossSpacing.space3,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Total Amount',
            style: TossTextStyles.body.copyWith(
              fontWeight: FontWeight.w700,
              fontSize: 17,
            ),
          ),
          Flexible(
            flex: 2,
            child: AnimatedSwitcher(
              duration: TossAnimations.slow,
              child: Text(
                total,
                key: ValueKey(total),
                style: _getResponsiveTotalStyle(total),
                textAlign: TextAlign.right,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Get responsive text style for total amount based on length
  TextStyle _getResponsiveTotalStyle(String total) {
    final length = total.length;
    
    if (length <= 10) {
      // Short amounts: ₫50,000
      return TossTextStyles.h2.copyWith(
        color: TossColors.primary,
        fontWeight: FontWeight.w700,
        fontFamily: TossTextStyles.fontFamilyMono,
      );
    } else if (length <= 15) {
      // Medium amounts: ₫5,000,000
      return TossTextStyles.h3.copyWith(
        color: TossColors.primary,
        fontWeight: FontWeight.w700,
        fontFamily: TossTextStyles.fontFamilyMono,
      );
    } else if (length <= 20) {
      // Long amounts: ₫500,000,000
      return TossTextStyles.h4.copyWith(
        color: TossColors.primary,
        fontWeight: FontWeight.w700,
        fontFamily: TossTextStyles.fontFamilyMono,
      );
    } else {
      // Very long amounts: ₫50,000,000,000+
      return TossTextStyles.caption.copyWith(
        color: TossColors.primary,
        fontWeight: FontWeight.w700,
        fontFamily: TossTextStyles.fontFamilyMono,
      );
    }
  }
  
  String _calculateTotal({required String tabType}) {
    // Get selected currency ID based on tab - EXACTLY like production
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
      final denomValue = (denom['value'] ?? 0).toString();
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
    
    return Center(
      child: TossPrimaryButton(
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
      ),
    );
  }
  
  int _calculateTotalAmount({String tabType = 'cash'}) {
    // For cash tab, calculate total across ALL currencies that have data
    if (tabType == 'cash') {
      int total = 0;
      for (var currency in companyCurrencies) {
        final currencyId = currency['currency_id']?.toString();
        if (currencyId != null && _currencyHasData(currencyId)) {
          final controllers = denominationControllers[currencyId] ?? {};
          final denominations = currencyDenominations[currencyId] ?? [];
          
          for (var denom in denominations) {
            final denomValue = (denom['value'] ?? 0).toString();
            final controller = controllers[denomValue];
            if (controller != null) {
              final value = ((denom['value'] ?? 0) as num).toInt();
              final qty = int.tryParse(controller.text) ?? 0;
              total += value * qty;
            }
          }
        }
      }
      return total;
    } else {
      // For bank and vault tabs, use the existing single currency logic
      final String? selectedCurrencyId;
      if (tabType == 'bank') {
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
        final denomValue = (denom['value'] ?? 0).toString();
        final controller = controllers[denomValue];
        if (controller != null) {
          final value = ((denom['value'] ?? 0) as num).toInt();
          final qty = int.tryParse(controller.text) ?? 0;
          total += value * qty;
        }
      }
      
      return total;
    }
  }
  
  // Add the _currencyHasData helper method from production
  bool _currencyHasData(String currencyId) {
    if (!denominationControllers.containsKey(currencyId)) {
      return false;
    }
    
    final controllers = denominationControllers[currencyId]!;
    for (var controller in controllers.values) {
      if (controller.text.isNotEmpty && controller.text != '0') {
        return true;
      }
    }
    return false;
  }
  
  Widget _buildRealJournalSection({required bool showSection}) {
    if (!showSection || selectedCashLocationIdForFlow == null || selectedCashLocationIdForFlow!.isEmpty) {
      return const SizedBox.shrink();
    }
    
    return Column(
      children: [
        const SizedBox(height: TossSpacing.space5),
        
        // Real Section - wrapped in white card matching production
        Container(
          height: 400, // Fixed height for the container
          decoration: BoxDecoration(
            color: TossColors.white,
            borderRadius: BorderRadius.circular(TossBorderRadius.lg),
            boxShadow: TossShadows.card,
          ),
          child: Column(
            children: [
              // Header for Real
              Container(
                height: 48,
                padding: EdgeInsets.symmetric(horizontal: TossSpacing.space5),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: TossColors.gray200,
                      width: 1,
                    ),
                  ),
                ),
                child: Center(
                  child: Text(
                    'Real',
                    style: TossTextStyles.body.copyWith(
                      fontWeight: FontWeight.w700,
                      fontSize: 17,
                      color: TossColors.black87,
                    ),
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
                          color: TossColors.gray600,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      Icon(
                        Icons.keyboard_arrow_down,
                        size: 18,
                        color: TossColors.gray600,
                      ),
                    ],
                  ),
                ),
              ),
              
              // Content area with Real content only
              Expanded(
                child: _buildRealTabContent(),
              ),
            ],
          ),
        ),
      ],
    );
  }
  
  Widget _buildRealTabContent() {
    if (isLoadingFlows) {
      return Center(
        child: TossLoadingView(),
      );
    }
    
    if (actualFlows.isEmpty) {
      return Container(
        padding: EdgeInsets.all(TossSpacing.space5),
        child: Center(
          child: Text(
            'No real data available',
            style: TossTextStyles.body.copyWith(
              color: TossColors.gray500,
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
    
    // Always sort filtered flows by createdAt in descending order (latest first)
    filteredFlows.sort((a, b) {
      DateTime dateA = DateTime.parse(a.createdAt);
      DateTime dateB = DateTime.parse(b.createdAt);
      return dateB.compareTo(dateA); // Descending order
    });
    
    if (filteredFlows.isEmpty) {
      return Container(
        padding: EdgeInsets.all(TossSpacing.space5),
        child: Center(
          child: Text(
            'No data for selected filter',
            style: TossTextStyles.body.copyWith(
              color: TossColors.gray500,
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
                child: Text(
                  'Load More',
                  style: TossTextStyles.bodyLarge.copyWith(
                    color: TossColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          );
        }
        
        final flow = filteredFlows[index];
        final showDate = index == 0 || 
            flow.getFormattedDate() != filteredFlows[index - 1].getFormattedDate();
        
        return RealItemWidget(
          flow: flow,
          showDate: showDate,
          locationSummary: locationSummary,
          getBaseCurrency: getBaseCurrency,
          formatBalance: FormattingUtils.formatBalance,
          tabController: _tabController,
          showRealDetailBottomSheet: _showRealDetailBottomSheet,
        );
      },
    );
  }
  
  Widget _buildDebitCreditToggle() {
    // MATCHING PRODUCTION LINES 936-956
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

  Widget _buildBankTab() {
    return BankTab(
      selectedStoreId: selectedStoreId,
      selectedBankLocationId: selectedBankLocationId,
      selectedBankCurrencyType: selectedBankCurrencyType,
      bankAmountController: bankAmountController,
      buildStoreSelector: () => _buildStoreSelector(),
      buildLocationSelector: (String locationType) => _buildLocationSelector(locationType),
      buildRealJournalSection: ({bool showSection = false}) => _buildRealJournalSection(showSection: showSection),
      saveBankBalance: () => _saveBankBalance(),
      onStateChange: () => setState(() {})
    );
  }

  Widget _buildVaultTab() {
    return VaultTab(
      selectedStoreId: selectedStoreId,
      selectedVaultLocationId: selectedVaultLocationId,
      buildStoreSelector: () => _buildStoreSelector(),
      buildLocationSelector: (String locationType) => _buildLocationSelector(locationType),
      buildDenominationSection: ({required String tabType}) => _buildDenominationSection(tabType: tabType),
      buildDebitCreditToggle: () => _buildDebitCreditToggle(),
      buildTotalSection: ({required String tabType}) => _buildTotalSection(tabType: tabType),
      buildSubmitButton: () => _buildSubmitButton(),
      buildRealJournalSection: ({required bool showSection}) => _buildRealJournalSection(showSection: showSection),
    );
  }

  // Removed extra VaultTab parameters that don't exist in widget definition

  // Business logic method implementations using extracted services
  void _refreshData() {
    final refreshCallback = CallbackHandlers.createRefreshDataCallback(
      context: context,
      selectedStoreId: selectedStoreId,
      selectedLocationId: selectedLocationId,
      selectedBankLocationId: selectedBankLocationId,
      selectedVaultLocationId: selectedVaultLocationId,
      selectedCashLocationIdForFlow: selectedCashLocationIdForFlow,
      fetchLocations: _fetchLocations,
      loadRecentCashEndings: _loadRecentCashEndings,
      fetchRecentBankTransactions: _fetchRecentBankTransactions,
      fetchVaultBalance: _fetchVaultBalance,
      fetchLocationStockFlow: _fetchLocationStockFlow,
    );
    refreshCallback();
  }

  Future<void> _loadRecentCashEndings(String locationId) async {
    await CashEndingCoordinator.loadRecentCashEndings(
      context: context,
      locationId: locationId,
      onEndingsLoaded: (endings, isLoading) {
        if (mounted) {
          setState(() {
            recentCashEndings = endings;
            isLoadingRecentEndings = isLoading;
          });
        }
      },
    );
  }

  Future<void> _saveCashEnding() async {
    final validation = IntegrationUtils.validateSaveData(
      selectedLocationId: selectedLocationId,
      selectedCurrencyId: selectedCashCurrencyId,
      denominationControllers: denominationControllers,
      tabType: 'cash',
    );

    if (!(validation['isValid'] as bool? ?? false)) {
      IntegrationUtils.showErrorMessage(
        context: context,
        message: validation['errorMessage'] as String? ?? 'Validation failed',
      );
      return;
    }

    // Get app state for company_id and user_id
    final appState = ref.read(appStateProvider);
    final companyId = appState.companyChoosen;
    final userId = appState.user['user_id'] as String?;

    await CashEndingCoordinator.saveCashEnding(
      context: context,
      companyId: companyId,
      userId: userId,
      selectedLocationId: selectedLocationId,
      selectedStoreId: selectedStoreId,
      tabIndex: _tabController.index,
      selectedBankLocationId: selectedBankLocationId,
      selectedVaultLocationId: selectedVaultLocationId,
      selectedCashCurrencyId: selectedCashCurrencyId,
      selectedBankCurrencyId: selectedBankCurrencyId,
      selectedVaultCurrencyId: selectedVaultCurrencyId,
      denominationControllers: denominationControllers,
      companyCurrencies: companyCurrencies,
      currencyDenominations: currencyDenominations,
      currencyHasData: (currencyId) => CashEndingCoordinator.currencyHasData(
        currencyId: currencyId,
        denominationControllers: denominationControllers,
      ),
      onSaveComplete: (success, {errorMessage, savedTotal}) {
        if (success && savedTotal != null) {
          _showSuccessBottomSheet(savedTotal);
          // Clear denomination controllers after successful save
          IntegrationUtils.clearDenominationControllers(
            currencyId: selectedCashCurrencyId!,
            denominationControllers: denominationControllers,
          );
          // Refresh the Real/Journal tabs data for Cash tab
          // MATCHING PRODUCTION LINES 3997-4002
          if (_tabController.index == 0 && selectedLocationId != null && selectedLocationId!.isNotEmpty) {
            selectedCashLocationIdForFlow = selectedLocationId;
            _fetchLocationStockFlow(selectedLocationId!);
            // Also reload recent cash endings
            _loadRecentCashEndings(selectedLocationId!);
          }
          // Refresh data
          _refreshData();
        } else {
          IntegrationUtils.showErrorMessage(
            context: context,
            message: errorMessage ?? 'Failed to save cash ending',
          );
        }
      },
    );
  }

  Future<void> _fetchLocationStockFlow(String locationId, {bool isLoadMore = false}) async {
    // Get app state for company_id
    final appState = ref.read(appStateProvider);
    final companyId = appState.companyChoosen;
    
    if (companyId.isEmpty || selectedStoreId == null || selectedStoreId!.isEmpty) {
      return;
    }
    
    await CashEndingCoordinator.fetchLocationStockFlow(
      context: context,
      locationId: locationId,
      companyId: companyId,
      storeId: selectedStoreId!,
      isLoadMore: isLoadMore,
      currentOffset: flowsOffset,
      onFlowsLoaded: (actualFlowsList, summary, isLoading, hasMore) {
        if (mounted) {
          setState(() {
            if (isLoadMore) {
              actualFlows.addAll(actualFlowsList);
              flowsOffset += flowsLimit;
            } else {
              actualFlows = actualFlowsList;
              flowsOffset = flowsLimit;
            }
            locationSummary = summary;
            isLoadingFlows = isLoading;
            hasMoreFlows = hasMore;
            selectedCashLocationIdForFlow = locationId;
          });
        }
      },
    );
  }

  Future<void> _fetchRecentBankTransactions() async {
    final appState = ref.read(appStateProvider);
    final companyId = appState.companyChoosen;
    
    await CashEndingCoordinator.fetchRecentBankTransactions(
      context: context,
      companyId: companyId,
      selectedStoreId: selectedStoreId,
      selectedBankLocationId: selectedBankLocationId,
      onTransactionsLoaded: (transactions, isLoading) {
        if (mounted) {
          setState(() {
            recentBankTransactions = transactions;
            isLoadingBankTransactions = isLoading;
          });
        }
      },
    );
  }

  Future<void> _saveBankBalance() async {
    if (selectedBankLocationId == null || bankAmountController.text.trim().isEmpty) {
      IntegrationUtils.showErrorMessage(
        context: context,
        message: 'Please select a location and enter an amount',
      );
      return;
    }

    // Get app state for company_id and user_id
    final appState = ref.read(appStateProvider);
    final companyId = appState.companyChoosen;
    final userId = appState.user['user_id'] as String?;

    await CashEndingCoordinator.saveBankBalance(
      context: context,
      companyId: companyId,
      userId: userId,
      selectedStoreId: selectedStoreId,
      selectedBankLocationId: selectedBankLocationId,
      bankAmountController: bankAmountController,
      selectedBankCurrencyType: selectedBankCurrencyType,
      currencyTypes: currencyTypes,
      onSaveComplete: (success, {errorMessage, amount}) {
        _showBankBalanceResultDialog(
          isSuccess: success,
          amount: amount,
          errorMessage: errorMessage,
        );
        if (success) {
          bankAmountController.clear();
          
          // Refresh the transaction list
          _fetchRecentBankTransactions();
          
          // Refresh the Real/Journal tabs data
          // MATCHING PRODUCTION LINES 2559-2562
          if (selectedBankLocationId != null && selectedBankLocationId!.isNotEmpty) {
            selectedCashLocationIdForFlow = selectedBankLocationId;
            _fetchLocationStockFlow(selectedBankLocationId!);
          }
          
          _refreshData();
        }
      },
    );
  }

  Future<void> _fetchAllBankTransactions({bool loadMore = false, Function? updateUI}) async {
    final appState = ref.read(appStateProvider);
    final companyId = appState.companyChoosen;
    
    await CashEndingCoordinator.fetchAllBankTransactions(
      context: context,
      companyId: companyId,
      selectedStoreId: selectedStoreId,
      loadMore: loadMore,
      updateUI: updateUI as dynamic Function()? ?? () {},
      selectedBankLocationId: selectedBankLocationId,
      onTransactionsLoaded: (transactions, isLoading, hasMore, offset) {
        if (mounted) {
          setState(() {
            if (loadMore) {
              allBankTransactions.addAll(transactions);
            } else {
              allBankTransactions = transactions;
            }
            isLoadingAllTransactions = isLoading;
            hasMoreTransactions = hasMore;
            transactionOffset = offset;
          });
        }
      },
    );
  }

  Future<void> _saveBankLocationCurrency() async {
    // Get app state for company_id and user_id
    final appState = ref.read(appStateProvider);
    final companyId = appState.companyChoosen;
    final userId = appState.user['user_id'] as String?;

    await CashEndingCoordinator.saveBankLocationCurrency(
      context: context,
      companyId: companyId,
      userId: userId,
      selectedBankLocationId: selectedBankLocationId,
      tempSelectedBankCurrency: tempSelectedBankCurrency,
      onSaveComplete: (success, {errorMessage}) {
        if (mounted) {
          setState(() {
            isSavingBankCurrency = false;
            if (success) {
              selectedBankCurrencyType = tempSelectedBankCurrency;
              isSettingBankCurrency = false;
              tempSelectedBankCurrency = null;
            }
          });
        }
        if (!success && errorMessage != null) {
          IntegrationUtils.showErrorMessage(
            context: context,
            message: errorMessage,
          );
        }
      },
    );
  }

  void _resetTransactionState() {
    IntegrationUtils.resetTransactionStateData(
      setAllBankTransactions: (transactions) => allBankTransactions = transactions,
      setIsLoadingAllTransactions: (isLoading) => isLoadingAllTransactions = isLoading,
      setHasMoreTransactions: (hasMore) => hasMoreTransactions = hasMore,
      setTransactionOffset: (offset) => transactionOffset = offset,
    );
  }

  Future<void> _fetchVaultBalance() async {
    await CashEndingCoordinator.fetchVaultBalance(
      context: context,
      selectedVaultLocationId: selectedVaultLocationId,
      onBalanceLoaded: (balanceData, isLoading) {
        if (mounted) {
          setState(() {
            vaultBalanceData = balanceData;
            isLoadingVaultBalance = isLoading;
          });
        }
      },
    );
  }

  Future<void> _saveVaultBalance() async {
    final validation = IntegrationUtils.validateSaveData(
      selectedLocationId: selectedVaultLocationId,
      selectedCurrencyId: selectedVaultCurrencyId,
      denominationControllers: denominationControllers,
      tabType: 'vault',
    );

    if (!(validation['isValid'] as bool? ?? false)) {
      IntegrationUtils.showErrorMessage(
        context: context,
        message: validation['errorMessage'] as String? ?? 'Validation failed',
      );
      return;
    }

    if (vaultTransactionType == null) {
      IntegrationUtils.showErrorMessage(
        context: context,
        message: 'Please select transaction type (In/Out)',
      );
      return;
    }

    // Get app state for company_id and user_id
    final appState = ref.read(appStateProvider);
    final companyId = appState.companyChoosen;
    final userId = appState.user['user_id'] as String?;

    await CashEndingCoordinator.saveVaultBalance(
      context: context,
      companyId: companyId,
      userId: userId,
      selectedStoreId: selectedStoreId,
      selectedVaultLocationId: selectedVaultLocationId,
      vaultTransactionType: vaultTransactionType,
      selectedVaultCurrencyId: selectedVaultCurrencyId,
      denominationControllers: denominationControllers,
      companyCurrencies: companyCurrencies,
      currencyDenominations: currencyDenominations,
      onSaveComplete: (success, {errorMessage, savedTotal}) {
        if (success) {
          // Use calculated total amount instead of savedTotal from response
          final calculatedTotal = _calculateTotalAmount(tabType: 'vault').toDouble();
          _showSuccessBottomSheet(calculatedTotal);
          // Clear denomination controllers after successful save
          IntegrationUtils.clearDenominationControllers(
            currencyId: selectedVaultCurrencyId!,
            denominationControllers: denominationControllers,
          );
          // Reset transaction type
          setState(() {
            vaultTransactionType = null;
          });
          
          // Refresh vault balance
          _fetchVaultBalance();
          
          // Refresh the Real/Journal tabs data for Vault tab
          // MATCHING PRODUCTION LINES 3816-3819
          if (selectedVaultLocationId != null && selectedVaultLocationId!.isNotEmpty) {
            selectedCashLocationIdForFlow = selectedVaultLocationId;
            _fetchLocationStockFlow(selectedVaultLocationId!);
          }
          // Refresh data
          _refreshData();
        } else {
          IntegrationUtils.showErrorMessage(
            context: context,
            message: errorMessage ?? 'Failed to save vault balance',
          );
        }
      },
    );
  }

  // UI method delegations - these will delegate to extracted UI components
  void _showStoreSelector() {
    StoreSelectorSheet.showStoreSelector(
      context: context,
      ref: ref,
      stores: stores,
      selectedStoreId: selectedStoreId,
      appStateProvider: appStateProvider,
      onStoreSelected: (storeId) {
        setState(() {
          selectedStoreId = storeId;
        });
      },
      fetchLocations: _fetchLocations,
      refreshData: _refreshData,
    );
  }

  void _showLocationSelector(String locationType) {
    // Get the appropriate locations and selected location based on type
    final List<Map<String, dynamic>> locations;
    final String? selectedLocation;
    final bool isLoading;
    
    switch (locationType) {
      case 'cash':
        locations = cashLocations;
        selectedLocation = selectedLocationId;
        isLoading = isLoadingCashLocations;
        break;
      case 'bank':
        locations = bankLocations;
        selectedLocation = selectedBankLocationId;
        isLoading = isLoadingBankLocations;
        break;
      case 'vault':
        locations = vaultLocations;
        selectedLocation = selectedVaultLocationId;
        isLoading = isLoadingVaultLocations;
        break;
      default:
        return;
    }

    if (isLoading) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Loading $locationType locations...')),
      );
      return;
    }

    // Use the new LocationSelectorSheet for consistency
    LocationSelectorSheet.showLocationSelector(
      context: context,
      locationType: locationType,
      locations: locations,
      selectedLocationId: selectedLocation,
      currencyTypes: currencyTypes,
      onLocationSelected: (locationId, location) {
        _onLocationSelected(locationId, location, locationType);
      },
    );
  }

  void _onLocationSelected(String locationId, Map<String, dynamic> location, String locationType) {
    setState(() {
      if (locationType == 'cash') {
        selectedLocationId = locationId;
      } else if (locationType == 'bank') {
        selectedBankLocationId = locationId;
        
        // Reset currency set mode when changing location
        isSettingBankCurrency = false;
        tempSelectedBankCurrency = null;
        
        // Get currency_id from the selected bank location
        final locationCurrencyId = location['currency_id']?.toString();
        final locationCurrencyCode = location['currency_code']?.toString();
        if (locationCurrencyId != null && locationCurrencyId.isNotEmpty) {
          // Auto-select the currency based on location's currency_id
          selectedBankCurrencyType = locationCurrencyId;
        } else if (locationCurrencyCode != null && locationCurrencyCode.isNotEmpty) {
          // Try to find currency_id using currency_code
          final matchingCurrency = currencyTypes.firstWhere(
            (currency) => currency['currency_code'] == locationCurrencyCode,
            orElse: () => <String, dynamic>{},
          );
          if (matchingCurrency.isNotEmpty) {
            selectedBankCurrencyType = matchingCurrency['currency_id']?.toString();
          } else {
          }
        } else {
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
    // CRITICAL: This happens OUTSIDE setState matching production lines 1568-1576
    if (locationId.isNotEmpty) {
      selectedCashLocationIdForFlow = locationId;
      _fetchLocationStockFlow(locationId);
      
      // Also load recent cash endings for compatibility (cash tab only)
      if (locationType == 'cash') {
        _loadRecentCashEndings(locationId);
      }
    }
  }

  void _showSuccessBottomSheet(double savedTotal) {
    ResultDialogs.showSuccessBottomSheet(
      context: context,
      savedTotal: savedTotal,
      tabController: _tabController,
      companyCurrencies: companyCurrencies,
      selectedBankCurrencyType: selectedBankCurrencyType,
      selectedVaultCurrencyId: selectedVaultCurrencyId,
      getBaseCurrency: getBaseCurrency,
      currencyHasData: (currencyId) => CashEndingCoordinator.currencyHasData(
        currencyId: currencyId,
        denominationControllers: denominationControllers,
      ),
    );
  }

  void _showFilterBottomSheet() {
    FilterBottomSheet.showFilterBottomSheet(
      context: context,
      selectedFilter: selectedFilter,
      onFilterSelected: (filter) {
        setState(() {
          selectedFilter = filter;
        });
      },
    );
  }

  void _showAllTransactionsBottomSheet() {
    TransactionsBottomSheet.showAllTransactionsBottomSheet(
      context: context,
      allBankTransactions: allBankTransactions,
      hasMoreTransactions: hasMoreTransactions,
      isLoadingAllTransactions: isLoadingAllTransactions,
      bankLocations: bankLocations,
      currencyTypes: currencyTypes,
      fetchAllBankTransactions: _fetchAllBankTransactions,
      resetTransactionState: _resetTransactionState,
    );
  }

  void _showBankBalanceResultDialog({
    required bool isSuccess,
    String? amount,
    String? errorMessage,
  }) {
    ResultDialogs.showBankBalanceResultDialog(
      context: context,
      isSuccess: isSuccess,
      amount: amount,
      errorMessage: errorMessage,
    );
  }

  void _showRealDetailBottomSheet(ActualFlow flow, {String locationType = 'cash'}) {
    RealDetailBottomSheet.showRealDetailBottomSheet(
      context: context,
      flow: flow,
      locationSummary: locationSummary,
      getBaseCurrency: getBaseCurrency,
      formatBalance: FormattingUtils.formatBalance,
      formatTransactionAmount: FormattingUtils.formatTransactionAmount,
      formatCurrency: FormattingUtils.formatCurrency,
      locationType: locationType,
    );
  }

}