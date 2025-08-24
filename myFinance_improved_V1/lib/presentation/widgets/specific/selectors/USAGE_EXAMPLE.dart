// =====================================================
// USAGE EXAMPLE FOR SMART ACCOUNT SELECTOR
// How to use the new smart account selector in your pages
// =====================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'smart_account_selector.dart';

// Example usage in a transaction form
class ExampleTransactionForm extends ConsumerStatefulWidget {
  @override
  ConsumerState<ExampleTransactionForm> createState() => _ExampleTransactionFormState();
}

class _ExampleTransactionFormState extends ConsumerState<ExampleTransactionForm> {
  String? selectedAccountId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Transaction Form')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // OLD WAY - Basic selector (still works)
            // AutonomousAccountSelector(
            //   selectedAccountId: selectedAccountId,
            //   onChanged: (id) => setState(() => selectedAccountId = id),
            //   label: 'Account',
            //   contextType: 'transaction', // <- Add this for tracking
            // ),

            // NEW WAY - Smart selector with quick access
            SmartAccountSelector(
              selectedAccountId: selectedAccountId,
              onChanged: (id) => setState(() => selectedAccountId = id),
              label: 'Account',
              contextType: 'transaction', // Important: tells system what this is for
              showQuickAccess: true, // Show quick access grid
              maxQuickItems: 6, // How many quick items to show
            ),

            SizedBox(height: 20),
            
            Text('Selected Account: $selectedAccountId'),
          ],
        ),
      ),
    );
  }
}

// Example for template creation
class ExampleTemplateForm extends ConsumerStatefulWidget {
  @override
  ConsumerState<ExampleTemplateForm> createState() => _ExampleTemplateFormState();
}

class _ExampleTemplateFormState extends ConsumerState<ExampleTemplateForm> {
  String? selectedAccountId;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SmartAccountSelector(
          selectedAccountId: selectedAccountId,
          onChanged: (id) => setState(() => selectedAccountId = id),
          label: 'Account',
          contextType: 'template', // Different context = different quick access data
          accountType: 'expense', // Optional: filter by account type
        ),
      ],
    );
  }
}

// Example for journal entry
class ExampleJournalEntryForm extends ConsumerStatefulWidget {
  @override
  ConsumerState<ExampleJournalEntryForm> createState() => _ExampleJournalEntryFormState();
}

class _ExampleJournalEntryFormState extends ConsumerState<ExampleJournalEntryForm> {
  String? debitAccountId;
  String? creditAccountId;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Debit account
        SmartAccountSelector(
          selectedAccountId: debitAccountId,
          onChanged: (id) => setState(() => debitAccountId = id),
          label: 'Debit Account',
          contextType: 'journal_entry',
        ),
        
        SizedBox(height: 16),
        
        // Credit account
        SmartAccountSelector(
          selectedAccountId: creditAccountId,
          onChanged: (id) => setState(() => creditAccountId = id),
          label: 'Credit Account', 
          contextType: 'journal_entry',
        ),
      ],
    );
  }
}

/* 
MIGRATION GUIDE:

1. EXISTING CODE (still works):
   AutonomousAccountSelector(...)

2. ADD TRACKING TO EXISTING:
   AutonomousAccountSelector(
     ...
     contextType: 'transaction', // <- Just add this line
   )

3. NEW SMART SELECTOR:
   SmartAccountSelector(
     ...
     contextType: 'transaction', // <- Required for smart features
     showQuickAccess: true,      // <- Enable quick access
   )

CONTEXT TYPES:
- 'transaction' - for transaction creation
- 'template' - for template creation  
- 'journal_entry' - for journal entries
- 'general' - for other uses

DATABASE FUNCTIONS EXPECTED:
- log_account_usage(p_user_id, p_company_id, p_store_id, p_account_id, p_context_type, p_selection_method)
- get_user_quick_access_accounts(p_user_id, p_company_id, p_store_id, p_context_type, p_limit)

**/