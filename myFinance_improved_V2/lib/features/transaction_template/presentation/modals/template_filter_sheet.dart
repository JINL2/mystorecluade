import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinance_improved/shared/themes/toss_colors.dart';
import 'package:myfinance_improved/shared/themes/toss_icons.dart';
import 'package:myfinance_improved/shared/themes/toss_spacing.dart';
import 'package:myfinance_improved/shared/themes/toss_text_styles.dart';
import 'package:myfinance_improved/shared/themes/toss_font_weight.dart';
// Autonomous Selectors

import '../../domain/value_objects/template_filter.dart';
// Updated imports to use new application layer providers
import '../providers/template_provider.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

class TemplateFilterSheet extends ConsumerStatefulWidget {
  const TemplateFilterSheet({super.key});

  @override
  ConsumerState<TemplateFilterSheet> createState() => _TemplateFilterSheetState();
}

class _TemplateFilterSheetState extends ConsumerState<TemplateFilterSheet> {
  List<String>? _selectedAccountIds;
  String? _selectedCounterpartyId;
  String? _selectedCashLocationId;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final filterState = ref.read(templateFilterNotifierProvider);
    // TemplateFilterState에서 기존 필터값 복원
    _selectedAccountIds = filterState.accountIds;
    _selectedCounterpartyId = filterState.counterpartyId;
    _selectedCashLocationId = filterState.cashLocationId;
    _searchController.text = filterState.searchText;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final maxHeight = screenHeight * 0.85; // Use 85% of screen height max

    return TossBottomSheet(
      content: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: maxHeight - 100,
        ),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Filter Templates',
                    style: TossTextStyles.h3.copyWith(
                      fontWeight: TossFontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(TossIcons.close, color: TossColors.gray700),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),

              const SizedBox(height: TossSpacing.space4),

              // Search Field
              _buildSearchField(),

              const SizedBox(height: TossSpacing.space4),

              // Account Selector - EnhancedAccountSelector
              EnhancedAccountSelector(
                selectedAccountId: _selectedAccountIds?.isNotEmpty == true ? _selectedAccountIds!.first : null,
                contextType: 'template_filter',
                showQuickAccess: true,
                maxQuickItems: 5,
                onAccountSelected: (account) {
                  setState(() {
                    _selectedAccountIds = [account.id];
                  });
                },
                onChanged: (accountId) {
                  setState(() {
                    _selectedAccountIds = accountId != null ? [accountId] : null;
                  });
                },
                label: 'Account',
                hint: 'All Accounts',
                showSearch: true,
                showTransactionCount: false,
              ),

              const SizedBox(height: TossSpacing.space4),

              // Counterparty Selector - AutonomousCounterpartySelector
              AutonomousCounterpartySelector(
                selectedCounterpartyId: _selectedCounterpartyId,
                label: 'Counterparty',
                hint: 'All Counterparties',
                onCounterpartySelected: (counterparty) {
                  setState(() {
                    _selectedCounterpartyId = counterparty.id;
                  });
                },
                onChanged: (counterpartyId) {
                  setState(() {
                    _selectedCounterpartyId = counterpartyId;
                  });
                },
              ),

              const SizedBox(height: TossSpacing.space4),

              // Cash Location Selector - AutonomousCashLocationSelector
              AutonomousCashLocationSelector(
                selectedLocationId: _selectedCashLocationId,
                label: 'Cash Location',
                hint: 'All Cash Locations',
                onCashLocationSelected: (cashLocation) {
                  setState(() {
                    _selectedCashLocationId = cashLocation.id;
                  });
                },
                onChanged: (locationId) {
                  setState(() {
                    _selectedCashLocationId = locationId;
                  });
                },
              ),

              const SizedBox(height: TossSpacing.space6),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: TossButton.secondary(
                      text: 'Clear All',
                      onPressed: _clearFilters,
                    ),
                  ),
                  const SizedBox(width: TossSpacing.space3),
                  Expanded(
                    child: TossButton.primary(
                      text: 'Apply Filter',
                      onPressed: _applyFilters,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: TossSpacing.space4),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Search Templates',
          style: TossTextStyles.caption.copyWith(
            color: TossColors.gray500,
            fontWeight: TossFontWeight.semibold,
          ),
        ),
        const SizedBox(height: TossSpacing.space2),
        TossTextField(
          controller: _searchController,
          hintText: 'Search by name or description...',
          suffixIcon: _searchController.text.isNotEmpty
              ? InkWell(
                  onTap: () => setState(() => _searchController.clear()),
                  child: const Icon(
                    TossIcons.close,
                    color: TossColors.gray500,
                    size: TossSpacing.iconSM,
                  ),
                )
              : const Icon(
                  TossIcons.search,
                  color: TossColors.gray400,
                  size: TossSpacing.iconSM,
                ),
          onChanged: (value) {
            setState(() {}); // Trigger rebuild to show/hide clear button
          },
        ),
      ],
    );
  }

  void _clearFilters() {
    setState(() {
      _selectedAccountIds = null;
      _selectedCounterpartyId = null;
      _selectedCashLocationId = null;
      _searchController.clear();
    });

    ref.read(templateFilterNotifierProvider.notifier).clearFilter();
    Navigator.pop(context);
  }

  void _applyFilters() {
    final newFilter = TemplateFilter(
      accountIds: _selectedAccountIds,
      counterpartyId: _selectedCounterpartyId,
      cashLocationId: _selectedCashLocationId,
      searchQuery: _searchController.text.trim().isEmpty ? null : _searchController.text.trim(),
    );

    ref.read(templateFilterNotifierProvider.notifier).updateFilter(newFilter);
    Navigator.pop(context);
  }
}
