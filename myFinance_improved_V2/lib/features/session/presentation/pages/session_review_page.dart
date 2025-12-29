import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/themes/toss_border_radius.dart';
import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_spacing.dart';
import '../../../../shared/themes/toss_text_styles.dart';
import '../../../../shared/widgets/common/toss_success_error_dialog.dart';
import '../providers/session_review_provider.dart';
import '../providers/states/session_review_state.dart';
import '../widgets/session_review/review_empty_view.dart';
import '../widgets/session_review/review_error_view.dart';
import '../widgets/session_review/review_filter_tab.dart';
import '../widgets/session_review/review_item_card.dart';
import '../widgets/session_review/review_submit_dialog.dart';

/// Session review page - Review counted items before final submission
/// Design matches BoxHero's "Review Inventory Changes" page
class SessionReviewPage extends ConsumerStatefulWidget {
  final String sessionId;
  final String sessionType;
  final String? sessionName;
  final String storeId;

  const SessionReviewPage({
    super.key,
    required this.sessionId,
    required this.sessionType,
    this.sessionName,
    required this.storeId,
  });

  @override
  ConsumerState<SessionReviewPage> createState() => _SessionReviewPageState();
}

class _SessionReviewPageState extends ConsumerState<SessionReviewPage> {
  final TextEditingController _searchController = TextEditingController();

  SessionReviewParams get _params => (
        sessionId: widget.sessionId,
        sessionType: widget.sessionType,
        sessionName: widget.sessionName,
        storeId: widget.storeId,
      );

  bool get _isCounting => widget.sessionType == 'counting';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(sessionReviewNotifierProvider(_params));

    return Scaffold(
      backgroundColor: TossColors.gray50,
      appBar: _buildAppBar(),
      body: _buildBody(state),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: TossColors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: TossColors.textPrimary),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: Text(
        'Review Inventory Changes',
        style: TossTextStyles.h4.copyWith(
          color: TossColors.textPrimary,
          fontWeight: FontWeight.w600,
        ),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh, color: TossColors.textSecondary),
          onPressed: () {
            ref.read(sessionReviewNotifierProvider(_params).notifier).refresh();
          },
        ),
      ],
    );
  }

  Widget _buildBody(SessionReviewState state) {
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.hasError) {
      return ReviewErrorView(
        error: state.error ?? 'Unknown error',
        onRetry: () {
          ref.read(sessionReviewNotifierProvider(_params).notifier).refresh();
        },
      );
    }

    if (!state.hasItems) {
      return ReviewEmptyView(sessionType: widget.sessionType);
    }

    return Column(
      children: [
        // Search Bar
        _buildSearchBar(state),

        // Filter Tabs
        _buildFilterTabs(state),

        // Summary Stats
        _buildSummaryStats(state),

        // Items List
        Expanded(
          child: RefreshIndicator(
            onRefresh: () async {
              await ref.read(sessionReviewNotifierProvider(_params).notifier).refresh();
            },
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: TossSpacing.space2),
              itemCount: state.filteredItems.length,
              itemBuilder: (context, index) {
                final item = state.filteredItems[index];
                return ReviewItemCard(item: item, params: _params);
              },
            ),
          ),
        ),

        // Bottom Submit Button
        _buildBottomButton(state),
      ],
    );
  }

  Widget _buildSearchBar(SessionReviewState state) {
    return Container(
      color: TossColors.white,
      padding: const EdgeInsets.fromLTRB(
        TossSpacing.space4,
        TossSpacing.space2,
        TossSpacing.space4,
        TossSpacing.space3,
      ),
      child: TextField(
        controller: _searchController,
        onChanged: (value) {
          ref.read(sessionReviewNotifierProvider(_params).notifier).setSearchQuery(value);
        },
        decoration: InputDecoration(
          hintText: 'You can search by name, product code, product type,...',
          hintStyle: TossTextStyles.body.copyWith(
            color: TossColors.textTertiary,
          ),
          prefixIcon: const Icon(
            Icons.search,
            color: TossColors.textTertiary,
            size: 20,
          ),
          suffixIcon: state.searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(
                    Icons.close,
                    color: TossColors.textTertiary,
                    size: 20,
                  ),
                  onPressed: () {
                    _searchController.clear();
                    ref.read(sessionReviewNotifierProvider(_params).notifier).clearSearch();
                  },
                )
              : null,
          filled: true,
          fillColor: TossColors.gray100,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: TossSpacing.space4,
            vertical: TossSpacing.space3,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(TossBorderRadius.lg),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(TossBorderRadius.lg),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(TossBorderRadius.lg),
            borderSide: const BorderSide(color: TossColors.primary, width: 1.5),
          ),
        ),
      ),
    );
  }

  Widget _buildFilterTabs(SessionReviewState state) {
    return Container(
      color: TossColors.white,
      padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space4),
      child: Row(
        children: [
          ReviewFilterTab(
            label: 'All',
            isActive: state.activeFilter == ReviewFilter.all,
            onTap: () {
              ref.read(sessionReviewNotifierProvider(_params).notifier).setFilter(ReviewFilter.all);
            },
          ),
          ReviewFilterTab(
            label: 'Increased',
            isActive: state.activeFilter == ReviewFilter.increased,
            color: TossColors.success,
            onTap: () {
              ref.read(sessionReviewNotifierProvider(_params).notifier).setFilter(ReviewFilter.increased);
            },
          ),
          ReviewFilterTab(
            label: 'Decreased',
            isActive: state.activeFilter == ReviewFilter.decreased,
            color: TossColors.loss,
            onTap: () {
              ref.read(sessionReviewNotifierProvider(_params).notifier).setFilter(ReviewFilter.decreased);
            },
          ),
          ReviewFilterTab(
            label: 'Unchanged',
            isActive: state.activeFilter == ReviewFilter.unchanged,
            onTap: () {
              ref.read(sessionReviewNotifierProvider(_params).notifier).setFilter(ReviewFilter.unchanged);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryStats(SessionReviewState state) {
    final summary = state.summary;
    if (summary == null) return const SizedBox.shrink();

    return Container(
      color: TossColors.white,
      padding: const EdgeInsets.symmetric(
        horizontal: TossSpacing.space4,
        vertical: TossSpacing.space3,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            'Items Counted: ',
            style: TossTextStyles.caption.copyWith(
              color: TossColors.textSecondary,
            ),
          ),
          Text(
            '${summary.totalProducts}',
            style: TossTextStyles.caption.copyWith(
              color: TossColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          _buildDivider(),
          Text(
            'Total Quantity: ',
            style: TossTextStyles.caption.copyWith(
              color: TossColors.textSecondary,
            ),
          ),
          Text(
            '${summary.totalQuantity}',
            style: TossTextStyles.caption.copyWith(
              color: TossColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          _buildDivider(),
          Text(
            'Items Changed: ',
            style: TossTextStyles.caption.copyWith(
              color: TossColors.textSecondary,
            ),
          ),
          Text(
            '${state.itemsChangedCount}',
            style: TossTextStyles.caption.copyWith(
              color: TossColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space2),
      child: Text(
        '|',
        style: TossTextStyles.caption.copyWith(
          color: TossColors.gray300,
        ),
      ),
    );
  }

  Widget _buildBottomButton(SessionReviewState state) {
    return Container(
      padding: const EdgeInsets.all(TossSpacing.space4),
      decoration: const BoxDecoration(
        color: TossColors.white,
        boxShadow: [
          BoxShadow(
            color: TossColors.shadow,
            blurRadius: 8,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: state.isSubmitting ? null : _showConfirmDialog,
            style: ElevatedButton.styleFrom(
              backgroundColor: TossColors.primary,
              foregroundColor: TossColors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(TossBorderRadius.lg),
              ),
              elevation: 0,
            ),
            child: state.isSubmitting
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: TossColors.white,
                    ),
                  )
                : Text(
                    'Submit',
                    style: TossTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                      color: TossColors.white,
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  void _showConfirmDialog() {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => ReviewSubmitDialog(
        isCounting: _isCounting,
        onSubmit: (isFinal) {
          Navigator.pop(dialogContext);
          _executeSubmit(isFinal);
        },
      ),
    );
  }

  Future<void> _executeSubmit(bool isFinal) async {
    final result = await ref
        .read(sessionReviewNotifierProvider(_params).notifier)
        .submitSession(isFinal: isFinal);

    if (!mounted) return;

    if (result.success) {
      showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => TossDialog.success(
          title: 'Session Finalized',
          message:
              'Receiving #${result.data?.receivingNumber ?? ''} created successfully.\n'
              '${result.data?.itemsCount ?? 0} items, ${result.data?.totalQuantity ?? 0} total quantity.',
          primaryButtonText: 'OK',
          onPrimaryPressed: () {
            Navigator.of(ctx).pop();
            // Navigate back to session entry point
            context.go('/session');
          },
        ),
      );
    } else {
      showDialog<void>(
        context: context,
        builder: (ctx) => TossDialog.error(
          title: 'Submit Failed',
          message: result.error ?? 'Failed to submit session',
          primaryButtonText: 'OK',
          onPrimaryPressed: () => Navigator.of(ctx).pop(),
        ),
      );
    }
  }
}
