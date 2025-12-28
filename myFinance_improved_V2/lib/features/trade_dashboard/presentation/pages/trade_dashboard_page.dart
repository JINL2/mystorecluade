import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/providers/app_state_provider.dart';
import '../../../../shared/widgets/common/toss_scaffold.dart';
import '../../../../shared/themes/toss_text_styles.dart';
import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_spacing.dart';
import '../../../../shared/themes/toss_border_radius.dart';
import '../../../trade_shared/presentation/widgets/trade_widgets.dart';
import '../../../trade_shared/presentation/providers/trade_shared_providers.dart';
import '../../../trade_shared/domain/entities/dashboard_summary.dart';
import '../widgets/dashboard_header.dart';
import '../widgets/dashboard_overview_section.dart';
import '../widgets/dashboard_alerts_section.dart';
import '../widgets/dashboard_activity_section.dart';
import '../widgets/dashboard_quick_actions.dart';

class TradeDashboardPage extends ConsumerStatefulWidget {
  final dynamic feature;

  const TradeDashboardPage({super.key, this.feature});

  @override
  ConsumerState<TradeDashboardPage> createState() => _TradeDashboardPageState();
}

class _TradeDashboardPageState extends ConsumerState<TradeDashboardPage> {
  DateRangeState? _previousDateRange;

  @override
  void initState() {
    super.initState();
    // Load initial data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadDashboardData();
    });
  }

  Future<void> _loadDashboardData() async {
    // Get actual company ID from app state
    final appState = ref.read(appStateProvider);
    final companyId = appState.companyChoosen;
    final storeId = appState.storeChoosen;

    // Check if company is selected
    if (companyId.isEmpty) {
      return;
    }

    final dateRange = ref.read(dateRangeProvider);

    ref.read(dashboardSummaryProvider.notifier).loadDashboardSummary(
          companyId: companyId,
          storeId: storeId.isNotEmpty ? storeId : null,
          dateFrom: dateRange.dateFrom,
          dateTo: dateRange.dateTo,
        );

    ref.read(recentActivitiesProvider.notifier).loadActivities(
          companyId: companyId,
          storeId: storeId.isNotEmpty ? storeId : null,
          limit: 10,
        );

    ref.read(tradeAlertsProvider.notifier).loadAlerts(
          companyId: companyId,
          refresh: true,
        );
  }

  @override
  Widget build(BuildContext context) {
    final summaryState = ref.watch(dashboardSummaryProvider);
    final activitiesState = ref.watch(recentActivitiesProvider);
    final alertsState = ref.watch(tradeAlertsProvider);
    final dateRange = ref.watch(dateRangeProvider);

    // Reload data when date range changes
    if (_previousDateRange != null && _previousDateRange!.label != dateRange.label) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _loadDashboardData();
      });
    }
    _previousDateRange = dateRange;

    return TossScaffold(
      appBar: AppBar(
        title: const Text('Trade Dashboard'),
        backgroundColor: TossColors.white,
        foregroundColor: TossColors.gray900,
        elevation: 0,
        actions: [
          if (alertsState.unreadCount > 0)
            Stack(
              alignment: Alignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.notifications_outlined),
                  onPressed: () => _showAlertsBottomSheet(context),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: TossColors.error,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 18,
                      minHeight: 18,
                    ),
                    child: Text(
                      alertsState.unreadCount > 9
                          ? '9+'
                          : alertsState.unreadCount.toString(),
                      style: TossTextStyles.caption.copyWith(
                        color: TossColors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            )
          else
            IconButton(
              icon: const Icon(Icons.notifications_outlined),
              onPressed: () => _showAlertsBottomSheet(context),
            ),
          IconButton(
            icon: const Icon(Icons.tune_outlined),
            onPressed: () => _showFilterBottomSheet(context),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadDashboardData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Date range header
              const DashboardHeader(),

              // Loading or error state
              if (summaryState.isLoading)
                _buildLoadingState()
              else if (summaryState.error != null)
                _buildErrorState(summaryState.error!)
              else if (summaryState.data != null)
                _buildDashboardContent(summaryState.data!)
              else
                _buildEmptyState(),

              const SizedBox(height: TossSpacing.space8),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Padding(
      padding: const EdgeInsets.all(TossSpacing.space4),
      child: Column(
        children: [
          // Overview skeleton
          _buildSkeletonCard(height: 180),
          const SizedBox(height: TossSpacing.space4),
          // Quick actions skeleton
          Row(
            children: [
              Expanded(child: _buildSkeletonCard(height: 80)),
              const SizedBox(width: TossSpacing.space3),
              Expanded(child: _buildSkeletonCard(height: 80)),
            ],
          ),
          const SizedBox(height: TossSpacing.space3),
          Row(
            children: [
              Expanded(child: _buildSkeletonCard(height: 80)),
              const SizedBox(width: TossSpacing.space3),
              Expanded(child: _buildSkeletonCard(height: 80)),
            ],
          ),
          const SizedBox(height: TossSpacing.space4),
          // Activity skeleton
          _buildSkeletonCard(height: 200),
        ],
      ),
    );
  }

  Widget _buildSkeletonCard({required double height}) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: TossColors.gray100,
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Padding(
      padding: const EdgeInsets.all(TossSpacing.space6),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: TossColors.error,
            ),
            const SizedBox(height: TossSpacing.space4),
            Text(
              'Failed to load dashboard',
              style: TossTextStyles.h3.copyWith(
                color: TossColors.gray900,
              ),
            ),
            const SizedBox(height: TossSpacing.space2),
            Text(
              error,
              style: TossTextStyles.bodySmall.copyWith(
                color: TossColors.gray500,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: TossSpacing.space4),
            ElevatedButton.icon(
              onPressed: _loadDashboardData,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
              style: ElevatedButton.styleFrom(
                backgroundColor: TossColors.primary,
                foregroundColor: TossColors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.all(TossSpacing.space6),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inbox_outlined,
              size: 64,
              color: TossColors.gray300,
            ),
            const SizedBox(height: TossSpacing.space4),
            Text(
              'No trade data yet',
              style: TossTextStyles.h3.copyWith(
                color: TossColors.gray900,
              ),
            ),
            const SizedBox(height: TossSpacing.space2),
            Text(
              'Start by creating your first Proforma Invoice',
              style: TossTextStyles.bodySmall.copyWith(
                color: TossColors.gray500,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: TossSpacing.space4),
            ElevatedButton.icon(
              onPressed: () {
                // TODO: Navigate to PI creation
              },
              icon: const Icon(Icons.add),
              label: const Text('Create Proforma Invoice'),
              style: ElevatedButton.styleFrom(
                backgroundColor: TossColors.primary,
                foregroundColor: TossColors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardContent(DashboardSummary summary) {
    final activitiesState = ref.watch(recentActivitiesProvider);
    final alertsState = ref.watch(tradeAlertsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Overview section
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space4),
          child: DashboardOverviewSection(summary: summary),
        ),

        const SizedBox(height: TossSpacing.space6),

        // Quick actions
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space4),
          child: DashboardQuickActions(
            onCreatePI: () {
              // TODO: Navigate to PI creation
            },
            onViewLC: () {
              // TODO: Navigate to L/C list
            },
            onViewShipments: () {
              // TODO: Navigate to Shipments
            },
            onViewReports: () {
              // TODO: Navigate to Reports
            },
          ),
        ),

        const SizedBox(height: TossSpacing.space6),

        // Alerts section (if any)
        if (alertsState.alerts.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space4),
            child: DashboardAlertsSection(
              alerts: alertsState.alerts.take(3).toList(),
              totalCount: alertsState.totalCount,
              onViewAll: () => _showAlertsBottomSheet(context),
            ),
          ),

        if (alertsState.alerts.isNotEmpty)
          const SizedBox(height: TossSpacing.space6),

        // Recent activity section
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space4),
          child: DashboardActivitySection(
            activities: activitiesState.activities,
            isLoading: activitiesState.isLoading,
            onViewAll: () {
              context.push('/trade/activities');
            },
          ),
        ),
      ],
    );
  }

  void _showAlertsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: TossColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) {
          return _AlertsBottomSheet(scrollController: scrollController);
        },
      ),
    );
  }

  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: TossColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => const _DateFilterBottomSheet(),
    );
  }
}

/// Alerts bottom sheet content
class _AlertsBottomSheet extends ConsumerWidget {
  final ScrollController scrollController;

  const _AlertsBottomSheet({required this.scrollController});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final alertsState = ref.watch(tradeAlertsProvider);

    return Column(
      children: [
        // Handle bar
        Container(
          margin: const EdgeInsets.symmetric(vertical: TossSpacing.space2),
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
                'Alerts',
                style: TossTextStyles.h3.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (alertsState.unreadCount > 0)
                TextButton(
                  onPressed: () {
                    final appState = ref.read(appStateProvider);
                    ref.read(tradeAlertsProvider.notifier).markAllAsRead(
                          companyId: appState.companyChoosen,
                          userId: appState.userId,
                        );
                  },
                  child: Text(
                    'Mark all as read',
                    style: TossTextStyles.bodySmall.copyWith(
                      color: TossColors.primary,
                    ),
                  ),
                ),
            ],
          ),
        ),

        const Divider(height: 1),

        // Alert list
        Expanded(
          child: alertsState.alerts.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.notifications_off_outlined,
                        size: 48,
                        color: TossColors.gray300,
                      ),
                      const SizedBox(height: TossSpacing.space3),
                      Text(
                        'No alerts',
                        style: TossTextStyles.bodyMedium.copyWith(
                          color: TossColors.gray500,
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  controller: scrollController,
                  padding: const EdgeInsets.all(TossSpacing.space4),
                  itemCount: alertsState.alerts.length,
                  itemBuilder: (context, index) {
                    final alert = alertsState.alerts[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: TossSpacing.space3),
                      child: TradeAlertListItem(
                        alert: alert,
                        onTap: () {
                          // TODO: Navigate to related entity
                        },
                        onMarkRead: () {
                          final appState = ref.read(appStateProvider);
                          ref.read(tradeAlertsProvider.notifier).markAsRead(
                                companyId: appState.companyChoosen,
                                alertId: alert.id,
                              );
                        },
                        onDismiss: () {
                          final appState = ref.read(appStateProvider);
                          ref.read(tradeAlertsProvider.notifier).dismissAlert(
                                companyId: appState.companyChoosen,
                                alertId: alert.id,
                              );
                        },
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}

/// Date filter bottom sheet
class _DateFilterBottomSheet extends ConsumerWidget {
  const _DateFilterBottomSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dateRange = ref.watch(dateRangeProvider);

    return Padding(
      padding: const EdgeInsets.all(TossSpacing.space4),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle bar
          Center(
            child: Container(
              margin: const EdgeInsets.only(bottom: TossSpacing.space4),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: TossColors.gray300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          Text(
            'Date Range',
            style: TossTextStyles.h3.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: TossSpacing.space4),

          _buildDateOption(
            context: context,
            ref: ref,
            label: 'All Time',
            isSelected: dateRange.label == 'All Time',
            onTap: () {
              ref.read(dateRangeProvider.notifier).setAllTime();
              Navigator.pop(context);
            },
          ),
          _buildDateOption(
            context: context,
            ref: ref,
            label: 'This Month',
            isSelected: dateRange.label == 'This Month',
            onTap: () {
              ref.read(dateRangeProvider.notifier).setThisMonth();
              Navigator.pop(context);
            },
          ),
          _buildDateOption(
            context: context,
            ref: ref,
            label: 'Last Month',
            isSelected: dateRange.label == 'Last Month',
            onTap: () {
              ref.read(dateRangeProvider.notifier).setLastMonth();
              Navigator.pop(context);
            },
          ),
          _buildDateOption(
            context: context,
            ref: ref,
            label: 'This Year',
            isSelected: dateRange.label == 'This Year',
            onTap: () {
              ref.read(dateRangeProvider.notifier).setThisYear();
              Navigator.pop(context);
            },
          ),

          const SizedBox(height: TossSpacing.space4),

          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {
                Navigator.pop(context);
                // TODO: Show custom date picker
              },
              child: const Text('Custom Range'),
            ),
          ),

          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }

  Widget _buildDateOption({
    required BuildContext context,
    required WidgetRef ref,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(TossBorderRadius.md),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: TossSpacing.space3,
          vertical: TossSpacing.space3,
        ),
        decoration: BoxDecoration(
          color: isSelected ? TossColors.primary.withOpacity(0.1) : null,
          borderRadius: BorderRadius.circular(TossBorderRadius.md),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: TossTextStyles.bodyMedium.copyWith(
                  color: isSelected ? TossColors.primary : TossColors.gray900,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check,
                color: TossColors.primary,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }
}
