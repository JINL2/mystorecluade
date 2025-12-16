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
    final state = ref.watch(sessionReviewProvider(_params));

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
            ref.read(sessionReviewProvider(_params).notifier).refresh();
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
      return _ErrorView(
        error: state.error ?? 'Unknown error',
        onRetry: () {
          ref.read(sessionReviewProvider(_params).notifier).refresh();
        },
      );
    }

    if (!state.hasItems) {
      return const _EmptyView();
    }

    return Column(
      children: [
        // Search Bar
        _buildSearchBar(state),

        // Filter Tabs (scrollable)
        _buildFilterTabs(),

        // Summary Stats
        _buildSummaryStats(state),

        // Table Header
        _buildTableHeader(),

        // Items List (table rows)
        Expanded(
          child: RefreshIndicator(
            onRefresh: () async {
              await ref.read(sessionReviewProvider(_params).notifier).refresh();
            },
            child: ListView.builder(
              padding: const EdgeInsets.only(bottom: TossSpacing.space2),
              itemCount: _getFilteredItems(state).length,
              itemBuilder: (context, index) {
                final item = _getFilteredItems(state)[index];
                return _ReceivingItemRow(item: item, params: _params);
              },
            ),
          ),
        ),

        // Bottom Submit Button
        _buildBottomButton(state),
      ],
    );
  }

  /// Get filtered items based on receiving filter
  List<SessionReviewItem> _getFilteredItems(SessionReviewState state) {
    var items = state.items;

    // Apply search filter first
    if (_searchController.text.isNotEmpty) {
      final query = _searchController.text.toLowerCase();
      items = items.where((item) {
        return item.productName.toLowerCase().contains(query) ||
            (item.sku?.toLowerCase().contains(query) ?? false);
      }).toList();
    }

    // Apply receiving filter
    switch (_activeFilter) {
      case ReceivingFilter.all:
        return items;
      case ReceivingFilter.overReceived:
        // Received more than shipped (netQuantity > previousStock means over)
        // In receiving context: previousStock is shipped quantity
        return items.where((item) => item.netQuantity > item.previousStock).toList();
      case ReceivingFilter.underReceived:
        // Received less than shipped
        return items.where((item) => item.netQuantity < item.previousStock && item.totalRejected == 0).toList();
      case ReceivingFilter.mismatchAccepted:
        // Has accepted items but quantity differs
        return items.where((item) => item.netQuantity != item.previousStock && item.netQuantity > 0).toList();
      case ReceivingFilter.fullyMatched:
        // Received exactly what was shipped
        return items.where((item) => item.netQuantity == item.previousStock && item.totalRejected == 0).toList();
      case ReceivingFilter.rejected:
        // Has rejected items
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
        onChanged: (value) {
          setState(() {});
        },
        decoration: InputDecoration(
          hintText: 'Search by product name or SKU...',
          hintStyle: TossTextStyles.body.copyWith(
            color: TossColors.textTertiary,
          ),
          prefixIcon: const Icon(
            Icons.search,
            color: TossColors.textTertiary,
            size: 20,
          ),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(
                    Icons.close,
                    color: TossColors.textTertiary,
                    size: 20,
                  ),
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
            _FilterChip(
              label: 'All',
              isActive: _activeFilter == ReceivingFilter.all,
              onTap: () => setState(() => _activeFilter = ReceivingFilter.all),
            ),
            _FilterChip(
              label: 'Over Received',
              isActive: _activeFilter == ReceivingFilter.overReceived,
              color: TossColors.primary,
              onTap: () => setState(() => _activeFilter = ReceivingFilter.overReceived),
            ),
            _FilterChip(
              label: 'Under Received',
              isActive: _activeFilter == ReceivingFilter.underReceived,
              color: TossColors.loss,
              onTap: () => setState(() => _activeFilter = ReceivingFilter.underReceived),
            ),
            _FilterChip(
              label: 'Mismatch (Accepted)',
              isActive: _activeFilter == ReceivingFilter.mismatchAccepted,
              color: TossColors.warning,
              onTap: () => setState(() => _activeFilter = ReceivingFilter.mismatchAccepted),
            ),
            _FilterChip(
              label: 'Fully Matched',
              isActive: _activeFilter == ReceivingFilter.fullyMatched,
              color: TossColors.success,
              onTap: () => setState(() => _activeFilter = ReceivingFilter.fullyMatched),
            ),
            _FilterChip(
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
    // Calculate summary stats using effective (edited) quantities
    int totalShipped = 0;
    int totalReceived = 0;
    int totalAccepted = 0;
    int totalRejected = 0;
    bool hasEdits = state.hasEdits;

    for (final item in state.items) {
      totalShipped += item.previousStock; // In receiving, previousStock = shipped qty
      // Use effective quantity (edited value if exists)
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
            _SummaryItem(label: 'Total Shipped', value: '$totalShipped'),
            _buildVerticalDivider(),
            _SummaryItem(
              label: hasEdits ? 'Received*' : 'Received',
              value: '$totalReceived',
              color: TossColors.primary,
            ),
            _buildVerticalDivider(),
            _SummaryItem(
              label: hasEdits ? 'Accepted*' : 'Accepted',
              value: '$totalAccepted',
              color: TossColors.success,
            ),
            _buildVerticalDivider(),
            _SummaryItem(label: 'Rejected', value: '$totalRejected', color: TossColors.loss),
            _buildVerticalDivider(),
            _SummaryItem(
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
      child: Container(
        width: 1,
        height: 32,
        color: TossColors.gray200,
      ),
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
          // Product column (expanded)
          const Expanded(
            flex: 2,
            child: Text(
              'Product',
              style: TextStyle(
                fontSize: 13,
                color: TossColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          // Number columns - fixed width each
          _buildHeaderCell('Shipped'),
          _buildHeaderCell('Received'),
          _buildHeaderCell('Accepted'),
          _buildHeaderCell('Rejected'),
          // Edit column
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
        style: const TextStyle(
          fontSize: 10,
          color: TossColors.textSecondary,
          fontWeight: FontWeight.w500,
        ),
        textAlign: TextAlign.center,
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
      builder: (dialogContext) => _SubmitConfirmDialog(
        onSubmit: (isFinal) {
          Navigator.pop(dialogContext);
          _executeSubmit(isFinal);
        },
      ),
    );
  }

  Future<void> _executeSubmit(bool isFinal) async {
    final result = await ref
        .read(sessionReviewProvider(_params).notifier)
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

/// Summary item widget
class _SummaryItem extends StatelessWidget {
  final String label;
  final String value;
  final Color? color;

  const _SummaryItem({
    required this.label,
    required this.value,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: TossTextStyles.small.copyWith(
            color: TossColors.textTertiary,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TossTextStyles.bodyMedium.copyWith(
            color: color ?? TossColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

/// Filter chip widget
class _FilterChip extends StatelessWidget {
  final String label;
  final bool isActive;
  final Color? color;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isActive,
    this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final activeColor = color ?? TossColors.primary;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: TossSpacing.space3,
          vertical: TossSpacing.space2,
        ),
        margin: const EdgeInsets.only(right: TossSpacing.space2),
        decoration: BoxDecoration(
          color: isActive ? activeColor.withValues(alpha: 0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(TossBorderRadius.full),
          border: Border.all(
            color: isActive ? activeColor : TossColors.gray200,
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: TossTextStyles.caption.copyWith(
            color: isActive ? activeColor : TossColors.textSecondary,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}

/// Receiving item row - table format
class _ReceivingItemRow extends ConsumerWidget {
  final SessionReviewItem item;
  final SessionReviewParams params;

  const _ReceivingItemRow({
    required this.item,
    required this.params,
  });

  void _showDetailBottomSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _ReceivingItemDetailBottomSheet(
        item: item,
        params: params,
      ),
    );
  }

  void _showEditDialog(BuildContext context, WidgetRef ref, SessionReviewState state) {
    final currentQuantity = state.getEffectiveQuantity(
      item.productId,
      item.totalQuantity,
    );

    showDialog<void>(
      context: context,
      builder: (dialogContext) => _EditReceivingQuantityDialog(
        item: item,
        currentQuantity: currentQuantity,
        onSave: (newQuantity) {
          ref.read(sessionReviewProvider(params).notifier).updateQuantity(
                item.productId,
                newQuantity,
              );
          Navigator.pop(dialogContext);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(sessionReviewProvider(params));
    final isEdited = state.isEdited(item.productId);
    final effectiveQuantity = state.getEffectiveQuantity(
      item.productId,
      item.totalQuantity,
    );

    // Calculate status colors using effective quantities
    final shipped = item.previousStock;
    final received = effectiveQuantity;
    final rejected = item.totalRejected;
    final accepted = received - rejected;

    // Determine row status color
    Color? receivedColor;
    Color? acceptedColor;

    if (accepted > shipped) {
      // Over received - blue
      receivedColor = TossColors.primary;
      acceptedColor = TossColors.primary;
    } else if (accepted < shipped && rejected == 0) {
      // Under received - red
      receivedColor = TossColors.loss;
      acceptedColor = TossColors.loss;
    } else if (accepted == shipped && rejected == 0) {
      // Fully matched - green
      acceptedColor = TossColors.success;
    }

    return InkWell(
      onTap: () => _showDetailBottomSheet(context, ref),
      child: Container(
      color: TossColors.white,
      padding: const EdgeInsets.symmetric(
        horizontal: TossSpacing.space4,
        vertical: TossSpacing.space4,
      ),
      child: Row(
        children: [
          // Product info (with image)
          Expanded(
            flex: 2,
            child: Row(
              children: [
                // Product image
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: TossColors.gray100,
                    borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                  ),
                  child: item.imageUrl != null && item.imageUrl!.isNotEmpty
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                          child: Image.network(
                            item.imageUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(
                                Icons.inventory_2_outlined,
                                color: TossColors.textTertiary,
                                size: 20,
                              );
                            },
                          ),
                        )
                      : const Icon(
                          Icons.inventory_2_outlined,
                          color: TossColors.textTertiary,
                          size: 20,
                        ),
                ),
                const SizedBox(width: TossSpacing.space3),
                // Product name and SKU
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        item.productName,
                        style: TossTextStyles.bodyMedium.copyWith(
                          color: TossColors.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (item.sku != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          item.sku!,
                          style: TossTextStyles.caption.copyWith(
                            color: TossColors.textTertiary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Number columns - match header layout
          _buildDataCell('$shipped', TossColors.textSecondary, false),
          // Received column - show edited state
          SizedBox(
            width: 52,
            child: Text(
              '$received',
              style: TextStyle(
                fontSize: 14,
                color: isEdited
                    ? TossColors.primary
                    : (receivedColor ?? TossColors.textPrimary),
                fontWeight: (isEdited || receivedColor != null)
                    ? FontWeight.w600
                    : FontWeight.normal,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          _buildDataCell('$accepted', acceptedColor ?? TossColors.textPrimary, acceptedColor != null),
          _buildDataCell('$rejected', rejected > 0 ? TossColors.loss : TossColors.textSecondary, rejected > 0),
          // Edit button
          GestureDetector(
            onTap: () => _showEditDialog(context, ref, state),
            child: Container(
              width: 32,
              height: 32,
              margin: const EdgeInsets.only(left: 8),
              decoration: BoxDecoration(
                color: isEdited
                    ? TossColors.primary.withValues(alpha: 0.1)
                    : TossColors.gray100,
                borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                border: Border.all(
                  color: isEdited ? TossColors.primary : TossColors.gray300,
                  width: 1,
                ),
              ),
              child: Icon(
                Icons.edit,
                size: 14,
                color: isEdited ? TossColors.primary : TossColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
      ),
    );
  }

  Widget _buildDataCell(String text, Color color, bool isBold) {
    return SizedBox(
      width: 52,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 14,
          color: color,
          fontWeight: isBold ? FontWeight.w600 : FontWeight.normal,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

/// Error view
class _ErrorView extends StatelessWidget {
  final String error;
  final VoidCallback onRetry;

  const _ErrorView({
    required this.error,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
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
              'Failed to load items',
              style: TossTextStyles.h4.copyWith(
                color: TossColors.textPrimary,
              ),
            ),
            const SizedBox(height: TossSpacing.space2),
            Text(
              error,
              style: TossTextStyles.bodySmall.copyWith(
                color: TossColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: TossSpacing.space4),
            TextButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}

/// Empty view
class _EmptyView extends StatelessWidget {
  const _EmptyView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(TossSpacing.space6),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.inbox_outlined,
              size: 64,
              color: TossColors.textTertiary,
            ),
            const SizedBox(height: TossSpacing.space4),
            Text(
              'No items received yet',
              style: TossTextStyles.h4.copyWith(
                color: TossColors.textPrimary,
              ),
            ),
            const SizedBox(height: TossSpacing.space2),
            Text(
              'No one has added items to this session yet',
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
}

/// Submit confirmation dialog with is_final option
class _SubmitConfirmDialog extends StatefulWidget {
  final void Function(bool isFinal) onSubmit;

  const _SubmitConfirmDialog({
    required this.onSubmit,
  });

  @override
  State<_SubmitConfirmDialog> createState() => _SubmitConfirmDialogState();
}

class _SubmitConfirmDialogState extends State<_SubmitConfirmDialog> {
  bool _isFinal = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Submit Receiving Session?'),
      contentPadding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Are you sure you want to submit this receiving session? '
            'This action cannot be undone.',
            style: TossTextStyles.body.copyWith(
              color: TossColors.textSecondary,
            ),
          ),
          const SizedBox(height: TossSpacing.space4),
          Container(
            decoration: BoxDecoration(
              color: TossColors.gray50,
              borderRadius: BorderRadius.circular(TossBorderRadius.md),
              border: Border.all(
                color: _isFinal ? TossColors.success : TossColors.gray200,
                width: _isFinal ? 1.5 : 1,
              ),
            ),
            child: InkWell(
              onTap: () {
                setState(() {
                  _isFinal = !_isFinal;
                });
              },
              borderRadius: BorderRadius.circular(TossBorderRadius.md),
              child: Padding(
                padding: const EdgeInsets.all(TossSpacing.space3),
                child: Row(
                  children: [
                    SizedBox(
                      width: 24,
                      height: 24,
                      child: Checkbox(
                        value: _isFinal,
                        onChanged: (value) {
                          setState(() {
                            _isFinal = value ?? false;
                          });
                        },
                        activeColor: TossColors.success,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                    const SizedBox(width: TossSpacing.space2),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'No more deliveries expected',
                            style: TossTextStyles.bodyMedium.copyWith(
                              fontWeight: FontWeight.w500,
                              color: TossColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Check this only when this is the final delivery for this shipment',
                            style: TossTextStyles.caption.copyWith(
                              color: TossColors.textTertiary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      actionsPadding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      actions: [
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(TossBorderRadius.md),
                  ),
                ),
                child: const Text('Cancel'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: () => widget.onSubmit(_isFinal),
                style: ElevatedButton.styleFrom(
                  backgroundColor: TossColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(TossBorderRadius.md),
                  ),
                ),
                child: const Text('Submit'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// Edit quantity dialog for receiving review (manager override)
class _EditReceivingQuantityDialog extends StatefulWidget {
  final SessionReviewItem item;
  final int currentQuantity;
  final void Function(int) onSave;

  const _EditReceivingQuantityDialog({
    required this.item,
    required this.currentQuantity,
    required this.onSave,
  });

  @override
  State<_EditReceivingQuantityDialog> createState() =>
      _EditReceivingQuantityDialogState();
}

class _EditReceivingQuantityDialogState
    extends State<_EditReceivingQuantityDialog> {
  late TextEditingController _controller;
  late int _quantity;

  @override
  void initState() {
    super.initState();
    _quantity = widget.currentQuantity;
    _controller = TextEditingController(text: _quantity.toString());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _increment() {
    setState(() {
      _quantity++;
      _controller.text = _quantity.toString();
    });
  }

  void _decrement() {
    if (_quantity > 0) {
      setState(() {
        _quantity--;
        _controller.text = _quantity.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isChanged = _quantity != widget.item.totalQuantity;
    final shipped = widget.item.previousStock;
    final newAccepted = _quantity - widget.item.totalRejected;

    return AlertDialog(
      title: Text(
        'Edit Received Count',
        style: TossTextStyles.h4.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product info
          Text(
            widget.item.productName,
            style: TossTextStyles.bodyMedium.copyWith(
              color: TossColors.textPrimary,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          if (widget.item.sku != null) ...[
            const SizedBox(height: 4),
            Text(
              widget.item.sku!,
              style: TossTextStyles.caption.copyWith(
                color: TossColors.textTertiary,
              ),
            ),
          ],
          const SizedBox(height: TossSpacing.space4),

          // Shipped info
          Container(
            padding: const EdgeInsets.all(TossSpacing.space3),
            decoration: BoxDecoration(
              color: TossColors.gray50,
              borderRadius: BorderRadius.circular(TossBorderRadius.md),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Shipped',
                      style: TossTextStyles.caption.copyWith(
                        color: TossColors.textSecondary,
                      ),
                    ),
                    Text(
                      '$shipped',
                      style: TossTextStyles.bodyMedium.copyWith(
                        color: TossColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Original Received',
                      style: TossTextStyles.caption.copyWith(
                        color: TossColors.textSecondary,
                      ),
                    ),
                    Text(
                      '${widget.item.totalQuantity}',
                      style: TossTextStyles.bodyMedium.copyWith(
                        color: TossColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: TossSpacing.space4),

          // Quantity editor
          Text(
            'New Received Count',
            style: TossTextStyles.caption.copyWith(
              color: TossColors.textSecondary,
            ),
          ),
          const SizedBox(height: TossSpacing.space2),
          Row(
            children: [
              // Decrement button
              IconButton(
                onPressed: _quantity > 0 ? _decrement : null,
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: TossColors.gray100,
                    borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                  ),
                  child: const Icon(Icons.remove, size: 20),
                ),
              ),

              // Text field
              Expanded(
                child: TextField(
                  controller: _controller,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  style: TossTextStyles.h3.copyWith(
                    fontWeight: FontWeight.w600,
                    color:
                        isChanged ? TossColors.primary : TossColors.textPrimary,
                  ),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: TossSpacing.space3,
                      vertical: TossSpacing.space2,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(TossBorderRadius.md),
                      borderSide: BorderSide(
                        color:
                            isChanged ? TossColors.primary : TossColors.gray200,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(TossBorderRadius.md),
                      borderSide: BorderSide(
                        color:
                            isChanged ? TossColors.primary : TossColors.gray200,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(TossBorderRadius.md),
                      borderSide: const BorderSide(
                        color: TossColors.primary,
                        width: 2,
                      ),
                    ),
                  ),
                  onChanged: (value) {
                    final parsed = int.tryParse(value);
                    if (parsed != null && parsed >= 0) {
                      setState(() {
                        _quantity = parsed;
                      });
                    }
                  },
                ),
              ),

              // Increment button
              IconButton(
                onPressed: _increment,
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: TossColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                  ),
                  child:
                      const Icon(Icons.add, size: 20, color: TossColors.primary),
                ),
              ),
            ],
          ),

          // Change indicator
          if (isChanged) ...[
            const SizedBox(height: TossSpacing.space3),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: TossSpacing.space3,
                vertical: TossSpacing.space2,
              ),
              decoration: BoxDecoration(
                color: TossColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(TossBorderRadius.md),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.info_outline,
                        size: 16,
                        color: TossColors.primary,
                      ),
                      const SizedBox(width: TossSpacing.space2),
                      Expanded(
                        child: Text(
                          'Received: ${widget.item.totalQuantity} → $_quantity',
                          style: TossTextStyles.caption.copyWith(
                            color: TossColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Accepted will be: $newAccepted (Shipped: $shipped)',
                    style: TossTextStyles.caption.copyWith(
                      color: newAccepted > shipped
                          ? TossColors.primary
                          : (newAccepted < shipped
                              ? TossColors.loss
                              : TossColors.success),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
      actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      actions: [
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(TossBorderRadius.md),
                  ),
                ),
                child: const Text('Cancel'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: () => widget.onSave(_quantity),
                style: ElevatedButton.styleFrom(
                  backgroundColor: TossColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(TossBorderRadius.md),
                  ),
                ),
                child: const Text('Save'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// Receiving item detail bottom sheet - shows scanned by users info
class _ReceivingItemDetailBottomSheet extends ConsumerWidget {
  final SessionReviewItem item;
  final SessionReviewParams params;

  const _ReceivingItemDetailBottomSheet({
    required this.item,
    required this.params,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(sessionReviewProvider(params));
    final isEdited = state.isEdited(item.productId);
    final effectiveQuantity = state.getEffectiveQuantity(
      item.productId,
      item.totalQuantity,
    );

    final shipped = item.previousStock;
    final received = effectiveQuantity;
    final rejected = item.totalRejected;
    final accepted = received - rejected;

    // Determine status
    String status;
    Color statusColor;
    if (accepted > shipped) {
      status = 'Over Received';
      statusColor = TossColors.primary;
    } else if (accepted < shipped && rejected == 0) {
      status = 'Under Received';
      statusColor = TossColors.loss;
    } else if (rejected > 0) {
      status = 'Partially Rejected';
      statusColor = TossColors.warning;
    } else {
      status = 'Fully Matched';
      statusColor = TossColors.success;
    }

    return Container(
      decoration: const BoxDecoration(
        color: TossColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.3,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) {
          return Column(
            children: [
              // Drag handle
              Container(
                margin: const EdgeInsets.only(top: 12, bottom: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: TossColors.gray300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // Header with product info
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: TossSpacing.space4,
                  vertical: TossSpacing.space2,
                ),
                child: Row(
                  children: [
                    // Product Image
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: TossColors.gray100,
                        borderRadius: BorderRadius.circular(TossBorderRadius.md),
                      ),
                      child: item.imageUrl != null && item.imageUrl!.isNotEmpty
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(TossBorderRadius.md),
                              child: Image.network(
                                item.imageUrl!,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Icon(
                                    Icons.inventory_2_outlined,
                                    color: TossColors.textTertiary,
                                    size: 28,
                                  );
                                },
                              ),
                            )
                          : const Icon(
                              Icons.inventory_2_outlined,
                              color: TossColors.textTertiary,
                              size: 28,
                            ),
                    ),
                    const SizedBox(width: TossSpacing.space3),

                    // Product Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.productName,
                            style: TossTextStyles.h4.copyWith(
                              fontWeight: FontWeight.w600,
                              color: TossColors.textPrimary,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (item.sku != null) ...[
                            const SizedBox(height: 4),
                            Text(
                              item.sku!,
                              style: TossTextStyles.caption.copyWith(
                                color: TossColors.textTertiary,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),

                    // Close button
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close, color: TossColors.textSecondary),
                    ),
                  ],
                ),
              ),

              const Divider(height: 1, color: TossColors.gray100),

              // Edited indicator banner
              if (isEdited)
                Container(
                  margin: const EdgeInsets.fromLTRB(
                    TossSpacing.space4,
                    TossSpacing.space3,
                    TossSpacing.space4,
                    0,
                  ),
                  padding: const EdgeInsets.all(TossSpacing.space3),
                  decoration: BoxDecoration(
                    color: TossColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(TossBorderRadius.md),
                    border: Border.all(color: TossColors.primary),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.edit,
                        size: 16,
                        color: TossColors.primary,
                      ),
                      const SizedBox(width: TossSpacing.space2),
                      Expanded(
                        child: Text(
                          'Manager edited: ${item.totalQuantity} → $effectiveQuantity',
                          style: TossTextStyles.caption.copyWith(
                            color: TossColors.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              // Status Badge
              Container(
                margin: const EdgeInsets.all(TossSpacing.space4),
                padding: const EdgeInsets.symmetric(
                  horizontal: TossSpacing.space3,
                  vertical: TossSpacing.space2,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(TossBorderRadius.full),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      status,
                      style: TossTextStyles.bodyMedium.copyWith(
                        color: statusColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (isEdited) ...[
                      const SizedBox(width: TossSpacing.space2),
                      Icon(
                        Icons.edit,
                        size: 14,
                        color: statusColor,
                      ),
                    ],
                  ],
                ),
              ),

              // Receiving Summary Cards
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space4),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildSummaryCard(
                        'Shipped',
                        '$shipped',
                        TossColors.textSecondary,
                        Icons.local_shipping_outlined,
                      ),
                    ),
                    const SizedBox(width: TossSpacing.space2),
                    Expanded(
                      child: _buildSummaryCard(
                        'Received',
                        '$received',
                        TossColors.primary,
                        Icons.download_outlined,
                      ),
                    ),
                    const SizedBox(width: TossSpacing.space2),
                    Expanded(
                      child: _buildSummaryCard(
                        'Accepted',
                        '$accepted',
                        TossColors.success,
                        Icons.check_circle_outline,
                      ),
                    ),
                    const SizedBox(width: TossSpacing.space2),
                    Expanded(
                      child: _buildSummaryCard(
                        'Rejected',
                        '$rejected',
                        TossColors.loss,
                        Icons.cancel_outlined,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: TossSpacing.space4),

              // Scanned By Section Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space4),
                child: Row(
                  children: [
                    const Icon(Icons.people_outline, size: 20, color: TossColors.textSecondary),
                    const SizedBox(width: TossSpacing.space2),
                    Text(
                      'Scanned By (${item.scannedBy.length} users)',
                      style: TossTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.w600,
                        color: TossColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: TossSpacing.space2),

              // Scanned By List
              Expanded(
                child: item.scannedBy.isEmpty
                    ? Center(
                        child: Text(
                          'No scan records available',
                          style: TossTextStyles.body.copyWith(
                            color: TossColors.textTertiary,
                          ),
                        ),
                      )
                    : ListView.builder(
                        controller: scrollController,
                        padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space4),
                        itemCount: item.scannedBy.length,
                        itemBuilder: (context, index) {
                          final user = item.scannedBy[index];
                          return _buildUserRow(user);
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSummaryCard(String label, String value, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(TossSpacing.space2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
      ),
      child: Column(
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(height: 4),
          Text(
            value,
            style: TossTextStyles.bodyMedium.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TossTextStyles.small.copyWith(
              color: color,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildUserRow(ScannedByUser user) {
    return Container(
      margin: const EdgeInsets.only(bottom: TossSpacing.space2),
      padding: const EdgeInsets.all(TossSpacing.space3),
      decoration: BoxDecoration(
        color: TossColors.white,
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
        border: Border.all(color: TossColors.gray100),
      ),
      child: Row(
        children: [
          // User Avatar
          CircleAvatar(
            radius: 20,
            backgroundColor: TossColors.primary.withValues(alpha: 0.1),
            child: Text(
              user.userName.isNotEmpty ? user.userName[0].toUpperCase() : '?',
              style: TossTextStyles.bodyMedium.copyWith(
                color: TossColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: TossSpacing.space3),

          // User Name
          Expanded(
            child: Text(
              user.userName,
              style: TossTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w500,
                color: TossColors.textPrimary,
              ),
            ),
          ),

          // Quantity & Rejected
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.add_box_outlined, size: 16, color: TossColors.success),
                  const SizedBox(width: 4),
                  Text(
                    '${user.quantity}',
                    style: TossTextStyles.bodyMedium.copyWith(
                      color: TossColors.success,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              if (user.quantityRejected > 0) ...[
                const SizedBox(height: 4),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.cancel_outlined, size: 16, color: TossColors.loss),
                    const SizedBox(width: 4),
                    Text(
                      '${user.quantityRejected}',
                      style: TossTextStyles.bodyMedium.copyWith(
                        color: TossColors.loss,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
