import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/themes/toss_border_radius.dart';
import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_font_weight.dart';
import '../../../../shared/themes/toss_spacing.dart';
import '../../../../shared/themes/toss_text_styles.dart';
import '../providers/session_history_provider.dart';
import '../providers/states/session_history_filter_state.dart';
import '../providers/states/session_history_state.dart';
import '../widgets/history/session_history_card.dart';
import '../widgets/history/session_history_filter_sheet.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

/// Session history page - view past sessions and their results
class SessionHistoryPage extends ConsumerWidget {
  const SessionHistoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(sessionHistoryNotifierProvider);
    final filter = state.filter;

    return Scaffold(
      appBar: TossAppBar(
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
                    padding: const EdgeInsets.all(TossSpacing.space1),
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
                      style: TossTextStyles.micro.copyWith(
                        color: TossColors.white,
                        fontWeight: TossFontWeight.semibold,
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
            size: TossSpacing.iconSM2,
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
                  fontWeight: TossFontWeight.medium,
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
                  fontWeight: TossFontWeight.medium,
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
      return const TossLoadingView();
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
                size: TossSpacing.icon4XL,
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
              TossButton.primary(
                text: 'Retry',
                onPressed: () => ref.read(sessionHistoryNotifierProvider.notifier).refresh(),
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
                size: TossSpacing.icon4XL,
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
      onRefresh: () => ref.read(sessionHistoryNotifierProvider.notifier).refresh(),
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: TossSpacing.space2),
        itemCount: state.sessions.length + (state.hasMore ? 1 : 0),
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemBuilder: (context, index) {
          // Load more indicator
          if (index == state.sessions.length) {
            // Trigger load more when reaching the end
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ref.read(sessionHistoryNotifierProvider.notifier).loadMore();
            });
            return _buildLoadMoreIndicator(state.isLoadingMore);
          }
          final session = state.sessions[index];
          return SessionHistoryCard(session: session);
        },
      ),
    );
  }

  Widget _buildLoadMoreIndicator(bool isLoading) {
    return Container(
      padding: const EdgeInsets.all(TossSpacing.space4),
      alignment: Alignment.center,
      child: isLoading
          ? TossLoadingView.inline(size: 24)
          : Text(
              'Load more...',
              style: TossTextStyles.bodySmall.copyWith(
                color: TossColors.textTertiary,
              ),
            ),
    );
  }
}
