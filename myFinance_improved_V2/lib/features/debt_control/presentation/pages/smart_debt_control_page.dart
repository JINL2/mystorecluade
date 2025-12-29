// lib/features/debt_control/presentation/pages/smart_debt_control_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/providers/app_state_provider.dart';
import '../../../../shared/themes/toss_animations.dart';
import '../../../../shared/themes/toss_border_radius.dart';
import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_spacing.dart';
import '../../../../shared/widgets/common/toss_app_bar_1.dart';
import '../../../../shared/widgets/common/toss_loading_view.dart';
import '../../../../shared/widgets/common/toss_scaffold.dart';
import '../../../../shared/widgets/toss/toss_refresh_indicator.dart';
import '../../../../shared/widgets/toss/toss_tab_bar_1.dart';
import '../../domain/entities/perspective_summary.dart';
import '../providers/currency_provider.dart';
import '../providers/debt_control_providers.dart';
import '../widgets/perspective_summary_card.dart';
import '../widgets/smart_debt_control/smart_debt_control_widgets.dart';

/// Smart Debt Control Page
///
/// Main debt control dashboard with Clean Architecture implementation.
class SmartDebtControlPage extends ConsumerStatefulWidget {
  const SmartDebtControlPage({super.key});

  @override
  ConsumerState<SmartDebtControlPage> createState() =>
      _SmartDebtControlPageState();
}

class _SmartDebtControlPageState extends ConsumerState<SmartDebtControlPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  int _selectedTabIndex = 0;
  final String _selectedFilter = 'all'; // all, internal, external
  String _selectedCompaniesTab = 'all'; // all, my_group, external

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: TossAnimations.medium,
      vsync: this,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
      _loadPerspectiveSummary();
      _animationController.forward();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  String get _selectedViewpoint =>
      _selectedTabIndex == 0 ? 'company' : 'store';

  Future<void> _loadData({bool forceRefresh = false}) async {
    if (!mounted) return;

    final appState = ref.read(appStateProvider);
    if (appState.companyChoosen.isEmpty) return;

    final storeId = _selectedViewpoint == 'store' &&
            appState.storeChoosen.isNotEmpty
        ? appState.storeChoosen
        : null;

    try {
      if (forceRefresh) {
        await ref.read(debtControlProvider.notifier).refresh(
              companyId: appState.companyChoosen,
              storeId: storeId,
              viewpoint: _selectedViewpoint,
              filter: _selectedFilter,
            );
      } else {
        await ref.read(debtControlProvider.notifier).loadPrioritizedDebts(
              companyId: appState.companyChoosen,
              storeId: storeId,
              viewpoint: _selectedViewpoint,
              filter: _selectedFilter,
            );
      }
    } catch (e) {
      // Error is handled by the provider's AsyncValue
    }
  }

  Future<void> _loadPerspectiveSummary() async {
    if (!mounted) return;

    final appState = ref.read(appStateProvider);
    if (appState.companyChoosen.isEmpty) return;

    final storeId = _selectedViewpoint == 'store' &&
            appState.storeChoosen.isNotEmpty
        ? appState.storeChoosen
        : null;

    final entityName = _selectedViewpoint == 'store'
        ? (appState.storeChoosen.isNotEmpty ? 'Store' : 'Company')
        : 'Company';

    try {
      await ref
          .read(perspectiveSummaryProvider.notifier)
          .loadPerspectiveSummary(
            companyId: appState.companyChoosen,
            storeId: storeId,
            perspectiveType: _selectedViewpoint,
            entityName: entityName,
          );
    } catch (e) {
      // Error is handled by the provider's AsyncValue
    }
  }

  void _onTabChanged(int index) {
    setState(() {
      _selectedTabIndex = index;
    });
    _loadData();
    _loadPerspectiveSummary();
  }

  void _onCompaniesFilterChanged(String value) {
    if (!mounted) return;

    setState(() {
      _selectedCompaniesTab = value;
    });

    // Convert UI filter to API filter format
    String apiFilter = 'all';
    if (value == 'my_group') {
      apiFilter = 'internal';
    } else if (value == 'external') {
      apiFilter = 'external';
    }

    // Reload data with new filter
    final appState = ref.read(appStateProvider);
    if (appState.companyChoosen.isEmpty) return;

    final storeId = _selectedViewpoint == 'store' &&
            appState.storeChoosen.isNotEmpty
        ? appState.storeChoosen
        : null;

    ref.read(debtControlProvider.notifier).loadPrioritizedDebts(
          companyId: appState.companyChoosen,
          storeId: storeId,
          viewpoint: _selectedViewpoint,
          filter: apiFilter,
        );
  }

  @override
  Widget build(BuildContext context) {
    final debtControlState = ref.watch(debtControlProvider);
    final perspectiveSummary = ref.watch(perspectiveSummaryProvider);
    final currency = ref.watch(debtCurrencyProvider);

    // Show loading view on initial load
    final isInitialLoading = debtControlState.isLoading &&
        !debtControlState.hasValue &&
        perspectiveSummary.isLoading &&
        !perspectiveSummary.hasValue;

    return TossScaffold(
      appBar: const TossAppBar1(
        title: 'Debt Control',
      ),
      backgroundColor: TossColors.background,
      body: isInitialLoading
          ? const TossLoadingView(
              message: 'Loading debt data...',
            )
          : SafeArea(
              child: Column(
                children: [
                  // Tab Bar
                  TossTabBar1(
                    tabs: const ['Company', 'Store'],
                    onTabChanged: _onTabChanged,
                  ),

                  // Content
                  Expanded(
                    child: TossRefreshIndicator(
                      onRefresh: () async {
                        await Future.wait([
                          _loadData(forceRefresh: true),
                          _loadPerspectiveSummary(),
                        ]);
                      },
                      child: CustomScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        slivers: [
                          // Perspective Summary Card
                          _buildPerspectiveSummary(perspectiveSummary),

                          // Companies Section with Filter and List
                          _buildCompaniesContent(debtControlState, currency),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildPerspectiveSummary(
    AsyncValue<PerspectiveSummary?> perspectiveSummary,
  ) {
    return perspectiveSummary.when(
      data: (summary) {
        if (summary == null) {
          return const SliverToBoxAdapter(
            child: SizedBox.shrink(),
          );
        }
        return SliverToBoxAdapter(
          child: PerspectiveSummaryCard(
            summary: summary,
            onTap: () {
              _loadPerspectiveSummary();
            },
          ),
        );
      },
      loading: () => SliverToBoxAdapter(
        child: Container(
          margin: const EdgeInsets.all(TossSpacing.space4),
          height: 300,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                TossColors.gray200,
                TossColors.gray100,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(TossBorderRadius.cardLarge),
          ),
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ),
      error: (_, __) => const SliverToBoxAdapter(
        child: SizedBox.shrink(),
      ),
    );
  }

  Widget _buildCompaniesContent(
    AsyncValue<DebtControlState> debtControlState,
    String currency,
  ) {
    return debtControlState.when(
      data: (state) {
        return DebtCompaniesSection(
          state: state,
          currency: currency,
          selectedCompaniesTab: _selectedCompaniesTab,
          onFilterChanged: _onCompaniesFilterChanged,
        );
      },
      loading: () => const DebtListLoadingState(),
      error: (error, _) => DebtListErrorState(error: error),
    );
  }
}
