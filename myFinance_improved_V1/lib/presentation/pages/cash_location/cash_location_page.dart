import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../core/themes/toss_text_styles.dart';
import '../../../core/themes/toss_spacing.dart';
import '../../../core/themes/toss_border_radius.dart';
import '../../../core/themes/toss_shadows.dart';
import '../../providers/app_state_provider.dart';
import 'add_account_page.dart';
import 'total_journal_page.dart';

class CashLocationPage extends ConsumerStatefulWidget {
  const CashLocationPage({super.key});

  @override
  ConsumerState<CashLocationPage> createState() => _CashLocationPageState();
}

class _CashLocationPageState extends ConsumerState<CashLocationPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedTab = 0;
  
  // Mock data for demonstration
  final Map<String, Map<String, dynamic>> locationData = {
    'cash': {
      'balance': 1233208,
      'income': 4285122,
      'spending': 3051914,
      'totalJournal': {
        'date': 'Aug 13',
        'totalIn': 5000000,
        'totalOut': 3766792,
      },
      'error': 0,
      'accounts': [
        {'name': 'Main Cashier', 'balance': 800000, 'errors': 0},
        {'name': 'Petty Cash', 'balance': 433208, 'errors': 2},
      ],
    },
    'bank': {
      'balance': 5650000,
      'income': 8500000,
      'spending': 2850000,
      'totalJournal': {
        'date': 'Aug 13',
        'totalIn': 9000000,
        'totalOut': 3350000,
      },
      'error': 0,
      'accounts': [
        {'name': 'KB Bank Main', 'balance': 3500000, 'errors': 1},
        {'name': 'Shinhan Business', 'balance': 2150000, 'errors': 0},
      ],
    },
    'vault': {
      'balance': 10000000,
      'income': 12000000,
      'spending': 2000000,
      'totalJournal': {
        'date': 'Aug 13',
        'totalIn': 12500000,
        'totalOut': 2500000,
      },
      'error': 0,
      'accounts': [
        {'name': 'Main Vault', 'balance': 7000000, 'errors': 0},
        {'name': 'Emergency Reserve', 'balance': 3000000, 'errors': 3},
      ],
    },
  };
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _selectedTab = _tabController.index;
      });
    });
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  
  String _formatCurrency(int amount) {
    final formatter = NumberFormat('#,###', 'en_US');
    return '₩${formatter.format(amount)}';
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
    final currentData = locationData[_currentLocationType]!;
    
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      body: SafeArea(
        child: Column(
          children: [
            // Header with back arrow, title, and edit button
            _buildHeader(context),
            
            // Tab Bar
            _buildTabBar(),
            
            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(TossSpacing.space4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Balance Section
                    _buildBalanceSection(currentData),
                    
                    SizedBox(height: TossSpacing.space4),
                    
                    // Accounts Section
                    _buildAccountsSection(currentData['accounts']),
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
              'Cash Control',
              style: TossTextStyles.h3.copyWith(
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          // Spacer to balance the layout
          SizedBox(width: 48),
        ],
      ),
    );
  }
  
  Widget _buildTabBar() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: TossSpacing.space4),
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
          dividerColor: Colors.transparent,
          overlayColor: WidgetStateProperty.all(Colors.transparent),
          tabs: const [
            Tab(text: 'Cash'),
            Tab(text: 'Bank'),
            Tab(text: 'Vault'),
          ],
        ),
      ),
    );
  }
  
  Widget _buildBalanceSection(Map<String, dynamic> data) {
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
          Text(
            'Balance',
            style: TossTextStyles.body.copyWith(
              fontWeight: FontWeight.w700,
              fontSize: 17,
            ),
          ),
          SizedBox(height: TossSpacing.space4),
          
          // Total Journal (previously Income)
          _buildBalanceRow(
            'Total Journal',
            _formatCurrency(data['income']),
            isIncome: true,
          ),
          
          SizedBox(height: TossSpacing.space3),
          
          // Total Real (previously Spending)
          _buildBalanceRow(
            'Total Real',
            _formatCurrency(data['spending']),
            isIncome: false,
          ),
          
          // Divider
          Container(
            margin: EdgeInsets.symmetric(vertical: TossSpacing.space4),
            height: 1,
            color: const Color(0xFFE5E8EB),
          ),
          
          // Error (previously Remaining balance)
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
                _formatCurrency(data['balance']),
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
  
  Widget _buildBalanceRow(String label, String amount, {required bool isIncome}) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        // Navigate to Total Journal page
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TotalJournalPage(
              locationType: _currentLocationType,
              journalType: label.toLowerCase().contains('journal') ? 'journal' : 'real',
            ),
          ),
        );
      },
      child: Row(
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
              Icon(
                Icons.chevron_right,
                size: 20,
                color: Colors.grey[400],
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildAccountsSection(List<dynamic> accounts) {
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
          Text(
            'Accounts',
            style: TossTextStyles.body.copyWith(
              fontWeight: FontWeight.w700,
              fontSize: 17,
            ),
          ),
          SizedBox(height: TossSpacing.space3),
          
          ...accounts.map((account) => _buildAccountCard(account)),
          
          // Add New Account button
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              // Navigate to Add Account page
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddAccountPage(
                    locationType: _currentLocationType,
                  ),
                ),
              );
            },
            child: Container(
              padding: EdgeInsets.symmetric(
                vertical: TossSpacing.space4,
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
          ),
        ],
      ),
    );
  }
  
  Widget _buildAccountCard(Map<String, dynamic> account) {
    // Calculate percentage (mock calculation)
    final totalBalance = locationData[_currentLocationType]!['balance'] as int;
    final accountBalance = account['balance'] as int;
    final percentage = ((accountBalance / totalBalance) * 100).round();
    
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        context.push(
          '/cashLocation/account/${Uri.encodeComponent(account['name'])}',
          extra: {
            'locationType': _currentLocationType,
            'balance': account['balance'],
            'errors': account['errors'] ?? 0,
          },
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: TossSpacing.space4,
        ),
        child: Row(
          children: [
              // Logo icon
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.08),
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
                      account['name'],
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
                        _formatCurrency(account['balance']),
                        style: TossTextStyles.body.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                      SizedBox(height: TossSpacing.space1),
                      Text(
                        '${account['errors'] ?? 0}',
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