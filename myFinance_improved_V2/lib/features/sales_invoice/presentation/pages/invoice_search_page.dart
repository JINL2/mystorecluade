// Presentation Page: Invoice Search
// Search page for sales invoices

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/providers/app_state_provider.dart';
import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_spacing.dart';
import '../../../../shared/themes/toss_text_styles.dart';
import '../../domain/entities/invoice.dart';
import '../../domain/value_objects/invoice_filter.dart';
import '../../domain/value_objects/invoice_period.dart';
import '../providers/invoice_providers.dart';
import '../widgets/invoice_list/invoice_list_item.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

/// Invoice Search Page
class InvoiceSearchPage extends ConsumerStatefulWidget {
  const InvoiceSearchPage({super.key});

  @override
  ConsumerState<InvoiceSearchPage> createState() => _InvoiceSearchPageState();
}

class _InvoiceSearchPageState extends ConsumerState<InvoiceSearchPage> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  Timer? _searchDebounceTimer;
  List<Invoice> _searchResults = [];
  bool _isSearching = false;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    // Auto focus the search field when page opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _searchFocusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    _searchDebounceTimer?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    setState(() {
      _searchQuery = value;
      _isSearching = value.isNotEmpty;
    });

    _searchDebounceTimer?.cancel();
    _searchDebounceTimer = Timer(const Duration(milliseconds: 300), () {
      _performSearch(value);
    });
  }

  Future<void> _performSearch(String query) async {
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
        _isSearching = false;
      });
      return;
    }

    setState(() {
      _isSearching = true;
    });

    try {
      final appState = ref.read(appStateProvider);
      final repository = ref.read(invoiceRepositoryProvider);

      final filter = InvoiceFilter(
        period: InvoicePeriod.allTime,
        searchQuery: query,
        page: 1,
      );

      final result = await repository.getInvoices(
        companyId: appState.companyChoosen,
        storeId: appState.storeChoosen,
        filter: filter,
      );

      if (mounted) {
        setState(() {
          _searchResults = result.invoices;
          _isSearching = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _searchResults = [];
          _isSearching = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TossColors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildSearchHeader(),
            Expanded(
              child: _buildSearchResults(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        TossSpacing.space4,
        TossSpacing.space3,
        TossSpacing.space4,
        TossSpacing.space3,
      ),
      decoration: const BoxDecoration(
        color: TossColors.white,
        border: Border(
          bottom: BorderSide(
            color: TossColors.gray100,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          // Back button
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              padding: const EdgeInsets.all(TossSpacing.space2),
              child: const Icon(
                Icons.arrow_back,
                color: TossColors.gray900,
                size: 24,
              ),
            ),
          ),
          const SizedBox(width: TossSpacing.space2),
          // Search field
          Expanded(
            child: TossSearchField(
              controller: _searchController,
              focusNode: _searchFocusNode,
              hintText: 'Search by invoice number...',
              autofocus: true,
              onChanged: _onSearchChanged,
              onClear: () {
                setState(() {
                  _searchResults = [];
                  _searchQuery = '';
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults() {
    if (_searchQuery.isEmpty) {
      return _buildEmptyState(
        icon: Icons.search,
        title: 'Search Invoices',
        subtitle: 'Enter invoice number to search',
      );
    }

    if (_isSearching) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(TossColors.primary),
        ),
      );
    }

    if (_searchResults.isEmpty) {
      return _buildEmptyState(
        icon: Icons.search_off,
        title: 'No results found',
        subtitle: 'Try a different search term',
      );
    }

    // Group invoices by date
    final groupedInvoices = _groupInvoicesByDate(_searchResults);

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(TossSpacing.space3, TossSpacing.space1, TossSpacing.space3, TossSpacing.space4),
      itemCount: _calculateTotalItemCount(groupedInvoices),
      itemBuilder: (context, index) {
        final entries = groupedInvoices.entries.toList();

        // Calculate which item we're rendering
        int currentIndex = 0;
        for (final entry in entries) {
          // Date separator
          if (index == currentIndex) {
            return Padding(
              padding: EdgeInsets.only(
                top: currentIndex == 0 ? 0 : 20,
                bottom: 2,
              ),
              child: _buildDateSeparator(entry.key),
            );
          }
          currentIndex++;

          // Invoice items for this date
          for (final invoice in entry.value) {
            if (index == currentIndex) {
              return Padding(
                padding: const EdgeInsets.only(bottom: TossSpacing.space4),
                child: InvoiceListItem(
                  invoice: invoice,
                ),
              );
            }
            currentIndex++;
          }
        }
        return null;
      },
    );
  }

  Map<DateTime, List<Invoice>> _groupInvoicesByDate(List<Invoice> invoices) {
    final grouped = <DateTime, List<Invoice>>{};

    for (final invoice in invoices) {
      final dateKey = DateTime(
        invoice.saleDate.year,
        invoice.saleDate.month,
        invoice.saleDate.day,
      );
      if (!grouped.containsKey(dateKey)) {
        grouped[dateKey] = [];
      }
      grouped[dateKey]!.add(invoice);
    }

    // Sort by date descending
    final sortedKeys = grouped.keys.toList()..sort((a, b) => b.compareTo(a));
    final sortedMap = <DateTime, List<Invoice>>{};
    for (final key in sortedKeys) {
      sortedMap[key] = grouped[key]!;
    }

    return sortedMap;
  }

  int _calculateTotalItemCount(Map<DateTime, List<Invoice>> groupedInvoices) {
    int count = 0;
    for (final entry in groupedInvoices.entries) {
      count++; // Date separator
      count += entry.value.length; // Invoice items
    }
    return count;
  }

  Widget _buildDateSeparator(DateTime date) {
    final dayNames = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final monthNames = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];

    final dayName = dayNames[date.weekday - 1];
    final monthName = monthNames[date.month - 1];

    return Text(
      '$dayName, ${date.day} $monthName ${date.year}',
      style: TossTextStyles.caption.copyWith(
        fontWeight: FontWeight.w400,
        color: TossColors.gray600,
      ),
    );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 64,
            color: TossColors.gray400,
          ),
          const SizedBox(height: TossSpacing.space3),
          Text(
            title,
            style: TossTextStyles.h4.copyWith(
              color: TossColors.gray700,
            ),
          ),
          const SizedBox(height: TossSpacing.space1),
          Text(
            subtitle,
            style: TossTextStyles.body.copyWith(
              color: TossColors.gray500,
            ),
          ),
        ],
      ),
    );
  }
}
