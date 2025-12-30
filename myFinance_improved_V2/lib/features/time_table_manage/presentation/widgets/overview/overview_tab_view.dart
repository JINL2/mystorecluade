import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';
import '../../../../../shared/widgets/common/toss_error_view.dart';
import '../../../../../shared/widgets/common/toss_loading_view.dart';
import '../../providers/time_table_providers.dart';

/// Overview Tab View
///
/// Displays statistical overview and summary information.
class OverviewTabView extends ConsumerStatefulWidget {
  final String storeId;

  const OverviewTabView({
    super.key,
    required this.storeId,
  });

  @override
  ConsumerState<OverviewTabView> createState() => _OverviewTabViewState();
}

class _OverviewTabViewState extends ConsumerState<OverviewTabView> {
  @override
  void initState() {
    super.initState();
    // Load initial data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  void _loadData() {
    final selectedDate = ref.read(selectedDateProvider);
    ref
        .read(managerOverviewProvider(widget.storeId).notifier)
        .loadMonth(month: selectedDate);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(managerOverviewProvider(widget.storeId));
    final selectedDate = ref.watch(selectedDateProvider);

    // Get data for selected month
    final monthKey = '${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}';
    final overview = state.dataByMonth[monthKey];

    if (state.isLoading) {
      return const TossLoadingView();
    }

    if (state.error != null) {
      return TossErrorView(
        error: state.error!,
        title: 'Failed to Load Data',
        onRetry: _loadData,
      );
    }

    if (overview == null) {
      return Center(
        child: Text(
          'No data available',
          style: TossTextStyles.body.copyWith(
            color: TossColors.gray500,
          ),
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(TossSpacing.space4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${overview.month.split('-')[0]}년 ${overview.month.split('-')[1]}월',
                style: TossTextStyles.h2.copyWith(
                  color: TossColors.gray900,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Monthly Overview',
                style: TossTextStyles.bodySmall.copyWith(
                  color: TossColors.gray500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Statistics Grid
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            childAspectRatio: 1.45,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            children: [
              // Total Request
              _buildStatCard(
                icon: Icons.calendar_today,
                iconColor: TossColors.primary,
                backgroundColor: TossColors.background,
                title: 'Total Request',
                value: overview.totalShifts.toString(),
                subtitle: 'requests',
              ),

              // Problem
              _buildStatCard(
                icon: Icons.warning_amber_rounded,
                iconColor: TossColors.error,
                backgroundColor: TossColors.errorLight,
                title: 'Problem',
                value: overview.totalProblems.toString(),
                subtitle: 'issues',
              ),

              // Total Approve
              _buildStatCard(
                icon: Icons.check_circle,
                iconColor: TossColors.success,
                backgroundColor: TossColors.successLight,
                title: 'Total Approve',
                value: overview.totalApprovedRequests.toString(),
                subtitle: 'approved',
              ),

              // Pending
              _buildStatCard(
                icon: Icons.access_time,
                iconColor: TossColors.warning,
                backgroundColor: TossColors.warningLight,
                title: 'Pending',
                value: overview.totalPendingRequests.toString(),
                subtitle: 'pending',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required Color iconColor,
    required Color backgroundColor,
    required String title,
    required String value,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(TossSpacing.space4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        border: backgroundColor == TossColors.background
            ? Border.all(color: TossColors.gray200)
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Icon and title
          Row(
            children: [
              Icon(
                icon,
                size: 18,
                color: iconColor,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: TossTextStyles.bodySmall.copyWith(
                    color: TossColors.gray600,
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),

          // Value and subtitle
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Flexible(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    value,
                    style: TossTextStyles.h1.copyWith(
                      color: TossColors.gray900,
                      fontWeight: FontWeight.w700,
                      fontSize: 28,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 4),
              Padding(
                padding: const EdgeInsets.only(bottom: TossSpacing.space1 / 2),
                child: Text(
                  subtitle,
                  style: TossTextStyles.bodySmall.copyWith(
                    color: TossColors.gray500,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
