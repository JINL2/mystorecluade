// =====================================================
// AUTONOMOUS SELECTOR USAGE EXAMPLES
// Demonstrates how to use autonomous selectors across the app
// =====================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'autonomous_account_selector.dart';
import 'autonomous_cash_location_selector.dart';
import 'autonomous_counterparty_selector.dart';

/// Example page showing autonomous selector usage
class AutonomousSelectorExamplesPage extends ConsumerStatefulWidget {
  const AutonomousSelectorExamplesPage({super.key});

  @override
  ConsumerState<AutonomousSelectorExamplesPage> createState() => _AutonomousSelectorExamplesPageState();
}

class _AutonomousSelectorExamplesPageState extends ConsumerState<AutonomousSelectorExamplesPage> {
  // State for single selections
  String? _selectedAccountId;
  String? _selectedCashLocationId;
  String? _selectedCounterpartyId;
  
  // State for multi selections
  List<String> _selectedAccountIds = [];
  List<String> _selectedCounterpartyIds = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Autonomous Selector Examples'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            const Text(
              'Single Selection Examples',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            
            // Account Selector Examples
            const Text('Account Selectors', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            
            // General account selector
            AutonomousAccountSelector(
              selectedAccountId: _selectedAccountId,
              onChanged: (accountId) {
                setState(() {
                  _selectedAccountId = accountId;
                });
              },
            ),
            const SizedBox(height: 16),
            
            // Asset accounts only
            const AutonomousAccountSelector(
              accountType: 'asset',
              selectedAccountId: null,
              onChanged: null, // Read-only for demo
            ),
            const SizedBox(height: 16),
            
            // Expense accounts only
            const AutonomousAccountSelector(
              accountType: 'expense',
              label: 'Expense Account',
              hint: 'Select an expense account',
              selectedAccountId: null,
              onChanged: null, // Read-only for demo
            ),
            const SizedBox(height: 24),
            
            // Cash Location Selector Examples
            const Text('Cash Location Selectors', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            
            // Cash location with scope tabs
            AutonomousCashLocationSelector(
              selectedLocationId: _selectedCashLocationId,
              onChanged: (locationId) {
                setState(() {
                  _selectedCashLocationId = locationId;
                });
              },
              showScopeTabs: true,
            ),
            const SizedBox(height: 16),
            
            // Cash location without scope tabs (simple selector)
            const AutonomousCashLocationSelector(
              showScopeTabs: false,
              label: 'Simple Cash Location',
              selectedLocationId: null,
              onChanged: null, // Read-only for demo
            ),
            const SizedBox(height: 16),
            
            // Bank accounts only
            const AutonomousCashLocationSelector(
              locationType: 'bank',
              label: 'Bank Account',
              hint: 'Select bank account',
              showScopeTabs: false,
              selectedLocationId: null,
              onChanged: null, // Read-only for demo
            ),
            const SizedBox(height: 24),
            
            // Counterparty Selector Examples
            const Text('Counterparty Selectors', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            
            // General counterparty selector
            AutonomousCounterpartySelector(
              selectedCounterpartyId: _selectedCounterpartyId,
              onChanged: (counterpartyId) {
                setState(() {
                  _selectedCounterpartyId = counterpartyId;
                });
              },
            ),
            const SizedBox(height: 16),
            
            // Customers only
            const AutonomousCounterpartySelector(
              counterpartyType: 'customer',
              selectedCounterpartyId: null,
              onChanged: null, // Read-only for demo
            ),
            const SizedBox(height: 16),
            
            // Internal counterparties only
            const AutonomousCounterpartySelector(
              isInternal: true,
              label: 'Internal Counterparty',
              selectedCounterpartyId: null,
              onChanged: null, // Read-only for demo
            ),
            const SizedBox(height: 32),
            
            // Multi Selection Examples
            const Text(
              'Multi Selection Examples',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            
            // Multi account selector
            AutonomousMultiAccountSelector(
              selectedAccountIds: _selectedAccountIds,
              onChanged: (accountIds) {
                setState(() {
                  _selectedAccountIds = accountIds ?? [];
                });
              },
            ),
            const SizedBox(height: 16),
            
            // Multi expense accounts
            const AutonomousMultiAccountSelector(
              accountType: 'expense',
              selectedAccountIds: [],
              onChanged: null, // Read-only for demo
            ),
            const SizedBox(height: 16),
            
            // Multi counterparty selector
            AutonomousMultiCounterpartySelector(
              selectedCounterpartyIds: _selectedCounterpartyIds,
              onChanged: (counterpartyIds) {
                setState(() {
                  _selectedCounterpartyIds = counterpartyIds ?? [];
                });
              },
            ),
            const SizedBox(height: 16),
            
            // Multi customers
            const AutonomousMultiCounterpartySelector(
              counterpartyType: 'customer',
              selectedCounterpartyIds: [],
              onChanged: null, // Read-only for demo
            ),
            const SizedBox(height: 32),
            
            // Current Selections Display
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Current Selections:', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text('Account ID: ${_selectedAccountId ?? 'None'}'),
                  Text('Cash Location ID: ${_selectedCashLocationId ?? 'None'}'),
                  Text('Counterparty ID: ${_selectedCounterpartyId ?? 'None'}'),
                  Text('Selected Accounts: ${_selectedAccountIds.length} items'),
                  Text('Selected Counterparties: ${_selectedCounterpartyIds.length} items'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Example usage in Journal Input Page
class JournalInputPageExample extends ConsumerStatefulWidget {
  const JournalInputPageExample({super.key});

  @override
  ConsumerState<JournalInputPageExample> createState() => _JournalInputPageExampleState();
}

class _JournalInputPageExampleState extends ConsumerState<JournalInputPageExample> {
  String? _fromAccountId;
  String? _toAccountId;
  String? _counterpartyId;
  String? _cashLocationId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Journal Entry - Autonomous Selectors'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // From Account (Asset accounts only)
            AutonomousAccountSelector(
              accountType: 'asset',
              label: 'From Account',
              hint: 'Select source account',
              selectedAccountId: _fromAccountId,
              onChanged: (accountId) {
                setState(() {
                  _fromAccountId = accountId;
                });
              },
            ),
            const SizedBox(height: 16),
            
            // To Account (Any account)
            AutonomousAccountSelector(
              label: 'To Account',
              hint: 'Select destination account',
              selectedAccountId: _toAccountId,
              onChanged: (accountId) {
                setState(() {
                  _toAccountId = accountId;
                });
              },
            ),
            const SizedBox(height: 16),
            
            // Counterparty (External only)
            AutonomousCounterpartySelector(
              isInternal: false,
              label: 'External Counterparty',
              selectedCounterpartyId: _counterpartyId,
              onChanged: (counterpartyId) {
                setState(() {
                  _counterpartyId = counterpartyId;
                });
              },
            ),
            const SizedBox(height: 16),
            
            // Cash Location
            AutonomousCashLocationSelector(
              selectedLocationId: _cashLocationId,
              onChanged: (locationId) {
                setState(() {
                  _cashLocationId = locationId;
                });
              },
            ),
            const SizedBox(height: 32),
            
            // Submit Button
            ElevatedButton(
              onPressed: _fromAccountId != null && _toAccountId != null
                  ? () {
                      // Process journal entry
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Journal entry would be created here')),
                      );
                    }
                  : null,
              child: const Text('Create Journal Entry'),
            ),
          ],
        ),
      ),
    );
  }
}

/// Example usage in Transaction Filter
class TransactionFilterExample extends ConsumerStatefulWidget {
  const TransactionFilterExample({super.key});

  @override
  ConsumerState<TransactionFilterExample> createState() => _TransactionFilterExampleState();
}

class _TransactionFilterExampleState extends ConsumerState<TransactionFilterExample> {
  List<String> _selectedAccountIds = [];
  List<String> _selectedCounterpartyIds = [];
  String? _selectedCashLocationId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaction Filter - Autonomous Selectors'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Multi Account Selection
            AutonomousMultiAccountSelector(
              label: 'Filter by Accounts',
              hint: 'Select accounts to filter',
              selectedAccountIds: _selectedAccountIds,
              onChanged: (accountIds) {
                setState(() {
                  _selectedAccountIds = accountIds ?? [];
                });
              },
            ),
            const SizedBox(height: 16),
            
            // Multi Counterparty Selection
            AutonomousMultiCounterpartySelector(
              label: 'Filter by Counterparties',
              hint: 'Select counterparties to filter',
              selectedCounterpartyIds: _selectedCounterpartyIds,
              onChanged: (counterpartyIds) {
                setState(() {
                  _selectedCounterpartyIds = counterpartyIds ?? [];
                });
              },
            ),
            const SizedBox(height: 16),
            
            // Single Cash Location
            AutonomousCashLocationSelector(
              label: 'Filter by Cash Location',
              selectedLocationId: _selectedCashLocationId,
              onChanged: (locationId) {
                setState(() {
                  _selectedCashLocationId = locationId;
                });
              },
            ),
            const SizedBox(height: 32),
            
            // Apply Filter Button
            ElevatedButton(
              onPressed: () {
                // Apply filters
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Filter applied: ${_selectedAccountIds.length} accounts, '
                      '${_selectedCounterpartyIds.length} counterparties, '
                      '${_selectedCashLocationId != null ? '1' : '0'} cash location',
                    ),
                  ),
                );
              },
              child: const Text('Apply Filters'),
            ),
          ],
        ),
      ),
    );
  }
}