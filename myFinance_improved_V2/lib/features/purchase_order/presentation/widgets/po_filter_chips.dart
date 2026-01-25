import 'package:flutter/material.dart';

import '../../../../shared/themes/toss_border_radius.dart';
import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_spacing.dart';
import '../../../../shared/themes/toss_text_styles.dart';
import '../../domain/entities/purchase_order.dart';

class POFilterChips extends StatelessWidget {
  final List<POStatus>? selectedStatuses;
  final ValueChanged<List<POStatus>?> onChanged;

  const POFilterChips({
    super.key,
    this.selectedStatuses,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space4),
      child: Row(
        children: [
          _FilterChip(
            label: 'All',
            isSelected: selectedStatuses == null || selectedStatuses!.isEmpty,
            onTap: () => onChanged(null),
          ),
          const SizedBox(width: TossSpacing.space2),
          _FilterChip(
            label: 'Pending',
            isSelected: selectedStatuses?.contains(POStatus.pending) ?? false,
            onTap: () => _toggleStatus(POStatus.pending),
          ),
          const SizedBox(width: TossSpacing.space2),
          _FilterChip(
            label: 'Process',
            isSelected: selectedStatuses?.contains(POStatus.process) ?? false,
            onTap: () => _toggleStatus(POStatus.process),
          ),
          const SizedBox(width: TossSpacing.space2),
          _FilterChip(
            label: 'Complete',
            isSelected: selectedStatuses?.contains(POStatus.complete) ?? false,
            onTap: () => _toggleStatus(POStatus.complete),
          ),
          const SizedBox(width: TossSpacing.space2),
          _FilterChip(
            label: 'Cancelled',
            isSelected: selectedStatuses?.contains(POStatus.cancelled) ?? false,
            onTap: () => _toggleStatus(POStatus.cancelled),
          ),
        ],
      ),
    );
  }

  void _toggleStatus(POStatus status) {
    final current = selectedStatuses?.toList() ?? [];
    if (current.contains(status)) {
      current.remove(status);
    } else {
      current.add(status);
    }
    onChanged(current.isEmpty ? null : current);
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: TossSpacing.space3,
          vertical: TossSpacing.space2,
        ),
        decoration: BoxDecoration(
          color: isSelected ? TossColors.primary : TossColors.gray100,
          borderRadius: BorderRadius.circular(TossBorderRadius.full),
        ),
        child: Text(
          label,
          style: TossTextStyles.caption.copyWith(
            color: isSelected ? TossColors.white : TossColors.gray700,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
