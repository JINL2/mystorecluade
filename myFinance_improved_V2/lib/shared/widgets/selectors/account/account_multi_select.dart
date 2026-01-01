/// Account Multi Select UI
///
/// Multi-selection mode UI components for account selector.
/// Includes sheet, list, and item widgets for multi-select functionality.
library;

import 'package:flutter/material.dart';
import 'package:myfinance_improved/core/domain/entities/selector_entities.dart';
import 'package:myfinance_improved/shared/themes/index.dart';
import 'package:myfinance_improved/shared/widgets/organisms/sheets/toss_bottom_sheet.dart';
import 'package:myfinance_improved/shared/widgets/atoms/inputs/toss_search_field.dart';

import 'account_quick_access.dart';

/// Bottom sheet for multi account selection
class AccountMultiSelectSheet extends StatefulWidget {
  final List<AccountData> accounts;
  final List<QuickAccessAccount> quickAccessAccounts;
  final List<String> selectedIds;
  final void Function(List<String> ids) onSelectionConfirmed;
  final String? label;
  final bool showSearch;
  final bool showQuickAccess;

  const AccountMultiSelectSheet({
    super.key,
    required this.accounts,
    required this.quickAccessAccounts,
    required this.selectedIds,
    required this.onSelectionConfirmed,
    this.label,
    this.showSearch = true,
    this.showQuickAccess = true,
  });

  @override
  State<AccountMultiSelectSheet> createState() => _AccountMultiSelectSheetState();
}

class _AccountMultiSelectSheetState extends State<AccountMultiSelectSheet> {
  late List<String> _tempSelectedIds;
  String _searchQuery = '';
  List<AccountData> _filteredAccounts = [];

  @override
  void initState() {
    super.initState();
    _tempSelectedIds = List<String>.from(widget.selectedIds);
    _filteredAccounts = _getSortedAccounts();
  }

  List<AccountData> _getSortedAccounts() {
    final sorted = List<AccountData>.from(widget.accounts);
    sorted.sort((a, b) {
      int typeCompare = a.type.compareTo(b.type);
      if (typeCompare != 0) return typeCompare;
      return a.name.compareTo(b.name);
    });
    return sorted;
  }

  void _updateFilteredAccounts() {
    if (_searchQuery.isEmpty) {
      _filteredAccounts = _getSortedAccounts();
    } else {
      final queryLower = _searchQuery.toLowerCase();
      _filteredAccounts = _getSortedAccounts().where((account) {
        return account.name.toLowerCase().contains(queryLower) ||
               account.type.toLowerCase().contains(queryLower) ||
               (account.categoryTag?.toLowerCase().contains(queryLower) ?? false);
      }).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return TossBottomSheet(
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: TossSpacing.space3),
          if (widget.showSearch) ...[
            _buildSearchField(),
            const SizedBox(height: TossSpacing.space3),
          ],
          _buildSelectionControls(),
          const SizedBox(height: TossSpacing.space2),
          Flexible(
            child: _buildContent(),
          ),
          const SizedBox(height: TossSpacing.space4),
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Text(
            'Select Accounts',
            style: TossTextStyles.h3.copyWith(
              fontWeight: FontWeight.bold,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        IconButton(
          icon: const Icon(Icons.close, color: TossColors.gray700),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }

  Widget _buildSearchField() {
    return TossSearchField(
      hintText: 'Search accounts...',
      onChanged: (value) {
        setState(() {
          _searchQuery = value;
          _updateFilteredAccounts();
        });
      },
    );
  }

  Widget _buildSelectionControls() {
    return Row(
      children: [
        TextButton(
          onPressed: () {
            setState(() {
              _tempSelectedIds = _filteredAccounts.map((a) => a.id).toList();
            });
          },
          child: Text(
            'Select All',
            style: TossTextStyles.caption.copyWith(
              color: TossColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(width: TossSpacing.space2),
        TextButton(
          onPressed: () {
            setState(() {
              _tempSelectedIds.clear();
            });
          },
          child: Text(
            'Deselect All',
            style: TossTextStyles.caption.copyWith(
              color: TossColors.gray600,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const Spacer(),
        Text(
          '${_tempSelectedIds.length} selected',
          style: TossTextStyles.caption.copyWith(
            color: TossColors.gray500,
          ),
        ),
      ],
    );
  }

  Widget _buildContent() {
    return ListView(
      shrinkWrap: true,
      children: [
        // Quick Access for Multi-Select
        if (widget.showQuickAccess &&
            _searchQuery.isEmpty &&
            widget.quickAccessAccounts.isNotEmpty) ...[
          AccountQuickAccessMultiSelect(
            quickAccounts: widget.quickAccessAccounts,
            allAccounts: widget.accounts,
            selectedIds: _tempSelectedIds,
            onSelectionChanged: (accountId, isSelected) {
              setState(() {
                if (isSelected) {
                  _tempSelectedIds.add(accountId);
                } else {
                  _tempSelectedIds.remove(accountId);
                }
              });
            },
          ),
          const SizedBox(height: TossSpacing.space2),
          Container(height: 1, color: TossColors.gray200),
          const SizedBox(height: TossSpacing.space2),
        ],

        // Section header
        if (_searchQuery.isEmpty && widget.quickAccessAccounts.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: TossSpacing.space4,
              vertical: TossSpacing.space2,
            ),
            child: Text(
              'All Accounts',
              style: TossTextStyles.caption.copyWith(
                color: TossColors.gray600,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

        // Grouped accounts list
        AccountMultiSelectList(
          accounts: _filteredAccounts,
          selectedIds: _tempSelectedIds,
          onSelectionChanged: (accountId, isSelected) {
            setState(() {
              if (isSelected) {
                _tempSelectedIds.add(accountId);
              } else {
                _tempSelectedIds.remove(accountId);
              }
            });
          },
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: TextButton(
            onPressed: () {
              widget.onSelectionConfirmed([]);
              Navigator.pop(context);
            },
            child: Text(
              'Clear',
              style: TossTextStyles.body.copyWith(
                color: TossColors.gray600,
              ),
            ),
          ),
        ),
        const SizedBox(width: TossSpacing.space3),
        Expanded(
          flex: 2,
          child: ElevatedButton(
            onPressed: () {
              widget.onSelectionConfirmed(_tempSelectedIds);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: TossColors.primary,
              foregroundColor: TossColors.white,
              padding: const EdgeInsets.symmetric(vertical: TossSpacing.space3),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(TossBorderRadius.md),
              ),
            ),
            child: Text(
              'Apply (${_tempSelectedIds.length})',
              style: TossTextStyles.body.copyWith(
                color: TossColors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Multi-select list widget for accounts
class AccountMultiSelectList extends StatelessWidget {
  final List<AccountData> accounts;
  final List<String> selectedIds;
  final void Function(String accountId, bool isSelected) onSelectionChanged;

  const AccountMultiSelectList({
    super.key,
    required this.accounts,
    required this.selectedIds,
    required this.onSelectionChanged,
  });

  @override
  Widget build(BuildContext context) {
    // Group accounts by type
    final Map<String, List<AccountData>> groupedAccounts = {};
    for (final account in accounts) {
      groupedAccounts.putIfAbsent(account.type, () => []).add(account);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: groupedAccounts.entries.map((entry) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Type header
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: TossSpacing.space4,
                vertical: TossSpacing.space2,
              ),
              child: Text(
                entry.key,
                style: TossTextStyles.caption.copyWith(
                  color: TossColors.gray500,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            // Accounts in this type
            ...entry.value.map((account) => AccountMultiSelectItem(
              account: account,
              isSelected: selectedIds.contains(account.id),
              onChanged: (isSelected) {
                onSelectionChanged(account.id, isSelected ?? false);
              },
            )),
          ],
        );
      }).toList(),
    );
  }
}

/// Multi-select item widget for a single account
class AccountMultiSelectItem extends StatelessWidget {
  final AccountData account;
  final bool isSelected;
  final ValueChanged<bool?> onChanged;

  const AccountMultiSelectItem({
    super.key,
    required this.account,
    required this.isSelected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onChanged(!isSelected),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: TossSpacing.space4,
          vertical: TossSpacing.space3,
        ),
        color: isSelected ? TossColors.primary.withValues(alpha: 0.05) : null,
        child: Row(
          children: [
            Checkbox(
              value: isSelected,
              onChanged: onChanged,
              activeColor: TossColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(width: TossSpacing.space2),
            Icon(
              Icons.account_balance_wallet,
              size: TossSpacing.iconSM,
              color: isSelected ? TossColors.primary : TossColors.gray500,
            ),
            const SizedBox(width: TossSpacing.space3),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    account.displayName,
                    style: TossTextStyles.body.copyWith(
                      color: isSelected ? TossColors.primary : TossColors.gray900,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                  if (account.categoryTag != null && account.categoryTag!.isNotEmpty)
                    Text(
                      account.categoryTag!,
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
    );
  }
}

/// Multi-select controls widget
class AccountMultiSelectControls extends StatelessWidget {
  final int selectedCount;
  final int totalCount;
  final VoidCallback onSelectAll;
  final VoidCallback onDeselectAll;
  final VoidCallback onConfirm;

  const AccountMultiSelectControls({
    super.key,
    required this.selectedCount,
    required this.totalCount,
    required this.onSelectAll,
    required this.onDeselectAll,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        TextButton(
          onPressed: onSelectAll,
          child: Text(
            'Select All',
            style: TossTextStyles.caption.copyWith(
              color: TossColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(width: TossSpacing.space2),
        TextButton(
          onPressed: onDeselectAll,
          child: Text(
            'Deselect All',
            style: TossTextStyles.caption.copyWith(
              color: TossColors.gray600,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const Spacer(),
        Text(
          '$selectedCount / $totalCount selected',
          style: TossTextStyles.caption.copyWith(
            color: TossColors.gray500,
          ),
        ),
      ],
    );
  }
}
