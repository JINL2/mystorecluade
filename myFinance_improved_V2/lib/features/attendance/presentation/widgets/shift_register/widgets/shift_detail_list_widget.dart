import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../../shared/themes/toss_colors.dart';
import '../../../../../../shared/themes/toss_spacing.dart';
import '../../../../../../shared/themes/toss_text_styles.dart';
import '../../../../../../shared/widgets/common/toss_loading_view.dart';
import '../../../../domain/entities/shift_metadata.dart';
import 'shift_card_widget.dart';

/// Widget showing list of available shifts for selected date
/// ✅ Clean Architecture: Uses ShiftMetadata Entity instead of dynamic
class ShiftDetailListWidget extends ConsumerWidget {
  final DateTime selectedDate;
  final List<ShiftMetadata>? shiftMetadata;
  final List<dynamic>? monthlyShiftStatus;
  final String? selectedShift;
  final String? selectionMode;
  final bool isLoadingMetadata;
  final bool isLoadingShiftStatus;
  final void Function(String shiftId, bool userHasRegistered) onShiftClick;

  const ShiftDetailListWidget({
    super.key,
    required this.selectedDate,
    required this.shiftMetadata,
    required this.monthlyShiftStatus,
    required this.selectedShift,
    required this.selectionMode,
    required this.isLoadingMetadata,
    required this.isLoadingShiftStatus,
    required this.onShiftClick,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeShifts = _getActiveShifts();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: TossSpacing.space5),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isLoadingMetadata || isLoadingShiftStatus)
                _buildLoadingState()
              else if (activeShifts.isNotEmpty)
                _buildShiftsList(activeShifts, ref)
              else
                _buildEmptyState(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: TossSpacing.space4),
        child: TossLoadingView(),
      ),
    );
  }

  Widget _buildShiftsList(List<ShiftMetadata> activeShifts, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(),
        const SizedBox(height: TossSpacing.space2),
        // ✅ Clean Architecture: Pass Entity directly to ShiftCardWidget
        ...activeShifts.map((shift) => ShiftCardWidget(
              shiftMetadata: shift,
              selectedDate: selectedDate,
              monthlyShiftStatus: monthlyShiftStatus,
              selectedShift: selectedShift,
              onShiftClick: onShiftClick,
            )),
      ],
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Available Shifts in This Store',
          style: TossTextStyles.bodySmall.copyWith(
            color: TossColors.gray700,
            fontWeight: FontWeight.w600,
          ),
        ),
        if (selectedShift != null) _buildSelectionBadge(),
      ],
    );
  }

  Widget _buildSelectionBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: TossSpacing.space2,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: TossColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.check_circle,
            size: 14,
            color: TossColors.primary,
          ),
          const SizedBox(width: 4),
          Text(
            '1 selected',
            style: TossTextStyles.caption.copyWith(
              color: TossColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
          if (selectionMode != null) ...[
            const SizedBox(width: 4),
            Text(
              '(${selectionMode == 'registered' ? 'Registered' : 'New'})',
              style: TossTextStyles.caption.copyWith(
                color: TossColors.primary,
                fontSize: 10,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(TossSpacing.space3),
      decoration: BoxDecoration(
        color: TossColors.warning.withOpacity(0.1),
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
        border: Border.all(
          color: TossColors.warning.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.info_outline,
            size: 16,
            color: TossColors.warning,
          ),
          const SizedBox(width: TossSpacing.space2),
          Text(
            'No shifts configured for this store',
            style: TossTextStyles.caption.copyWith(
              color: TossColors.warning,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  /// Get active shifts from metadata
  /// ✅ Clean Architecture: Returns Entity list directly
  List<ShiftMetadata> _getActiveShifts() {
    if (shiftMetadata == null || shiftMetadata!.isEmpty) {
      return [];
    }

    return shiftMetadata!.where((shift) => shift.isActive).toList();
  }
}
