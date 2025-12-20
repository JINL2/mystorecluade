import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/themes/toss_border_radius.dart';
import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_spacing.dart';
import '../../../../shared/themes/toss_text_styles.dart';
import '../../../../shared/widgets/common/toss_app_bar_1.dart';
import '../../domain/entities/session_history_item.dart';
import '../providers/session_history_provider.dart';
import '../providers/states/session_history_filter_state.dart';
import '../widgets/history/session_history_filter_sheet.dart';

/// Session history page - view past sessions and their results
class SessionHistoryPage extends ConsumerWidget {
  const SessionHistoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(sessionHistoryProvider);
    final filter = state.filter;

    return Scaffold(
      appBar: TossAppBar1(
        title: 'History',
        actions: [
          // Filter button
          Stack(
            children: [
              IconButton(
                onPressed: () => SessionHistoryFilterSheet.show(context),
                icon: const Icon(Icons.filter_list),
                color: filter.hasActiveFilters
                    ? TossColors.primary
                    : TossColors.textSecondary,
              ),
              if (filter.activeFilterCount > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: TossColors.primary,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      '${filter.activeFilterCount}',
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
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Filter summary bar
            _buildFilterSummaryBar(context, ref, filter),
            // Content
            Expanded(
              child: _buildContent(context, ref, state),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterSummaryBar(
    BuildContext context,
    WidgetRef ref,
    SessionHistoryFilterState filter,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: TossSpacing.space4,
        vertical: TossSpacing.space3,
      ),
      decoration: const BoxDecoration(
        color: TossColors.gray50,
        border: Border(
          bottom: BorderSide(color: TossColors.gray100),
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.calendar_today,
            size: 16,
            color: TossColors.textSecondary,
          ),
          const SizedBox(width: TossSpacing.space2),
          Expanded(
            child: Text(
              filter.dateRangeDisplayText,
              style: TossTextStyles.bodySmall.copyWith(
                color: TossColors.textSecondary,
              ),
            ),
          ),
          if (filter.sessionType != null) ...[
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: TossSpacing.space2,
                vertical: TossSpacing.space1,
              ),
              decoration: BoxDecoration(
                color: filter.sessionType == 'counting'
                    ? TossColors.primary.withValues(alpha: 0.1)
                    : TossColors.success.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(TossBorderRadius.sm),
              ),
              child: Text(
                filter.sessionType == 'counting' ? 'Counting' : 'Receiving',
                style: TossTextStyles.caption.copyWith(
                  color: filter.sessionType == 'counting'
                      ? TossColors.primary
                      : TossColors.success,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(width: TossSpacing.space2),
          ],
          if (filter.isActive != null) ...[
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: TossSpacing.space2,
                vertical: TossSpacing.space1,
              ),
              decoration: BoxDecoration(
                color: filter.isActive == true
                    ? TossColors.success.withValues(alpha: 0.1)
                    : TossColors.gray200,
                borderRadius: BorderRadius.circular(TossBorderRadius.sm),
              ),
              child: Text(
                filter.isActive == true ? 'Active' : 'Closed',
                style: TossTextStyles.caption.copyWith(
                  color: filter.isActive == true
                      ? TossColors.success
                      : TossColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    WidgetRef ref,
    SessionHistoryState state,
  ) {
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.hasError) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(TossSpacing.space6),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 64,
                color: TossColors.error,
              ),
              const SizedBox(height: TossSpacing.space4),
              Text(
                'Failed to load sessions',
                style: TossTextStyles.h4.copyWith(
                  color: TossColors.textPrimary,
                ),
              ),
              const SizedBox(height: TossSpacing.space2),
              Text(
                state.error ?? 'Unknown error',
                style: TossTextStyles.body.copyWith(
                  color: TossColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: TossSpacing.space4),
              ElevatedButton(
                onPressed: () => ref.read(sessionHistoryProvider.notifier).refresh(),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (state.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(TossSpacing.space6),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.history,
                size: 64,
                color: TossColors.textTertiary,
              ),
              const SizedBox(height: TossSpacing.space4),
              Text(
                'No sessions found',
                style: TossTextStyles.h4.copyWith(
                  color: TossColors.textPrimary,
                ),
              ),
              const SizedBox(height: TossSpacing.space2),
              Text(
                'Try adjusting your filters or create a new session',
                style: TossTextStyles.body.copyWith(
                  color: TossColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => ref.read(sessionHistoryProvider.notifier).refresh(),
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: TossSpacing.space2),
        itemCount: state.sessions.length + (state.hasMore ? 1 : 0),
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemBuilder: (context, index) {
          // Load more indicator
          if (index == state.sessions.length) {
            // Trigger load more when reaching the end
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ref.read(sessionHistoryProvider.notifier).loadMore();
            });
            return _buildLoadMoreIndicator(state.isLoadingMore);
          }
          final session = state.sessions[index];
          return _SessionHistoryCard(session: session);
        },
      ),
    );
  }

  Widget _buildLoadMoreIndicator(bool isLoading) {
    return Container(
      padding: const EdgeInsets.all(TossSpacing.space4),
      alignment: Alignment.center,
      child: isLoading
          ? const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : Text(
              'Load more...',
              style: TossTextStyles.bodySmall.copyWith(
                color: TossColors.textTertiary,
              ),
            ),
    );
  }
}

/// Session history card widget
class _SessionHistoryCard extends StatelessWidget {
  final SessionHistoryItem session;

  const _SessionHistoryCard({required this.session});

  @override
  Widget build(BuildContext context) {
    final isCounting = session.sessionType == 'counting';
    final typeColor = isCounting ? TossColors.primary : TossColors.success;

    return InkWell(
      onTap: () {
        context.pushNamed('session-history-detail', extra: session);
      },
      child: Padding(
        padding: const EdgeInsets.all(TossSpacing.space4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Type indicator with merge/new badge
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: typeColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(TossBorderRadius.md),
                  ),
                  child: Icon(
                    isCounting ? Icons.inventory_2_outlined : Icons.local_shipping_outlined,
                    color: typeColor,
                    size: 24,
                  ),
                ),
                // Merge badge (top-right)
                if (session.isMergedSession)
                  Positioned(
                    top: -4,
                    right: -4,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: TossColors.info,
                        shape: BoxShape.circle,
                        border: Border.all(color: TossColors.white, width: 1.5),
                      ),
                      child: const Icon(
                        Icons.merge_type,
                        size: 10,
                        color: TossColors.white,
                      ),
                    ),
                  ),
                // New products badge (bottom-right) - receiving only
                if (session.isReceiving && session.newProductsCount > 0)
                  Positioned(
                    bottom: -4,
                    right: -4,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                      decoration: BoxDecoration(
                        color: TossColors.warning,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: TossColors.white, width: 1.5),
                      ),
                      child: Text(
                        'NEW ${session.newProductsCount}',
                        style: TossTextStyles.caption.copyWith(
                          color: TossColors.white,
                          fontSize: 8,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: TossSpacing.space3),
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Session name and status
                  Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Flexible(
                              child: Text(
                                session.sessionName,
                                style: TossTextStyles.body.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: TossColors.textPrimary,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            // Inline merge indicator
                            if (session.isMergedSession) ...[
                              const SizedBox(width: TossSpacing.space1),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                  vertical: 1,
                                ),
                                decoration: BoxDecoration(
                                  color: TossColors.info.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.merge_type,
                                      size: 10,
                                      color: TossColors.info,
                                    ),
                                    const SizedBox(width: 2),
                                    Text(
                                      'Merged',
                                      style: TossTextStyles.caption.copyWith(
                                        color: TossColors.info,
                                        fontSize: 9,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(width: TossSpacing.space2),
                      _buildStatusBadge(),
                    ],
                  ),
                  const SizedBox(height: TossSpacing.space1),
                  // Store name
                  Row(
                    children: [
                      const Icon(
                        Icons.store_outlined,
                        size: 14,
                        color: TossColors.textTertiary,
                      ),
                      const SizedBox(width: TossSpacing.space1),
                      Expanded(
                        child: Text(
                          session.storeName,
                          style: TossTextStyles.bodySmall.copyWith(
                            color: TossColors.textSecondary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: TossSpacing.space1),
                  // Meta info
                  Row(
                    children: [
                      // Created by
                      const Icon(
                        Icons.person_outline,
                        size: 14,
                        color: TossColors.textTertiary,
                      ),
                      const SizedBox(width: TossSpacing.space1),
                      Text(
                        session.createdByName,
                        style: TossTextStyles.caption.copyWith(
                          color: TossColors.textTertiary,
                        ),
                      ),
                      const SizedBox(width: TossSpacing.space3),
                      // Member count
                      const Icon(
                        Icons.group_outlined,
                        size: 14,
                        color: TossColors.textTertiary,
                      ),
                      const SizedBox(width: TossSpacing.space1),
                      Text(
                        '${session.memberCount}',
                        style: TossTextStyles.caption.copyWith(
                          color: TossColors.textTertiary,
                        ),
                      ),
                      // New/Restock info for receiving sessions
                      if (session.hasReceivingInfo) ...[
                        const SizedBox(width: TossSpacing.space3),
                        if (session.newProductsCount > 0)
                          _buildReceivingBadge(
                            icon: Icons.fiber_new,
                            count: session.newProductsCount,
                            color: TossColors.warning,
                          ),
                        if (session.restockProductsCount > 0) ...[
                          const SizedBox(width: TossSpacing.space2),
                          _buildReceivingBadge(
                            icon: Icons.replay,
                            count: session.restockProductsCount,
                            color: TossColors.success,
                          ),
                        ],
                      ],
                      const Spacer(),
                      // Date
                      Text(
                        _formatDate(session.createdAt),
                        style: TossTextStyles.caption.copyWith(
                          color: TossColors.textTertiary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Chevron
            const SizedBox(width: TossSpacing.space2),
            const Icon(
              Icons.chevron_right,
              color: TossColors.textTertiary,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReceivingBadge({
    required IconData icon,
    required int count,
    required Color color,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 12, color: color),
        const SizedBox(width: 2),
        Text(
          '$count',
          style: TossTextStyles.caption.copyWith(
            color: color,
            fontWeight: FontWeight.w600,
            fontSize: 11,
          ),
        ),
      ],
    );
  }

  Widget _buildStatusBadge() {
    final isActive = session.isActive;
    final isFinal = session.isFinal;

    Color bgColor;
    Color textColor;
    String label;

    if (isFinal) {
      bgColor = TossColors.success.withValues(alpha: 0.1);
      textColor = TossColors.success;
      label = 'Finalized';
    } else if (isActive) {
      bgColor = TossColors.warning.withValues(alpha: 0.1);
      textColor = TossColors.warning;
      label = 'Active';
    } else {
      bgColor = TossColors.gray200;
      textColor = TossColors.textSecondary;
      label = 'Closed';
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: TossSpacing.space2,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(TossBorderRadius.sm),
      ),
      child: Text(
        label,
        style: TossTextStyles.caption.copyWith(
          color: textColor,
          fontWeight: FontWeight.w500,
          fontSize: 10,
        ),
      ),
    );
  }

  String _formatDate(String dateString) {
    final date = DateTime.tryParse(dateString);
    if (date == null) return dateString;

    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inDays == 0) {
      return 'Today';
    } else if (diff.inDays == 1) {
      return 'Yesterday';
    } else if (diff.inDays < 7) {
      return '${diff.inDays} days ago';
    } else {
      return '${date.month}/${date.day}/${date.year}';
    }
  }
}
