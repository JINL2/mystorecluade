/// Counterparty Section - Counterparty display and selectors
///
/// Purpose: Manages counterparty-related UI for template entries
/// - Read-only counterparty display (counterparty cannot be changed)
/// - Counterparty store selector (for internal counterparties)
/// - Counterparty cash location selector (for internal counterparties)
/// - Account mapping status display
///
/// Clean Architecture: PRESENTATION LAYER - Widget
library;

import 'package:myfinance_improved/shared/widgets/index.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinance_improved/shared/themes/index.dart';

import '../../../../journal_input/presentation/providers/journal_input_providers.dart';
import 'entry_edit_state.dart';

/// Counterparty section with display and selectors
class CounterpartySection extends ConsumerWidget {
  final int index;
  final EntryEditState entryState;
  final VoidCallback onStateChanged;
  final Future<void> Function(int, EntryEditState) onCheckAccountMapping;
  final void Function(String, String) onNavigateToAccountSettings;

  const CounterpartySection({
    super.key,
    required this.index,
    required this.entryState,
    required this.onStateChanged,
    required this.onCheckAccountMapping,
    required this.onNavigateToAccountSettings,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Counterparty display (read-only)
        _CounterpartyDisplay(entryState: entryState),

        // Counterparty Store selector (only for INTERNAL counterparty)
        if (entryState.counterpartyId != null &&
            entryState.isCounterpartyInternal &&
            entryState.linkedCompanyId != null) ...[
          const SizedBox(height: TossSpacing.space3),
          _CounterpartyStoreSelector(
            index: index,
            entryState: entryState,
            onStateChanged: onStateChanged,
          ),
        ],

        // Counterparty Cash Location selector (only for INTERNAL counterparty)
        if (entryState.counterpartyId != null &&
            entryState.isCounterpartyInternal &&
            entryState.linkedCompanyId != null) ...[
          const SizedBox(height: TossSpacing.space3),
          AutonomousCashLocationSelector(
            companyId: entryState.linkedCompanyId, // Counterparty's company
            storeId: entryState.counterpartyStoreId, // Counterparty's selected store
            selectedLocationId: entryState.counterpartyCashLocationId,
            label: 'Counterparty Cash Location *', // Asterisk indicates required
            showScopeTabs: entryState.counterpartyStoreId != null,
            onChanged: (cashLocationId) {
              entryState.counterpartyCashLocationId = cashLocationId;
              onStateChanged();
            },
          ),
        ],

        // Account Mapping Status (for internal + payable/receivable)
        if (entryState.isCounterpartyInternal &&
            (entryState.categoryTag == 'payable' ||
                entryState.categoryTag == 'receivable')) ...[
          const SizedBox(height: TossSpacing.space3),
          _AccountMappingStatus(
            index: index,
            entryState: entryState,
            onCheckAccountMapping: onCheckAccountMapping,
            onNavigateToAccountSettings: onNavigateToAccountSettings,
          ),
        ],
      ],
    );
  }
}

/// Read-only counterparty display
class _CounterpartyDisplay extends StatelessWidget {
  final EntryEditState entryState;

  const _CounterpartyDisplay({required this.entryState});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Counterparty',
          style: TossTextStyles.label.copyWith(
            color: TossColors.gray700,
          ),
        ),
        const SizedBox(height: TossSpacing.space2),
        Container(
          padding: const EdgeInsets.all(TossSpacing.space3),
          decoration: BoxDecoration(
            border: Border.all(color: TossColors.gray300),
            borderRadius: BorderRadius.circular(TossBorderRadius.md),
            color: TossColors.gray50,
          ),
          child: Row(
            children: [
              Icon(
                entryState.isCounterpartyInternal
                    ? Icons.business
                    : Icons.person_outline,
                color: TossColors.gray600,
                size: 20,
              ),
              const SizedBox(width: TossSpacing.space2),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      entryState.counterpartyName ?? 'Unknown',
                      style: TossTextStyles.body.copyWith(
                        color: TossColors.gray900,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (entryState.isCounterpartyInternal)
                      Text(
                        'Internal',
                        style: TossTextStyles.caption.copyWith(
                          color: TossColors.primary,
                        ),
                      ),
                  ],
                ),
              ),
              Icon(
                Icons.lock_outline,
                color: TossColors.gray400,
                size: 16,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Counterparty store selector
class _CounterpartyStoreSelector extends ConsumerWidget {
  final int index;
  final EntryEditState entryState;
  final VoidCallback onStateChanged;

  const _CounterpartyStoreSelector({
    required this.index,
    required this.entryState,
    required this.onStateChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final storesAsync =
        ref.watch(journalCounterpartyStoresProvider(entryState.linkedCompanyId));

    return storesAsync.when(
      data: (stores) {
        if (stores.isEmpty) {
          return Container(
            padding: const EdgeInsets.all(TossSpacing.space3),
            decoration: BoxDecoration(
              color: TossColors.gray50,
              borderRadius: BorderRadius.circular(TossBorderRadius.md),
              border: Border.all(color: TossColors.gray200),
            ),
            child: Row(
              children: [
                const Icon(Icons.info_outline,
                    size: 18, color: TossColors.gray500),
                const SizedBox(width: TossSpacing.space2),
                Text(
                  'No stores configured for this counterparty',
                  style:
                      TossTextStyles.bodySmall.copyWith(color: TossColors.gray600),
                ),
              ],
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Counterparty Store',
              style: TossTextStyles.label.copyWith(color: TossColors.gray700),
            ),
            const SizedBox(height: TossSpacing.space2),
            GestureDetector(
              onTap: () => _showStoreSelectionBottomSheet(context, stores),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                decoration: BoxDecoration(
                  color: TossColors.white,
                  borderRadius: BorderRadius.circular(TossBorderRadius.md),
                  border: Border.all(color: TossColors.gray300),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.store,
                      size: 20,
                      color: entryState.counterpartyStoreId != null
                          ? TossColors.primary
                          : TossColors.gray400,
                    ),
                    const SizedBox(width: TossSpacing.space2),
                    Expanded(
                      child: Text(
                        entryState.counterpartyStoreName ??
                            'Select store (optional)',
                        style: TossTextStyles.body.copyWith(
                          color: entryState.counterpartyStoreId != null
                              ? TossColors.gray900
                              : TossColors.gray400,
                          fontWeight: entryState.counterpartyStoreId != null
                              ? FontWeight.w500
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.arrow_drop_down,
                      color: entryState.counterpartyStoreId != null
                          ? TossColors.primary
                          : TossColors.gray400,
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
      loading: () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Counterparty Store',
            style: TossTextStyles.label.copyWith(color: TossColors.gray700),
          ),
          const SizedBox(height: TossSpacing.space2),
          const Center(child: TossLoadingView()),
        ],
      ),
      error: (_, __) => Container(
        padding: const EdgeInsets.all(TossSpacing.space3),
        decoration: BoxDecoration(
          color: TossColors.error.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(TossBorderRadius.md),
        ),
        child: Text(
          'Error loading stores',
          style: TossTextStyles.bodySmall.copyWith(color: TossColors.error),
        ),
      ),
    );
  }

  void _showStoreSelectionBottomSheet(
    BuildContext context,
    List<Map<String, dynamic>> stores,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _StoreSelectionSheet(
        stores: stores,
        entryState: entryState,
        onStateChanged: onStateChanged,
      ),
    );
  }
}

/// Store selection bottom sheet
class _StoreSelectionSheet extends StatelessWidget {
  final List<Map<String, dynamic>> stores;
  final EntryEditState entryState;
  final VoidCallback onStateChanged;

  const _StoreSelectionSheet({
    required this.stores,
    required this.entryState,
    required this.onStateChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: TossColors.surface,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(TossBorderRadius.xxl),
          topRight: Radius.circular(TossBorderRadius.xxl),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: const EdgeInsets.only(top: TossSpacing.space3),
            width: 36,
            height: 4,
            decoration: BoxDecoration(
              color: TossColors.gray300,
              borderRadius: BorderRadius.circular(TossBorderRadius.xs),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(TossSpacing.space4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Select Store',
                    style:
                        TossTextStyles.h3.copyWith(fontWeight: FontWeight.w600)),
                IconButton(
                  icon: const Icon(Icons.close, color: TossColors.gray500),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          // Clear selection option
          ListTile(
            leading: const Icon(Icons.clear, color: TossColors.gray500),
            title: Text('No store selected',
                style: TossTextStyles.body.copyWith(color: TossColors.gray600)),
            onTap: () {
              entryState.counterpartyStoreId = null;
              entryState.counterpartyStoreName = null;
              entryState.counterpartyCashLocationId = null;
              entryState.counterpartyCashLocationName = null;
              onStateChanged();
              Navigator.pop(context);
            },
          ),
          const Divider(height: 1),
          Flexible(
            child: ListView.separated(
              shrinkWrap: true,
              padding:
                  const EdgeInsets.symmetric(horizontal: TossSpacing.space4),
              itemCount: stores.length,
              separatorBuilder: (_, __) =>
                  const Divider(height: 1, color: TossColors.gray100),
              itemBuilder: (_, i) {
                final store = stores[i];
                final storeId = store['store_id'] as String?;
                final storeName =
                    store['store_name'] as String? ?? 'Unknown Store';
                final isSelected = entryState.counterpartyStoreId == storeId;

                return ListTile(
                  leading: Icon(
                    Icons.store,
                    color:
                        isSelected ? TossColors.primary : TossColors.gray500,
                  ),
                  title: Text(
                    storeName,
                    style: TossTextStyles.body.copyWith(
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.w500,
                      color:
                          isSelected ? TossColors.primary : TossColors.gray900,
                    ),
                  ),
                  trailing: isSelected
                      ? const Icon(Icons.check, color: TossColors.primary)
                      : null,
                  onTap: () {
                    entryState.counterpartyStoreId = storeId;
                    entryState.counterpartyStoreName = storeName;
                    // Clear cash location when store changes
                    entryState.counterpartyCashLocationId = null;
                    entryState.counterpartyCashLocationName = null;
                    onStateChanged();
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
          SizedBox(
              height: MediaQuery.of(context).padding.bottom + TossSpacing.space4),
        ],
      ),
    );
  }
}

/// Account mapping status display
class _AccountMappingStatus extends StatefulWidget {
  final int index;
  final EntryEditState entryState;
  final Future<void> Function(int, EntryEditState) onCheckAccountMapping;
  final void Function(String, String) onNavigateToAccountSettings;

  const _AccountMappingStatus({
    required this.index,
    required this.entryState,
    required this.onCheckAccountMapping,
    required this.onNavigateToAccountSettings,
  });

  @override
  State<_AccountMappingStatus> createState() => _AccountMappingStatusState();
}

class _AccountMappingStatusState extends State<_AccountMappingStatus> {
  @override
  void initState() {
    super.initState();
    // Check account mapping on first build
    if (widget.entryState.accountMapping == null &&
        widget.entryState.mappingError == null) {
      widget.onCheckAccountMapping(widget.index, widget.entryState);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.entryState.accountMapping != null) {
      return Container(
        padding: const EdgeInsets.all(TossSpacing.space3),
        decoration: BoxDecoration(
          color: TossColors.success.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(TossBorderRadius.md),
          border: Border.all(color: TossColors.success.withValues(alpha: 0.3)),
        ),
        child: Row(
          children: [
            const Icon(Icons.check_circle, color: TossColors.success, size: 20),
            const SizedBox(width: TossSpacing.space2),
            Text(
              'Account mapping verified',
              style: TossTextStyles.bodySmall.copyWith(
                color: TossColors.success,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      );
    }

    if (widget.entryState.mappingError != null) {
      return Container(
        padding: const EdgeInsets.all(TossSpacing.space3),
        decoration: BoxDecoration(
          color: TossColors.error.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(TossBorderRadius.md),
          border: Border.all(color: TossColors.error.withValues(alpha: 0.3)),
        ),
        child: Row(
          children: [
            const Icon(Icons.warning, color: TossColors.error, size: 20),
            const SizedBox(width: TossSpacing.space2),
            Expanded(
              child: Text(
                widget.entryState.mappingError!,
                style:
                    TossTextStyles.bodySmall.copyWith(color: TossColors.error),
              ),
            ),
            // "Set Up" button to navigate to Account Settings
            if (widget.entryState.counterpartyId != null &&
                widget.entryState.counterpartyName != null)
              GestureDetector(
                onTap: () => widget.onNavigateToAccountSettings(
                  widget.entryState.counterpartyId!,
                  widget.entryState.counterpartyName!,
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: TossSpacing.space2,
                    vertical: TossSpacing.space1,
                  ),
                  decoration: BoxDecoration(
                    color: TossColors.primary,
                    borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                  ),
                  child: Text(
                    'Set Up',
                    style: TossTextStyles.caption.copyWith(
                      color: TossColors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
          ],
        ),
      );
    }

    // Loading state
    return Container(
      padding: const EdgeInsets.all(TossSpacing.space3),
      decoration: BoxDecoration(
        color: TossColors.gray50,
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
      ),
      child: Row(
        children: [
          const SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
          const SizedBox(width: TossSpacing.space2),
          Text(
            'Checking account mapping...',
            style: TossTextStyles.bodySmall.copyWith(color: TossColors.gray600),
          ),
        ],
      ),
    );
  }
}
