import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/providers/app_state_provider.dart';
import '../../../../core/utils/number_formatter.dart';
import '../../../../shared/themes/toss_animations.dart';
import '../../../../shared/themes/toss_border_radius.dart';
import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_spacing.dart';
import '../../../../shared/themes/toss_text_styles.dart';
import '../../../../shared/widgets/common/toss_app_bar_1.dart';
import '../../../../shared/widgets/common/toss_empty_view.dart';
import '../../../../shared/widgets/common/toss_scaffold.dart';
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
    final appState = ref.read(appStateProvider);
    if (appState.companyChoosen.isEmpty) return;

    final storeId = _selectedViewpoint == 'store' &&
            appState.storeChoosen.isNotEmpty
        ? appState.storeChoosen
        : null;

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
  }

  Future<void> _loadPerspectiveSummary() async {
    final appState = ref.read(appStateProvider);
    if (appState.companyChoosen.isEmpty) return;

    final entityId = _selectedViewpoint == 'store' &&
            appState.storeChoosen.isNotEmpty
        ? appState.storeChoosen
        : appState.companyChoosen;

    final entityName = _selectedViewpoint == 'store'
        ? (appState.storeChoosen.isNotEmpty ? 'Store' : 'Company')
        : 'Company';

    await ref.read(perspectiveSummaryProvider.notifier).loadPerspectiveSummary(
          perspectiveType: _selectedViewpoint,
          entityId: entityId,
          entityName: entityName,
        );
  }

  void _onTabChanged(int index) {
    setState(() {
      _selectedTabIndex = index;
    });
    _loadData();
    _loadPerspectiveSummary();
  }

  @override
  Widget build(BuildContext context) {
    final debtControlState = ref.watch(debtControlProvider);
    final perspectiveSummary = ref.watch(perspectiveSummaryProvider);

    return TossScaffold(
      appBar: const TossAppBar1(
        title: 'Debt Control',
      ),
      backgroundColor: TossColors.background,
      body: SafeArea(
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
                    if (perspectiveSummary.hasValue &&
                        perspectiveSummary.value != null)
                      SliverToBoxAdapter(
                        child: PerspectiveSummaryCard(
                          summary: perspectiveSummary.value!,
                          onTap: () {
                            _loadPerspectiveSummary();
                          },
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
                        child: Row(
                          children: [
                            _buildCompaniesFilterChip('All', 'all'),
                            const SizedBox(width: TossSpacing.space2),
                            _buildCompaniesFilterChip('My Group', 'my_group'),
                            const SizedBox(width: TossSpacing.space2),
                            _buildCompaniesFilterChip('External', 'external'),
                          ],
                        ),
                      ),
                    ),

                    const SliverToBoxAdapter(
                      child: SizedBox(height: TossSpacing.space3),
                    ),

                    // Debts List
                    debtControlState.when(
                      data: (state) {
                        if (state.isLoadingDebts) {
                          return const SliverFillRemaining(
                            child: Center(child: CircularProgressIndicator()),
                          );
                        } else if (state.hasDebts) {
                          return SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                final debt = state.debts[index];
                                return _buildCompanyCard(debt);
                              },
                              childCount: state.debts.length,
                            ),
                          );
                        } else {
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
                        }
                      },
                      loading: () => const SliverFillRemaining(
                        child: Center(child: CircularProgressIndicator()),
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

  Widget _buildCompaniesFilterChip(String label, String value) {
    final isSelected = _selectedCompaniesTab == value;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCompaniesTab = value;
        });
        // TODO: Filter companies based on selection
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: TossSpacing.space4,
          vertical: TossSpacing.space2,
        ),
        decoration: BoxDecoration(
          color: isSelected ? TossColors.gray100 : TossColors.white,
          borderRadius: BorderRadius.circular(TossBorderRadius.full),
          border: Border.all(
            color: isSelected ? TossColors.gray300 : TossColors.border,
          ),
        ),
        child: Text(
          label,
          style: TossTextStyles.body.copyWith(
            color: isSelected ? TossColors.textPrimary : TossColors.textSecondary,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildCompanyCard(PrioritizedDebt debt) {
    final isPositive = debt.amount > 0;
    final currency = ref.watch(debtCurrencyProvider);

    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: TossSpacing.space4,
        vertical: TossSpacing.space2,
      ),
      decoration: BoxDecoration(
        color: TossColors.white,
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        border: Border.all(
          color: TossColors.border,
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(TossSpacing.space4),
        child: Row(
          children: [
            // Blue vertical bar on the left
            Container(
              width: 4,
              height: 60,
              decoration: BoxDecoration(
                color: TossColors.primary,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: TossSpacing.space3),

            // Company info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    debt.counterpartyName,
                    style: TossTextStyles.h4.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Last activity ${_formatLastActivity(debt.daysOverdue)}',
                    style: TossTextStyles.caption.copyWith(
                      color: TossColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),

            // Amount and badge
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  NumberFormatter.formatCurrency(debt.amount.abs(), currency),
                  style: TossTextStyles.body.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isPositive ? TossColors.success : TossColors.error,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: isPositive
                        ? TossColors.success.withValues(alpha: 0.1)
                        : TossColors.error.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                  ),
                  child: Text(
                    isPositive ? 'They owe us' : 'We owe them',
                    style: TossTextStyles.caption.copyWith(
                      color: isPositive ? TossColors.success : TossColors.error,
                      fontWeight: FontWeight.w600,
                      fontSize: 10,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatLastActivity(int daysOverdue) {
    if (daysOverdue == 0) return 'today';
    if (daysOverdue == 1) return '1d ago';
    if (daysOverdue < 7) return '${daysOverdue}d ago';
    if (daysOverdue < 30) return '${(daysOverdue / 7).floor()}w ago';
    return '${(daysOverdue / 30).floor()}m ago';
  }
}
