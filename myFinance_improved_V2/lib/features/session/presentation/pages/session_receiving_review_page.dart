import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/themes/toss_border_radius.dart';
import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_spacing.dart';
import '../../../../shared/themes/toss_text_styles.dart';
import '../providers/session_review_provider.dart';
import '../providers/states/session_review_state.dart';
import '../widgets/receiving_review/receiving_empty_view.dart';
import '../widgets/receiving_review/receiving_error_view.dart';
import '../widgets/receiving_review/receiving_filter_chip.dart';
import '../widgets/receiving_review/receiving_item_row.dart';
import '../widgets/receiving_review/receiving_submit_dialog.dart';
import '../widgets/receiving_review/receiving_summary_item.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

/// Filter types for receiving review items
enum ReceivingFilter {
  all,
  overReceived,
  underReceived,
  mismatchAccepted,
  fullyMatched,
  rejected,
}

/// Session Receiving Review Page
/// Design matches "Review Stock In vs Order" mockup with table format
class SessionReceivingReviewPage extends ConsumerStatefulWidget {
  final String sessionId;
  final String sessionType;
  final String? sessionName;
  final String storeId;

  const SessionReceivingReviewPage({
    super.key,
    required this.sessionId,
    required this.sessionType,
    this.sessionName,
    required this.storeId,
  });

  @override
  ConsumerState<SessionReceivingReviewPage> createState() =>
      _SessionReceivingReviewPageState();
}

class _SessionReceivingReviewPageState
    extends ConsumerState<SessionReceivingReviewPage> {
  final TextEditingController _searchController = TextEditingController();
  ReceivingFilter _activeFilter = ReceivingFilter.all;

  SessionReviewParams get _params => (
        sessionId: widget.sessionId,
        sessionType: widget.sessionType,
        sessionName: widget.sessionName,
        storeId: widget.storeId,
      );

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
        onPressed: () => context.pop(),
      ),
      title: Text(
        'Review Stock In vs Order',
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
      return ReceivingErrorView(
        error: state.error ?? 'Unknown error',
        onRetry: () {
          ref.read(sessionReviewNotifierProvider(_params).notifier).refresh();
        },
      );
    }

    if (!state.hasItems) {
      return const ReceivingEmptyView();
    }

    return Column(
      children: [
        _buildSearchBar(state),
        _buildFilterTabs(),
        _buildSummaryStats(state),
        _buildTableHeader(),
        Expanded(
          child: RefreshIndicator(
            onRefresh: () async {
              await ref.read(sessionReviewNotifierProvider(_params).notifier).refresh();
            },
            child: ListView.builder(
              padding: const EdgeInsets.only(bottom: TossSpacing.space2),
              itemCount: _getFilteredItems(state).length,
              itemBuilder: (context, index) {
                final item = _getFilteredItems(state)[index];
                return ReceivingItemRow(item: item, params: _params);
              },
            ),
          ),
        ),
        _buildBottomButton(state),
      ],
    );
  }

  List<SessionReviewItem> _getFilteredItems(SessionReviewState state) {
    var items = state.items;

    if (_searchController.text.isNotEmpty) {
      final query = _searchController.text.toLowerCase();
      items = items.where((item) {
        return item.productName.toLowerCase().contains(query) ||
            (item.sku?.toLowerCase().contains(query) ?? false);
      }).toList();
    }

    switch (_activeFilter) {
      case ReceivingFilter.all:
        return items;
      case ReceivingFilter.overReceived:
        return items.where((item) => item.netQuantity > item.previousStock).toList();
      case ReceivingFilter.underReceived:
        return items.where((item) => item.netQuantity < item.previousStock && item.totalRejected == 0).toList();
      case ReceivingFilter.mismatchAccepted:
        return items.where((item) => item.netQuantity != item.previousStock && item.netQuantity > 0).toList();
      case ReceivingFilter.fullyMatched:
        return items.where((item) => item.netQuantity == item.previousStock && item.totalRejected == 0).toList();
      case ReceivingFilter.rejected:
        return items.where((item) => item.totalRejected > 0).toList();
    }
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
        onChanged: (value) => setState(() {}),
        decoration: InputDecoration(
          hintText: 'Search by product name or SKU...',
          hintStyle: TossTextStyles.body.copyWith(color: TossColors.textTertiary),
          prefixIcon: const Icon(Icons.search, color: TossColors.textTertiary, size: 20),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.close, color: TossColors.textTertiary, size: 20),
                  onPressed: () {
                    _searchController.clear();
                    setState(() {});
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

  Widget _buildFilterTabs() {
    return Container(
      color: TossColors.white,
      padding: const EdgeInsets.symmetric(
        horizontal: TossSpacing.space4,
        vertical: TossSpacing.space2,
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            ReceivingFilterChip(
              label: 'All',
              isActive: _activeFilter == ReceivingFilter.all,
              onTap: () => setState(() => _activeFilter = ReceivingFilter.all),
            ),
            ReceivingFilterChip(
              label: 'Over Received',
              isActive: _activeFilter == ReceivingFilter.overReceived,
              color: TossColors.primary,
              onTap: () => setState(() => _activeFilter = ReceivingFilter.overReceived),
            ),
            ReceivingFilterChip(
              label: 'Under Received',
              isActive: _activeFilter == ReceivingFilter.underReceived,
              color: TossColors.loss,
              onTap: () => setState(() => _activeFilter = ReceivingFilter.underReceived),
            ),
            ReceivingFilterChip(
              label: 'Mismatch (Accepted)',
              isActive: _activeFilter == ReceivingFilter.mismatchAccepted,
              color: TossColors.warning,
              onTap: () => setState(() => _activeFilter = ReceivingFilter.mismatchAccepted),
            ),
            ReceivingFilterChip(
              label: 'Fully Matched',
              isActive: _activeFilter == ReceivingFilter.fullyMatched,
              color: TossColors.success,
              onTap: () => setState(() => _activeFilter = ReceivingFilter.fullyMatched),
            ),
            ReceivingFilterChip(
              label: 'Rejected',
              isActive: _activeFilter == ReceivingFilter.rejected,
              color: TossColors.error,
              onTap: () => setState(() => _activeFilter = ReceivingFilter.rejected),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryStats(SessionReviewState state) {
    int totalShipped = 0;
    int totalReceived = 0;
    int totalAccepted = 0;
    int totalRejected = 0;
    bool hasEdits = state.hasEdits;

    for (final item in state.items) {
      totalShipped += item.previousStock;
      final effectiveQty = state.getEffectiveQuantity(item.productId, item.totalQuantity);
      totalReceived += effectiveQty;
      totalAccepted += effectiveQty - item.totalRejected;
      totalRejected += item.totalRejected;
    }

    final remaining = totalShipped - totalAccepted;

    return Container(
      color: TossColors.white,
      padding: const EdgeInsets.symmetric(
        horizontal: TossSpacing.space4,
        vertical: TossSpacing.space4,
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            ReceivingSummaryItem(label: 'Total Shipped', value: '$totalShipped'),
            _buildVerticalDivider(),
            ReceivingSummaryItem(
              label: hasEdits ? 'Received*' : 'Received',
              value: '$totalReceived',
              color: TossColors.primary,
            ),
            _buildVerticalDivider(),
            ReceivingSummaryItem(
              label: hasEdits ? 'Accepted*' : 'Accepted',
              value: '$totalAccepted',
              color: TossColors.success,
            ),
            _buildVerticalDivider(),
            ReceivingSummaryItem(label: 'Rejected', value: '$totalRejected', color: TossColors.loss),
            _buildVerticalDivider(),
            ReceivingSummaryItem(
              label: 'Remaining',
              value: '$remaining',
              color: remaining > 0 ? TossColors.warning : TossColors.textSecondary,
            ),
            if (hasEdits) ...[
              _buildVerticalDivider(),
              const Icon(Icons.edit, size: 14, color: TossColors.primary),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildVerticalDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space4),
      child: Container(width: 1, height: 32, color: TossColors.gray200),
    );
  }

  Widget _buildTableHeader() {
    return Container(
      color: TossColors.gray50,
      padding: const EdgeInsets.symmetric(
        horizontal: TossSpacing.space4,
        vertical: TossSpacing.space3,
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              'Product',
              style: TossTextStyles.bodySmall.copyWith(color: TossColors.textSecondary, fontWeight: FontWeight.w500),
            ),
          ),
          _buildHeaderCell('Shipped'),
          _buildHeaderCell('Received'),
          _buildHeaderCell('Accepted'),
          _buildHeaderCell('Rejected'),
          const SizedBox(width: 40),
        ],
      ),
    );
  }

  Widget _buildHeaderCell(String text) {
    return SizedBox(
      width: 52,
      child: Text(
        text,
        style: TossTextStyles.labelSmall.copyWith(color: TossColors.textSecondary, fontWeight: FontWeight.w500),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildBottomButton(SessionReviewState state) {
    return Container(
      padding: const EdgeInsets.all(TossSpacing.space4),
      decoration: const BoxDecoration(
        color: TossColors.white,
        boxShadow: [BoxShadow(color: TossColors.shadow, blurRadius: 8, offset: Offset(0, -2))],
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
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(TossBorderRadius.lg)),
              elevation: 0,
            ),
            child: state.isSubmitting
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2, color: TossColors.white),
                  )
                : Text(
                    'Submit',
                    style: TossTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600, color: TossColors.white),
                  ),
          ),
        ),
      ),
    );
  }

  void _showConfirmDialog() {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => ReceivingSubmitDialog(
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

    if (result.success && result.data != null) {
      context.go('/session/receiving-result', extra: result.data);
    } else if (result.success) {
      showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => TossDialog.success(
          title: 'Session Finalized',
          message: 'Receiving created successfully.',
          primaryButtonText: 'OK',
          onPrimaryPressed: () {
            Navigator.of(ctx).pop();
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
