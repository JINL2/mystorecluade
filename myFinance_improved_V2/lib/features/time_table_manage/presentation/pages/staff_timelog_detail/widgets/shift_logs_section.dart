import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../../shared/themes/toss_colors.dart';
import '../../../../../../shared/themes/toss_spacing.dart';
import '../../../../../../shared/themes/toss_text_styles.dart';
import '../../../../domain/entities/shift_audit_log.dart';
import '../../../providers/state/shift_audit_logs_provider.dart';
import 'shift_log_item.dart';

/// Shift Logs Section Widget
///
/// Displays the audit log history for a shift in an expandable card.
/// Shows who changed what, when, and how.
///
/// Features:
/// - Expandable/collapsible section
/// - Timeline display of all events
/// - Shows count badge in header
/// - Default state: collapsed
class ShiftLogsSection extends ConsumerStatefulWidget {
  final String? shiftRequestId;

  const ShiftLogsSection({
    super.key,
    required this.shiftRequestId,
  });

  @override
  ConsumerState<ShiftLogsSection> createState() => _ShiftLogsSectionState();
}

class _ShiftLogsSectionState extends ConsumerState<ShiftLogsSection> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final logsAsync = ref.watch(shiftAuditLogsProvider(widget.shiftRequestId));

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: TossColors.gray100, width: 1),
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header (always visible)
          _buildHeader(logsAsync),

          // Content (visible when expanded)
          if (_isExpanded) ...[
            Container(
              height: 1,
              color: TossColors.gray100,
            ),
            _buildContent(logsAsync),
          ],
        ],
      ),
    );
  }

  Widget _buildHeader(AsyncValue<List<ShiftAuditLog>> logsAsync) {
    // Get count for badge
    final count = logsAsync.whenOrNull(data: (logs) => logs.length) ?? 0;

    return InkWell(
      onTap: () => setState(() => _isExpanded = !_isExpanded),
      borderRadius: BorderRadius.vertical(
        top: const Radius.circular(TossBorderRadius.lg),
        bottom: _isExpanded ? Radius.zero : const Radius.circular(TossBorderRadius.lg),
      ),
      child: Padding(
        padding: const EdgeInsets.all(TossSpacing.space3),
        child: Row(
          children: [
            Text(
              'Shift Logs',
              style: TossTextStyles.bodyMedium.copyWith(
                color: TossColors.gray900,
              ),
            ),
            const SizedBox(width: 8),
            // Count badge
            if (count > 0)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: TossColors.gray100,
                  borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                ),
                child: Text(
                  '$count',
                  style: TossTextStyles.caption.copyWith(
                    color: TossColors.gray600,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            const Spacer(),
            // Loading indicator or expand icon
            logsAsync.when(
              data: (_) => Icon(
                _isExpanded ? Icons.expand_less : Icons.expand_more,
                color: TossColors.gray600,
                size: 20,
              ),
              loading: () => const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: TossColors.gray400,
                ),
              ),
              error: (_, __) => const Icon(
                Icons.error_outline,
                color: TossColors.error,
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(AsyncValue<List<ShiftAuditLog>> logsAsync) {
    return logsAsync.when(
      data: (logs) {
        if (logs.isEmpty) {
          return Padding(
            padding: const EdgeInsets.all(TossSpacing.space4),
            child: Center(
              child: Text(
                'No logs available',
                style: TossTextStyles.caption.copyWith(
                  color: TossColors.gray500,
                ),
              ),
            ),
          );
        }

        return Padding(
          padding: const EdgeInsets.all(TossSpacing.space3),
          child: Column(
            children: List.generate(logs.length, (index) {
              return ShiftLogItem(
                log: logs[index],
                isLast: index == logs.length - 1,
              );
            }),
          ),
        );
      },
      loading: () => const Padding(
        padding: EdgeInsets.all(TossSpacing.space4),
        child: Center(
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: TossColors.gray400,
          ),
        ),
      ),
      error: (error, _) => Padding(
        padding: const EdgeInsets.all(TossSpacing.space4),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.error_outline,
                color: TossColors.error,
                size: 24,
              ),
              const SizedBox(height: 8),
              Text(
                'Failed to load logs',
                style: TossTextStyles.caption.copyWith(
                  color: TossColors.error,
                ),
              ),
              const SizedBox(height: 4),
              TextButton(
                onPressed: () {
                  ref.invalidate(shiftAuditLogsProvider(widget.shiftRequestId));
                },
                child: Text(
                  'Retry',
                  style: TossTextStyles.caption.copyWith(
                    color: TossColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
