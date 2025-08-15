import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/themes/toss_text_styles.dart';
import '../../../core/themes/toss_spacing.dart';
import '../../../core/themes/toss_border_radius.dart';
import '../../../core/themes/toss_shadows.dart';
import 'account_settings_page.dart';

class AccountDetailPage extends ConsumerStatefulWidget {
  final String accountName;
  final String locationType;
  final int balance;
  final int errors;
  final int? totalJournal;
  final int? totalReal;
  final int? cashDifference;
  final String? currencySymbol;
  
  const AccountDetailPage({
    super.key,
    required this.accountName,
    required this.locationType,
    required this.balance,
    required this.errors,
    this.totalJournal,
    this.totalReal,
    this.cashDifference,
    this.currencySymbol,
  });

  @override
  ConsumerState<AccountDetailPage> createState() => _AccountDetailPageState();
}

class _AccountDetailPageState extends ConsumerState<AccountDetailPage> 
    with SingleTickerProviderStateMixin {
  // Mock transaction data
  late List<Map<String, dynamic>> transactions;
  late TabController _tabController;
  int _selectedTab = 0;
  String _selectedFilter = 'All';
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _selectedTab = _tabController.index;
      });
    });
    _loadTransactions();
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  
  void _loadTransactions() {
    // Mock transactions data - in real app, this would come from API
    transactions = [
      {
        'date': '9/8',
        'title': 'Office Expense',
        'time': '01:01',
        'amount': 122,
        'balance': 156023,
        'isIncome': true,
        'account': 'John Smith',
      },
      {
        'date': '4/8',
        'title': 'Customer Payment',
        'time': '16:21',
        'amount': 10000,
        'balance': 155901,
        'isIncome': true,
        'account': 'Sarah Kim',
      },
      {
        'date': '2/8',
        'title': 'Card Payment',
        'time': '08:00',
        'amount': -51914,
        'balance': 145901,
        'isIncome': false,
        'account': 'Mike Johnson',
      },
      {
        'date': '29/7',
        'title': 'Food Supplies',
        'time': '20:58',
        'amount': -14000,
        'balance': 197815,
        'isIncome': false,
        'account': 'Lisa Park',
      },
      {
        'date': '29/7',
        'title': 'Hotel Services',
        'time': '20:13',
        'amount': -44032,
        'balance': 211815,
        'isIncome': false,
        'account': 'David Lee',
      },
      {
        'date': '29/7',
        'title': 'Duty Free Shop',
        'time': '20:09',
        'amount': -159616,
        'balance': 255847,
        'isIncome': false,
        'account': 'Emma Wilson',
      },
    ];
  }
  
  String _formatCurrency(int amount, [String? currencySymbol]) {
    final formatter = NumberFormat('#,###', 'en_US');
    final symbol = currencySymbol ?? '₩';
    return '$symbol${formatter.format(amount.abs())}';
  }
  
  String _formatTransactionAmount(int amount, bool isIncome) {
    final formatter = NumberFormat('#,###', 'en_US');
    final prefix = isIncome ? '+₩' : '-₩';
    return '$prefix${formatter.format(amount.abs())}';
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(context),
            
            // Content
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Balance Card with padding
                    Padding(
                      padding: EdgeInsets.all(TossSpacing.space4),
                      child: _buildBalanceCard(),
                    ),
                    
                    // Transaction List (has its own padding)
                    _buildTransactionList(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildHeader(BuildContext context) {
    return Container(
      height: 56,
      padding: EdgeInsets.symmetric(horizontal: TossSpacing.space2),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios, size: 20),
            onPressed: () => Navigator.of(context).pop(),
          ),
          Expanded(
            child: Text(
              widget.accountName,
              style: TossTextStyles.h3.copyWith(
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          GestureDetector(
            onTap: () {
              // Navigate to account settings page
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AccountSettingsPage(
                    accountName: widget.accountName,
                    locationType: widget.locationType,
                  ),
                ),
              );
            },
            child: Container(
              padding: EdgeInsets.all(8),
              child: Icon(
                Icons.settings_outlined,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildBalanceCard() {
    // Use passed parameters or fallback to legacy values
    final totalJournal = widget.totalJournal ?? widget.balance;
    final totalReal = widget.totalReal ?? widget.balance;
    final error = widget.cashDifference ?? (totalReal - totalJournal);
    final currencySymbol = widget.currencySymbol ?? '₩';
    
    return Container(
      padding: EdgeInsets.all(TossSpacing.space5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        boxShadow: TossShadows.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Balance title and Auto Mapping button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Balance',
                style: TossTextStyles.body.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: 17,
                ),
              ),
              GestureDetector(
                onTap: () => _showAutoMappingBottomSheet(),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: TossSpacing.space4,
                    vertical: TossSpacing.space2,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(TossBorderRadius.md),
                  ),
                  child: Text(
                    'Auto Mapping',
                    style: TossTextStyles.caption.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: TossSpacing.space4),
          
          // Total Journal
          _buildBalanceRow(
            'Total Journal',
            _formatCurrency(totalJournal, currencySymbol),
            isJournal: true,
          ),
          
          SizedBox(height: TossSpacing.space3),
          
          // Total Real
          _buildBalanceRow(
            'Total Real',
            _formatCurrency(totalReal, currencySymbol),
            isJournal: false,
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
                _formatCurrency(error, currencySymbol),
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
  
  Widget _buildBalanceRow(String label, String amount, {required bool isJournal}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TossTextStyles.body.copyWith(
            fontSize: 15,
          ),
        ),
        Text(
          amount,
          style: TossTextStyles.body.copyWith(
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
  
  void _showFilterBottomSheet() {
    // Different filters based on tab
    List<String> filterOptions;
    if (_selectedTab == 0) {
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
                _buildFilterOption(option, _selectedFilter == option)
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
          _selectedFilter = title;
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
                color: Theme.of(context).colorScheme.primary,
                size: 28,
                weight: 900,
              ),
          ],
        ),
      ),
    );
  }
  
  void _showAutoMappingBottomSheet() {
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
                padding: const EdgeInsets.fromLTRB(24, 20, 20, 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Select Mapping Reason',
                      style: TossTextStyles.h2.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, size: 24),
                      onPressed: () => Navigator.pop(context),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              ),
              
              // Mapping options
              _buildMappingOption('Error', Icons.error_outline),
              _buildMappingOption('Exchange Rate Differences', Icons.currency_exchange),
              
              // Bottom safe area
              SizedBox(height: MediaQuery.of(context).padding.bottom + 20),
            ],
          ),
        );
      },
    );
  }
  
  Widget _buildMappingOption(String title, IconData icon) {
    return InkWell(
      onTap: () {
        // Handle mapping selection
        Navigator.pop(context);
        // Perform mapping action without notification
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(
          children: [
            Icon(
              icon,
              color: Theme.of(context).colorScheme.primary,
              size: 24,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TossTextStyles.body.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: Colors.grey[400],
              size: 24,
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildTransactionList() {
    // Filter transactions based on selected tab and filter
    var filteredTransactions = _selectedTab == 0 
        ? transactions // Journal - show all
        : transactions.where((t) => t['isIncome'] == false).toList(); // Real - show expenses only
    
    // Apply additional filter
    if (_selectedFilter == 'Money In') {
      filteredTransactions = filteredTransactions.where((t) => t['isIncome'] == true).toList();
    } else if (_selectedFilter == 'Money Out') {
      filteredTransactions = filteredTransactions.where((t) => t['isIncome'] == false).toList();
    } else if (_selectedFilter == 'Today') {
      // Mock: show first 2 transactions for "Today"
      filteredTransactions = filteredTransactions.take(2).toList();
    } else if (_selectedFilter == 'Yesterday') {
      // Mock: show next 2 transactions for "Yesterday"
      filteredTransactions = filteredTransactions.skip(2).take(2).toList();
    } else if (_selectedFilter == 'Last Week') {
      // Mock: show last 2 transactions for "Last Week"
      filteredTransactions = filteredTransactions.skip(4).toList();
    } else if (_selectedFilter == 'Last Month') {
      // Mock: show all transactions for "Last Month"
      filteredTransactions = filteredTransactions;
    }
    
    return Column(
      children: [
        // Transaction container with tab bar
        Container(
          margin: EdgeInsets.symmetric(horizontal: TossSpacing.space4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(TossBorderRadius.lg),
            boxShadow: TossShadows.cardShadow,
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
                    controller: _tabController,
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
                      Tab(text: 'Journal'),
                      Tab(text: 'Real'),
                    ],
                  ),
                ),
              ),
              
              // Header with filter - aligned with Balance text
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
                        _selectedFilter,
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
              
              // Transaction items
              ..._buildTransactionItems(filteredTransactions),
            ],
          ),
        ),
        
        // Bottom spacing
        SizedBox(height: TossSpacing.space4),
      ],
    );
  }
  
  List<Widget> _buildTransactionItems(List<dynamic> transactions) {
    List<Widget> items = [];
    String? lastDate;
    
    for (int i = 0; i < transactions.length; i++) {
      final transaction = transactions[i];
      final currentDate = transaction['date']?.toString() ?? '';
      final bool showDate = currentDate.isNotEmpty && currentDate != lastDate;
      
      if (showDate) {
        lastDate = currentDate;
      }
      
      items.add(_buildTransactionItem(transaction, showDate));
    }
    
    return items;
  }
  
  Widget _buildTransactionItem(Map<String, dynamic> transaction, bool showDate) {
    final bool isIncome = transaction['isIncome'] ?? false;
    final bool isRealTab = _selectedTab == 1;
    
    return Container(
      padding: EdgeInsets.only(
        left: TossSpacing.space4,
        right: TossSpacing.space4,
        top: TossSpacing.space3,
        bottom: TossSpacing.space3,
      ),
      child: Row(
        children: [
          // Date section (centered vertically, aligned left)
          Container(
            width: 42,
            padding: EdgeInsets.only(left: TossSpacing.space1),
            child: showDate
                ? Text(
                    transaction['date'],
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
                  transaction['title'],
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
                    Text(
                      transaction['account'] ?? 'Unknown',
                      style: TossTextStyles.caption.copyWith(
                        color: Colors.grey[500],
                        fontSize: 13,
                        height: 1.2,
                      ),
                    ),
                    if (transaction['time'] != null && transaction['time'].toString().isNotEmpty) ...[
                      Text(
                        ' • ',
                        style: TossTextStyles.caption.copyWith(
                          color: Colors.grey[500],
                          fontSize: 13,
                          height: 1.2,
                        ),
                      ),
                      Text(
                        transaction['time'],
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
          
          // Amount and balance (different for Real tab)
          if (isRealTab) 
            Text(
              _formatCurrency(transaction['balance']),
              style: TossTextStyles.body.copyWith(
                color: Colors.black87,
                fontWeight: FontWeight.w600,
                fontSize: 16,
                height: 1.2,
              ),
            )
          else
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  _formatTransactionAmount(transaction['amount'], isIncome),
                  style: TossTextStyles.body.copyWith(
                    color: isIncome 
                        ? Theme.of(context).colorScheme.primary 
                        : Colors.black87,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    height: 1.2,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  _formatCurrency(transaction['balance']),
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
    );
  }
}