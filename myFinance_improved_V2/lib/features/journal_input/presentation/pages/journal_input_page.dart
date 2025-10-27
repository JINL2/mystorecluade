import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

// Domain
import '../../domain/entities/transaction_line.dart';

// Presentation
import '../providers/journal_input_providers.dart';
import '../widgets/transaction_line_card.dart';
import '../widgets/add_transaction_dialog.dart';

// App
import '../../../../app/providers/app_state_provider.dart';

// Shared widgets
import '../../../../shared/widgets/common/toss_app_bar_1.dart';
import '../../../../shared/widgets/common/toss_scaffold.dart';
import '../../../../shared/widgets/common/toss_white_card.dart';
import '../../../../shared/widgets/common/toss_empty_view.dart';
import '../../../../shared/widgets/toss/toss_primary_button.dart';
import '../../../../shared/widgets/toss/toss_secondary_button.dart';
import '../../../../shared/widgets/toss/toss_enhanced_text_field.dart';

// Shared themes
import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_text_styles.dart';
import '../../../../shared/themes/toss_spacing.dart';
import '../../../../shared/themes/toss_border_radius.dart';

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
      _descriptionController.clear();

      // Initialize with company/store from app state
      final notifier = ref.read(journalEntryStateProvider.notifier);
      if (appState.companyChoosen.isNotEmpty) {
        notifier.setSelectedCompany(appState.companyChoosen);
      }
      if (appState.storeChoosen.isNotEmpty) {
        notifier.setSelectedStore(appState.storeChoosen);
      }
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
    final state = ref.read(journalEntryStateProvider);

    // Suggest the difference amount if there is one
    double? suggestedAmount;
    final difference = state.difference;
    if (difference.abs() > 0.01) {
      suggestedAmount = difference.abs();
    }

    // Determine default type
    bool defaultIsDebit;

    if (isDebit != null) {
      defaultIsDebit = isDebit;
    } else {
      // Auto-determine based on which side needs balancing
      final totalDebits = state.totalDebits;
      final totalCredits = state.totalCredits;
      if (totalDebits < totalCredits) {
        defaultIsDebit = true;
      } else if (totalCredits < totalDebits) {
        defaultIsDebit = false;
      } else {
        defaultIsDebit = true;
      }
    }

    // Get already used cash locations
    final usedCashLocations = state.transactionLines
        .where((line) => line.categoryTag == 'cash' && line.cashLocationId != null)
        .map((line) => line.cashLocationId!)
        .toSet();

    final result = await showModalBottomSheet<TransactionLine>(
      context: context,
      isScrollControlled: true,
      backgroundColor: TossColors.transparent,
      useRootNavigator: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: AddTransactionDialog(
          initialIsDebit: defaultIsDebit,
          suggestedAmount: suggestedAmount,
          blockedCashLocationIds: usedCashLocations,
        ),
      ),
    );

    if (result != null) {
      ref.read(journalEntryStateProvider.notifier).addTransactionLine(result);

      // If the transaction line has a counterparty cash location, update state
      if (result.counterpartyCashLocationId != null) {
        ref.read(journalEntryStateProvider.notifier).setCounterpartyCashLocation(
          result.counterpartyCashLocationId,
        );
      }
    }
  }

  Future<void> _editTransactionLine(int index) async {
    final journalEntry = ref.read(journalEntryStateProvider);
    final existingLine = journalEntry.transactionLines[index];

    // Get already used cash locations, excluding the current line being edited
    final usedCashLocations = journalEntry.transactionLines
        .asMap()
        .entries
        .where((entry) => entry.key != index &&
               entry.value.categoryTag == 'cash' &&
               entry.value.cashLocationId != null)
        .map((entry) => entry.value.cashLocationId!)
        .toSet();

    final result = await showModalBottomSheet<TransactionLine>(
      context: context,
      isScrollControlled: true,
      backgroundColor: TossColors.transparent,
      useRootNavigator: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: AddTransactionDialog(
          existingLine: existingLine,
          blockedCashLocationIds: usedCashLocations,
        ),
      ),
    );

    if (result != null) {
      ref.read(journalEntryStateProvider.notifier).updateTransactionLine(index, result);

      // If the transaction line has a counterparty cash location, update state
      if (result.counterpartyCashLocationId != null) {
        ref.read(journalEntryStateProvider.notifier).setCounterpartyCashLocation(
          result.counterpartyCashLocationId,
        );
      }
    }
  }

  Future<void> _submitJournalEntry() async {
    final journalEntry = ref.read(journalEntryStateProvider);

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
      final appState = ref.read(appStateProvider);

      // Get current journal entry as entity
      final notifier = ref.read(journalEntryStateProvider.notifier);
      final currentEntry = notifier.getCurrentJournalEntry();

      // Update description
      final updatedJournalEntry = currentEntry.copyWith(
        overallDescription: _descriptionController.text.isNotEmpty ? _descriptionController.text : null,
      );

      // Get user ID from app state or auth
      final userId = appState.userId;
      if (userId.isEmpty) {
        throw Exception('User not authenticated');
      }

      // Submit the journal entry
      final submitFunction = ref.read(submitJournalEntryProvider);
      await submitFunction(
        updatedJournalEntry,
        userId,
        appState.companyChoosen,
        appState.storeChoosen.isNotEmpty ? appState.storeChoosen : null,
      );

      // Show success message
      if (mounted) {
        // Clear the form and reset journal entry immediately after success
        _descriptionController.clear();
        notifier.clear();

        // Show success dialog
        await showDialog<void>(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext dialogContext) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(TossBorderRadius.lg),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.check_circle,
                    color: TossColors.success,
                    size: 64,
                  ),
                  const SizedBox(height: TossSpacing.space3),
                  Text(
                    'Success!',
                    style: TossTextStyles.h3.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: TossSpacing.space2),
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
                  onPressed: () {
                    Navigator.of(dialogContext).pop(); // Close dialog
                    Navigator.of(context).pop(); // Navigate back to previous page
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: TossColors.primary,
                  ),
                  child: const Text('OK'),
                ),
              ],
            );
          },
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
    final journalEntry = ref.watch(journalEntryStateProvider);
    final appState = ref.watch(appStateProvider);

    return TossScaffold(
      backgroundColor: TossColors.gray100,
      resizeToAvoidBottomInset: false,
      appBar: TossAppBar1(
        title: 'Journal Entry',
        backgroundColor: TossColors.gray100,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: TossColors.gray700, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Date and Company/Store info bar
                    TossWhiteCard(
                      margin: const EdgeInsets.symmetric(
                        horizontal: TossSpacing.space4,
                        vertical: TossSpacing.space2,
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: TossSpacing.space4,
                        vertical: TossSpacing.space3,
                      ),
                      showBorder: false,
                      child: Row(
                        children: [
                          // Date
                          Text(
                            DateFormat('MMM d, yyyy').format(journalEntry.entryDate ?? DateTime.now()),
                            style: TossTextStyles.caption.copyWith(
                              color: TossColors.gray600,
                            ),
                          ),
                          if (appState.companyChoosen.isNotEmpty) ...[
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: TossSpacing.space2),
                              child: SizedBox(
                                width: 1,
                                height: 12,
                                child: ColoredBox(color: TossColors.gray200),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                appState.storeChoosen.isNotEmpty
                                    ? '${appState.companyName} • ${appState.storeName}'
                                    : appState.companyName,
                                style: TossTextStyles.caption.copyWith(
                                  color: TossColors.gray600,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),

                    // Balance Summary Card
                    TossWhiteCard(
                      margin: const EdgeInsets.symmetric(
                        horizontal: TossSpacing.space4,
                        vertical: TossSpacing.space2,
                      ),
                      padding: const EdgeInsets.all(TossSpacing.space4),
                      showBorder: false,
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
                            margin: const EdgeInsets.symmetric(horizontal: TossSpacing.space3),
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
                            margin: const EdgeInsets.symmetric(horizontal: TossSpacing.space3),
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
                    TossWhiteCard(
                      margin: const EdgeInsets.symmetric(
                        horizontal: TossSpacing.space4,
                        vertical: TossSpacing.space2,
                      ),
                      padding: const EdgeInsets.all(TossSpacing.space4),
                      showBorder: false,
                      child: TossEnhancedTextField(
                        controller: _descriptionController,
                        label: 'Description (Optional)',
                        hintText: 'Enter journal description...',
                        maxLines: 2,
                        textInputAction: TextInputAction.newline,
                        showKeyboardToolbar: false,
                      ),
                    ),

                    // Transaction Lines Section
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: TossSpacing.space4,
                        vertical: TossSpacing.space2,
                      ),
                      child: journalEntry.transactionLines.isEmpty
                        ? _buildEmptyState()
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: journalEntry.transactionLines.asMap().entries.map((entry) {
                              final index = entry.key;
                              final line = entry.value;
                              return TransactionLineCard(
                                line: line,
                                index: index,
                                onEdit: () => _editTransactionLine(index),
                                onDelete: () {
                                  ref.read(journalEntryStateProvider.notifier).removeTransactionLine(index);
                                },
                              );
                            }).toList(),
                          ),
                    ),

                    // Add some padding at the bottom
                    const SizedBox(height: TossSpacing.space5),
                  ],
                ),
              ),
            ),

            // Bottom Actions
            Container(
              decoration: BoxDecoration(
                color: TossColors.white,
                boxShadow: [
                  BoxShadow(
                    color: TossColors.black.withValues(alpha: 0.06),
                    blurRadius: 12,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(TossSpacing.space4),
              child: SafeArea(
                child: Column(
                  children: [
                    // Add Transaction Button
                    TossSecondaryButton(
                      text: 'Add Transaction',
                      onPressed: () => _addTransactionLine(),
                      leadingIcon: const Icon(Icons.add_circle_outline, size: 20),
                      fullWidth: true,
                    ),
                    const SizedBox(height: TossSpacing.space3),
                    // Submit Button
                    TossPrimaryButton(
                      text: 'Submit Journal Entry',
                      onPressed: journalEntry.canSubmit() && !_isSubmitting
                          ? _submitJournalEntry
                          : null,
                      isLoading: _isSubmitting,
                      isEnabled: journalEntry.canSubmit(),
                      fullWidth: true,
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
      padding: const EdgeInsets.symmetric(vertical: TossSpacing.space2),
      child: Column(
        children: [
          Text(
            label,
            style: TossTextStyles.caption.copyWith(
              color: TossColors.gray600,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            _formatCurrency(amount),
            style: TossTextStyles.bodyLarge.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
            ),
          ),
          if (count != null) ...[
            const SizedBox(height: 2),
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
    return TossWhiteCard(
      margin: const EdgeInsets.symmetric(
        vertical: TossSpacing.space4,
      ),
      padding: const EdgeInsets.all(TossSpacing.space6),
      showBorder: false,
      child: TossEmptyView(
        icon: Container(
          padding: const EdgeInsets.all(TossSpacing.space4),
          decoration: const BoxDecoration(
            color: TossColors.gray50,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.receipt_long_outlined,
            size: 48,
            color: TossColors.gray400,
          ),
        ),
        title: 'No transactions yet',
        description: 'Tap Debits or Credits above to add',
      ),
    );
  }
}
