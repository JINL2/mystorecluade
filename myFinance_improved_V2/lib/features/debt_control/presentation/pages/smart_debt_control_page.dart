import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/providers/app_state_provider.dart';
import '../../../../core/utils/number_formatter.dart';
import '../../../../shared/themes/toss_animations.dart';
import '../../../../shared/themes/toss_border_radius.dart';
import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_spacing.dart';
import '../../../../shared/themes/toss_text_styles.dart';
import '../../../../shared/widgets/common/toss_app_bar_1.dart';
import '../../../../shared/widgets/common/toss_empty_view.dart';
import '../../../../shared/widgets/common/toss_loading_view.dart';
import '../../../../shared/widgets/common/toss_scaffold.dart';
import '../../../../shared/widgets/toss/toss_badge.dart';
import '../../../../shared/widgets/toss/toss_card.dart';
import '../../../../shared/widgets/toss/toss_chip.dart';
import '../../../../shared/widgets/toss/toss_refresh_indicator.dart';
import '../../../../shared/widgets/toss/toss_tab_bar_1.dart';
import '../../domain/entities/prioritized_debt.dart';
import '../providers/currency_provider.dart';
import '../providers/debt_control_providers.dart';
import '../widgets/perspective_summary_card.dart';

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

  String get _selectedViewpoint => _selectedTabIndex == 0 ? 'company' : 'store';

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
      if (mounted) {
        // Log error if needed
      }
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
      await ref.read(perspectiveSummaryProvider.notifier).loadPerspectiveSummary(
            companyId: appState.companyChoosen,
            storeId: storeId,
            perspectiveType: _selectedViewpoint,
            entityName: entityName,
          );
    } catch (e) {
      // Error is handled by the provider's AsyncValue
      if (mounted) {
        // Log error if needed
      }
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
    final currency = ref.watch(debtCurrencyProvider); // Read once at top level

    // Show loading view on initial load (when both are loading and have no data)
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
                    perspectiveSummary.when(
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
                            borderRadius:
                                BorderRadius.circular(TossBorderRadius.cardLarge),
                          ),
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                      ),
                      error: (_, __) => const SliverToBoxAdapter(
                        child: SizedBox.shrink(),
                      ),
                    ),

                    // Companies Section
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(
                          TossSpacing.space4,
                          TossSpacing.space4,
                          TossSpacing.space4,
                          TossSpacing.space2,
                        ),
                        child: Text(
                          'Companies',
                          style: TossTextStyles.h3.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    // Companies Filter Tabs
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: TossSpacing.space4,
                        ),
                        child: TossChipGroup(
                          items: const [
                            TossChipItem(value: 'all', label: 'All'),
                            TossChipItem(value: 'my_group', label: 'My Group', icon: Icons.people_outline),
                            TossChipItem(value: 'external', label: 'External', icon: Icons.public),
                          ],
                          selectedValue: _selectedCompaniesTab,
                          onChanged: (value) {
                            if (value != null) {
                              _onCompaniesFilterChanged(value);
                            }
                          },
                        ),
                      ),
                    ),

                    const SliverToBoxAdapter(
                      child: SizedBox(height: TossSpacing.space3),
                    ),

                    // Debts List
                    debtControlState.when(
                      data: (state) {
                        // Show loading indicator while data is being fetched
                        if (state.isLoadingDebts) {
                          return SliverFillRemaining(
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const CircularProgressIndicator(),
                                  const SizedBox(height: TossSpacing.space4),
                                  Text(
                                    'Loading debt records...',
                                    style: TossTextStyles.bodyMedium,
                                  ),
                                ],
                              ),
                            ),
                          );
                        }

                        // Show data if available
                        if (state.hasDebts) {
                          // Debts are already sorted in the provider
                          return SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                final debt = state.debts[index];
                                return _buildCompanyCard(
                                  debt,
                                  currency: currency,
                                  key: ValueKey(debt.id),
                                );
                              },
                              childCount: state.debts.length,
                            ),
                          );
                        }

                        // Show empty state only when loading is complete and no data
                        return const SliverFillRemaining(
                          child: TossEmptyView(
                            title: 'No companies found',
                            description:
                                'There are no debt records matching your criteria',
                            icon: Icon(
                              Icons.business_outlined,
                              size: 64,
                              color: TossColors.gray400,
                            ),
                          ),
                        );
                      },
                      loading: () => SliverFillRemaining(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const CircularProgressIndicator(),
                              const SizedBox(height: TossSpacing.space4),
                              Text(
                                'Loading debt records...',
                                style: TossTextStyles.bodyMedium,
                              ),
                            ],
                          ),
                        ),
                      ),
                      error: (error, stack) => SliverFillRemaining(
                        child: TossEmptyView(
                          title: 'Error loading data',
                          description: error.toString(),
                          icon: const Icon(
                            Icons.error_outline,
                            size: 64,
                            color: TossColors.error,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
            ),
    );
  }


  Widget _buildCompanyCard(
    PrioritizedDebt debt, {
    required String currency,
    Key? key,
  }) {
    final isPositive = debt.amount > 0;
    final isInternal = debt.isInternal;

    // Color scheme based on internal/external
    final accentColor = isInternal ? TossColors.primary : TossColors.warning;

    return Container(
      key: key,
      margin: const EdgeInsets.symmetric(
        horizontal: TossSpacing.space4,
        vertical: TossSpacing.space2,
      ),
      child: TossCard(
        onTap: () {
          // Navigate to transaction history page to view debt details
          context.push(
            '/transactionHistory?counterpartyId=${debt.counterpartyId}&counterpartyName=${Uri.encodeComponent(debt.counterpartyName)}&scope=all',
          );
        },
        padding: const EdgeInsets.all(TossSpacing.space4),
        child: Row(
          children: [
            // Colored vertical bar indicating internal/external
            Container(
              width: 4,
              height: 68,
              decoration: BoxDecoration(
                color: accentColor,
                borderRadius: BorderRadius.circular(TossBorderRadius.xs),
              ),
            ),
            const SizedBox(width: TossSpacing.space3),

            // Company info with internal/external badge
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Company name with type badge
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          debt.counterpartyName,
                          style: TossTextStyles.h4.copyWith(
                            color: TossColors.textPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: TossSpacing.space2),
                      TossBadge(
                        label: isInternal ? 'My Group' : 'External',
                        backgroundColor: isInternal
                            ? TossColors.primary.withValues(alpha: 0.1)
                            : TossColors.warning.withValues(alpha: 0.1),
                        textColor: accentColor,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        borderRadius: TossBorderRadius.full,
                      ),
                    ],
                  ),
                  const SizedBox(height: TossSpacing.space2),
                  // Last activity with icon
                  TossBadge(
                    label: _formatLastActivity(debt.lastContactDate),
                    icon: Icons.access_time_rounded,
                    iconSize: 12,
                    backgroundColor: TossColors.transparent,
                    textColor: TossColors.textSecondary,
                    padding: EdgeInsets.zero,
                  ),
                  const SizedBox(height: TossSpacing.space1),
                  // Transaction count
                  TossBadge(
                    label: '${debt.transactionCount} transactions',
                    icon: Icons.receipt_long_outlined,
                    iconSize: 12,
                    backgroundColor: TossColors.transparent,
                    textColor: TossColors.textSecondary,
                    padding: EdgeInsets.zero,
                  ),
                ],
              ),
            ),

            const SizedBox(width: TossSpacing.space3),

            // Amount and status badge
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Amount with financial number styling
                Text(
                  NumberFormatter.formatCurrency(debt.amount.abs(), currency),
                  style: TossTextStyles.amount.copyWith(
                    color: isPositive ? TossColors.success : TossColors.error,
                  ),
                ),
                const SizedBox(height: TossSpacing.space2),
                // Direction badge with icon
                TossBadge(
                  label: isPositive ? 'Receivable' : 'Payable',
                  icon: isPositive ? Icons.arrow_downward_rounded : Icons.arrow_upward_rounded,
                  iconSize: 10,
                  backgroundColor: isPositive
                      ? TossColors.success.withValues(alpha: 0.12)
                      : TossColors.error.withValues(alpha: 0.12),
                  textColor: isPositive ? TossColors.success : TossColors.error,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  borderRadius: TossBorderRadius.sm,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatLastActivity(DateTime? lastActivity) {
    if (lastActivity == null) return 'no activity';

    final now = DateTime.now();
    final difference = now.difference(lastActivity);
    final days = difference.inDays;

    if (days == 0) return 'today';
    if (days == 1) return '1d ago';
    if (days < 7) return '${days}d ago';
    if (days < 30) return '${(days / 7).floor()}w ago';
    if (days < 365) return '${(days / 30).floor()}mo ago';
    return '${(days / 365).floor()}y ago';
  }
}
