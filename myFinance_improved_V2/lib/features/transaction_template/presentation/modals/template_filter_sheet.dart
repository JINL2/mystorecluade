import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinance_improved/app/providers/app_state_provider.dart';
import 'package:myfinance_improved/shared/themes/toss_colors.dart';
import 'package:myfinance_improved/shared/themes/toss_icons.dart';
import 'package:myfinance_improved/shared/themes/toss_spacing.dart';
import 'package:myfinance_improved/shared/themes/toss_text_styles.dart';
import 'package:myfinance_improved/shared/widgets/selectors/autonomous_cash_location_selector.dart';
import 'package:myfinance_improved/shared/widgets/selectors/autonomous_counterparty_selector.dart';
import 'package:myfinance_improved/shared/widgets/selectors/enhanced_account_selector.dart';
import 'package:myfinance_improved/shared/widgets/toss/toss_bottom_sheet.dart';
import 'package:myfinance_improved/shared/widgets/toss/toss_primary_button.dart';
import 'package:myfinance_improved/shared/widgets/toss/toss_secondary_button.dart';
import 'package:myfinance_improved/shared/widgets/toss/toss_text_field.dart';

import '../../domain/value_objects/template_filter.dart';
// Updated imports to use new application layer providers
import '../providers/template_provider.dart';

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
    final filterState = ref.read(templateFilterProvider);
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
                      fontWeight: FontWeight.bold,
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
              
              // Account Selector - Enhanced with type-safe callback
              EnhancedAccountSelector(
                selectedAccountId: _selectedAccountIds?.isNotEmpty == true ? _selectedAccountIds!.first : null,
                contextType: 'template_filter',
                showQuickAccess: true,
                maxQuickItems: 5,
                // ✅ Type-safe callback
                onAccountSelected: (account) {
                  setState(() {
                    _selectedAccountIds = [account.id];
                  });
                },
                label: 'Account',
                hint: 'All Accounts',
                showSearch: true,
                showTransactionCount: false,
              ),
              
              const SizedBox(height: TossSpacing.space4),
              
              // Entity Selectors
              Column(
                children: [
                  // Counterparty Selector
                  AutonomousCounterpartySelector(
                    selectedCounterpartyId: _selectedCounterpartyId,
                    onChanged: (value) {
                      setState(() {
                        _selectedCounterpartyId = value;
                      });
                    },
                  ),
                  const SizedBox(height: TossSpacing.space4),
                  
                  // Cash Location Selector
                  Builder(
                    builder: (context) {
                      final appState = ref.watch(appStateProvider);
                      final currentStoreId = appState.storeChoosen;

                      return AutonomousCashLocationSelector(
                        selectedLocationId: _selectedCashLocationId,
                        storeId: currentStoreId, // ✅ 필터용이지만 Store 탭 필터링을 위해 전달
                        showScopeTabs: true, // ✅ 필터 시트에서도 탭 사용 가능
                        onChanged: (value) {
                          setState(() {
                            _selectedCashLocationId = value;
                          });
                        },
                      );
                    },
                  ),
                  const SizedBox(height: TossSpacing.space4),
                ],
              ),
              
              
              const SizedBox(height: TossSpacing.space6),
              
              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: TossSecondaryButton(
                      text: 'Clear All',
                      onPressed: _clearFilters,
                    ),
                  ),
                  const SizedBox(width: TossSpacing.space3),
                  Expanded(
                    child: TossPrimaryButton(
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
            fontWeight: FontWeight.w600,
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

    ref.read(templateFilterProvider.notifier).clearFilter();
    Navigator.pop(context);
  }

  void _applyFilters() {
    final newFilter = TemplateFilter(
      accountIds: _selectedAccountIds,
      counterpartyId: _selectedCounterpartyId,
      cashLocationId: _selectedCashLocationId,
      searchQuery: _searchController.text.trim().isEmpty ? null : _searchController.text.trim(),
    );

    ref.read(templateFilterProvider.notifier).updateFilter(newFilter);
    Navigator.pop(context);
  }
}