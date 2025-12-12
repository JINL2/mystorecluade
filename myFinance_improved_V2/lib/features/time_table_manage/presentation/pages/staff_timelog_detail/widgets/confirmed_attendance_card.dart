import 'package:flutter/material.dart';

import '../../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../../shared/themes/toss_colors.dart';
import '../../../../../../shared/themes/toss_spacing.dart';
import '../../../../../../shared/themes/toss_text_styles.dart';

/// Confirmed attendance card with expandable content and edit capability
class ConfirmedAttendanceCard extends StatelessWidget {
  final bool isExpanded;
  final VoidCallback onToggle;
  final bool isFullyConfirmed;
  final String confirmedCheckIn;
  final String confirmedCheckOut;
  final bool checkInNeedsConfirm;
  final bool checkOutNeedsConfirm;
  final bool isCheckInConfirmed;
  final bool isCheckOutConfirmed;
  final VoidCallback onEditCheckIn;
  final VoidCallback onEditCheckOut;
  /// When true, neither "Confirmed" nor "Need confirm" status is shown
  /// (shift is still in progress)
  final bool isShiftInProgress;

  const ConfirmedAttendanceCard({
    super.key,
    required this.isExpanded,
    required this.onToggle,
    required this.isFullyConfirmed,
    required this.confirmedCheckIn,
    required this.confirmedCheckOut,
    required this.checkInNeedsConfirm,
    required this.checkOutNeedsConfirm,
    required this.isCheckInConfirmed,
    required this.isCheckOutConfirmed,
    required this.onEditCheckIn,
    required this.onEditCheckOut,
    this.isShiftInProgress = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: TossColors.gray100, width: 1),
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          InkWell(
            onTap: onToggle,
            borderRadius: BorderRadius.vertical(
              top: const Radius.circular(TossBorderRadius.lg),
              bottom: isExpanded ? Radius.zero : const Radius.circular(TossBorderRadius.lg),
            ),
            child: Padding(
              padding: const EdgeInsets.all(TossSpacing.space3),
              child: Row(
                children: [
                  Text(
                    'Confirmed attendance',
                    style: TossTextStyles.bodyMedium.copyWith(
                      color: TossColors.gray900,
                    ),
                  ),
                  // Only show status when shift has ended
                  if (!isShiftInProgress) ...[
                    const SizedBox(width: 8),
                    Text(
                      isFullyConfirmed ? '• Confirmed' : '• Need confirm',
                      style: TossTextStyles.caption.copyWith(
                        color: isFullyConfirmed ? TossColors.gray500 : TossColors.error,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                  const Spacer(),
                  Icon(
                    isExpanded ? Icons.expand_less : Icons.expand_more,
                    color: TossColors.gray600,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),

          // Content
          if (isExpanded) ...[
            Container(
              height: 1,
              color: TossColors.gray100,
            ),
            Padding(
              padding: const EdgeInsets.all(TossSpacing.space3),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _EditableTimeRow(
                    label: 'Confirmed check-in',
                    value: confirmedCheckIn,
                    needsConfirm: checkInNeedsConfirm,
                    isConfirmed: isCheckInConfirmed,
                    onEdit: onEditCheckIn,
                  ),
                  const SizedBox(height: 12),
                  _EditableTimeRow(
                    label: 'Confirmed check-out',
                    value: confirmedCheckOut,
                    needsConfirm: checkOutNeedsConfirm,
                    isConfirmed: isCheckOutConfirmed,
                    onEdit: onEditCheckOut,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'These times are used for salary calculations.',
                    style: TossTextStyles.caption.copyWith(
                      color: TossColors.gray500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Editable time row with colored text and edit button
/// Tap area includes both time value and edit icon for better UX
class _EditableTimeRow extends StatelessWidget {
  final String label;
  final String value;
  final bool needsConfirm;
  final bool isConfirmed;
  final VoidCallback onEdit;

  const _EditableTimeRow({
    required this.label,
    required this.value,
    required this.needsConfirm,
    required this.isConfirmed,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    // Determine color: red if needs confirm, blue if confirmed, black otherwise
    Color timeColor;
    if (needsConfirm) {
      timeColor = TossColors.error;
    } else if (isConfirmed) {
      timeColor = TossColors.primary;
    } else {
      timeColor = TossColors.gray900;
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TossTextStyles.bodyLarge.copyWith(
            color: TossColors.gray600,
          ),
        ),
        // Expanded tap area: includes time value and edit icon
        InkWell(
          onTap: onEdit,
          borderRadius: BorderRadius.circular(TossBorderRadius.md),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: TossSpacing.space2,
              vertical: TossSpacing.space1,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      value,
                      style: TossTextStyles.bodyLarge.copyWith(
                        color: timeColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (isConfirmed) ...[
                      const SizedBox(height: 2),
                      Text(
                        'Confirmed',
                        style: TossTextStyles.caption.copyWith(
                          color: TossColors.gray500,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(width: 8),
                const Padding(
                  padding: EdgeInsets.all(4),
                  child: Icon(
                    Icons.edit_outlined,
                    size: 16,
                    color: TossColors.gray600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
