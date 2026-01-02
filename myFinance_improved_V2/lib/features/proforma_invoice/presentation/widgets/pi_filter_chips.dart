import 'package:flutter/material.dart';

import '../../../../shared/themes/toss_border_radius.dart';
import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_spacing.dart';
import '../../../../shared/themes/toss_text_styles.dart';
import '../../domain/entities/proforma_invoice.dart';

class PIFilterChips extends StatelessWidget {
  final List<PIStatus>? selectedStatuses;
  final ValueChanged<List<PIStatus>?> onChanged;

  const PIFilterChips({
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
            label: 'Draft',
            isSelected: selectedStatuses?.contains(PIStatus.draft) ?? false,
            onTap: () => _toggleStatus(PIStatus.draft),
          ),
          const SizedBox(width: TossSpacing.space2),
          _FilterChip(
            label: 'Sent',
            isSelected: selectedStatuses?.contains(PIStatus.sent) ?? false,
            onTap: () => _toggleStatus(PIStatus.sent),
          ),
          const SizedBox(width: TossSpacing.space2),
          _FilterChip(
            label: 'Accepted',
            isSelected: selectedStatuses?.contains(PIStatus.accepted) ?? false,
            onTap: () => _toggleStatus(PIStatus.accepted),
          ),
          const SizedBox(width: TossSpacing.space2),
          _FilterChip(
            label: 'Rejected',
            isSelected: selectedStatuses?.contains(PIStatus.rejected) ?? false,
            onTap: () => _toggleStatus(PIStatus.rejected),
          ),
          const SizedBox(width: TossSpacing.space2),
          _FilterChip(
            label: 'Converted',
            isSelected: selectedStatuses?.contains(PIStatus.converted) ?? false,
            onTap: () => _toggleStatus(PIStatus.converted),
          ),
        ],
      ),
    );
  }

  void _toggleStatus(PIStatus status) {
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
