import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/themes/toss_colors.dart';
import '../../../core/themes/toss_text_styles.dart';
import '../../../core/themes/toss_border_radius.dart';
import '../../../core/themes/toss_spacing.dart';
import '../../../core/utils/number_formatter.dart';
import '../../widgets/common/toss_scaffold.dart';
import '../../widgets/common/toss_white_card.dart';
import '../../widgets/common/toss_app_bar.dart';
import '../../providers/app_state_provider.dart';
import 'providers/debt_control_providers.dart';
import '../../../data/models/transaction_history_model.dart';
import '../../../data/services/supabase_service.dart';
import 'widgets/edit_counterparty_sheet.dart';
import '../../../core/navigation/safe_navigation.dart';

class DebtRelationshipPage extends ConsumerStatefulWidget {
  final String counterpartyId;
  final String counterpartyName;

  const DebtRelationshipPage({
    super.key,
    required this.counterpartyId,
    required this.counterpartyName,
  });

  @override
  ConsumerState<DebtRelationshipPage> createState() => _DebtRelationshipPageState();
}

class _DebtRelationshipPageState extends ConsumerState<DebtRelationshipPage> {
  List<TransactionData>? _recentTransactions;
  bool _isLoadingTransactions = false;
  
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadRelationshipData();
      _loadRecentTransactions();
    });
  }

  Future<void> _loadRelationshipData() async {
    final appState = ref.read(appStateProvider);
    if (appState.companyChoosen.isEmpty) return;

    // Load debt data for this specific counterparty
    await ref.read(prioritizedDebtsProvider.notifier).loadPrioritizedDebts(
      companyId: appState.companyChoosen,
      storeId: appState.storeChoosen.isNotEmpty ? appState.storeChoosen : null,
      viewpoint: appState.storeChoosen.isNotEmpty ? 'store' : 'company',
      filter: 'all',
    );
  }
  
  Future<void> _loadRecentTransactions() async {
    if (_isLoadingTransactions) return;
    
    setState(() {
      _isLoadingTransactions = true;
    });
    
    try {
      final appState = ref.read(appStateProvider);
      final appStateNotifier = ref.read(appStateProvider.notifier);
      final selectedCompany = appStateNotifier.selectedCompany;
      
      if (selectedCompany == null) return;
      
      final supabase = ref.read(supabaseServiceProvider);
      
      // Determine perspective: Company view (no storeChoosen) or Store view (with storeChoosen)
      final isStoreView = appState.storeChoosen.isNotEmpty;
      
      
      // Use the existing get_transaction_history RPC function with counterparty filter
      final params = {
        'p_company_id': selectedCompany['company_id'],
        // Only pass store_id if we're in Store view, otherwise NULL for Company view
        'p_store_id': isStoreView ? appState.storeChoosen : null,
        'p_counterparty_id': widget.counterpartyId, // Filter by this counterparty
        'p_limit': 12, // Get 12 recent activities (show 10, but have extra in case)
        'p_offset': 0,
      };
      
      final response = await supabase.client.rpc(
        'get_transaction_history',
        params: params,
      );
      
      
      if (response != null) {
        List<dynamic> dataList;
        if (response is List) {
          dataList = response;
        } else if (response is Map && response.containsKey('data')) {
          dataList = response['data'] as List;
        } else {
          dataList = [];
        }
        
        final transactions = <TransactionData>[];
        for (final json in dataList) {
          try {
            final transaction = TransactionData.fromJson(json as Map<String, dynamic>);
            transactions.add(transaction);
            
          } catch (e) {
            // Error parsing transaction
          }
        }
        
        // Sort transactions by entry date in descending order (most recent first)
        transactions.sort((a, b) => b.entryDate.compareTo(a.entryDate));
        
        setState(() {
          _recentTransactions = transactions;
        });
      }
    } catch (e) {
      // Error loading recent transactions
    } finally {
      setState(() {
        _isLoadingTransactions = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final prioritizedDebts = ref.watch(prioritizedDebtsProvider);

    // Find the specific debt record for this counterparty
    final counterpartyDebt = prioritizedDebts.hasValue
        ? prioritizedDebts.value?.firstWhere(
            (debt) => debt.counterpartyId == widget.counterpartyId,
            orElse: () => prioritizedDebts.value!.first,
          )
        : null;


    return TossScaffold(
      appBar: TossAppBar(
        title: widget.counterpartyName,
        primaryActionText: 'Add',
        primaryActionIcon: Icons.add,
        onPrimaryAction: () => _showAddOptionsBottomSheet(context),
      ),
      backgroundColor: const Color(0xFFF7F8FA),
      body: SafeArea(
        child: Column(
          children: [
            
            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
              // Overview Summary Card
              if (counterpartyDebt != null)
                _buildOverviewCard(counterpartyDebt),
              
              const SizedBox(height: 12),

              // Transaction History Section
              _buildTransactionHistorySection(),
              
                    const SizedBox(height: 24), // Normal bottom spacing
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildOverviewCard(dynamic debt) {
    final isPositive = debt.amount >= 0;
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [TossColors.primary, TossColors.primary.withValues(alpha: 0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(TossBorderRadius.cardLarge),
        boxShadow: [
          BoxShadow(
            color: TossColors.primary.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with counterparty info
            Row(
              children: [
                Icon(
                  Icons.handshake_outlined,
                  color: TossColors.textInverse.withValues(alpha: 0.9),
                  size: 16,
                ),
                const SizedBox(width: 8),
                Text(
                  '${widget.counterpartyName} relationship',
                  style: TossTextStyles.body.copyWith(
                    color: TossColors.textInverse.withValues(alpha: 0.9),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 20),
            
            // Net Position
            Text(
              'Net Position',
              style: TossTextStyles.body.copyWith(
                color: TossColors.textInverse.withValues(alpha: 0.8),
              ),
            ),
            
            const SizedBox(height: 8),
            
            // Hero amount - white text on blue background like dashboard
            Text(
              NumberFormatter.formatCurrency(debt.amount.abs(), '₫'),
              style: TossTextStyles.display.copyWith(
                color: TossColors.textInverse,
                fontSize: 36,
                fontWeight: FontWeight.w800,
                height: 1.1,
              ),
            ),
            
            const SizedBox(height: 4),
            
            // Direction indicator
            Text(
              isPositive ? 'Net Receivable' : 'Net Payable',
              style: TossTextStyles.body.copyWith(
                color: TossColors.textInverse.withValues(alpha: 0.8),
                fontWeight: FontWeight.w500,
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Breakdown boxes similar to dashboard Internal/External
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: TossColors.white.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.trending_up,
                              color: TossColors.textInverse.withValues(alpha: 0.8),
                              size: 14,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Receivables',
                              style: TossTextStyles.caption.copyWith(
                                color: TossColors.textInverse.withValues(alpha: 0.8),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          NumberFormatter.formatCurrency(
                            debt.amount > 0 ? debt.amount : 0.0,
                            '₫',
                          ),
                          style: TossTextStyles.body.copyWith(
                            color: TossColors.textInverse,
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          'R: ${debt.transactionCount ~/ 2}',
                          style: TossTextStyles.small.copyWith(
                            color: TossColors.textInverse.withValues(alpha: 0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(width: 12),
                
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: TossColors.white.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.trending_down,
                              color: TossColors.textInverse.withValues(alpha: 0.8),
                              size: 14,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Payables',
                              style: TossTextStyles.caption.copyWith(
                                color: TossColors.textInverse.withValues(alpha: 0.8),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          NumberFormatter.formatCurrency(
                            debt.amount < 0 ? debt.amount.abs() : 0.0,
                            '₫',
                          ),
                          style: TossTextStyles.body.copyWith(
                            color: TossColors.textInverse,
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          'P: ${debt.transactionCount ~/ 2}',
                          style: TossTextStyles.small.copyWith(
                            color: TossColors.textInverse.withValues(alpha: 0.7),
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
      ),
    );
  }


  List<Widget> _buildTransactionItems() {
    final widgets = <Widget>[];
    final itemCount = _recentTransactions!.length > 10 ? 10 : _recentTransactions!.length;
    
    for (int i = 0; i < itemCount; i++) {
      widgets.add(_buildRealTransactionItem(_recentTransactions![i]));
      if (i < itemCount - 1) {
        widgets.add(const SizedBox(height: 12));
      }
    }
    
    // Add View All button at the bottom if there are more transactions
    if (_recentTransactions!.length > 10 || itemCount == 10) {
      widgets.add(const SizedBox(height: 20));
      widgets.add(_buildBottomViewAllButton());
    }
    
    return widgets;
  }
  
  Widget _buildBottomViewAllButton() {
    final appState = ref.read(appStateProvider);
    final isStoreView = appState.storeChoosen.isNotEmpty;
    
    return GestureDetector(
      onTap: () => context.safePush(
        '/transactionHistory?counterparty=${widget.counterpartyId}&scope=${isStoreView ? "store" : "company"}',
        extra: {'counterpartyName': widget.counterpartyName},
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: TossColors.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(TossBorderRadius.md),
          border: Border.all(
            color: TossColors.primary.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'View All Transactions',
                style: TossTextStyles.body.copyWith(
                  color: TossColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.arrow_forward,
                size: 16,
                color: TossColors.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildTransactionHistorySection() {
    return TossWhiteCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent Activity',
                style: TossTextStyles.h4.copyWith(
                  color: TossColors.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              GestureDetector(
                onTap: () {
                  final appState = ref.read(appStateProvider);
                  final isStoreView = appState.storeChoosen.isNotEmpty;
                  context.safePush(
                    '/transactionHistory?counterparty=${widget.counterpartyId}&scope=${isStoreView ? "store" : "company"}',
                    extra: {'counterpartyName': widget.counterpartyName},
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: TossColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    'View All',
                    style: TossTextStyles.caption.copyWith(
                      color: TossColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 20),
          
          // Loading or transactions
          if (_isLoadingTransactions)
            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 32),
                child: CircularProgressIndicator(),
              ),
            )
          else if (_recentTransactions != null && _recentTransactions!.isNotEmpty)
            ..._buildTransactionItems()
          else if (_recentTransactions != null && _recentTransactions!.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 32),
              child: Column(
                children: [
                  Icon(
                    Icons.receipt_long_outlined,
                    size: 48,
                    color: TossColors.textSecondary.withValues(alpha: 0.5),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No recent transactions',
                    style: TossTextStyles.body.copyWith(
                      color: TossColors.textSecondary,
                    ),
                  ),
                ],
              ),
            )
        ],
      ),
    );
  }

  Widget _buildRealTransactionItem(TransactionData transaction) {
    // Calculate the total amount from journal lines
    double totalAmount = 0;
    
    // Determine if this is a receivable or payable
    bool isReceivable = false;
    bool hasCounterpartyLine = false;
    
    // Since the transaction is already filtered by counterparty, 
    // we should use the total transaction amount
    // The transaction shows movement with this specific counterparty
    totalAmount = transaction.totalAmount;
    
    // Determine if it's receivable or payable based on journal type and lines
    // Look for lines that have this counterparty
    for (final line in transaction.lines) {
      final counterpartyData = line.counterparty;
      if (counterpartyData != null && counterpartyData['id'] == widget.counterpartyId) {
        hasCounterpartyLine = true;
        // In accounting:
        // - If we DEBIT a counterparty account (A/R), they OWE us (receivable)
        // - If we CREDIT a counterparty account (A/P), we OWE them (payable)
        if (line.isDebit) {
          // We debited counterparty = Receivable (they owe us)
          isReceivable = true;
        } else {
          // We credited counterparty = Payable (we owe them)
          isReceivable = false;
        }
        break;
      }
    }
    
    // Fallback: use total debit/credit comparison if no specific counterparty line
    if (!hasCounterpartyLine) {
      isReceivable = transaction.totalDebit > transaction.totalCredit;
    }
    
    
    // Format the date
    final now = DateTime.now();
    final transactionDate = transaction.entryDate;
    final difference = now.difference(transactionDate);
    String formattedDate;
    
    // Handle negative differences (future dates) or wrong dates
    if (difference.inDays < 0) {
      // Date is in the future or wrong year - show actual date
      formattedDate = '${transactionDate.day}/${transactionDate.month}/${transactionDate.year}';
    } else if (difference.inDays == 0) {
      formattedDate = 'Today';
    } else if (difference.inDays == 1) {
      formattedDate = 'Yesterday';
    } else if (difference.inDays < 7) {
      formattedDate = '${difference.inDays} days ago';
    } else if (difference.inDays < 30) {
      formattedDate = '${(difference.inDays / 7).ceil()} weeks ago';
    } else if (difference.inDays < 365) {
      formattedDate = '${(difference.inDays / 30).ceil()} months ago';
    } else {
      formattedDate = '${transactionDate.day}/${transactionDate.month}/${transactionDate.year}';
    }
    
    // Determine transaction type display name
    String displayType = transaction.description.isNotEmpty 
      ? transaction.description 
      : (transaction.journalType.isNotEmpty ? transaction.journalType : 'Transaction');
    
    return Row(
      children: [
        // Simple dot indicator
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            // Green for receivables (money we will receive), Red for payables (money we owe)
            color: isReceivable ? TossColors.success : TossColors.error,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        
        const SizedBox(width: 16),
        
        // Transaction details
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                displayType,
                style: TossTextStyles.body.copyWith(
                  fontWeight: FontWeight.w600,
                  color: TossColors.textPrimary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                formattedDate,
                style: TossTextStyles.caption.copyWith(
                  color: TossColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        
        // Amount
        Text(
          NumberFormatter.formatCurrency(totalAmount.abs(), '₫'),
          style: TossTextStyles.body.copyWith(
            fontWeight: FontWeight.w700,
            color: TossColors.textPrimary,
          ),
        ),
      ],
    );
  }



  String _determineSuggestedAccountType() {
    // Analyze current debt position to suggest appropriate account type
    final prioritizedDebts = ref.read(prioritizedDebtsProvider);
    
    if (prioritizedDebts.hasValue && prioritizedDebts.value != null) {
      final counterpartyDebt = prioritizedDebts.value?.firstWhere(
        (debt) => debt.counterpartyId == widget.counterpartyId,
        orElse: () => prioritizedDebts.value!.first,
      );
      
      if (counterpartyDebt != null) {
        // If we have a net receivable (positive), suggest creating more receivables
        // If we have a net payable (negative), suggest creating more payables
        return counterpartyDebt.amount >= 0 ? 'receivable' : 'payable';
      }
    }
    
    // Default to receivable if no existing relationship
    return 'receivable';
  }

  void _showAddOptionsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: TossColors.surface,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(TossBorderRadius.xxl),
          ),
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: EdgeInsets.all(TossSpacing.space5),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Handle bar
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: TossColors.gray300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                
                SizedBox(height: TossSpacing.space5),
                
                // Header
                Text(
                  'Add New',
                  style: TossTextStyles.h3.copyWith(
                    fontWeight: FontWeight.w700,
                    color: TossColors.textPrimary,
                  ),
                ),
                
                SizedBox(height: TossSpacing.space6),
                
                // Option 1: Create Transaction
                _buildBottomSheetOption(
                  icon: Icons.receipt_long,
                  title: 'Create Transaction',
                  subtitle: 'Add a new debt transaction',
                  onTap: () {
                    Navigator.pop(context);
                    // Navigate to journal input with pre-filled counterparty data
                    context.safePush(
                      '/journalInput',
                      extra: {
                        'mode': 'debt_transaction',
                        'counterpartyId': widget.counterpartyId,
                        'counterpartyName': widget.counterpartyName,
                        'transactionContext': 'debt',
                        // Determine suggested account type based on current debt position
                        'suggestedAccountType': _determineSuggestedAccountType(),
                        'contextMessage': 'Creating debt transaction for ${widget.counterpartyName}',
                      },
                    );
                  },
                ),
                
                SizedBox(height: TossSpacing.space3),
                
                // Option 2: Account Mapping
                _buildBottomSheetOption(
                  icon: Icons.account_tree,
                  title: 'Account Mapping',
                  subtitle: 'Configure account relationships',
                  onTap: () {
                    Navigator.pop(context);
                    context.safePush(
                      '/debtAccountSettings/${Uri.encodeComponent(widget.counterpartyId)}/${Uri.encodeComponent(widget.counterpartyName)}',
                    );
                  },
                ),
                
                SizedBox(height: TossSpacing.space3),
                
                // Option 3: Edit
                _buildBottomSheetOption(
                  icon: Icons.edit,
                  title: 'Edit',
                  subtitle: 'Edit counterparty details',
                  onTap: () async {
                    Navigator.pop(context);
                    await EditCounterpartySheet.show(
                      context,
                      counterpartyId: widget.counterpartyId,
                      counterpartyName: widget.counterpartyName,
                      onUpdate: () {
                        // Refresh the page data when counterparty is updated
                        _loadRelationshipData();
                        _loadRecentTransactions();
                        
                        // Show success message
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Counterparty updated successfully'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      },
                    );
                  },
                ),
                
                SizedBox(height: TossSpacing.space4),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomSheetOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(TossSpacing.space4),
          child: Row(
            children: [
              // Icon container
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: TossColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                ),
                child: Icon(
                  icon,
                  color: TossColors.primary,
                  size: 24,
                ),
              ),
              
              SizedBox(width: TossSpacing.space4),
              
              // Text content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TossTextStyles.body.copyWith(
                        fontWeight: FontWeight.w600,
                        color: TossColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: TossSpacing.space1),
                    Text(
                      subtitle,
                      style: TossTextStyles.caption.copyWith(
                        color: TossColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Arrow icon
              Icon(
                Icons.chevron_right,
                color: TossColors.textTertiary,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}