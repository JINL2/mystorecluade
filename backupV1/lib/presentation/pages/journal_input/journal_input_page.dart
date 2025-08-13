import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';
import '../../providers/app_state_provider.dart';
import '../homepage/providers/homepage_providers.dart';
import '../../../core/themes/toss_colors.dart';
import '../../../core/themes/toss_text_styles.dart';
import '../../../core/themes/toss_spacing.dart';
import '../../../core/themes/toss_border_radius.dart';
import '../../../core/themes/toss_shadows.dart';

// Custom number formatter for adding commas
class ThousandsSeparatorInputFormatter extends TextInputFormatter {
  static const separator = ',';

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Short-circuit if the new value is empty
    if (newValue.text.isEmpty) {
      return newValue;
    }

    // Handle deletion
    if (oldValue.text.length > newValue.text.length) {
      return newValue;
    }

    // Remove all commas
    final String newValueText = newValue.text.replaceAll(separator, '');
    
    // Check if it's a valid number
    if (int.tryParse(newValueText) == null) {
      return oldValue;
    }

    // Format with commas
    final formatter = NumberFormat('#,###');
    final newText = formatter.format(int.parse(newValueText));

    // Calculate the new cursor position
    final int newTextLength = newText.length;
    final int selectionIndex = newValue.selection.end;
    int newSelectionIndex = selectionIndex;
    
    // Adjust cursor position based on comma insertions
    final int commasInOldText = oldValue.text.split(separator).length - 1;
    final int commasInNewText = newText.split(separator).length - 1;
    
    if (commasInNewText > commasInOldText) {
      // A comma was added
      newSelectionIndex += (commasInNewText - commasInOldText);
    }

    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newSelectionIndex.clamp(0, newTextLength)),
    );
  }
}

/// Toss-style Journal Input Page
/// Following Toss Design Principles:
/// 1. Minimalist & Clean - White space, clear hierarchy
/// 2. Micro-interactions - Subtle animations and feedback
/// 3. Bold Typography - Clear text hierarchy
/// 4. Soft Shadows - 2-8% opacity for depth
/// 5. Rounded Corners - 12-16px radius
/// 6. Single Actions - One primary CTA
/// 7. Progressive Disclosure - Information revealed as needed
class JournalInputPage extends ConsumerStatefulWidget {
  const JournalInputPage({super.key});

  static String routeName = 'journalInput';
  static String routePath = '/journal-input';

  @override
  ConsumerState<JournalInputPage> createState() => _JournalInputPageState();
}

class _JournalInputPageState extends ConsumerState<JournalInputPage>
    with TickerProviderStateMixin {
  // Animation Controllers
  late AnimationController _pageAnimationController;
  late AnimationController _balanceAnimationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;

  // Transaction data - starts empty
  final List<Map<String, dynamic>> _transactions = [];
  double _debitTotal = 0;
  double _creditTotal = 0;
  
  // Entry date - defaults to today
  DateTime _entryDate = DateTime.now();
  
  // Text controller for description
  final TextEditingController _descriptionController = TextEditingController();
  
  // Focus node for keyboard management
  final FocusNode _descriptionFocusNode = FocusNode();
  
  // Controllers for add transaction bottom sheet
  final TextEditingController _accountController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _transactionDescController = TextEditingController();
  String _selectedTransactionType = 'debit';
  
  // Account data from Supabase
  List<Map<String, dynamic>> _accounts = [];
  Map<String, dynamic>? _selectedAccount;
  bool _isLoadingAccounts = false;
  
  // Cash location data
  List<Map<String, dynamic>> _cashLocations = [];
  Map<String, dynamic>? _selectedCashLocation;
  bool _isLoadingCashLocations = false;
  
  // Counterparty data
  List<Map<String, dynamic>> _counterparties = [];
  Map<String, dynamic>? _selectedCounterparty;
  bool _isLoadingCounterparties = false;
  
  // Debt related data
  String? _selectedDebtCategory;
  final List<String> _debtCategories = ['note', 'account', 'loan', 'other'];
  final TextEditingController _interestRateController = TextEditingController();
  DateTime? _issueDate;
  DateTime? _dueDate;
  
  // Fixed Asset related data
  final TextEditingController _fixedAssetNameController = TextEditingController();
  final TextEditingController _usefulLifeController = TextEditingController();
  DateTime? _acquisitionDate;
  
  // Method to fetch cash locations
  Future<void> _fetchCashLocations(void Function(void Function())? setModalState) async {
    if (!mounted) return;
    
    final appState = ref.read(appStateProvider);
    final selectedCompanyId = appState.companyChoosen;
    final selectedStoreId = appState.storeChoosen;
    
    if (selectedCompanyId.isEmpty) {
      print('No company selected');
      return;
    }
    
    // Update loading state
    if (setModalState != null) {
      setModalState(() {
        _isLoadingCashLocations = true;
      });
    } else {
      setState(() {
        _isLoadingCashLocations = true;
      });
    }
    
    try {
      final supabase = Supabase.instance.client;
      
      // Build query based on whether store is selected (Headquarters = empty string)
      final query = supabase
          .from('cash_locations')
          .select('cash_location_id, location_name, location_type')
          .eq('company_id', selectedCompanyId);
      
      // If store is empty (Headquarters), filter for null store_id
      // Otherwise filter for the specific store_id
      final response = selectedStoreId.isEmpty
          ? await query.isFilter('store_id', null)
          : await query.eq('store_id', selectedStoreId);
      
      if (!mounted) return;
      
      // Update state
      if (setModalState != null) {
        setModalState(() {
          _cashLocations = List<Map<String, dynamic>>.from(response);
          _isLoadingCashLocations = false;
        });
      } else {
        setState(() {
          _cashLocations = List<Map<String, dynamic>>.from(response);
          _isLoadingCashLocations = false;
        });
      }
      
      print('Fetched ${_cashLocations.length} cash locations for ${selectedStoreId.isEmpty ? "Headquarters (null store_id)" : "store: $selectedStoreId"}');
    } catch (e) {
      print('Error fetching cash locations: $e');
      if (!mounted) return;
      
      // Update state
      if (setModalState != null) {
        setModalState(() {
          _isLoadingCashLocations = false;
        });
      } else {
        setState(() {
          _isLoadingCashLocations = false;
        });
      }
    }
  }
  
  // Method to fetch counterparties
  Future<void> _fetchCounterparties(void Function(void Function())? setModalState) async {
    if (!mounted) return;
    
    final appState = ref.read(appStateProvider);
    final selectedCompanyId = appState.companyChoosen;
    
    if (selectedCompanyId.isEmpty) {
      print('No company selected');
      return;
    }
    
    // Update loading state
    if (setModalState != null) {
      setModalState(() {
        _isLoadingCounterparties = true;
      });
    } else {
      setState(() {
        _isLoadingCounterparties = true;
      });
    }
    
    try {
      final supabase = Supabase.instance.client;
      final response = await supabase
          .from('counterparties')
          .select('counterparty_id, name')
          .eq('company_id', selectedCompanyId);
      
      if (!mounted) return;
      
      // Update state
      if (setModalState != null) {
        setModalState(() {
          _counterparties = List<Map<String, dynamic>>.from(response);
          _isLoadingCounterparties = false;
        });
      } else {
        setState(() {
          _counterparties = List<Map<String, dynamic>>.from(response);
          _isLoadingCounterparties = false;
        });
      }
      
      print('Fetched ${_counterparties.length} counterparties');
    } catch (e) {
      print('Error fetching counterparties: $e');
      if (!mounted) return;
      
      // Update state
      if (setModalState != null) {
        setModalState(() {
          _isLoadingCounterparties = false;
        });
      } else {
        setState(() {
          _isLoadingCounterparties = false;
        });
      }
    }
  }
  
  // Method to show counterparty selector
  void _showCounterpartySelector(void Function(void Function()) setParentState) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.6,
        ),
        decoration: const BoxDecoration(
          color: TossColors.background,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            // Handle bar
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: TossColors.gray300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            
            // Title
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Text(
                    'Select Counterparty',
                    style: TossTextStyles.h3.copyWith(
                      color: TossColors.gray900,
                    ),
                  ),
                  const Spacer(),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => Navigator.pop(context),
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        width: 32,
                        height: 32,
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.close_rounded,
                          size: 20,
                          color: TossColors.gray600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Counterparty List
            Expanded(
              child: _isLoadingCounterparties
                  ? Center(
                      child: CircularProgressIndicator(
                        color: TossColors.primary,
                      ),
                    )
                  : _counterparties.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.business_outlined,
                                size: 48,
                                color: TossColors.gray300,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'No counterparties found',
                                style: TossTextStyles.body.copyWith(
                                  color: TossColors.gray500,
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          itemCount: _counterparties.length,
                          itemBuilder: (context, index) {
                            final counterparty = _counterparties[index];
                            final isSelected = _selectedCounterparty?['counterparty_id'] == counterparty['counterparty_id'];
                            
                            return Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () {
                                  setParentState(() {
                                    _selectedCounterparty = counterparty;
                                  });
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 16,
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        color: TossColors.gray100,
                                        width: 1,
                                      ),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      // Counterparty Icon
                                      Container(
                                        width: 40,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          color: isSelected
                                              ? TossColors.primary.withOpacity(0.1)
                                              : TossColors.gray50,
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Center(
                                          child: Icon(
                                            Icons.business,
                                            size: 20,
                                            color: isSelected
                                                ? TossColors.primary
                                                : TossColors.gray500,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      // Counterparty Info
                                      Expanded(
                                        child: Text(
                                          counterparty['name'] ?? 'Unknown',
                                          style: TossTextStyles.body.copyWith(
                                            color: TossColors.gray900,
                                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      // Check Icon
                                      if (isSelected)
                                        Icon(
                                          Icons.check_circle,
                                          size: 20,
                                          color: TossColors.primary,
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
  
  // Method to show cash location selector
  void _showCashLocationSelector(void Function(void Function()) setParentState) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.6,
        ),
        decoration: const BoxDecoration(
          color: TossColors.background,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            // Handle bar
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: TossColors.gray300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            
            // Title
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Text(
                    'Select Cash Location',
                    style: TossTextStyles.h3.copyWith(
                      color: TossColors.gray900,
                    ),
                  ),
                  const Spacer(),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => Navigator.pop(context),
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        width: 32,
                        height: 32,
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.close_rounded,
                          size: 20,
                          color: TossColors.gray600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Cash Location List
            Expanded(
              child: _isLoadingCashLocations
                  ? Center(
                      child: CircularProgressIndicator(
                        color: TossColors.primary,
                      ),
                    )
                  : _cashLocations.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.account_balance_wallet_outlined,
                                size: 48,
                                color: TossColors.gray300,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'No cash locations found',
                                style: TossTextStyles.body.copyWith(
                                  color: TossColors.gray500,
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          itemCount: _cashLocations.length,
                          itemBuilder: (context, index) {
                            final location = _cashLocations[index];
                            final isSelected = _selectedCashLocation?['cash_location_id'] == location['cash_location_id'];
                            
                            return Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () {
                                  setParentState(() {
                                    _selectedCashLocation = location;
                                  });
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 16,
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        color: TossColors.gray100,
                                        width: 1,
                                      ),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      // Location Icon
                                      Container(
                                        width: 40,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          color: isSelected
                                              ? TossColors.primary.withOpacity(0.1)
                                              : TossColors.gray50,
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Center(
                                          child: Icon(
                                            Icons.location_on_outlined,
                                            size: 20,
                                            color: isSelected
                                                ? TossColors.primary
                                                : TossColors.gray500,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      // Location Info
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              location['location_name'] ?? 'Unknown Location',
                                              style: TossTextStyles.body.copyWith(
                                                color: TossColors.gray900,
                                                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                                              ),
                                            ),
                                            if (location['location_type'] != null)
                                              Text(
                                                location['location_type'],
                                                style: TossTextStyles.caption.copyWith(
                                                  color: TossColors.gray500,
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                      // Check Icon
                                      if (isSelected)
                                        Icon(
                                          Icons.check_circle,
                                          size: 20,
                                          color: TossColors.primary,
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    // No mock transactions - start with empty list
  }

  void _initializeAnimations() {
    // Page entrance animation
    _pageAnimationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    // Balance update animation
    _balanceAnimationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _pageAnimationController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.05),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _pageAnimationController,
      curve: const Interval(0.2, 1.0, curve: Curves.easeOutCubic),
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.95,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _pageAnimationController,
      curve: Curves.easeOutBack,
    ));

    _pageAnimationController.forward();
  }


  void _calculateTotals() {
    _debitTotal = _transactions
        .where((t) => t['type'] == 'debit')
        .fold(0, (sum, t) => sum + (t['amount'] as double));
    _creditTotal = _transactions
        .where((t) => t['type'] == 'credit')
        .fold(0, (sum, t) => sum + (t['amount'] as double));
    
    // Trigger balance animation
    _balanceAnimationController.forward(from: 0);
  }

  void _resetForm() {
    setState(() {
      // Clear transactions and totals
      _transactions.clear();
      _debitTotal = 0;
      _creditTotal = 0;
      
      // Reset entry date to today
      _entryDate = DateTime.now();
      
      // Clear description
      _descriptionController.clear();
      
      // Clear all transaction-related controllers
      _accountController.clear();
      _amountController.clear();
      _transactionDescController.clear();
      _interestRateController.clear();
      _fixedAssetNameController.clear();
      _usefulLifeController.text = '1';
      
      // Reset selections
      _selectedTransactionType = 'debit';
      _selectedAccount = null;
      _selectedCashLocation = null;
      _selectedCounterparty = null;
      _selectedDebtCategory = null;
      _issueDate = null;
      _dueDate = null;
      _acquisitionDate = DateTime.now();
      
      // Clear lists
      _cashLocations.clear();
      _counterparties.clear();
    });
  }

  Future<void> _submitJournalEntry() async {
    try {
      // Show loading
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const CircularProgressIndicator(),
          ),
        ),
      );

      final appState = ref.read(appStateProvider);
      final supabase = Supabase.instance.client;
      
      // Prepare p_lines data
      final List<Map<String, dynamic>> pLines = [];
      
      for (var transaction in _transactions) {
        final Map<String, dynamic> line = {
          'account_id': transaction['account_id'],
          'description': (transaction['description'] != null && transaction['description'].toString().isNotEmpty) 
              ? transaction['description'] 
              : null,
          'debit': transaction['type'] == 'debit' ? transaction['amount'].toString() : '0',
          'credit': transaction['type'] == 'credit' ? transaction['amount'].toString() : '0',
        };
        
        // Add counterparty for payable/receivable accounts
        if (transaction['category_tag'] != null &&
            (transaction['category_tag'].toString().toLowerCase() == 'payable' ||
             transaction['category_tag'].toString().toLowerCase() == 'receivable')) {
          // Only add counterparty_id if it exists, otherwise don't include it in the line
          if (transaction['counterparty_id'] != null) {
            line['counterparty_id'] = transaction['counterparty_id'];
          }
          
          // Add debt information if present
          if (transaction['counterparty_id'] != null && 
              (transaction['debt_category'] != null || 
               transaction['interest_rate'] != null || 
               transaction['issue_date'] != null || 
               transaction['due_date'] != null)) {
            final Map<String, dynamic> debt = {
              'direction': transaction['category_tag'].toString().toLowerCase(),
              'category': transaction['debt_category'] ?? 'other',
              'counterparty_id': transaction['counterparty_id'],  // Add counterparty_id to debt
              'original_amount': transaction['amount'].toString(),
              'interest_rate': (transaction['interest_rate'] ?? 0.0).toString(),
              'interest_account_id': '',  // Add if you have this data
              'interest_due_day': 0,  // Add if you have this data
              'issue_date': transaction['issue_date'] ?? DateFormat('yyyy-MM-dd').format(DateTime.now()),
              'due_date': transaction['due_date'] ?? DateFormat('yyyy-MM-dd').format(DateTime.now().add(const Duration(days: 30))),
              'description': transaction['description'],
            };
            line['debt'] = debt;
          }
        }
        
        // Add cash location for cash accounts
        if (transaction['cash_location_id'] != null) {
          line['cash'] = {
            'cash_location_id': transaction['cash_location_id'],
          };
        }
        
        // Add fixed asset information
        if (transaction['category_tag'] != null &&
            transaction['category_tag'].toString().toLowerCase() == 'fixedasset' &&
            transaction['fixed_asset_name'] != null) {
          line['fix_asset'] = {
            'asset_name': transaction['fixed_asset_name'],
            'acquisition_date': transaction['acquisition_date'] ?? DateFormat('yyyy-MM-dd').format(DateTime.now()),
            'acquisition_cost': transaction['amount'].toString(),
            'useful_life_years': transaction['useful_life'] ?? 1,
            'salvage_value': 0,  // You can add a field for this if needed
          };
        }
        
        pLines.add(line);
      }
      
      // Call the RPC
      final response = await supabase.rpc(
        'insert_journal_with_everything',
        params: {
          'p_company_id': appState.companyChoosen,
          'p_store_id': appState.storeChoosen.isEmpty ? null : appState.storeChoosen,
          'p_created_by': appState.user['user_id'],
          'p_entry_date': _entryDate.toIso8601String(),
          'p_description': _descriptionController.text.isEmpty ? null : _descriptionController.text,
          'p_base_amount': _debitTotal,
          'p_lines': pLines,
          'p_counterparty_id': null,  // This is at journal level, usually null
          'p_if_cash_location_id': null,  // This is for special cases, usually null
        },
      );
      
      // Close loading dialog
      if (mounted) {
        Navigator.pop(context);
      }
      
      // Show success popup
      if (mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: TossColors.success.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.check_circle_rounded,
                        color: TossColors.success,
                        size: 32,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Success!',
                      style: TossTextStyles.h3.copyWith(
                        color: TossColors.gray900,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Journal entry has been submitted successfully',
                      textAlign: TextAlign.center,
                      style: TossTextStyles.body.copyWith(
                        color: TossColors.gray600,
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          // Reset the form
                          _resetForm();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: TossColors.primary,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'OK',
                          style: TossTextStyles.bodyLarge.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }
    } catch (e) {
      // Close loading dialog if still open
      if (mounted) {
        Navigator.pop(context);
      }
      
      // Show error popup
      if (mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: TossColors.error.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.error_rounded,
                        color: TossColors.error,
                        size: 32,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Error',
                      style: TossTextStyles.h3.copyWith(
                        color: TossColors.gray900,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Failed to submit journal entry',
                      textAlign: TextAlign.center,
                      style: TossTextStyles.body.copyWith(
                        color: TossColors.gray600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: TossColors.gray50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        e.toString(),
                        textAlign: TextAlign.center,
                        style: TossTextStyles.caption.copyWith(
                          color: TossColors.gray700,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: TossColors.primary,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'Try Again',
                          style: TossTextStyles.bodyLarge.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }
    }
  }

  @override
  void dispose() {
    _pageAnimationController.dispose();
    _balanceAnimationController.dispose();
    _descriptionController.dispose();
    _descriptionFocusNode.dispose();
    _accountController.dispose();
    _amountController.dispose();
    _transactionDescController.dispose();
    _interestRateController.dispose();
    _fixedAssetNameController.dispose();
    _usefulLifeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Watch the data providers to ensure data is loaded
    final userCompaniesAsync = ref.watch(userCompaniesProvider);
    final categoriesAsync = ref.watch(categoriesWithFeaturesProvider);
    
    // Watch app state and selections
    final appState = ref.watch(appStateProvider);
    final selectedCompany = ref.watch(selectedCompanyProvider);
    final selectedStore = ref.watch(selectedStoreProvider);
    
    final difference = _debitTotal - _creditTotal;
    final isBalanced = difference.abs() < 0.01; // Account for floating point

    // Show loading indicator while data is being fetched
    return userCompaniesAsync.when(
      data: (userData) => Scaffold(
      backgroundColor: TossColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Custom App Bar
            _buildAppBar(context),
            
            // Main Content
            Expanded(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: _buildContent(
                    appState,
                    selectedCompany,
                    selectedStore,
                    difference,
                    isBalanced,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      
      // Floating Action Button Area
      bottomNavigationBar: _buildBottomBar(isBalanced, difference),
      ),
      loading: () => Scaffold(
        backgroundColor: TossColors.background,
        body: Center(
          child: CircularProgressIndicator(color: TossColors.primary),
        ),
      ),
      error: (error, stack) => Scaffold(
        backgroundColor: TossColors.background,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 48, color: TossColors.error),
              const SizedBox(height: 16),
              Text('Something went wrong', style: TossTextStyles.h3),
              const SizedBox(height: 8),
              Text(error.toString(), style: TossTextStyles.caption),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => context.pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: TossColors.primary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text('Go Back', style: TossTextStyles.body),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: TossColors.background,
        border: Border(
          bottom: BorderSide(
            color: TossColors.divider,
            width: 1,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: [
            // Back Button with Ripple
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => context.pop(),
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  width: 40,
                  height: 40,
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    size: 20,
                    color: TossColors.gray900,
                  ),
                ),
              ),
            ),
            
            const SizedBox(width: 16),
            
            // Title with Animation
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: TossTextStyles.h3.copyWith(
                color: TossColors.gray900,
              ),
              child: const Text('Journal Input'),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildContent(
    AppState appState,
    dynamic selectedCompany,
    dynamic selectedStore,
    double difference,
    bool isBalanced,
  ) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.only(bottom: 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Company & Store Selection (moved to top)
          const SizedBox(height: 20),
          _buildCompanyStoreSelection(appState, selectedCompany, selectedStore),
          
          const SizedBox(height: 24),
          
          // Balance Overview with Animation (moved below location)
          ScaleTransition(
            scale: _scaleAnimation,
            child: _buildBalanceOverview(difference, isBalanced),
          ),
          
          const SizedBox(height: 32),
          
          // Transaction List
          _buildTransactionList(),
          
          const SizedBox(height: 24),
          
          // Description Input
          _buildDescriptionInput(),
          
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildBalanceOverview(double difference, bool isBalanced) {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            TossColors.primary.withOpacity(0.05),
            TossColors.primary.withOpacity(0.02),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: TossColors.primary.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          // Balance Cards Row
          Row(
            children: [
              // Debit Card
              Expanded(
                child: AnimatedBuilder(
                  animation: _balanceAnimationController,
                  builder: (context, child) {
                    return Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          HapticFeedback.lightImpact();
                          _showAddTransactionBottomSheet(defaultType: 'debit');
                        },
                        borderRadius: BorderRadius.circular(16),
                        child: _buildBalanceCard(
                          title: 'Debit',
                          amount: _debitTotal * _balanceAnimationController.value,
                          count: _transactions.where((t) => t['type'] == 'debit').length,
                          color: TossColors.info,
                          icon: Icons.add_circle_outline_rounded,
                        ),
                      ),
                    );
                  },
                ),
              ),
              
              const SizedBox(width: 12),
              
              // Credit Card
              Expanded(
                child: AnimatedBuilder(
                  animation: _balanceAnimationController,
                  builder: (context, child) {
                    return Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          HapticFeedback.lightImpact();
                          _showAddTransactionBottomSheet(defaultType: 'credit');
                        },
                        borderRadius: BorderRadius.circular(16),
                        child: _buildBalanceCard(
                          title: 'Credit',
                          amount: _creditTotal * _balanceAnimationController.value,
                          count: _transactions.where((t) => t['type'] == 'credit').length,
                          color: TossColors.loss,
                          icon: Icons.remove_circle_outline_rounded,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          
          // Balance Status Bar
          if (!isBalanced) ...[
            const SizedBox(height: 16),
            _buildBalanceStatusBar(difference),
          ],
        ],
      ),
    );
  }

  Widget _buildBalanceCard({
    required String title,
    required double amount,
    required int count,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: TossColors.background,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            offset: const Offset(0, 2),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  size: 18,
                  color: color,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: TossTextStyles.label.copyWith(
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            _formatNumber(amount),
            style: TossTextStyles.h2.copyWith(
              color: TossColors.gray900,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '$count entries',
            style: TossTextStyles.caption.copyWith(
              color: TossColors.gray500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceStatusBar(double difference) {
    final percentage = difference.abs() / (_debitTotal + _creditTotal) * 100;
    
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: TossColors.warning.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: TossColors.warning.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.warning_amber_rounded,
            size: 18,
            color: TossColors.warning,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Unbalanced by ${_formatNumber(difference.abs())} (${percentage.toStringAsFixed(1)}%)',
              style: TossTextStyles.bodySmall.copyWith(
                color: TossColors.gray700,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompanyStoreSelection(
    AppState appState,
    dynamic selectedCompany,
    dynamic selectedStore,
  ) {
    // Get the display values from the properly loaded data
    String companyDisplayName = 'Select Company';
    String storeDisplayName = 'Headquarters';  // Default to Headquarters
    
    // Set company display name
    if (selectedCompany != null && selectedCompany['company_name'] != null) {
      companyDisplayName = selectedCompany['company_name'];
    }
    
    // Set store display name
    if (appState.storeChoosen.isEmpty) {
      // If no store is selected, show Headquarters
      storeDisplayName = 'Headquarters';
    } else if (selectedStore != null && selectedStore['store_name'] != null) {
      // If a store is selected, show its name
      storeDisplayName = selectedStore['store_name'];
    }
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Location',
            style: TossTextStyles.bodySmall.copyWith(
              color: TossColors.gray500,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.5,
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Company Selector - always visible
          _buildTossSelector(
            label: 'Company',
            value: companyDisplayName,
            isEmpty: appState.companyChoosen.isEmpty,
            onTap: () => _showCompanySelector(appState),
          ),
          
          // Store Selector - visible when company is selected
          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutCubic,
            child: appState.companyChoosen.isNotEmpty
                ? Column(
                    children: [
                      const SizedBox(height: 16),
                      _buildTossSelector(
                        label: 'Store',
                        value: storeDisplayName,
                        isEmpty: appState.storeChoosen.isEmpty,
                        onTap: () => _showStoreSelector(selectedCompany),
                      ),
                    ],
                  )
                : const SizedBox.shrink(),
          ),
          
          const SizedBox(height: 32),
          
          // Entry Date Section
          Text(
            'Entry Date',
            style: TossTextStyles.bodySmall.copyWith(
              color: TossColors.gray500,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.5,
            ),
          ),
          
          const SizedBox(height: 16),
          
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(TossBorderRadius.lg),
              boxShadow: TossShadows.shadow2,
            ),
            child: Material(
              color: TossColors.background,
              borderRadius: BorderRadius.circular(TossBorderRadius.lg),
              child: InkWell(
                onTap: () => _selectDate(context),
                borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                splashColor: TossColors.primary.withOpacity(0.05),
                highlightColor: TossColors.primary.withOpacity(0.03),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                  child: Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: TossColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                        ),
                        child: Icon(
                          Icons.calendar_today_rounded,
                          size: 18,
                          color: TossColors.primary,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              DateFormat('yyyy-MM-dd').format(_entryDate),
                              style: TossTextStyles.bodyLarge.copyWith(
                                color: TossColors.gray900,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: TossColors.gray100,
                          borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                        ),
                        child: Icon(
                          Icons.chevron_right_rounded,
                          size: 18,
                          color: TossColors.gray500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTossSelector({
    required String label,
    required String value,
    required bool isEmpty,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        boxShadow: TossShadows.shadow2,
      ),
      child: Material(
        color: TossColors.background,
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(TossBorderRadius.lg),
          splashColor: TossColors.primary.withOpacity(0.05),
          highlightColor: TossColors.primary.withOpacity(0.03),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        style: TossTextStyles.caption.copyWith(
                          color: TossColors.gray500,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        value,
                        style: TossTextStyles.bodyLarge.copyWith(
                          color: isEmpty ? TossColors.gray400 : TossColors.gray900,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: TossColors.gray100,
                    borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                  ),
                  child: Icon(
                    Icons.chevron_right_rounded,
                    size: 18,
                    color: TossColors.gray500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTransactionList() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Transactions',
                style: TossTextStyles.label.copyWith(
                  color: TossColors.gray600,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: TossColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${_transactions.length}',
                  style: TossTextStyles.caption.copyWith(
                    color: TossColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          // Show transactions if any, otherwise show add button only
          if (_transactions.isNotEmpty) ...[
            // Transaction Items with Stagger Animation
            ..._transactions.asMap().entries.map((entry) {
              final index = entry.key;
              final transaction = entry.value;
              
              return TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: 1.0),
                duration: Duration(milliseconds: 300 + (index * 50)),
                curve: Curves.easeOutCubic,
                builder: (context, value, child) {
                  return Transform.translate(
                    offset: Offset(0, 20 * (1 - value)),
                    child: Opacity(
                      opacity: value,
                      child: _buildTransactionItem(transaction, index),
                    ),
                  );
                },
              );
            }).toList(),
            const SizedBox(height: 16),
          ],
          
          // Add Transaction Button
          _buildAddTransactionButton(),
        ],
      ),
    );
  }

  Widget _buildTransactionItem(Map<String, dynamic> transaction, int index) {
    final isDebit = transaction['type'] == 'debit';
    final color = isDebit ? TossColors.info : TossColors.loss;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            // Edit transaction
          },
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: TossColors.background,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: TossColors.divider,
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.02),
                  offset: const Offset(0, 1),
                  blurRadius: 4,
                ),
              ],
            ),
            child: Row(
              children: [
                // Type Badge with Animation
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      isDebit ? 'DR' : 'CR',
                      style: TossTextStyles.caption.copyWith(
                        color: color,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(width: 12),
                
                // Account Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        spacing: 8,
                        runSpacing: 4,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Text(
                            transaction['account'],
                            style: TossTextStyles.body.copyWith(
                              color: TossColors.gray900,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          if (transaction['cash_location_name'] != null)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: TossColors.info.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                transaction['cash_location_name'],
                                style: TossTextStyles.caption.copyWith(
                                  color: TossColors.info,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          if (transaction['counterparty_name'] != null)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: TossColors.warning.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                transaction['counterparty_name'],
                                style: TossTextStyles.caption.copyWith(
                                  color: TossColors.warning,
                                  fontWeight: FontWeight.w500,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        transaction['description'] ?? 'Transaction',
                        style: TossTextStyles.caption.copyWith(
                          color: TossColors.gray500,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ],
                  ),
                ),
                
                // Amount
                Text(
                  _formatNumber(transaction['amount']),
                  style: TossTextStyles.bodyLarge.copyWith(
                    color: TossColors.gray900,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                
                const SizedBox(width: 8),
                
                // Delete Button
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _transactions.removeAt(index);
                        _calculateTotals();
                      });
                      
                      // Haptic feedback
                      HapticFeedback.lightImpact();
                    },
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      width: 32,
                      height: 32,
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.close_rounded,
                        size: 18,
                        color: TossColors.gray400,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAddTransactionButton() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          // Show add transaction bottom sheet
          HapticFeedback.lightImpact();
          _showAddTransactionBottomSheet();
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: TossColors.background,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: TossColors.primary.withOpacity(0.3),
              width: 1.5,
              style: BorderStyle.solid,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.add_rounded,
                size: 20,
                color: TossColors.primary,
              ),
              const SizedBox(width: 8),
              Text(
                'Add Transaction',
                style: TossTextStyles.body.copyWith(
                  color: TossColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDescriptionInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Description',
            style: TossTextStyles.label.copyWith(
              color: TossColors.gray600,
              fontWeight: FontWeight.w600,
            ),
          ),
          
          const SizedBox(height: 12),
          
          Container(
            decoration: BoxDecoration(
              color: TossColors.gray50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: TossColors.gray200,
                width: 1,
              ),
            ),
            child: TextField(
              controller: _descriptionController,
              focusNode: _descriptionFocusNode,
              maxLines: 3,
              style: TossTextStyles.body.copyWith(
                color: TossColors.gray900,
                height: 1.5,
              ),
              decoration: InputDecoration(
                hintText: 'Add notes about this journal entry...',
                hintStyle: TossTextStyles.body.copyWith(
                  color: TossColors.gray400,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.all(16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar(bool isBalanced, double difference) {
    // Check if button should be enabled
    final bool hasTransactions = _transactions.isNotEmpty;
    final bool canSubmit = hasTransactions && isBalanced;
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: TossColors.background,
        border: Border(
          top: BorderSide(
            color: TossColors.divider,
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, -2),
            blurRadius: 10,
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Warning Message with Animation
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: (hasTransactions && !isBalanced) ? 48 : 0,
              child: (hasTransactions && !isBalanced)
                  ? Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: TossColors.warning.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.info_outline_rounded,
                            size: 18,
                            color: TossColors.warning,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Balance your entries before submitting',
                              style: TossTextStyles.bodySmall.copyWith(
                                color: TossColors.gray700,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
            
            // Submit Button with Toss Style
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: canSubmit
                    ? () async {
                        // Submit journal
                        HapticFeedback.mediumImpact();
                        await _submitJournalEntry();
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: canSubmit ? TossColors.primary : TossColors.gray200,
                  foregroundColor: canSubmit ? Colors.white : TossColors.gray400,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Text(
                  'Submit Journal Input',
                  style: TossTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.w700,
                    color: canSubmit ? Colors.white : TossColors.gray400,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCompanySelector(AppState appState) {
    final companies = appState.user['companies'] as List<dynamic>? ?? [];
    final currentCompanyId = appState.companyChoosen;
    
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _buildTossBottomSheet(
        title: 'Select Company',
        items: companies.map((company) => {
          'id': company['company_id'],
          'title': company['company_name'] ?? '',
          'subtitle': '${company['store_count'] ?? 0} stores',
          'isSelected': company['company_id'] == currentCompanyId,
        }).toList(),
        onSelect: (company) {
          ref.read(appStateProvider.notifier).setCompanyChoosen(company['id']?.toString() ?? '');
          // Clear store selection when company changes
          ref.read(appStateProvider.notifier).setStoreChoosen('');
          Navigator.pop(context);
        },
      ),
    );
  }

  void _showStoreSelector(dynamic selectedCompany) {
    final stores = selectedCompany?['stores'] as List<dynamic>? ?? [];
    final appState = ref.read(appStateProvider);
    final currentStoreId = appState.storeChoosen;
    
    // Create items list with Headquarters first
    final List<Map<String, dynamic>> items = [
      // Add Headquarters as first option with null/empty value
      {
        'id': '',  // Empty string for null value
        'title': 'Headquarters',
        'subtitle': 'All stores',
        'isSelected': currentStoreId.isEmpty,
      },
      // Then add all other stores
      ...stores.map((store) => {
        'id': store['store_id'],
        'title': store['store_name'] ?? '',
        'subtitle': store['store_code'] ?? '',
        'isSelected': store['store_id'] == currentStoreId,
      }),
    ];
    
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _buildTossBottomSheet(
        title: 'Select Store',
        items: items,
        onSelect: (store) {
          ref.read(appStateProvider.notifier).setStoreChoosen(store['id']?.toString() ?? '');
          Navigator.pop(context);
        },
      ),
    );
  }

  Widget _buildTossBottomSheet({
    required String title,
    required List<Map<String, dynamic>> items,
    required Function(Map<String, dynamic>) onSelect,
  }) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.7,
      ),
      decoration: const BoxDecoration(
        color: TossColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle Bar
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: TossColors.gray200,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          // Title
          Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              title,
              style: TossTextStyles.h3.copyWith(
                color: TossColors.gray900,
              ),
            ),
          ),
          
          // Items List
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.only(bottom: 20),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                final isSelected = item['isSelected'] == true;
                
                return Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => onSelect(item),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected ? TossColors.primary.withOpacity(0.05) : Colors.transparent,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item['title']?.toString() ?? '',
                                  style: TossTextStyles.body.copyWith(
                                    color: isSelected ? TossColors.primary : TossColors.gray900,
                                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                                  ),
                                ),
                                if ((item['subtitle']?.toString() ?? '').isNotEmpty) ...[
                                  const SizedBox(height: 2),
                                  Text(
                                    item['subtitle'].toString(),
                                    style: TossTextStyles.caption.copyWith(
                                      color: isSelected ? TossColors.primary.withOpacity(0.7) : TossColors.gray500,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                          if (isSelected)
                            Icon(
                              Icons.check_rounded,
                              size: 20,
                              color: TossColors.primary,
                            )
                          else
                            Icon(
                              Icons.chevron_right_rounded,
                              size: 20,
                              color: TossColors.gray400,
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showDebtCategorySelector(void Function(void Function()) setParentState) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.4,
        ),
        decoration: const BoxDecoration(
          color: TossColors.background,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            // Handle bar
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: TossColors.gray300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            
            // Title
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Text(
                    'Select Debt Category',
                    style: TossTextStyles.h3.copyWith(
                      color: TossColors.gray900,
                    ),
                  ),
                  const Spacer(),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => Navigator.pop(context),
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        width: 32,
                        height: 32,
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.close_rounded,
                          size: 20,
                          color: TossColors.gray600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Category List
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: _debtCategories.length,
                itemBuilder: (context, index) {
                  final category = _debtCategories[index];
                  final isSelected = _selectedDebtCategory == category;
                  
                  return Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        setParentState(() {
                          _selectedDebtCategory = category;
                        });
                        Navigator.pop(context);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: TossColors.gray100,
                              width: 1,
                            ),
                          ),
                        ),
                        child: Row(
                          children: [
                            // Category Icon
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? TossColors.primary.withOpacity(0.1)
                                    : TossColors.gray50,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Center(
                                child: Icon(
                                  _getDebtCategoryIcon(category),
                                  size: 20,
                                  color: isSelected
                                      ? TossColors.primary
                                      : TossColors.gray500,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            // Category Name
                            Expanded(
                              child: Text(
                                category.substring(0, 1).toUpperCase() + category.substring(1),
                                style: TossTextStyles.body.copyWith(
                                  color: TossColors.gray900,
                                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                                ),
                              ),
                            ),
                            // Check Icon
                            if (isSelected)
                              Icon(
                                Icons.check_circle,
                                size: 20,
                                color: TossColors.primary,
                              ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  IconData _getDebtCategoryIcon(String category) {
    switch (category) {
      case 'note':
        return Icons.note_alt_outlined;
      case 'account':
        return Icons.account_balance_outlined;
      case 'loan':
        return Icons.monetization_on_outlined;
      case 'other':
        return Icons.more_horiz_outlined;
      default:
        return Icons.category_outlined;
    }
  }
  
  Future<void> _selectIssueDate(BuildContext context, void Function(void Function()) setModalState) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _issueDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: TossColors.primary,
              onPrimary: Colors.white,
              surface: TossColors.background,
              onSurface: TossColors.gray900,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: TossColors.primary,
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    
    if (picked != null && picked != _issueDate) {
      setModalState(() {
        _issueDate = picked;
      });
    }
  }
  
  Future<void> _selectDueDate(BuildContext context, void Function(void Function()) setModalState) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: TossColors.primary,
              onPrimary: Colors.white,
              surface: TossColors.background,
              onSurface: TossColors.gray900,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: TossColors.primary,
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    
    if (picked != null && picked != _dueDate) {
      setModalState(() {
        _dueDate = picked;
      });
    }
  }
  
  Future<void> _selectDate(BuildContext context) async {
    // Haptic feedback when opening date picker
    HapticFeedback.selectionClick();
    
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _entryDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      helpText: 'Select date',
      cancelText: 'Cancel',
      confirmText: 'OK',
      errorFormatText: 'Invalid date format',
      errorInvalidText: 'Enter a valid date',
      fieldHintText: 'mm/dd/yyyy',
      fieldLabelText: 'Enter date',
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: TossColors.primary,
            colorScheme: const ColorScheme.light(
              primary: TossColors.primary,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: TossColors.gray900,
              surfaceVariant: TossColors.gray50,
              onSurfaceVariant: TossColors.gray700,
            ),
            dialogBackgroundColor: Colors.white,
            dialogTheme: DialogThemeData(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28),
              ),
              elevation: 0,
              backgroundColor: Colors.white,
              surfaceTintColor: Colors.transparent,
            ),
            datePickerTheme: DatePickerThemeData(
              backgroundColor: Colors.white,
              elevation: 0,
              shadowColor: Colors.transparent,
              surfaceTintColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28),
              ),
              // Header styling - Modern Toss blue header
              headerBackgroundColor: TossColors.primary,
              headerForegroundColor: Colors.white,
              headerHelpStyle: const TextStyle(
                fontSize: 14,
                color: Colors.white70,
                fontWeight: FontWeight.w500,
              ),
              headerHeadlineStyle: const TextStyle(
                fontSize: 32,
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
              // Calendar weekday headers
              weekdayStyle: TextStyle(
                fontSize: 13,
                color: TossColors.gray500,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
              // Year selector text
              yearStyle: TextStyle(
                fontSize: 16,
                color: TossColors.gray700,
                fontWeight: FontWeight.w500,
              ),
              // Day numbers in calendar
              dayStyle: TextStyle(
                fontSize: 16,
                color: TossColors.gray900,
                fontWeight: FontWeight.w500,
              ),
              // Today's date styling - Only border, no fill
              todayBackgroundColor: MaterialStateProperty.all(
                Colors.transparent,
              ),
              todayForegroundColor: MaterialStateProperty.all(
                TossColors.primary,
              ),
              todayBorder: BorderSide(
                color: TossColors.primary,
                width: 2,
              ),
              // Selected date styling - Solid blue circle
              dayBackgroundColor: MaterialStateProperty.resolveWith((states) {
                if (states.contains(MaterialState.selected)) {
                  return TossColors.primary;
                }
                return Colors.transparent;
              }),
              dayForegroundColor: MaterialStateProperty.resolveWith((states) {
                if (states.contains(MaterialState.selected)) {
                  return Colors.white;
                }
                if (states.contains(MaterialState.disabled)) {
                  return TossColors.gray300;
                }
                return TossColors.gray900;
              }),
              dayOverlayColor: MaterialStateProperty.resolveWith((states) {
                if (states.contains(MaterialState.pressed)) {
                  return TossColors.primary.withOpacity(0.08);
                }
                if (states.contains(MaterialState.hovered)) {
                  return TossColors.gray100;
                }
                return Colors.transparent;
              }),
              // Divider styling
              dividerColor: TossColors.gray200,
              // Input field for manual date entry
              inputDecorationTheme: InputDecorationTheme(
                filled: true,
                fillColor: TossColors.gray50,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: TossColors.primary, width: 2),
                ),
                labelStyle: TextStyle(
                  fontSize: 14,
                  color: TossColors.gray600,
                ),
                hintStyle: TextStyle(
                  fontSize: 14,
                  color: TossColors.gray400,
                ),
              ),
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: TossColors.primary,
                minimumSize: const Size(88, 48),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            textTheme: const TextTheme(
              headlineLarge: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
              headlineMedium: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
              ),
              titleLarge: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
              bodyLarge: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              bodyMedium: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              labelLarge: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    
    if (picked != null && picked != _entryDate) {
      // Haptic feedback on date selection
      HapticFeedback.lightImpact();
      setState(() {
        _entryDate = picked;
      });
    }
  }
  
  String _formatNumber(double number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(0)}K';
    }
    return number.toStringAsFixed(0);
  }

  Future<void> _fetchAccounts(void Function(void Function())? setModalState) async {
    // Update both parent state and modal state if available
    void updateState(void Function() fn) {
      if (setModalState != null) {
        setModalState(fn);
      }
      setState(fn);
    }
    
    updateState(() {
      _isLoadingAccounts = true;
    });

    try {
      final supabase = Supabase.instance.client;
      final response = await supabase
          .from('accounts')
          .select('account_id, account_name, category_tag')
          .order('account_name', ascending: true);
      
      if (response != null) {
        updateState(() {
          _accounts = List<Map<String, dynamic>>.from(response);
          _isLoadingAccounts = false;
        });
        print('Loaded ${_accounts.length} accounts');
      }
    } catch (e) {
      print('Error fetching accounts: $e');
      updateState(() {
        _isLoadingAccounts = false;
      });
      // Show error message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load accounts'),
            backgroundColor: TossColors.error,
          ),
        );
      }
    }
  }

  void _showAccountSelector(void Function(void Function()) setParentState) {
    String searchQuery = '';
    
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => StatefulBuilder(
        builder: (context, setBottomSheetState) => Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.7,
        ),
        decoration: const BoxDecoration(
          color: TossColors.background,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle Bar
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: TossColors.gray200,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            
            // Title
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Text(
                    'Select Account',
                    style: TossTextStyles.h3.copyWith(
                      color: TossColors.gray900,
                    ),
                  ),
                  const Spacer(),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => Navigator.pop(context),
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        width: 32,
                        height: 32,
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.close_rounded,
                          size: 20,
                          color: TossColors.gray600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Search Bar (Optional)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                decoration: BoxDecoration(
                  color: TossColors.gray50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: TossColors.gray200,
                    width: 1,
                  ),
                ),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search accounts...',
                    hintStyle: TossTextStyles.body.copyWith(
                      color: TossColors.gray400,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.all(12),
                    prefixIcon: Icon(
                      Icons.search_rounded,
                      color: TossColors.gray400,
                      size: 20,
                    ),
                  ),
                  onChanged: (value) {
                    setBottomSheetState(() {
                      searchQuery = value.toLowerCase();
                    });
                  },
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Account List
            Flexible(
              child: () {
                // Filter accounts based on search query
                final filteredAccounts = searchQuery.isEmpty
                    ? _accounts
                    : _accounts.where((account) {
                        final accountName = (account['account_name'] ?? '').toString().toLowerCase();
                        final categoryTag = (account['category_tag'] ?? '').toString().toLowerCase();
                        return accountName.contains(searchQuery) || categoryTag.contains(searchQuery);
                      }).toList();
                
                if (filteredAccounts.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.search_off_rounded,
                            size: 48,
                            color: TossColors.gray400,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'No accounts found',
                            style: TossTextStyles.body.copyWith(
                              color: TossColors.gray600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Try a different search term',
                            style: TossTextStyles.caption.copyWith(
                              color: TossColors.gray500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                
                return ListView.builder(
                  shrinkWrap: true,
                  padding: const EdgeInsets.only(bottom: 20),
                  itemCount: filteredAccounts.length,
                  itemBuilder: (context, index) {
                    final account = filteredAccounts[index];
                    final isSelected = _selectedAccount?['account_id'] == account['account_id'];
                  
                  return Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        setParentState(() {
                          _selectedAccount = account;
                          // Reset selections when account changes
                          _selectedCashLocation = null;
                          _selectedCounterparty = null;
                        });
                        
                        // If Cash account is selected, fetch cash locations
                        if (account['account_name'] != null &&
                            account['account_name'].toString().toLowerCase().contains('cash')) {
                          _fetchCashLocations(setParentState);
                        }
                        
                        // If payable or receivable account is selected, fetch counterparties
                        if (account['category_tag'] != null &&
                            (account['category_tag'].toString().toLowerCase() == 'payable' ||
                             account['category_tag'].toString().toLowerCase() == 'receivable')) {
                          _fetchCounterparties(setParentState);
                        }
                        
                        Navigator.pop(context);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected ? TossColors.primary.withOpacity(0.05) : Colors.transparent,
                        ),
                        child: Row(
                          children: [
                            // Account Icon with first letter of account name
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: TossColors.primary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: Text(
                                  (account['account_name'] ?? 'A').toString().substring(0, 1).toUpperCase(),
                                  style: TossTextStyles.body.copyWith(
                                    color: TossColors.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    account['account_name'] ?? 'Unknown Account',
                                    style: TossTextStyles.body.copyWith(
                                      color: isSelected ? TossColors.primary : TossColors.gray900,
                                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                                    ),
                                  ),
                                  if (account['category_tag'] != null) ...[
                                    const SizedBox(height: 2),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: isSelected 
                                            ? TossColors.primary.withOpacity(0.1)
                                            : TossColors.gray100,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        account['category_tag'],
                                        style: TossTextStyles.caption.copyWith(
                                          color: isSelected 
                                              ? TossColors.primary
                                              : TossColors.gray600,
                                          fontSize: 11,
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                            if (isSelected)
                              Icon(
                                Icons.check_rounded,
                                size: 20,
                                color: TossColors.primary,
                              ),
                          ],
                        ),
                      ),
                    ),
                  );
                  },
                );
              }(),
            ),
          ],
        ),
        ),
      ),
    );
  }

  void _showAddTransactionBottomSheet({String? defaultType}) {
    // Clear controllers and fetch accounts
    _accountController.clear();
    _transactionDescController.clear();
    
    // Calculate the difference between debit and credit
    double difference = (_debitTotal - _creditTotal).abs();
    
    // Set default amount if there's an imbalance
    if (difference > 0 && _transactions.isNotEmpty) {
      // Format the difference with commas
      final formatter = NumberFormat('#,###');
      _amountController.text = formatter.format(difference.toInt());
    } else {
      _amountController.clear();
    }
    
    // Set default transaction type based on parameter or what's needed for balance
    if (defaultType != null) {
      _selectedTransactionType = defaultType;
    } else if (_debitTotal > _creditTotal) {
      // Need more credit to balance
      _selectedTransactionType = 'credit';
    } else if (_creditTotal > _debitTotal) {
      // Need more debit to balance
      _selectedTransactionType = 'debit';
    } else {
      // Already balanced, default to debit
      _selectedTransactionType = 'debit';
    }
    
    _selectedAccount = null;
    _selectedCashLocation = null;
    _cashLocations = [];
    _selectedCounterparty = null;
    _counterparties = [];
    _selectedDebtCategory = null;
    _interestRateController.clear();
    _issueDate = null;
    _dueDate = null;
    
    // Clear fixed asset controllers
    _fixedAssetNameController.clear();
    _usefulLifeController.text = '1'; // Default useful life to 1
    _acquisitionDate = DateTime.now(); // Default to today
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) {
          // Fetch accounts when bottom sheet opens (only once)
          if (_accounts.isEmpty && !_isLoadingAccounts) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _fetchAccounts(setModalState);
            });
          }
          
          return AnimatedPadding(
          padding: MediaQuery.of(context).viewInsets,
          duration: const Duration(milliseconds: 100),
          child: Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.9,
              minHeight: MediaQuery.of(context).size.height * 0.5,
            ),
            decoration: BoxDecoration(
              color: TossColors.background,
              borderRadius: BorderRadius.vertical(top: Radius.circular(TossBorderRadius.xxl)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  offset: const Offset(0, -2),
                  blurRadius: 16,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Handle Bar with Toss Style
                Container(
                  margin: const EdgeInsets.only(top: 8, bottom: 8),
                  width: 48,
                  height: 5,
                  decoration: BoxDecoration(
                    color: TossColors.gray300,
                    borderRadius: BorderRadius.circular(TossBorderRadius.full),
                  ),
                ),
                
                // Header
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Text(
                        'Add Transaction',
                        style: TossTextStyles.h3.copyWith(
                          color: TossColors.gray900,
                        ),
                      ),
                      const Spacer(),
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () => Navigator.pop(context),
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            width: 32,
                            height: 32,
                            alignment: Alignment.center,
                            child: Icon(
                              Icons.close_rounded,
                              size: 20,
                              color: TossColors.gray600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Content
                Flexible(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Transaction Type Toggle with Animation
                        Text(
                          'Transaction Type',
                          style: TossTextStyles.label.copyWith(
                            color: TossColors.gray600,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          height: 56,
                          decoration: BoxDecoration(
                            color: TossColors.gray50,
                            borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                          ),
                          padding: const EdgeInsets.all(4),
                          child: Stack(
                            children: [
                              // Animated sliding background
                              AnimatedAlign(
                                alignment: _selectedTransactionType == 'debit'
                                    ? Alignment.centerLeft
                                    : Alignment.centerRight,
                                duration: const Duration(milliseconds: 250),
                                curve: Curves.easeInOutCubic,
                                child: Container(
                                  width: (MediaQuery.of(context).size.width - 48) / 2,
                                  height: 48,
                                  decoration: BoxDecoration(
                                    color: TossColors.background,
                                    borderRadius: BorderRadius.circular(TossBorderRadius.md),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.06),
                                        offset: const Offset(0, 2),
                                        blurRadius: 8,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              // Transaction type buttons
                              Row(
                                children: [
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        HapticFeedback.lightImpact();
                                        setModalState(() {
                                          _selectedTransactionType = 'debit';
                                        });
                                      },
                                      child: Container(
                                        height: 48,
                                        alignment: Alignment.center,
                                        child: AnimatedDefaultTextStyle(
                                          duration: const Duration(milliseconds: 200),
                                          style: TossTextStyles.bodyLarge.copyWith(
                                            color: _selectedTransactionType == 'debit'
                                                ? TossColors.info
                                                : TossColors.gray500,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          child: const Text('Debit'),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        HapticFeedback.lightImpact();
                                        setModalState(() {
                                          _selectedTransactionType = 'credit';
                                        });
                                      },
                                      child: Container(
                                        height: 48,
                                        alignment: Alignment.center,
                                        child: AnimatedDefaultTextStyle(
                                          duration: const Duration(milliseconds: 200),
                                          style: TossTextStyles.bodyLarge.copyWith(
                                            color: _selectedTransactionType == 'credit'
                                                ? TossColors.loss
                                                : TossColors.gray500,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          child: const Text('Credit'),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        
                        const SizedBox(height: 24),
                        
                        // Account Selection (Required)
                        Text(
                          'Account',
                          style: TossTextStyles.label.copyWith(
                            color: TossColors.gray600,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          decoration: BoxDecoration(
                            color: TossColors.gray50,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: TossColors.primary.withOpacity(0.5),
                              width: 1.5,
                            ),
                          ),
                          child: _isLoadingAccounts
                              ? Container(
                                  padding: const EdgeInsets.all(16),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: TossColors.primary,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Text(
                                        'Loading accounts...',
                                        style: TossTextStyles.body.copyWith(
                                          color: TossColors.gray500,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: () => _showAccountSelector(setModalState),
                                    borderRadius: BorderRadius.circular(12),
                                    child: Container(
                                      padding: const EdgeInsets.all(16),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  _selectedAccount != null
                                                      ? (_selectedAccount!['account_name'] ?? 'Unknown Account')
                                                      : 'Select account',
                                                  style: TossTextStyles.body.copyWith(
                                                    color: _selectedAccount != null
                                                        ? TossColors.gray900
                                                        : TossColors.gray400,
                                                  ),
                                                ),
                                                if (_selectedAccount != null && 
                                                    _selectedAccount!['category_tag'] != null)
                                                  Text(
                                                    _selectedAccount!['category_tag'],
                                                    style: TossTextStyles.caption.copyWith(
                                                      color: TossColors.gray500,
                                                    ),
                                                  ),
                                              ],
                                            ),
                                          ),
                                          Icon(
                                            Icons.arrow_drop_down_rounded,
                                            color: TossColors.gray400,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                        ),
                        
                        // Cash Location Selector (only if Cash account is selected)
                        if (_selectedAccount != null && 
                            _selectedAccount!['account_name'] != null &&
                            _selectedAccount!['account_name'].toString().toLowerCase().contains('cash')) ...[
                          const SizedBox(height: 24),
                          Text(
                            'Cash Location',
                            style: TossTextStyles.label.copyWith(
                              color: TossColors.gray600,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Container(
                            decoration: BoxDecoration(
                              color: TossColors.gray50,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: TossColors.primary.withOpacity(0.5),
                                width: 1.5,
                              ),
                            ),
                            child: _isLoadingCashLocations
                                ? Container(
                                    padding: const EdgeInsets.all(16),
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: TossColors.primary,
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Text(
                                          'Loading cash locations...',
                                          style: TossTextStyles.body.copyWith(
                                            color: TossColors.gray500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      onTap: () => _showCashLocationSelector(setModalState),
                                      borderRadius: BorderRadius.circular(12),
                                      child: Container(
                                        padding: const EdgeInsets.all(16),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    _selectedCashLocation != null
                                                        ? (_selectedCashLocation!['location_name'] ?? 'Unknown Location')
                                                        : 'Select cash location',
                                                    style: TossTextStyles.body.copyWith(
                                                      color: _selectedCashLocation != null
                                                          ? TossColors.gray900
                                                          : TossColors.gray400,
                                                    ),
                                                  ),
                                                  if (_selectedCashLocation != null && 
                                                      _selectedCashLocation!['location_type'] != null)
                                                    Text(
                                                      _selectedCashLocation!['location_type'],
                                                      style: TossTextStyles.caption.copyWith(
                                                        color: TossColors.gray500,
                                                      ),
                                                    ),
                                                ],
                                              ),
                                            ),
                                            Icon(
                                              Icons.arrow_drop_down_rounded,
                                              color: TossColors.gray400,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                          ),
                        ],
                        
                        // Counterparty Selector (only if payable or receivable account is selected)
                        if (_selectedAccount != null && 
                            _selectedAccount!['category_tag'] != null &&
                            (_selectedAccount!['category_tag'].toString().toLowerCase() == 'payable' ||
                             _selectedAccount!['category_tag'].toString().toLowerCase() == 'receivable')) ...[
                          const SizedBox(height: 24),
                          Text(
                            'Counterparty',
                            style: TossTextStyles.label.copyWith(
                              color: TossColors.gray600,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Container(
                            decoration: BoxDecoration(
                              color: TossColors.gray50,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: TossColors.primary.withOpacity(0.5),
                                width: 1.5,
                              ),
                            ),
                            child: _isLoadingCounterparties
                                ? Container(
                                    padding: const EdgeInsets.all(16),
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: TossColors.primary,
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Text(
                                          'Loading counterparties...',
                                          style: TossTextStyles.body.copyWith(
                                            color: TossColors.gray500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      onTap: () => _showCounterpartySelector(setModalState),
                                      borderRadius: BorderRadius.circular(12),
                                      child: Container(
                                        padding: const EdgeInsets.all(16),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                _selectedCounterparty != null
                                                    ? (_selectedCounterparty!['name'] ?? 'Unknown')
                                                    : 'Select counterparty',
                                                style: TossTextStyles.body.copyWith(
                                                  color: _selectedCounterparty != null
                                                      ? TossColors.gray900
                                                      : TossColors.gray400,
                                                ),
                                              ),
                                            ),
                                            Icon(
                                              Icons.arrow_drop_down_rounded,
                                              color: TossColors.gray400,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                          ),
                        ],
                        
                        // Fixed Asset related fields (only if fixed asset account is selected)
                        if (_selectedAccount != null && 
                            _selectedAccount!['category_tag'] != null &&
                            _selectedAccount!['category_tag'].toString().toLowerCase() == 'fixedasset') ...[
                          const SizedBox(height: 24),
                          
                          // Fixed Asset Name
                          Text(
                            'Fixed Asset Name',
                            style: TossTextStyles.label.copyWith(
                              color: TossColors.gray600,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Container(
                            decoration: BoxDecoration(
                              color: TossColors.gray50,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: TossColors.primary.withOpacity(0.5),
                                width: 1.5,
                              ),
                            ),
                            child: TextField(
                              controller: _fixedAssetNameController,
                              style: TossTextStyles.body.copyWith(
                                color: TossColors.gray900,
                              ),
                              decoration: InputDecoration(
                                hintText: 'Enter fixed asset name',
                                hintStyle: TossTextStyles.body.copyWith(
                                  color: TossColors.gray400,
                                ),
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.all(16),
                              ),
                            ),
                          ),
                          
                          const SizedBox(height: 24),
                          
                          // Acquisition Date
                          Text(
                            'Acquisition Date',
                            style: TossTextStyles.label.copyWith(
                              color: TossColors.gray600,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () async {
                                final picked = await showDatePicker(
                                  context: context,
                                  initialDate: _acquisitionDate ?? DateTime.now(),
                                  firstDate: DateTime(2000),
                                  lastDate: DateTime(2100),
                                );
                                if (picked != null && mounted) {
                                  setModalState(() {
                                    _acquisitionDate = picked;
                                  });
                                }
                              },
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: TossColors.gray50,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: TossColors.primary.withOpacity(0.5),
                                    width: 1.5,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.calendar_today_rounded,
                                      size: 16,
                                      color: TossColors.primary,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        DateFormat('yyyy-MM-dd').format(_acquisitionDate ?? DateTime.now()),
                                        style: TossTextStyles.body.copyWith(
                                          color: TossColors.gray900,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          
                          const SizedBox(height: 24),
                          
                          // Useful Life
                          Text(
                            'Useful Life (years)',
                            style: TossTextStyles.label.copyWith(
                              color: TossColors.gray600,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Container(
                            decoration: BoxDecoration(
                              color: TossColors.gray50,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: TossColors.primary.withOpacity(0.5),
                                width: 1.5,
                              ),
                            ),
                            child: TextField(
                              controller: _usefulLifeController,
                              keyboardType: TextInputType.number,
                              style: TossTextStyles.body.copyWith(
                                color: TossColors.gray900,
                              ),
                              decoration: InputDecoration(
                                hintText: 'Enter useful life in years',
                                hintStyle: TossTextStyles.body.copyWith(
                                  color: TossColors.gray400,
                                ),
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.all(16),
                              ),
                            ),
                          ),
                        ],
                        
                        // Debt Category and related fields (only if payable or receivable account is selected)
                        if (_selectedAccount != null && 
                            _selectedAccount!['category_tag'] != null &&
                            (_selectedAccount!['category_tag'].toString().toLowerCase() == 'payable' ||
                             _selectedAccount!['category_tag'].toString().toLowerCase() == 'receivable')) ...[
                          const SizedBox(height: 24),
                          
                          // Debt Category
                          Text(
                            'Debt Category',
                            style: TossTextStyles.label.copyWith(
                              color: TossColors.gray600,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Container(
                            decoration: BoxDecoration(
                              color: TossColors.gray50,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: TossColors.primary.withOpacity(0.5),
                                width: 1.5,
                              ),
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () => _showDebtCategorySelector(setModalState),
                                borderRadius: BorderRadius.circular(12),
                                child: Container(
                                  padding: const EdgeInsets.all(16),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          _selectedDebtCategory != null
                                              ? _selectedDebtCategory!.substring(0, 1).toUpperCase() + _selectedDebtCategory!.substring(1)
                                              : 'Select debt category',
                                          style: TossTextStyles.body.copyWith(
                                            color: _selectedDebtCategory != null
                                                ? TossColors.gray900
                                                : TossColors.gray400,
                                          ),
                                        ),
                                      ),
                                      Icon(
                                        Icons.arrow_drop_down_rounded,
                                        color: TossColors.gray400,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          
                          const SizedBox(height: 24),
                          
                          // Interest Rate
                          Text(
                            'Interest Rate (%)',
                            style: TossTextStyles.label.copyWith(
                              color: TossColors.gray600,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Container(
                            decoration: BoxDecoration(
                              color: TossColors.gray50,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: TossColors.gray200,
                                width: 1,
                              ),
                            ),
                            child: TextField(
                              controller: _interestRateController,
                              keyboardType: TextInputType.numberWithOptions(decimal: true),
                              style: TossTextStyles.body.copyWith(
                                color: TossColors.gray900,
                              ),
                              decoration: InputDecoration(
                                hintText: 'Enter interest rate',
                                hintStyle: TossTextStyles.body.copyWith(
                                  color: TossColors.gray400,
                                ),
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.all(16),
                              ),
                            ),
                          ),
                          
                          const SizedBox(height: 24),
                          
                          // Issue Date and Due Date Row
                          Row(
                            children: [
                              // Issue Date
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Issue Date',
                                      style: TossTextStyles.label.copyWith(
                                        color: TossColors.gray600,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        onTap: () => _selectIssueDate(context, setModalState),
                                        borderRadius: BorderRadius.circular(12),
                                        child: Container(
                                          padding: const EdgeInsets.all(16),
                                          decoration: BoxDecoration(
                                            color: TossColors.gray50,
                                            borderRadius: BorderRadius.circular(12),
                                            border: Border.all(
                                              color: TossColors.gray200,
                                              width: 1,
                                            ),
                                          ),
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.calendar_today_rounded,
                                                size: 16,
                                                color: _issueDate != null ? TossColors.primary : TossColors.gray400,
                                              ),
                                              const SizedBox(width: 8),
                                              Expanded(
                                                child: Text(
                                                  _issueDate != null
                                                      ? DateFormat('yyyy-MM-dd').format(_issueDate!)
                                                      : 'Select date',
                                                  style: TossTextStyles.bodySmall.copyWith(
                                                    color: _issueDate != null ? TossColors.gray900 : TossColors.gray400,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 12),
                              // Due Date
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Due Date',
                                      style: TossTextStyles.label.copyWith(
                                        color: TossColors.gray600,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        onTap: () => _selectDueDate(context, setModalState),
                                        borderRadius: BorderRadius.circular(12),
                                        child: Container(
                                          padding: const EdgeInsets.all(16),
                                          decoration: BoxDecoration(
                                            color: TossColors.gray50,
                                            borderRadius: BorderRadius.circular(12),
                                            border: Border.all(
                                              color: TossColors.gray200,
                                              width: 1,
                                            ),
                                          ),
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.calendar_today_rounded,
                                                size: 16,
                                                color: _dueDate != null ? TossColors.primary : TossColors.gray400,
                                              ),
                                              const SizedBox(width: 8),
                                              Expanded(
                                                child: Text(
                                                  _dueDate != null
                                                      ? DateFormat('yyyy-MM-dd').format(_dueDate!)
                                                      : 'Select date',
                                                  style: TossTextStyles.bodySmall.copyWith(
                                                    color: _dueDate != null ? TossColors.gray900 : TossColors.gray400,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                        
                        const SizedBox(height: 24),
                        
                        // Amount Input (Always Required)
                        Text(
                          'Amount',
                          style: TossTextStyles.label.copyWith(
                            color: TossColors.gray600,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          decoration: BoxDecoration(
                            color: TossColors.gray50,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: TossColors.primary.withOpacity(0.5),
                              width: 1.5,
                            ),
                          ),
                          child: TextField(
                            controller: _amountController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              ThousandsSeparatorInputFormatter(),
                            ],
                            style: TossTextStyles.body.copyWith(
                              color: TossColors.gray900,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Enter amount',
                              hintStyle: TossTextStyles.body.copyWith(
                                color: TossColors.gray400,
                              ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.all(16),
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 24),
                        
                        // Description
                        Text(
                          'Description',
                          style: TossTextStyles.label.copyWith(
                            color: TossColors.gray600,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          decoration: BoxDecoration(
                            color: TossColors.gray50,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: TossColors.gray200,
                              width: 1,
                            ),
                          ),
                          child: TextField(
                            controller: _transactionDescController,
                            maxLines: 3,
                            style: TossTextStyles.body.copyWith(
                              color: TossColors.gray900,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Enter transaction description',
                              hintStyle: TossTextStyles.body.copyWith(
                                color: TossColors.gray400,
                              ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.all(16),
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 32),
                        
                        // Action Buttons with Toss Style
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: SizedBox(
                                height: 56,
                                child: TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  style: TextButton.styleFrom(
                                    backgroundColor: TossColors.gray100,
                                    foregroundColor: TossColors.gray700,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                                    ),
                                  ),
                                  child: Text(
                                    'Cancel',
                                    style: TossTextStyles.bodyLarge.copyWith(
                                      color: TossColors.gray700,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: SizedBox(
                                height: 56,
                                child: ElevatedButton(
                                  onPressed: () {
                                    // Validate required fields based on account type
                                    bool isValid = true;
                                    String? errorMessage;
                                    
                                    // Check basic requirements
                                    if (_selectedAccount == null) {
                                      isValid = false;
                                      errorMessage = 'Please select an account';
                                    } else if (_amountController.text.isEmpty) {
                                      isValid = false;
                                      errorMessage = 'Please enter an amount';
                                    }
                                    
                                    // Check category-specific requirements
                                    if (isValid && _selectedAccount != null) {
                                      final categoryTag = _selectedAccount!['category_tag']?.toString().toLowerCase();
                                      
                                      // For payable/receivable accounts
                                      if (categoryTag == 'payable' || categoryTag == 'receivable') {
                                        if (_selectedCounterparty == null) {
                                          isValid = false;
                                          errorMessage = 'Please select a counterparty';
                                        } else if (_selectedDebtCategory == null) {
                                          isValid = false;
                                          errorMessage = 'Please select a debt category';
                                        }
                                      }
                                      
                                      // For cash accounts
                                      else if (_selectedAccount!['account_name']?.toString().toLowerCase().contains('cash') == true) {
                                        if (_selectedCashLocation == null) {
                                          isValid = false;
                                          errorMessage = 'Please select a cash location';
                                        }
                                      }
                                      
                                      // For fixed asset accounts
                                      else if (categoryTag == 'fixedasset') {
                                        if (_fixedAssetNameController.text.isEmpty) {
                                          isValid = false;
                                          errorMessage = 'Please enter a fixed asset name';
                                        } else if (_usefulLifeController.text.isEmpty) {
                                          isValid = false;
                                          errorMessage = 'Please enter useful life';
                                        }
                                      }
                                    }
                                    
                                    // Show error if validation failed
                                    if (!isValid) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text(errorMessage ?? 'Please fill in all required fields'),
                                          backgroundColor: TossColors.error,
                                        ),
                                      );
                                      return;
                                    }
                                    
                                    // Add transaction if validation passed
                                    final amountText = _amountController.text.replaceAll(',', '');
                                    final amount = double.tryParse(amountText) ?? 0;
                                    if (amount > 0) {
                                        setState(() {
                                          final transaction = {
                                            'type': _selectedTransactionType,
                                            'account': _selectedAccount!['account_name'] ?? 'Unknown',
                                            'account_id': _selectedAccount!['account_id'],
                                            'category_tag': _selectedAccount!['category_tag'],
                                            'description': _transactionDescController.text.isEmpty
                                                ? null
                                                : _transactionDescController.text,
                                            'amount': amount,
                                          };
                                          
                                          // Add cash location if it's a cash account and location is selected
                                          if (_selectedAccount!['account_name'] != null &&
                                              _selectedAccount!['account_name'].toString().toLowerCase().contains('cash') &&
                                              _selectedCashLocation != null) {
                                            transaction['cash_location_id'] = _selectedCashLocation!['cash_location_id'];
                                            transaction['cash_location_name'] = _selectedCashLocation!['location_name'];
                                            transaction['location_type'] = _selectedCashLocation!['location_type'];
                                          }
                                          
                                          // Add counterparty if it's a payable or receivable account
                                          if (_selectedAccount!['category_tag'] != null &&
                                              (_selectedAccount!['category_tag'].toString().toLowerCase() == 'payable' ||
                                               _selectedAccount!['category_tag'].toString().toLowerCase() == 'receivable')) {
                                            if (_selectedCounterparty != null) {
                                              transaction['counterparty_id'] = _selectedCounterparty!['counterparty_id'];
                                              transaction['counterparty_name'] = _selectedCounterparty!['name'];
                                            }
                                            
                                            // Add debt-related fields
                                            if (_selectedDebtCategory != null) {
                                              transaction['debt_category'] = _selectedDebtCategory;
                                            }
                                            if (_interestRateController.text.isNotEmpty) {
                                              transaction['interest_rate'] = double.tryParse(_interestRateController.text) ?? 0;
                                            }
                                            if (_issueDate != null) {
                                              transaction['issue_date'] = DateFormat('yyyy-MM-dd').format(_issueDate!);
                                            }
                                            if (_dueDate != null) {
                                              transaction['due_date'] = DateFormat('yyyy-MM-dd').format(_dueDate!);
                                            }
                                          }
                                          
                                          // Add fixed asset fields if it's a fixed asset account
                                          if (_selectedAccount!['category_tag'] != null &&
                                              _selectedAccount!['category_tag'].toString().toLowerCase() == 'fixedasset') {
                                            if (_fixedAssetNameController.text.isNotEmpty) {
                                              transaction['fixed_asset_name'] = _fixedAssetNameController.text;
                                            }
                                            if (_acquisitionDate != null) {
                                              transaction['acquisition_date'] = DateFormat('yyyy-MM-dd').format(_acquisitionDate!);
                                            }
                                            if (_usefulLifeController.text.isNotEmpty) {
                                              transaction['useful_life'] = int.tryParse(_usefulLifeController.text) ?? 1;
                                            }
                                          }
                                          
                                          _transactions.add(transaction);
                                          _calculateTotals();
                                        });
                                        Navigator.pop(context);
                                        HapticFeedback.lightImpact();
                                      }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: TossColors.primary,
                                    foregroundColor: Colors.white,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                                    ),
                                  ),
                                  child: Text(
                                    'Add',
                                    style: TossTextStyles.bodyLarge.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        
                        // Safe area padding for bottom
                        SizedBox(height: MediaQuery.of(context).padding.bottom + 20),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          );
        },
      ),
    );
  }
}

