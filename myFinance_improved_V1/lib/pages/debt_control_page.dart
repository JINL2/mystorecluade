import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/debt_control_providers.dart';
import '../models/debt_control_models.dart';

class DebtControlPage extends ConsumerWidget {
  const DebtControlPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final perspective = ref.watch(debtPerspectiveProvider);
    final selectedStore = ref.watch(selectedStoreProvider);
    final debtDataAsync = ref.watch(debtControlDataProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _HeaderSection(),
            
            // Tab Bar
            _TabBarSection(),
            
            // Content
            Expanded(
              child: debtDataAsync.when(
                data: (response) => _DebtContent(response: response),
                loading: () => const Center(
                  child: CircularProgressIndicator(),
                ),
                error: (error, stack) => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, 
                        size: 48, 
                        color: Colors.red
                      ),
                      const SizedBox(height: 16),
                      Text('Error: ${error.toString()}'),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => ref.refresh(debtControlDataProvider),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Header Section
class _HeaderSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios, size: 24),
            onPressed: () => Navigator.pop(context),
          ),
          const Expanded(
            child: Text(
              'Debt Control',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(width: 48), // Balance the back button
        ],
      ),
    );
  }
}

// Tab Bar Section
class _TabBarSection extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final perspective = ref.watch(debtPerspectiveProvider);
    
    return Container(
      height: 48,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: _TabButton(
              label: 'Company',
              isActive: perspective == DebtPerspective.company,
              onTap: () {
                ref.read(debtPerspectiveProvider.notifier).state = 
                    DebtPerspective.company;
              },
            ),
          ),
          Expanded(
            child: _TabButton(
              label: 'Store',
              isActive: perspective == DebtPerspective.store,
              onTap: () {
                final selectedStore = ref.read(selectedStoreProvider);
                if (selectedStore == null) {
                  _showStoreSelectionDialog(context, ref);
                } else {
                  ref.read(debtPerspectiveProvider.notifier).state = 
                      DebtPerspective.store;
                }
              },
            ),
          ),
        ],
      ),
    );
  }
  
  void _showStoreSelectionDialog(BuildContext context, WidgetRef ref) {
    // TODO: Implement store selection dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Store'),
        content: const Text('Please select a store first'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}

// Tab Button
class _TabButton extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;
  
  const _TabButton({
    required this.label,
    required this.isActive,
    required this.onTap,
  });
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isActive ? const Color(0xFF007AFF) : Colors.transparent,
              width: 3,
            ),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
            color: isActive ? Colors.black : Colors.grey,
          ),
        ),
      ),
    );
  }
}

// Main Content
class _DebtContent extends ConsumerWidget {
  final DebtControlResponse response;
  
  const _DebtContent({required this.response});
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return RefreshIndicator(
      onRefresh: () async {
        ref.refresh(debtControlDataProvider);
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            // Summary Card
            _SummaryCard(
              metadata: response.metadata,
              summary: response.summary,
            ),
            
            // Debt by Store (Company view only)
            if (response.metadata.isCompanyPerspective && 
                response.storeAggregates.isNotEmpty)
              _StoreAggregatesSection(stores: response.storeAggregates),
            
            // Filter Section
            _FilterSection(),
            
            // Debt Records
            ...response.records.map((record) => 
              _DebtRecordCard(record: record)
            ),
            
            if (response.records.isEmpty)
              const Padding(
                padding: EdgeInsets.all(32.0),
                child: Text(
                  'No debt records found',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            
            const SizedBox(height: 100), // Bottom padding
          ],
        ),
      ),
    );
  }
}

// Summary Card (Blue Gradient)
class _SummaryCard extends ConsumerWidget {
  final DebtMetadata metadata;
  final DebtSummary summary;
  
  const _SummaryCard({
    required this.metadata,
    required this.summary,
  });
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedStore = ref.watch(selectedStoreProvider);
    
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF007AFF), Color(0xFF0051D5)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF007AFF).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  metadata.isStorePerspective ? Icons.store : Icons.business,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      metadata.isStorePerspective 
                        ? (selectedStore?['name'] ?? 'Store')
                        : 'Company Overview',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      metadata.displaySubtitle,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.diamond_outlined,
                      color: Colors.white,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${summary.counterpartyCount} counterparties',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // Net Position
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Net Position',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                summary.netPositionFormatted,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 48,
                  fontWeight: FontWeight.w700,
                  height: 1.1,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                summary.netPositionStatus,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 16,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // Internal/External Boxes
          Row(
            children: [
              Expanded(
                child: _SummaryBox(
                  icon: Icons.business,
                  title: 'Internal',
                  amount: summary.internalNetFormatted,
                  receivable: summary.internalReceivableFormatted,
                  payable: summary.internalPayableFormatted,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _SummaryBox(
                  icon: Icons.public,
                  title: 'External',
                  amount: summary.externalNetFormatted,
                  receivable: summary.externalReceivableFormatted,
                  payable: summary.externalPayableFormatted,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Summary Box (Internal/External)
class _SummaryBox extends StatelessWidget {
  final IconData icon;
  final String title;
  final String amount;
  final String receivable;
  final String payable;
  
  const _SummaryBox({
    required this.icon,
    required this.title,
    required this.amount,
    required this.receivable,
    required this.payable,
  });
  
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.white, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            amount,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.arrow_upward,
                    color: Colors.white.withOpacity(0.7),
                    size: 14,
                  ),
                  const SizedBox(width: 2),
                  Text(
                    receivable,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Icon(
                    Icons.arrow_downward,
                    color: Colors.white.withOpacity(0.7),
                    size: 14,
                  ),
                  const SizedBox(width: 2),
                  Text(
                    payable,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Store Aggregates Section (Company View Only)
class _StoreAggregatesSection extends StatelessWidget {
  final List<StoreAggregate> stores;
  
  const _StoreAggregatesSection({required this.stores});
  
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF007AFF).withOpacity(0.8),
            const Color(0xFF0051D5).withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Debt by Store',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: stores.map((store) => 
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(
                    right: stores.last != store ? 8 : 0,
                  ),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        store.storeName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        store.netPositionCompact,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        store.counterpartyText,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ).toList(),
          ),
        ],
      ),
    );
  }
}

// Filter Section
class _FilterSection extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentFilter = ref.watch(debtFilterProvider);
    final showAll = ref.watch(showAllCounterpartiesProvider);
    
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Toggle for showing all counterparties
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Companies',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: showAll ? const Color(0xFF007AFF).withOpacity(0.1) : Colors.grey.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: InkWell(
                  onTap: () {
                    ref.read(showAllCounterpartiesProvider.notifier).state = !showAll;
                  },
                  borderRadius: BorderRadius.circular(20),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        showAll ? Icons.visibility : Icons.visibility_outlined,
                        size: 16,
                        color: showAll ? const Color(0xFF007AFF) : Colors.grey,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        showAll ? 'All Partners' : 'Active Only',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: showAll ? const Color(0xFF007AFF) : Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: DebtFilter.values.map((filter) {
              final isSelected = currentFilter == filter;
              return Padding(
                padding: const EdgeInsets.only(right: 12),
                child: _FilterChip(
                  label: ref.watch(filterDisplayNameProvider(filter)),
                  isSelected: isSelected,
                  onTap: () {
                    ref.read(debtFilterProvider.notifier).state = filter;
                  },
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

// Filter Chip
class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  
  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });
  
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color: isSelected ? Colors.black : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? Colors.black : Colors.grey.shade300,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : 
                   isSelected ? Colors.black : Colors.grey,
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}

// Debt Record Card
class _DebtRecordCard extends StatelessWidget {
  final DebtRecord record;
  
  const _DebtRecordCard({required this.record});
  
  @override
  Widget build(BuildContext context) {
    final isPositive = record.netAmount >= 0;
    final hasNoTransactions = record.netAmount == 0 && record.transactionCount == 0;
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: () {
            // TODO: Navigate to detail
            print('Navigate to ${record.counterpartyId}');
          },
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide(
                  color: hasNoTransactions
                    ? Colors.grey.shade300
                    : isPositive 
                      ? const Color(0xFF34C759)
                      : const Color(0xFFFF3B30),
                  width: 4,
                ),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Row
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            record.counterpartyName,
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            record.lastActivityText,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        if (hasNoTransactions) ...[
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              'No trades yet',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ),
                        ] else ...[
                          Text(
                            record.netAmountFormatted,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: isPositive 
                                ? const Color(0xFF34C759)
                                : const Color(0xFFFF3B30),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            record.statusText,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
                
                // Internal Badge
                if (record.isInternal) ...[
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF007AFF).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      'Internal',
                      style: TextStyle(
                        color: Color(0xFF007AFF),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}