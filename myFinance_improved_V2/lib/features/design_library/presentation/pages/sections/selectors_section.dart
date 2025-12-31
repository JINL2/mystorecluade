import 'package:flutter/material.dart';
import 'package:myfinance_improved/core/domain/entities/selector_entities.dart';
import 'package:myfinance_improved/shared/themes/index.dart';
import 'package:myfinance_improved/shared/widgets/selectors/account/account_selector_sheet.dart';
import 'package:myfinance_improved/shared/widgets/selectors/account/account_quick_access.dart';
import 'package:myfinance_improved/shared/widgets/selectors/cash_location/cash_location_selector_sheet.dart';

/// Selectors Section - Interactive demo with REAL selector components
/// Shows the actual production selectors: Account, CashLocation, Counterparty
class SelectorsSection extends StatefulWidget {
  const SelectorsSection({super.key});

  @override
  State<SelectorsSection> createState() => _SelectorsSectionState();
}

class _SelectorsSectionState extends State<SelectorsSection> {
  // ══════════════════════════════════════════════════════════════
  // MOCK DATA - Same structure as production
  // ══════════════════════════════════════════════════════════════

  /// Mock accounts (same as production AccountData)
  static final List<AccountData> _mockAccounts = [
    const AccountData(
      id: '1',
      name: 'Cash',
      type: 'asset',
      categoryTag: 'cash',
      transactionCount: 46,
    ),
    const AccountData(
      id: '2',
      name: 'Note Receivable',
      type: 'asset',
      categoryTag: 'receivable',
      transactionCount: 12,
    ),
    const AccountData(
      id: '3',
      name: 'Notes Payable',
      type: 'liability',
      categoryTag: 'payable',
      transactionCount: 3,
    ),
    const AccountData(
      id: '4',
      name: 'Accounts Receivable',
      type: 'asset',
      categoryTag: 'receivable',
      transactionCount: 3,
    ),
    const AccountData(
      id: '5',
      name: 'Sales revenue',
      type: 'income',
      categoryTag: 'revenue',
      transactionCount: 3,
    ),
    const AccountData(
      id: '6',
      name: 'Accounts Payable',
      type: 'liability',
      categoryTag: 'payable',
      transactionCount: 2,
    ),
    const AccountData(
      id: '7',
      name: 'Inventory',
      type: 'asset',
      categoryTag: 'inventory',
      transactionCount: 1,
    ),
    const AccountData(
      id: '8',
      name: 'Office Supplies',
      type: 'expense',
      categoryTag: 'operating',
      transactionCount: 0,
    ),
  ];

  /// Mock quick access accounts (Frequently Used section)
  static final List<QuickAccessAccount> _mockQuickAccess = [
    QuickAccessAccount(
      accountId: '1',
      accountName: 'Cash',
      accountType: 'asset',
      usageCount: 46,
      lastUsed: DateTime.now().subtract(const Duration(hours: 2)),
      usageScore: 100.0,
    ),
    QuickAccessAccount(
      accountId: '2',
      accountName: 'Note Receivable',
      accountType: 'asset',
      usageCount: 12,
      lastUsed: DateTime.now().subtract(const Duration(days: 1)),
      usageScore: 80.0,
    ),
    QuickAccessAccount(
      accountId: '3',
      accountName: 'Notes Payable',
      accountType: 'liability',
      usageCount: 3,
      lastUsed: DateTime.now().subtract(const Duration(days: 2)),
      usageScore: 50.0,
    ),
    QuickAccessAccount(
      accountId: '4',
      accountName: 'Accounts Receivable',
      accountType: 'asset',
      usageCount: 3,
      lastUsed: DateTime.now().subtract(const Duration(days: 3)),
      usageScore: 45.0,
    ),
    QuickAccessAccount(
      accountId: '5',
      accountName: 'Sales revenue',
      accountType: 'income',
      usageCount: 3,
      lastUsed: DateTime.now().subtract(const Duration(days: 4)),
      usageScore: 40.0,
    ),
  ];

  /// Mock cash locations (Company-wide)
  static const List<CashLocationData> _mockCompanyLocations = [
    CashLocationData(
      id: 'c1',
      name: 'Main Office Safe',
      type: 'Company',
      transactionCount: 35,
    ),
    CashLocationData(
      id: 'c2',
      name: 'Petty Cash - HQ',
      type: 'Company',
      transactionCount: 22,
    ),
    CashLocationData(
      id: 'c3',
      name: 'Bank Deposit Box',
      type: 'Company',
      transactionCount: 8,
    ),
  ];

  /// Mock cash locations (Store-specific)
  static const List<CashLocationData> _mockStoreLocations = [
    CashLocationData(
      id: 's1',
      name: 'Register #1',
      type: 'Store',
      transactionCount: 156,
    ),
    CashLocationData(
      id: 's2',
      name: 'Register #2',
      type: 'Store',
      transactionCount: 89,
    ),
    CashLocationData(
      id: 's3',
      name: 'Safe',
      type: 'Store',
      transactionCount: 45,
    ),
    CashLocationData(
      id: 's4',
      name: 'Petty Cash',
      type: 'Store',
      transactionCount: 12,
    ),
  ];

  /// Mock counterparties
  static const List<CounterpartyData> _mockCounterparties = [
    CounterpartyData(
      id: 'cp1',
      name: 'ABC Trading Co.',
      type: 'Suppliers',
      transactionCount: 28,
      isInternal: false,
    ),
    CounterpartyData(
      id: 'cp2',
      name: 'John Smith',
      type: 'Customers',
      transactionCount: 15,
      isInternal: false,
    ),
    CounterpartyData(
      id: 'cp3',
      name: 'My Company HQ',
      type: 'My Company',
      transactionCount: 42,
      isInternal: true,
    ),
    CounterpartyData(
      id: 'cp4',
      name: 'XYZ Logistics',
      type: 'Suppliers',
      transactionCount: 8,
      isInternal: false,
    ),
    CounterpartyData(
      id: 'cp5',
      name: 'Jane Doe',
      type: 'Customers',
      transactionCount: 5,
      isInternal: false,
    ),
  ];

  // ══════════════════════════════════════════════════════════════
  // STATE
  // ══════════════════════════════════════════════════════════════
  String? _selectedAccountId;
  String? _selectedAccountName;

  String? _selectedCashLocationId;
  String? _selectedCashLocationName;

  String? _selectedCounterpartyId;
  String? _selectedCounterpartyName;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(TossSpacing.space4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Production Selectors', 'shared/widgets/selectors/'),
          _buildInfoBanner(
            'These are the ACTUAL selector components used in production. '
            'Tap to see the real UI with search, tabs, and transaction counts.',
          ),
          const SizedBox(height: TossSpacing.space4),

          // ══════════════════════════════════════════════════════════════
          // 1. Account Selector
          // ══════════════════════════════════════════════════════════════
          _ComponentShowcase(
            name: 'AccountSelector',
            description: 'Account selector with Quick Access, transaction counts, and search',
            filename: 'selectors/account/account_selector.dart',
            child: _buildSelectorTrigger(
              icon: Icons.account_balance_wallet,
              label: 'Account',
              selectedValue: _selectedAccountName,
              hint: 'Select an account',
              isSelected: _selectedAccountId != null,
              onTap: () => _showAccountSelectorSheet(context),
            ),
          ),

          // ══════════════════════════════════════════════════════════════
          // 2. Cash Location Selector
          // ══════════════════════════════════════════════════════════════
          _ComponentShowcase(
            name: 'CashLocationSelector',
            description: 'Cash location with Company/Store tabs and search',
            filename: 'selectors/cash_location/cash_location_selector.dart',
            child: _buildSelectorTrigger(
              icon: Icons.point_of_sale,
              label: 'Cash Location',
              selectedValue: _selectedCashLocationName,
              hint: 'Select cash location',
              isSelected: _selectedCashLocationId != null,
              onTap: () => _showCashLocationSheet(context),
            ),
          ),

          // ══════════════════════════════════════════════════════════════
          // 3. Counterparty Selector
          // ══════════════════════════════════════════════════════════════
          _ComponentShowcase(
            name: 'CounterpartySelector',
            description: 'Counterparty selector with type filtering (Customers, Suppliers, etc.)',
            filename: 'selectors/counterparty/counterparty_selector.dart',
            child: _buildSelectorTrigger(
              icon: Icons.people,
              label: 'Counterparty',
              selectedValue: _selectedCounterpartyName,
              hint: 'Select counterparty',
              isSelected: _selectedCounterpartyId != null,
              onTap: () => _showCounterpartySheet(context),
            ),
          ),

          const Divider(height: TossSpacing.space6),

          // ══════════════════════════════════════════════════════════════
          // Key Features
          // ══════════════════════════════════════════════════════════════
          _buildSubSectionTitle('Key Features', ''),

          const _FeatureCard(
            icon: Icons.bolt,
            iconColor: TossColors.warning,
            title: 'Frequently Used (Quick Access)',
            description: 'Shows top accounts based on usage history with transaction counts (46x, 12x)',
          ),

          const _FeatureCard(
            icon: Icons.search,
            iconColor: TossColors.primary,
            title: 'Search',
            description: 'Real-time search across name, type, and category',
          ),

          const _FeatureCard(
            icon: Icons.tab,
            iconColor: TossColors.info,
            title: 'Scoped Tabs',
            description: 'Company/Store tabs for CashLocation selector',
          ),

          const _FeatureCard(
            icon: Icons.check_circle,
            iconColor: TossColors.success,
            title: 'Selection State',
            description: 'Visual feedback with checkmark and highlighted row',
          ),

          const Divider(height: TossSpacing.space6),

          // ══════════════════════════════════════════════════════════════
          // Component Architecture
          // ══════════════════════════════════════════════════════════════
          _buildSubSectionTitle('Component Architecture', ''),

          const _ComponentGroup(
            groupName: 'Account Selector',
            components: [
              _ComponentInfo(
                name: 'AccountSelector',
                filename: 'account_selector.dart',
                description: 'Main widget with Riverpod integration',
              ),
              _ComponentInfo(
                name: 'AccountSelectorSheet',
                filename: 'account_selector_sheet.dart',
                description: 'Bottom sheet with search & quick access',
              ),
            ],
          ),

          const _ComponentGroup(
            groupName: 'Cash Location Selector',
            components: [
              _ComponentInfo(
                name: 'CashLocationSelector',
                filename: 'cash_location_selector.dart',
                description: 'Main widget with Riverpod integration',
              ),
              _ComponentInfo(
                name: 'CashLocationScopedSheet',
                filename: 'cash_location_selector_sheet.dart',
                description: 'Bottom sheet with Company/Store tabs',
              ),
            ],
          ),

          const _ComponentGroup(
            groupName: 'Counterparty Selector',
            components: [
              _ComponentInfo(
                name: 'CounterpartySelector',
                filename: 'counterparty_selector.dart',
                description: 'Main widget with type filtering',
              ),
              _ComponentInfo(
                name: 'TossSingleSelector',
                filename: 'base/toss_single_selector.dart',
                description: 'Base component used internally',
              ),
            ],
          ),

          const SizedBox(height: TossSpacing.space6),
        ],
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════
  // SELECTOR TRIGGER (Reusable)
  // ══════════════════════════════════════════════════════════════
  Widget _buildSelectorTrigger({
    required IconData icon,
    required String label,
    required String? selectedValue,
    required String hint,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: TossSpacing.space4,
              vertical: TossSpacing.space3,
            ),
            decoration: BoxDecoration(
              color: TossColors.white,
              borderRadius: BorderRadius.circular(TossBorderRadius.md),
              border: Border.all(color: TossColors.border),
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: TossSpacing.iconSM,
                  color: isSelected ? TossColors.primary : TossColors.gray500,
                ),
                const SizedBox(width: TossSpacing.space3),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        style: TossTextStyles.label.copyWith(
                          color: TossColors.textSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        selectedValue ?? hint,
                        style: TossTextStyles.body.copyWith(
                          color: isSelected
                              ? TossColors.textPrimary
                              : TossColors.textTertiary,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.arrow_drop_down,
                  color: TossColors.textSecondary,
                ),
              ],
            ),
          ),
        ),
        if (isSelected) ...[
          const SizedBox(height: TossSpacing.space2),
          _buildSelectedInfo('Selected: $selectedValue'),
        ],
      ],
    );
  }

  // ══════════════════════════════════════════════════════════════
  // BOTTOM SHEETS
  // ══════════════════════════════════════════════════════════════
  void _showAccountSelectorSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: TossColors.transparent,
      barrierColor: TossColors.black54,
      builder: (context) => AccountSelectorSheet(
        accounts: _mockAccounts,
        quickAccessAccounts: _mockQuickAccess,
        selectedAccountId: _selectedAccountId,
        onAccountSelected: (account) {
          setState(() {
            _selectedAccountId = account.id;
            _selectedAccountName = account.name;
          });
          Navigator.pop(context);
        },
        label: 'Account',
        showSearch: true,
        showQuickAccess: true,
        showTransactionCount: true,
      ),
    );
  }

  void _showCashLocationSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: TossColors.transparent,
      barrierColor: TossColors.black54,
      builder: (context) => CashLocationScopedSheet(
        companyLocations: _mockCompanyLocations,
        storeLocations: _mockStoreLocations,
        selectedLocationId: _selectedCashLocationId,
        onLocationSelected: (location) {
          setState(() {
            _selectedCashLocationId = location.id;
            _selectedCashLocationName = location.name;
          });
        },
        label: 'Cash Location',
        showSearch: true,
        showTransactionCount: true,
      ),
    );
  }

  void _showCounterpartySheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: TossColors.transparent,
      barrierColor: TossColors.black54,
      builder: (context) => _CounterpartyDemoSheet(
        counterparties: _mockCounterparties,
        selectedCounterpartyId: _selectedCounterpartyId,
        onCounterpartySelected: (cp) {
          setState(() {
            _selectedCounterpartyId = cp.id;
            _selectedCounterpartyName = cp.name;
          });
          Navigator.pop(context);
        },
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════
  // UI HELPERS
  // ══════════════════════════════════════════════════════════════
  Widget _buildSectionTitle(String title, String path) {
    return Padding(
      padding: const EdgeInsets.only(bottom: TossSpacing.space2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TossTextStyles.h3.copyWith(
              fontWeight: FontWeight.bold,
              color: TossColors.gray900,
            ),
          ),
          const SizedBox(height: TossSpacing.space1),
          Text(
            path,
            style: TossTextStyles.caption.copyWith(
              color: TossColors.textTertiary,
              fontFamily: 'monospace',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubSectionTitle(String title, String path) {
    return Padding(
      padding: const EdgeInsets.only(bottom: TossSpacing.space3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TossTextStyles.h4.copyWith(
              fontWeight: FontWeight.w600,
              color: TossColors.gray800,
            ),
          ),
          if (path.isNotEmpty) ...[
            const SizedBox(height: TossSpacing.space1),
            Text(
              path,
              style: TossTextStyles.caption.copyWith(
                color: TossColors.textTertiary,
                fontFamily: 'monospace',
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoBanner(String text) {
    return Container(
      padding: const EdgeInsets.all(TossSpacing.space3),
      decoration: BoxDecoration(
        color: TossColors.primarySurface,
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
        border: Border.all(color: TossColors.primary.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.touch_app, color: TossColors.primary, size: 20),
          const SizedBox(width: TossSpacing.space3),
          Expanded(
            child: Text(
              text,
              style: TossTextStyles.caption.copyWith(color: TossColors.primary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedInfo(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: TossSpacing.space3,
        vertical: TossSpacing.space2,
      ),
      decoration: BoxDecoration(
        color: TossColors.success.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(TossBorderRadius.sm),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.check_circle, size: 16, color: TossColors.success),
          const SizedBox(width: TossSpacing.space2),
          Flexible(
            child: Text(
              text,
              style: TossTextStyles.caption.copyWith(
                color: TossColors.success,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Component showcase with visual example
class _ComponentShowcase extends StatelessWidget {
  const _ComponentShowcase({
    required this.name,
    required this.description,
    required this.filename,
    required this.child,
  });

  final String name;
  final String description;
  final String filename;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: TossSpacing.space5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: TossTextStyles.h4.copyWith(
              color: TossColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: TossSpacing.space1),
          Text(
            description,
            style: TossTextStyles.body.copyWith(color: TossColors.textSecondary),
          ),
          const SizedBox(height: TossSpacing.space1),
          Text(
            filename,
            style: TossTextStyles.caption.copyWith(
              color: TossColors.textTertiary,
              fontFamily: 'monospace',
            ),
          ),
          const SizedBox(height: TossSpacing.space3),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(TossSpacing.space4),
            decoration: BoxDecoration(
              color: TossColors.gray50,
              borderRadius: BorderRadius.circular(TossBorderRadius.md),
              border: Border.all(color: TossColors.gray200),
            ),
            child: child,
          ),
        ],
      ),
    );
  }
}

/// Feature highlight card
class _FeatureCard extends StatelessWidget {
  const _FeatureCard({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: TossSpacing.space3),
      padding: const EdgeInsets.all(TossSpacing.space3),
      decoration: BoxDecoration(
        color: TossColors.white,
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
        border: Border.all(color: TossColors.gray200),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 18, color: iconColor),
          ),
          const SizedBox(width: TossSpacing.space3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TossTextStyles.body.copyWith(
                    fontWeight: FontWeight.w600,
                    color: TossColors.gray900,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: TossTextStyles.caption.copyWith(
                    color: TossColors.gray600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Group of related components
class _ComponentGroup extends StatelessWidget {
  const _ComponentGroup({
    required this.groupName,
    required this.components,
  });

  final String groupName;
  final List<_ComponentInfo> components;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: TossSpacing.space4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            groupName,
            style: TossTextStyles.label.copyWith(
              fontWeight: FontWeight.w600,
              color: TossColors.gray700,
            ),
          ),
          const SizedBox(height: TossSpacing.space2),
          Container(
            decoration: BoxDecoration(
              color: TossColors.white,
              borderRadius: BorderRadius.circular(TossBorderRadius.md),
              border: Border.all(color: TossColors.gray200),
            ),
            child: Column(
              children: components.asMap().entries.map((entry) {
                final index = entry.key;
                final component = entry.value;
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(TossSpacing.space3),
                      child: Row(
                        children: [
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: TossColors.primarySurface,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.widgets_outlined,
                              size: 16,
                              color: TossColors.primary,
                            ),
                          ),
                          const SizedBox(width: TossSpacing.space3),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  component.name,
                                  style: TossTextStyles.body.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: TossColors.gray900,
                                  ),
                                ),
                                Text(
                                  component.description,
                                  style: TossTextStyles.caption.copyWith(
                                    color: TossColors.gray500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (index < components.length - 1)
                      const Divider(height: 1, indent: 56),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _ComponentInfo {
  const _ComponentInfo({
    required this.name,
    required this.filename,
    required this.description,
  });

  final String name;
  final String filename;
  final String description;
}

/// Demo sheet for Counterparty selector (Design Library only)
class _CounterpartyDemoSheet extends StatefulWidget {
  final List<CounterpartyData> counterparties;
  final String? selectedCounterpartyId;
  final void Function(CounterpartyData) onCounterpartySelected;

  const _CounterpartyDemoSheet({
    required this.counterparties,
    required this.selectedCounterpartyId,
    required this.onCounterpartySelected,
  });

  @override
  State<_CounterpartyDemoSheet> createState() => _CounterpartyDemoSheetState();
}

class _CounterpartyDemoSheetState extends State<_CounterpartyDemoSheet> {
  String _searchQuery = '';

  List<CounterpartyData> get _filteredCounterparties {
    if (_searchQuery.isEmpty) return widget.counterparties;
    final query = _searchQuery.toLowerCase();
    return widget.counterparties.where((cp) {
      return cp.name.toLowerCase().contains(query) ||
          cp.type.toLowerCase().contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.7,
      ),
      decoration: const BoxDecoration(
        color: TossColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: TossColors.gray300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // Header
          Padding(
            padding: const EdgeInsets.all(TossSpacing.space4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Select Counterparty',
                  style: TossTextStyles.h3.copyWith(fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: TossColors.gray500),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          // Search
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space4),
            child: TextField(
              onChanged: (value) => setState(() => _searchQuery = value),
              decoration: InputDecoration(
                hintText: 'Search counterparties',
                prefixIcon: const Icon(Icons.search, color: TossColors.gray500),
                filled: true,
                fillColor: TossColors.gray100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
          ),
          const SizedBox(height: TossSpacing.space3),
          // List
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _filteredCounterparties.length,
              itemBuilder: (context, index) {
                final cp = _filteredCounterparties[index];
                final isSelected = cp.id == widget.selectedCounterpartyId;
                return ListTile(
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: cp.isInternal
                          ? TossColors.primary.withValues(alpha: 0.1)
                          : TossColors.gray100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      cp.isInternal ? Icons.business : Icons.person,
                      color: cp.isInternal ? TossColors.primary : TossColors.gray600,
                      size: 20,
                    ),
                  ),
                  title: Text(
                    cp.isInternal ? '🏢 ${cp.name}' : cp.name,
                    style: TossTextStyles.body.copyWith(
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                  subtitle: Text(
                    '${cp.type} • ${cp.transactionCount} transactions',
                    style: TossTextStyles.caption.copyWith(color: TossColors.gray500),
                  ),
                  trailing: isSelected
                      ? const Icon(Icons.check_circle, color: TossColors.primary)
                      : null,
                  onTap: () => widget.onCounterpartySelected(cp),
                );
              },
            ),
          ),
          const SizedBox(height: TossSpacing.space4),
        ],
      ),
    );
  }
}
