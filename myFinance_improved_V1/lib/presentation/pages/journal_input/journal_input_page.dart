import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'models/journal_entry_model.dart';
import 'providers/journal_input_providers.dart';
import 'widgets/transaction_line_card.dart';
import 'widgets/add_transaction_dialog.dart';
import '../../providers/app_state_provider.dart';
import '../../widgets/common/toss_app_bar.dart';
import '../../../core/themes/toss_colors.dart';
import '../../../core/themes/toss_text_styles.dart';
import '../../../core/themes/toss_spacing.dart';
import '../../../core/themes/toss_border_radius.dart';

class JournalInputPage extends ConsumerStatefulWidget {
  const JournalInputPage({super.key});

  @override
  ConsumerState<JournalInputPage> createState() => _JournalInputPageState();
}

class _JournalInputPageState extends ConsumerState<JournalInputPage> 
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  final _descriptionController = TextEditingController();
  bool _isSubmitting = false;
  
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    _animationController.forward();
    
    // Initialize journal entry with company/store from app state
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final appState = ref.read(appStateProvider);
      final journalEntry = ref.read(journalEntryProvider);
      journalEntry.setSelectedCompany(appState.companyChoosen);
      journalEntry.setSelectedStore(appState.storeChoosen);
    });
  }
  
  @override
  void dispose() {
    _animationController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
  
  String _formatCurrency(double amount) {
    final formatter = NumberFormat('#,##0', 'en_US');
    return formatter.format(amount);
  }
  
  Color _getDifferenceColor(double difference) {
    if (difference.abs() < 0.01) return TossColors.success;
    return TossColors.error;
  }
  
  Future<void> _addTransactionLine([bool? isDebit]) async {
    final journalEntry = ref.read(journalEntryProvider);
    
    // Always suggest the difference amount if there is one
    double? suggestedAmount;
    if (journalEntry.difference.abs() > 0.01) {
      suggestedAmount = journalEntry.difference.abs();
    }
    
    // Determine default type
    bool defaultIsDebit;
    
    if (isDebit != null) {
      // If explicitly specified (from clicking Debit or Credit section)
      defaultIsDebit = isDebit;
    } else {
      // Auto-determine based on which side needs balancing
      if (journalEntry.totalDebits < journalEntry.totalCredits) {
        // Need more debits to balance
        defaultIsDebit = true;
      } else if (journalEntry.totalCredits < journalEntry.totalDebits) {
        // Need more credits to balance
        defaultIsDebit = false;
      } else {
        // Already balanced, default to debit
        defaultIsDebit = true;
      }
    }
    
    final result = await showModalBottomSheet<TransactionLine>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddTransactionDialog(
        initialIsDebit: defaultIsDebit,
        suggestedAmount: suggestedAmount,
      ),
    );
    
    if (result != null) {
      ref.read(journalEntryProvider).addTransactionLine(result);
    }
  }
  
  Future<void> _editTransactionLine(int index) async {
    final journalEntry = ref.read(journalEntryProvider);
    final existingLine = journalEntry.transactionLines[index];
    
    final result = await showModalBottomSheet<TransactionLine>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddTransactionDialog(
        existingLine: existingLine,
      ),
    );
    
    if (result != null) {
      journalEntry.updateTransactionLine(index, result);
    }
  }
  
  Future<void> _submitJournalEntry() async {
    final journalEntry = ref.read(journalEntryProvider);
    
    if (!journalEntry.canSubmit()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(journalEntry.isBalanced 
            ? 'Please add at least one transaction'
            : 'Debits and credits must be balanced'),
          backgroundColor: TossColors.error,
        ),
      );
      return;
    }
    
    setState(() => _isSubmitting = true);
    
    try {
      // Set the description
      journalEntry.setOverallDescription(
        _descriptionController.text.isNotEmpty ? _descriptionController.text : null
      );
      
      // Submit the journal entry
      final submitFunction = ref.read(submitJournalEntryProvider);
      await submitFunction(journalEntry);
      
      // Show success message
      if (mounted) {
        // Show success dialog
        await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(TossBorderRadius.lg),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.check_circle,
                    color: TossColors.success,
                    size: 64,
                  ),
                  SizedBox(height: TossSpacing.space3),
                  Text(
                    'Success!',
                    style: TossTextStyles.h3.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: TossSpacing.space2),
                  Text(
                    'Journal entry created successfully',
                    style: TossTextStyles.body.copyWith(
                      color: TossColors.gray600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('OK'),
                  style: TextButton.styleFrom(
                    foregroundColor: TossColors.primary,
                  ),
                ),
              ],
            );
          },
        );
        
        // Clear the form and reset journal entry
        _descriptionController.clear();
        journalEntry.clear();
        
        // Re-set company and store from app state after clearing
        final appState = ref.read(appStateProvider);
        journalEntry.setSelectedCompany(appState.companyChoosen);
        journalEntry.setSelectedStore(appState.storeChoosen);
        
        // Also show snackbar for additional feedback
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Ready for new journal entry'),
            backgroundColor: TossColors.info,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: TossColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final journalEntry = ref.watch(journalEntryProvider);
    final appState = ref.watch(appStateProvider);
    final selectedCompany = ref.watch(selectedCompanyProvider);
    final selectedStore = ref.watch(selectedStoreProvider);
    
    return Scaffold(
      backgroundColor: TossColors.gray50,
      appBar: TossAppBar(
        title: 'Journal Entry',
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 20),
          onPressed: () => context.pop(),
        ),
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Column(
          children: [
            // Date and Company Info
            Container(
              color: Colors.white,
              padding: EdgeInsets.all(TossSpacing.space4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Date Display
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.calendar_today, size: 16, color: TossColors.gray500),
                          const SizedBox(width: 8),
                          Text(
                            DateFormat('yyyy-MM-dd').format(journalEntry.entryDate),
                            style: TossTextStyles.bodySmall.copyWith(
                              color: TossColors.gray700,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  // Company and Store Info
                  if (appState.companyChoosen.isNotEmpty) ...[
                    SizedBox(height: TossSpacing.space2),
                    Row(
                      children: [
                        Icon(Icons.business, size: 16, color: TossColors.gray500),
                        SizedBox(width: 8),
                        Text(
                          selectedCompany?['company_name'] ?? 'Company',
                          style: TossTextStyles.bodySmall.copyWith(
                            color: TossColors.gray700,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        if (appState.storeChoosen.isNotEmpty) ...[
                          Text(' • ', style: TextStyle(color: TossColors.gray400)),
                          Text(
                            selectedStore?['store_name'] ?? 'Store',
                            style: TossTextStyles.bodySmall.copyWith(
                              color: TossColors.gray600,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ],
              ),
            ),
            
            // Balance Summary Card
            Container(
              color: Colors.white,
              margin: const EdgeInsets.only(top: 1),
              padding: EdgeInsets.all(TossSpacing.space4),
              child: Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () => _addTransactionLine(true),
                      borderRadius: BorderRadius.circular(TossBorderRadius.md),
                      child: _buildBalanceItem(
                        'Debits',
                        journalEntry.totalDebits,
                        journalEntry.debitCount,
                        TossColors.primary,
                        isClickable: true,
                      ),
                    ),
                  ),
                  Container(
                        width: 1,
                        height: 60,
                        color: TossColors.gray200,
                    margin: EdgeInsets.symmetric(horizontal: TossSpacing.space3),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () => _addTransactionLine(false),
                      borderRadius: BorderRadius.circular(TossBorderRadius.md),
                      child: _buildBalanceItem(
                        'Credits',
                        journalEntry.totalCredits,
                        journalEntry.creditCount,
                        TossColors.success,
                        isClickable: true,
                      ),
                    ),
                  ),
                  Container(
                        width: 1,
                        height: 60,
                        color: TossColors.gray200,
                    margin: EdgeInsets.symmetric(horizontal: TossSpacing.space3),
                  ),
                  Expanded(
                    child: _buildBalanceItem(
                      'Difference',
                      journalEntry.difference.abs(),
                      null,
                      _getDifferenceColor(journalEntry.difference),
                    ),
                  ),
                ],
              ),
            ),
            
            // Description Field
            Container(
              color: Colors.white,
              margin: EdgeInsets.only(top: 1),
              padding: EdgeInsets.all(TossSpacing.space4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Description (Optional)',
                    style: TossTextStyles.body.copyWith(
                      color: TossColors.gray700,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: TossSpacing.space2),
                  TextField(
                    controller: _descriptionController,
                    maxLines: 2,
                    style: TossTextStyles.body,
                    decoration: InputDecoration(
                      hintText: 'Enter journal description...',
                      hintStyle: TossTextStyles.body.copyWith(
                        color: TossColors.gray400,
                      ),
                      filled: true,
                      fillColor: TossColors.gray50,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(TossBorderRadius.md),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: EdgeInsets.all(TossSpacing.space3),
                    ),
                  ),
                ],
              ),
            ),
            
            // Transaction Lines
            Expanded(
              child: journalEntry.transactionLines.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: EdgeInsets.all(TossSpacing.space4),
                    itemCount: journalEntry.transactionLines.length,
                    itemBuilder: (context, index) {
                      final line = journalEntry.transactionLines[index];
                      return TransactionLineCard(
                        line: line,
                        index: index,
                        onEdit: () => _editTransactionLine(index),
                        onDelete: () {
                          journalEntry.removeTransactionLine(index);
                        },
                      );
                    },
                  ),
            ),
            
            // Bottom Actions
            Container(
              color: Colors.white,
              padding: EdgeInsets.all(TossSpacing.space4),
              child: SafeArea(
                child: Column(
                  children: [
                    // Add Transaction Button
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () => _addTransactionLine(),
                        icon: Icon(Icons.add_circle_outline, size: 20),
                        label: Text('Add Transaction'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: TossColors.primary,
                          side: BorderSide(color: TossColors.primary, width: 1.5),
                          padding: EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: TossSpacing.space3),
                    // Submit Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: journalEntry.canSubmit() && !_isSubmitting
                          ? _submitJournalEntry
                          : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: TossColors.primary,
                          foregroundColor: Colors.white,
                          disabledBackgroundColor: TossColors.gray200,
                          disabledForegroundColor: TossColors.gray400,
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                          ),
                          elevation: 0,
                        ),
                        child: _isSubmitting
                          ? SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : Text(
                              'Submit Journal Entry',
                              style: TossTextStyles.labelLarge.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildBalanceItem(String label, double amount, int? count, Color color, {bool isClickable = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                label,
                style: TossTextStyles.caption.copyWith(
                  color: TossColors.gray600,
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (isClickable) ...[
                SizedBox(width: 4),
                Icon(
                  Icons.add_circle_outline,
                  size: 14,
                  color: TossColors.gray500,
                ),
              ],
            ],
          ),
          SizedBox(height: 4),
          Text(
            _formatCurrency(amount),
            style: TossTextStyles.bodyLarge.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
            ),
          ),
          if (count != null) ...[
            SizedBox(height: 2),
            Text(
              '$count items',
              style: TossTextStyles.caption.copyWith(
                color: TossColors.gray500,
              ),
            ),
          ],
        ],
      ),
    );
  }
  
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.receipt_long_outlined,
            size: 64,
            color: TossColors.gray300,
          ),
          SizedBox(height: TossSpacing.space4),
          Text(
            'No transactions added',
            style: TossTextStyles.h3.copyWith(
              color: TossColors.gray700,
            ),
          ),
          SizedBox(height: TossSpacing.space2),
          Text(
            'Click Debits or Credits above to add transactions',
            style: TossTextStyles.body.copyWith(
              color: TossColors.gray500,
            ),
          ),
        ],
      ),
    );
  }
}