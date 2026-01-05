import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:myfinance_improved/shared/themes/toss_animations.dart';
import 'package:myfinance_improved/shared/themes/toss_border_radius.dart';
import 'package:myfinance_improved/shared/themes/toss_colors.dart';
import 'package:myfinance_improved/shared/themes/toss_spacing.dart';

import '../../domain/entities/counter_party.dart';
import '../providers/counter_party_providers.dart';
import '../widgets/counter_party_form.dart';
import '../widgets/filter/filter_sheet.dart';
import '../widgets/filter/filter_sort_bar.dart';
import '../widgets/list/counter_party_list_section.dart';
import '../widgets/stats/counter_party_stats_section.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

class CounterPartyPage extends ConsumerStatefulWidget {
  const CounterPartyPage({super.key});

  @override
  ConsumerState<CounterPartyPage> createState() => _CounterPartyPageState();
}

class _CounterPartyPageState extends ConsumerState<CounterPartyPage> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  Timer? _searchDebounce;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeData();
    });
  }

  void _initializeData() {
    final companyId = ref.read(selectedCompanyIdProvider);
    if (companyId != null) {
      // Always fetch fresh data on page entry
      ref.invalidate(optimizedCounterPartyDataProvider(companyId));
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    _searchDebounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    _searchDebounce?.cancel();
    _searchDebounce = Timer(TossAnimations.slow, () {
      ref.read(counterPartySearchProvider.notifier).setSearch(value);
    });
  }

  Future<void> _refreshData() async {
    final refresh = ref.read(counterPartyRefreshProvider);
    refresh();
  }

  void _showCreateForm() {
    TossBottomSheet.showWithBuilder<void>(
      context: context,
      heightFactor: 0.8,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: TossColors.surface,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(TossBorderRadius.xl),
            topRight: Radius.circular(TossBorderRadius.xl),
          ),
        ),
        child: const CounterPartyForm(),
      ),
    );
  }

  void _showEditForm(CounterParty counterParty) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: TossColors.transparent,
      constraints: BoxConstraints(
        maxHeight: (MediaQuery.of(context).size.height -
                   MediaQuery.of(context).viewInsets.bottom) * 0.8,
      ),
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: TossColors.surface,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(TossBorderRadius.xl),
            topRight: Radius.circular(TossBorderRadius.xl),
          ),
        ),
        child: CounterPartyForm(counterParty: counterParty),
      ),
    );
  }

  void _showFilterSheet() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: TossColors.transparent,
      builder: (context) => const CounterPartyFilterSheet(),
    );
  }

  void _showSortSheet() {
    SortOptionsHelper.showSortSheet(context, ref);
  }

  Future<void> _deleteCounterParty(CounterParty counterParty) async {
    try {
      await ref.read(deleteCounterPartyProvider(counterParty.counterpartyId).future);

      if (!mounted) return;

      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (dialogContext) => TossDialog.success(
          title: 'Counter Party Deleted!',
          message: '${counterParty.name} has been deleted successfully',
          primaryButtonText: 'Done',
          onPrimaryPressed: () {
            if (Navigator.canPop(dialogContext)) {
              Navigator.pop(dialogContext);
            }
          },
        ),
      );
    } catch (e) {
      if (!mounted) return;

      final errorMessage = e.toString();
      String title = 'Failed to Delete';
      String message = 'Could not delete counter party';

      if (errorMessage.contains('unpaid debts')) {
        title = 'Cannot Delete - Unpaid Debts';
        message = 'Counter party "${counterParty.name}" has outstanding debts that need to be settled before deletion.\n\n'
                  'Please clear all debts in the Debt Control section first.';
      } else {
        message = 'Could not delete "${counterParty.name}".\n\n$errorMessage';
      }

      await showDialog(
        context: context,
        barrierDismissible: true,
        builder: (dialogContext) => TossDialog.error(
          title: title,
          message: message,
          primaryButtonText: 'OK',
          onPrimaryPressed: () {
            if (Navigator.canPop(dialogContext)) {
              Navigator.pop(dialogContext);
            }
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final counterPartiesAsync = ref.watch(optimizedCounterPartiesProvider);
    final statsAsync = ref.watch(optimizedCounterPartyStatsProvider);
    ref.watch(selectedCompanyIdProvider);

    return TossScaffold(
      backgroundColor: TossColors.gray100,
      appBar: TossAppBar(
        title: 'Counter Party',
        backgroundColor: TossColors.gray100,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: TossColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        primaryActionText: 'Add',
        primaryActionIcon: Icons.add,
        onPrimaryAction: _showCreateForm,
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        color: TossColors.primary,
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            // Stats Card
            CounterPartyStatsSection(
              statsAsync: statsAsync,
              onRetry: _refreshData,
            ),

            // Filter and Sort Bar
            FilterSortBar(
              onFilterTap: _showFilterSheet,
              onSortTap: _showSortSheet,
            ),

            // Search Field
            _buildSearchField(),

            // Counter Party List
            CounterPartyListSection(
              counterPartiesAsync: counterPartiesAsync,
              onEdit: _showEditForm,
              onDelete: _deleteCounterParty,
              onRetry: _refreshData,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchField() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          TossSpacing.space4,
          TossSpacing.space2,
          TossSpacing.space4,
          TossSpacing.space3,
        ),
        child: TossSearchField(
          controller: _searchController,
          hintText: 'Search counterparties...',
          prefixIcon: Icons.search,
          onChanged: _onSearchChanged,
          onClear: () {
            _searchController.clear();
            _onSearchChanged('');
          },
        ),
      ),
    );
  }
}
