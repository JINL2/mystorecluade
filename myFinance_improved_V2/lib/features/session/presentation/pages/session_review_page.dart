import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/themes/toss_border_radius.dart';
import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_spacing.dart';
import '../../../../shared/themes/toss_text_styles.dart';
import '../../../../shared/widgets/common/toss_app_bar_1.dart';
import '../../../../shared/widgets/common/toss_success_error_dialog.dart';
import '../providers/session_review_provider.dart';
import '../providers/states/session_review_state.dart';

/// Session review page - Review counted items before final submission
class SessionReviewPage extends ConsumerStatefulWidget {
  final String sessionId;
  final String sessionType;
  final String? sessionName;

  const SessionReviewPage({
    super.key,
    required this.sessionId,
    required this.sessionType,
    this.sessionName,
  });

  @override
  ConsumerState<SessionReviewPage> createState() => _SessionReviewPageState();
}

class _SessionReviewPageState extends ConsumerState<SessionReviewPage> {
  SessionReviewParams get _params => (
        sessionId: widget.sessionId,
        sessionType: widget.sessionType,
        sessionName: widget.sessionName,
      );

  bool get _isCounting => widget.sessionType == 'counting';

  Color get _typeColor =>
      _isCounting ? TossColors.primary : TossColors.success;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(sessionReviewProvider(_params));

    return Scaffold(
      appBar: TossAppBar1(
        title: widget.sessionName ?? 'Review Items',
        secondaryActionIcon: Icons.refresh,
        onSecondaryAction: () {
          ref.read(sessionReviewProvider(_params).notifier).refresh();
        },
      ),
      body: _buildBody(state),
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
      return _EmptyView(sessionType: widget.sessionType);
    }

    return Column(
      children: [
        // Summary Header
        if (state.summary != null) _buildSummaryHeader(state.summary!),

        // Items List
        Expanded(
          child: RefreshIndicator(
            onRefresh: () async {
              await ref.read(sessionReviewProvider(_params).notifier).refresh();
            },
            child: ListView.separated(
              padding: EdgeInsets.zero,
              itemCount: state.items.length,
              separatorBuilder: (context, index) => const Divider(
                height: 1,
                thickness: 1,
                color: TossColors.gray100,
              ),
              itemBuilder: (context, index) {
                final item = state.items[index];
                return _ReviewItemCard(
                  item: item,
                  typeColor: _typeColor,
                );
              },
            ),
          ),
        ),

        // Bottom Action Button
        _buildBottomButton(state),
      ],
    );
  }

  Widget _buildSummaryHeader(SessionReviewSummary summary) {
    return Container(
      padding: const EdgeInsets.all(TossSpacing.space4),
      color: _typeColor.withValues(alpha: 0.05),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _SummaryItem(
            label: 'Products',
            value: '${summary.totalProducts}',
            icon: Icons.inventory_2_outlined,
            color: _typeColor,
          ),
          _SummaryItem(
            label: 'Total Count',
            value: '${summary.totalQuantity}',
            icon: Icons.add_circle_outline,
            color: TossColors.primary,
          ),
          _SummaryItem(
            label: 'Rejected',
            value: '${summary.totalRejected}',
            icon: Icons.remove_circle_outline,
            color: TossColors.error,
          ),
        ],
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
              backgroundColor: _typeColor,
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
                    'Confirm & Finalize',
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
      builder: (dialogContext) => AlertDialog(
        title: const Text('Submit Session?'),
        content: Text(
          'Are you sure you want to submit this ${_isCounting ? 'stock count' : 'receiving'} session? '
          'This action cannot be undone.',
        ),
        actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        actions: [
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(dialogContext),
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
                  onPressed: () {
                    Navigator.pop(dialogContext);
                    _executeSubmit();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _typeColor,
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
      ),
    );
  }

  Future<void> _executeSubmit() async {
    final result = await ref
        .read(sessionReviewProvider(_params).notifier)
        .submitSession(isFinal: true);

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

/// Summary item widget
class _SummaryItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _SummaryItem({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: TossSpacing.space1),
        Text(
          value,
          style: TossTextStyles.h3.copyWith(
            fontWeight: FontWeight.bold,
            color: TossColors.textPrimary,
          ),
        ),
        Text(
          label,
          style: TossTextStyles.caption.copyWith(
            color: TossColors.textSecondary,
          ),
        ),
      ],
    );
  }
}

/// Review item card - simplified style matching detail page
class _ReviewItemCard extends StatelessWidget {
  final SessionReviewItem item;
  final Color typeColor;

  const _ReviewItemCard({
    required this.item,
    required this.typeColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: TossColors.white,
      padding: const EdgeInsets.symmetric(
        horizontal: TossSpacing.space4,
        vertical: TossSpacing.space3,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.productName,
                  style: TossTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w500,
                    color: TossColors.textPrimary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                if (item.sku != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    item.sku!,
                    style: TossTextStyles.caption.copyWith(
                      color: TossColors.textTertiary,
                    ),
                  ),
                ],
                // User breakdown (compact)
                if (item.scannedBy.isNotEmpty) ...[
                  const SizedBox(height: TossSpacing.space2),
                  ...item.scannedBy.map((user) => _UserCountRow(user: user)),
                ],
              ],
            ),
          ),

          // Quantity display
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${item.totalQuantity}',
                style: TossTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                  color: typeColor,
                ),
              ),
              if (item.totalRejected > 0)
                Text(
                  '(-${item.totalRejected})',
                  style: TossTextStyles.caption.copyWith(
                    color: TossColors.error,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

/// User count row - compact style
class _UserCountRow extends StatelessWidget {
  final ScannedByUser user;

  const _UserCountRow({required this.user});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 2),
      child: Row(
        children: [
          Text(
            '• ${user.userName}',
            style: TossTextStyles.caption.copyWith(
              color: TossColors.textSecondary,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            '${user.quantity}',
            style: TossTextStyles.caption.copyWith(
              fontWeight: FontWeight.w600,
              color: TossColors.textPrimary,
            ),
          ),
          if (user.quantityRejected > 0)
            Text(
              ' (-${user.quantityRejected})',
              style: TossTextStyles.caption.copyWith(
                color: TossColors.error,
              ),
            ),
        ],
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
  final String sessionType;

  const _EmptyView({required this.sessionType});

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
              'No items counted yet',
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
