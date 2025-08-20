import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/themes/toss_text_styles.dart';
import '../../../core/themes/toss_spacing.dart';
import '../../../core/themes/toss_border_radius.dart';
import '../../../core/themes/toss_shadows.dart';
import '../../../core/themes/toss_colors.dart';

class TotalJournalPage extends ConsumerStatefulWidget {
  final String locationType; // 'cash', 'bank', 'vault'
  final String journalType; // 'journal', 'real'
  
  const TotalJournalPage({
    super.key,
    required this.locationType,
    required this.journalType,
  });

  @override
  ConsumerState<TotalJournalPage> createState() => _TotalJournalPageState();
}

class _TotalJournalPageState extends ConsumerState<TotalJournalPage> {
  late List<Map<String, dynamic>> transactions;
  String _selectedFilter = 'All';
  
  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }
  
  @override
  void dispose() {
    super.dispose();
  }
  
  void _loadTransactions() {
    // Mock comprehensive transaction data from all accounts
    transactions = [
      {
        'date': '9/8',
        'title': 'Office Expense',
        'time': '01:01',
        'amount': 122,
        'balance': 156023,
        'isIncome': true,
        'account': 'John Smith',
        'accountName': 'Main Cashier',
        'category': 'Office',
        'description': 'Monthly office supplies purchase',
        'reference': 'INV-001',
      },
      {
        'date': '4/8',
        'title': 'Customer Payment',
        'time': '16:21',
        'amount': 10000,
        'balance': 155901,
        'isIncome': true,
        'account': 'Sarah Kim',
        'accountName': 'Main Cashier',
        'category': 'Sales',
        'description': 'Product sales payment',
        'reference': 'PAY-102',
      },
      {
        'date': '2/8',
        'title': 'Card Payment',
        'time': '08:00',
        'amount': -51914,
        'balance': 145901,
        'isIncome': false,
        'account': 'Mike Johnson',
        'accountName': 'Petty Cash',
        'category': 'Payment',
        'description': 'Credit card processing fee',
        'reference': 'FEE-089',
      },
      {
        'date': '29/7',
        'title': 'Food Supplies',
        'time': '20:58',
        'amount': -14000,
        'balance': 197815,
        'isIncome': false,
        'account': 'Lisa Park',
        'accountName': 'Main Cashier',
        'category': 'Supplies',
        'description': 'Weekly food supplies for office',
        'reference': 'SUP-045',
      },
      {
        'date': '29/7',
        'title': 'Hotel Services',
        'time': '20:13',
        'amount': -44032,
        'balance': 211815,
        'isIncome': false,
        'account': 'David Lee',
        'accountName': 'Petty Cash',
        'category': 'Services',
        'description': 'Business trip accommodation',
        'reference': 'TRV-023',
      },
      {
        'date': '29/7',
        'title': 'Duty Free Shop',
        'time': '20:09',
        'amount': -159616,
        'balance': 255847,
        'isIncome': false,
        'account': 'Emma Wilson',
        'accountName': 'Main Cashier',
        'category': 'Purchase',
        'description': 'Corporate gifts purchase',
        'reference': 'GFT-012',
      },
    ];
  }
  
  String _formatCurrency(int amount) {
    final formatter = NumberFormat('#,###', 'en_US');
    return '₩${formatter.format(amount.abs())}';
  }
  
  String _formatTransactionAmount(int amount, bool isIncome) {
    final formatter = NumberFormat('#,###', 'en_US');
    final prefix = isIncome ? '+₩' : '-₩';
    return '$prefix${formatter.format(amount.abs())}';
  }
  
  String get _pageTitle {
    String type = widget.locationType.capitalize();
    String journal = widget.journalType == 'journal' ? 'Total Journal' : 'Total Real';
    return '$type $journal';
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
            
            // Content - Transaction List fills remaining space
            Expanded(
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  TossSpacing.space4,
                  TossSpacing.space4,
                  TossSpacing.space4,
                  TossSpacing.space4,
                ),
                child: _buildTransactionList(),
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
              _pageTitle,
              style: TossTextStyles.h3.copyWith(
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          // Spacer to balance layout
          const SizedBox(width: 48),
        ],
      ),
    );
  }
  
  
  Widget _buildTransactionList() {
    final filteredTransactions = _getFilteredTransactions();
    
    return Container(
      decoration: BoxDecoration(
        color: TossColors.white,
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        boxShadow: TossShadows.card,
      ),
      child: Column(
        children: [
          // Header with filters
          _buildListHeader(),
          
          // Scrollable transaction items
          Expanded(
            child: ListView.builder(
              itemCount: filteredTransactions.length,
              itemBuilder: (context, index) {
                final transaction = filteredTransactions[index];
                final showDate = index == 0 || 
                    transaction['date'] != filteredTransactions[index - 1]['date'];
                
                return _buildTransactionItem(transaction, showDate);
              },
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildListHeader() {
    return Container(
      padding: EdgeInsets.only(
        left: TossSpacing.space5,
        right: TossSpacing.space4,
        top: TossSpacing.space4,
        bottom: TossSpacing.space3,
      ),
      child: GestureDetector(
        onTap: () => _showFilterBottomSheet(),
        child: Row(
          children: [
            Text(
              _selectedFilter,
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
    );
  }
  
  Widget _buildTransactionItem(Map<String, dynamic> transaction, bool showDate) {
    final bool isIncome = transaction['isIncome'] ?? false;
    final bool isRealType = widget.journalType == 'real';
    
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: TossSpacing.space4,
        vertical: TossSpacing.space3,
      ),
      child: Row(
        children: [
          // Date section
          Container(
            width: 42,
            padding: EdgeInsets.only(left: TossSpacing.space1),
            child: showDate
                ? Text(
                    transaction['date'],
                    style: TossTextStyles.caption.copyWith(
                      color: TossColors.gray600,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  )
                : const SizedBox.shrink(),
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
                    color: TossColors.gray800,
                  ),
                ),
                SizedBox(height: 4),
                Row(
                  children: [
                    Flexible(
                      child: Row(
                        children: [
                          // Account name
                          Flexible(
                            child: Text(
                              transaction['accountName'],
                              style: TossTextStyles.caption.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            ' • ',
                            style: TossTextStyles.caption.copyWith(
                              color: TossColors.gray400,
                              fontSize: 12,
                            ),
                          ),
                          // Person
                          Flexible(
                            child: Text(
                              transaction['account'] ?? 'Unknown',
                              style: TossTextStyles.caption.copyWith(
                                color: TossColors.gray500,
                                fontSize: 12,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (transaction['time'] != null) ...[
                            Text(
                              ' • ',
                              style: TossTextStyles.caption.copyWith(
                                color: TossColors.gray400,
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              transaction['time'],
                              style: TossTextStyles.caption.copyWith(
                                color: TossColors.gray500,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          SizedBox(width: TossSpacing.space2),
          
          // Amount - different display for Real vs Journal
          if (isRealType)
            Text(
              _formatCurrency(transaction['balance']),
              style: TossTextStyles.body.copyWith(
                color: TossColors.gray800,
                fontWeight: FontWeight.w600,
                fontSize: 16,
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
                        : TossColors.gray800,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  _formatCurrency(transaction['balance']),
                  style: TossTextStyles.caption.copyWith(
                    color: TossColors.gray500,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
  
  List<Map<String, dynamic>> _getFilteredTransactions() {
    var filtered = List<Map<String, dynamic>>.from(transactions);
    
    // Apply filter based on journal type
    if (widget.journalType == 'journal') {
      // Journal tab filters
      if (_selectedFilter == 'Money In') {
        filtered = filtered.where((t) => t['isIncome'] == true).toList();
      } else if (_selectedFilter == 'Money Out') {
        filtered = filtered.where((t) => t['isIncome'] == false).toList();
      } else if (_selectedFilter == 'Today') {
        // Mock: show first 2 transactions for "Today"
        filtered = filtered.take(2).toList();
      } else if (_selectedFilter == 'Yesterday') {
        // Mock: show next 2 transactions for "Yesterday"
        filtered = filtered.skip(2).take(2).toList();
      } else if (_selectedFilter == 'Last Week') {
        // Mock: show last 2 transactions for "Last Week"
        filtered = filtered.skip(4).toList();
      }
    } else {
      // Real tab filters - show only expenses
      filtered = filtered.where((t) => t['isIncome'] == false).toList();
      
      if (_selectedFilter == 'Today') {
        // Mock: show first 2 transactions for "Today"
        filtered = filtered.take(2).toList();
      } else if (_selectedFilter == 'Yesterday') {
        // Mock: show next 2 transactions for "Yesterday"
        filtered = filtered.skip(2).take(2).toList();
      } else if (_selectedFilter == 'Last Week') {
        // Mock: show last 2 transactions for "Last Week"
        filtered = filtered.skip(4).toList();
      } else if (_selectedFilter == 'Last Month') {
        // Mock: show all transactions for "Last Month"
        // filtered = filtered; // No change
      }
    }
    
    return filtered;
  }
  
  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: TossColors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          decoration: const BoxDecoration(
            color: TossColors.white,
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
                  color: TossColors.gray300,
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
                      'Filter Transactions',
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
              
              // Filter options
              ..._getFilterOptions().map((option) => 
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
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
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
                size: 24,
              ),
          ],
        ),
      ),
    );
  }
  
  
  List<String> _getFilterOptions() {
    if (widget.journalType == 'journal') {
      // Journal tab filters
      return ['All', 'Money In', 'Money Out', 'Today', 'Yesterday', 'Last Week'];
    } else {
      // Real tab filters
      return ['All', 'Today', 'Yesterday', 'Last Week', 'Last Month'];
    }
  }
}

extension StringExtension on String {
  String capitalize() {
    return '${this[0].toUpperCase()}${substring(1)}';
  }
}